import requests
import libaaron
URL = 'http://localhost:9091/transmission/rpc'
HEADER = 'X-Transmission-Session-Id'
session = requests.session()
initial = session.get(URL)
sessid = initial.headers[HEADER]

nxt = session.post(URL, headers={HEADER: sessid}, json={
    'method': 'torrent-get',
    'arguments': {
        'fields': ['id', 'name']
    }
})
print(nxt.text)
