#!/bin/bash
touchpadID=$(xinput list |grep ETPS |awk '{print $6}' | grep -o '[0-9]\+')
xinput enable $touchpadID



