#!/usr/bin/env python3
import json
import re
import typing as t
import aiohttp
import compose
import libaaron
from libaaron import aio

# ## Torrent status codes ##
# 0 /* Torrent is stopped */
# 1 /* Queued to check files */
# 2 /* Checking files */
# 3 /* Queued to download */
# 4 /* Downloading */
# 5 /* Queued to seed */
# 6 /* Seeding */

URL = 'http://localhost:9091/transmission/rpc'
HEADER = 'X-Transmission-Session-Id'
decoder = json.JSONDecoder(object_hook=libaaron.DotDict)
IDs = t.Union[t.Sequence[int], int]


class Duplicate(Exception):
    def __init__(self, tor):
        self.tor = tor
        self.args = tor.name,


class NoJson(Exception):
    pass


# base async api
class AsyncSession:
    __slots__ = 'sess', 'hdr', 'url'

    def __init__(self, url: str = URL):
        self.url = url
        self.sess = aiohttp.ClientSession()

    def __repr__(self):
        name = self.__class__.__name__
        if self.url == URL:
            return name + '()'

        return '%s(url=%r)' % (name, self.url)

    async def close(self):
        await self.sess.close()

    async def __aenter__(self):
        return self

    async def __aexit__(self, exc_type, exc_value, traceback):
        await self.sess.close()

    async def get_hdr(self):
        try:
            return self.hdr
        except AttributeError:
            async with self.sess.get(URL) as resp:
                self.hdr = {HEADER: resp.headers[HEADER]}
            return self.hdr

    async def request(
            self,
            method: str,
            arguments: t.Mapping,
            tag: int = None
    ) -> t.Mapping:
        data = dict(method=method, arguments=arguments)
        if tag:
            data['tag'] = tag
        async with self.sess.post(
                URL, json=data, headers=await self.get_hdr()) as resp:
            if resp.status == 409:
                self.hdr = {HEADER: resp.headers[HEADER]}
                return await self.request(method, arguments, tag)
            try:
                return await resp.json(loads=decoder.decode)
            except aiohttp.client_exceptions.ContentTypeError:
                nj = NoJson()
                nj.content = await resp.read()
                raise nj

    async def torrents(
            self,
            method: str,
            arguments: t.Mapping,
            ids: IDs = None,
            *args, **kwargs
    ) -> t.Mapping:
        if arguments is None:
            arguments = {}
        if ids:
            arguments['ids'] = ids
        method = 'torrent-' + method
        return await self.request(method, arguments, *args, **kwargs)

    async def tget(
            self, fields: t.Sequence[str], *args, **kwargs
    ) -> t.List[t.Mapping]:
        if isinstance(fields, str):
            fields = [fields]
        else:
            fields = list(fields)
        fields.append('id')
        arguments = dict(fields=fields)
        data = await self.torrents('get', arguments, *args, **kwargs)
        return data.arguments.torrents

    async def tset(
            self, arguments: t.Mapping, *args, **kwargs
    ) -> t.Mapping:
        return await self.torrents('set', arguments, *args, **kwargs)

    async def tremove(self, ids: IDs, delete=False, *args, **kwargs):
        arguments = {'delete-local-data': delete}
        return await self.torrents('remove', arguments, ids, *args, **kwargs)

    async def tadd(
            self,
            filename,
            paused=False,
            arguments=None,
            *args,
            **kwargs
    ):
        if not arguments:
            arguments = {}
        arguments['filename'] = filename
        arguments['paused'] = paused
        result = await self.torrents('add', arguments, *args, **kwargs)
        try:
            return result.arguments['torrent-added']
        except KeyError as e:
            if 'torrent-duplicate' in result.arguments:
                raise Duplicate(result.arguments['torrent-duplicate'])
            else:
                e.content = result.result.encode()
                raise e


@compose.struct
class Torrent:
    data: dict
    session: AsyncSession

    @classmethod
    def new(cls, id: int, session: AsyncSession):
        return cls({'id': id}, session)

    async def add_attrs(self, *attrs):
        tor, = await self.session.tget(attrs, ids=self.id)
        self.data.update(tor)

    async def update(self):
        await self.add_attrs(*self.data)

    @property
    async def path(self):
        return (await self.get('downloadDir')) + (await self.get('name'))

    def __getattr__(self, attr):
        return self.data[attr]

    __getitem__ = __getattr__

    def __hash__(self):
        return hash(self.id)

    async def get(self, attr):
        try:
            return self.data[attr]
        except KeyError:
            await self.add_attrs(attr)
            return self.data[attr]

    async def set(self, arguments, *args, **kwargs):
        return await self.session.tset(arguments, *args, **kwargs)

    async def remove(self, delete=False):
        return await self.session.tremove(self.id, delete)

    async def wait(self, sleep=1):
        while await self.get('status') != 6:
            await aio.sleep(sleep)
            await self.update()
        return self


class Torrents:
    __slots__ = 'session', 'ts'

    def __init__(self, url=None):
        self.session = AsyncSession(url or URL)
        self.ts = set()

    async def __call__(self, *ids: IDs, fields=None, url=None, update=True):
        if fields is None:
            fields = 'id', 'name', 'downloadDir', 'percentDone', 'status'

        if update:
            self.ts = set(
                Torrent(data, self.session) for data in
                await self.session.tget(fields, ids=ids))

        return self

    async def update(self):
        if not self.ts:
            return

        fields = list(list(self.ts)[0].data.keys())
        ids = [await t.get('id') for t in self]
        return await self(*ids, fields)

    async def by_pattern(self, pattern, fields=None):
        pat = re.compile(pattern, re.IGNORECASE)
        self.ts = set(
            t for t in await self(fields=fields) if pat.search(t.name))
        return self

    async def __aenter__(self):
        return await self(update=False)

    async def __aexit__(self, exc_type, exc_value, traceback):
        await self.close()

    async def close(self):
        await self.session.close()

    def __iter__(self):
        return iter(self.ts)

    async def completed(self, sleep=1, forever=False):
        while forever or self.ts:
            if self.ts:
                await self.update()
                cur = list(self.ts)
                for torrent in cur:
                    if await torrent.get('percentDone') == 1:
                        self.ts.remove(torrent)
                        yield torrent
            await aio.sleep(sleep)

    async def listen(self, port, paused=False):

        async def handler(reader, writer):
            filename = await reader.read(4096)
            filename = filename.decode()
            try:
                tor = await self.add(filename, paused)
                writer.write(
                    str(tor.id).encode() + b'\t' + tor.name.encode() + b'\n')
            except (NoJson, KeyError) as e:
                writer.write(e.content + b'\n')
            await writer.drain()
            writer.close()

        await aio.start_server(handler, 'localhost', port)

    async def add(self, filename, paused=False):
        if not isinstance(filename, Torrent):
            try:
                tor = await self.session.tadd(filename, paused)
                tor = Torrent(tor, self.session)
            except Duplicate as d:
                return Torrent(d.tor, self.session)
        self.ts.add(tor)
        return tor
