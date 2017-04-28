//
//  SoundPlayer.hpp
//  ABBB
//
//  Created by Yann on 3/27/16.
//
//

#ifndef SoundPlayer_hpp
#define SoundPlayer_hpp
#include <string>
#include <vector>
#include <unordered_map>
#include <stdio.h>
#include "cocos2d.h"
#include "json/document.h"
#include "MusicFade.h"
#include <iostream>
using namespace std;

#include "MyboDevice.h"
USING_NS_CC;
class SoundPlayer :public Ref{
    std::string currentBackgroudMusicId;
    std::string currentMilleuBackgroudMusicId;
    //音频文件分组管理, 可以整体提高音量, 停止, 继续. group 音量乘自身音量为最终音量
    std::unordered_map<std::string, float> groups;
    
    //音频文件参数列表  type, loop, volume, pitch, delay, group
    std::unordered_map<std::string, std::vector<std::string>> audioParameters;
    
    //音频文件列表
    std::unordered_map<std::string, std::vector<std::string>> audioFiles;
    
    std::vector<std::string> audioBattleList;

public:
    bool disableMusic = false;
    bool disableSFX = false;
    
    struct AsyncStruct
    {
    public:
        AsyncStruct(const std::string& fn, std::function<void(std::string)> f) : filename(fn), callback(f) {}

        std::string filename;
        std::function<void(std::string)> callback;
    };
    
protected:
    static SoundPlayer* instance;

    std::deque<AsyncStruct*> _asyncStructQueue;
    std::deque<AsyncStruct*> _requestQueue;
    std::deque<AsyncStruct*> _responseQueue;

    std::mutex _requestMutex;
    std::mutex _responseMutex;
    
    std::condition_variable _sleepCondition;
    std::function<void(std::string)> callback;

    std::thread* _loadingThread;
    bool _needQuit = false;
    int _asyncRefCount;

public:
    static SoundPlayer* getInstance();

    SoundPlayer();
    ~SoundPlayer ();
    void init(std::string config, bool disableMusic, bool disableSFX);
    
    void setMusicEnbale(bool enable);
    void setSFXEnbale(bool enable);
    
    bool getMusicEnbale();
    bool getSFXEnbale();
    
    //group
    void stopAudioByGroup(const char* groupId);
    void resumeAudioByGroup(const char* groupId);
    
    void changEffectsLoading(bool inMapScene);
    
    // music
    virtual void preloadBackgroundMusic(const char* musicId,bool isSecondSound=false);
    virtual void playBackgroundMusic(const char* musicId,bool isMileuBg=false);
    virtual void stopBackgroundMusic(bool bReleaseData = false);
    virtual void pauseBackgroundMusic();
    virtual void resumeBackgroundMusic();
    virtual void rewindBackgroundMusic();
    virtual bool willPlayBackgroundMusic();
    virtual bool isBackgroundMusicPlaying();
    virtual float getBackgroundMusicVolume();
    virtual void setBackgroundMusicVolume(float volume);
    
    // sound effects
    virtual unsigned int playEffect(const char* SFXId);
    
    virtual float getEffectsVolume();
    virtual void setEffectsVolume(float volume);
    
    virtual void pauseAllEffects();
    virtual void pauseEffect(unsigned int nSoundId);
    
    virtual void resumeEffect(unsigned int nSoundId);
    virtual void resumeAllEffects();
    
    virtual void stopEffect(unsigned int nSoundId);
    virtual void stopAllEffects();
    virtual void preloadEffect(const char* sfxId);
    virtual void unloadEffect(const char* sfxId);
    
    //game audio control
    void playBalloonBlast(float time, int number);
    
    void unloadEffectForId(const char* sfxId);
    void preloadEffectForId(const std::string& sfxId,const std::function<void(std::string)>& callback);
    void loadSound();
    void loadSoundCallBack(float dt);
    
private:
    float cutVolume;
    float cutSceVolume;
    bool isBattleScene;
};

#endif /* SoundPlayer_hpp */
