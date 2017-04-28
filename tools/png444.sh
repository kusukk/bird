#!/bin/bash

resPath='../res/effect/universe'


find ${resPath} -name \*.png | sed 's/\.png//g' | \
    xargs -I % -n 1 TexturePacker %.png \
    --sheet %.png \
    --data dummy.plist \
    --algorithm Basic \
    --allow-free-size \
    --max-width 4096 \
    --max-height 4096 \
    --size-constraints AnySize \
    --no-trim \
    --opt RGBA8888 \
    --dither-fs \
    --border-padding 0 \
    --shape-padding 0 \
    --inner-padding 0 \
    --extrude 0 
rm -r dummy*.plist