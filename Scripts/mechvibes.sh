#!/bin/env sh

# to disable gpu rendering and make it run on 2GB of ram


# /usr/share/fontconfig/conf.avail/05-reset-dirs-sample.conf 
# comented line: <!--  <reset-dirs />  -->
/usr/bin/mechvibes --disable-gpu --disable-seccomp-filter-sandbox --max-old-space-size
#/usr/bin/mechvibes --disable-gpu --disable-seccomp-filter-sandbox 
