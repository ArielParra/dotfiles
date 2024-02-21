#!/bin/env bash

# to notify when im in battery mode

if [ $(acpi -a | awk '{print $3}') = "off-line" ]; then
    notify-send "on battery mode!"
fi
