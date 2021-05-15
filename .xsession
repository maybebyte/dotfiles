# sourced files
. "${HOME}/.profile"
xrdb "${HOME}/.Xresources"

# daemons
dunst &
sxhkd &
# don't use -grab. it doesn't play nice with slock(1).
unclutter -idle 3 &
# xcompmgr(1) seems to cause horizontal screen tearing on x1c7 with
# mpv(1) and modesetting(4).
#
# with either xcompmgr(1) or modesetting(4) disabled, horizontal screen
# tearing is absent.
xcompmgr -I 0.0125 -O 0.0125 -D 2 -cfC &
xidle &

[ -x "$(command -v dbus-launch)" ] \
  && [ -z "${DBUS_SESSION_BUS_ADDRESS}" ] \
  && eval "$(dbus-launch --sh-syntax --exit-with-x11)"

# look and feel
"${HOME}/.local/bin/wal" -R
sct 3500
xset b off

# laptop adjustments
if [ "$(hostname -s)" = 'lain' ]; then
  xset m 3/1 0
  # trackpad scrolling with middle button
  xinput set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation' 1
  xinput set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Button' 2
  xinput set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Axes' 6 7 4 5
fi

# status bar.
"${HOME}/.local/bin/sysinfo" | "${HOME}/.local/bin/lbar" &

# random manual page for didactic purposes
"${TERMINAL}" -e man "$("${HOME}/.local/bin/randman")" &

exec xmonad
