#!/bin/sh
upgradable="$(apt list --upgradable 2> /dev/null | wc -l)"
expr "$upgradable" - 1 | $HOME/bin/i2b > $HOME/.updates
