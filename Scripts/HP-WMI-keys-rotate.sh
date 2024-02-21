#!/bin/env bash

# intended to rotate with HP-WMI-KEYS, not working!

#inspired by "https://forums.linuxmint.com/viewtopic.php?f=191&t=108174"

#rotation grep info
rotation="$(xrandr -q --verbose | grep 'connected' | grep -E -o  '\) (normal|left|inverted|right) \(' | grep -E -o '(normal|left|inverted|right)')"

	trap "kill 0" SIGINT
	exec 3< <(stdbuf -o0 xinput test "HP WMI hotkeys")
	while read <&3 data; do
			     #161
	if echo $data | grep "161" | grep "release" >/dev/null; then
	#rotation function
	case "$rotation" in
	normal)
	# rotate to right
	xrandr -o right
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
	;;
	right)
	# rotate to inverted
	xrandr -o inverted
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	;;
	inverted)
	# rotate to normal
	xrandr -o left
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
	;;
	left)
	# rotate to normal
	xrandr -o normal
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	;;
	esac
	fi
	done
