//
//  AppGameConfig.hpp
//  popbirds
//
//  Created by He_bi on 16/7/13.
//
//

#ifndef AppGameConfig_hpp
#define AppGameConfig_hpp

#include <stdio.h>
#include "cocos2d.h"

class AppGameConfig {
    
public:
    static bool GetIsSkipLevel();
    
    static bool GetIsSkipPay();
    
    static bool GetIsRepeatedlyShowGuide();
    
    static bool GetIsOpenCheckPointPackage();
    
    static bool GetIsOpenLocalLanguage();
    
    static bool GetIsEnableHatch();
    
    static bool GetIsEncryption();
    
    static bool GetIsDebugMode();
    
    static std::string GetInitMapVersion();
    
    static std::string GetInitResVersion();
    
    static bool GetIsForceUnzip();
    
    static bool GetIsOpenAD();
    
    static bool GetIsChangeBG();
    
    static bool GetIsHotUpdateLocalLanguage();
    static bool GetIsDebugHotUpdate();
};

#endif /* AppGameConfig_hpp */
