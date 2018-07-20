#!/usr/bin/env python3
import json
import shlex
import subprocess as sp
import sys
import typing as t
import aiohttp
import compose
import libaaron
from libaaron import aio
URL = 'http://localhost:9091/transmission/rpc'
HEADER = 'X-Transmission-Session-Id'
dct = libaaron.DotDict
decoder = json.JSONDecoder(object_hook=dct)
IDs = t.Union[t.Sequence[int], int]


class Duplicate(Exception):
    def __init__(self, tor):
        self.tor = tor
        self.args = tor.name,


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
            self, method: str, arguments: t.Mapping, tag: int = None
    ) -> t.Mapping:
        data = dict(method=method, arguments=arguments)
        if tag:
            data['tag'] = tag
        async with self.sess.post(
                URL, json=data, headers=await self.get_hdr()) as resp:
            return await resp.json(loads=decoder.decode)

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
        except KeyError:
            if 'torrent-duplicate' in result.arguments:
                raise Duplicate(result.arguments['torrent-duplicate'])
            else:
                raise


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

    def __getattr__(self, attr):
        return self.data[attr]

    __getitem__ = __getattr__

    async def get(self, attr):
        try:
            return self.data[attr]
        except KeyError:
            await self.add_attrs(attr)
            return self.data[attr]

    async def remove(self, delete=False):
        return await self.session.tremove(self.id, delete)


class Torrents:
    __slots__ = 'session', 'queue'

    async def __call__(
            self, *ids: IDs, fields='name', url=None):
        if not hasattr(self, 'session'):
            self.session = AsyncSession(url or URL)
        elif url:
            self.session.close()
            self.session = AsyncSession(url)

        self.queue = [
            Torrent(data, self.session) for data in
            await self.session.tget(fields, ids=ids)]

        return self

    async def __aenter__(self):
        return await self()

    async def __aexit__(self, exc_type, exc_value, traceback):
        await self.close()

    async def close(self):
        await self.session.close()

    def __iter__(self):
        return iter(self.queue)

    async def add(self, filename, paused=False):
        try:
            tor = await self.session.tadd(filename, paused)
            tor = Torrent(tor, self.session)
            self.queue.append(tor)
            return tor
        except Duplicate as d:
            return Torrent(d.tor, self.session)


Torrent.s = Torrents()


async def sftp(
        torrent, host, sleeptime=5, remove=False, delete=False, coro=False):
    await torrent.add_attrs('percentDone', 'downloadDir', 'name')
    while not torrent.percentDone == 1:
        print('%5.1f' % (torrent.percentDone*100), torrent.name)
        await aio.sleep(sleeptime)
        await torrent.update()

    args = [
        'sftp', '-ar',
        host + ':/' + shlex.quote(torrent.downloadDir[1:] + torrent.name),
        '.'
    ]

    if coro:
        with open(torrent.name + '.log', 'wb') as log:
            proc = await aio.proc(*args, stderr=sp.STDOUT, stdout=log)
        ret = await proc.wait()
    else:
        ret = sp.run(args).returncode

    if ret == 0 and (remove or delete):
        await torrent.remove(delete)


async def main():
    async with Torrent.s as ts:
        fs = await ts.session.request(
            'free-space', {'path': '/home/ninjaaron/'})
        print(fs.arguments['size-bytes'] / 1024**3)
        tor = await ts.add(sys.argv[1])
        print(tor.id, tor.name, await tor.get('downloadDir'))
        print(*ts)
        dls = [await aio.spawn(sftp(t, 'sink', 0, delete=True))
               for t in ts]
        for dl in dls:
            await dl
    return 'foo'


if __name__ == '__main__':
    aio.run(main())
