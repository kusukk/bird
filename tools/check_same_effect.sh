#!/bin/bash
effectPath='../oriRes/effect/'
folder=( "add_step" "ball" "balloon" "belt" "big_pig" "bird" "birdfly" "block" "bomb" "box" "box_egg" "box_map" "bread" "brick" "cloud" "collect_port" "color_bucket" "color_pig" "convert" "deadlock" "egg" "failed" "hairball" "hand" "inflactor" "level_mark" "lock" "magic_bomb" "pig" "portal" "rocket" "rocket_bomb" "separator" "shadow" "single" "stone" "target_block" "target_complete" "target_shine" "ui_win" "universe")

cd ${effectPath}
if [ -n "$1" -a "$1" = 'all' ]
then
    for dir in `ls`
    do
        cd ${dir}
        echo "--------------check folder ${dir}----------------"
        rm -rf *.lua
        count=`find ./ -type f -name \*.atlas | grep -v final |  wc -l`
        if [ ${count} -gt 1 ];
        then
            lua ../../../tools/check_same_name.lua all
        fi
        cd -
    done
else
    for((i=0; i<${#folder[@]}; i++))
    do
        cd ${folder[i]}
        rm -rf *.lua
        count=`find ./ -type f -name \*.atlas | grep -v final |  wc -l`
        if [ ${count} -gt 1 ];
        then
            lua ../../../tools/check_same_name.lua all
        fi
        cd -
    done
fi
