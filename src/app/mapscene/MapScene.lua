--
-- Author: pengxianfeng
-- Date: 2017-04-27 18:28:20
--
require "app.config.config"
require('app.consts')

local MapFactory = require('app.data.MapFactory')
local MapSceneUI = require "app.mapscene.MapSceneUI"
local utils = require("app.utils.utils")
local PropResUtils = require("app.config.PropResUtils")
local UserData = require ("app.data.UserData")
local SchedulerManager = require "app.mapscene.SchedulerManager"
local LoadingScene = require("app.LoadingScene")
local LoadingLayer = require('app.LoadingLayer')

local LineData = require "app.mapscene.LineData"
local ButtonView = require "app.mapscene.ButtonView"
local ParallaxNode = require "app.mapscene.ParallaxNode"
local MovePanel = require "app.mapscene.MovePanel"
local MapBox = require "app.mapscene.MapBox"
-- local ADManage = require('app.common.ADManage')
-- local ADConfig = require('app.config.adsConfig')

require "app.mapscene.Layout"
require "app.mapscene.LevelLayout"
-- require "app.network.ServerProxy"
require("socket")
-- require "app.data.FriendsData"
-- require "app.data.piggyTowerData"
local StartAndUpdateScene = require "app.StartAndUpdateScene"

local MapScene = class("MapScene", function () return display.newScene("MapScene") end)
function MapScene:onEnter()
    self.isTouchMoved = false
    LoadingLayer:getInstance():removeFromParent()
    self:addChild(LoadingLayer:getInstance(),10000)
    self:performWithDelay(function ()
        LoadingLayer:getInstance():onEnd()
        if self.unlockCloud then
            -- 云消失的动画
            if self.cloudLevel >= MaxMapUnlock then
                self.mapLock:setVisible(false)
            end
            self.mapLock:setAnimation(0,"run",false) --85帧的run动画
            if self.parallaxLayer:getChildByTag(501) then
                -- 黑色遮罩和云同步消失
                local fadeOut = cc.FadeOut:create(1.2)
                local autoRemove = cc.RemoveSelf:create()
                self.parallaxLayer:getChildByTag(501):runAction(cc.Sequence:create(fadeOut,autoRemove))
                self.parallaxLayer:getChildByTag(502):runAction(cc.Sequence:create(fadeOut:clone(),autoRemove:clone()))
            end
            -- 创建新的maplock
            self.mapLock = self:createMapCloudLock(false)
            -- 更新scrollView长度
            scrollSize = cc.size(layout.mapWidth, self.mapLock:getPositionY()+150)
            self.scrollView:setContentSize(scrollSize)

            -- 开启新的关卡的hatchling的动画，暂停遮罩里的hatchling的动画
            local hatchlingCount = self.cloudLevel-ScrollLevelNum
            self.buttonView:setShowHatchingLevel(hatchlingCount)
            for i=1,hatchlingCount do
                self.buttonView:resumeHatchlingByLevel(i)
            end
            for i=hatchlingCount+1,self.cloudLevel do
                self.buttonView:pauseHatchlingByLevel(i)
            end
        end
    end,0.01)

  -- self:playCutSubjectMusic( self.firstSubjectHeight)
end

function MapScene:ctor(type,levelP,newAction)
    -- 预加载广告
    -- if not newAction then
    --     if not utils.getInternetConnectionStatus()  then
    --         ADManage:preLoadAd()
    --     end
    -- else
    --     self:performWithDelay(function ()
    --         if not utils.getInternetConnectionStatus()  then
    --             ADManage:preLoadAd()
    --         end
    --     end,4)
    -- end
    --custom criteria上传用户的当前最大关卡
    -- mybo.HatchSDK:getInstance():setProfileFieldInt("currentLevel",UserData:getCurrentLevel())
    -- --用户的金币余额
    -- mybo.HatchSDK:getInstance():setProfileFieldInt("bal_gold",UserData:getGoldCoin())

    --dump(type,UserData:getIsAntion())
    --dump(UserData:getIsAntion())
    if type~="dailymission" and UserData:getIsAntion()==1 then
        type=1
        UserData:setIsAntion(0)
    end
    -- local mask =MaskLayer:getInstance();
    AdministrateFrame:getInstance():clear()
    local layer = display.newLayer()
    layer:setName("layer_1")
    layer:addTo(self)
    GUideCurrSate = "stop"
    -- 创建大地图
    local mapLayer = self:createMapLayer(type,newAction)
    mapLayer:addTo(layer)

    self:showBattleSceneEvent()
    self.ui = MapSceneUI.new(newAction)
    self.ui:setName("MapSceneUI")
    self.ui:addTo(layer)
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end
    if self.parallaxLayer and UserData:getCurrentTopLevel()==#levelLayout.levels then
        local pigTowerBtn=  self:showPigTowerBtn(0,0)
        if pigTowerBtn then
            self.parallaxLayer:addChild(pigTowerBtn,120,cc.p(1,1),cc.p(0,0))
            pigTowerBtn:setPosition(layout.mapWidth*0.5,levelLayout.levels[#levelLayout.levels][2]/1.08+370)
        end

    end
    self:registerScriptHandler(onNodeEvent)

    display.removeSpriteFrameByImageName("bg_1.png")
    display.removeSpriteFrameByImageName("bg_2.png")
    display.removeSpriteFrameByImageName("bg_3.png")
    display.removeSpriteFrameByImageName("bg_4.png")
    display.removeSpriteFrameByImageName("bg_5.png")
    display.removeSpriteFrameByImageName("bg_6.png")
    display.removeSpriteFrameByImageName("bg_7.png")
    display.removeSpriteFrameByImageName("Space.png")

    -- 检测宝箱
    self:checkChest()
    if type=="dailymission" then
        if not utils.getInternetConnectionStatus() then
            AdministrateFrame:getInstance():newBox("DailyPanel",self.ui)
        else
            AdministrateFrame:getInstance():newBox("NetworkWarnning",self);
        end
    end

    -- 用户当前关卡头像展示
    local touchUserIconLayer = display.newLayer():addTo(self)
    touchUserIconLayer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
        touchUserIconLayer:setTouchSwallowEnabled(false)
        self.isShow = false
        self.showTb = nil
        local isEnd = true
        local currLevel
        local index = 0
        local showIconAction = function(isShow,tbSp,spSize)
        if isShow then
            self.isShow = false
        else
            self.isShow = true
        end
        local num = 0
        for k2,v2 in pairs(tbSp) do
            local mov_y = num*(spSize.height+2)
            mov_y = self.isShow and mov_y or -mov_y
            -- local mov_x = self.isShow and 70 or -70
            local mov_x = self.isShow and 0.75 or 0
            self.showTb = nil
            transition.execute(v2.name,cc.EaseBounceOut:create(cc.MoveBy:create(0.2,cc.p(0,mov_y))))
            transition.execute(v2.sp,cc.Sequence:create(cc.EaseBounceOut:create(cc.MoveBy:create(0.2,cc.p(0,mov_y))),cc.CallFunc:create(function()
            transition.execute(v2.name,cc.Sequence:create(cc.ScaleTo:create(0.2,mov_x,0.7),cc.CallFunc:create(function()
                if self.isShow then
                self.showTb = tbSp
                else
                currLevel = nil
                end
                index = index +1
                if index >= table.nums(tbSp) then
                isEnd = true
                end
            end)))
            end)))
            num = num + 1
        end
      end
      local offectY = 0
	    touchUserIconLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            offectY = event.y
            self.isTouchMoved = false
          if self.buttonView.userIconTouch and isEnd then
            for k,v in pairs(self.buttonView.userIconTouch) do
                for k1,v1 in pairs(v) do
                    local spPos = v1.sp:convertToWorldSpace(cc.p(0,0))
                    if spPos.y<=display.height then
                    local spSize = v1.sp:getBoundingBox()
                    if self.showTb then
                        isEnd = false
                        index = 0
                        showIconAction(true,self.showTb,spSize)
                    end
                    if cc.rectContainsPoint(cc.rect(spPos.x-spSize.width/2,spPos.y-spSize.height/2,spSize.width,spSize.height),cc.p(event.x,event.y)) == true and currLevel ~= k then
                        isEnd = false
                        currLevel = k
                        local tbSp = self.buttonView.userIconTouch[k]
                        index = 0
                        showIconAction(self.isShow,tbSp,spSize)
                        break
                    end
                    end
                end
            end
          end
          return true
        end
        if event.name == "moved" then
            if math.abs(event.y - offectY) >=10 then
                -- print("moved----------->")
                self.isTouchMoved = true
            end
        end
        if event.name == "ended" then
            self.isTouchMoved = false
        end
        if event.name == "cancelled" then
            self.isTouchMoved = false
        end
      end)

    -- 检测piggyTower相关自动弹框
    self:checkShowPiggyBox()


    transition.execute(self,cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        -- FBLike弹框
        if UserData:getIsOpenFBLikePanel() then
            AdministrateFrame:getInstance():newBox("FBLikePanel",self);
        end
        -- 送体力弹框
        if not utils.getInternetConnectionStatus() and not UserData:hasSendFriendsLives() then
            local data = FriendsData.getFriends()
            if #data > 0 then
                AdministrateFrame:getInstance():newBox("FriendsRequestBox",self,true)
            end
        end

    end)))

    -- 检测Facebook未登录过
    transition.execute(self,cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        if UserData.getFBFirstLoginSign()==false and UserData:getLastScene()=='app.battlescene.BattleScene' then
            -- local currentLevel = UserData:getCurrentTopLevel()
            -- if math.random(1,10) < 5 and currentLevel%3 == 0 then
            if UserData:checkPlayWithFriendsTime() then
                AdministrateFrame:getInstance():newBox("PlayWithFriends",self,nil)
            end
            -- end
        end
    end)))

    if(device.platform == "ios") then
        -- 通知弹框
        transition.execute(self,cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
            if (UserData:getLife() == 0 or UserData:getCurrentTopLevel() == 7) and not cc.UserDefault:getInstance():getBoolForKey("isNotification",false) then
            AdministrateFrame:getInstance():newBox("Notification",self)
            end
        end)))
    end

    -- 广告弹框
    transition.execute(self,cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        if ADManage:isReadyWithoutCallBack(ADConfig.Popup) and ADManage:isOneGameMap() and (type~=2 and type~=1 and type~="dailymission" ) and not utils.getInternetConnectionStatus()  then
            AdministrateFrame:getInstance():newBox("AdPopupPanel",self)
        end
        ADManage:setOneGameMap(true)
    end)))

    utils:registerKeyBack(self)

    --把ad_watched和ad_offerd在这里设置为0，以便在每一关结束的时候监测玩家是否观看了视屏广告
    UserData:setAdWatched(0)
    UserData:setadOfferd(0)
    UserData:setOriScreen("map")

    -- self:scheduleStart()
end

-- 检测piggy自动弹框
function MapScene:checkShowPiggyBox()
    self:checkShowPiggyRankRewardBox(function(delay)
        self:checkShowPiggyFirstBox(dalay)
    end)
end

-- 检测赛季奖励
function MapScene:checkShowPiggyRankRewardBox(callback)
    if piggyTowerData:getLastRewardSign() and UserData:getLastScene()=='app.StartAndUpdateScene' then
        transition.execute(self,cc.Sequence:create(cc.DelayTime:create(0.98),cc.CallFunc:create(function()
            local params = {rank = piggyTowerData:getRank(), callBack = callback}
            AdministrateFrame:getInstance():newBox("TowerRankReward",self,params)
        end)))
    else
        if callback then
            callback(0.9)
        end
    end
end

-- 检测首次进入piggy
function MapScene:checkShowPiggyFirstBox(dalay)
    if piggyTowerData:checkFirst(piggyTowerData:getCheckListPhase()) then
        -- 新赛季清空礼盒标志位
        UserData:cleanPiggyLevelRewardSign()
        if piggyTowerData:checkPiggyTowerMode() and piggyTowerData:checkTower() then
            transition.execute(self,cc.Sequence:create(cc.DelayTime:create(dalay or 0.1),cc.CallFunc:create(function()
                AdministrateFrame:getInstance():newBox("TowerUnlockPanel",self)
            end)))
        end
    end
end

function MapScene:onKeyback()
    --dump("MapScene:onKeyback")
    print("isShowGuide----->",isShowGuide,GuideCurrIndex)
    if not isShowGuide then
        local keyback = AdministrateFrame:getInstance():onKeyback()
        if keyback then return end
        local panel = self.ui:getChildByName("JourneyPanel")
        if panel then
          panel:closeSelf()
          return
        end
        local bar = self.ui:getChildByName("SettingBar")
        if bar and bar.showSettingItems then
          bar.settingCallback()
          return
        end
        -- 没有其他打开界面,返回退出游戏
        AdministrateFrame:getInstance():newBox("ExitGameTip",self.ui)
    end
end

function MapScene:initOnce()
    if self.buttonView and self.panel and self.line then
        local lineSpine=mybo.SpineCache:getInstance():getSpine("hand/line.json","hand/line.atlas","hand/line.png",0.98);
        lineSpine:setTimeScale(2)
        lineSpine:setAnimation(0,"animation",false)
        self.levelItemLayer:addChild(lineSpine,-1)
        lineSpine:setPosition(cc.p(288,610))
        lineSpine:registerSpineEventHandler(function(event)
            --dump(event)
            if event.eventData.name=="run1" then
                self.buttonView:showBtnByIndex(1)
            elseif event.eventData.name=="run2" then
                self.buttonView:showBtnByIndex(2)
            elseif event.eventData.name=="run3" then
                self.buttonView:showBtnByIndex(3)
            elseif event.eventData.name=="run4" then
                self.buttonView:showBtnByIndex(4)
            elseif event.eventData.name=="run5" then
                self.buttonView:showBtnByIndex(5)
            elseif event.eventData.name=="line" then
                self.buttonView:showAllBtn(40)
                self.line:setVisible(true)
                -- self.line:setOpacity(0)
                -- self.line:runAction(cc.FadeIn:create(0.5))
            end
        end, sp.EventType.ANIMATION_EVENT)

        lineSpine:registerSpineEventHandler(function(event)
                -- self.buttonView:showAllBtn(35)
                -- self.line:setVisible(true)
                -- if self.lineSpine then
                --     self.lineSpine:retain()
                --     self.lineSpine:removeFromParent()
                --     self.lineSpine:autorelease()
                -- end
            end,sp.EventType.ANIMATION_COMPLETE)

        self.lineSpine = lineSpine
    end
end

function MapScene:scheduleStart()
    self.existSchedule = true
    local function handleBuildingConfig(data)
        if not data["dataEnable"] or not self.existSchedule then
            return
        end

        local frame = data["frame"]
        if not self.frameCount then
            self.frameCount = 0
        end
        self.frameCount = self.frameCount+1
        if self.frameCount%frame ~= 0 then return end
        self.frameCount = 0

        dump(data["topLevel"])
        UserData:setCurrentTopLevel(data["topLevel"])
        if self.mapLock and self.scrollView then
            local scrollSize = cc.size(layout.mapWidth, self.mapLock:getPositionY()+data["height"])
            self.scrollView:setContentSize(scrollSize)
        end
    end

    local function updateHttpConfig()
        local url = "http://192.168.16.39:8000/testdata.lua"
        local request = network.createHTTPRequest(function(event)
            if event.name == "completed" then
                local request = event.request
                local data = request:getResponseString()
                handleBuildingConfig(loadstring(data)())
            end
        end, url, "GET")
        request:start()
    end
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    scheduler.scheduleGlobal(updateHttpConfig,1)
end

-- 宝箱检测
function MapScene:checkChest()
    local num = UserData:getBoxNum()
    if self and self.parallaxLayer then
        if num == 0 then
            UserData:setBoxConfig({})
        else
            local mapbox = MapBox.new(self,num)
            self.parallaxLayer:addChild(mapbox,99,cc.p(1,1),cc.p(0,0))
        end
    end
end

function MapScene:onExit()
    self.line:onClear()
    if self.moveContainerSch~=0 then
        SchedulerManager:getInstance():stop(self.moveContainerSch)
        self.moveContainerSch = 0
    end

    SchedulerManager:getInstance():stop(self.value)
    -- SchedulerManager:getInstance():allStop()
    -- Mask:getInstance():clear()
end

function MapScene:setGoldIcon()
    self.ui:updateGlodCoin()
end

function MapScene:setSilverCoin()
    self.ui:updateSilverCoin()
end

function MapScene:setHpEnabled(bool)
    self.ui.hpBar:setEnabled(bool)
end

function MapScene:setCoinBoxEnabled(bool)
    self.ui.coinBox:setEnabled(bool)
end

-- 隐藏图标
function MapScene:showHpCoin(bool)
    if self.ui then
       self.ui.hpBar:setVisible(bool)
    end
end

function MapScene:showSilverCoin(bool)
    if self.ui then
       self.ui.coinBox.silverCoin:setVisible(bool)
    end
end

function MapScene:StopScrollEvent()
    local eventDispatcher = self:getEventDispatcher()
    local listener = nil
    self.scrollPos =nil
    local function handleBuyGoods(event)
        if event.state  =="down" then
            self.scrollPos = self.tableView:getContentOffset()
        elseif event.state  =="move" then
            self.tableView:setContentOffset(self.scrollPos)
        end
    end
    listener = cc.EventListenerCustom:create("MapSceneTouch.stopScroll", handleBuyGoods)
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function MapScene:showBattleSceneEvent()
    local eventDispatcher = self:getEventDispatcher()
    local listener = nil
    local function handleBuyGoods(event)
        if event.state =="showBattleScene" then
            self:runBattleScene(event.index)
        elseif event.state == "showDebugDialog" then
            self:showDebugDialog()
        elseif event.state == "showGameLevelsBox" then
            self:ShowGameLevelsBox(event.index)
        end

    end
    listener = cc.EventListenerCustom:create("MapSceneTouch.showScene", handleBuyGoods)
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function MapScene:showDebugDialog()
        self:removeFromParent()
        local layer = cc.LayerColor:create(cc.c4b(255,102,118,255))
        self:addChild(layer)

        local map = require('map')
        local colNum = 2
        self.m_ScrollView = cc.ScrollView:create(cc.size(display.width, display.height))
        self.m_ScrollView:setContentSize(cc.size(display.width, #map/colNum*120+80))
        self.m_ScrollView:setDirection(1)
        self.m_ScrollView:setPosition(cc.p(0, 0))
        layer:addChild(self.m_ScrollView)

        self.touchCount = 0
        self.beganPosX = 0
        self.movedPosX = 0
        self.isMoved =false
        local labelConfig  = {
                text = "",
                size = 50,
                color = cc.c3b(255, 255, 255),
        }
        for i=1,#map do
            local label = display.newTTFLabel(labelConfig)
            local str = map[i][1]
            label:setString(str)
            label:setAnchorPoint(cc.p(0,0.5))
            label:setPosition((i-1)%colNum*display.width/2 + 50, #map/colNum*100  - (math.floor((i-1)/colNum) * 100))
            self.m_ScrollView:addChild(label)

            label:setTouchEnabled(true)
            label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name=="began" then
                    self.isMoved = false
                    self.beganPosX = self.m_ScrollView:getContainer():getPositionY()
                    return true
                end
                if event.name == "moved" then
                    self.movedPosX = self.m_ScrollView:getContainer():getPositionY()
                    if math.abs(self.movedPosX-self.beganPosX) > 5 then
                        self.isMoved = true
                    end
                end
                if event.name == "ended" then
                    if not self.isMoved then
                        UserData.setMapName(str)
                        self:runMapScene(map[i])
                    end
                end
            end)
        end
        self.m_ScrollView:getContainer():setPosition(cc.p(0,display.height-self.m_ScrollView:getContainer():getContentSize().height))

        -- version
        local lableConfig  = {
            text = mybo.MyboDevice:getLocalString("MapScene_00001")..UserData.getAssetVersion(),
            size = 40,
            color = cc.c3b(255, 255, 255),
            x = display.width/2,
            y = 40,
            self = layer,
            anchor = cc.p(0.5,0.5)
        }
        utils:createLabel(lableConfig)

        local reloadBtn = self:genReloadMapButton()
        layer:addChild(reloadBtn)
        --self:initFacebook()
    end

function MapScene:createTouchLable(params)
    local label = display.newTTFLabel(params.config)
    label:setAnchorPoint(params.ap or cc.p(0.5,0.5))
    label:setPosition(params.pos or cc.p(0,0))
    --self:addChild(label)

    label:setTouchEnabled(true)
    label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name=="began" then
            if params.touchBeganFunc then
                return params.touchBeganFunc(label)
            else
                return true
            end
        elseif event.name == "ended" then
            if params.touchEndedFunc then
                params.touchEndedFunc(label)
            end
        end
    end)

    return label
end

function MapScene:genReloadMapButton()
    local labelConfig  = {
        text = "Reload",
        size = 64,
        color = cc.c3b(200, 200, 200),
    }
    local reloadMapLabel = self:createTouchLable({
        config = labelConfig,
        ap = cc.p(0.5, 1),
        pos = cc.p(display.width/2, 200),
        text = 'Reload',
        touchEndedFunc = function(sender)
            sender:setString('Loading...')
            require("app.MyApp").new():run()
        end
    })

    return reloadMapLabel
end

function MapScene:initFacebook()
    local labelConfig  = {
        text = "FBInvite",
        size = 64,
        color = cc.c3b(255, 0, 0),
    }
    local fbInvite = self:createTouchLable({
        config = labelConfig,
        ap = cc.p(0,1),
        pos = cc.p(0,display.height-250),
        text = 'FBInvite',
        touchEndedFunc = function(sender)
            FB.inviteFriends()
        end
    })
    fbInvite:setVisible(false)

    local fbLogin = self:createTouchLable({
        config = labelConfig,
        ap = cc.p(0,1),
        pos = cc.p(0,display.height-150),
        text = FB.isLoggedIn() and 'FBLogout' or 'FBLogin',
        touchEndedFunc = function(sender)
            -- 判断是否为无帐号状态
            if UserData:getNoHatchAccountMode() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",display.getRunningScene(), {errCode = 1})
                do return end
            end
            if FB.isLoggedIn() then
                FB.logout()
                sender:setString('FBLogin')
                fbInvite:setVisible(false)
            else
                FB.login(function()
                    sender:setString('FBLogout')
                    fbInvite:setVisible(true)
                end)
            end
        end
    })

end

function MapScene:runBattleScene(index)
    if self.touchCount~=nil then
        if self.touchCount > 0 then
            return
        end
        self.touchCount = self.touchCount + 1
    end
    LoadingScene:getInstance():replaceScene("app.battlescene.BattleScene",MapFactory:getLevelData())
    UserData:updateLevelDiff(MapFactory:getLevel())
    -- MapFactory:setLevel(index)
    -- display.replaceScene(require('app.battlescene.BattleScene').new(MapFactory:getLevelData()))
end

function MapScene:runMapScene(obj)
    MapFactory:init(obj,'normal')--MapFactory:getMode() == 'normal' and 'dig' or 'normal'
    LoadingScene:getInstance():replaceScene("app.mapscene.MapScene")
end

function MapScene:runPigTowerScene()
    MapFactory:init(MapFactory:getDefaultMap(), 'tower')
    LoadingScene:getInstance():replaceScene("app.towerscene.PigTowerScene")
end


function MapScene:createMapLayer(state,newAction)
    -- scrollSize 整个地图的宽高 winSize和display.size是一样的
    local winSize = cc.Director:getInstance():getWinSize()
    local scrollSize = cc.size(layout.mapWidth, self:getMapHeight(UserData:getCurrentLevel()))
    local Type = state

    self.scrollView = cc.ScrollView:create()
    self.scrollView:setViewSize(cc.size(winSize.width, winSize.height))
    self.scrollView:setContentSize(scrollSize)
    self.scrollView:setTouchEnabled(false)

    -- 判断ipad和iphone 设置不同的缩放比例
    local con = math.abs(display.height/16-display.width/9)
    local contScale =1
    if con>1 then
        contScale=1.2
        MapFactory:setWinFormat(1)
    else
        contScale=1
        MapFactory:setWinFormat(0)
    end
    -- if newAction then

        self.scrollView:getContainer():scale(display.width/(layout.mapWidth+40))
    -- else
    --     self.scrollView:getContainer():scale(contScale)
    -- end

    self.scrollView:setPosition(cc.p(0,0))
    self.scrollView:ignoreAnchorPointForPosition(true)
    self.scrollView:setDelegate()
    self.scrollView:updateInset()
    self.scrollView:setMaxScale(contScale)
    self.scrollView:setMinScale(contScale)
    self.scrollView:setClippingToBounds(true)
    self.scrollView:setBounceable(true)
    -- 创建视差图层
    self.parallaxLayer = ParallaxNode.new()
    self.parallaxLayer:setPosition(0,0)
    self.parallaxLayer:addTo(self.scrollView)
    -- 画线
    self.line = self:genLineNode()
    self.levelItemLayer = display.newNode()
    self.levelItemLayer:addChild(self.line)

    -- self.mapLock = self:createMapLock()
    self.cloudLevel = 0
    self.mapLock = self:createMapCloudLock(Type==1 or Type==2)
    scrollSize = cc.size(layout.mapWidth, self.mapLock:getPositionY()+150)
    self.scrollView:setContentSize(scrollSize)

    local levelP = UserData:getClickLevel()
    local pointX,pointY= self:getLevelPos(levelP)

    -- 创建关卡动画
    local movePanel = MovePanel.new()
    -- 创建关卡按钮
    self.buttonView = ButtonView.new(self.levelItemLayer,levelLayout,Type==1 or Type==2 ,function (idx)
        movePanel:onClick(self.buttonView:getChildByName(idx),idx)
    end)

    local function moveBtn()
        if Type==1 or Type==2 then
            movePanel:move(Type==2 and true or false,self.buttonView:getChildByName(""..UserData:getCurrentTopLevel()+1),self.buttonView:getChildByName(""..UserData:getCurrentTopLevel()),self)
        elseif Type==3 or Type==4  then
            movePanel:openLevel(Type)
        end

        local clickLevel= UserData:getClickLevel();
        if UserData:getClickLevel() > MapFactory:getMaxLevel() then
            clickLevel=MapFactory:getMaxLevel()
        end
        movePanel:setBirdScale(self.buttonView:getChildByName(clickLevel))
    end

    local unlockCloud = (Type==1 or Type==2) and (self.cloudLevel-ScrollLevelNum)==UserData:getCurrentTopLevel()
    self.unlockCloud = unlockCloud
    -- 地图放大缩小动画
    self.moveContainerSch = SchedulerManager:getInstance():setFun(function ()
        self.parallaxLayer:update()
        self:setMap(newAction or unlockCloud)
        self:setSpine()
        self:setLineData()
    end)
    SchedulerManager:getInstance():starts()

    if newAction then
        -- 这是两个回调函数
        local createLayer = movePanel:createLayer(10002)
        local removelayer = movePanel:removeLayer(10002)

        self.buttonView:getChildByName(""..1):setInitState()
        movePanel:setPanelPos(nil,cc.p(-100,300));

        self.buttonView:hideAllBtn(40)
        self.line:setVisible(false)

        pointY = pointY-100
        self.scrollView:setContentOffset(cc.p(pointX,pointY-3000))
        -- self:performWithDelay(function()
        --     self.scrollView:setContentOffsetInDuration(cc.p(pointX,pointY),1)
        -- end, 0.2)

        local delayTime = cc.DelayTime:create(0.8)
        local moveTo = cc.MoveTo:create(2.5,cc.p(pointX,pointY))
        local tweenAction = cc.EaseSineInOut:create(moveTo)

        local removeSch = cc.CallFunc:create(function()
            self.scrollView:updateInset()
                if self.moveContainerSch then
                    SchedulerManager:getInstance():stop(self.moveContainerSch)
                    self.moveContainerSch = 0
                end
                newAction=false

                local colorLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
                colorLayer:setScale(2)
                colorLayer:setTag(100)
                local fadeto = cc.FadeTo:create(0.3,100);
                local delay1 = cc.DelayTime:create(3.4)
                local fadeOut = cc.FadeOut:create(0.3)
                local callback = cc.CallFunc:create(function()
                        self.levelItemLayer:removeChildByTag(100, true)
                    end)

                colorLayer:runAction(transition.sequence({fadeto,delay1,fadeOut,callback}))
                self.levelItemLayer:addChild(colorLayer,-2)
            end)

        local container = self.scrollView:getContainer()
        container:stopAllActions()
        local ScaleTo = cc.EaseSineInOut:create(cc.ScaleTo:create(1,contScale))
        container:runAction(transition.sequence({delayTime,tweenAction,ScaleTo,removeSch}))

        local delayPre = cc.DelayTime:create(3.5)
        local cfun = cc.CallFunc:create(function ()
            self:initOnce()
        end)
        local delayPre2 = cc.DelayTime:create(1)
        local cfun2 = cc.CallFunc:create(function ()
            --dump("cfun2")
            movePanel:onClick(self.buttonView:getChildByName(""..1),-10)
        end)
        local delayPre3 = cc.DelayTime:create(1)
        local cfun3 = cc.CallFunc:create(function ()
            --dump("cfun3")
            self.scrollView:setMaxScale(contScale)
            self.scrollView:setMinScale(contScale)
            self.scrollView:setTouchEnabled(true)
            self:getLevelPos(1)
            moveBtn()
        end)
        self:runAction(transition.sequence({createLayer,delayPre,cfun,delayPre2,cfun2,delayPre3,cfun3,removelayer}))
    elseif unlockCloud then
        -- 这是两个回调函数
        local createLayer = movePanel:createLayer(10002)
        local removelayer = movePanel:removeLayer(10002)
        -- 设置红鸟的位置
        movePanel:setPanelPos(UserData:getCurrentTopLevel(),nil)
        -- 设置scrollview偏移，要移动的距离
        self.scrollView:setContentOffset(cc.p(pointX,-self.mapLock:getPositionY()-150))
        -- 注册事件，云消失后开始移动地图
        self.mapLock:registerSpineEventHandler(function (event)
            local moveTo = cc.MoveTo:create(2.5,cc.p(pointX,pointY))
            local tweenAction = cc.EaseSineInOut:create(moveTo)
            local removeSch = cc.CallFunc:create(function()
                self.scrollView:updateInset()
                if self.moveContainerSch then
                    SchedulerManager:getInstance():stop(self.moveContainerSch)
                    self.moveContainerSch = 0
                end
                unlockCloud = false
            end)

            local container = self.scrollView:getContainer()
            container:stopAllActions()
            -- 拉近镜头 缩放的时候移动位置保证要显示的关卡在中间
            local ScaleTo = cc.EaseSineInOut:create(cc.ScaleTo:create(0.8,contScale))
            local moveto=cc.EaseSineInOut:create(cc.MoveTo:create(0.8,cc.p(self:getLevelPos(levelP,contScale))))
            local swap = cc.Spawn:create(ScaleTo,moveto)
            container:runAction(transition.sequence({tweenAction,swap,removeSch}))

            -- 动画结束后 回调
            local delayPre = cc.DelayTime:create(3.3)
            local cfun = cc.CallFunc:create(function ()
                self.scrollView:setMaxScale(contScale)
                self.scrollView:setMinScale(contScale)
                self.scrollView:setTouchEnabled(true)
                self:getLevelPos(UserData:getCurrentTopLevel()+1)
                -- 红鸟跳动的动画
                moveBtn()
            end)
            self:runAction(transition.sequence({createLayer,delayPre,cfun,removelayer}))
        end, sp.EventType.ANIMATION_COMPLETE)

    else
        self.scrollView:setContentOffset(cc.p(pointX,pointY))
        moveBtn()
        self:setLineData()
        local container = self.scrollView:getContainer()
        container:stopAllActions()
        local createLayer = movePanel:createLayer(10050)
        local delayPre = cc.DelayTime:create(0.2)
        local ScaleTo = cc.EaseSineInOut:create(cc.ScaleTo:create(0.8,contScale))
        local moveto=cc.EaseSineInOut:create(cc.MoveTo:create(0.8,cc.p(self:getLevelPos(levelP,contScale))))
        local swap = cc.Spawn:create(ScaleTo,moveto)
        local removeLayer = movePanel:removeLayer(10050)
        local initScroll = cc.CallFunc:create(function ()
            self.scrollView:setMaxScale(contScale)
            self.scrollView:setMinScale(contScale)
            self.scrollView:setTouchEnabled(true)
            self.scrollView:updateInset()
            if self.moveContainerSch then
                SchedulerManager:getInstance():stop(self.moveContainerSch)
                self.moveContainerSch = 0
            end
        end)
        container:runAction(transition.sequence({createLayer,delayPre,swap,removeLayer,initScroll}))
    end

    self.buttonView:addTo(self.levelItemLayer)
    movePanel:addTo(self.levelItemLayer)
    self.panel = movePanel


    -- 暂停遮罩里的hatchling的动画
    local hatchlingCount = self.cloudLevel-ScrollLevelNum
    self.buttonView:setShowHatchingLevel(hatchlingCount)
    for i=hatchlingCount+1,self.cloudLevel do
        self.buttonView:pauseHatchlingByLevel(i)
    end

    self.md={};
    self.spValue={};
    self.sp={}
    self:mapInit()
    self.lastPositionY=nil
    -- self:setMap(newAction)
    self.spTap={};
    -- self:setSpine()

    self.parallaxLayer:addChild(self.levelItemLayer,100,cc.p(1.08,1.08),cc.p(-40,-100))

    -- 大地图上的spine触摸事件

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(function(touch, event)

        if self.buttonView.smallbox then
            AdministrateFrame:getInstance():removeBox(self.buttonView.smallbox)
            self.buttonView.smallbox=nil
        end
        -- local touchPos = touch:getLocation()
        local pos =self.scrollView:getContainer():convertTouchToNodeSpace(touch);
        local x,y= self.scrollView:getContainer():getPosition()

        for k,v in pairs(self.spTap) do
            local rect=clone(v.rect)
            rect.x=-x+x*v.ratioX+v.rect.x;
            rect.y=-y+y*v.ratioY+v.rect.y;
            if cc.rectContainsPoint(rect,pos) then
                if self.cloudLevel-ScrollLevelNum<v.runLevel then
                    return
                end

                local img;
                if v.getName then
                    img=self.parallaxLayer:getChildByName(v.getName):getChildByTag(v.key);
                else
                    img=self.parallaxLayer:getChildByTag(v.key);
                end

                -- dump(v.run,type(v.run))
                if type(v.run) == "table" then
                    local n =math.random(#v.run)
                    img:setAnimation(0,v.run[n],false)
                else
                    img:setAnimation(0,v.run,false)
                end
            end
        end

        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.scrollView)

    -- 滑动大地图是更新大地图
    self.scrollView:registerScriptHandler(function(view)
        self.parallaxLayer:update()
        self:setMap(newAction or unlockCloud)
        self:setLineData()
        self:setSpine()
    end, cc.SCROLLVIEW_SCRIPT_SCROLL)


    -- self.scrollView:registerScriptHandler(function(view)
    --         self.scrollView:updateInset()
    -- end, cc.SCROLLVIEW_SCRIPT_ZOOM)


    -- self.value=SchedulerManager:getInstance():setFun(function ()
    --     self.parallaxLayer:update()
    --
    --     end)
    -- SchedulerManager:getInstance():starts()

    return self.scrollView
end



function MapScene:rectIntersectsRect( rect1, rect2 ,contentScale)
    local intersect = not (
    -- rect1.x > rect2.x + rect2.width or
                    -- rect1.x + rect1.width < rect2.x         or
                    rect1.y > (rect2.y + rect2.height)* contentScale       or
                    rect1.y + rect1.height < rect2.y*contentScale )
    return intersect
end

-- 初始化大地图和spine的偏差
function MapScene:mapInit()
    for i=1,#layout.frame do
        local info = layout.frame[i]
        local rect2= {};
        rect2.y=info[3][2]/info[4][2];
        rect2.height =info[6][2]/info[4][2];
        table.insert(info,rect2)
    end
    self.spineArr={}
     for i,v in ipairs(layout.animation) do
        local rect2= {};
        rect2.y=(v.posY-v.oriY)/(v.ratioY or 1)
        rect2.height =v.height/(v.ratioY or 1)
        table.insert(self.spineArr,rect2)

    end
end
-- 更新大地图 出入屏幕加载大地图和删除大地图缓存
function MapScene:setMap(newAction)
    local pos = self.scrollView:getContentOffset()
    if self.lastPositionY  == pos.y then
        return
    end
    -- print("pos.y---->",pos.y)
    if not self.firstSubjectHeight then
      self.firstSubjectHeight = pos.y
    else
      self:playCutSubjectMusic(pos.y)
    end

    local contentScale= self.scrollView:getZoomScale();
    local viewSize = self.scrollView:getViewSize()
    local rect = {};
    rect.y =-pos.y
    for i=1,#layout.frame do
        local info = layout.frame[i]
        rect.height =viewSize.height/info[4][2];
        -- dump(rect.y)
        -- dump(info[#info])
        if self:rectIntersectsRect(rect,info[#info],contentScale)  then
            if(self.md[i]==false or self.md[i]==nil) then
                self.md[i]=true
                local t = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
                if info[7] ==1 then
                    t = cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565
                elseif info[7]==0 then
                    t =cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444
                end
                cc.Texture2D:setDefaultAlphaPixelFormat(t)
                local bg=cc.Director:getInstance():getTextureCache():addImage(info[2])
                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
                local img = display.newSprite(bg)
                img:align(display.BOTTOM_LEFT)
                img:setTag(i)
                self.parallaxLayer:addChild(img,info[5],cc.p(info[4][1],info[4][2]),cc.p(info[3][1],info[3][2]))
            end
        else
            if self.md[i] ==true then
                local sp = self.parallaxLayer:getChildByTag(i)
                local spT = sp:getTexture();
                self.parallaxLayer:removeChild(sp,true)
                if  not newAction then
                    cc.Director:getInstance():getTextureCache():removeTexture(spT)
                end

                -- display.removeSpriteFrameByImageName(info[2] .. ".pvr")
                self.md[i]=false
            end
        end
    end
    -- self.cutSubjectPosY = pos.y
end

-- 更新大地图spine 出入屏幕加载spine和删除spine但不删除缓存

function MapScene:setSpine()
    local contentScale= self.scrollView:getZoomScale();
    local pos = self.scrollView:getContentOffset()
    local viewSize = self.scrollView:getViewSize()
    local rect = {};
    rect.y = -pos.y

    for i,v in ipairs(layout.animation) do
        rect.height = viewSize.height/(v.ratioY or 1)
        if self:rectIntersectsRect(rect,self.spineArr[i],contentScale) or v.notRemove then
            if(self.sp[i]==false or self.sp[i]==nil) then
                self.sp[i]=true
                -- dump(info[#info],contentScale)
                local img = mybo.SpineCache:getInstance():getSpine(v.name..".json",v.name..".atlas",v.name ..".png", v.scale or 1)
                img:setSkin(v.skin or "default")
                img:setTimeScale(v.time or 2)
                img:setRotation(v.rotation or 0)
                img:setTag(1000+i)
                if v.setName then img:setName(v.setName) end
                if v.sX~=nil then img:setScaleX(v.sX) end
                if v.sY~=nil then img:setScaleY(v.sY) end
                if type(v.run)=="table" then
                    local n = #v.run
                    img:setAnimation(0,v.run[n],false);
                    img:registerSpineEventHandler(function (event)
                        n=n-1
                        if n==0 then
                            n=#v.run
                        end
                        img:setAnimation(0,v.run[n],false);
                    end, sp.EventType.ANIMATION_COMPLETE)
                else
                    img:setAnimation(0,v.run,true);
                    if v.randomX then
                        img:registerSpineEventHandler(function (event)
                            img:setScaleX(math.random(2)==2 and 1 or -1)
                            img:setVisible(math.random(2)==2 and true or false)
                        end, sp.EventType.ANIMATION_COMPLETE)
                    else
                        img:registerSpineEventHandler(function (event)
                            img:setAnimation(0,v.run,true)
                        end, sp.EventType.ANIMATION_COMPLETE)
                    end
                end
                if v.getName then
                    local ret = self.parallaxLayer:getChildByName(v.getName)
                    if ret.findBone then
                        local value = SchedulerManager:getInstance():setFun(function (ret)
                            local x,y,rotation,scaleX,scaleY,len = ret:findBone(v.point)
                            img:setPosition(cc.p(x,y))
                            img:setRotation(rotation)
                            img:setScaleX(scaleX)
                            img:setScaleY(scaleY)
                        end,ret)
                        SchedulerManager:getInstance():starts()
                        ret:addChild(img,v.z or 1)
                        table.insert(self.spValue,{1000+i,value})
                    else
                        dump("debug bad")
                    end
                else
                    self.parallaxLayer:addChild(img,v.z or 1,cc.p(v.ratioX or 1,v.ratioY or 1),cc.p(v.posX,v.posY))
                end

                if self.cloudLevel-ScrollLevelNum>=v.runLevel then
                    img:resume()
                else
                    img:update(1)
                    img:pause()
                end

                -- local shape3 = cc.DrawNode:create()
                -- shape3:drawRect(cc.p(0,0),cc.p(v.width,v.height),cc.c4f(1,1,1,1))
                -- self.parallaxLayer:addChild(shape3,20,cc.p(v.ratioX or 1,v.ratioY or 1),cc.p(v.posX-v.oriX,v.posY-v.oriY))

                if v.tap then
                    table.insert(self.spTap,{rect=cc.rect(v.posX-v.oriX,v.posY-v.oriY,v.width,v.height),runLevel=v.runLevel,key=img:getTag(),getName=v.getName,run=(v.tapRun or v.run),ratioX=(v.ratioX or 1),ratioY=(v.ratioY or 1)})
                end
            end

        else
            if self.sp[i] ==true then
                for j=1,#self.spValue do
                   if self.spValue[j][1]==1000+i then
                       SchedulerManager:getInstance():stop(self.spValue[j][2])
                       table.remove(self.spValue,j)
                       break;
                   end
                end
                for b,v in ipairs(self.spTap) do
                   if v.key==1000+i then
                      table.remove(self.spTap,b)
                      break;
                   end
                end
                --  dump(#self.spTap)
                self.parallaxLayer:removeChild(self.parallaxLayer:getChildByTag(1000+i),true)
                self.sp[i]=false
            end

        end
    end

end

-- 计算大地图线
function MapScene:setLineData()
    local pos = self.scrollView:getContentOffset()
    local size = self.scrollView:getViewSize()
    local contentScale= self.scrollView:getZoomScale();
    local dataLen =#LineData.data
    local lowY = -pos.y - size.height * 0.5
    local height = size.height * 2.0 / 1.08

    local function bSearch(v)
        local t = LineData.data
        local left = 2;
        local right = dataLen
        local ceil = math.ceil
        local mid = ceil((left + right)/2)
        local tmpY
        while left < right do
            if mid % 2 == 1 then
                mid = mid + 1
            end
            tmpY = t[mid]*contentScale /1.08
            if tmpY < v then
                left = mid + 2
            else
                right = mid -2
            end
            mid = ceil((left + right)/2)
        end
        return mid
    end

    local lowIndex = bSearch(lowY)
    if lowIndex % 2 == 0 then
        lowIndex = lowIndex - 1
    end
    if lowIndex < 2 then
        lowIndex = 1
    end
    local highIndex = bSearch(lowY + height)
    if highIndex % 2 == 0 then
        highIndex = highIndex + 1
    end
    if highIndex > dataLen then
        highIndex = dataLen - 1
    end

    if self.line then
        --这里是lua的索引适配c++索引
        self.line:updateLineIndex(lowIndex - 1,highIndex - 1)
    end
end
-- 计算再大地图显示几个按钮
function MapScene:setButtonData()
    local pos = self.scrollView:getContentOffset()
    local size = self.scrollView:getViewSize()
    local contentScale= self.scrollView:getZoomScale();
    dump(contentScale,"尺寸")
    local dataLen =#levelLayout.levels
    local lowY = -pos.y*1.08
    local height = size.height*1.2
    local function bSearch(v)
        local t = levelLayout.levels
        local left = 0;
        local right = dataLen
        local ceil = math.ceil
        local mid = ceil((left + right)/2)
        local tmpY
        while left < right do
            -- if mid % 2 == 1 then
            --     mid = mid + 1
            -- end
            -- dump("zk")
            tmpY = t[mid][2]*contentScale
            if tmpY < v then
                left = mid + 1
            else
                right = mid -1
            end
            mid = ceil((left + right)/2)
        end
        return mid
    end

    local lowIndex = bSearch(lowY)
    if lowIndex % 2 == 0 then
        lowIndex = lowIndex - 1
    end
    if lowIndex < 2 then
        lowIndex = 1
    end
    local highIndex = bSearch(lowY + height)
    if highIndex % 2 == 0 then
        highIndex = highIndex + 1
    end
    if highIndex > dataLen then
        highIndex = dataLen - 1
    end
    -- if self.buttonView then
    --     self.buttonView:updateButtonView(lowIndex,highIndex+1)
    -- end
    return lowIndex,highIndex+1
end

function MapScene:genLineNode()
    return mybo.LineNode:create(LineData.data)
end

function MapScene:gotoLevel(level,bool)
    local pointX,pointY = self:getLevelPos(level)
    self.scrollView:setContentOffset(cc.p(pointX,pointY),bool)
end


-- 修正关卡按钮位置

function MapScene:getLevelPos(level,containerScale)

    if level>#levelLayout.levels then
        level = #levelLayout.levels
    end
    local scrollSize =self.scrollView:getContentSize()
    if not containerScale then
        containerScale=self.scrollView:getContainer():getScale()
    end
    self.subjectHeightRange = {{100*containerScale,-6532*containerScale},
                                {-6532*containerScale,-12438*containerScale},
                                {-12438*containerScale,-18888*containerScale},
                                {-18888*containerScale,-28888*containerScale},
                                {-28888*containerScale,-40200*containerScale},
                                {-40200*containerScale,-44506*containerScale},
                                {-44506*containerScale,-50225*containerScale},
                                {-50225*containerScale,-80000*containerScale}}
    scrollSize.width=scrollSize.width*containerScale;
    scrollSize.height=scrollSize.height*containerScale;
    local pointY = (-levelLayout.levels[level][2]+display.height*0.5)*containerScale
    local pointX = (-levelLayout.levels[level][1]+display.width*0.5)*containerScale
    pointY=pointY/1.08
    pointX=pointX/1.08
    if pointY>=0 then
        pointY=0
    elseif pointY<=display.height-scrollSize.height  then
        pointY= display.height-scrollSize.height
    end

    if pointX>=0 then
        pointX=0
    elseif pointX<=display.width-scrollSize.width then
        pointX=display.width-scrollSize.width
    end



    return pointX,pointY

end

-- 显示hatchling收集动画
function MapScene:runHatchling(oriButton, callBack)
    local hatchlingId = 12001
    local level = UserData:getCurrentTopLevel()
    local hatchCfg= utils.json2lua("json/task_hatchling.json")
    local info = hatchCfg[tostring(level)]
    if info then
        for k,v in pairs(info) do
            hatchlingId = tonumber(k)
        end
    end
    -- 根据hatchling id 获取相应动画
    local anim = PropResUtils.getHatchlingAnimInMap(hatchlingId)
    local animEffect = PropResUtils.getHatchlingEffectAnimInMap("hatchlingEffect")
    local currentPos = cc.p(oriButton:getPosition())
    local hatchlingSp = mybo.SpineCache:getInstance():getSpine(anim.json,anim.atlas,anim.png,0.5)
    local hatchlingEf = mybo.SpineCache:getInstance():getSpine(animEffect.json,animEffect.atlas,animEffect.png,0.8)
    local hatchlingEf2 = mybo.SpineCache:getInstance():getSpine(animEffect.json,animEffect.atlas,animEffect.png,1)
    hatchlingSp:setTimeScale(2)
    hatchlingEf:setTimeScale(2)
    hatchlingEf2:setTimeScale(2)
    hatchlingSp:addTo(self, 1000)
    hatchlingEf:addTo(self, 1000)
    hatchlingEf2:addTo(self, 1000)
    hatchlingEf2:setVisible(false)
    local oriPos = oriButton:getParent():convertToWorldSpace(cc.p(oriButton:getPositionX() + 80, oriButton:getPositionY()))
    local oriPosEf = oriButton:getParent():convertToWorldSpace(cc.p(oriButton:getPositionX() + 45, oriButton:getPositionY()))
    hatchlingSp:setPosition(oriPos)
    hatchlingEf:setPosition(oriPosEf)
    -- 动画动作
    local sequenceArr = {}
    local delay1 = cc.DelayTime:create(0.05)
    local missionBtn = self:getMissionBtn()
    local targetPos = self:convertToNodeSpace(cc.p(missionBtn:getPosition()))
    local moveTo = cc.JumpTo:create(0.6, targetPos, 100, 1)
    local delay2 = cc.DelayTime:create(0.05)

    table.insert(sequenceArr,delay1)
    table.insert(sequenceArr,moveTo)
    table.insert(sequenceArr,delay2)
    local sequence = transition.sequence(sequenceArr)
    -- 动画 animation
    hatchlingSp:setAnimation(0,"run",false)
    hatchlingEf:setAnimation(0,"run1",false)
    hatchlingSp:runAction(sequence)

    -- 注册事件
    hatchlingSp:registerSpineEventHandler(function(event)
        if event.eventData.name=="run2" then
            hatchlingEf2:setVisible(true)
            hatchlingEf2:setPosition(targetPos)
            hatchlingEf2:setAnimation(0,"run2",false)
        end
    end, sp.EventType.ANIMATION_EVENT)

    -- 结束事件回调
    hatchlingSp:registerSpineEventHandler(function (event)
        if callBack then
            callBack()
        end
    end, sp.EventType.ANIMATION_COMPLETE)
end

function MapScene:updateMailBtn()
    self.ui:updateMailBtn()
end

function MapScene:setMailBtn(bool)
    self.ui:setMailBtn(bool)
end


function MapScene:updateMissionBtn()
    self.ui:updateMissionBtn()
end

function MapScene:setMissionBtn(bool)
    self.ui:setMissionBtn(bool)
end

function MapScene:isShowMissionRed()
    self.ui:isShowMissionRed()
end

function MapScene:setDailyDitVisible(bool)
    self.ui:setDailyDitVisible(bool)
end

-- function MapScene:getSilverIcon()
--     return self.ui.silverIcon;
-- end
-- function MapScene:getGlodIcon()
--     return self.ui.glodIcon;
-- end

function MapScene:getCoinBox()
    return self.ui.coinBox;
end

function MapScene:getHpBar()
    return self.ui.hpBar;
end

-- get mission
function MapScene:getMissionBtn()
    return self.ui.btnMission
end

-- get ui
function MapScene:getUI()
    return self.ui
end

function MapScene:getScrollViewOffset()
    if self.scrollView then
        return self.scrollView:getContentOffset()
    end
    return nil
end
function MapScene:setScrollViewOffset(p)
    if self.scrollView then
        self.scrollView:setContentOffset(p)
    end
end

function MapScene:silverCoinAnimation()
    self.ui:silverCoinAnimation();
end

function MapScene:glodCoinAnimation()
    self.ui:glodCoinAnimation();
end

function MapScene:playCutSubjectMusic( currPos_y )
  -- print("当前高度------------->",currPos_y)
  local subjectFun = function  (subject)
    if subject == 1 then
        print("进入第一章节")
         mybo.SoundPlayer:getInstance():playBackgroundMusic("map_bird_home");
         mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_bird_home",true)
    elseif subject == 2 then
        print("进入第二章节")
         mybo.SoundPlayer:getInstance():playBackgroundMusic("map_beach");
         mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_beach",true)
    elseif subject == 3 then
        print("进入第三章节")
         mybo.SoundPlayer:getInstance():playBackgroundMusic("map_desert");
         mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_desert",true)
    elseif subject == 4 then
        print("进入第四章节")
         mybo.SoundPlayer:getInstance():playBackgroundMusic("map_magic_swamp");
         mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_magic_swamp",true)
    elseif subject == 5 then
        print("进入第五章节")
        mybo.SoundPlayer:getInstance():playBackgroundMusic("map_pigcity");
        mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_pigcity",true)
      elseif subject == 6 then
          print("进入第六章节")
          mybo.SoundPlayer:getInstance():playBackgroundMusic("map_garden");
          mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_garden",true)
      elseif subject == 7 then
          print("进入第七章节")
          mybo.SoundPlayer:getInstance():playBackgroundMusic("map_christmasvillage");
          mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_christmasvillage",true)
      elseif subject == 8 then
          print("进入第八章节")
          mybo.SoundPlayer:getInstance():playBackgroundMusic("map_space");
          mybo.SoundPlayer:getInstance():playBackgroundMusic("amb_space",true)
    end
  end
    local subjectNum
    for k,v in pairs(self.subjectHeightRange) do
      if currPos_y<v[1] and currPos_y>=v[2] then
        subjectNum = k
      end
    end
    if not self.cutSubject then
      self.cutSubject = subjectNum
      subjectFun(self.cutSubject)
    else
      if self.cutSubject ~= subjectNum then
        self.cutSubject = subjectNum
        subjectFun(self.cutSubject)
      end
    end
end

function MapScene:createMapLock()
    local mapLock= mybo.SpineCache:getInstance():getSpine("effect/mapLock/mapcloud.json","effect/mapLock/mapcloud.atlas","effect/mapLock/mapcloud.png", 0.75)
    mapLock:setTimeScale(2)
    mapLock:setAnimation(0,"stop",false)
    -- mapLock:setVisible(false)
    -- dump(UserData:getCurrentLevel())
    self.parallaxLayer:addChild(mapLock,108,cc.p(1,1),cc.p(0,0))
    mapLock:setPosition(display.width*0.5+20,self:getMapHeight(UserData:getCurrentLevel())-150)

    return mapLock
end

function MapScene:createMapCloudLock(playAnim)
    local mapLock= mybo.SpineCache:getInstance():getSpine("effect/mapLock/mapcloud.json","effect/mapLock/mapcloud.atlas","effect/mapLock/mapcloud.png", 0.75)
    mapLock:setTimeScale(2)
    mapLock:setAnimation(0,"stop",false)
    self.parallaxLayer:addChild(mapLock,108,cc.p(1,1),cc.p(0,0))

    local cloudLevel = self:getCloudLevel(playAnim)
    local cloudHeight = self:getLevelBtnHeight(cloudLevel)
    mapLock:setPosition(display.width*0.5+20,cloudHeight/1.08+370)
    self.cloudLevel = cloudLevel

    local heightColor = 250
    local layerHeight = self:getLevelBtnHeight(cloudLevel-ScrollLevelNum)
    local colorLayer = cc.LayerGradient:create(cc.c4b(0,0,0,255*0), cc.c4b(0,0,0,255*0.65),cc.p(0,1))
    colorLayer:setTag(501)
    self.parallaxLayer:addChild(colorLayer,107,cc.p(1,1),cc.p(0,0))
    colorLayer:setContentSize(display.width * 2,heightColor)
    colorLayer:setPosition(-200,layerHeight/1.08+50-100)

    local colorLayer1 = cc.LayerGradient:create(cc.c4b(0,0,0,255*0.65), cc.c4b(0,0,0,255*0.65),cc.p(0,1))
    colorLayer1:setTag(502)
    self.parallaxLayer:addChild(colorLayer1,107,cc.p(1,1),cc.p(0,0))
    colorLayer1:setContentSize(display.width * 2,cloudHeight/1.08-layerHeight/1.08+500-heightColor)
    colorLayer1:setPosition(-200,layerHeight/1.08+50-100+heightColor)

    -- for i=1,300 do
    --     local layerHeight = self:getLevelBtnHeight(i)
    --     local colorLayer = cc.LayerGradient:create(cc.c4b(0,0,0,255*0.85), cc.c4b(0,0,0,255*0.85),cc.p(0,1))
    --     self.parallaxLayer:addChild(colorLayer,107,cc.p(1,1),cc.p(0,0))
    --     colorLayer:setContentSize(display.width+200,1)
    --     colorLayer:setPosition(-200,layerHeight/1.08+50)
    -- end

    return mapLock
end

function MapScene:getCloudLevel(playAnim)
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

function MapScene:getLevelBtnHeight(level)
    local levelsNum = #levelLayout.levels
    level = level<MaxMapUnlock and level or MaxMapUnlock
    level = level<levelsNum and level or levelsNum
    return levelLayout.levels[level][2]
end

function MapScene:getMapHeight(level)
    local data = layout.mapHeight
    for i,v in ipairs(MAP_UNLOCK) do
        if level< v[1] then
            data = v[2]+200
            break;
        end
    end
    return data
end

function MapScene:updateMapLockPos(level)
    self.mapLock:setPosition(display.width*0.5+20,self:getMapHeight(level)-150)
end

function MapScene:updateMapLock(onMove)

    self.mapLock:setAnimation(0,"run",false);
    self:performWithDelay(function ()
        onMove()
        local scrollSize = cc.size(layout.mapWidth, self:getMapHeight(UserData:getCurrentLevel()))
        self.scrollView:setContentSize(scrollSize)
        self:updateMapLockPos(UserData:getCurrentLevel())
        self.mapLock:setAnimation(0,"stop",false);
    end,2)
end

function MapScene:loadingSpine(callback)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(touches, event)
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )

    local eventDispatcher =cc.Director:getInstance():getEventDispatcher()

    local width=750.38;
    local height=1136;
    local scale=display.width/width>= display.height/height and  display.width/width or display.height/height

    local bombSpine=mybo.SpineCache:getInstance():getSpine("load/loading.json","load/loading.atlas","load/loading.png",scale);
    local scene = cc.Director:getInstance():getRunningScene()
    bombSpine:addTo(scene,100000)
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, bombSpine);
    bombSpine:setTimeScale(1.5)
    bombSpine:setAnimation(0,"star",false)
    bombSpine:addAnimation(0,"end",false)
    bombSpine:setPosition(display.cx,display.cy)
    bombSpine:registerSpineEventHandler(function(event)
        if event.animation=="star" then
            if callback then
                callback()
            end
        elseif  event.animation=="end" then
            self:performWithDelay(function ()
                bombSpine:removeFromParent()
            end,0.1)

        end

    end,sp.EventType.ANIMATION_COMPLETE)
end

-- Loading
function MapScene:showLoading()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,120))
    self:addChild(colorLayer, 80000)
    colorLayer:setName("colorLayer")
    local waitSpine =mybo.SpineCache:getInstance():getSpine("wait/skeleton.json", "wait/skeleton.atlas","wait/skeleton.png",1.5)
    waitSpine:setAnimation(0,'run',true)
    waitSpine:setPosition(display.cx,display.cy)
    waitSpine:setTimeScale(1.5)
    self:addChild(waitSpine, 80001)
    waitSpine:setName("waitSpine")

    local listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch,event)
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listenner, colorLayer)
end
function MapScene:hideLoading()
    local waitSpine = self:getChildByName("waitSpine")
    if waitSpine then
        waitSpine:removeFromParent()
    end
    local colorLayer = self:getChildByName("colorLayer")
    if colorLayer then
        colorLayer:removeFromParent()
    end
end

function MapScene:isUpdateMapLock()
    -- dump("现在",UserData:getCurrentLevel())
    for i,v in ipairs(MAP_UNLOCK) do
        if v[1]==UserData:getCurrentLevel() then
            return true
        end
    end
    return false
end

function MapScene:showPigTowerBtn(x,y)
    if self.ui and self.ui.createPigTowerBtn  then
        local btn = self.ui:createPigTowerBtn(x,y)
        if not btn then
            return nil
        end
        local bar = display.newSprite("#towerIcon_bar.png")
        bar:setPosition(70, 24)
        bar:addTo(btn:getMenuItem())
        local lableConfig  = {
            text =mybo.MyboDevice:getLocalString("piggyTower_0003"),
            size = 22,
            color = cc.c3b(255, 255, 255),

            x= 70,
            y= 29,
            self = btn:getMenuItem(),
            align = cc.TEXT_ALIGNMENT_CENTER

        }
        local towerTitle =utils:createLabel(lableConfig)
        towerTitle:enableShadow(cc.c4b(0,0,0,255),cc.size(2,-2),2)


        return btn
    end
end
return MapScene
