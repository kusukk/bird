#include "lua-bind/lua_gameConfig_auto.hpp"
#include "AppGameConfig.hpp"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_AppGameConfig_AppGameConfig_GetIsHotUpdateLocalLanguage(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsHotUpdateLocalLanguage'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsHotUpdateLocalLanguage();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsHotUpdateLocalLanguage",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsHotUpdateLocalLanguage'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsOpenCheckPointPackage(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsOpenCheckPointPackage'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsOpenCheckPointPackage();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsOpenCheckPointPackage",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsOpenCheckPointPackage'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsEnableHatch(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsEnableHatch'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsEnableHatch();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsEnableHatch",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsEnableHatch'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsEncryption(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsEncryption'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsEncryption();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsEncryption",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsEncryption'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsDebugMode(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsDebugMode'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsDebugMode();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsDebugMode",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsDebugMode'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsOpenLocalLanguage(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsOpenLocalLanguage'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsOpenLocalLanguage();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsOpenLocalLanguage",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsOpenLocalLanguage'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsOpenAD(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsOpenAD'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsOpenAD();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsOpenAD",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsOpenAD'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsChangeBG(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsChangeBG'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsChangeBG();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsChangeBG",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsChangeBG'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsForceUnzip(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsForceUnzip'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsForceUnzip();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsForceUnzip",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsForceUnzip'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsSkipPay(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsSkipPay'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsSkipPay();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsSkipPay",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsSkipPay'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsSkipLevel(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsSkipLevel'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsSkipLevel();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsSkipLevel",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsSkipLevel'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsRepeatedlyShowGuide(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsRepeatedlyShowGuide'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsRepeatedlyShowGuide();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsRepeatedlyShowGuide",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsRepeatedlyShowGuide'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetIsDebugHotUpdate(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetIsDebugHotUpdate'", nullptr);
            return 0;
        }
        bool ret = AppGameConfig::GetIsDebugHotUpdate();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetIsDebugHotUpdate",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetIsDebugHotUpdate'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetInitMapVersion(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetInitMapVersion'", nullptr);
            return 0;
        }
        std::string ret = AppGameConfig::GetInitMapVersion();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetInitMapVersion",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetInitMapVersion'.",&tolua_err);
#endif
    return 0;
}
int lua_AppGameConfig_AppGameConfig_GetInitResVersion(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AppGameConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_AppGameConfig_AppGameConfig_GetInitResVersion'", nullptr);
            return 0;
        }
        std::string ret = AppGameConfig::GetInitResVersion();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AppGameConfig:GetInitResVersion",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_AppGameConfig_AppGameConfig_GetInitResVersion'.",&tolua_err);
#endif
    return 0;
}
static int lua_AppGameConfig_AppGameConfig_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (AppGameConfig)");
    return 0;
}

int lua_register_AppGameConfig_AppGameConfig(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"AppGameConfig");
    tolua_cclass(tolua_S,"AppGameConfig","AppGameConfig","",nullptr);

    tolua_beginmodule(tolua_S,"AppGameConfig");
        tolua_function(tolua_S,"GetIsHotUpdateLocalLanguage", lua_AppGameConfig_AppGameConfig_GetIsHotUpdateLocalLanguage);
        tolua_function(tolua_S,"GetIsOpenCheckPointPackage", lua_AppGameConfig_AppGameConfig_GetIsOpenCheckPointPackage);
        tolua_function(tolua_S,"GetIsEnableHatch", lua_AppGameConfig_AppGameConfig_GetIsEnableHatch);
        tolua_function(tolua_S,"GetIsEncryption", lua_AppGameConfig_AppGameConfig_GetIsEncryption);
        tolua_function(tolua_S,"GetIsDebugMode", lua_AppGameConfig_AppGameConfig_GetIsDebugMode);
        tolua_function(tolua_S,"GetIsOpenLocalLanguage", lua_AppGameConfig_AppGameConfig_GetIsOpenLocalLanguage);
        tolua_function(tolua_S,"GetIsOpenAD", lua_AppGameConfig_AppGameConfig_GetIsOpenAD);
        tolua_function(tolua_S,"GetIsChangeBG", lua_AppGameConfig_AppGameConfig_GetIsChangeBG);
        tolua_function(tolua_S,"GetIsForceUnzip", lua_AppGameConfig_AppGameConfig_GetIsForceUnzip);
        tolua_function(tolua_S,"GetIsSkipPay", lua_AppGameConfig_AppGameConfig_GetIsSkipPay);
        tolua_function(tolua_S,"GetIsSkipLevel", lua_AppGameConfig_AppGameConfig_GetIsSkipLevel);
        tolua_function(tolua_S,"GetIsRepeatedlyShowGuide", lua_AppGameConfig_AppGameConfig_GetIsRepeatedlyShowGuide);
        tolua_function(tolua_S,"GetIsDebugHotUpdate", lua_AppGameConfig_AppGameConfig_GetIsDebugHotUpdate);
        tolua_function(tolua_S,"GetInitMapVersion", lua_AppGameConfig_AppGameConfig_GetInitMapVersion);
        tolua_function(tolua_S,"GetInitResVersion", lua_AppGameConfig_AppGameConfig_GetInitResVersion);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(AppGameConfig).name();
    g_luaType[typeName] = "AppGameConfig";
    g_typeCast["AppGameConfig"] = "AppGameConfig";
    return 1;
}
TOLUA_API int register_all_AppGameConfig(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"mybo",0);
	tolua_beginmodule(tolua_S,"mybo");

	lua_register_AppGameConfig_AppGameConfig(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

