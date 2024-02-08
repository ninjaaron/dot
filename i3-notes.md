don't forget to move or link config files in "KB" to the right
directories.

libinput config files go in /etc/X11/xorg.conf.d/
xkb symbols files go in /usr/share/X11/xkb/symbols

for brightness, install `brightnessctl`

add user to `video` and `input` group.

    # usermod -aG input $USER
    # sudo usermod -aG video $USER

Install vpn-slice with pip (or pipx) for VPN routing.
