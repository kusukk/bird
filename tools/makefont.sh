#!/bin/sh

usage(){
    echo '-----usage-----\n sh makefont.sh xxx\n\n xxx->[step,combo]\n'
}
if [ $# -ne 1  ];
then 
    echo "one argument expected."
    usage
    exit 1
fi
fontFolder=../docs/originResource/gfx
stepNumberFolder='stepNumber'
stepNumber2Folder='stepNumber2'
comboNumberFolder='comboNumber'


if [ $1 = 'step' ];
then
    dstFolder=${stepNumberFolder}
elif [ $1 = 'combo' ];
then
    dstFolder=${comboNumberFolder}
elif [ $1 = 'step2' ];
then
    dstFolder=${stepNumber2Folder}
else
    echo "argument error!"
    usage
    exit 1
fi
rm ${dstFolder}.*
cp ${fontFolder}/template.fnt ./
mv template.fnt ${dstFolder}.fnt
TexturePacker --data ${dstFolder}.plist --format cocos2d --disable-rotation --size-constraints AnySize --sheet ${dstFolder}.png ${fontFolder}/${dstFolder}/*.png
python ./fontMaker.py ${dstFolder}
echo "copy ${dstFolder}.fnt and ${dstFolder}.png to directory res/gfx/ (y/n)?"
read input
if [ $input -a $input = 'y' ];then
	cp -fv ${dstFolder}.png ${dstFolder}.fnt ../res/gfx/
	echo 'copy complete!'
else
   echo 'warning==>not copy!!!'
fi
rm ${dstFolder}.*
echo 'done.'
