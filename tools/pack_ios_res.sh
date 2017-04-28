#!/bin/bash
TOOL_DIR=$(dirname $0)
cd $TOOL_DIR

if [ ! -d "../res_ios" ]; then
	mkdir ../res_ios
fi

sh ./pack_images.sh ios $@
echo "\n---->pack images done!\n"

cd ..
cur=`pwd`
rm -rf zip/
mkdir zip
cd res_ios
echo "----->making zip, wait seconds...\n"
zip -r ../zip/res.zip gfx effect -x "*.DS_Store" -x "__MACOSX" -x "*startBg.jpg">/dev/null
echo "----->updated $cur/zip/res.zip"

rm -rf ./fonts ./json ./map ./shaders ./audio
cp -R ../oriRes/fonts ./
cp -R ../oriRes/json ./
cp -R ../oriRes/map ./
cp -R ../oriRes/shaders ./
cp -R ../oriRes/audio/ios ./
mv ios audio
