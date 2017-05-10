
//
//  SpineCache.hpp
//  popbirds
//
//  Created by Yann on 2/19/16.
//
//

#ifndef SpineCache_hpp
#define SpineCache_hpp

#include <stdio.h>
#include "editor-support/spine/SkeletonAnimation.h"
#include "editor-support/spine/Cocos2dAttachmentLoader.h"
#include "cocos2d.h"

using namespace spine;
using namespace cocos2d;

class SpineCache : public Ref{
    
public:
    static SpineCache * getInstance();
    
    SpineCache();
    ~SpineCache();

    //
    void loadSpineAsync(const std::string &jsonPath, const std::string &atlasPath, const std::string &texturePath,
                         const std::function<void(const std::string&)>& callback);
    
    SkeletonAnimation* getSpine(const std::string &jsonPath, const std::string &atlasPath, const std::string & texturePath, float scale);
    
    void unloadSpine(const std::string &jsonPath, const std::string &atlasPath, const std::string & texturePath);
    
private:
    void checkProgress(float dt);
    void loadSpineInThread();
    spSkeletonData* loadSkeletonData(const std::string &jsonPath, const std::string &atlasPath);
    const std::string getKey(const std::string &jsonPath, float scale);
    
    std::mutex funMutex;
    
protected:
    static SpineCache* instance;
    
    struct SpineInfo{
        std::string jsonPath;
        std::string atlasPath;
        std::function<void(const std::string&)> callback;
        spSkeletonData *skeletonData;
    };
    
    std::thread *loadingThread;
    
    std::queue<SpineInfo*> *loadQueue;
    std::mutex loadQueueMutex;

    std::deque<SpineInfo*> *completedQueue;
    std::mutex completedQueueMutex;
    
    std::mutex sleepMutex;
    std::condition_variable sleepCondition;
    
    int asyncRefCount;
    
    std::unordered_map<std::string, spSkeletonData*> skeletonRenderers;
};

#endif /* SpineCache_hpp */
