#!/bin/bash

##
## Author: ruohuan.he
## Date: 2016-05-04 09:46:13
##
echo "请输入新的版本号（例如：1.0.1）："
read newVersion

lastJson="{\"path\": {\"res_json.zip\": \"res/json\",\"res_map.zip\": \"res/map\",\"res_audio.zip\": \"res/audio\",\"res_animation.zip\": \"res/animation\",\"res_gfx.zip\": \"res/gfx\",\"res_script.zip\": \"res/script\"},\"map_version\": \"133\",\"asset_version\": \"311\"}"
fileName=("res_script" "res_audio" "res_animation" "res_gfx" "res_json")
findPathArryNoPwd=("../csrc" "../res_ios/audio" "../oriRes/effect" "../oriRes/gfx" "../res_ios/json")
orginPathD=$(pwd)"/versionManage"
orginPath=$(pwd)"/versionManage/version.txt"
orginPathFileMD5=$(pwd)"/versionManage/versionFileMd5.log"
orginPathFileMD5Temp=$(pwd)"/versionManage/versionFileMd5Temp.log"

if  [[ -z $(echo $newVersion|sed 's/^[0-9]\{1,5\}\.[0-9]\{1,5\}\.[0-9]\{1,5\}$//g') ]]; then
	echo "版本号验证成功"
	if [ -f "${orginPath}" ]; then
		str_1=${newVersion%%.*}
		str_temp=${newVersion#*.}
		str_2=${str_temp%%.*}
		str_3=${str_temp#*.}
		export DA=`grep "currVersion" -n ${orginPath}`
		oldStr="${DA#*=}"
		oldStr_1=${oldStr%%.*}
		oldStr_temp=${oldStr#*.}
		oldStr_2=${oldStr_temp%%.*}
		oldStr_3=${oldStr_temp#*.}
		if (( $str_1<$oldStr_1 )); then
			echo "输入的版本低_1"
			exit
		else
			if (( $str_1==$oldStr_1 )); then
				if (( $str_2<$oldStr_2 )); then
					echo "输入的版本低_2"
					exit
				else
					if (( $str_2==$oldStr_2 )); then
						if (( $str_3<$oldStr_3 )); then
							echo "输入的版本低_3"
							exit
						fi
					fi
				fi
			fi
		fi

	fi
else
	echo "版本号验证失败"
	exit
fi

function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file $2
        else
            echo $1"/"$file
            md5 -r $1"/"$file >> $2
        fi
    done
}

isChange=false
function checkMD5(){
	index=0
	while read line;do
		for word in $line; do
			wordNum=$[wordNum+1]
			if (( $wordNum%2==0 )); then
				wordEnd=$word
			else
				wordStart=$word
			fi
			if (( $wordNum%2==0 )); then
				export DA=`grep $wordEnd -n ${orginPathFileMD5}`
				isCopy=false
				if [ -n "$DA" ] ; then
					if [[ ! "$DA" =~ "$wordStart" ]] ; then
						echo $wordStart"--------有差异-------"$wordEnd
						isChange=true
						isCopy=true
					fi
				else
					isCopy=true
					isChange=true
					echo $wordStart"--------有新文件-------"$wordEnd
				fi
				if $isCopy ; then
					mkdirPath="${orginPathD}/${newVersion}/$wordEnd"
					mkdirPath=${mkdirPath%/*}
					if ! test -x "$mkdirPath" ; then
						echo "创建文件夹：$mkdirPath"
						mkdir -p $mkdirPath
					fi
					echo $wordEnd >> "${orginPathD}/${newVersion}/difference.txt"
					cp -p $wordEnd "${orginPathD}/${newVersion}/$wordEnd"
				fi
			fi
		done
	done < $orginPathFileMD5Temp
}



if [ ! -d "${orginPathD}" ]; then 
	mkdir "$orginPathD" 
	echo $lastJson >> "${orginPathD}/last.json"
fi 
if [ ! -f "${orginPath}" ]; then 
	touch "$orginPath" 
	echo "currVersion=${newVersion}" >> $orginPath
	echo "historyVersion" >> $orginPath
	echo "-----------创建原始版本-----------"
	:>$orginPathFileMD5
	for((i=0;i<${#findPathArryNoPwd[@]};i++)); do
		read_dir "${findPathArryNoPwd[i]}" "${orginPathFileMD5}"
	done
else
	echo "-----------存在原始版本-----------"
	export DA=`grep $newVersion -n ${orginPath}`
	if [ -n "$DA" ] ; then
		echo "-----------存在此版本-----------"
	else
		echo "---------开始匹配差异文件---------"
		for((i=0;i<${#findPathArryNoPwd[@]};i++)); do
			read_dir "${findPathArryNoPwd[i]}" "${orginPathFileMD5Temp}"
		done
		checkMD5
		if $isChange ; then
			export DA=`grep "currVersion" -n ${orginPath}`
			if [ -n "$DA" ] ; then
				oldVersion="${DA#*=}"
				sed -i "" 's/'"${oldVersion}"'/'$newVersion'/g' $orginPath
				echo $oldVersion >> $orginPath
			fi
			for((i=0;i<${#fileName[@]};i++)); do
				if [ -d "${orginPathD}/${newVersion}/${findPathArryNoPwd[i]}" ]; then
					echo "压缩文件----->${orginPathD}/${newVersion}/${findPathArryNoPwd[i]}"
					cd "${orginPathD}/${newVersion}/${findPathArryNoPwd[i]}"
					zip -r "${fileName[i]}.zip" *
					mv "${fileName[i]}.zip" "${orginPathD}/${newVersion}"
					str_q=${fileName[i]%%_*}
					str_h=${fileName[i]#*_}
					sed -i "" "s/{/&\"${fileName[i]}.zip\":\"${str_q}\/${str_h}\",/2" "${orginPathD}/last.json"
					echo "是否需要上传到服务器(y/n)"
					read YorN
					if [ "$YorN" == "y" ]; then
						echo "请输入上传版本号（例如：1.0.1）："
						read updateVersion
						username="admin"
						password="36583658"
						curl -F username=$username -F password=$password -F version=$updateVersion -F upload=@"${orginPathD}/${newVersion}/${fileName[i]}.zip" http://pop.mybogame.com/incr/uploadzip | grep \* | echo
					fi
				fi
			done
			echo "--------------------------压缩完毕--------------------------"
		else
			echo "--------------版本无变化---------------"
		fi
		mv $orginPathFileMD5Temp $orginPathFileMD5
		# rm -f $orginPathFileMD5Temp
	fi
fi

