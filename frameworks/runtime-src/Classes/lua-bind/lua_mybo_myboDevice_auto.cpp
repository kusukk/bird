#include "scripting/lua-bindings/auto/lua_mybo_myboDevice_auto.hpp"
#include "MyboDevice.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_MyboDevice_MyboDevice_playMilieuBgMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyboDevice:playMilieuBgMusic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_playMilieuBgMusic'", nullptr);
            return 0;
        }
        MyboDevice::playMilieuBgMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2)
    {
        std::string arg0;
        bool arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyboDevice:playMilieuBgMusic");
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "MyboDevice:playMilieuBgMusic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_playMilieuBgMusic'", nullptr);
            return 0;
        }
        MyboDevice::playMilieuBgMusic(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:playMilieuBgMusic",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_playMilieuBgMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_puaseMilleuBgMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_puaseMilleuBgMusic'", nullptr);
            return 0;
        }
        MyboDevice::puaseMilleuBgMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:puaseMilleuBgMusic",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_puaseMilleuBgMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_getBuildID(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_getBuildID'", nullptr);
            return 0;
        }
        std::string ret = MyboDevice::getBuildID();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:getBuildID",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_getBuildID'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_stopMilleuBgMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_stopMilleuBgMusic'", nullptr);
            return 0;
        }
        MyboDevice::stopMilleuBgMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:stopMilleuBgMusic",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_stopMilleuBgMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_setMilleuBgMusicVolume(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        double arg0;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "MyboDevice:setMilleuBgMusicVolume");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_setMilleuBgMusicVolume'", nullptr);
            return 0;
        }
        MyboDevice::setMilleuBgMusicVolume(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:setMilleuBgMusicVolume",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_setMilleuBgMusicVolume'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_getBuildVersion(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_getBuildVersion'", nullptr);
            return 0;
        }
        std::string ret = MyboDevice::getBuildVersion();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:getBuildVersion",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_getBuildVersion'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_proloadMilleuBgMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyboDevice:proloadMilleuBgMusic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_proloadMilleuBgMusic'", nullptr);
            return 0;
        }
        MyboDevice::proloadMilleuBgMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:proloadMilleuBgMusic",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_proloadMilleuBgMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_getAppVersion(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_getAppVersion'", nullptr);
            return 0;
        }
        std::string ret = MyboDevice::getAppVersion();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:getAppVersion",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_getAppVersion'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_resumeMilleuBgMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_resumeMilleuBgMusic'", nullptr);
            return 0;
        }
        MyboDevice::resumeMilleuBgMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:resumeMilleuBgMusic",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_resumeMilleuBgMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_isMilleuBgMusicPlaying(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_isMilleuBgMusicPlaying'", nullptr);
            return 0;
        }
        bool ret = MyboDevice::isMilleuBgMusicPlaying();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:isMilleuBgMusicPlaying",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_isMilleuBgMusicPlaying'.",&tolua_err);
#endif
    return 0;
}
int lua_MyboDevice_MyboDevice_isOtherAudioPlaying(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyboDevice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyboDevice_MyboDevice_isOtherAudioPlaying'", nullptr);
            return 0;
        }
        bool ret = MyboDevice::isOtherAudioPlaying();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyboDevice:isOtherAudioPlaying",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyboDevice_MyboDevice_isOtherAudioPlaying'.",&tolua_err);
#endif
    return 0;
}
static int lua_MyboDevice_MyboDevice_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MyboDevice)");
    return 0;
}

int lua_register_MyboDevice_MyboDevice(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MyboDevice");
    tolua_cclass(tolua_S,"MyboDevice","MyboDevice","",nullptr);

    tolua_beginmodule(tolua_S,"MyboDevice");
        tolua_function(tolua_S,"playMilieuBgMusic", lua_MyboDevice_MyboDevice_playMilieuBgMusic);
        tolua_function(tolua_S,"puaseMilleuBgMusic", lua_MyboDevice_MyboDevice_puaseMilleuBgMusic);
        tolua_function(tolua_S,"getBuildID", lua_MyboDevice_MyboDevice_getBuildID);
        tolua_function(tolua_S,"stopMilleuBgMusic", lua_MyboDevice_MyboDevice_stopMilleuBgMusic);
        tolua_function(tolua_S,"setMilleuBgMusicVolume", lua_MyboDevice_MyboDevice_setMilleuBgMusicVolume);
        tolua_function(tolua_S,"getBuildVersion", lua_MyboDevice_MyboDevice_getBuildVersion);
        tolua_function(tolua_S,"proloadMilleuBgMusic", lua_MyboDevice_MyboDevice_proloadMilleuBgMusic);
        tolua_function(tolua_S,"getAppVersion", lua_MyboDevice_MyboDevice_getAppVersion);
        tolua_function(tolua_S,"resumeMilleuBgMusic", lua_MyboDevice_MyboDevice_resumeMilleuBgMusic);
        tolua_function(tolua_S,"isMilleuBgMusicPlaying", lua_MyboDevice_MyboDevice_isMilleuBgMusicPlaying);
        tolua_function(tolua_S,"isOtherAudioPlaying", lua_MyboDevice_MyboDevice_isOtherAudioPlaying);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MyboDevice).name();
    g_luaType[typeName] = "MyboDevice";
    g_typeCast["MyboDevice"] = "MyboDevice";
    return 1;
}
TOLUA_API int register_all_MyboDevice(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"mybo",0);
	tolua_beginmodule(tolua_S,"mybo");

	lua_register_MyboDevice_MyboDevice(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

