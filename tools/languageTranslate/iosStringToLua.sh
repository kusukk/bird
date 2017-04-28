#!/bin/bash

##
## Author: ruohuan.he
## Date: 2016-05-04 09:46:13
##


newStr=","
oldStr=";"

languageArr=("de.lproj" "en.lproj" "es.lproj" "fr.lproj" "it.lproj" "ja.lproj" "ko.lproj" "pt.lproj" "ru.lproj" "tr.lproj" "zh-Hans.lproj")
# languageArr=("de.lproj")
languageArr2=("de" "en" "es" "fr" "it" "ja" "ko" "pt" "ru" "tr" "zh")
iosOrginPath="../../frameworks/runtime-src/proj.ios_mac/ios"
iosSourceFile=$(pwd)"/iosSourceFile"
rm -rf $iosSourceFile
mkdir -p $iosSourceFile
for((i=0;i<${#languageArr[@]};i++)); do
	cp -r -f -v "${iosOrginPath}/${languageArr[i]}" "${iosSourceFile}"
done


for((i=0;i<${#languageArr[@]};i++)); do
	orginPath="${iosSourceFile}/${languageArr[i]}/Localizable.strings"
	sed -i.bak 's/'"${oldStr}"'/'$newStr'/g' $orginPath
	sed -i.bak '/\/\//d' $orginPath
	sed -i.bak '/^ *$/d' $orginPath
	sed -i.bak "s/\/\*.*\*\///" $orginPath
	sed -i.bak "/^[ \t]*\/\*/,/.*\*\//d" $orginPath

	startStr=`cat ${iosSourceFile}/${languageArr[i]}/Localizable.strings|head -n1`
	st="language = {"
	if [ "$startStr" = "language = {" ];then
		echo "已经含有头尾结构字符串:
	language = { 
	}"
	else
		sed -i.bak '1 i\
		language = {
		' $orginPath

		echo "}">>$orginPath
	fi
	while read myline
	do
		if [[ "$myline" == \"* ]];then
			OLD_IFS="$IFS" 
			IFS="\"" 
			arr=($myline) 
			IFS="$OLD_IFS" 
			index=0
			for s in ${arr[@]} 
			do 
				index=$[index+1]
				if (( index==1 )); then
			    	echo "$s" 
			    	s="\"${s}\""
			    	bb="[${s}]"
					sed -i.bak 's/'"${s}"'/'$bb'/g' $orginPath
				fi
			done

		fi

	done < $orginPath

	mv -f $orginPath "${iosSourceFile}/${languageArr[i]}/Localizable.lua"
	mv -f "${iosSourceFile}/${languageArr[i]}" "${iosSourceFile}/${languageArr2[i]}" 
	rm -f "${iosSourceFile}/${languageArr2[i]}/Localizable.strings.bak"
done

cp -r -f -v "${iosSourceFile}" "../../src/app/language/"


