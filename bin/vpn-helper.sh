#!/bin/sh

. ~/.hrz-credentials.sh

echo "$PASSWORD" | sudo openconnect \
  "$VPN_SERVER" \
  --user="$USER" \
  --passwd-on-stdin \
  -s "$HOME/.local/bin/vpn-slice $ROUTES"
