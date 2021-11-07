#!/usr/bin/env sh

# sourced files
# shellcheck disable=SC1090,SC1091
. "${HOME}/.profile"
xrdb "${HOME}/.Xresources"

# temporary Downloads directory for browser
if TMP_DL="$(mktemp -d)"; then
  rm -rf "${HOME}/Downloads/"*
  ln -sf "${TMP_DL}" "${HOME}/Downloads"

else
  # shellcheck disable=SC2088
  echo 'Unable to create ~/Downloads symlink.' 2>>"${DOTFILES_LOG}" >&2

fi

# environment variables that either:
#
# a) don't make sense to put in ~/.profile
# b) only make sense with a graphical environment
#
# some of these are overrides, and some are variables not specified in
# ~/.profile.
export                                                 \
  BROWSER='firefox'                                    \
  GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0" \
  QT_STYLE_OVERRIDE='Breeze'                           \
  READER='zathura'                                     \
  TERMINAL='xst'

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
xcompmgr &
xidle &

[ -x "$(command -v 'dbus-launch')" ] \
  && [ -z "${DBUS_SESSION_BUS_ADDRESS}" ] \
  && eval "$(dbus-launch --sh-syntax --exit-with-x11)"

# look and feel
"${HOME}/.local/bin/wal" -R
sct 3500
xset b off

# open FileChooser in current working directory instead of recents
gsettings set org.gtk.Settings.FileChooser startup-mode cwd

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
"${HOME}/.local/bin/randman" | xargs -- "${TERMINAL}" -e man &

exec xmonad
