#!/bin/env sh

# to fix a problem i had with xauthority x11 id while root


mv /root/.Xauthority /root/.Xauthority.bak
touch /root/.Xauthority

x11id=$(xauth -f $(ps aux | grep Xorg |awk '{print $18}') list |awk '{printf $3}') 

echo $x11id
xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $x11id

