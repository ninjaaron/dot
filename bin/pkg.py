#!/usr/bin/env python3
import requests
import sys
import inspect

TEMPLATE='''\
pkgbase=('python-{name}')
pkgname=('python-{name}')
_module='{name}'
pkgver='{version}'
pkgrel=1
pkgdesc="{summary}"
url="{home_page}"
depends=('python')
makedepends=('python-pip' 'python-wheel')
license=('{license}')
arch=('any')
source=("{url}")
md5sums=('{md5_digest}')

build() {{
    cd "${{srcdir}}/{name}-{version}"
    pip3 wheel .
}}

package() {{
    depends+=()
    cd "${{srcdir}}/{name}-{version}"
    pip3 install --ignore-installed --root="${{pkgdir}}" "{name}"*.whl
}}'''

package = sys.argv[1]
data = requests.request \
    ('GET', 'https://pypi.python.org/pypi/%s/json/'%package).json()

info = data['info']
info['license'] = info['license'] or 'unknown'

for url in data['urls']:
    if 'source' in url['python_version']:
        info.update(url)
from pprint import pprint
print(TEMPLATE.format(**info), file=open('PKGBUILD', 'w'))
