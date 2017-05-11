//
//  AppGameConfig.cpp
//  popbirds
//
//  Created by He_bi on 16/7/13.
//
//

#include "AppGameConfig.hpp"
//跳关
static bool isSkipLevel = true;
//跳过内付费直接购买
static bool isSkipPay = true;
//重复显示新手引导
static bool isRepeatedlyShowGuide = false;
// 显示用户关卡包列表
static bool isOpenCheckPointPackage = false;
//打开多语言
static bool isOpenLocalLanguage = true;
//打开Hatch
static bool isEnableHatchAsset = true;
//使用加密
static bool isEncryption = true;
//强制每次解压资源包
static bool isForceUnzip = false;
//使用Debug模式
static bool isDebugMode = false;
//地图初始版本号
static std::string initMapVersion = "9993";
//资源初始版本号
static std::string initResVersion = "12061";
//广告视频开关
static bool isOpenAD = true;

//改变游戏背景图片
static bool isChangeBG = false;

//是否打开多语言的热更新测试
static bool isHotUpdateLocalLanguage = false;
//是否打开debug热更新
static bool isDebugHotUpdate = false;

bool AppGameConfig::GetIsSkipLevel(){
    return isSkipLevel;
}

bool AppGameConfig::GetIsSkipPay(){
    return isSkipPay;
}

bool AppGameConfig::GetIsRepeatedlyShowGuide(){
    return isRepeatedlyShowGuide;
}

bool AppGameConfig::GetIsOpenCheckPointPackage(){
    return isOpenCheckPointPackage;
}

bool AppGameConfig::GetIsOpenLocalLanguage(){
    return isOpenLocalLanguage;
}

bool AppGameConfig::GetIsEnableHatch(){
    return isEnableHatchAsset;
}

bool AppGameConfig::GetIsEncryption(){
    return isEncryption;
}
bool AppGameConfig::GetIsDebugMode(){
    return isDebugMode;
}

std::string AppGameConfig::GetInitMapVersion(){
    return initMapVersion;
}

std::string AppGameConfig::GetInitResVersion(){
    return initResVersion;
}

bool AppGameConfig::GetIsForceUnzip(){
    return isForceUnzip;
}
bool AppGameConfig::GetIsOpenAD(){
    return isOpenAD;
}
bool AppGameConfig::GetIsChangeBG(){
    return isChangeBG;
}

bool AppGameConfig::GetIsHotUpdateLocalLanguage(){
    return isHotUpdateLocalLanguage;
}

bool AppGameConfig::GetIsDebugHotUpdate(){
    return isDebugHotUpdate;
}






