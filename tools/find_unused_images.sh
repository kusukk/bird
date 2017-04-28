#! /bin/bash

totalsize=0
totalcount=0

for file in `find res/gfx -name \*.png`; do
    newFile=`basename $file`
    counter=`find ./src/ ./frameworks/runtime-src/Classes/ -name \*.lua -o -name \*.cpp |xargs grep $newFile |wc -l`
    if [ $counter == 0 ]; then
        filesize=$(stat -f "%z" $file)
        echo $file,  $counter, $filesize
        let totalsize=totalsize+filesize
        # rm $file
        let totalcount=totalcount+1
    fi
done

echo "total file count: ${totalcount}, totalsize:${totalsize}"
