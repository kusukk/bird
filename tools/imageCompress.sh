#!/bin/bash
TOOL_DIR=$(dirname $0)
cd $TOOL_DIR/../
PROJECT_ROOT=`pwd`
ORI_RES=$PROJECT_ROOT/oriRes
ORI_COMPRESS=$PROJECT_ROOT/oriRes_compress
API_KEYS_FILE="$PROJECT_ROOT/tools/TinyPng/tinyApiKeys.txt"
# today=`date +"%d"`
# todayFileIdx=`echo "$today * 3" | bc`

#把 key 读到数组里
api_keys_arr=(`cat "$API_KEYS_FILE"`)
#获取数组的长度
KEYS_LENS="${#api_keys_arr[@]}"
#获取一个随机的开始行
start_index=`echo "$RANDOM % $KEYS_LENS" | bc`
image_idx=1
imageAmount=0

function updateKey(){
    local -i idx
    idx=`echo "($image_idx + $start_index) % $KEYS_LENS" |bc`
    api_key=${api_keys_arr[idx]}
}

function updateCounter(){
    echo
    echo "$image_idx / $imageAmount"
    echo
    let image_idx=image_idx+1
}

function compress(){
    if [[ ! "$1" =~ "$ORI_RES" ]]; then
        echo "!ERROR PATH:$1"
        return
    fi
    # FILE_NAME=`basename $1`
    # SRC_ABS_FILE=$1 #/aaa/bbb/oriRes/x/a.png
    # SRC_PRE_FILE=${SRC_ABS_FILE%\.*} #/aaa/bbb/oriRes/x/a
    # SRC_PRE_FOLDER=${SRC_ABS_FILE%\/*} #/aaa/bbb/oriRes/x
    # DST_ABS_FILE=${SRC_ABS_FILE/$ORI_RES/$ORI_COMPRESS} #/aaa/bbb/oriRes_compress/x/a.png
    # DST_PRE_FILE=${DST_ABS_FILE%\.*} #/aaa/bbb/oriRes_compress/x/a
    # DST_PRE_FOLDER=${DST_ABS_FILE%\/*} #/aaa/bbb/oriRes_compress/x
    # DST_PRE_FOLDER="$HOME/Desktop/pop"
    # DST_ABS_FILE="$DST_PRE_FOLDER/$FILE_NAME"
    # rm -rf "$DST_PRE_FOLDER"
    # mkdir -p "$DST_PRE_FOLDER"

    # if [ -s ${SRC_PRE_FILE}.json ]; then
    #     echo "copy ${SRC_PRE_FILE}.json to ${DST_PRE_FOLDER}"
    #     cp -f ${SRC_PRE_FILE}.json ${DST_PRE_FOLDER}
    # fi

    # if [ -s ${SRC_PRE_FILE}.atlas ]; then
    #     echo "copy ${SRC_PRE_FILE}.atlas to ${DST_PRE_FOLDER}"
    #     cp -f ${SRC_PRE_FILE}.atlas ${DST_PRE_FOLDER}
    # fi
    # cp -f ${SRC_ABS_FILE} ${DST_ABS_FILE}

    updateKey
    python ${PROJECT_ROOT}/tools/TinyPng/tinypng.py -k $api_key -f $1
    updateCounter
}

function usage(){
    echo "--------sh imageCompress.sh [-h] /absolute/path"
    echo "option:"
    echo "-h show usage"
    echo
    echo "->sample:"
    echo "sh imageCompress.sh /Users/zinber/work/popbirds/oriRes/gfx/back.png"
    exit 1
}

if [ $# -gt 0 ]; then
    if [ "$1" == "-h" ]; then
        usage 
    fi
    for f_d in $@
    do
        #如果是目录
        if [ -d $f_d ]; then
            find $f_d -type f \( -name \*.png -or -name \*.jpg \) | while read filename ;
            do
                compress "$filename"
            done
        else
            if [[ "$f_d" =~ ".jpg" ]]; then
                compress "$f_d"
            elif [[ "$f_d" =~ ".png" ]]; then
                compress "$f_d"
            else
                echo "unknown file:$f_d"
            fi
        fi
    done
else
    usage
    # echo "------compress all------"
    # rm -rf $ORI_COMPRESS
    # mkdir $ORI_COMPRESS
    
    # cp -r $ORI_RES/* $ORI_COMPRESS
    # imageAmount=`find . -type f \( -name \*.png -or -name \*.jpg \) | wc -l`
    # find $ORI_RES -type f \( -name \*.png -or -name \*.jpg \) | while read filename ;
    # do
    #     compress "$filename"
    # done
fi
