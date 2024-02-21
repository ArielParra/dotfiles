#!/bin/env bash

# Now Working

NAME="HP WMI hotkeys"
KEY_ID="161"

rotation="$(xrandr -q --verbose | grep 'connected' | grep -E -o  '\) (normal|left|inverted|right) \(' | grep -E -o '(normal|left|inverted|right)')"

function rotate_display() {
	ROTATE="1 0 0 0 1 0 0 0 1"
	DISP="normal"
	if [ "$rotation" == "inverted" ]; then
	ROTATE="-1 0 1 0 -1 1 0 0 1"
	DISP="inverted"
	fi
	xinput set-prop "N-Trig Pen Pen (0)" "Coordinate Transformation Matrix" $ROTATE
	xinput set-prop "N-Trig MultiTouch" "Coordinate Transformation Matrix" $ROTATE
	xrandr -o $DISP
}

	trap "kill 0" SIGINT
	exec 3< <(stdbuf -o0 xinput test "HP WMI hotkeys")
	while read <&3 data; do
	if echo $data | grep "161" | grep "release" >/dev/null; then
	currentRotation=$rotation
	if [ -z "$currentRotation" ]; then
	nextRotation="half"
	fi

	if [ "$currentRotation" == "inverted" ]; then
	nextRotation="none"
	fi
	rotate_display $nextRotation
fi
done
