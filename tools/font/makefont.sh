#!/bin/sh

usage(){
    echo '-----usage-----\n sh makefont.sh xxx\n\n xxx->[stepNumber stepNumber2]\n'
}

if [ $# -eq 0 ]
then
    echo "argument expect !!!"
    usage
    exit 1
fi
fontFolder=../../oriRes/font

for i in $@
do
    rm ${i}.* 2>/dev/null
    cp template.fnt ${i}.fnt
    TexturePacker --data ${i}.plist --format cocos2d --disable-rotation --size-constraints AnySize --sheet ${i}.png ${fontFolder}/${i}/*.png
    python ./fontMaker.py ${i}
    cp ${i}.png ${i}.fnt ../../oriRes/gfx
    rm ${i}.* 2>/dev/null
    echo "make font $i done."
done

