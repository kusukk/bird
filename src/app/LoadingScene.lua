--
-- Author: pengxianfeng
-- Date: 2017-04-27 18:18:48
--

require "app.config.config"
local utils = require("app.utils.utils")
local UserData = require ("app.data.UserData")
-- local SchedulerManager = require "app.mapscene.SchedulerManager"
local elementsRes = require("app.config.ElementsResourceLoad")
local loadingLayer = require('app.LoadingLayer')

require "app.mapscene.LevelLayout"
require "app.mapscene.Layout"
local LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

local loadingScene = nil

function LoadingScene:getInstance()
    if loadingScene == nil then
        loadingScene = LoadingScene.new()
        loadingScene:retain()
    end
    if loadingScene.listener == nil then
        loadingScene:regListener()
    end

    return loadingScene
end

function LoadingScene:onExit()
    --dump("LoadingScene:onExit")
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener)
    self.listener = nil
end

function LoadingScene:ctor()
    self.lastScene = "app.StartAndUpdateScene"  -- 默认startScene
    self.currentScene = nil
    self.listener = nil
    -- 元素资源
    self.lastEleRes = nil
    self.curEleRes = nil
    local lableConfig  = {
        text =  "loading",
        font = "fonts/ABFlockText-Bold.ttf",
        size = 45,
        color = cc.c3b(255, 255, 255),
        x = display.cx,
        y = display.cy-65,
        shadow_color = cc.c4b(0,49,86,255),
        shadow_size = cc.size(2,-2),
        shadow_radius = 1,
        self = self
    }
    self.lab =utils:createLabel(lableConfig)
    self.lab:setLocalZOrder(1000001)
    self.lab:setVisible(false)

    self.width=750.38;
    self.height=1136;
    self.scale=display.width/self.width>= display.height/self.height and  display.width/self.width or display.height/self.height
end

function LoadingScene:regListener()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(touches, event)
        return true
        end,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = loadingScene:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, loadingScene)

    loadingScene.listener = listener
end

--切换场景 统一接口
function LoadingScene:replaceScene(sceneName, ...)
    if loadingLayer:getInstance():getParent() then
        dump("返回")
        return
    end
    local data = {...}
    if UserData:getCurrentTopLevel()== 0 and sceneName=="app.mapscene.MapScene" and UserData:getIsAntion()==1 then
        UserData:setClickLevel(1)
        sceneName = "app.battlescene.BattleScene"
        local MapFactory = require('app.data.MapFactory')
        MapFactory:init(require('map')[1],'normal')
        data = {}
        data[1] = MapFactory:getLevelData(1)
    end


    cc.Director:getInstance():getRunningScene():addChild(loadingLayer:getInstance(),1000000)

    --先清掉垃圾数据
    local info = data
    loadingLayer:getInstance():onBegin(function()
        AdministrateFrame:getInstance():clear()
        loadingLayer:getInstance():onLoop();
        loadingLayer:getInstance():removeFromParent()
        self:addChild(loadingLayer:getInstance())
        -- SchedulerManager:getInstance():allStop()
        display.replaceScene(self)

        self.currentScene = sceneName
        UserData:setCurrentScene(sceneName)
        -- 进出battleScene，判断元素资源加卸载
        if self.lastScene == "app.battlescene.BattleScene" then
            self.lastEleRes = self.curEleRes
        else
            self.lastEleRes = nil
        end
        if self.currentScene == "app.battlescene.BattleScene" then
            self.curEleRes = elementsRes.getElementResource(clone(unpack(info)))
        else
            self.curEleRes = nil
        end
        -- get resource
        self:getLoadingProfiles(info)
        self.completeCallBack = function()
                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
                display.replaceScene(require(sceneName).new(unpack(info)))
                -- cc.Director:getInstance():replaceScene(require(sceneName).new(unpack(info)))
            end
        -- 延迟卸载，加载资源
        local delay1 = cc.DelayTime:create(0.3)
        local delay2 = cc.DelayTime:create(0.3)
        local unloadFun = cc.CallFunc:create(function()
                self:unload(self.unloadTable)
                self:unload(self.extraUnload)
            end)

        -- 先加载rgba8888
        local loadFun8888 = cc.CallFunc:create(function()
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
            -- dump(self.loadTable8888, "debug 8888")
            self:loadRGBA8888(self.loadTable8888 , function()
                -- load rgba8888 再load rgba4444
                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
                -- dump(self.loadTable,"loadTable")
                self:load(self.loadTable , self.completeCallBack)
            end)
        end)
        self:runAction(cc.Sequence:create(unloadFun,loadFun8888))
        -- self:runAction(cc.Sequence:create(delay1, unloadFun, delay2, loadFun8888))
    end)


    -- self.birdJumpSpine:setToSetupPose()

    -- if self.lastScene then


end

function LoadingScene:getLoadTableLength(loadTable)
    loadTable = loadTable or {}
    local ret = 0
    local audio = utils.json2lua("audio/config.json").audio
    local audioName
    local audioNameCfg
    for k,v in pairs(loadTable) do
        if type(v) == 'table' then
            --audio
            if v[1] == 3 then
                audioName = v[2] or ''
                audioNameCfg = audio[tostring(audioName)] or {}
                if type(audioNameCfg) == 'table' and audioNameCfg[8] and type(audioNameCfg[8]) == 'table' then
                    for m,n in pairs(audioNameCfg[8]) do
                        if string.len(n) > 4 then --x.m4a or x.ogg
                            ret = ret + 1
                        end
                    end

                end
            else
                ret = ret + 1
            end
        end
    end

    return ret
end

--根据场景从配置表中获取加载内容
function LoadingScene:getLoadingProfiles(info)
    self.sceneProfiles = require("app.config.resources")
    self.loadTable = {}   -- 加载
    self.loadTable8888 = {}   -- 加载8888
    self.unloadTable = {}   -- 卸载
    self.keepTable = {}   -- 不卸载
    self.extraUnload = {}  -- 额外卸载
    if self.lastScene ~= nil then
        self.unloadTable = clone(self.sceneProfiles[self.lastScene]["load"])
        local unload8888 = clone(self.sceneProfiles[self.lastScene]["loadRGBA8888"] or {})
        -- 卸载rgba8888
        table.insertto(self.unloadTable, unload8888)
        self.keepTable = clone(self.sceneProfiles[self.lastScene]["keep"])
        self.extraUnload = clone(self.sceneProfiles[self.lastScene]["extraUnload"])
        UserData:setLastScene(self.lastScene)
    end
    -- 默认资源加载
    local resource = clone(self.sceneProfiles[self.currentScene]["load"])
    local resource8888 = clone(self.sceneProfiles[self.currentScene]["loadRGBA8888"] or {})
    self.loadTable = resource
    table.insertto(self.loadTable8888, resource8888)

    local unlockCloud = (info[1]==1 or info[1]==2) and (self:getCloudLevel(true)-ScrollLevelNum)==UserData:getCurrentTopLevel()
    -- 首次直接进入第一关
    if  self.currentScene=="app.mapscene.MapScene" then
        if info[3] then
            local oneResources = require "app.config.OneResources"
            local oneResources8888 = oneResources.rgba8888 or {}
            oneResources.rgba8888 = nil
            table.insertto(self.loadTable, oneResources)
            table.insertto(self.loadTable8888, oneResources8888)
        elseif unlockCloud then
            local spMap,rgb8888Map = self:setCloudSpine()
            table.insertto(self.loadTable8888, rgb8888Map)
            table.insertto(self.loadTable, spMap)
        else
            local spMap , rgb8888Map=self:setSpine()
            table.insertto(self.loadTable8888, rgb8888Map)
            table.insertto(self.loadTable, spMap)
        end
    end

    -- 元素的加卸载资源
    if self.curEleRes then
        -- dump(self.curEleRes, "debug aaa")
        local effect = self.curEleRes.effect
        local sound = self.curEleRes.sound
        local element8888 = self.curEleRes.rgba8888 or {}
        for k,v in pairs(effect) do
            table.insert(self.loadTable, v)
        end
        for k,v in pairs(sound) do
            table.insert(self.loadTable, {3,v})
        end
        -- element rgba8888
        table.insertto(self.loadTable8888, element8888)
        -- dump(self.loadTable, "debug aa1")
    end
    if self.lastEleRes then
        -- dump(self.lastEleRes, "debug bbb")
        local effect = self.lastEleRes.effect
        local sound = self.lastEleRes.sound
        local element8888 = self.lastEleRes.rgba8888 or {}
        for k,v in pairs(effect) do
            table.insert(self.unloadTable, v)
        end
        for k,v in pairs(sound) do
            table.insert(self.unloadTable, {3,v})
        end
        -- rgba8888
        table.insertto(self.unloadTable, element8888)
        -- dump(self.unloadTable, "debug bb1")
    end

    -- log
    -- print("==> lastScene:", self.lastScene)
    -- print("==> currentScene:", self.currentScene)

    -- 卸载列表删除不卸载的
    if #self.keepTable ~= 0 then
        for i=#self.unloadTable,1,-1 do
            for j,v in ipairs(self.keepTable) do
                if self:tabEqual(self.unloadTable[i], v) then
                    table.remove(self.unloadTable, i)
                    break
                end
            end
        end
    end
    --
    -- -- 筛选 将加载列表和卸载列表中重复的删除
    -- if self.unloadTable ~= nil then
    --     for i=#self.loadTable,1,-1 do
    --         for j=#self.unloadTable,1,-1 do
    --             if self:tabEqual(self.loadTable[i], self.unloadTable[j]) then
    --                 table.remove(self.loadTable, i)
    --                 table.remove(self.unloadTable, j)
    --                 break
    --             end
    --         end
    --     end
    -- end

    self.lastScene = self.currentScene
end


function LoadingScene:rectIntersectsRect( rect1, rect2 ,contentScale)
    local intersect = not (
    -- rect1.x > rect2.x + rect2.width or
                    -- rect1.x + rect1.width < rect2.x         or
                    rect1.y > (rect2.y + rect2.height)* contentScale       or
                    rect1.y + rect1.height < rect2.y*contentScale )
    return intersect
end

function LoadingScene:setCloudSpine()
    local sp = {};
    local rgb8888sp = {}
    local maxLevel = self:getCloudLevel(true)
    local minLevel = maxLevel-ScrollLevelNum-5
    local exist = false
    local count = 0
    for i,v in ipairs(layout.animation) do
        if v.runLevel and v.runLevel>minLevel and v.runLevel<maxLevel then
            exist = false
            if v.rgb==true then
                count = #rgb8888sp
                for i=1,count do
                    if v.name..".json"==rgb8888sp[i][2] then
                        exist = true
                        break
                    end
                end
                if not exist then
                    table.insert(rgb8888sp,{2,v.name..".json" ,v.name..".atlas" ,v.name ..".png"})
                end
            else
                count = #sp
                for i=1,count do
                    if v.name..".json"==sp[i][2] then
                        exist = true
                        break
                    end
                end
                if not exist then
                    table.insert(sp,{2,v.name..".json" ,v.name..".atlas" ,v.name ..".png"})
                end
            end
        end
    end

    return sp,rgb8888sp
end

function LoadingScene:getCloudLevel(playAnim)
    -- topLevel 地图显示的最高关卡
    local topLevel = playAnim and UserData:getCurrentTopLevel() or UserData:getCurrentTopLevel()+1
    topLevel = topLevel>0 and topLevel or 1
    topLevel = topLevel<MaxMapUnlock and topLevel or MaxMapUnlock
    local currChapterNum = math.floor(topLevel/ChapterLevelNums)+1
    if topLevel%ChapterLevelNums==0 then
        currChapterNum = currChapterNum-1
    end
    -- 返回cloud所在关卡的位置
    return currChapterNum*ChapterLevelNums+ScrollLevelNum
end

function LoadingScene:setSpine()
        local contentScale=1.2
        local Ssize = cc.size(display.width,display.height)
        local rect = {};
        local rect2= {};
        local levels  =  UserData:getClickLevel()

        if not levels then
             levels=1
        elseif levels > #levelLayout.levels then
            levels=#levelLayout.levels
        end

        rect.y =levelLayout.levels[levels][2]-display.height*0.5
        local sp ={};
        local rgb8888sp={}

    for i,v in ipairs(layout.animation) do
        rect.height =Ssize.height/(v.ratioY or 1)
        rect2.y=(v.posY-v.oriY)/(v.ratioY or 1)
        rect2.height =v.height/(v.ratioY or 1)
        if self:rectIntersectsRect(rect,rect2,contentScale) then
            if v.rgb ==true then

                local b =true
                for i=1,#rgb8888sp do
                    if v.name..".json"==rgb8888sp[i][2] then
                        b=false
                        break;
                    end
                end
                if b then
                    table.insert(rgb8888sp,{2,v.name..".json" ,v.name..".atlas" ,v.name ..".png"})
                end
            else
                local b =true
                for i=1,#sp do
                    if v.name..".json"==sp[i][2] then
                        b=false
                        break;
                    end
                end
                if b then
                    table.insert(sp,{2,v.name..".json" ,v.name..".atlas" ,v.name ..".png"})
                end
            end

        end
    end


    return sp , rgb8888sp

end


--卸载素材（不区分后缀）
function LoadingScene:unload(deletetable)
    -- dump(deletetable, 'deletetable')
     if #deletetable > 0 then
        for i,v in ipairs(deletetable) do
            if v[1] == 0 then
                self:removeImageAsync(v[2])
            elseif v[1] == 1 then
                self:removeFrames(v[2], v[3])
            elseif v[1] == 2 then
                local extends = self:mysplit(v[2],".")
                self:removeSpine(v[2], v[3], v[4])
            elseif v[1] == 3 then
                -- sfx
                -- dump(v[2],"debug unload")
                self:unLoadSound(v[2])
            end
        end
    end
end

function LoadingScene:removeImageAsync(imagePath)
    --print("==> unload: removeImageAsync:", imagePath)
    display.removeSpriteFrameByImageName(imagePath)
end

function LoadingScene:removeFrames(filePathPlist, filePathPvr)
    --print("==> unload: removeFrames:", filePathPlist, filePathPvr)
    display.removeSpriteFramesWithFile(filePathPlist , filePathPvr)
end

function LoadingScene:removeSpine(json, atlas, texture)
    --print("==> unload: removeSpine:", spinePath)
    mybo.SpineCache:getInstance():unloadSpine(json, atlas, texture)
end

-- 优先加载 rgba8888 资源
function LoadingScene:loadRGBA8888(loadTable8888, completeCallBack8888)
    self.completeCallBack8888 = completeCallBack8888
    if #loadTable8888 == 0 then
        self.completeCallBack8888()
        return
    end

    -- 计数，用来判断是否全部加载完毕
    self.totalLength8888      = #loadTable8888
    self.currentLoadIndex8888 = 0

    for i,v in ipairs(loadTable8888) do
        if v[1] == 0 then
            self:addImageAsync8888(v[2])
        elseif v[1] == 1 then
            self:addSpriteFrames8888(v[2], v[3])
        elseif v[1] == 2 then
            self:loadSpine8888(v[2], v[3], v[4])
        end
    end
end

function LoadingScene:addImageAsync8888(imagePath)
    display.addImageAsync(imagePath , function()
        --print("==> load: addImageAsync8888 : ", imagePath)
        self.currentLoadIndex8888 = self.currentLoadIndex8888 + 1
        if self.currentLoadIndex8888 == self.totalLength8888 then
            self.completeCallBack8888()
        end
    end)
end

function LoadingScene:addSpriteFrames8888(imagePathPlist, imagePathPvr)
    display.addSpriteFrames(imagePathPlist, imagePathPvr, function()
        -- print("==> load: addSpriteFrames8888 : ", imagePathPlist, imagePathPvr)
        self.currentLoadIndex8888 = self.currentLoadIndex8888 + 1
        if self.currentLoadIndex8888 == self.totalLength8888 then
            self.completeCallBack8888()
        end
    end)
end

--加载spine素材
function LoadingScene:loadSpine8888(json, atlas, texture)
    --print("==> 111 load: loadSpine8888 : ", json, atlas, texture)
    mybo.SpineCache:getInstance():loadSpineAsync(json,atlas,texture,function()
        --print("==> 222 load: loadSpine8888 : ", json, atlas, texture)
        self.currentLoadIndex8888 = self.currentLoadIndex8888 + 1
        if self.currentLoadIndex8888 == self.totalLength8888 then
            self.completeCallBack8888()
        end
    end)
end

--默认加载素材
function LoadingScene:load(loadTable, completeCallBack)
    self.completeCallBack = completeCallBack
    if #loadTable == 0 then
        self.completeCallBack()
        return
    end

    -- 计数，用来判断是否全部加载完毕
    self.totalLength      = self:getLoadTableLength(loadTable)
    self.currentLoadIndex = 0

    for i,v in ipairs(loadTable) do
        if v[1] == 0 then
            self:addImageAsync(v[2])
        elseif v[1] == 1 then
            self:addSpriteFrames(v[2], v[3])
        elseif v[1] == 2 then
            self:loadSpine(v[2], v[3], v[4])
        elseif v[1] == 3 then
            -- sfx
            -- dump(v[2],"debug load")
            self:loadSound(v[2])
        end
    end
end

function LoadingScene:addImageAsync(imagePath)
    display.addImageAsync(imagePath , function()
        -- print("==> load: addImageAsync : ", imagePath)
        self.currentLoadIndex = self.currentLoadIndex + 1
        -- print("cur_index:",self.currentLoadIndex,'totalIndex:',self.totalLength)
        if self.currentLoadIndex == self.totalLength then
            self.completeCallBack()
        end
    end)
end

function LoadingScene:addSpriteFrames(imagePathPlist, imagePathPvr)
    display.addSpriteFrames(imagePathPlist, imagePathPvr, function()
        -- print("==> load: addSpriteFrames : ", imagePathPlist, imagePathPvr)
        self.currentLoadIndex = self.currentLoadIndex + 1
        -- print("cur_index:",self.currentLoadIndex,'totalIndex:',self.totalLength)
        if self.currentLoadIndex == self.totalLength then
            self.completeCallBack()
        end
    end)
end

--加载spine素材
function LoadingScene:loadSpine(json, atlas, texture)
    --print("==> 111 load: loadSpine : ", json, atlas, texture)
    mybo.SpineCache:getInstance():loadSpineAsync(json,atlas,texture,function()
        -- print("==> 222 load: loadSpine : ", json, atlas, texture)
        self.currentLoadIndex = self.currentLoadIndex + 1
        -- print("cur_index:",self.currentLoadIndex,'totalIndex:',self.totalLength)
        if self.currentLoadIndex == self.totalLength then
            self.completeCallBack()
        end
    end)
end

-- 加载音效
function LoadingScene:loadSound(name)
    if not name or name == "" then
        print("ERR:loadSound...")
        return
    end
    mybo.SoundPlayer:getInstance():preloadEffectForId(name,function(newName)
        -- 判断是否都加载完成
        self.currentLoadIndex = self.currentLoadIndex + 1
        -- print("audio callback name:",newName,self.currentLoadIndex,self.totalLength)
        if self.currentLoadIndex == self.totalLength then
            self.completeCallBack()
        end
    end)
end

-- 卸载音效
function LoadingScene:unLoadSound(name)
    if not name or name == "" then
        print("ERR:unLoadSound...")
        return
    end
    mybo.SoundPlayer:getInstance():unloadEffectForId(name)
end

-- 单独加载StartScene
function LoadingScene:loadStartSceneRes(callback)
    local sceneProfiles = require("app.config.resources")
    local loadTable = clone(sceneProfiles["app.StartAndUpdateScene"]["load"])
    self:load(loadTable, callback)
end

function LoadingScene:mysplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

-- 判断table是否相等
function LoadingScene:tabEqual(tab1, tab2)
    if #tab1 ~= #tab2 then
        return false
    end
    for i=1, #tab1 do
        if tab1[i] ~= tab2[i] then
            return false
        end
    end
    return true
end


return LoadingScene
