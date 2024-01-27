#!/bin/bash

if [ $(acpi -a | awk '{print $3}') = "off-line" ]; then
aplay beep.wav
fi
