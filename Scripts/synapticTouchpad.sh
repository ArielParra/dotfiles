#!/bin/env sh

# enables the use SynPS/2 Synaptic Touchpad while pressing keys

touchpadID=$(xinput list |grep Syn |awk '{print $6}' | grep -o '[0-9]\+')
touchpadProp=$(xinput list-props $touchpadID |grep 'Disable While Typing Enabled' | grep -o '[0-9]\+' |awk '{printf "%s %s", $1 , $2}' |awk '{print $1}')

xinput set-prop $touchpadID $touchpadProp 0
echo xinput set-prop $touchpadID $touchpadProp 0
echo succes!



