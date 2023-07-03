#!/bin/sh
# shellcheck disable=SC1090,SC1091

# sourced files
. "${HOME}/.profile"
xrdb "${HOME}/.Xresources"

# Load fonts so that tools incompatible with Xft can access them.
# This includes things like xfontsel(1), xlock(1), etc.
if [ -d '/usr/local/share/fonts' ]; then
	for font in '/usr/local/share/fonts/'*; do
		xset fp+ "${font}"
	done
	xset fp rehash
fi

# environment variables that either:
#
# a) don't make sense to put in ~/.profile
# b) only make sense with a graphical environment
# c) should be overridden in a graphical environment
export \
	BROWSER='ungoogled-chromium' \
	GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0" \
	QT_STYLE_OVERRIDE='Adwaita' \
	READER='zathura' \
	TERMINAL='st'

command -v 'dbus-launch' > /dev/null 2>&1 \
	&& [ -z "${DBUS_SESSION_BUS_ADDRESS}" ] \
	&& eval "$(dbus-launch --sh-syntax --exit-with-x11)"

# keep Downloads clean
rm -rf "${HOME}/Downloads"
mkdir -m 700 "${HOME}/Downloads"

# open FileChooser in current working directory instead of recents
gsettings set org.gtk.Settings.FileChooser startup-mode cwd

# laptop adjustments
if [ "$(hostname -s)" = 'bluebell' ]; then
	xset m 3/2 0
	# trackpad scrolling with middle button
	xinput set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation' 1
	xinput set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Button' 2
	xinput set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Axes' 6 7 4 5
fi

# no pointer acceleration, only constant deceleration.
# see POINTER ACCELERATION in xorg.conf(5)
xinput set-prop '/dev/wsmouse' 'Device Accel Profile' -1

# look and feel
"${XDG_BIN_HOME}/wal" -R -a 85
sct 3500
xset b off

# daemons
picom -b --log-file "${XDG_DATA_HOME}/picom/picom.log"
xidle &
unclutter -idle 3 &
sxhkd &
dunst &

exec spectrwm
