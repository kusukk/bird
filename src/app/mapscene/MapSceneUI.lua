--
-- Author: pengxianfeng
-- Date: 2017-04-27 18:34:15
--
local Button = require "app.common.Button"
local UIButton = require "app.common.UIButton"
local UserData = require "app.data.UserData"
local JourneyPanel = require('app.mapscene.popupview.JourneyPanel')
local SettingsPanel = require('app.mapscene.popupview.SettingsPanel')
local FB =require "app.data.Facebook"
local SettingBar = require("app.common.SettingBar")
-- local MissionPanel = require("app.mapscene.popupview.MissionPanel")
require ("app.config.config")
require("socket")
local SchedulerManager = require "app.mapscene.SchedulerManager"
-- local ActivityPacks = require "app.common.shop.ActivityPacks"
local CoinBox = require "app.common.CoinBox"
local HpBar =require "app.common.HpBar"
local taskUtils = require "app.config.taskUtils"
local MessageData = require "app.data.MessageData"
local MapSceneUI = class("MapSceneUI", function () return display.newNode() end)
local utils = require("app.utils.utils")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local DailyMissionData = require "app.data.DailyMissionData"
-- local ADManage = require('app.common.ADManage')
-- local ADConfig = require('app.config.adsConfig')
-- require "app.data.piggyTowerData"
-- 小红点 请求间隔时间(s)
local DOT_GAP_TIME = 300

function MapSceneUI:ctor(isFirstShow)
    self.value=-1
    self.DailyBtnShakeValue =-1
    self.mailBtnValue =-1
    local screenSize = cc.Director:getInstance():getWinSize()

    -- 创建金币框和银币框
    self.coinBox =CoinBox.new(3,self)
    self.coinBox:addTo(self)

    -- 行动力按钮, 体力入口
    self.hpBar = HpBar.new()
    self.hpBar:addTo(self)

    self.timeimgBtn=false

    -- 促销按钮
    self:addPromotionIcon()
    self.adnew =-1

   local function newContent()
        ADManage:isReady(ADConfig.NewContent,function(ready)
            if ready then
                if self.adnew ~=-1 then
                   scheduler.unscheduleGlobal(self.adnew)
                    self.adnew =-1
               end
               local texture=  cc.SpriteFrameCache:getInstance():getSpriteFrame(ADConfig.NewContent..2);
               local sp =display.newSprite(texture)
               dump(sp:getContentSize())
               -- sp:setScale(200/sp:getContentSize().width)
               -- sp:setPosition(display.cx,display.cy)
               -- sp:addTo(self)

               local btn = UIButton.new()
               btn:setNormalSprite(sp)
               btn:getMenuItem():setScale(0.9)
               local btnSize = btn:getMenuItem():getContentSize()
               if     self.timeimgBtn then
                    btn:setItemPosition(btnSize.width*0.5,display.height-500)
               else
                    btn:setItemPosition(btnSize.width*0.5,display.height-250)
               end

               btn:addTo(self)
               btn:setTouchFunc(function ()
                --    ADManage:showAD(ADConfig.NewContent,function (layer)
                --        if not layer then do return end end
                --        self.AdLayer = layer
                --        self.ad_sp = layer.ad_sp
                --        self:addChild(layer,500)
                --        layer.closeBtn:registerScriptTapHandler(function()
                --            mybo.SoundPlayer:getInstance():playEffect("ui_close_panel")
                --            if self.AdLayer then
                --                self:removeChild(self.AdLayer)
                --                self.AdLayer = nil;
                --                self.ad_sp=nil
                --            end
                --        end)
                --        ServerProxy.trackEventAD(ADConfig.NewContent)
                --     end)
                AdministrateFrame:getInstance():newBox("NewContentBox",cc.Director:getInstance():getRunningScene())
               end)
            elseif self.adnew==-1 then
                self.adnew=scheduler.scheduleGlobal(newContent, 5)
            end
        end)
   end

    -- 判断hatch登录状态
    if UserData:getHatchLoginState() then
        newContent()
    else
        ServerProxy.hatchLogin(function()
            newContent()
        end)
    end

    -- 进度按钮
    local progress = UIButton.new()
    progress:setNormalImage("#star_progress.png")
    local progressSize = progress:getMenuItem():getContentSize()
    local isClickProgress = false
    progress:setItemPosition(display.width-progressSize.width*0.5-15,display.height-300)
    progress:setTouchFunc(function ()
        if not self:getParent():getParent().isTouchMoved and not self.settingBar.showSettingItems and not isClickProgress then
            isClickProgress = true
            self:performWithDelay(function ()
                UserData:setPanelDot(false)
                self:updateProgressBtn()
                self:addChild(JourneyPanel.new(),100,"JourneyPanel")
                self:performWithDelay(function ()
                    isClickProgress = false
                end,1.0)
            end,6.0/60.0)
        end
    end)
    self:addChild(progress)
    self.progress = progress:getMenuItem()
    -- 进度小红点
    local dot1 = display.newSprite("#red.png")
    dot1:setPosition(progressSize.width*0.2,progressSize.height*0.8)
    dot1:addTo(self.progress)
    dot1:setTag(10)
    dot1:setVisible(UserData:getPanelDot())

    -- 邮箱按钮
    local mail = UIButton.new()
    mail:setNormalImage("#mail.png")
    local mailSize = mail:getMenuItem():getContentSize()
    mail:setItemPosition(display.width-mailSize.width*0.5-15,display.height-430)
    mail:setTouchFunc(function ()
        if not self:getParent():getParent().isTouchMoved and not self.settingBar.showSettingItems then
            if UserData:getNoHatchAccountMode() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self, 1)
            elseif utils.getInternetConnectionStatus() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
            else
                -- self:addChild(MessagePanel.new(),100)
                AdministrateFrame:getInstance():newBox("PageFrame",self)
            end
            -- self:updateLayout()
            -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
        end
    end)
    self:addChild(mail)
    self.mail = mail:getMenuItem()
    -- 邮箱小红点
    local dot = display.newSprite("#red.png")
    dot:setPosition(mailSize.width*0.2,mailSize.height*0.8)
    dot:addTo(self.mail)
    dot:setTag(12)
    dot:setVisible(false)
    -- 更新
    self:updataMail()

    -- Mission按钮
    local btnMission = UIButton.new()
    btnMission:setNormalImage("#mission_button.png")
    local missionSize = btnMission:getMenuItem():getContentSize()
    btnMission:setItemPosition(display.width-missionSize.width*0.5-15,display.height-560)
    btnMission:setTouchFunc(function ()
        if not self:getParent():getParent().isTouchMoved and not self.settingBar.showSettingItems then
            if UserData:getNoHatchAccountMode() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self, 1)
                return
            end
            -- if utils.getInternetConnectionStatus() then
            --   AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
            -- else
            AdministrateFrame:getInstance():newBox("MissionPanel",self)
            -- end
        end
    end)
    self:addChild(btnMission)
    self.btnMission = btnMission:getMenuItem()
    local levelEnable = UserData:getCurrentLevel() > 5
    self.btnMission:setVisible(levelEnable)
    -- 任务小红点
    local dot = display.newSprite("#red.png")
    dot:setPosition(missionSize.width*0.2,missionSize.height*0.8)
    dot:addTo(self.btnMission)
    dot:setTag(12)
    dot:setVisible(false)
    if levelEnable then
        -- 更新
        self:updateMissionBtn()
        -- 刷新mission小红点
        self:isShowMissionRed()
    end

    self.progress:setScale(missionSize.width/progressSize.width)
    self.mail:setScale(missionSize.width/mailSize.width)

    -- 显示piggyTower开关
    local delayShow = 0
    if isFirstShow then
        delayShow = 9.5
    end
    -- 延时显示
    self:performWithDelay(function()
        self:showTowerBtn()
    end, delayShow)

    -- daily task
    local iconBG = display.newSprite("#map_icon_bg.png")
    local btnDaily = UIButton.new()
    btnDaily:setNormalImage("#DMBtn.png")
    local dailySize = btnDaily:getMenuItem():getContentSize()
    btnDaily:setItemPosition(display.width-dailySize.width*0.5-20,display.height*0.065+80)
    iconBG:setPosition(display.width-dailySize.width*0.5+5-20,display.height*0.065+67)
    btnDaily:setTouchFunc(function ()
        if not self:getParent():getParent().isTouchMoved and not self.settingBar.showSettingItems then
            if UserData:getNoHatchAccountMode() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self, 1)
            elseif utils.getInternetConnectionStatus() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
            else
                if self.value~=-1 then
                    AdministrateFrame:getInstance():newBox("DailyTipPanel",self,self.time:getString())
                    -- AdministrateFrame:getInstance():newBox("DailyPanel",self)
                else
                    AdministrateFrame:getInstance():newBox("DailyPanel",self)
                end
            end
      end
    end)
    self:addChild(iconBG)
    self:addChild(btnDaily)
    self.btnDaily = btnDaily:getMenuItem()
    local levelEnable = UserData:getCurrentLevel() > 25
    self.btnDaily:setVisible(levelEnable)
    iconBG:setVisible(levelEnable)
    -- daily task 小红点
    local dot = display.newSprite("#red.png")
    dot:setPosition(dailySize.width*0.81,dailySize.height*0.82)
    dot:addTo(self.btnDaily)
    dot:setScale(1.2)
    dot:setTag(12)
    dot:setScaleX(-1.2)
    dot:setVisible(false)
    if levelEnable then
        self:updateDailyBtn()
        local timeNode = display.newNode()
        local timeImg = display.newSprite("#dailyTimeImg2.png");
        timeImg:setPosition(-25+15,-12)
        timeImg:addTo(timeNode)
        self.time = cc.Label:createWithTTF("","fonts/ABFlockText-Bold.ttf",24);
        self.time:setTextColor(cc.c4b(255,255,255,255))
        self.time:enableShadow(cc.c4b(0,0,0,255),cc.size(2,-2),2)
        self.time:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        self.time:setAnchorPoint(0,0.5)
        self.time:setPosition(-5+15,-12)
        self.time:addTo(timeNode)
        timeNode:addTo(self)
        local x,y =btnDaily:getItemPosition()
        timeNode:setVisible(false)
        timeNode:setPosition(x-45,y-dailySize.height*0.5-10)
        self.timeNode=timeNode

        local lableConfig  = {
                text =mybo.MyboDevice:getLocalString("Dailypanel_0005"),
                size = 24,
                color = cc.c3b(255, 255, 255),
                x = x-20+20,
                y = y-dailySize.height*0.5-18,
                self = self
        }
        self.dailyStr =utils:createLabel(lableConfig)
        self.dailyStr:enableShadow(cc.c4b(0,0,0,255),cc.size(2,-2),2)

        self.dailyStr:setVisible(true)
    end
    -- daily task 抖动
    self:DailyBtnShake()
    self.DailyBtnShakeValue = scheduler.scheduleGlobal(function ()
        self:DailyBtnShake()
    end, 10)

    -- FB首登送礼Btn
    -- 关闭当前入口(1.3.2)
    -- self:showFBGiftBtn()

    local useToonsSdk = true
    if useToonsSdk then
        mybo.HatchSDK:getInstance():enableToonsSdk()
    end
    self:showTv(useToonsSdk)

    -- old setting bar
    self:initOldSettingBar()

    -- new SettingsPanel
    self:initSettingsBtn()

    -- 显示本地关卡包 
    self:showLocalPointPackage()
    self:showLocalPointPackageAndDig()

    -- 测试弹框开关
    -- self:openTestPopBox()

    -- 热更新开关
    -- self:hotUpdate("SettingsPanel")

    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

-- Loading
function MapSceneUI:showLoading()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,120))
    self:addChild(colorLayer, 40000)
    colorLayer:setName("colorLayer")
    local waitSpine =mybo.SpineCache:getInstance():getSpine("wait/skeleton.json", "wait/skeleton.atlas","wait/skeleton.png",1.5)
    waitSpine:setAnimation(0,'run',true)
    waitSpine:setPosition(display.cx,display.cy)
    waitSpine:setTimeScale(1.5)
    self:addChild(waitSpine, 40001)
    waitSpine:setName("waitSpine")

    local listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch,event)
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listenner, colorLayer)

end
function MapSceneUI:hideLoading()
    local waitSpine = self:getChildByName("waitSpine")
    if waitSpine then
        waitSpine:removeFromParent()
    end
    local colorLayer = self:getChildByName("colorLayer")
    if colorLayer then
        colorLayer:removeFromParent()
    end
end

--显示tower按钮
function MapSceneUI:showTowerBtn()
    local iconBg = display.newSprite("#map_icon_bg.png")
    local pigTowerBtn =  self:createPigTowerBtn(95,88)
    local pigTowerSize = pigTowerBtn:getMenuItem():getContentSize()
    iconBg:addChild(pigTowerBtn)
    iconBg:setPosition(display.width-pigTowerSize.width*0.5+5-20,display.height*0.065+270)
    self:addChild(iconBg)


    self.towerIconBg = iconBg
    self.towerBtn = pigTowerBtn:getMenuItem()

    -- 倒计时
    local timeTower = self:getTowerTime()
    timeTower:setPosition(70, 24)
    timeTower:addTo(pigTowerBtn:getMenuItem())

    local lableConfig  = {
        text =mybo.MyboDevice:getLocalString("piggyTower_0001"),
        size = 22,
        color = cc.c3b(255, 255, 255),

        x= 90,
        y= -10,
        self = iconBg,
        align = cc.TEXT_ALIGNMENT_CENTER

    }
    self.towerTitle =utils:createLabel(lableConfig)
    self.towerTitle:enableShadow(cc.c4b(0,0,0,255),cc.size(2,-2),2)

    -- daily不显示,默认在daily位置
    if not self.btnDaily:isVisible() then
        self.towerIconBg:setPositionY(self.towerIconBg:getPositionY() - 213)
    end
end




function MapSceneUI:createPigTowerBtn(x,y)

    local pigTowerBtn = UIButton.new()
    pigTowerBtn:setNormalImage("#towerIcon.png")

    pigTowerBtn:setItemPosition(x, y)

    pigTowerBtn:setTouchFunc(function ()
        if self:getParent():getParent().isTouchMoved or self.settingBar.showSettingItems then
            return
        end
        -- ChapterPreparePanel打开不能进tower
        if AdministrateFrame:getInstance():hadBox('ChapterPreparePanel') then
            return
        end
        if UserData:getNoHatchAccountMode() then
            AdministrateFrame:getInstance():newBox("NetworkWarnning",self, 1)
        elseif utils.getInternetConnectionStatus() then
            AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
        else
            -- piggy正常流程
            local checkBack = function()
                if not piggyTowerData:checkTower() then
                    AdministrateFrame:getInstance():newBox("PiggyLastLeaderboard",cc.Director:getInstance():getRunningScene())
                elseif not piggyTowerData:checkPiggyTowerMode() then
                    AdministrateFrame:getInstance():newBox("CheckListPanel",cc.Director:getInstance():getRunningScene())
                else
                    self:showLoading()
                    piggyTowerData:initPiggyTower(function(bool)
                        if bool then
                            if not piggyTowerData:checkTower() then
                                self:hideLoading()
                                AdministrateFrame:getInstance():newBox("PiggyLastLeaderboard",cc.Director:getInstance():getRunningScene())
                                return
                            end
                            piggyTowerData:getTaskList(function()
                                self:hideLoading()
                                cc.Director:getInstance():getRunningScene():runPigTowerScene()
                            end)
                        else
                            self:hideLoading()
                            AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
                        end
                    end)
                end
            end
            -- 是否有期数
            if piggyTowerData:getCheckListPhase() ~= "" then
                checkBack()
            else
                self:showLoading()
                piggyTowerData:updatePiggyTowerPhase(function(bool)
                    self:hideLoading()
                    if bool then
                        checkBack()
                    else
                        AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
                    end
                end)
            end
        end
    end)


    return  pigTowerBtn
end

-- piggyTower倒计时
function MapSceneUI:getTowerTime()
    local bar = display.newSprite("#towerIcon_bar_coming.png")

    local strCofig = {
        text = "",
        size = 20,
        x = bar:getContentSize().width/2 - 2,
        y = bar:getContentSize().height/2 + 4,
        font = "fonts/ABFlockText-Bold.ttf",
        -- self= bar
    }
    local timeDesc = display.newTTFLabel(strCofig)
    timeDesc:addTo(bar)

    local getTiem = function()
        local startTime = piggyTowerData:getOpenTime()
        local endtime = piggyTowerData:getCloseTime()
        if piggyTowerData:checkTower() then
            bar:setSpriteFrame("towerIcon_bar.png")
            local timeLab = utils.conversionTime(endtime)
            timeDesc:setVisible(true)
            timeDesc:setString(timeLab)
        else
            if startTime == 0 and endtime == 0 then
                piggyTowerData:updatePiggyTowerPhase()
            end
            bar:setSpriteFrame("towerIcon_bar_coming.png")
            timeDesc:setVisible(false)
        end
    end

    getTiem()
    self.towerTimeSch = scheduler.scheduleGlobal(function()
        getTiem()
    end, 1)

    return bar
end

-- hide tower
function MapSceneUI:hideTower()
    if self.towerIconBg then
        self.towerIconBg:setVisible(false)
    end
end

-- facebook首登送礼
function MapSceneUI:showFBGiftBtn()
    local btnFBGift = UIButton.new()
    btnFBGift:setNormalImage("#fb_login_gift.png")
    local fbGiftSize = btnFBGift:getMenuItem():getContentSize()
    btnFBGift:setItemPosition(display.width-fbGiftSize.width*0.5-15,display.height-820)
    btnFBGift:setTouchFunc(function ()
        if not self:getParent():getParent().isTouchMoved and not self.settingBar.showSettingItems then
            if UserData:getNoHatchAccountMode() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self, 1)
            elseif utils.getInternetConnectionStatus() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
            else
                AdministrateFrame:getInstance():newBox("InvitePanel",self)
            end
        end
    end)
    self:addChild(btnFBGift)
    self.btnFBGift = btnFBGift:getMenuItem()
    self.btnFBGift:setVisible(FB.isLoggedIn())
    -- mission不显示时,默认顶上去
    if not self.btnMission:isVisible() then
        self.btnFBGift:setPositionY(self.btnFBGift:getPositionY()+130)
    end
end

-- 促销icon添加
function MapSceneUI:addPromotionIcon()
    -- 倒计时
    local activityData = UserData:getActivity()
    local time
    local config
    for k,v in pairs(activityData) do
        if tonumber(k) then
            if v.type == "sp_offer_1" then
                time = tonumber(v.offerDuration-(os.time() - v.startTime))
                config = v
                break
            end
        end
    end
    if not config or not time or time < 0 then
        return
    end
    local hour = math.modf(time/3600)
    local min = math.modf((time%3600)/60)
    -- timeimg
    local timeimgBtn = UIButton.new()
    timeimgBtn:setNormalImage("#promotion_icon.png")
    timeimgBtn:setAnchorPoint(0.5,0.5)
    timeimgBtn:setScale(1.1)
    local pSize = timeimgBtn:getMenuItem():getContentSize()
    timeimgBtn:setItemPosition(pSize.width+7-50,display.height-300+25-30)
    timeimgBtn:setTouchFunc(function ()
        --  gold shop
        local parent = self:getParent()
        if UserData:getNoHatchAccountMode() then
            AdministrateFrame:getInstance():newBox("NetworkWarnning",self, 1)
            return
        elseif utils.getInternetConnectionStatus() then
             AdministrateFrame:getInstance():transferBox(nil,"NetworkWarnning",nil,parent);
             return
        end
        AdministrateFrame:getInstance():transferBox(nil,"BuyStepLimitBox",config,parent)
    end)
    self.timeimgBtn=true
    self:addChild(timeimgBtn)
    local timeimg = timeimgBtn:getMenuItem()
    local addGapY = 0-timeimg:getContentSize().height / 2 + 35
    local addGapX = 2
    -- hour
    local lableConfig  = {
        text = tostring(hour),
        -- font = FONT,
        size = 28,
        color = cc.c3b(255, 255, 255),
        x = timeimg:getContentSize().width / 2,
        y = addGapY,
        align = cc.TEXT_ALIGNMENT_LEFT,
        anchor = cc.p(0, 0),
        self=timeimg,
        shadow_color = cc.c4b(40,40,40,255),
        shadow_size = cc.size(2,-4),
        shadow_radius = 2,
    }
    local countdown1 = utils:createLabel(lableConfig)
    -- "H"
    lableConfig.text = "H"
    lableConfig.size = 19
    lableConfig.x = countdown1:getPositionX() + countdown1:getContentSize().width + 5
    lableConfig.y = 5+addGapY
    local countdown2 = utils:createLabel(lableConfig)
    -- min
    lableConfig.text = tostring(min)
    lableConfig.size = 28
    lableConfig.x = countdown2:getPositionX() + countdown2:getContentSize().width + 5
    lableConfig.y = addGapY
    local countdown3 = utils:createLabel(lableConfig)
    -- "min"
    lableConfig.text = "MIN"
    lableConfig.size = 19
    lableConfig.x = countdown3:getPositionX() + countdown3:getContentSize().width + 5
    lableConfig.y = 5+addGapY
    local countdown4 = utils:createLabel(lableConfig)
    -- pos
    local allwidth = countdown1:getContentSize().width + countdown2:getContentSize().width + countdown3:getContentSize().width + countdown4:getContentSize().width + 15
    countdown1:setPositionX((timeimg:getContentSize().width - allwidth)/2 + addGapX)
    countdown2:setPositionX(countdown1:getPositionX() + countdown1:getContentSize().width + addGapX)
    countdown3:setPositionX(countdown2:getPositionX() + countdown2:getContentSize().width + addGapX)
    countdown4:setPositionX(countdown3:getPositionX() + countdown3:getContentSize().width + addGapX)
    -- 定时5s循环
    local gap = 5
    if self.sch == nil then
        self.sch = scheduler.scheduleGlobal(function()
            time = time - gap
            local activityData = UserData:getActivity()
            local sign = false
            if activityData then
                for k,v in pairs(activityData) do
                    if tonumber(k) then
                        if v.type == "sp_offer_1" then
                            sign = true
                            break
                        end
                    end
                end
            end
            if not sign then
                time = 0
            end
            if time <= 0 then
                -- 删除活动信息,并设置下次开始检测时间
                local localData = UserData:getActivity()
                for k,v in pairs(localData) do
                    if tonumber(k) then
                        if v.type == "sp_offer_1" then
                            localData[k] = nil
                            localData.limitReStartTime = os.time() + tonumber(v.coolDownDuration)
                        end
                    end
                end
                UserData:setActivity(localData)
                -- 重置界面
                timeimg:removeFromParent()
                    self.timeimgBtn=false
                if self.sch then
                    scheduler.unscheduleGlobal(self.sch)
                    self.sch = nil
                end
            else
                hour = math.modf(time/3600)
                min = math.modf((time%3600)/60)
                countdown1:setString(tostring(hour))
                countdown3:setString(tostring(min))
                local allwidth = countdown1:getContentSize().width + countdown2:getContentSize().width + countdown3:getContentSize().width + countdown4:getContentSize().width + 15
                countdown1:setPositionX((timeimg:getContentSize().width - allwidth)/2 + addGapX)
                countdown2:setPositionX(countdown1:getPositionX() + countdown1:getContentSize().width + addGapX)
                countdown3:setPositionX(countdown2:getPositionX() + countdown2:getContentSize().width + addGapX)
                countdown4:setPositionX(countdown3:getPositionX() + countdown3:getContentSize().width + addGapX)
            end
        end, gap)
    end
end


function MapSceneUI:gotoLevel(level,bool)
    if self:getScene() then
        self:getScene():gotoLevel(level,bool)
    end
end

-- 更新银币
function MapSceneUI:updateSilverCoin()
    self.coinBox:updateSilverCoin(UserData:getSilverCoin())
end

-- 更新金币
function MapSceneUI:updateGlodCoin()
    self.coinBox:updateGoldCoin(UserData:getGoldCoin())
end

-- 更新进度小红点状态
function MapSceneUI:updateProgressBtn()
    if self.progress then
        self.progress:getChildByTag(10):setVisible(UserData:getPanelDot())
    end
end

-- 更新邮箱小红点
function MapSceneUI:updataMail()
    -- 先判断,如果有小红点就不再请求
    if UserData:getMailDot() then
        self:setMailBtn(true)
        do return end
    end
    -- 判断间隔时间
    local gapTime = os.time() - UserData:getMailDotTime()
    if gapTime < DOT_GAP_TIME then
        do return end
    end
    ServerProxy.getRequestLife(
    function (data)
        MessageData:getInstance():initMessages(data)
        if self and self.updateMailBtn then
            self:updateMailBtn()
        end
    end,
    function (data)
    end)
end

-- 邮箱小红点状态设置
function MapSceneUI:updateMailBtn()
    local data =MessageData:getInstance():getMessages()
    if data and #data>0 then
        for i=#data,1,-1 do
            local info = data[i]
            if info.name==nil then
                table.remove(data,i)
            end
        end
        if #data>0 then
            UserData:updateMailDot(true)
        else
            UserData:updateMailDot(false)
        end
    end
    if self then
        self.mail:getChildByTag(12):setVisible(UserData:getMailDot())
    end
end
-- set mail dot
function MapSceneUI:setMailBtn(bool)
    UserData:updateMailDot(bool)
    self.mail:getChildByTag(12):setVisible(UserData:getMailDot())
end

-- 更新任务小红点状态
function MapSceneUI:updateMissionBtn()
    -- facebook
    if not UserData:getSwitchFBState() then
        -- 先判断,如果有小红点就不再请求
        if UserData:getMissionDot() then
            self:setMissionBtn(true)
            do return end
        end
        -- 判断间隔时间
        local gapTime = os.time() - UserData:getMissionDotTime()
        if gapTime < DOT_GAP_TIME then
            do return end
        end
    end

    taskUtils.getMasterTaskList(function()
        if self.isShowMissionRed then
            self:isShowMissionRed()
        end

    end)
    if taskUtils.isDailyStart() then
        taskUtils.getServerDailyList(1,function ()
            if self.isShowMissionRed then
                self:isShowMissionRed()
            end
        end)
    end

end
-- 判断是否显示小红点
function MapSceneUI:isShowMissionRed()
    self:setMissionBtn(false)
    taskUtils.gettotalNum()
    local b =taskUtils.dailyAchieve()
    for k,v in pairs(b) do
        if v[1] then
            self:setMissionBtn(true)
            break
        end
    end
    local a =taskUtils.Achieve()
    for k,v in pairs(a) do
        if v then
            self:setMissionBtn(true)
            break
        end
    end
end
-- set mission dot
function MapSceneUI:setMissionBtn(bool)
    UserData:updateMissionDot(bool)
    self.btnMission:getChildByTag(12):setVisible(bool)
end

-- 更新daily小红点状态
function MapSceneUI:updateDailyBtn()
    -- 先判断,如果有小红点就不再请求
    -- daily task
    if UserData:getdailyBtnDot() then
        self:setDailyDitVisible(true)
        do return end
    end
    -- 判断间隔时间
    -- local gapTime = os.time() - UserData:getdailyBtnDotTime()
    -- if gapTime < DOT_GAP_TIME then
    --     do return end
    -- end
    self.dailyNum=0
    ServerProxy.getDailyTaskList(function(data)
        if data.data.code ==1 then
            DailyMissionData.setComplete(data.data)
            if self.isShowDailyDit then
                self:isShowDailyDit()
            end
        end
    end,function ()
        dump("error:getDailyTaskList")
    end)
    -- daily init
    ServerProxy.getDailyInit(function (data)
        if data.data.code ==1 then
            DailyMissionData.setDayTime(data.data.day)
            DailyMissionData.setWeekTime(data.data.week)
            DailyMissionData.setMondayTime(data.data.monday)
            DailyMissionData.setDayPrice(data.data.price)
            DailyMissionData.setNum(data.data.residueNumber)
            DailyMissionData.setDaily_week(data.data.weekOfYear)
            DailyMissionData.setTask(data.data.dailyTask)
            if self.isShowDailyDit then
                self:isShowDailyDit()
            end
        end
    end,function(data)
        dump("error:getDailyInit")
    end)
end

function MapSceneUI:isShowDailyDit()
    self.dailyNum=self.dailyNum+1
    if self.dailyNum>=2 then
        DailyMissionData.setTotalData();
        local totalData = DailyMissionData.getTotalData()
        if DailyMissionData.getMondayTime()<=0 then
            if DailyMissionData.getNum()>0 then
                return self:setDailyDitVisible(true)
            else
                return self:setDailyDitVisible(DailyMissionData.getRewCnt()>0 and true or false)
            end
        else
            self.timeP=DailyMissionData.getMondayTime()
            self.timeS=socket.gettime()
            self.dailyStr:setVisible(false)
            self:setTime()
            self.timeNode:setVisible(true)

            self.value =  scheduler.scheduleGlobal(function()
                 self:setTime()
             end ,0.1)
        end
        return self:setDailyDitVisible(false)
    end
end
-- set daily btn dot
function MapSceneUI:setDailyDitVisible(bool)
    UserData:updatedailyBtnDot(bool)
    if self.btnDaily then
        self.btnDaily:getChildByTag(12):setVisible(bool)
    end
end

function MapSceneUI:setTime()
    local tNum=self.timeP-math.floor((socket.gettime()-self.timeS));
    self.time:setString(utils.conversionTime(tNum))
    self.time.tt =tNum
    -- dump(tNum)
    if tNum<=0 then
        scheduler.unscheduleGlobal(self.value)
        self.value=-1
        self.timeNode:setVisible(false)
        self.dailyStr:setVisible(true)
    end
end

function MapSceneUI:silverCoinAnimation()
	self.coinBox.silverIcon:stopAllActions()
	local scaleOut  = cc.EaseSineOut:create(cc.ScaleTo:create(3/60,1.2))
	local scaleIn   = cc.EaseSineOut:create(cc.ScaleTo:create(5/60,1))
	local seqScale  = cc.Sequence:create(scaleOut,scaleIn)
	self.coinBox.silverIcon:runAction(seqScale)
end

function MapSceneUI:DailyBtnShake()
    if UserData:getLife()<=1 then
        if self.btnDaily then
            local rotateR = cc.RotateTo:create(0.025, 15, 15)
            local rotateM = cc.RotateTo:create(0.025, 0, 0)
            local rotateL = cc.RotateTo:create(0.025, -15, -15)
            local scaleBig = cc.ScaleTo:create(0.03, 1.25);
            local scaleNor = cc.ScaleTo:create(0.03, 1);
            local seq      = cc.Sequence:create(rotateR,rotateM,rotateL,rotateM)
            local repeatA  = cc.Repeat:create(seq,5)
            local finSeq   = cc.Sequence:create(scaleBig,repeatA,scaleNor)
            self.btnDaily:runAction(finSeq)
        end
    end
end

-- showTv
function MapSceneUI:showTv(useToonsSdk)
    local tv = UIButton.new()
    tv:setNormalSprite(display.newSprite("#toonTv.png"))
    -- tv:getMenuItem():setScale(0.9)
    tv:setAnchorPoint(0.5, 0.5)
    local tvSize = tv:getMenuItem():getContentSize()
    -- start:setScale(0.92)
    tv:setPosition(display.width-tvSize.width*0.5-15,display.height-690)
    tv:setTouchFunc(function ()
        if not self:getParent():getParent().isTouchMoved and not self.settingBar.showSettingItems then
            if utils.getInternetConnectionStatus() then
                AdministrateFrame:getInstance():newBox("NetworkWarnning",self)
                return
            end
            -- if device.platform=="ios" then
            --      local gf = cc.Application:getInstance():openURL("com.rovio.toonstv://");
            --      if  not gf then
            --          cc.Application:getInstance():openURL("itms-apps://itunes.apple.com/app/toonstv-angry-birds-video-app/id826347453?mt=8");
            --      end
            --  else
            --      local className="com.mybo.game.GameActivity"
            --      local args = { "com.rovio.Toons.tv" }
            --      local sigs = "(Ljava/lang/String;)V" --传入string参数，无返回值
            --      local ok,ret = luaj.callStaticMethod(className,"startApplication",args,sigs)
            --
            --     if not ok then
            --         cc.Application:getInstance():openURL("https://play.google.com/store/apps/details?id=com.rovio.Toons.tv&hl=en");
            --     end
            -- end
            if device.platform=="ios" or not useToonsSdk then
                cc.Application:getInstance():openURL("https://sdk.toons.tv/?clientId=rovio_3bb4586d&subClientId=blast")
            else
                mybo.HatchSDK:getInstance():luaOpenToons()
            end
        end
    end)
    self:addChild(tv)
    -- mission不显示时,默认顶上去
    if not self.btnMission:isVisible() then
        tv:setPosition(self.btnMission:getPosition())
    end
end

-- 显示新版设置入口
function MapSceneUI:initSettingsBtn()
    local settingsBtn = UIButton.new()
    settingsBtn:setNormalSprite(display.newSprite("#setting_btn.png"))
    local btnSize = settingsBtn:getMenuItem():getContentSize()
    settingsBtn:setPosition(btnSize.width*0.5 + 15,display.height*0.06)
    settingsBtn:setTouchFunc(function ()
        self:performWithDelay(
        function ()
            self:addChild(SettingsPanel.new(),10000,"SettingsPanel")
        end,6.0/60.0)
    end)
    self:addChild(settingsBtn, 301)
end

-- 旧版设置入口
function MapSceneUI:initOldSettingBar()
    -- 添加设置条按钮
    self.settingBar = SettingBar.new()
    self:addChild(self.settingBar,300,"SettingBar")
    self.settingBar:setVisible(false)
end

function MapSceneUI:onExit()
    -- SchedulerManager:getInstance():allStop()
    if self.adnew ~=-1 then
        scheduler.unscheduleGlobal(self.adnew)
         self.adnew =-1
    end
    scheduler.unscheduleGlobal(self.value)
    scheduler.unscheduleGlobal(self.DailyBtnShakeValue)
    scheduler.unscheduleGlobal(self.mailBtnValue)
    if self.sch then
        scheduler.unscheduleGlobal(self.sch)
        self.sch = nil
    end
    if self.towerTimeSch then
        scheduler.unscheduleGlobal(self.towerTimeSch)
        self.towerTimeSch = nil
    end
end

function MapSceneUI:onEnter()

    -- if Activity then
    --    Activity=false
    --    AdministrateFrame:getInstance():newBox("ActivityPacks",self,self.coinBox)
    -- end
end

-- *********************************************** 测试 ***********************************************

-- 热更新
function MapSceneUI:updateLayout()
    -- local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    local url = "http://192.168.16.111:8080/Desktop/LanguagePosOffset.lua"
    local request = network.createHTTPRequest(function(event)
        local request = event.request
        if event.name == "completed" then
            local response = request:getResponseString()
            print(response)
            LanguagePosOffset = loadstring(response)()

            local url2 = "http://192.168.16.111:8080/Desktop/Ge.lua"
            local request2 = network.createHTTPRequest(function(event)
                local request2 = event.request
                if event.name == "completed" then
                    local response2 = request2:getResponseString()
                    print(response2)
                    Ge = loadstring(response2)()

                    --  require("app.LoadingScene"):getInstance():replaceScene("app.mapscene.MapScene",nil,UserData:getClickLevel())
                end
            end, url2, "GET")
            request2:start()

            --  require("app.LoadingScene"):getInstance():replaceScene("app.mapscene.MapScene",nil,UserData:getClickLevel())
        end
    end, url, "GET")
    request:start()
end

-- 代码热更新
function MapSceneUI:hotUpdate(fileName)
    local function hotUpdateFun()
        local url = "http://192.168.16.211:8080/ab-blast/src/app/mapscene/popupview/" .. fileName .. ".lua"
        local request = network.createHTTPRequest(function(event)
            local request = event.request
            if event.name == "completed" then
                if not cc.FileUtils:getInstance():isFileExist(device.writablePath.."app/mapscene/popupview/" .. fileName .. ".lua") then
                    cc.FileUtils:getInstance():createDirectory(device.writablePath.."app/mapscene/popupview");
                    --body...
                end
                request:saveResponseData(device.writablePath.."/" .. fileName .. ".lua")
                dump(device.writablePath.."app/mapscene/popupview/" .. fileName .. ".lua")

                package.loaded[fileName]=nil

                dump("完成")
            end
        end, url, "GET")
        request:start()
    end
    -- btn
    local swithButton = UIButton.new()
    swithButton:setNormalImage("#lv_item_unlock_img.png")
    swithButton:setTouchFunc(hotUpdateFun)
    swithButton:addTo(self)
    swithButton:setScale(1.2)
    swithButton:setItemPosition(display.width - swithButton:getMenuItem():getContentSize().width-100,300)
end

-- 打开弹框测试按钮
function MapSceneUI:openTestPopBox()
    -- add test pop box
    local btnFBGift1 = UIButton.new()
    btnFBGift1:setNormalImage("#fb_login_gift.png")
    local fbGiftSize = btnFBGift1:getMenuItem():getContentSize()
    btnFBGift1:setItemPosition(display.width-fbGiftSize.width*0.5-100,display.height-880)
    btnFBGift1:setTouchFunc(function ()
         AdministrateFrame:getInstance():newBox("popBoxPanel",self)
    end)
    self:addChild(btnFBGift1)
end

-- 左上角显示本地关卡包
function MapSceneUI:showLocalPointPackage()
    if mybo.AppGameConfig:GetIsOpenCheckPointPackage() then
        local params={
            bg = "#lv_item_unlock_img.png"
        }
        local function showDebugDialog()
            self:onExit()
            local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
            local event = cc.EventCustom:new("MapSceneTouch.showScene")
            event.state = "showDebugDialog"
            eventDispatcher:dispatchEvent(event)
        end
        local swithButton = Button.new();
        swithButton:initOrdinary(showDebugDialog,params)
        swithButton:addTo(self)
        swithButton:pos(swithButton:getCascadeBoundingBox().size.width*0.5,display.height-100-swithButton:getCascadeBoundingBox().size.height*0.5)
        swithButton.exNode:setCascadeOpacityEnabled(true)
        swithButton.exNode:setOpacity(250)
    end
end

-- 右下角显示本地关卡包
function MapSceneUI:showLocalPointPackageAndDig()
    if mybo.AppGameConfig:GetIsOpenCheckPointPackage() then
        local btnDailyDemo = UIButton.new()
        btnDailyDemo:setNormalImage("#DMBtn.png")
        btnDailyDemo.label:setString('调试地图')
        btnDailyDemo.label:setAnchorPoint(cc.p(0,0.5))
        local dailySize = btnDailyDemo:getMenuItem():getContentSize()
        btnDailyDemo:setItemPosition(display.width-dailySize.width*0.5-200,display.height-950)
        btnDailyDemo:setTouchFunc(function ()
            AdministrateFrame:getInstance():newBox("DigPanel",self)
        end,false)
        self:addChild(btnDailyDemo)
    end
end

return MapSceneUI;
