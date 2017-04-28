#!/bin/bash
toolDir=$(dirname $0)
cd $toolDir

echo "---------compress gfx images"
cd $toolDir
sh imageCompress.sh

if [[ $? -ne 0 ]]; then
    echo "imageCompress ERROR!"
    exit 1
fi

if [ x"$1" == x"ios" ]; then
    echo "-----------make ios images-----"
    sh pack_images_ios.sh
else
    echo "--------make android images-----"
    sh pack_images.sh
fi
if [[ $? -ne 0 ]]; then
    echo "pack_images ERROR!"
    exit 1
fi


echo "------------make font"
cd $toolDir/font
sh makefont.sh stepNumber stepNumber2

if [[ $? -ne 0 ]]; then
    echo "make font ERROR!"
    exit 1
fi




