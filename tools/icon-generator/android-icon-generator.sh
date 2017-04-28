#!/bin/bash
#
# Copyright (C) 2014 Wenva <lvyexuwenfa100@126.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

set -e

SRC_FILE="$1"
DST_PATH="../../frameworks/runtime-src/proj.android/appActivity/src/main/res"

VERSION=1.0.0

info() {
     local green="\033[1;32m"
     local normal="\033[0m"
     echo -e "[${green}INFO${normal}] $1"
}

error() {
     local red="\033[1;31m"
     local normal="\033[0m"
     echo -e "[${red}ERROR${normal}] $1"
}

usage() {
cat << EOF
VERSION: $VERSION
USAGE:
    $0 srcfile dstpath

DESCRIPTION:
    This script aim to generate ios app icons easier and simply.

    srcfile - The source png image. Preferably above 1024x1024
    dstpath - The destination path where the icons generate to.

    This script is depend on ImageMagick. So you must install ImageMagick first
    You can use 'sudo brew install ImageMagick' to install it

AUTHOR:
    Pawpaw<lvyexuwenfa100@126.com>

LICENSE:
    This script follow MIT license.

EXAMPLE:
    $0 1024.png ~/123
EOF
}

# Check ImageMagick
command -v convert >/dev/null 2>&1 || { error >&2 "The ImageMagick is not installed. Please use brew to install it first."; exit -1; }

# Check param
if [ $# != 1 ];then
    usage
    exit -1
fi

# Check dst path whether exist.
if [ ! -d "$DST_PATH" ];then
    mkdir -p "$DST_PATH"
fi

# Generate, refer to:https://developer.apple.com/library/ios/qa/qa1686/_index.html

# info 'Generate iTunesArtwork.png ...'
# convert "$SRC_FILE" -resize 512x512 "$DST_PATH/iTunesArtwork.png"
# info 'Generate iTunesArtwork@2x.png ...'
# convert "$SRC_FILE" -resize 1024x1024 "$DST_PATH/iTunesArtwork@2x.png"

info 'Generate drawable ...'
convert "$SRC_FILE" -resize 144x144 "$DST_PATH/drawable/icon.png"

info 'Generate drawable-ldpi/icon.png ...'
convert "$SRC_FILE" -resize 32x32 "$DST_PATH/drawable-ldpi/icon.png"

info 'Generate drawable-hdpi ...'
convert "$SRC_FILE" -resize 72x72 "$DST_PATH/drawable-hdpi/icon.png"

info 'Generate drawable-mdpi ...'
convert "$SRC_FILE" -resize 48x48 "$DST_PATH/drawable-mdpi/icon.png"

info 'Generate drawable-xhdpi ...'
convert "$SRC_FILE" -resize 96x96 "$DST_PATH/drawable-xhdpi/icon.png"

info 'Generate drawable-xxhdpi ...'
convert "$SRC_FILE" -resize 144x144 "$DST_PATH/drawable-xxhdpi/icon.png"

info 'Generate drawable-xxxhdpi ...'
convert "$SRC_FILE" -resize 192x192 "$DST_PATH/drawable-xxxhdpi/icon.png"

info 'Generate Done.'
