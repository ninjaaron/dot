#!/usr/bin/env python3
import requests
import sys
import inspect

TEMPLATE='''\
pkgbase=('{py_prefix}{name}')
pkgname=('{py_prefix}{name}')
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

if sys.argv[1] == '-np':
    py_prefix = ''
    package = sys.argv[2]
else:
    package = sys.argv[1]
    py_prefix = 'python-'

data = requests.request \
    ('GET', 'https://pypi.python.org/pypi/%s/json/'%package).json()

info = data['info']
info['license'] = info['license'] or 'unknown'

for url in data['urls']:
    if 'source' in url['python_version']:
        info.update(url)

info['py_prefix'] = py_prefix
print(TEMPLATE.format(**info), file=open('PKGBUILD', 'w'))
