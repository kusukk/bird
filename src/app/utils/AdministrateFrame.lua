--
-- Author: pengxianfeng
-- Date: 2017-04-27 18:32:01
--
-- 打开和关闭box 的统一管理

local utils = require("app.utils.utils")
-- require "app.config.adsConfig"
require('app.data.UserData')
-- local ServerProxy = require "app.network.ServerProxy"
-- local ADManage = require('app.common.ADManage')
AdministrateFrame = class("AdministrateFrame")

local sington = nil;


function AdministrateFrame:getInstance()
    if not sington then
        sington=AdministrateFrame.new()
    end
    return sington
end

function AdministrateFrame:ctor()
    self:clear()
end
-- 窗口名,放在哪个scene上,参数
-- 暂时不能放在scene上 ,只能放在 scene.ui上
function AdministrateFrame:newBox(name,scene,args)
    if not scene then
        dump("err:scene is nil")
        do return end
    end
    -- 检测窗口是否可弹
    if not self:checkBoxShow(name, args) then
        do return end
    end

    if not self.layer then
        self.layer=cc.LayerColor:create(cc.c4b(0,0,0,35))
        self.layer:setCascadeOpacityEnabled(true)
        self.layer:setCascadeColorEnabled(true)
        scene:addChild(self.layer)
    end

    table.insert(self.tab,1,name)
    local view = require (name).new(args)

    scene:addChild(view)
    view:setName(name)
    self.zOrder= self.zOrder+2
    view:setLocalZOrder(self.zOrder)
    self.layer:setLocalZOrder(self.zOrder-1)
    --dump(view:getLocalZOrder(),"view")
    --dump(self.layer:getLocalZOrder(),"layer")
    return view
end

function AdministrateFrame:onKeyback()
    local scene = display.getRunningScene()
    local tradeLoading = scene:getChildByName('TradeLoading')
    if tradeLoading then
        do return true end
    end

    local fbLogin = scene:getChildByName('loginUI')
    if fbLogin then
        do return true end
    end

    if #self.tab==0 then
        return false;
    end

    -- 找到tab所在的scene
    local function getScene(scene,tabName)
        if scene:getChildrenCount()>0 then
            if scene:getChildByName(tabName) then
                return scene
            else
                local child = scene:getChildren()
                for i=1,#child do
                    scene = getScene(child[i],tabName)
                    if scene then
                        return scene
                    end
                end
                return nil
            end
        else
            return nil;
        end
    end

    local tabName = self.tab[1]
    scene = getScene(scene,tabName)
    if not scene then
        return false
    end
    scene:getChildByName(self.tab[1]):onClose()

    return true
end

-- 删除窗口 ,要删除的窗口  bool 不要写,会错
function AdministrateFrame:removeBox(targetName,scene,bool)
    dump("zaiai")
    local name
    local target
    if type(targetName) == 'string' then
        name = targetName
        target = scene:getChildByName(name)
    else
        if targetName.node == nil then
            return
        end
        name = targetName:getName()
        target = targetName
    end
    for i,v in ipairs(self.tab) do
        if v==name then
            self.zOrder=self.zOrder-2
            table.remove(self.tab,i)
            target:removeFromParent()
            break;
        end
    end

    if #self.tab<=0 and not bool then
        if self.layer then
            self.layer:removeFromParent()
            self.layer=nil
        end
    else
        if self.layer then
            self.layer:setLocalZOrder(self.zOrder-1)
            --dump(self.layer:getLocalZOrder(),"local zorder")
        end
    end
end
-- 要删除的窗口, 要开启的窗口名,开启窗口的参数
function AdministrateFrame:transferBox(target,name,args,scene)
    local view =nil
    if #self.tab<=0 then
        dump("err:没有可以删除的窗口")
        view= self:newBox(name,scene,args)
        return view
    end
    if not target and scene then
        target = scene:getChildByName(self.tab[1])
    elseif  not scene and target then
        scene =target:getParent()
    elseif not target and not scene then
        dump("err:not target and not scene");
        return
    end
    if not target then
        dump("err: target is nil")
        return
    end

    local closeParams = clone(target.closeParams)
    self:removeBox(target,nil,true)
    --dump(name,scene)
    --dump(args)
    view =self:newBox(name,scene,args)
    if view ==nil then
        dump("view is nil")
        return
    end
    view.closeParams=closeParams
    return view
end

-- 隐藏窗口
function AdministrateFrame:hideBox(targetName, scene)
    local name
    local target
    if type(targetName) == 'string' then
        name = targetName
        target = scene:getChildByName(name)
    else
        if targetName.node == nil then
            return
        end
        name =targetName:getName()
        target = targetName
    end
    for i,v in ipairs(self.tab) do
        if v==name then
            target:setVisible(false)
            break;
        end
    end
end

-- 显示窗口
function AdministrateFrame:showBox(targetName, scene)
    local name
    local target
    if type(targetName) == 'string' then
        name = targetName
        target = scene:getChildByName(name)
    else
        if targetName.node == nil then
            return
        end
        name =targetName:getName()
        target = targetName
    end
    for i,v in ipairs(self.tab) do
        if v==name then
            target:setVisible(true)
            break;
        end
    end
end

-- tab中是否存在
function AdministrateFrame:hadBox(name)
    for i,v in ipairs(self.tab) do
        if v==name then
            return true
        end
    end
    return false
end

function AdministrateFrame:getLayer()
    return self.layer,#self.tab;
end

function  AdministrateFrame:clear()
    self.tab={}
    self.num=0
    self.layer =nil
    self.zOrder=50000
    self.hideTab={}
end

function onGameClose()
    dump("删除")
    -- if #AdministrateFrame:getInstance().tab>=1 then
    --     AdministrateFrame:getInstance():removeBox(AdministrateFrame:getInstance().tab[1])
    -- end
    --dump("MapScene:onKeyback")
    local keyback = AdministrateFrame:getInstance():onKeyback()
    dump(keyback)
end

-- 弹框优先级列表
-- 值越大优先级越高,优先级越高显示越前,当已经有同级或者高级的弹框存在,则不再弹
local boxPriorityList = {
    ["ExitGameTip"] = 15,
    ["NetworkWarnning"] = 14,
    ["PiggyTowerNetReLine"] = 14,
    -- 商店
    ["GoldShop"] = 13,
    ["SilverShop"] = 12,

    ["smallBox"] = 11,
    ["HeartPurchasePanel"] = 11,

    -- piggy自动弹框
    ["TowerUnlockPanel"] = 10.5,
    ["TowerRankReward"] = 10.5,
    ["PigTowerPassGuide"] = 10.5,
    ["CheckListPanel"] = 10,

    ["TipBox"] = 10,
    ["ChapterPreparePanel"] = 10,
    ["SettingBox"] = 10,
    ["MessagePanel"] = 10,
    ["MissionPanel"] = 10,
    ["DailyPanel"] = 10,
    ["PageFrame"] = 10,
    ["InvitePanel"] = 10,
    ["FBLikePanel"] = 10,
    ["BuyStepLimitBox"] = 10,
    ["UnlockPanel"] = 10,
    ["FriendsRequestBox"] = 11,

    -- piggy界面弹框
    ["ChestPanel"] = 10,
    ["ExplainPanel"] = 10,
    ["GalleryPanel"] = 10,
    ["TowerLeaderBoardPanel"] = 10,
    ["LevelRewardBox"] = 10,

    -- 自动弹出框
    ["RankShareBox"] = 9,
    ["PlayWithFriends"] = 9,
    ["Notification"] = 9,
    ["AdPopupPanel"] = 9,

    ["popBoxPanel"] = 8,
}

-- 最高权限窗口
local topestBox = {
    "ExitGameTip",
    "NetworkWarnning",
}

-- 检测弹框是否可弹
function AdministrateFrame:checkBoxShow(boxName, args)
    if not boxName or boxName == "" then
        do return end
    end
    -- 检测是否已存在
    if table.keyof(self.tab, boxName) then
        print("AdministrateFrame err: box exist:"..boxName)
        return false
    end
    -- 检测优先级
    if self:checkTopestPriority(boxName) then
        print("AdministrateFrame topest Box:"..boxName)
        return true
    end
    -- 特殊处理 FriendsRequestBox
    local autoPopList = {
        "FriendsRequestBox",
        "PlayWithFriends",
        "Notification",
        "AdPopupPanel",
    }
    if table.keyof(autoPopList, boxName) and UserData.showNextlevel then
        if boxName == "FriendsRequestBox" then
            if args then
                print("err: can't show "..boxName)
                return false
            end
        else
            print("err: can't show "..boxName)
            return false
        end
    end
    -- 检测优先级
    for i,v in ipairs(self.tab) do
        print("tab is:")
        dump(self.tab)
        -- 检测
        if boxPriorityList[v] and boxPriorityList[boxName] then
            if not self:comparePriority(v, boxName) then
                print("error:box can't show cause priority,the box is:",v,"the fail box is:",boxName)
                return false
            end
        end
    end
    return true
end

-- 检测是否为最高优先级
function AdministrateFrame:checkTopestPriority(boxName)
    for i,v in ipairs(topestBox) do
        if v == boxName then
            return true
        end
    end
    return false
end

-- 检测优先级
function AdministrateFrame:comparePriority(existName, newName)
    print("compare is :",boxPriorityList[existName],boxPriorityList[newName])

    if boxPriorityList[existName] >= boxPriorityList[newName] then
        print("prority not enough")
        return false
    else
        return true
    end
end

return AdministrateFrame
