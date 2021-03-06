//
//  MyboDevice.h
//  bird
//
//  Created by 彭先锋 on 2017/4/28.
//
//

#ifndef MyboDevice_h
#define MyboDevice_h
#include <stdio.h>
#include <string>
#include "cocos2d.h"
using namespace std;
using namespace cocos2d;


#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
const static char* CHANNEL = "AppStore";
#else
const static char* CHANNEL = "GooglePlay";
#endif

class MyboDevice{
public:
    static std::string getCurLanguageKey();
    static void setCurLanguageKey(const std::string key);

    static std::string getLocalString(const std::string key,bool isSet=true);
    static void playMilieuBgMusic(const std::string musicName,bool loop=false);
    static void proloadMilleuBgMusic(const std::string musicName);
    static void stopMilleuBgMusic();
    static void puaseMilleuBgMusic();
    static void resumeMilleuBgMusic();
    static void setMilleuBgMusicVolume(float volume);
    static bool isMilleuBgMusicPlaying();
    static bool isOtherAudioPlaying();
    
    
    static string getAppVersion();
    static string getBuildID();
    static std::string getBuildVersion();
    
    
//    typedef std::function<void(int code)> resultCallback;
//#if (CC_TAEGET_PLATFORM == CC_PLATFORM_IOS)
//    static void loadFile(const char*fileName,const resultCallback& result,int resultCode);
//    
//    static boool isFilePathInDocument(cons)
//    static std::string getCountry();
//    static bool isLanguageHaveList();
//    static void goToComment();
};

#endif /* MyboDevice_h */
