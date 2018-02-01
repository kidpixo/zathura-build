#!/bin/bash
# brew cask install xquartz
defaults write org.macosforge.xquartz.X11 app_to_run '' # suppress xterm terminal
open -a XQuartz
ip=$(ifconfig|grep -E 'inet.*broad'|awk '{ print $2; }')
display_number=`ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'`
/opt/X11/bin/xhost + $ip
/usr/local/bin/docker rm gimp
/usr/local/bin/docker run -d --name gimp -e DISPLAY=$ip$display_number -v ~/Pictures:/root/Pictures -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/.gtkrc:/root/.gtkrc jess/gimp

