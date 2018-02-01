#!/bin/bash

__DIR__=$(dirname $(greadlink -f "$0"))
VERSION=$(cat "${__DIR__}/VERSION")
FILE=$(greadlink -f "$1")
CONFIG=$(greadlink -f "$HOME/.config/zathura/zathurarc")

_OLD_DISPLAY=$DISPLAY

IP=$(ifconfig|grep -E 'inet.*broad'|awk '{ print $2; }')
echo "DISPLAY IS $DISPLAY";
#Find good port 
#p=0;for port in $(seq 0 10);do echo "Check DISPLAY port:$((6000+$p)) (:$p)";  nc -w0 127.0.0.1 $((6000+$p)) && DISPLAY="$IP:$p"; let p=p+1;  done;
export DISPLAY=$IP:0 # this is the only way it is working!
echo "DISPLAY IS $DISPLAY";
#add xhost
xhost + $IP

echo "IP IS $IP";

export DISPLAY=$DISPLAY
echo "NEW DISPLAY IS $DISPLAY";
#Lauch your display

#xhost +local:docker

docker run --rm -d \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v "$CONFIG:/root/.config/zathura/zathurarc:ro" \
       -v "$HOME/.local/share/zathura/:/root/.local/share/zathura/" \
       -v "$FILE:$FILE:ro" \
       "fuco1/zathura:$VERSION" "$FILE"

xhost - $IP
export DISPLAY=$_OLD_DISPLAY

