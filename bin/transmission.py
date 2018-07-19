import asyncio
import json
import functools
import os
import sys
import aiohttp
import libaaron
import compose
URL = 'http://localhost:9091/transmission/rpc'
HEADER = 'X-Transmission-Session-Id'
dct = libaaron.DotDict
decoder = json.JSONDecoder(object_hook=dct)

# base async api


def run(coro):
    # stole the idea from 3.7
    loop = asyncio.get_event_loop()
    return loop.run_until_complete(coro)


def spawn(coro):
    # also again stole the idea from 3.7
    return asyncio.get_event_loop().create_task(coro)


class AsyncSession:
    __slots__ = 'sess', 'hdr', 'url'

    def __init__(self, url=URL):
        self.url = url
        self.sess = aiohttp.ClientSession()

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

    async def request(self, method, arguments, tag=None):
        data = dict(method=method, arguments=arguments)
        if tag:
            data['tag'] = tag
        async with self.sess.post(
                URL, json=data, headers=await self.get_hdr()) as resp:
            return await resp.json(loads=decoder.decode)

    async def torrents(self, method, arguments, ids=None, *args, **kwargs):
        if arguments is None:
            arguments = {}
        if ids:
            arguments['ids'] = ids
        method = 'torrent-' + method
        return await self.request(method, arguments, *args, **kwargs)

    async def tget(self, fields, *args, **kwargs):
        if isinstance(fields, str):
            fields = [fields]
        else:
            fields = list(fields)
        fields.append('id')
        arguments = dict(fields=fields)
        data = await self.torrents('get', arguments, *args, **kwargs)
        return data.arguments.torrents

    async def tset(self, arguments, *args, **kwargs):
        return await self.torrents('set', arguments, *args, **kwargs)

    async def tremove(self, ids, delete=False, *args, **kwargs):
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
        return result.arguments['torrent-added']


@compose.struct
class Torrent:
    data: dict
    session: AsyncSession

    async def add_attrs(self, *attrs):
        tor, = await self.session.tget(attrs, ids=self.id)
        self.data.update(tor)

    async def update(self):
        await self.add_attrs(self.data)

    async def __getattr__(self, attr):
        try:
            return self.data[attr]
        except KeyError:
            tor, = await self.session.tget(attr, ids=self.id)
            self.data.update(tor)
        return self.data[attr]

    __getitem__ = __getattr__


async def main():
    async with AsyncSession() as session:
        tor = await session.tadd(sys.argv[1])
        print(tor)
        data = await session.tget(['name', 'downloadDir'])
        print(*data, sep='\n')
        for i in data:
            if 'Taylor' in i.name:
                await session.tremove(i.id, delete=True)
                print('removed', i.name)
        print(await session.tget('name'))
    return 'foo'


run(main())


# sychronous hacks. to be avoided.


def get_coro_wrapper(method):
    @functools.wraps(method)
    def wrapper(self, *args, **kwargs):
        return run(method(self.sess, *args, **kwargs))
    return wrapper


class Session:
    def __init__(self, url=URL):
        stderr = sys.stderr
        with open(os.devnull, 'w') as devnull:
            sys.stderr = devnull
            self.sess = AsyncSession(url)
        sys.stderr = stderr

    def __enter__(self):
        return self

    __exit__ = get_coro_wrapper(AsyncSession.__aexit__)


for k, v in AsyncSession.__dict__.items():
    if callable(v) and not k.startswith('__'):
        setattr(Session, k, get_coro_wrapper(v))
