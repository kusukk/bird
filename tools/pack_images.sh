#!/bin/bash

oriResPath='../oriRes/'
resPath=''
imageDir='gfx/'
effectDir='effect/'
configINI='config.ini'

devicePlatform=${1:-android}
if [ "$devicePlatform" == "ios" ]; then
    resPath='../res_ios/'
    shift
elif [ "$devicePlatform" == "android" ]; then
    resPath='../res_android/'
    shift
fi

function trim(){
    echo "$1" | sed 's/^[ ]*//g' | sed 's/[ ]*$//g'
}

function resetVars(){
    name=()
    type=()
    folder=()
    images=()
    format=()
    suffix=()
    scale=()
    maxWidth=()
    maxHeight=()
    padding=()
    textureFormat=()
    dataFormat=('cocos2d')
    extrude=()
    dither=('-none-nn')
    imageRotate=('--enable-rotation')
    savePath=()
}


function getProp(){
    resetVars
    local sec=$1
    local section=`echo "$_CONFIG" | grep "^${sec}"` #获取指定section 相关属性值
    if [ -n "$section" ]; then
        section=($section)
        local -i i
        for((i=0; i<${#section[@]}; i++))
        do
            if [[ ${section[$i]} =~ "${sec}.name" ]]; then
                name=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.type" ]]; then
                type=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.folder" ]]; then
                folder=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.images" ]]; then
                images=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.format" ]]; then
                format=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.suffix" ]]; then
                suffix=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.scale" ]]; then
                scale=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.maxWidth" ]]; then
                maxWidth=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.maxHeight" ]]; then
                maxHeight=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.padding" ]]; then
                padding=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.extrude" ]]; then
                extrude=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.rotate" ]]; then
                local r=${section[$i]#*=}
                if [ "$r" == "0" ]; then
                    imageRotate=('--disable-rotation')
                fi
            elif [[ ${section[$i]} =~ "${sec}.savePath" ]]; then
                savePath=${section[$i]#*=}
            elif [[ ${section[$i]} =~ "${sec}.dither" ]]; then
                dither=${section[$i]#*=}
            fi
        done
    fi

    if [ ${suffix[@]} = 'pvr' ]; then
        textureFormat=('pvr2')
    elif [ ${suffix[@]} = 'pvr.ccz' ]; then
        textureFormat=('pvr2ccz')
    else
        textureFormat=('png')
    fi

    if [ ${#maxWidth[@]} -eq 0 ]; then
        maxWidth=("2048")
    fi

    if [ ${#maxHeight[@]} -eq 0 ]; then
        maxHeight=("2048")
    fi

    if [ ${#padding[@]} -eq 0 ]; then
        padding=("2")
    fi

    if [ ${#extrude[@]} -eq 0 ]; then
        extrude=(1)
    fi
}

function printInfo(){
    echo 'name:' ${name[@]} ${#name[@]}
    echo 'type:' ${type[@]} ${#type[@]}
    echo 'folder:' ${folder[@]} ${#folder[@]}
    echo 'images:' ${images[@]} ${#images[@]}
    echo 'format:' ${format[@]} ${#format[@]}
    echo 'suffix:' ${suffix[@]} ${#suffix[@]}
    echo 'scale:' ${scale[@]}  ${#scale[@]}
    echo 'maxWidth:' ${maxWidth[@]} ${#maxWidth[@]}
    echo 'maxHeight:' ${maxHeight[@]} ${#maxHeight[@]}
    echo 'padding:' ${padding[@]} ${#padding[@]}
    echo 'dataFormat:' ${dataFormat[@]} ${#dataFormat[@]}
    echo 'savePath:' ${savePath[@]} ${#savePath[@]}
    echo 'extrude:' ${extrude[@]} ${#extrude[@]}
    echo 'dither:' ${dither[@]}
    echo 'imageRotate:' ${imageRotate[@]}
}

function removeAndCopyImages(){
    rm -rf ${resPath}${imageDir}* 2>/dev/null
    cp -R  ${oriResPath}${imageDir} ${resPath}${imageDir}
}

function removeEffectOutput(){
    find ${oriResPath}${effectDir} -type d -name output -print0 | xargs -0 rm -rf  2>/dev/null
}

function removeAndCopyEffects(){
    rm -rf ${resPath}${effectDir}* 2>/dev/null
    removeEffectOutput
    cp -R  ${oriResPath}${effectDir} ${resPath}${effectDir}
}

#根据spine altas 配置信息切割图片
function cropPicture(){
    IFS=$'\n'
    for atlasFile in `find ${1} -type f -name \*.atlas`
    do
        IFS=$'\n'
        local sec=(`awk '$0 ~ /^$/{print NR}' ${atlasFile}`)
        for ((sec_i=0; sec_i<${#sec[@]}; sec_i++))
        do
            local _image
            local _imW
            local _imH
            local _imFormat
            local _filter
            local _repeat
            local _sp_image
            local _sp_image_rotate
            local _sp_image_x
            local _sp_image_y
            local _sp_image_w
            local _sp_image_h
            local _sp_image_ow
            local _sp_image_oh
            local _sp_image_ofx
            local _sp_image_ofy
            local _sp_image_idx
            local singleAtlas

            local sec_iAdd=$((${sec_i}+1))
            IFS=$'\n'
            local headV
            local tailV
            if [ ${sec_iAdd} -lt ${#sec[@]} ]
            then
                tailV=$[${sec[sec_i]} + 1]
                headV=$[${sec[sec_iAdd]} - ${sec[sec_i]} - 1]
                singleAtlas=(`tail +${tailV} ${atlasFile} | head -${headV}`)
            else
                tailV=$[${sec[sec_i]} + 1]
                singleAtlas=(`tail +${tailV} ${atlasFile}`)
            fi
            ## image
            _image=`trim "${singleAtlas[0]}"`
            ## size
            IFS=$':'
            local size=(${singleAtlas[1]})
            IFS=$','
            size=(${size[1]})
            imW=`trim "${size[0]}"`
            imH=`trim "${size[1]}"`
            IFS=$':'
            local _format=(${singleAtlas[2]})
            imFormat=`trim "${_format[1]}"`
            local filter=(${singleAtlas[3]})
            _filter=`trim "${filter[1]}"`
            local repeat=(${singleAtlas[4]})
            _repeat=`trim "${repeat[1]}"`
            for((_atlas_i=5; _atlas_i<${#singleAtlas[@]}; _atlas_i+=7))
            do
                _sp_image=`trim "${singleAtlas[_atlas_i]}"`
                _sp_image_rotate=(${singleAtlas[((_atlas_i+1))]})
                _sp_image_rotate=`trim "${_sp_image_rotate[1]}"`

                local xy=(${singleAtlas[((_atlas_i+2))]})
                IFS=','
                xy=(${xy[1]})
                _sp_image_x=`trim "${xy[0]}"`
                _sp_image_y=`trim "${xy[1]}"`
                IFS=:
                local size=(${singleAtlas[((_atlas_i+3))]})
                IFS=','
                size=(${size[1]})
                _sp_image_w=`trim "${size[0]}"`
                _sp_image_h=`trim "${size[1]}"`
                IFS=:
                local osize=(${singleAtlas[((_atlas_i+4))]})
                IFS=','
                osize=(${osize[1]})
                _sp_image_ow=`trim "${osize[0]}"`
                _sp_image_oh=`trim "${osize[1]}"`
                IFS=:
                local ofsize=(${singleAtlas[((_atlas_i+5))]})
                IFS=','
                ofsize=(${ofsize[1]})
                _sp_image_ofx=`trim "${ofsize[0]}"`
                _sp_image_ofy=`trim "${ofsize[1]}"`
                IFS=:
                _sp_image_idx=(${singleAtlas[((_atlas_i+6))]})
                _sp_image_idx=`trim "${_sp_image_idx[1]}"`

                local _sp_image_out_dir=${_sp_image%/*}
                if [ "${_sp_image_out_dir}" != "${_sp_image}" ]
                then
                    mkdir -p ${1}/output/${_sp_image_out_dir}
                fi
                if [ "${_sp_image_rotate}" = "true" ]
                then
                    convert -crop ${_sp_image_h}x${_sp_image_w}+${_sp_image_x}+${_sp_image_y} +repage ${atlasFile%/*}/${_image} ${1}/output/${_sp_image}.png
                    convert -rotate 90 ${1}/output/${_sp_image}.png ${1}/output/${_sp_image}.png
                else
                    convert -crop ${_sp_image_w}x${_sp_image_h}+${_sp_image_x}+${_sp_image_y} +repage ${atlasFile%/*}/${_image} ${1}/output/${_sp_image}.png
                fi
            done
        done
    done
}

function pack_image(){
  local tmpFolder=()
  local tmpImages=()
  for((j=0; j<${#folder[@]}; j++))
  do
      tmpFolder=(${tmpFolder[@]} "${oriResPath}${imageDir}${folder[j]}")
  done

  for((j=0; j<${#images[@]}; j++))
  do
      tmpImages=(${tmpImages[@]} "${oriResPath}${imageDir}${images[j]}")
  done

  resFolder=${tmpFolder[*]/${oriResPath}/${resPath}}
  resImages=${tmpImages[*]/${oriResPath}/${resPath}}
  rm -rf ${resFolder}${resImages}
  TexturePacker --scale ${scale[@]} --opt ${format[@]} --premultiply-alpha --texture-format ${textureFormat[@]} --sheet ${resPath}${imageDir}${savePath[@]}/${name[@]}.${suffix[@]} --data ${resPath}${imageDir}${savePath[@]}/${name[@]}.plist --format ${dataFormat[@]} ${imageRotate[@]} --no-trim --max-width ${maxWidth[@]} --max-height ${maxHeight[@]} --size-constraints AnySize --padding ${padding[@]} --extrude ${extrude[@]} --dither${dither[@]} --algorithm MaxRects ${tmpFolder[@]} ${tmpImages[@]}
}

function pack_images(){
  if [ $# -eq 0 ] #没有指定任何参数，则根据配置文件打包整个gfx文件夹
  then
    #pack image by default config
    for ((i=0; i<${#_SECTION[@]}; i++))
    do
      if [[ ${_SECTION[i]} =~ image_ ]]
      then
        getProp ${_SECTION[i]}
        echo "--------> pack section: ${_SECTION[i]} "
        #printInfo
        pack_image
      fi
    done
  else #根据参数 打包gfx 指定目录
     local tmpSec=`echo ${_SECTION[*]} | tr ' ' '\n'`
    for imgFold in $@
    do
      local findSec=`echo "$tmpSec" | grep image_${imgFold}`
      if [ -n "${findSec}" ]; then #找到配置信息，则根据配置信息打包
          findSec=("$findSec")
          for sec in ${findSec[@]}
          do
              getProp ${sec}
              echo "--------> pack section: ${sec} "
              #printInfo
              pack_image
          done
      else #没有找到配置信息则直接拷贝
          if [ -d ${oriResPath}${imageDir}${imgFold} ]; then
              echo "------>copy $imgFold"
              rm -rf ${resPath}${imageDir}${imgFold} 2>/dev/null
              cp -R ${oriResPath}${imageDir}${imgFold} ${resPath}${imageDir}${imgFold}
          else
              echo "can not find image folder $imgFold !!!!"
          fi
      fi
    done
  fi
}

function compressImage(){
  local oriImage=$1
  local oriImageWithoutSuffix="${oriImage%.*}"
  local retImage=${oriImage/${oriResPath}/${resPath}}
  local retImageWithoutSuffix="${retImage%.*}"
  local retDir="${retImage%/*}"
  cp $oriImageWithoutSuffix\.* $retDir
  rm -f $retImage 2>/dev/null
  TexturePacker --scale ${scale[@]} --opt ${format[@]} --texture-format ${textureFormat[@]} --sheet $retImageWithoutSuffix.${suffix[@]} --data $retImageWithoutSuffix.plist --format ${dataFormat[@]} ${imageRotate[@]} --no-trim --max-width ${maxWidth[@]} --max-height ${maxHeight[@]} --size-constraints AnySize --padding ${padding[@]} --extrude ${extrude[@]} --dither${dither[@]} --algorithm MaxRects $oriImage
  rm -f $retImageWithoutSuffix.plist 2>/dev/null
}

function compress(){
  local -i i
  #check params folder
  if [ ! -z "$folder" -a "$folder" != " "  ]; then
    folder=($folder)
    for ((i=0; i<${#folder[@]}; i++))
    do
        for f in `find $oriResPath${folder[i]} -type f -name "*.png"`
        do
            compressImage $f
        done

    done
  fi

  #check params images
  if [ ! -z "$images" -a "$images" != " "  ]; then
    images=(images)
    for ((i=0; i<${#folder[@]}; i++))
    do
       compressImage $oriResPath${images[i]}
    done
  fi
}


function pack_effect(){
  if [ -d "${oriResPath}${effectDir}${folder[*]}" ]
  then
      rm -rf ${resPath}${effectDir}${folder} 2>/dev/null
      cp -R ${oriResPath}${effectDir}${folder} ${resPath}${effectDir}${effectFold}
      IFS_OLD=$IFS
      mkdir -p ${oriResPath}${effectDir}${folder[*]}/output
      cropPicture ${oriResPath}${effectDir}${folder[*]}
      find ${resPath}${effectDir}${folder[*]} -type f ! -name \*.json -print0 | xargs -0 rm -rf 2>/dev/null
      TexturePacker --opt ${format[@]} --premultiply-alpha --texture-format ${textureFormat[@]} --sheet ${resPath}${effectDir}${folder[*]}/final.${suffix[@]}  --data ${resPath}${effectDir}${folder[*]}/final.atlas --format spineatlas --trim-sprite-names --algorithm MaxRects --max-width ${maxWidth[@]} --max-height ${maxHeight[@]} --size-constraints AnySize ${imageRotate[@]} --dither${dither[@]} --trim-mode None ${oriResPath}${effectDir}${folder[*]}/output/
      IFS=${IFS_OLD}
  fi
}

#打包方式和pack_images相似
function pack_effects(){
  if [ $# -eq 0 ]
  then
    #pack image by default config
    for ((i=0; i<${#_SECTION[@]}; i++))
    do
      if [[ ${_SECTION[i]} =~ spine_ ]]; then
        getProp ${_SECTION[i]}
        echo "--------> pack section: ${_SECTION[i]} "
        #printInfo
        pack_effect
      elif [[ ${_SECTION[i]} =~ compress_ ]]; then
          getProp ${_SECTION[i]}
          echo "------> compress section ${_SECTION[i]}"
          compress
      fi
    done
  else
     local tmpSec=`echo ${_SECTION[*]} | tr ' ' '\n'`
    for effectFold in $@
    do
      local findSec=`echo "$tmpSec" | grep -Fx spine_${effectFold}`
      local findCom=`echo "$tmpSec" | grep -Fx compress_${effectFold}`
      if [ -n "${findSec}" ]; then
          getProp ${findSec}
          echo "--------> pack section: ${findSec} "
          #printInfo
          pack_effect
      elif [[ -n "${findCom}" ]]; then
          getProp ${findCom}
          compress
      else
          if [ -d ${oriResPath}${effectDir}${effectFold} ]; then
              echo "-----copy $effectFold"
              rm -rf ${resPath}${effectDir}${effectFold} 2>/dev/null
              cp -R ${oriResPath}${effectDir}${effectFold} ${resPath}${effectDir}${effectFold}
          else
              echo "can not find spine section $effectFold !!!!"
          fi
      fi
    done
  fi
  removeEffectOutput
}

function pack_all(){
  removeAndCopyImages
  pack_images
  removeAndCopyEffects
  pack_effects
}

function usage(){
  echo "-------------------------------------usage--------------------------------------"
  echo "1.-->\"sh $0\" = \"sh $0 all\" = \"sh $0 gfx effect\"     #pack all"
  echo "2.-->\"sh $0 gfx\"                                        #pack whole folder of gfx"
  echo "3.-->\"sh $0 gfx folderA\"                                #pack folderA in gfx only"
  echo "4.-->\"sh $0 effect\"                                     #pack whole folder of effect"
  echo "5.-->\"sh $0 effect folderB\"                             #pack folderB in effect only"
  echo "6.-->\"sh $0 gfx folderA effect folderB\"                 #execute index3 and index5"
  echo "-----------------------------------------------------------------------------------"
}

function loadConfig(){
  echo "-->Loading config file!"
  ALL="$(./iniparse ${oriResPath}${configINI})"
  _CONFIG=`echo $ALL | cut -d "#" -f 1 | tr ' ' '\n'`
  _SECTION=(`echo $ALL | cut -d "#" -f 2`)
  echo "-->Loading complete!"
}








#--------------------------------------------------------------------#

cd `dirname $0`  #进入shell目录
if [[ $# -eq 0 ]]; then
  loadConfig
  pack_all
elif [[ $# -eq 1 ]]; then
  if [[ "$1" = "all" ]]; then
    loadConfig
    pack_all
  elif [[ "$1" = "gfx" ]]; then
    loadConfig
    removeAndCopyImages
    pack_images
  elif [[ "$1" = "effect" ]]; then
    loadConfig
    removeAndCopyEffects
    pack_effects
  else
    usage
    exit 1
  fi
elif [[ $# -gt 1 ]]; then
  gfxArgs=()
  effectArgs=()
  gfxFlag=0
  effectFlag=0
  typeIn=0
  for arg in $@
  do
    if [[ $arg = 'gfx' ]]; then
      gfxFlag=1
      typeIn=1
      continue
    elif [[ $arg = 'effect' ]]; then
      effectFlag=1
      typeIn=2
      continue
    fi

    if [[ $typeIn -eq 1 ]]; then
        gfxArgs=($gfxArgs "$arg")
    elif [[ $typeIn -eq 2 ]]; then
        effectArgs=($effectArgs "$arg")
    fi
  done

  if [[ $gfxFlag -eq 0 && $effectFlag -eq 0 ]]; then
    usage
    exit 1
  else
    loadConfig
    if [[ $gfxFlag -eq 1 ]]; then
        if [[ ${#gfxArgs} -eq 0 ]]; then
            removeAndCopyImages
            pack_images
        elif [[ ${#gfxArgs} -gt 1 ]]; then
            pack_images ${gfxArgs[@]}
        fi
    fi

    if [[ $effectFlag -eq 1 ]]; then
        if [[ ${#effectArgs} -eq 0 ]]; then
            removeAndCopyEffects
            pack_effects
        elif [[ ${#effectArgs} -gt 1 ]]; then
            pack_effects ${effectArgs[@]}
        fi
    fi
  fi
fi
