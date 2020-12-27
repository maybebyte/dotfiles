# sourced files
. "${HOME}/.profile"
xrdb "${HOME}/.Xresources"

# vars
export LANG=en_US.UTF-8

# daemons
"${HOME}/.local/bin/sysinfo" | "${HOME}/.local/bin/lbar" &
dunst &
sxhkd &
unclutter -idle 3 -grab &
xcompmgr -I 0.0125 -O 0.0125 -D 2 -cfC &
xidle &

if [ -x dbus-launch ] && [ -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
  eval "$(dbus-launch --sh-syntax --exit-with-x11)"
fi

# look and feel
"${HOME}/.local/bin/wal" -R
sct 3500
xset b off

# laptop adjustments
if [ "$(hostname -s)" = "lain" ]; then
  xset m 3/1 0
  # trackpad scrolling with middle button
  xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1
  xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2
  xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5
fi

# random manual page for didactic purposes
xst -e "${HOME}/.local/bin/randman" &

exec xmonad
