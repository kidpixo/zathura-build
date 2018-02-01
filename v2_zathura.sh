#!/bin/bash

__DIR__=$(dirname $(greadlink -f "$0"))
VERSION=$(cat "${__DIR__}/VERSION")
FILE=$(greadlink -f "$1")
CONFIG=$(greadlink -f "$HOME/.config/zathura/zathurarc")

#open -a XQuartz

_OLD_DISPLAY=$DISPLAY
# add a port from local IP to xhost
IP=$(ifconfig|grep -E 'inet.*broad'|awk '{ print $2; }')
#Find good port 
display_number=`ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'`
#add xhost
echo "IP IS $IP";
echo "DISPLAY IS $DISPLAY";
/opt/X11/bin/xhost + $IP

#Lauch your display
export DISPLAY=$IP$display_number".0"
echo "NEW DISPLAY IS $DISPLAY";

xhost + $IP

docker run --rm -d \
       -e DISPLAY=unix$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v "$CONFIG:/root/.config/zathura/zathurarc:ro" \
       -v "$HOME/.local/share/zathura/:/root/.local/share/zathura/" \
       -v "$FILE:$FILE:ro" \
       "fuco1/zathura:$VERSION" "$FILE"

## remove from xhost
/opt/X11/bin/xhost - $IP
## reset to olr display
export DISPLAY=$_OLD_DISPLAY

