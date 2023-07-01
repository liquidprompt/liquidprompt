#!/bin/bash

height="20"

wdir=$(dirname $0)

# Cannot use terminal emulator reusing a common daemon from which to fork windows, or else the PID will change.
# e.g. gnome-terminal, terminator, etc.
# urxvt gets X11 errors and shorten the output...
xterm -bg black -e watch --no-title --no-wrap --color --interval 1 $wdir/lp-status.sh default $wdir/lp-status.conf &
PID="$!"

ID=$(xdotool search --sync -pid $PID 2>/dev/null)
width=$(xrandr -q | head -n1 | awk '{print $8}')
xdotool windowunmap --sync ${ID}
xdotool windowsize --sync ${ID} ${width} ${height}
xprop -id "${ID}" -format _NET_WM_WINDOW_TYPE 32a -set _NET_WM_WINDOW_TYPE "_NET_WM_WINDOW_TYPE_DOCK"
xprop -id "${ID}" -format _NET_WM_STRUT_PARTIAL 32cccccccccccc -set _NET_WM_STRUT_PARTIAL "0,0,${height},0,0,0,0,0,0,${width},0,0"
xdotool windowmap ${ID}

