#!/bin/env bash

#inspired by "https://forums.linuxmint.com/viewtopic.php?f=191&t=108174"

#rotation grep info
rotation="$(xrandr -q --verbose | grep 'connected' | grep -E -o  '\) (normal|left|inverted|right) \(' | grep -E -o '(normal|left|inverted|right)')"

#rotation function
case "$rotation" in
normal)
	# rotate to inverted
	xrandr -o inverted
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	;;
inverted)
	# rotate to normal
	xrandr -o normal
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	;;
esac
