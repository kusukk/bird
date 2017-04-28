#!/bin/bash

##
## Author: ruohuan.he
## Date: 2016-05-04 09:46:13
##

TOOL_DIR=$(dirname $0)
ios_projPath="../../frameworks/runtime-src/proj.ios_mac/ios"
android_projPath="../../frameworks/runtime-src/proj.android/appActivity/src/main/res"

iosPath=("en.lproj" "de.lproj" "es.lproj" "fr.lproj" "it.lproj" "ja.lproj" "ko.lproj" "pt.lproj" "ru.lproj" "tr.lproj" "zh-Hans.lproj" "zh-Hant.lproj")

androidPath=("values-en" "values-de" "values-es" "values-fr" "values-it" "values-ja" "values-ko" "values-pt-rBR" "values-ru" "values-tr" "values-zh-rCN" "values-zh-rTW")

curr_path=$(pwd)
cd $TOOL_DIR
for((i=0;i<${#iosPath[@]};i++)); do
	echo "转换语言----->${ios_projPath}/${iosPath[i]}"
	#先把key为LocalNotification0001的从安卓资源文件里面拿出来做特殊处理
	notification=`grep LocalNotification0001 "${android_projPath}/${androidPath[i]}/strings.xml"`
    # echo $notification
    
	#将notification中value值前后双引号去掉
	newNotify=`echo "$notification" | cut -d ":" -f2 | sed "s:>\":>:g" | sed "s:\"<:<:g"`
    # echo $newNotify

	#开始转换
    cp -p "${ios_projPath}/${iosPath[i]}/Localizable.strings" $(pwd)
    ruby LocalizedStringsConverter_iOS_TO_Android.rb >/dev/null

    notifyLineNum=`grep -n LocalNotification0001 ./strings.xml | cut -d":" -f1`
    # echo $notifyLineNum

    #转换完以后再做其他的处理
    #将key为LocalNotification0001字段替换为上面的处理过的notify
    sed -i.bak "${notifyLineNum}s:^.*$:$newNotify:" ./strings.xml
    #将单引号加上转移符号
    sed -i.bak "s/'/\\\'/g" ./strings.xml
    #将value前面加双引号
    sed -i.bak 's#">#&\"#g' ./strings.xml
    #将value后面加双引号
    sed -i.bak 's#</string#"&#g' ./strings.xml
    #将key为LocalNotification0001的前面加一个\t 用做对齐,加不加都不影响使用
    # sed -i.bak '/LocalNotification0001/s/^/\t/g' ./strings.xml
    cp -p "strings.xml" "${android_projPath}/${androidPath[i]}"
    # mv strings.xml ${androidPath[i]}-strings.xml
done
rm strings.xml.bak


cd $curr_path
