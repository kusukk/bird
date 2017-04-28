#include "scripting/lua-bindings/auto/lua_mybo_sound_player_auto.hpp"
#include "SoundPlayer.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_mybo_sound_player_SoundPlayer_stopAllEffects(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_stopAllEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_stopAllEffects'", nullptr);
            return 0;
        }
        cobj->stopAllEffects();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:stopAllEffects",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_stopAllEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_playBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_playBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:playBackgroundMusic"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_playBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->playBackgroundMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        const char* arg0;
        bool arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:playBackgroundMusic"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "SoundPlayer:playBackgroundMusic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_playBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->playBackgroundMusic(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:playBackgroundMusic",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_playBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_getEffectsVolume(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_getEffectsVolume'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_getEffectsVolume'", nullptr);
            return 0;
        }
        double ret = cobj->getEffectsVolume();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:getEffectsVolume",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_getEffectsVolume'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_setSFXEnbale(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_setSFXEnbale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SoundPlayer:setSFXEnbale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_setSFXEnbale'", nullptr);
            return 0;
        }
        cobj->setSFXEnbale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:setSFXEnbale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_setSFXEnbale'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_stopEffect(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_stopEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "SoundPlayer:stopEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_stopEffect'", nullptr);
            return 0;
        }
        cobj->stopEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:stopEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_stopEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_pauseBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_pauseBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_pauseBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->pauseBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:pauseBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_pauseBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_willPlayBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_willPlayBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_willPlayBackgroundMusic'", nullptr);
            return 0;
        }
        bool ret = cobj->willPlayBackgroundMusic();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:willPlayBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_willPlayBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_setBackgroundMusicVolume(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_setBackgroundMusicVolume'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "SoundPlayer:setBackgroundMusicVolume");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_setBackgroundMusicVolume'", nullptr);
            return 0;
        }
        cobj->setBackgroundMusicVolume(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:setBackgroundMusicVolume",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_setBackgroundMusicVolume'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_stopBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_stopBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_stopBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->stopBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SoundPlayer:stopBackgroundMusic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_stopBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->stopBackgroundMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:stopBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_stopBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_getBackgroundMusicVolume(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_getBackgroundMusicVolume'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_getBackgroundMusicVolume'", nullptr);
            return 0;
        }
        double ret = cobj->getBackgroundMusicVolume();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:getBackgroundMusicVolume",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_getBackgroundMusicVolume'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_isBackgroundMusicPlaying(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_isBackgroundMusicPlaying'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_isBackgroundMusicPlaying'", nullptr);
            return 0;
        }
        bool ret = cobj->isBackgroundMusicPlaying();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:isBackgroundMusicPlaying",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_isBackgroundMusicPlaying'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_init(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        bool arg1;
        bool arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SoundPlayer:init");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "SoundPlayer:init");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "SoundPlayer:init");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_init'", nullptr);
            return 0;
        }
        cobj->init(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:init",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_init'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_unloadEffect(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_unloadEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:unloadEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_unloadEffect'", nullptr);
            return 0;
        }
        cobj->unloadEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:unloadEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_unloadEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_stopAudioByGroup(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_stopAudioByGroup'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:stopAudioByGroup"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_stopAudioByGroup'", nullptr);
            return 0;
        }
        cobj->stopAudioByGroup(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:stopAudioByGroup",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_stopAudioByGroup'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_loadSound(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_loadSound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_loadSound'", nullptr);
            return 0;
        }
        cobj->loadSound();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:loadSound",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_loadSound'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_pauseAllEffects(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_pauseAllEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_pauseAllEffects'", nullptr);
            return 0;
        }
        cobj->pauseAllEffects();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:pauseAllEffects",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_pauseAllEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_preloadBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_preloadBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:preloadBackgroundMusic"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_preloadBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->preloadBackgroundMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        const char* arg0;
        bool arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:preloadBackgroundMusic"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "SoundPlayer:preloadBackgroundMusic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_preloadBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->preloadBackgroundMusic(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:preloadBackgroundMusic",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_preloadBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_loadSoundCallBack(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_loadSoundCallBack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "SoundPlayer:loadSoundCallBack");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_loadSoundCallBack'", nullptr);
            return 0;
        }
        cobj->loadSoundCallBack(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:loadSoundCallBack",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_loadSoundCallBack'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_getMusicEnbale(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_getMusicEnbale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_getMusicEnbale'", nullptr);
            return 0;
        }
        bool ret = cobj->getMusicEnbale();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:getMusicEnbale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_getMusicEnbale'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_playEffect(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_playEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:playEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_playEffect'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->playEffect(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:playEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_playEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_preloadEffectForId(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_preloadEffectForId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::function<void (std::basic_string<char>)> arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SoundPlayer:preloadEffectForId");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_preloadEffectForId'", nullptr);
            return 0;
        }
        cobj->preloadEffectForId(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:preloadEffectForId",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_preloadEffectForId'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_resumeAllEffects(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_resumeAllEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_resumeAllEffects'", nullptr);
            return 0;
        }
        cobj->resumeAllEffects();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:resumeAllEffects",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_resumeAllEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_unloadEffectForId(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_unloadEffectForId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:unloadEffectForId"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_unloadEffectForId'", nullptr);
            return 0;
        }
        cobj->unloadEffectForId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:unloadEffectForId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_unloadEffectForId'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_getSFXEnbale(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_getSFXEnbale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_getSFXEnbale'", nullptr);
            return 0;
        }
        bool ret = cobj->getSFXEnbale();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:getSFXEnbale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_getSFXEnbale'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_rewindBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_rewindBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_rewindBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->rewindBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:rewindBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_rewindBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_preloadEffect(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_preloadEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:preloadEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_preloadEffect'", nullptr);
            return 0;
        }
        cobj->preloadEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:preloadEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_preloadEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_playBalloonBlast(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_playBalloonBlast'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        int arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "SoundPlayer:playBalloonBlast");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "SoundPlayer:playBalloonBlast");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_playBalloonBlast'", nullptr);
            return 0;
        }
        cobj->playBalloonBlast(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:playBalloonBlast",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_playBalloonBlast'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_resumeAudioByGroup(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_resumeAudioByGroup'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "SoundPlayer:resumeAudioByGroup"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_resumeAudioByGroup'", nullptr);
            return 0;
        }
        cobj->resumeAudioByGroup(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:resumeAudioByGroup",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_resumeAudioByGroup'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_pauseEffect(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_pauseEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "SoundPlayer:pauseEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_pauseEffect'", nullptr);
            return 0;
        }
        cobj->pauseEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:pauseEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_pauseEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_resumeBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_resumeBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_resumeBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->resumeBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:resumeBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_resumeBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_setMusicEnbale(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_setMusicEnbale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SoundPlayer:setMusicEnbale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_setMusicEnbale'", nullptr);
            return 0;
        }
        cobj->setMusicEnbale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:setMusicEnbale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_setMusicEnbale'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_changEffectsLoading(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_changEffectsLoading'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SoundPlayer:changEffectsLoading");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_changEffectsLoading'", nullptr);
            return 0;
        }
        cobj->changEffectsLoading(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:changEffectsLoading",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_changEffectsLoading'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_setEffectsVolume(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_setEffectsVolume'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "SoundPlayer:setEffectsVolume");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_setEffectsVolume'", nullptr);
            return 0;
        }
        cobj->setEffectsVolume(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:setEffectsVolume",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_setEffectsVolume'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_resumeEffect(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SoundPlayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_mybo_sound_player_SoundPlayer_resumeEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "SoundPlayer:resumeEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_resumeEffect'", nullptr);
            return 0;
        }
        cobj->resumeEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:resumeEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_resumeEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_mybo_sound_player_SoundPlayer_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"SoundPlayer",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_getInstance'", nullptr);
            return 0;
        }
        SoundPlayer* ret = SoundPlayer::getInstance();
        object_to_luaval<SoundPlayer>(tolua_S, "SoundPlayer",(SoundPlayer*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "SoundPlayer:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_mybo_sound_player_SoundPlayer_constructor(lua_State* tolua_S)
{
    int argc = 0;
    SoundPlayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_mybo_sound_player_SoundPlayer_constructor'", nullptr);
            return 0;
        }
        cobj = new SoundPlayer();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"SoundPlayer");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SoundPlayer:SoundPlayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_mybo_sound_player_SoundPlayer_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_mybo_sound_player_SoundPlayer_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (SoundPlayer)");
    return 0;
}

int lua_register_mybo_sound_player_SoundPlayer(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"SoundPlayer");
    tolua_cclass(tolua_S,"SoundPlayer","SoundPlayer","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"SoundPlayer");
        tolua_function(tolua_S,"new",lua_mybo_sound_player_SoundPlayer_constructor);
        tolua_function(tolua_S,"stopAllEffects",lua_mybo_sound_player_SoundPlayer_stopAllEffects);
        tolua_function(tolua_S,"playBackgroundMusic",lua_mybo_sound_player_SoundPlayer_playBackgroundMusic);
        tolua_function(tolua_S,"getEffectsVolume",lua_mybo_sound_player_SoundPlayer_getEffectsVolume);
        tolua_function(tolua_S,"setSFXEnbale",lua_mybo_sound_player_SoundPlayer_setSFXEnbale);
        tolua_function(tolua_S,"stopEffect",lua_mybo_sound_player_SoundPlayer_stopEffect);
        tolua_function(tolua_S,"pauseBackgroundMusic",lua_mybo_sound_player_SoundPlayer_pauseBackgroundMusic);
        tolua_function(tolua_S,"willPlayBackgroundMusic",lua_mybo_sound_player_SoundPlayer_willPlayBackgroundMusic);
        tolua_function(tolua_S,"setBackgroundMusicVolume",lua_mybo_sound_player_SoundPlayer_setBackgroundMusicVolume);
        tolua_function(tolua_S,"stopBackgroundMusic",lua_mybo_sound_player_SoundPlayer_stopBackgroundMusic);
        tolua_function(tolua_S,"getBackgroundMusicVolume",lua_mybo_sound_player_SoundPlayer_getBackgroundMusicVolume);
        tolua_function(tolua_S,"isBackgroundMusicPlaying",lua_mybo_sound_player_SoundPlayer_isBackgroundMusicPlaying);
        tolua_function(tolua_S,"init",lua_mybo_sound_player_SoundPlayer_init);
        tolua_function(tolua_S,"unloadEffect",lua_mybo_sound_player_SoundPlayer_unloadEffect);
        tolua_function(tolua_S,"stopAudioByGroup",lua_mybo_sound_player_SoundPlayer_stopAudioByGroup);
        tolua_function(tolua_S,"loadSound",lua_mybo_sound_player_SoundPlayer_loadSound);
        tolua_function(tolua_S,"pauseAllEffects",lua_mybo_sound_player_SoundPlayer_pauseAllEffects);
        tolua_function(tolua_S,"preloadBackgroundMusic",lua_mybo_sound_player_SoundPlayer_preloadBackgroundMusic);
        tolua_function(tolua_S,"loadSoundCallBack",lua_mybo_sound_player_SoundPlayer_loadSoundCallBack);
        tolua_function(tolua_S,"getMusicEnbale",lua_mybo_sound_player_SoundPlayer_getMusicEnbale);
        tolua_function(tolua_S,"playEffect",lua_mybo_sound_player_SoundPlayer_playEffect);
        tolua_function(tolua_S,"preloadEffectForId",lua_mybo_sound_player_SoundPlayer_preloadEffectForId);
        tolua_function(tolua_S,"resumeAllEffects",lua_mybo_sound_player_SoundPlayer_resumeAllEffects);
        tolua_function(tolua_S,"unloadEffectForId",lua_mybo_sound_player_SoundPlayer_unloadEffectForId);
        tolua_function(tolua_S,"getSFXEnbale",lua_mybo_sound_player_SoundPlayer_getSFXEnbale);
        tolua_function(tolua_S,"rewindBackgroundMusic",lua_mybo_sound_player_SoundPlayer_rewindBackgroundMusic);
        tolua_function(tolua_S,"preloadEffect",lua_mybo_sound_player_SoundPlayer_preloadEffect);
        tolua_function(tolua_S,"playBalloonBlast",lua_mybo_sound_player_SoundPlayer_playBalloonBlast);
        tolua_function(tolua_S,"resumeAudioByGroup",lua_mybo_sound_player_SoundPlayer_resumeAudioByGroup);
        tolua_function(tolua_S,"pauseEffect",lua_mybo_sound_player_SoundPlayer_pauseEffect);
        tolua_function(tolua_S,"resumeBackgroundMusic",lua_mybo_sound_player_SoundPlayer_resumeBackgroundMusic);
        tolua_function(tolua_S,"setMusicEnbale",lua_mybo_sound_player_SoundPlayer_setMusicEnbale);
        tolua_function(tolua_S,"changEffectsLoading",lua_mybo_sound_player_SoundPlayer_changEffectsLoading);
        tolua_function(tolua_S,"setEffectsVolume",lua_mybo_sound_player_SoundPlayer_setEffectsVolume);
        tolua_function(tolua_S,"resumeEffect",lua_mybo_sound_player_SoundPlayer_resumeEffect);
        tolua_function(tolua_S,"getInstance", lua_mybo_sound_player_SoundPlayer_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(SoundPlayer).name();
    g_luaType[typeName] = "SoundPlayer";
    g_typeCast["SoundPlayer"] = "SoundPlayer";
    return 1;
}
TOLUA_API int register_all_mybo_sound_player(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"mybo",0);
	tolua_beginmodule(tolua_S,"mybo");

	lua_register_mybo_sound_player_SoundPlayer(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

