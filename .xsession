. "${HOME}/.profile"
export LANG=en_US.UTF-8
xrdb "${HOME}/.Xresources"
xidle &
sct 3500
xset b off
sxhkd &
unclutter -idle 3 -grab &
"${HOME}/.local/bin/wal" -R
xcompmgr -I 0.0125 -O 0.0125 -D 2 -cfC &
[ "$(hostname -s)" = "lain" ] && xset m 3/1 0
"${HOME}/.local/bin/sysinfo" | "${HOME}/.local/bin/lbar" &

# trackpad scrolling with middle button
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5

if [ -x dbus-launch ] && [ -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
  eval "$(dbus-launch --sh-syntax --exit-with-x11)"
fi

xst -e "${HOME}/.local/bin/randman" &
exec xmonad
