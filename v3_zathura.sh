#!/bin/bash

__DIR__=$(dirname $(greadlink -f "$0"))
VERSION=$(cat "${__DIR__}/VERSION")
FILE=$(greadlink -f "$1")
CONFIG=$(greadlink -f "$HOME/.config/zathura/zathurarc")

docker run --rm -d \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v "$CONFIG:/root/.config/zathura/zathurarc:ro" \
       -v "$HOME/.local/share/zathura/:/root/.local/share/zathura/" \
       -v "$FILE:$FILE:ro" \
       "fuco1/zathura:$VERSION" "$FILE"

