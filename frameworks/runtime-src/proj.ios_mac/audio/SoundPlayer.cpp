//
//  SoundPlayer.cpp
//  popbirds
//
//  Created by Yann on 3/27/16.
//
//

#include "SoundPlayer.h"
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

SoundPlayer* SoundPlayer::instance = nullptr;
SoundPlayer* SoundPlayer::getInstance(){
    if (instance == nullptr){
        instance = new (std::nothrow) SoundPlayer();
    }
    return instance;
}


SoundPlayer::SoundPlayer()
:_loadingThread(nullptr)
, _needQuit(false)
,_asyncRefCount(0)
{

}

SoundPlayer::~SoundPlayer(){
    CC_SAFE_DELETE(_loadingThread);
}


void SoundPlayer::init(std::string config, bool disableMusic, bool disableSFX){
    this->disableMusic = disableMusic;
    this->disableSFX = disableSFX;
    audioParameters.clear();
    audioFiles.clear();
    rapidjson::Document doc;
    doc.Parse<0>(config.c_str());
    if (doc.HasParseError()){
        CCLOG("A GetParseError %s\n",doc.GetParseError());
    }
    CCLOG("-----------初始化音乐-----------");
    const rapidjson::Value& audioList = doc["audio"];
    rapidjson::Value::ConstMemberIterator member;
    const char *key;
//    int NUM0 = 0;
    for (member = audioList.MemberBegin(); member != audioList.MemberEnd(); member++){
        key   = member->name.GetString();
        std::vector<std::string> parameters;
        if (key != nullptr && member->value.IsArray()){
            for (rapidjson::SizeType i = 0; i < member->value.Size(); i++){
                if (i == 7) {
                    const rapidjson::Value& soundfiles = member->value[i];
                    if (soundfiles.IsArray()) {
                        std::vector<std::string> files;
                        for (rapidjson::SizeType j = 0; j < soundfiles.Size(); j++){
                            files.push_back(soundfiles[j].GetString());
//                            if (member->value[NUM0].GetInt() == 1) {
//                                std::string str = soundfiles[j].GetString();
//                                if (str.size()>0) {
//                                    if (FileUtils::getInstance()->fullPathForFilename(str).compare(str)!=0) {
//                                        if (member->value[(int)6].GetInt() == 0) {
//                                            CCLOG("%s ", str.c_str());
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//                                            m_MainSound->preloadEffect(str.c_str());
//#else
//                                            SimpleAudioEngine::getInstance()->preloadEffect(str.c_str());
//#endif
//
//                                        }else{
//                                            audioBattleList.push_back(str);
//                                        }
//                                    }else{
//                                        log("file is null ");
//                                    }
//                                }else{
//                                    log("config set is null ----- %s",key);
//                                }
//                            }
                        }
                        audioFiles.insert(std::make_pair(key, files));
                    }else{
                        log("Audio Config Error!");
                    }
                }else if( i == 5){
                    parameters.push_back((std::string)member->value[i].GetString());
                }else{
                    parameters.push_back(StringUtils::format("%f",member->value[i].GetDouble()));
                }
            }
            audioParameters.insert(std::pair<std::string, std::vector<std::string>>(key, parameters));
        }
    }
    
    //group
    const rapidjson::Value& groupData = doc["group"];
    float volume = 1;
    for (member = groupData.MemberBegin(); member != groupData.MemberEnd(); member++){
        key   = member->name.GetString();
        volume = member->value.GetInt();
        this->groups.insert(std::pair<std::string, float>(key, volume));
    }
}

void SoundPlayer::setMusicEnbale(bool enable){
    disableMusic = !enable;
}

void SoundPlayer::setSFXEnbale(bool enable){
    disableSFX = !enable;
}

void SoundPlayer::stopAudioByGroup(const char *groupId){
    
}

void SoundPlayer::resumeAudioByGroup(const char *groupId){
    
}

void SoundPlayer::preloadBackgroundMusic(const char* musicId,bool isSecondSound){
    // Changing file path to full path
    if (audioFiles.find(musicId) != audioFiles.end()) {
        auto files = audioFiles.at(musicId);
        auto filePath = files.at(cocos2d::random(0,(int)files.size()-1));
        std::string fullPath = FileUtils::getInstance()->fullPathForFilename(filePath);
        SimpleAudioEngine::getInstance()->preloadBackgroundMusic(fullPath.c_str());
    }else{
        log("preloadBackgroundMusic: Can not find audio file by Id - %s", musicId);
    }
    
}

void SoundPlayer::playBackgroundMusic(const char* musicId,bool isMileuBg){
    // Changing file path to full path
    std::string musicStr = musicId;
    if (audioFiles.find(musicId) != audioFiles.end()) {
        auto files = audioFiles.at(musicId);
        auto filePath = files.at(cocos2d::random(0,(int)files.size()-1));
        std::string fullPath = FileUtils::getInstance()->fullPathForFilename(filePath);
        if (fullPath.compare("")==0) {
            log("config set is null");
            return;
        }
        auto audioInfo = audioParameters.at(musicId);
        int tag = std::atoi(audioInfo.at(1).c_str());
        bool loop = tag==-1?true:false;
        float volume = std::atof(audioInfo.at(2).c_str());
        //float pitch = std::atoi(audioInfo.at(3).c_str());
        float delay = std::atof(audioInfo.at(4).c_str());
        std::string group = audioInfo.at(5);
        
        if (1 == groups.count(musicId)) {
            volume *= groups.at(musicId);
        }
        
        auto scene = Director::getInstance()->getRunningScene();
        DelayTime* delayTime = DelayTime::create(delay);
        CallFunc* fun;
        
        if (!isMileuBg) {
            fun = CallFunc::create([=](){
                bool isPlaying = SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying();
                if ( isPlaying && musicStr.compare(currentBackgroudMusicId)!=0) {
                    auto fadeOut = MusicFade::create(0.4, 0);
                    auto fadeIn = MusicFade::create(0.4, volume);
                    auto playFun = CallFunc::create([=](){
                        currentBackgroudMusicId = musicStr;
                        SimpleAudioEngine::getInstance()->playBackgroundMusic(fullPath.c_str(), loop);
                    });
                    scene->runAction(Sequence::create(fadeOut, playFun, fadeIn, nullptr));
                }else{
                    SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(volume);
                    SimpleAudioEngine::getInstance()->playBackgroundMusic(fullPath.c_str(), loop);
                    currentBackgroudMusicId = musicStr;
                }
                if (disableMusic) {
                    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
                }

            });
        }else{
            fun = CallFunc::create([=](){
                bool isPlaying = MyboDevice::isMilleuBgMusicPlaying();
                if ( isPlaying && strcmp(musicId, currentMilleuBackgroudMusicId.c_str()) != 0) {
                    auto fadeOut = MusicFade::create(0.4, 0);
                    auto fadeIn = MusicFade::create(0.4, volume);
                    auto playFun = CallFunc::create([=](){
                        currentMilleuBackgroudMusicId = musicId;
                        MyboDevice::playMilieuBgMusic(fullPath,loop);
                    });
                    scene->runAction(Sequence::create(fadeOut, playFun, fadeIn, nullptr));
                }else{
                    currentMilleuBackgroudMusicId = musicId;
                    MyboDevice::playMilieuBgMusic(fullPath,loop);
                    MyboDevice::setMilleuBgMusicVolume(volume);
                }
                if (disableSFX) {
                    MyboDevice::puaseMilleuBgMusic();
                }
            });
        }
        scene->runAction(Sequence::create(delayTime, fun, NULL));
    }else{
        log("playBackgroundMusic: Can not find backgroud music file by Id - %s", musicId);
    }
    
}

void SoundPlayer::stopBackgroundMusic(bool bReleaseData){
    SimpleAudioEngine::getInstance()->stopBackgroundMusic(bReleaseData);
    currentBackgroudMusicId = "";
}

void SoundPlayer::pauseBackgroundMusic(){
    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

void SoundPlayer::resumeBackgroundMusic(){
    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}

void SoundPlayer::rewindBackgroundMusic(){
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//    m_MainSound->rewindBackgroundMusic();
//    m_SecondSound->rewindBackgroundMusic();
//#endif
}

bool SoundPlayer::willPlayBackgroundMusic(){
    return SimpleAudioEngine::getInstance()->willPlayBackgroundMusic();
}

bool SoundPlayer::isBackgroundMusicPlaying(){
    if (SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying() or MyboDevice::isMilleuBgMusicPlaying()) {
        return true;
    }
    return false;
}

float SoundPlayer::getBackgroundMusicVolume(){
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//    return m_SecondSound->getBackgroundMusicVolume();
//#else
    return SimpleAudioEngine::getInstance()->getBackgroundMusicVolume();
//#endif
}

void SoundPlayer::setBackgroundMusicVolume(float volume){
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//    if (!disableMusic) {
//        if (m_MainSound) {
//            m_MainSound->setBackgroundMusicVolume(volume);
//        }
//    }
//    if (!disableSFX) {
//        if (m_SecondSound) {
//            m_SecondSound->setBackgroundMusicVolume(volume);
//        }
//    }
//#else
    if (!disableMusic) {
        SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(volume);
    }
    if (!disableSFX) {
        MyboDevice::setMilleuBgMusicVolume(volume);
    }
//#endif
}

float SoundPlayer::getEffectsVolume(){
    
    return SimpleAudioEngine::getInstance()->getEffectsVolume();
    
}

void SoundPlayer::setEffectsVolume(float volume){
    SimpleAudioEngine::getInstance()->setEffectsVolume(volume);
    MyboDevice::setMilleuBgMusicVolume(volume);
}

unsigned int SoundPlayer::playEffect(const char *SFXId){
    unsigned int effId = -1;
    if (audioFiles.find(SFXId) != audioFiles.end()) {
        //            CCLOG("音量-------->%f",this->getEffectsVolume());
        auto files = audioFiles.at(SFXId);
        auto filePath = files.at(cocos2d::random(0,(int)files.size()-1));
        std::string fullPath = FileUtils::getInstance()->fullPathForFilename(filePath);
        if (fullPath.compare("")==0) {
            log("config set is null--->%s",SFXId);
            return 0;
        }
        if(fullPath.compare("")!=0){
            auto audioInfo = audioParameters.at(SFXId);
            bool loop = std::atoi(audioInfo.at(1).c_str()) == -1 ? true : false;
            float volume = std::atof(audioInfo.at(2).c_str());
            float pitch = std::atof(audioInfo.at(3).c_str());
            float delay = std::atof(audioInfo.at(4).c_str());
            std::string group = audioInfo.at(5);
            
            if (1 == groups.count(SFXId)) {
                volume *= groups.at(SFXId);
            }
            if (delay != 0.0f) {
//                log("pauseEffect------->%d------%f----->%s",effId,delay,fullPath.c_str());
                CallFunc* fun = CallFunc::create([this,effId,fullPath,loop,pitch,volume](){
//                    this->resumeEffect(effId);
                    SimpleAudioEngine::getInstance()->playEffect(fullPath.c_str(), loop, pitch, 0, disableSFX?0 : volume);
                });
                Director::getInstance()->getRunningScene()->runAction(Sequence::create(DelayTime::create(delay), fun, NULL));
            }else{
                effId = SimpleAudioEngine::getInstance()->playEffect(fullPath.c_str(), loop, pitch, 0, disableSFX?0 : volume);
            }
        }else{
            log("无配置音乐------>%s",SFXId);;
        }
    }else{
        log("play Effect: Can not find audio file by Id - %s", SFXId);
    }
    return effId;
}

void SoundPlayer::stopEffect(unsigned int nSoundId){
    log("SID:%d", nSoundId);
    SimpleAudioEngine::getInstance()->stopEffect(nSoundId);
}

void SoundPlayer::preloadEffect(const char* sfxId){
    // Changing file path to full path
    if (audioFiles.find(sfxId) != audioFiles.end()) {
        auto files = audioFiles.at(sfxId);
        auto filePath = files.at(cocos2d::random(0,(int)files.size()-1));
        if (filePath.size()>0) {
            std::string fullPath = FileUtils::getInstance()->fullPathForFilename(filePath);
            if (fullPath.size()>0) {
                SimpleAudioEngine::getInstance()->preloadEffect(fullPath.c_str());
            }
        }
    }else{
        log("preloadEffect: Can not find audio file by Id - %s", sfxId);
    }
}

void SoundPlayer::unloadEffect(const char* pszFilePath){
    // Changing file path to full path
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    SimpleAudioEngine::getInstance()->unloadEffect(fullPath.c_str());
}


void SoundPlayer::pauseEffect(unsigned int uSoundId){
        SimpleAudioEngine::getInstance()->pauseEffect(uSoundId);
}

void SoundPlayer::resumeEffect(unsigned int uSoundId){
    if (!disableSFX) {
        SimpleAudioEngine::getInstance()->resumeEffect(uSoundId);
    }
}

void SoundPlayer::pauseAllEffects(){
    SimpleAudioEngine::getInstance()->pauseAllEffects();
    MyboDevice::puaseMilleuBgMusic();
}

void SoundPlayer::resumeAllEffects(){
    if (!disableSFX) {
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//        if (m_MainSound) {
//            m_MainSound->resumeAllEffects();
//        }
//        if (m_SecondSound) {
//            m_SecondSound->setBackgroundMusicVolume(m_SecondSound->getOggBackgroundMusicVolume());
//            m_SecondSound->resumeBackgroundMusic();
//        }
//#else
//#endif
        SimpleAudioEngine::getInstance()->resumeAllEffects();
        MyboDevice::resumeMilleuBgMusic();

    }
}

void SoundPlayer::stopAllEffects(){
    SimpleAudioEngine::getInstance()->stopAllEffects();
}

bool SoundPlayer::getMusicEnbale(){
    return !disableMusic;
}
bool SoundPlayer::getSFXEnbale(){
    return !disableSFX;
}


// game audio
void SoundPlayer::playBalloonBlast(float time, int number){
    if (disableSFX) {
        return;
    }
    
    float pitch = 1 * (0.8 + CCRANDOM_0_1()*0.2);
    int soundNumber = number > 3 ? 3: number;
    auto playCallback = CallFunc::create([=](){
        const char* sfx = "balloon_blast";
        auto files = audioFiles.at(sfx);
        auto filePath = files.at(cocos2d::random(0,(int)files.size()-1));
        std::string fullPath = FileUtils::getInstance()->fullPathForFilename(filePath);
        auto audioInfo = audioParameters.at(sfx);
        bool loop = std::atoi(audioInfo.at(1).c_str()) == -1 ? true : false;
        float volume = std::atoi(audioInfo.at(2).c_str()) * (0.6 + CCRANDOM_0_1()*0.4);
        //        float pitch = std::atoi(audioInfo.at(3).c_str());
        //        float delay = std::atoi(audioInfo.at(4).c_str());
        std::string group = audioInfo.at(5);
//        log("filePath--->%s----%f",filePath.c_str(),volume);
        SimpleAudioEngine::getInstance()->playEffect(fullPath.c_str(), loop, pitch, 0, volume);
    });
    
    auto scene = Director::getInstance()->getRunningScene();
    float step = (time*2 / (soundNumber + 1));
    for (int i = 0; i < soundNumber; i++) {
        auto delay = DelayTime::create(i * step + (step*0.3 - 0.6*step*CCRANDOM_0_1()));
        //auto delay = DelayTime::create(i * step);
        scene->runAction(Sequence::create(delay, playCallback, NULL));
    }
}



void SoundPlayer::changEffectsLoading(bool inMapScene){
    for (auto effect : audioBattleList) {
        if (inMapScene) {
            this->unloadEffect(effect.c_str());
//            CCLOG("卸载--->%s",effect.c_str());
        }else{
            isBattleScene = false;
        }
    }
}

void SoundPlayer::unloadEffectForId(const char *sfxId){
    // Changing file path to full path
    if (audioFiles.find(sfxId) != audioFiles.end()) {
        auto files = audioFiles.at(sfxId);
        for (auto file : files) {
            if (file.size()>0) {
                std::string fullPath = FileUtils::getInstance()->fullPathForFilename(file);
                if (fullPath.size()>0) {
                    SimpleAudioEngine::getInstance()->unloadEffect(fullPath.c_str());
                }
            }
        }

    }else{
        log("preloadEffect: Can not find audio file by Id - %s", sfxId);
    }
}

void SoundPlayer::preloadEffectForId(const string& sfxId,const std::function<void(std::string)>& callback){
    // Changing file path to full path
    if (audioFiles.find(sfxId) != audioFiles.end()) {
        auto files = audioFiles.at(sfxId);
        for (auto file : files) {
            if (file.size()>0) {
                std::string fullPath = FileUtils::getInstance()->fullPathForFilename(file);
                if (fullPath.size()>0) {
                    if (nullptr == _loadingThread){
                        _loadingThread = new std::thread(&SoundPlayer::loadSound, this);
                        _needQuit = false;
                    }
                    if (0 == _asyncRefCount)
                    {
                        Director::getInstance()->getScheduler()->schedule(CC_SCHEDULE_SELECTOR(SoundPlayer::loadSoundCallBack), this, 0, false);
                    }

                    ++_asyncRefCount;

                    // generate async struct
                    AsyncStruct *data = new (std::nothrow) AsyncStruct(fullPath, callback);
                    // add async struct into queue
                    _asyncStructQueue.push_back(data);
                    _requestMutex.lock();
                    _requestQueue.push_back(data);
                    _requestMutex.unlock();

                    _sleepCondition.notify_one();
                }
            }
        }
        
    }else{
        log("preloadEffect: Can not find audio file by Id - %s", sfxId.c_str());
    }
}

void SoundPlayer::loadSound(){
    AsyncStruct *asyncStruct = nullptr;
    std::mutex signalMutex;
    std::unique_lock<std::mutex> signal(signalMutex);
    while (!_needQuit)
    {
        // pop an AsyncStruct from request queue
        _requestMutex.lock();
        if (_requestQueue.empty())
        {
            asyncStruct = nullptr;
        }
        else
        {
            asyncStruct = _requestQueue.front();
            _requestQueue.pop_front();
        }
        _requestMutex.unlock();

        if (nullptr == asyncStruct) {
            _sleepCondition.wait(signal);
            continue;
        }
        //load sound
        SimpleAudioEngine::getInstance()->preloadEffect(asyncStruct->filename.c_str());
        
        // push the asyncStruct to response queue
        _responseMutex.lock();
        _responseQueue.push_back(asyncStruct);
        _responseMutex.unlock();
    }

}

void SoundPlayer::loadSoundCallBack(float dt){
    AsyncStruct *asyncStruct = nullptr;
    while (true)
    {
        // pop an AsyncStruct from response queue
        _responseMutex.lock();
        if (_responseQueue.empty())
        {
            asyncStruct = nullptr;
        }
        else
        {
            asyncStruct = _responseQueue.front();
            _responseQueue.pop_front();
            // the asyncStruct's sequence order in _asyncStructQueue must equal to the order in _responseQueue
            CC_ASSERT(asyncStruct == _asyncStructQueue.front());
            _asyncStructQueue.pop_front();
        }
        _responseMutex.unlock();

        if (nullptr == asyncStruct) {
            break;
        }

        
        // call callback function
        if (asyncStruct->callback)
        {
            (asyncStruct->callback)(asyncStruct->filename);
        }

        // release the asyncStruct
        delete asyncStruct;
        --_asyncRefCount;
    }

    if (0 == _asyncRefCount)
    {
        Director::getInstance()->getScheduler()->unschedule(CC_SCHEDULE_SELECTOR(SoundPlayer::loadSoundCallBack), this);
    }
}


