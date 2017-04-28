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
    static void playMilieuBgMusic(const std::string musicName,bool loop=false);
    static void proloadMilleuBgMusic(const std::string musicName);
    static void stopMilleuBgMusic();
    static void puaseMilleuBgMusic();
    static void resumeMilleuBgMusic();
    static void setMilleuBgMusicVolume(float volume);
    static bool isMilleuBgMusicPlaying();
    static bool isOtherAudioPlaying();
    

};

#endif /* MyboDevice_h */
