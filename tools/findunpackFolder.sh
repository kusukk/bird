#!/bin/bash

cd ../oriRes/effect/
curr=`pwd`
for dir in `ls ./`
do
    if [ -d ${curr}/${dir} ];
    then
        cd ${dir}
        if [ ! -f ${curr}/${dir}/final.atlas ];
        then
            echo ${dir} "not find final.atlas!"
        fi
        cd ..
    fi
done
