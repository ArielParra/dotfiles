#!/bin/sh

#inspired by "https://forums.linuxmint.com/viewtopic.php?f=191&t=108174"

#variables
penDriver="N-Trig Pen Pen (0)"
touchDriver="N-Trig MultiTouch" 

#xinput enable "$penDriver"

#rotation grep info
rotation="$(xrandr -q --verbose | grep 'connected' | grep -E -o  '\) (normal|left|inverted|right) \(' | grep -E -o '(normal|left|inverted|right)')"

#rotation function
case "$rotation" in
normal)
	
	# rotate to right
	xrandr -o right
	xinput set-prop "$penDriver" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
	xinput set-prop "$touchDriver" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
	;;
right)
	# rotate to inverted
	xrandr -o inverted
	xinput set-prop "$penDriver" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	xinput set-prop "$touchDriver" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	;;

inverted)
	# rotate to left
	xrandr -o left
	xinput set-prop "$penDriver" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
	xinput set-prop "$touchDriver" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
	;;
left)
	# rotate to normal
	xrandr -o normal
	xinput set-prop "$penDriver" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	xinput set-prop "$touchDriver" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	;;

esac
feh --no-fehbg --bg-fill '/home/ravary/Pictures/joy.png'
