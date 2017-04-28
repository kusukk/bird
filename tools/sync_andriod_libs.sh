#!/usr/bin/env bash
TOOL_DIR=$(dirname $0)
cd $TOOL_DIR

cocos2dx_root='../frameworks/cocos2d-x'
android_project_root='../frameworks/runtime-src/proj.android'
target_dir=$android_project_root/jni/cocos_armeabi-v7a_libs/

cp $android_project_root/obj/local/armeabi-v7a/*.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/chipmunk/prebuilt/android/armeabi-v7a/libchipmunk.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/curl/prebuilt/android/armeabi-v7a/libcrypto.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/curl/prebuilt/android/armeabi-v7a/libcurl.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/freetype2/prebuilt/android/armeabi-v7a/libfreetype.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/jpeg/prebuilt/android/armeabi-v7a/libjpeg.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/lua/luajit/prebuilt/android/armeabi-v7a/libluajit.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/png/prebuilt/android/armeabi-v7a/libpng.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/curl/prebuilt/android/armeabi-v7a/libssl.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/tiff/prebuilt/android/armeabi-v7a/libtiff.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/webp/prebuilt/android/armeabi-v7a/libwebpdecoder_static.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/websockets/prebuilt/android/armeabi-v7a/libwebsockets.a $target_dir 2>/dev/null
cp $cocos2dx_root/external/png/prebuilt/android/armeabi-v7a/libz.a $target_dir 2>/dev/null