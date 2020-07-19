#!/usr/bin/env sh
export LANG=en_US.UTF-8
/usr/X11R6/bin/xrdb -merge ${HOME}/.Xresources
/usr/X11R6/bin/xidle -timeout 90 -program '/usr/local/bin/slock' &
/usr/local/bin/sct 3500 &
/usr/X11R6/bin/xset b off
/usr/local/bin/sxhkd &
/usr/local/bin/unclutter -idle 3 -grab &
~/.local/bin/wal -R &
/usr/X11R6/bin/xcompmgr -I 0.0125 -O 0.0125 -D 2 -c -f -C &
/usr/X11R6/bin/xset m 4/1 4
/usr/X11R6/bin/xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1
/usr/X11R6/bin/xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2
/usr/X11R6/bin/xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5
exec i3
