#include "scripting/lua-bindings/auto/lua_mybo_spineCache_auto.hpp"
#include "SpineCache.hpp"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_spineCache_SpineCache_getSpine(lua_State* tolua_S)
{
    int argc = 0;
    SpineCache* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SpineCache",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SpineCache*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_spineCache_SpineCache_getSpine'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        double arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SpineCache:getSpine");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SpineCache:getSpine");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SpineCache:getSpine");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "SpineCache:getSpine");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_spineCache_SpineCache_getSpine'", nullptr);
            return 0;
        }
        spine::SkeletonAnimation* ret = cobj->getSpine(arg0, arg1, arg2, arg3);
        object_to_luaval<spine::SkeletonAnimation>(tolua_S, "sp.SkeletonAnimation",(spine::SkeletonAnimation*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SpineCache:getSpine",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_spineCache_SpineCache_getSpine'.",&tolua_err);
#endif

    return 0;
}
int lua_spineCache_SpineCache_loadSpineAsync(lua_State* tolua_S)
{
    int argc = 0;
    SpineCache* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SpineCache",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SpineCache*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_spineCache_SpineCache_loadSpineAsync'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::function<void (const std::basic_string<char> &)> arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SpineCache:loadSpineAsync");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SpineCache:loadSpineAsync");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SpineCache:loadSpineAsync");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_spineCache_SpineCache_loadSpineAsync'", nullptr);
            return 0;
        }
        cobj->loadSpineAsync(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SpineCache:loadSpineAsync",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_spineCache_SpineCache_loadSpineAsync'.",&tolua_err);
#endif

    return 0;
}
int lua_spineCache_SpineCache_unloadSpine(lua_State* tolua_S)
{
    int argc = 0;
    SpineCache* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SpineCache",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SpineCache*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_spineCache_SpineCache_unloadSpine'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SpineCache:unloadSpine");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SpineCache:unloadSpine");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SpineCache:unloadSpine");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_spineCache_SpineCache_unloadSpine'", nullptr);
            return 0;
        }
        cobj->unloadSpine(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SpineCache:unloadSpine",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_spineCache_SpineCache_unloadSpine'.",&tolua_err);
#endif

    return 0;
}
int lua_spineCache_SpineCache_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"SpineCache",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_spineCache_SpineCache_getInstance'", nullptr);
            return 0;
        }
        SpineCache* ret = SpineCache::getInstance();
        object_to_luaval<SpineCache>(tolua_S, "SpineCache",(SpineCache*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "SpineCache:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_spineCache_SpineCache_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_spineCache_SpineCache_constructor(lua_State* tolua_S)
{
    int argc = 0;
    SpineCache* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_spineCache_SpineCache_constructor'", nullptr);
            return 0;
        }
        cobj = new SpineCache();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"SpineCache");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SpineCache:SpineCache",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_spineCache_SpineCache_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_spineCache_SpineCache_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (SpineCache)");
    return 0;
}

int lua_register_spineCache_SpineCache(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"SpineCache");
    tolua_cclass(tolua_S,"SpineCache","SpineCache","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"SpineCache");
        tolua_function(tolua_S,"new",lua_spineCache_SpineCache_constructor);
        tolua_function(tolua_S,"getSpine",lua_spineCache_SpineCache_getSpine);
        tolua_function(tolua_S,"loadSpineAsync",lua_spineCache_SpineCache_loadSpineAsync);
        tolua_function(tolua_S,"unloadSpine",lua_spineCache_SpineCache_unloadSpine);
        tolua_function(tolua_S,"getInstance", lua_spineCache_SpineCache_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(SpineCache).name();
    g_luaType[typeName] = "SpineCache";
    g_typeCast["SpineCache"] = "SpineCache";
    return 1;
}
TOLUA_API int register_all_spineCache(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"mybo",0);
	tolua_beginmodule(tolua_S,"mybo");

	lua_register_spineCache_SpineCache(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

