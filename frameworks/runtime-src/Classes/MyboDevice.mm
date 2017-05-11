//
//  MyboDevice.m
//  bird
//
//  Created by 彭先锋 on 2017/4/28.
//
//

#import <Foundation/Foundation.h>
#include "MyboDevice.h"
#include "SoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static bool m_isEqual = false;
static std::string m_CurLanguageKey ="";

static AVAudioPlayer *audioSourcePlayer = nullptr;
static bool _stoppedMilleuBgMusic= false;
static bool _pauseMilleuBgMusic= false;

void MyboDevice::playMilieuBgMusic(const std::string musicName,bool loop){
    MyboDevice::proloadMilleuBgMusic(musicName);
    audioSourcePlayer.numberOfLoops = loop?-1:0;
    if (!_stoppedMilleuBgMusic && !_pauseMilleuBgMusic) {
        [audioSourcePlayer play];
    }
}
bool MyboDevice::isOtherAudioPlaying(){
    return false;
}
void MyboDevice::proloadMilleuBgMusic(const std::string musicName){
    _stoppedMilleuBgMusic = false;
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(musicName);
    if (fullPath.size()>0) {
        if (audioSourcePlayer) {
            [audioSourcePlayer release];
            audioSourcePlayer = nullptr;
        }
        NSError *error = nil;
        audioSourcePlayer = [(AVAudioPlayer*)[AVAudioPlayer alloc] initWithContentsOfURL
                             :[NSURL fileURLWithPath:[NSString stringWithUTF8String
                                                      :fullPath.c_str()]] error:&error];
        audioSourcePlayer.volume = 1;
        audioSourcePlayer.numberOfLoops = -1;
    }else{
        NSLog(@"not play music file");
    }
}

void MyboDevice::stopMilleuBgMusic(){
    if (audioSourcePlayer) {
        _stoppedMilleuBgMusic = true;
        _pauseMilleuBgMusic = false;
        [audioSourcePlayer stop];
    }else{
        //        NSLog(@"audioSourcePlayer is null");
    }
}

void MyboDevice::resumeMilleuBgMusic(){
    if (audioSourcePlayer) {
        if (!_stoppedMilleuBgMusic) {
            _pauseMilleuBgMusic = false;
            _stoppedMilleuBgMusic = false;
            [audioSourcePlayer play];
        }else{
            NSLog(@"music stopped");
        }
    }else{
        //        NSLog(@"audioSourcePlayer is null");
    }
}

void MyboDevice::puaseMilleuBgMusic(){
    if (audioSourcePlayer) {
        _pauseMilleuBgMusic = true;
        [audioSourcePlayer pause];
    }else{
        //        NSLog(@"audioSourcePlayer is null");
    }
}

string MyboDevice::getAppVersion(){
    NSString * version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [version UTF8String];
    
}

std::string MyboDevice::getBuildVersion(){
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [version UTF8String];
}

std::string MyboDevice::getBuildID(){
    NSString * id = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return [id UTF8String];
}

std::string MyboDevice::getLocalString(const std::string key,bool isSet){
    
    
    
    if (m_CurLanguageKey.size()<=0) {
        NSArray * arr = [[NSBundle mainBundle] localizations];
        NSString * CURR_LANG = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:CURR_LANG];
        CURR_LANG = [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];
        if ([CURR_LANG isEqualToString:@"zh"]) {
            if ([languageDic objectForKey:@"kCFLocaleCountryCodeKey"]) {
                CURR_LANG = [NSString stringWithFormat:@"%@-%@",CURR_LANG,@"Hant"];
            }else if([languageDic objectForKey:@"kCFLocaleScriptCodeKey"]){
                CURR_LANG = [NSString stringWithFormat:@"%@-%@",CURR_LANG,[languageDic objectForKey:@"kCFLocaleScriptCodeKey"]];
            }
        }
        for (NSString *str : arr) {
            //        TODO: 未配置好的语言强制设置成英文
            if ([str isEqualToString:CURR_LANG]) {
                //                if ([CURR_LANG isEqualToString:@"zh"] || [CURR_LANG isEqualToString:@"ja"] || [CURR_LANG isEqualToString:@"ko"]) {
                //                    CURR_LANG = @"en";
                //                    m_isEqual = false;
                //                }else{
                //                    m_isEqual = true;
                m_isEqual = true;
                //                }
                break;
            }
        }
    }
    if (isSet) {
        //        m_CurLanguageKey = key;
        MyboDevice::setCurLanguageKey(key);
    }
    NSString * str;
    if (m_isEqual && AppGameConfig::GetIsOpenLocalLanguage()) {
        str =  NSLocalizedString([NSString stringWithUTF8String:key.c_str()],@"xxxx");
    }else{
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        str = [languageBundle localizedStringForKey:[NSString stringWithUTF8String:key.c_str()] value:@"" table:nil];
    }
    
    if (AppGameConfig::GetIsHotUpdateLocalLanguage()) {
        LuaStack * L =LuaEngine::getInstance()->getLuaStack();
        lua_State* tolua_s = L->getLuaState();
        lua_getglobal(tolua_s, "getHotUpdateLocalLanguage");
        lua_pushstring(tolua_s, key.c_str());
        int iRet= lua_pcall(tolua_s, 1, 1, 0);
        if (iRet)
        {
            const char *pErrorMsg = lua_tostring(tolua_s, -1);
            CCLOG("错误-------%s",pErrorMsg);
            return "NULL";
        }
        return lua_tostring(tolua_s, -1);
    }
    //    NSLog(@"%@------------>%@",[NSString stringWithUTF8String:key.c_str()],str);
    std::string str2 =[str cStringUsingEncoding: NSUTF8StringEncoding];
    return str2;
}

















