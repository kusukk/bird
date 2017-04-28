//
//  SpineCache.cpp
//  popbirds
//
//  Created by Yann on 2/19/16.
//
//

#include "SpineCache.hpp"

SpineCache* SpineCache::instance = nullptr;

SpineCache* SpineCache::getInstance(){
    if (instance == nullptr) {
        instance = new (std::nothrow) SpineCache();
    }
    return instance;
}

SpineCache::SpineCache(){
    
    loadQueueMutex.lock();
    loadQueue = new std::queue<SpineInfo*>();
    loadQueueMutex.unlock();
    
    completedQueueMutex.lock();
    completedQueue   = new std::deque<SpineInfo*>();
    completedQueueMutex.unlock();
    
    asyncRefCount = 0;
    
    // create a new thread to load spine
    loadingThread = new std::thread(&SpineCache::loadSpineInThread, this);
}

SpineCache::~SpineCache(){
    for(auto it = skeletonRenderers.begin(); it != skeletonRenderers.end(); ++it)
        spSkeletonData_dispose((it->second));
    
    CC_SAFE_DELETE(loadingThread);
}

const std::string SpineCache::getKey(const std::string &jsonPath, float scale){
    int scaleFactor = scale * 100;
    std::stringstream ss;
    std::string scaleFactorStr;
    ss << scaleFactor;
    ss >> scaleFactorStr;
    return jsonPath + scaleFactorStr;
}

void SpineCache::loadSpineAsync(const std::string &jsonPath, const std::string &atlasPath, const std::string &texturePath,
                               const std::function<void (const std::string &)> &callback){
    
    auto key = FileUtils::getInstance()->fullPathForFilename(jsonPath);
    auto it = skeletonRenderers.find(key);
    spSkeletonData* skeletonRenderer = nullptr;
    
    if (it != skeletonRenderers.end()) {
        skeletonRenderer = it->second;
    }
    
    if (skeletonRenderer) {
        callback(jsonPath);
        return;
    }

    if (0 == asyncRefCount){
        Director::getInstance()->getScheduler()->schedule(CC_SCHEDULE_SELECTOR(SpineCache::checkProgress), this, 0, false);
    }
    
    ++asyncRefCount;
    
    auto fullJsonPath = FileUtils::getInstance()->fullPathForFilename(jsonPath);
    auto fullAtlasPath = FileUtils::getInstance()->fullPathForFilename(atlasPath);

    // generate async struct
    SpineInfo *data = new (std::nothrow) SpineInfo();
    data->jsonPath = fullJsonPath;
    data->atlasPath = fullAtlasPath;
    data->callback = callback;
    
    //rgba8888默认在lua中处理
//    if (jsonPath != "effect/map/common/rgba8888/down.json" &&
//        jsonPath != "balloon/skeleton.json" &&
//        jsonPath != "yellow_bubble/yellow_bubble.json"&&
//        jsonPath != "itembg_light/skeleton.json" &&
//        jsonPath != "export/balloon.json") {
//        Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat::RGBA4444);
//    }
    Director::getInstance()->getTextureCache()->addImageAsync(texturePath, [=](Texture2D* tex){
        loadQueueMutex.lock();
        loadQueue->push(data);
        loadQueueMutex.unlock();
        sleepCondition.notify_one();
//        Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat::RGBA8888);

    });
}

SkeletonAnimation* SpineCache::getSpine(const std::string &jsonPath, const std::string &atlasPath, const std::string &texturePath, float scale){

    auto key = FileUtils::getInstance()->fullPathForFilename(jsonPath);
    
    
    auto it = skeletonRenderers.find(key);
//     printf("key-1:%s\n", jsonPath.c_str());
    spSkeletonData *data;
    if (it == skeletonRenderers.end()) {
        printf("No Cache, Load spine in main thread. %s\n", jsonPath.c_str());

        SpineInfo *siData = new (std::nothrow) SpineInfo();
        
        auto fullJsonPath = FileUtils::getInstance()->fullPathForFilename(jsonPath);
        auto fullAtlasPath = FileUtils::getInstance()->fullPathForFilename(atlasPath);
        
        siData->jsonPath = fullJsonPath;
        siData->atlasPath = fullAtlasPath;
        
        if (jsonPath != "effect/map/common/rgba8888/down.json" &&
            jsonPath != "balloon/skeleton.json" &&
            jsonPath != "yellow_bubble/yellow_bubble.json"&&
             jsonPath != "itembg_light/skeleton.json" &&
            jsonPath != "export/balloon.json"&&
            jsonPath !="effect/target_block/bubble/skeleton.json"&&
            jsonPath !="effect/map/ch7/rgba8888/aurora.json"&&
            jsonPath!="effect/map/ch7/rgba4444/bubble_pig.json"&&
            jsonPath!="effect/map/ch7/rgba4444/bubble.json" &&
            jsonPath!="effect/mapLock/mapcloud.json"&&
            jsonPath!="load/loading.json"&&
            jsonPath!="effect/big_pig/skeleton.json"&&
            jsonPath!="effect/target_complete/skeleton.json"&&
            jsonPath!="effect/bonus_time/skeleton.json"&&
            jsonPath!="effect/mapLock/mapcloud.json" &&
            jsonPath!="export/infinite_balloon.json") {
             Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat::RGBA4444);
        }

        Director::getInstance()->getTextureCache()->addImage(texturePath);
        Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat::RGBA8888);

        data = loadSkeletonData(fullJsonPath, fullAtlasPath);
//        data->strPath = (char *)jsonPath.c_str();
        skeletonRenderers.insert(make_pair(key, data));
    }else{
        data = it->second;
//        printf("key-2:%s\n", jsonPath.c_str());
    }
    
    spine::SkeletonAnimation* animation = spine::SkeletonAnimation::createWithData(data);
    animation->setToSetupPose();
    //animation->setSlotsToSetupPose();
    //animation->update(0);
//    animation->setOriginScale(scale);

    return animation;
}

void SpineCache::unloadSpine(const std::string &jsonPath, const std::string &atlasPath, const std::string & texturePath){
    auto key = FileUtils::getInstance()->fullPathForFilename(jsonPath);
    auto it = skeletonRenderers.find(key);
    if (it != skeletonRenderers.end()) {
        log("remove key:%s", it->first.c_str());
        
        spSkeletonData_dispose(it->second);
        skeletonRenderers.erase(it);
        
    }
    //log("spSkeletonData key:%s", jsonPath.c_str());
    auto tex = Director::getInstance()->getTextureCache()->getTextureForKey(texturePath);
    if(tex){
        //引用计数为大于1, 需要额外的 release
        for(int i = tex->getReferenceCount(); i > 1; i--){
            tex->release();
        }
        Director::getInstance()->getTextureCache()->removeTexture(tex);
        //log("remove texture:%s", texturePath.c_str());
    }
    else{
        //log("un remove texture:%s", texturePath.c_str());
    }
}

spSkeletonData* SpineCache::loadSkeletonData(const std::string &jsonPath, const std::string &atlasPath){
    
    auto atlas = spAtlas_createFromFile(atlasPath.c_str(), 0);
    CCASSERT(atlas, "Error reading atlas file.");
    
    auto attachmentLoader = &Cocos2dAttachmentLoader_create(atlas)->super;
    
    spSkeletonJson* json = spSkeletonJson_createWithLoader(attachmentLoader);
    json->scale = 1;
    
    spSkeletonData* skeletonData = spSkeletonJson_readSkeletonDataFile(json, jsonPath.c_str());
    CCASSERT(skeletonData, json->error ? json->error : "Error reading skeleton data.");
    spSkeletonJson_dispose(json);
    
    return skeletonData;
}

void SpineCache::loadSpineInThread(){
    SpineInfo *spineInfo = nullptr;
    
    while (true){
        std::queue<SpineInfo*> *pQueue = loadQueue;
        
        loadQueueMutex.lock();
        if (pQueue->empty()){
            loadQueueMutex.unlock();
            std::unique_lock<std::mutex> lk(sleepMutex);
            sleepCondition.wait(lk);
            continue;
        }else{
            spineInfo = pQueue->front();
            pQueue->pop();
            loadQueueMutex.unlock();
        }
        
        bool needLoad = false;
        
        
        
        auto key = spineInfo->jsonPath;
        auto it = skeletonRenderers.find(key);
        
        if( it == skeletonRenderers.end() ){
            completedQueueMutex.lock();
            SpineInfo *completeSpineInfo;
            size_t pos = 0;
            size_t infoSize = completedQueue->size();
            for (; pos < infoSize; pos++){
                completeSpineInfo = (*completedQueue)[pos];
                if(completeSpineInfo->jsonPath.compare(spineInfo->jsonPath) == 0)
                    break;
            }
            completedQueueMutex.unlock();
            if(infoSize == 0 || pos == infoSize)
                needLoad = true;
        }else{
            log("key:%s", it->first.c_str());
            spineInfo->skeletonData = it->second;
        }
        
        if (needLoad){
            funMutex.lock();
            spineInfo->skeletonData = loadSkeletonData(spineInfo->jsonPath, spineInfo->atlasPath);
            funMutex.unlock();
        }
        
        // put the image info into the queue
        completedQueueMutex.lock();
        completedQueue->push_back(spineInfo);
        completedQueueMutex.unlock();
    }
}

void SpineCache::checkProgress(float dt){
    completedQueueMutex.lock();
    if (completedQueue->empty()){
        completedQueueMutex.unlock();
    }else{
        SpineInfo *spineInfo = completedQueue->front();
        completedQueue->pop_front();
        completedQueueMutex.unlock();
        
        const std::string& key = spineInfo->jsonPath;
        auto *data = spineInfo->skeletonData;
        if (data){
//            log("insert key:%s", key.c_str());
            skeletonRenderers.insert( std::make_pair(key, data) );
            if (spineInfo->callback){
                spineInfo->callback(spineInfo->jsonPath);
            }
        }
        
        delete spineInfo;
        
        --asyncRefCount;
        if (0 == asyncRefCount){
            Director::getInstance()->getScheduler()->unschedule(CC_SCHEDULE_SELECTOR(SpineCache::checkProgress), this);
        }
    }
}
