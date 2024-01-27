#!/bin/sh

#inspired by "https://forums.linuxmint.com/viewtopic.php?f=191&t=108174"

#variables
penDriver="N-Trig Pen Pen (0)"
touchDriver="N-Trig MultiTouch" 

#xinput enable "$penDriver"

#rotation grep info
rotation="$(xrandr -q --verbose | grep 'connected' | grep -E -o  '\) (normal|left|inverted|right) \(' | grep -E -o '(normal|left|inverted|right)')"

if ! xinput | grep -q "$penDriver"; then
    echo "Unable to find pen Driver: \"$penDriver\"" 
    notify-send "Unable to find pen Driver: \"$penDriver\"" 
else
#rotation function
case "$rotation" in
normal)
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
fi
