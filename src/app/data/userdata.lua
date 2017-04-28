--
-- Author: pengxianfeng
-- Date: 2017-04-26 14:14:07
--
require("app.consts")
require("socket")
require("app.config.config")
-- require('app.data.LogData')
local utils = require("app.utils.utils")
-- local levelConfig
-- local GameState=require(cc.PACKAGE_NAME .. ".cc.utils.GameState")
print("cc.PACKAGE_NAME:"..cc.PACKAGE_NAME)
-- isShowGuide = false

-- 防止本地数据被修改，经过异或运算后再存储,取数据时先异或再用
local function encodeData(num)
    return num*9+123
end
local function decodeData(num)
    return (num-123)/9
end

UserData = {}
-- 注:UserData存储的bool型数据不进行保存状态,以便再次进入游戏时使用初始默认状态

-- 服务器类型(修改服务器需要重新安装才能起作用!!!)
-- 0:demo
-- 1:online
-- 2:online 测试
UserData.serverURLType = 1

-- log服务器类型(修改服务器需要重新安装才能起作用!!!)
-- 0:demo
-- 1:online
UserData.logServerURLType = 1

-- 登录平台
-- 0:fisrt time
-- 1:guest
-- 2:facebook
UserData.platform = 0

-- 邮箱小红点标志位
UserData.mailDot=false
UserData.mailDotTime = 0

-- 任务小红点标志位
UserData.missionDot = false
UserData.missionDotTime = 0

-- daily btn 小红点标志位
UserData.dailyBtnDot = false
UserData.dailyBtnDotTime = 0

UserData.comment = nil
-- UUID 设备ID
UserData.UUID = ""

-- rovioUUID
UserData.rovioUUID = ""
UserData.customerId = 0

-- serverName
UserData.serverName = ""

-- Facebook ID
UserData.FacebookId = ""

-- 昵称
UserData.name = ""

-- 用户 id 服务器生成返回
UserData.userId = ""

-- 是否登录Hatch标志
UserData.HatchLoginState = false

-- hatch 注册失败,无帐号状态标志位
UserData.noHatchAccountMode = false

-- 地图包名称 默认default
UserData.mapName = 'default'

-- 记录打开游戏次数
UserData.runGameTimes = 0

--金币
-- UserData.goldCoin = encodeData(160)
-- 默认金币数目为50  2016年12月05日
UserData.goldCoin = encodeData(50)
UserData.defaultGold = UserData.goldCoin
-- 是否已经接收赠送的金币
UserData.isReceiveSendGold = 0
-- 银币
UserData.silverCoin = encodeData(400)

-- 血量
UserData.life = encodeData(5)

-- 宝箱
UserData.boxNum = 0

-- 时间戳
UserData.timeStamp = 0
UserData.limitStamp = 0

--用户道具y
UserData.items = {}

-- 用户道具加密
UserData.isItemsEncode = 0

--用户每一关消耗的金币
UserData.goldCoinSpent = 0

-- 交易数据
UserData.purchaseData = {}

-- {1, 577777, 3}
UserData.passedLevels = {}
UserData.currentLevel = encodeData(1)

UserData.tasks = {}

UserData.elements = {}

-- 记录掉落的hatchling
UserData.dropHatchlings = {}

-- 当前点击的关卡
UserData.clickLevel = encodeData(1)

-- 当前关卡使用的关前道具
UserData.currentPreProp = {}

-- 进入关卡默认创建levelUpdate命令
UserData.levelCommand = {}

-- 记录每一关打的次数
UserData.levelCounts = {}

-- 记录goldShop打开次数打点
-- 记录每次打开金店时间戳
UserData.openGoldShopSign = {}

-- 存储quest已领取任务
UserData.masterCompleted = {}

-- 是否正在转换道具
UserData.isTransforItem = false

UserData.inviteTime = 0

-- 邀请送炸弹道具的数目
UserData.sendBombNum = 0

-- piggyTower各个版本第一次进入记录
UserData.piggyTowerFirstSign = {}
-- 记录关卡奖励领取
UserData.piggyTowerLevelReward = {}

--记录最高关卡难度信息
UserData.levelDiff = {
    recordLevel=0,--当前记录的是哪一关
    failCount=0,--该关卡失败的次数
    timeStamp=0,--每天0点时间戳
    diff=0, --该关卡的难度系数
    isLowestDiffUsed=0,--今天最低难度次数是否用过,每天只有一次机会触发最低难度
}

-- 记录连续失败关卡状态
UserData.continueFailInfo = {
    level = 0,
    count = 0,
    isGet = 0,
}

--服务器地址
UserData.centerServer = "https://global.mybogames.com/v1"
if UserData.serverURLType and UserData.serverURLType == 0 then
    UserData.centerServer = "http://demo2.global.mybogame.com/v1"
elseif UserData.serverURLType and UserData.serverURLType == 2 then
    UserData.centerServer = "http://54.166.19.129:4678/v1"
end
UserData.zoneServer = ""

-- log url
UserData.logServer = "https://log.us.mybogames.com"
if UserData.logServerURLType and UserData.logServerURLType == 0 then
    UserData.logServer = "http://demo2.log.cn.mybogame.com"
end

--地图版本
UserData.mapVersion = mybo.AppGameConfig:GetInitMapVersion()

--资源版本
UserData.resVersion = mybo.AppGameConfig:GetInitResVersion()

--同步hatch
UserData.hatchLevelScore={}

--同步命令
UserData.netCommands = {}

-- friendsData
UserData.friendsData = nil
UserData.mapOldFriendsData = nil
UserData.panelOldFriendsData = nil
UserData.panelDot = false

--facebook
UserData.facebookInfo = {}

-- facebook 登录状态切换标志位
UserData.switchFBState = 0

-- 更新好友时间戳
UserData.checkFriendsTime = 0

-- 检测PlayWithFriends弹框时间
UserData.nextPlayWithFriendsTime = 0

-- 分数关卡超越弹框触发次数
UserData.checkRankShareTime = 1
UserData.checkRankShareData = tostring(os.date("%x", os.time()))

-- 当前的场景
UserData.currentScene = "app.StartAndUpdateScene"
UserData.lastScene = ''

-- 当前Battle类型，normal or dig
UserData.battleType = "normal"

-- 胜利显示下一关
UserData.showNextlevel = false

-- 公告
UserData.notifications = {}
UserData.workedNotifications = {}

-- 促销信息
UserData.activityConfig = {}

-- 记录最近一次失败关卡
UserData.lastLostLevel = 0

-- 记录当前的付费促销方案(battlescene 更新),默认为1
UserData.payerPromotionType = 1

-- 记录gold shop购买的最高优先级的促销
UserData.payedPriority = 0
-- 记录gold shop 最后购买的价格
UserData.lastPayedPrice = 0

--box Coin
UserData.boxConfig = {}

UserData.propRewardLevel = 0

UserData.isDirectlySend = 1

UserData.digMapTimeStamp = 0

UserData.digMapIndexTable={5,6,1,7,2,3,4}

UserData.firstBuyStep = 1

-- 是否已有重排
UserData.hasRefreashItem = false
-- 1true,0false ,关卡动画
UserData.isAntion = 0;

--hatch监测专用数据
--纪录玩家是否观看了广告
 UserData.adWatched = 0
 --是否得到了视频广告奖励
 UserData.adOfferd = 0
 --在哪里进入的商店
 UserData.enterShop = ""
 --在哪里退出的游戏
 UserData.ExitScreen = ""
 --关卡结束清除的比例
 UserData.objective_cleared = 0
 --是否登录了gameCenter
 UserData.isLoginGameCenter = 0
 --玩家的当前排名
 UserData.rank = 1
 --游戏结束后的排名
 UserData.enRank = 1
 --
 UserData.origin_screen = "map"
--玩家购买某个包购买了多少次
 UserData.previous_time = {}

 --纪录购买的receiptId
 UserData.receiptId = ""
 --是否登录了googleplay
 UserData.isLogedGp = 1
 --是否评价了app
 UserData.isRate = false

 -- 纪录玩家邀请朋友的次数
 UserData.inviteNum = 0


-- 此处取UserDefault数据，只有当版本更新时，对新添加的字段有用。否则会被pop_data数据覆盖。
-- music
UserData.music = cc.UserDefault:getInstance():getBoolForKey("music", true)
-- effect
UserData.effect = cc.UserDefault:getInstance():getBoolForKey("effect", true)
-- 振动
UserData.ShakeVibrate=cc.UserDefault:getInstance():getBoolForKey("isOpenShakeVibrate",true)
-- 用户第一次登录 要先注册
UserData.userFirstPlayGame = cc.UserDefault:getInstance():getStringForKey("userFirstPlayGame","nil")
-- 注册过Global
UserData.hadRegGlobalSign = cc.UserDefault:getInstance():getBoolForKey("hadRegGlobalSign",false)
-- 创建帐号标志
UserData.hadCreateAccount = 0
UserData.buyCoinFailQueue = cc.UserDefault:getInstance():getStringForKey("coinFailQueue","{}")
-- 用户登录过Facebook
UserData.FBFirstLoginSign = 0

UserData.stopBack=false

function UserData:adInviteNum(num)
    self.inviteNum = self.inviteNum+1
end

function UserData:getInviteNum()
    return self.inviteNum
end


function UserData:setStopBack(bool)
     UserData.stopBack =bool
end

function UserData:isStopBack()
    return UserData.stopBack
end

-- 以下UserDefault里的设置不在pop_data里存储
-- 根据实际情况设置不需要存储
-- cc.UserDefault:getInstance():getBoolForKey("FBLoginComplete")
-- cc.UserDefault:getInstance():getBoolForKey("auto_music", false)
-- cc.UserDefault:getInstance():setIntegerForKey("m_life",decodeData(self.life))
-- cc.UserDefault:getInstance():setStringForKey("timeStamp", ""..math.ceil(num));

-- 游戏开始的时间 c++里会设置
-- cc.UserDefault:getInstance():getDoubleForKey('game_playtime_resume_key', os.time())
-- 统计玩游戏的时间 c++里会设置 统计是有异常的 但是发送到服务器的是取两个时间的间隔，是正确的
-- cc.UserDefault:getInstance():setIntegerForKey('game_playtime_key', sum)

-- 游戏地图和资源的版本信息 pop_data里应该根据实际的版本来设置，云上的不一定是正确的
-- cc.UserDefault:getInstance():getStringForKey("mapVersion",UserData.mapVersion)
-- cc.UserDefault:getInstance():getStringForKey("assetVersion",UserData.resVersion)
-- 不是老版本
-- cc.UserDefault:getInstance():getBoolForKey("userIsOldVersion",false)

-- 以下本来就没有从UserData里获取和存储数据
-- cc.UserDefault:getInstance():getBoolForKey("isComment",false)
-- cc.UserDefault:getInstance():setIntegerForKey("winNum",0)
-- cc.UserDefault:getInstance():setStringForKey("commentTime",tostring(os.time()))
-- cc.UserDefault:getInstance():setBoolForKey("guide"..tostring(id), true)
-- cc.UserDefault:getInstance():getBoolForKey("isNotification",false)
-- cc.UserDefault:getInstance():getStringForKey("unzip", "1.0.0-1")
-- cc.UserDefault:getInstance():getStringForKey("appStoreCountry","nil")
-- cc.UserDefault:getInstance():getStringForKey("appStoreVersion","1.0.0")
--hach监测用
function UserData:setIsRate(bool)
    self.isRate = bool
end

function UserData:getIsRate()
    return self.isRate
end



function UserData:setIsLoggedGp(param)
    self.isLogedGp = param
end

function UserData:getIsLoggedGP()
    if device.platform == "ios" then
        self.isLogedGp = 0
    end


    return self.isLogedGp
end
function UserData:getRceiptId()
    return self.receiptId
end


function UserData:setReceiptId(rid)

    self.receiptId =rid
end

function UserData:setPreviouTime(id)

        if UserData.previous_time[id] == nil then
            UserData.previous_time[id] = 0
        else
            UserData.previous_time[id]= UserData.previous_time[id] + 1
        end

    self:save()


end

function UserData:getPreviousTime(productID)

    if self.previous_time[productID] ~= nil then
        return self.previous_time[productID]
    else
        return 0

    end

end


function UserData:getOriScreen()
    return self.origin_screen
end

function UserData:setOriScreen(param)
    self.origin_screen = param
end





function UserData:getEnRank()
    return self.enRank
end

function UserData:setEnRank(enRank)
    self.enRank = enRank
end

function UserData:getRank()
    return self.rank
end

function UserData:setRank(rank)
    self.rank=rank
end



function UserData.setObjCleared(percent)
    UserData.objective_cleared=percent
    -- UserData:save()
end

function UserData.getObjCleared()
    return UserData.objective_cleared*100
end



function UserData:setExitScreen(param)
    UserData.ExitScreen=param
    -- UserData:save()
end

function UserData:getExitScreen()
    return UserData.ExitScreen
end


function UserData:getAdWatched()
    return UserData.adWatched
end

function UserData:setAdWatched(param)

    UserData.adWatched=param
    -- UserData:save()
end

function UserData:getadOfferd()
    return UserData.adOfferd
end

function UserData:setadOfferd(param)
    UserData.adOfferd=param
    -- UserData:save()
end

function UserData:setEnterShop(param)
    UserData.enterShop=param
    -- UserData:save()
end

function UserData:getEnterShop()
    return UserData.enterShop
end


function UserData:getIsAntion()
    return UserData.isAntion;
end

function UserData:getItemById(itemId)
    local id = tostring(itemId)
    if     id == "1281" then
        return "slingShot"
    elseif id == "1282" then
        return "H_Rocket"
    elseif id== "1283" then
        return "v_Rocket"
    elseif id == "1284" then
       return "twister"
    elseif id == "1541"  then
        return "bomb"
    elseif id =="1285" then
            return "laser_gun"
    elseif id == "1539" then
        return "3moves"
    end

end

function UserData.setIsLoginGameCenter(num)
    UserData.isLoginGameCenter=num
    -- UserData:save()
end

function UserData.getIsloginGameCenter()
    return UserData.isLoginGameCenter
end


function UserData:setIsAntion(num)
    UserData.isAntion=num
    self:save()
end

function UserData:init()


    -- GameState.init(function(param)
    --     local returnValue=nil
    --     if param.errorCode then
    --         print("gamestate error")
    --     else
    --         if param.name=="save" then
    --             local str = utils.sz_T2S(param.values)
    --             str = crypto.encryptXXTEA(str, "POPBIRDS")
    --             returnValue = {data=str}
    --         elseif param.name=="load" then
    --             local str = crypto.decryptXXTEA(param.values.data, "POPBIRDS")
    --             returnValue = utils.t_S2T(str)
    --         end
    --     end
    --     return returnValue
    -- end, "pop_data","0f69b609a9dfcae8d0eb830523e6bf2f") --md5("MYBO_GAME_POPBIRDS")

   -- 文件本地存储，创建一个文件
   local fullPathForFilename = cc.FileUtils:getInstance():fullPathForFilename("pop_data")
   local path = cc.FileUtils:getInstance():getWritablePath()




    self:load()
    UserData:initOldVersion()

    -- 道具数目加密判断
    if not self:getItemEncodeSign() then
        self:encodeAllItems()
    end
    if UserData.userFirstPlayGame == "nil" then
        UserData.userFirstPlayGame = ""..os.time()
        cc.UserDefault:getInstance():setStringForKey("userFirstPlayGame", UserData.userFirstPlayGame)
        for i=1,4 do
            -- 道具初始值
            UserData:updateItemAmount(1280+i, 3)
        end
    end

    if UserData.comment == nil then
      UserData.comment=utils.json2lua('json/comment.json')
      self:save()
    end
    -- dump(UserData.comment)
    dump(UserData.centerServer, "global server")
    dump(UserData.zoneServer, "zone server")
    if cc.UserDefault:getInstance():getIntegerForKey("firstOpenFBLike", 0) == 0 then
        cc.UserDefault:getInstance():setIntegerForKey("firstOpenFBLike", os.time())
    end
    cc.UserDefault:getInstance():setBoolForKey("isShowAD",false)
    cc.UserDefault:getInstance():setBoolForKey("outofmoves_loop",false)
    cc.UserDefault:getInstance():setBoolForKey("isOpenWinLayer",false)
end

function UserData:initUserDefault()
    UserData.music = not UserData.music
    UserData:setMusicEnabled(not UserData.music)
    UserData.effect = not UserData.effect
    UserData:setEffectEnabled(not UserData.effect)

    UserData.ShakeVibrate = not UserData.ShakeVibrate
    UserData:setOpenShakeVibrateEnabled(not UserData.ShakeVibrate)

    if self.zoneServer then
        UserData.hadRegGlobalSign = true
    end

    cc.UserDefault:getInstance():setStringForKey("userFirstPlayGame",UserData.userFirstPlayGame)
    cc.UserDefault:getInstance():setBoolForKey("hadRegGlobalSign",UserData.hadRegGlobalSign)
    cc.UserDefault:getInstance():setStringForKey("coinFailQueue",UserData.buyCoinFailQueue)
end

function UserData:getUserFirstPlayGame()
  -- print("shijian----->",os.time())
  -- print("shijian----->",tonumber(UserData.userFirstPlayGame))
  local sum = math.floor ((os.time() - tonumber(UserData.userFirstPlayGame))/(24*60*60))+1
  return sum
end

-- 判断是否是<=1.0.9的用户
function UserData:initOldVersion()
  local isFirstPlayGame = cc.UserDefault:getInstance():getStringForKey("userFirstPlayGame","nil")
  local isCheckVersion = cc.UserDefault:getInstance():getBoolForKey("userIsOldVersion",true)
  if isFirstPlayGame=="nil" and isCheckVersion then
    cc.UserDefault:getInstance():setBoolForKey("userIsOldVersion",false)
  end
end
function UserData:isOldVersion()
  return cc.UserDefault:getInstance():getBoolForKey("userIsOldVersion",true)
end
function UserData:load()
    -- local filePath = GameState.getGameStatePath()
    -- if io.exists(filePath) then
    --     local data = GameState.load()
    --     -- dump(data,"debug UserData")
    --     if(data) then
    --         for k,v in pairs(data) do
    --             UserData[k] = v
    --         end
    --     else
    --         print('ERROR! user data not match!')
    --     end
    -- end
end

function UserData:getPlatform()
    return self.platform
end

function UserData:setPlatform(platform)
   self.platform = platform
   self:save()
end

function UserData:getUserId()
    return UserData.userId
end

function UserData:setUserId(id)
    UserData.userId = id
    UserData:save()
end

-- 本地标志是否注册global
function UserData:setRegSign(sign)
    cc.UserDefault:getInstance():setBoolForKey("hadRegGlobalSign", sign)
end

function UserData:getRegSign()
    return cc.UserDefault:getInstance():getBoolForKey("hadRegGlobalSign") or false
end

-- 本地是否创建帐号
function UserData:setCreateAccountSign(bool)
    UserData.hadCreateAccount = bool and 1 or 0
    self:save()
end
function UserData:getCreateAccountSign()
    return UserData.hadCreateAccount == 1
end

function UserData:getServerName()
    return UserData.serverName
end

function UserData:setGoldCoinSpent(params)
     self.goldCoinSpent=self.goldCoinSpent+params
     UserData:save()
end

function UserData:getGoldCoinSpent()
    return self.goldCoinSpent
end

function UserData:setServerName(serverName)
    UserData.serverName = serverName
    UserData:save()
end

function UserData:setFacebookInfo(data)
    self.facebookInfo = data
    self:save()
end

function UserData:getFacebookInfo()
    return self.facebookInfo
end

-- Facebook 登录状态切换
function UserData:getSwitchFBState()
    return (UserData.switchFBState == 1) and true or false
end

function UserData:setSwitchFBState(bool)
    if bool then
        UserData.switchFBState = 1
    else
        UserData.switchFBState = 0
    end
    self:save()
end

function UserData:addLevelScoreHatch(level,score)
    if self.hatchLevelScore[tostring(level)] and self.hatchLevelScore[tostring(level)]<=score then
        return
    end
    self.hatchLevelScore[tostring(level)] = score
    self:save()
end

function UserData:removeLevelScoreHatch(Levels)
    for k,v in pairs(Levels) do
        for m,n in pairs(self.hatchLevelScore) do
            if k==m then
                self.hatchLevelScore[m] = nil
                break
            end
        end
    end
end

function UserData:getLevelScoreHatch()
    return self.hatchLevelScore
end

function UserData:setPanelDot(b)
    self.panelDot = b
end
function UserData:getPanelDot()
    return self.panelDot
end

function UserData:getMapOldFriendsData()
    return self.mapOldFriendsData or {}
end

function UserData:getPanelOldFriendsData()
    return self.panelOldFriendsData or {}
end

function UserData:getFriendsData()
    return self.friendsData or {}
end

function UserData:updateMapOldFriendsData()
    self.mapOldFriendsData = {}
    if self.friendsData then
        for i=1, #self.friendsData do
           local friend = self.friendsData[i]
           if not friend.accountId then
                self.friendsData[i].accountId =  friend.uid;
                dump(friend)
                friend.accountId = friend.uid;
           end
           if friend and friend.level then
               table.insert(self.mapOldFriendsData, friend)
           end
        end
        self:save()
    end
end

function UserData:updatePanelOldFriendsData()
    self.panelOldFriendsData = {}
    if self.friendsData then
        for i=1, #self.friendsData do
            local friend = self.friendsData[i]
            if not friend.accountId then
                self.friendsData[i].accountId =  friend.uid;
                friend.accountId = friend.uid;
            end
            if friend and friend.level then
               table.insert(self.panelOldFriendsData, friend)
            end
        end
        self:save()
    end
end

function UserData:setFriendsData(friends)
    self.friendsData = friends
    if not self.mapOldFriendsData then
        self.mapOldFriendsData = {}
        self.panelOldFriendsData = {}
    end
    for i=1,#self.friendsData do
        local f1 = self.friendsData[i]
        local exist = false;
        for j=1,#self.mapOldFriendsData do
            local f2 = self.mapOldFriendsData[j]
            if f1.accountId == f2.accountId then
                exist=true;
                break;
            end
        end
        if not exist then
            local f3 =clone(f1)
            if not f3.level then f3.level=1 end
            table.insert(self.mapOldFriendsData,f3)
            table.insert(self.panelOldFriendsData,f3)
        end
    end
    self:save()
end

function UserData:updateFriendLevel(index,level)
    if not level or self.friendsData==nil then
        do return end
    end

    local data = self.friendsData[index]
    if not data then
        print('can not find friend index:',index)
        do return end
    end
    if not data.level then
        data.level = 1
    end
    if data.level or 0 < tonumber(level) or 0 then
        data.level = tonumber(level)
    end
    self.friendsData[index] = data
    self:save()
end

function UserData:updateFriendAvatarImage(index,avatarImg)
    if not avatarImg or self.friendsData==nil then
        do return end
    end

    if self.friendsData[index] then
        self.friendsData[index].avatarImg = avatarImg
        self:save()
    end
end

-- 更新好友时间戳
function UserData:setCheckUpdateFriendTime()
    UserData.checkFriendsTime = os.time() + 2*24*3600
    self:save()
end
function UserData:checkUpdateFriendTime()
    return tonumber(UserData.checkFriendsTime) < tonumber(os.time())
end

-- 未登录facebook账户奖励提醒时间
function UserData:setCheckPlayWithFriendsTime()
    UserData.nextPlayWithFriendsTime = os.time() + 2*24*3600
    -- UserData.nextPlayWithFriendsTime = os.time() + 600
    self:save()
end
function UserData:checkPlayWithFriendsTime()
    return tonumber(UserData.nextPlayWithFriendsTime) < tonumber(os.time())
end

-- 分数关卡超越弹框触发次数
function UserData:getRankShareTime()
    return UserData.checkRankShareTime
end
function UserData:updateRankShareTime()
    -- 每日限制两次
    local date = tostring(os.date("%x", os.time()))
    if not UserData.checkRankShareData or date ~= UserData.checkRankShareData then
        UserData.checkRankShareData = date
        UserData.checkRankShareTime = 1
    else
        UserData.checkRankShareTime = UserData.checkRankShareTime + 1
    end
    self:save()
end

-- 同步命令队列
function UserData:addSyncCommand(command)
    table.insert(self.netCommands, command)
    self:save()
end

function UserData:removeAllSyncCommand()
    self.netCommands = {}
    self:save()
end

function UserData:getSyncCommands()
    return self.netCommands
end

function UserData:removeSyncCommands(commands)
    for i=1,#commands do
        local removeCommand = false
        local command1 = commands[i]
        for j=1,#self.netCommands do
            local command2 = self.netCommands[j]
            if command1.serverType==command2.serverType then
                for k,v in pairs(command1.actions) do
                    for m,n in pairs(command2.actions) do
                        if k==m then
                            removeCommand = true
                            break
                        end
                    end
                end
            end
            if removeCommand then
                table.remove(self.netCommands,j)
                break
            end
        end
    end
    self:save()
end

-- 按时间戳删除同步队列
function UserData:removeSyncCommandsPackage(data)
    if not data or type(data) ~= "table" then
        do return end
    end
    for k,v in pairs(data) do
        if tonumber(k) then
            if v.code and v.code == 1 then
                -- 删除该command
                self:removeSyncCommandsByTag(k)
            end
        end
    end
end

-- 删除单个命令
function UserData:removeSyncCommandsByTag(tag)
    -- 删除所有相同时间戳相同命令
    for i=#self.netCommands,1,-1 do
        local needRemove = false
        local command = self.netCommands[i]
        for k,v in pairs(command.actions) do
            if tostring(tag) == tostring(k) then
                needRemove = true
                break
            end
        end
        if needRemove then
            table.remove(self.netCommands, i)
            -- break
        end
    end
end

-- 同步命令队列,请求服务器失败时间戳加一
function UserData:changeCommandsActions(commands)
    for i=1,#commands do
        local command1 = commands[i]
        for j=1,#self.netCommands do
            local needChange = false
            local command2 = self.netCommands[j]
            if command1.serverType==command2.serverType then
                for k,v in pairs(command1.actions) do
                    for m,n in pairs(command2.actions) do
                        if k==m then
                            needChange = true
                            break
                        end
                    end
                end
            end
            if needChange then
                -- 时间戳加一
                local actions = {}
                for k,v in pairs(self.netCommands[j].actions) do
                    actions[tostring(k+1)] = v
                end
                self.netCommands[j].actions = actions
            end
        end
    end
    self:save()
end

-- 获取global服务器
function UserData:getCenterServer()
    return UserData.centerServer .. "?logId=" .. self:getRandomString(32)
end

-- 判断global服务器类型
function UserData:checkGlobalServerType()
    local globalUrl = UserData.centerServer
    if string.find(globalUrl, "demo") then
        return 0
    elseif string.find(globalUrl, "global") then
        return 1
    elseif string.find(globalUrl, "54") then
        return 2
    else
        return 3
    end
end

-- 获取本地zone服务器 (默认 version 为 v2)
function UserData:getZoneServer(version)
    version = version or 'v2'
    local zoneUrl = UserData.zoneServer
    if UserData.serverURLType and UserData.serverURLType == 2 then
        zoneUrl = "http://54.166.19.129:4679"
    end
    return string.format("%s/%s?logId=%s",zoneUrl,version,self:getRandomString(32))
end

function UserData:setZoneServer(server)
    if UserData.serverURLType and UserData.serverURLType == 0 then
        UserData.zoneServer = "http://" .. server
    else
        UserData.zoneServer = "https://" .. server
    end
    UserData:save()
end

-- logServer
function UserData:getLogServer(version)
    version = version or 'v1'
    return string.format("%s/%s?logId=%s",UserData.logServer,version,self:getRandomString(32))
end

function UserData:getUUID()
    if self.UUID == "" then
        self.UUID = self:genUUID()
        self:save()
    end
    return self.UUID
end

function UserData:genUUID()
    return mybo.MyboDevice:getUUID()
end

function UserData:getRovioUUID()
    return self.rovioUUID
end

function UserData:setRovioUUID(uuid)
    self.rovioUUID = uuid
    self:save()
end

function UserData:getCustomerId()
    return self.customerId
end

function UserData:setCustomerId(customerId)
    if tonumber(customerId) == 0 then
        print("LUA ERR: set customerId is 0")
        do return end
    end
    self.customerId = tonumber(customerId)
    self:save()
end

function UserData:setName (name)
    UserData.name = name
    self:save()
end

function UserData:getName ()
    return UserData.name
end

function UserData:setFacebookId (id)
    UserData.FacebookId = id
    self:save()
end

function UserData:getFacebookId ()
    return UserData.FacebookId
end

-- hatch login
function UserData:getHatchLoginState ()
    return UserData.HatchLoginState
end

function UserData:setHatchLoginState (islogin)
    UserData.HatchLoginState = islogin
    -- self:save()  -- hatch需要每次都登录
end

-- -- hatch 注册失败,无帐号状态标志位
function UserData:setNoHatchAccountMode(bool)
    -- 默认不保存本地
    UserData.noHatchAccountMode = bool
end
function UserData:getNoHatchAccountMode()
    return UserData.noHatchAccountMode and (UserData.rovioUUID == "" or not UserData.rovioUUID)
end

function UserData:getBoxConfig()
    return UserData.boxConfig
end

function UserData:setBoxConfig(config)
    UserData.boxConfig = config
    self:save()
end

-- 取金币数
function UserData:getGoldCoin()
    return decodeData(self.goldCoin)
end
-- 默认创建金币数
function UserData:getDefaultGold()
    return decodeData(self.defaultGold)
end
function UserData:setDefaultGold(num)
    self.defaultGold = encodeData(num)
    self:save()
end
-- 领取奖励金币标志位
function UserData:getReceiveSendGoldSign()
    return UserData.isReceiveSendGold == 1
end
function UserData:setReceiveSendGoldSign(bool)
    UserData.isReceiveSendGold = bool and 1 or 0
    self:save()
end
-- 取银币数
function UserData:getSilverCoin()
    return decodeData(self.silverCoin)
end

-- 设置金币数
function UserData:setGoldCoin(num)
    self.goldCoin = encodeData(num)
    self:save()
end
-- 添加金币
function UserData:addGoldCoin(num)
    self:setGoldCoin(num + decodeData(self.goldCoin))
end

-- 设置银币数
function UserData:setSilverCoin(num)
    self.silverCoin = encodeData(num)
    self:save()
end
-- 添加银币
function UserData:addSilverCoin(num)
    self:setSilverCoin(num + decodeData(self.silverCoin))
end

-- 取得当前血量
function UserData:getLife()
    return decodeData(self.life)
end

-- 设置当前血量
function UserData:setLife(num)
    if num < 0 then
        do return end
    end
    if decodeData(self.life) == MAX_LIFE then
        self:setTimeStamp(socket.gettime()*1000)
    end
    self.life = encodeData(num)
    if num >= MAX_LIFE then
        self:setTimeStamp(0)
    end
    -- 在c++中使用，暂时未处理
    cc.UserDefault:getInstance():setIntegerForKey("m_life",decodeData(self.life))
    self:save()
end

-- 取得时间戳
function UserData:getTimeStamp()
    return UserData.timeStamp;
end
-- 设置时间戳
function UserData:setTimeStamp(num)
    -- local residueTime =(socket.gettime()*1000-UserData:getTimeStamp())
    -- -(UserData:getReturnTime()*(UserData:getMaxLife() - UserData:getLife()))
    --  if residueTime>=0 then
         UserData.timeStamp=num
         cc.UserDefault:getInstance():setStringForKey("timeStamp", ""..math.ceil(num));
         self:save()
    --  end
end

-- 取得限时时间戳
function UserData:getLimitStamp()
    return UserData.limitStamp;
end

-- 设置限时时间戳

function UserData:setLimitStamp(num)
    UserData.limitStamp=num
    self:save()
end

function UserData:conversionTime(num,type)
    local text ="";
	-- if  num >= (24*60*60) then
	-- 	text = math.floor(num/(24*60*60)) .. ":"
	-- 		.. ( ( math.floor(num%(24*60*60)/(60*60))==0) and "00" or ("" ..  math.floor(num%(24*60*60)/(60*60))  ) )

	if num >= (60*60) and type ==1 then
		text = (math.floor(num/(60*60))<10 and "0" .. math.floor(num/(60*60)) or math.floor(num/(60*60))) ..":"
    end


	if num >= 60 then
		text = text .. ( (math.floor(num%(60*60)/60)<10) and  "0" .. math.floor(num%(60*60)/60) or   math.floor(num%(60*60)/60) ) .. ":"
			.. ( ((num%60)<10) and "0" .. math.floor(num%60) or math.floor(num%60)  )

	elseif num >= 0 then
		text = text .. "00:" .. ((num<10) and "0" .. num or num)
	end
    return text
end

function UserData:getPassedLevels()
    return UserData.passedLevels
end

function UserData:setPassedLevels(data)
    UserData.passedLevels = data
    self:save()
end

function UserData:getCurrentTopLevel()
    local max =0;
    for k,v in pairs(UserData.passedLevels) do
        if tonumber(k)>max then
            max=tonumber(k)
        end
    end
    return max
end

function UserData:getCurrentLevel()
    return decodeData(UserData.currentLevel)
end
function UserData:setCurrentLevel(num)
    UserData.currentLevel = encodeData(num)
    self:save();
end

function UserData:getClickLevel()
    return decodeData(UserData.clickLevel)
end
function UserData:setClickLevel(num)
    UserData.clickLevel = encodeData(num)
    self:save();
end

function UserData:updateLevelScore(level, score, passSave)
    local t =UserData.passedLevels[tostring(level)]
    t = t or {maxScore = 0,star = 0}
    local needUpdate = false
    if t.maxScore < score then
        t.maxScore = score
        needUpdate = true
    end
    UserData.passedLevels[tostring(level)] = t
    if needUpdate and not passSave then
        self:save()
    end
end

function UserData:getLevelBestScore(level)
    local t = UserData.passedLevels[tostring(level)]
    t = t or {maxScore = 0,star = 0}
    return t.maxScore
end

function UserData:resetLevelData(level, score, star)
    local levelData = UserData.passedLevels[tostring(level)]
    levelData = nil
    if score and star then
        levelData.maxScore = score
        maxScore.star = star
    end
    UserData.passedLevels[tostring(level)] = levelData
    self:save()
end

function UserData:getLevelStar(level)
    local t = UserData.passedLevels[tostring(level)]
    t = t or {maxScore = 0,star = 0}
    return t.star
end

function UserData:getLevelStarAndScore(level)
    local t = UserData.passedLevels[tostring(level)]
    t = t or {maxScore = 0,star = 0}
    return t.star,t.maxScore
end

function UserData:getCurrentStar()
    local b =0;
    for k,v in pairs(UserData.passedLevels) do
        b=b+v.star;
    end
    return b;
end

function UserData:updateLevelStar(level, star, passSave)
    local t = UserData.passedLevels[tostring(level)]
    t = t or {maxScore = 0,star = 0}
    local needUpdate = false
    if t.star < star then
        t.star = star
        needUpdate = true
    end
    UserData.passedLevels[tostring(level)] = t
    if needUpdate and not passSave then
        self:save()
    end
end

-- 道具是否加密处理标志位
function UserData:setItemEncodeSign(bool)
    UserData.isItemsEncode = bool and 1 or 0
    self:save()
end
function UserData:getItemEncodeSign()
    return UserData.isItemsEncode == 1
end

-- 加密所有道具
function UserData:encodeAllItems()
    if self.items then
        for k,v in pairs(self.items) do
            self.items[k] = {cnt = encodeData(v.cnt or 0)}
        end
        UserData:setItemEncodeSign(true)
    end
end

function UserData:getItemAmount(id)
    local t = self.items[tostring(id)] or {cnt = encodeData(0)}
    self.items[tostring(id)] = t
    return decodeData(t.cnt)
end

function UserData:updateItemAmount(id,cnt)
    if not cnt or cnt < 0 then
        return
    end
    -- 金币银币单独处理
    if tonumber(id) == 1279 then -- gold
        self:addGoldCoin(cnt)
        return
    elseif tonumber(id) == 1280 then -- silver
        self:addSilverCoin(cnt)
        return
    end
    local t = self.items[tostring(id)] or {}
    -- encode and save
    t.cnt = encodeData(cnt)
    self.items[tostring(id)] = t
    self:save()
end

function UserData:isMusicEnabled()
    -- if cc.UserDefault:getInstance():getBoolForKey("auto_music", false) then
    -- --   cc.UserDefault:getInstance():setBoolForKey("auto_music", false)
    --   self.music = false
    -- else
      self.music = cc.UserDefault:getInstance():getBoolForKey("music", true)
    -- end
    return self.music
end

function UserData:setMusicEnabled(enable)
    if self.music ~= enable then
        self.music = enable
        cc.UserDefault:getInstance():setBoolForKey("music", self.music)
        mybo.SoundPlayer:getInstance():setMusicEnbale(self.music)
        self:save()
    end
end

function UserData:isEffectEnabled()
    self.effect = cc.UserDefault:getInstance():getBoolForKey("effect", true)
    return self.effect
end

function UserData:setEffectEnabled(enable)
    if self.effect ~= enable then
        self.effect = enable
        cc.UserDefault:getInstance():setBoolForKey("effect", self.effect)
        mybo.SoundPlayer:getInstance():setSFXEnbale(self.effect)
        self:save()
    end
end

function UserData:isOpenShakeVibrateEnabled()
    self.ShakeVibrate = cc.UserDefault:getInstance():getBoolForKey("isOpenShakeVibrate", true)
    return self.ShakeVibrate
end

function UserData:setOpenShakeVibrateEnabled(enable)
    if self.ShakeVibrate ~= enable then
        self.ShakeVibrate = enable
        cc.UserDefault:getInstance():setBoolForKey("isOpenShakeVibrate", self.ShakeVibrate)
        self:save()
    end
end

function UserData:getPropRewardLevel()
   return UserData.propRewardLevel
end

function UserData:setPropRewardLevel(level)
    UserData.propRewardLevel = level
    self:save()
end

function UserData:save()
    local data = {}
    for k,v in pairs(self) do
        if k == 'netCommands' then
            if type(v) == "table" then
                for _,command in pairs(v) do
                    if type(command) == 'table' and command.class then
                        command.class = nil
                    end
                end
            end
            data[k] = v
        elseif type(v) ~= "function" then
            data[k] = v
        end
    end
    -- data写进文件
    local path = cc.FileUtils:getInstance():getWritablePath()
    cc.FileUtils:getInstance():writeToFile(data, path.."pop_data")
    
    -- GameState.save(data)
end

function UserData:getConfigVersion()
    -- 2016年11月16日
    -- return "1.0.6"
    -- 2016年11月23日
    -- return "1.0.7"
    -- 2016年12月02日
    -- return "1.0.8"
    -- 2016年12月12日
    -- return "1.0.9"
    -- 2016年12月22日
    -- return "1.1.0"
    -- 2017年02月07日
    -- return "1.1.1"
    -- 2017年01月19日, 增加piggeyTower配置
    -- return "1.1.2"
    -- 2017年3月20日, 天梯老鹰山版本
    return "1.1.3"
end

function UserData:getAppVersion()
    return mybo.MyboDevice:getAppVersion().."."..mybo.MyboDevice:getBuildVersion().."-"..UserData:getAssetVersion().."-"..UserData:getMapVersion()
end

function UserData.setAssetVersion(version)
    cc.UserDefault:getInstance():setStringForKey("assetVersion", version);
end

function UserData.getAssetVersion()
    return cc.UserDefault:getInstance():getStringForKey("assetVersion",UserData.resVersion);
end

-- FB登录并且数据同步完成
function UserData.setFBLoginComplete (val)
    cc.UserDefault:getInstance():setBoolForKey("FBLoginComplete", val)
end

function UserData.getFBLoginComplete()
    return cc.UserDefault:getInstance():getBoolForKey("FBLoginComplete") or false
end

-- 标志是否第一次登录
function UserData.setFBFirstLoginSign(bool)
    UserData.FBFirstLoginSign = bool and 1 or 0
    UserData:save()
end

function UserData.getFBFirstLoginSign()
    return UserData.FBFirstLoginSign == 1
end

-- map version
function UserData.setMapVersion (version)
    cc.UserDefault:getInstance():setStringForKey("mapVersion", version)
end

function UserData.getMapVersion()
    return cc.UserDefault:getInstance():getStringForKey("mapVersion",UserData.mapVersion)
end

-- map name
function UserData.setMapName (name)
    UserData.mapName = name
end

function UserData.getMapName()
    return UserData.mapName
end

-- 记录游戏打开次数
function UserData:updateRunGameTimes()
    self.runGameTimes = (self.runGameTimes or 0) + 1
    self:save()
end
function UserData:getRunGameTimes()
    return self.runGameTimes or 0
end

-- 邮箱小红点
function UserData:updateMailDot(bool)
    UserData.mailDot = bool
end
function UserData:getMailDot()
    return  UserData.mailDot
end
-- mail dot 最近请求时间
function UserData:updateMailDotTime(time)
    UserData.mailDotTime = time
    self:save()
end
function UserData:getMailDotTime()
    return  UserData.mailDotTime or 0
end

-- 任务小红点
function UserData:updateMissionDot(bool)
    UserData.MissionDot = bool
end
function UserData:getMissionDot()
    return  UserData.MissionDot
end
-- mission dot 最近请求时间
function UserData:updateMissionDotTime(time)
    UserData.MissionDotTime = time
    self:save()
end
function UserData:getMissionDotTime()
    return  UserData.MissionDotTime or 0
end

-- daily btn 小红点
function UserData:updatedailyBtnDot(bool)
    UserData.dailyBtnDot = bool
end
function UserData:getdailyBtnDot()
    return  UserData.dailyBtnDot
end
-- daily btn dot 最近请求时间
function UserData:updatedailyBtnDotTime(time)
    UserData.dailyBtnDotTime = time
    self:save()
end
function UserData:getdailyBtnDotTime()
    return  UserData.dailyBtnDotTime or 0
end

function UserData:updateTask(id)
    UserData.tasks[tostring(id)]=1
    self:save()
end

function UserData:getTask()
    return UserData.tasks;
end

function UserData:setTask(data)
    UserData.tasks= data
    self:save()
end

function UserData:updateElements(data)
    for k,v in pairs(data) do
        if not UserData.elements[k] then
            UserData.elements[k]=0
        end
        UserData.elements[k]= UserData.elements[k]+v
    end
    self:save()
end

function UserData:setElements(data)
    UserData.elements=data
    self:save()
end

function UserData:getElements()
    return UserData.elements
end

function UserData:getElement(id)
    return UserData.elements[id] or 0
end

-- hatchling
function UserData:addHatchlingById(id, num)
    if num <= 0 then
        return
    end
    if UserData.dropHatchlings[id] then
        UserData.dropHatchlings[id] = UserData.dropHatchlings[id] + num
    else
        UserData.dropHatchlings[id] = num
    end
    self:save()
end
function UserData:setHatchlingById(id, num)
    if num <= 0 then
        return
    end
    UserData.dropHatchlings[id] = num
    self:save()
end
function UserData:getHatchlingById(id)
    return UserData.dropHatchlings[id] or 0
end
function UserData:getHatchling()
    return UserData.dropHatchlings or {}
end

-- 统计关卡中使用的关前道具
function UserData:addCurrentPreProp (itemId)
    UserData.currentPreProp[tostring(itemId)] = 1
end

function UserData:getCurrentPreProp ()
    return UserData.currentPreProp
end

function UserData:getPrePropByID(id)
    if UserData.currentPreProp[tostring(id)] ~= nil then
        return UserData.currentPreProp[tostring(id)]
    else
       return 0
    end
end

function UserData:cleanCurrentPreProp ()
    UserData.currentPreProp = {}
end

function UserData:setCoinFailQueue (args)
  UserData.buyCoinFailQueue = args
  cc.UserDefault:getInstance():setStringForKey("coinFailQueue",UserData.buyCoinFailQueue)
end

function UserData:addCoinFailQueue (args)
  local tb = json.decode(UserData.buyCoinFailQueue)
  table.insert(tb,json.decode(args))
  UserData.buyCoinFailQueue = json.encode(tb)
  cc.UserDefault:getInstance():setStringForKey("coinFailQueue",UserData.buyCoinFailQueue)
end

function UserData:getCoinFailQueue ()
    return UserData.buyCoinFailQueue
end
-- 当前scene
function UserData:getCurrentScene()
    return UserData.currentScene
end
function UserData:setCurrentScene(scene)
    UserData.currentScene = scene
end
-- battle type
function UserData:setBattleType(mode)
    if mode ~= "normal" and mode ~= "dig" and mode ~= "PiggyTower"then
        print("ERR: battleType is err", mode)
    end
    UserData.battleType = mode
    self:save()
end
function UserData:getBattleType()
    return UserData.battleType
end
-- 上一个scene
function UserData:getLastScene()
    return UserData.lastScene
end
function UserData:setLastScene(scene)
    UserData.lastScene = scene
end

-- playGame Time
function UserData:getPlayGameTime()
    local resumeTime = cc.UserDefault:getInstance():getDoubleForKey('game_playtime_resume_key')
    local interval = os.time() - resumeTime
    local sum = cc.UserDefault:getInstance():getIntegerForKey('game_playtime_key')
    sum = sum + interval
    cc.UserDefault:getInstance():setIntegerForKey('game_playtime_key', sum)
    cc.UserDefault:getInstance():setDoubleForKey('game_playtime_resume_key', os.time())
    return sum
end

function UserData:setDirectlySend(hasSend)
    self.isDirectlySend = tonumber(hasSend) or 1
end

function UserData:hasSendFriendsLives()
    return tonumber(self.isDirectlySend) > 0
end

-- create levelUpdate command
function UserData:setLevelCommand(level,levelDiff,prop)
    self.levelCommand.level = level
    self.levelCommand.levelDiff = levelDiff
    self.levelCommand.prop = prop
    self:save()
end

function UserData:getLevelCommand()
    return self.levelCommand
end

-- 持续失败相关
function UserData:setContinueFailInfo(level)
    if UserData.continueFailInfo.level == level then
        UserData.continueFailInfo.count = UserData.continueFailInfo.count + 1
    else
        UserData.continueFailInfo.level = level
        UserData.continueFailInfo.count = 1
    end
    self:save()
end
function UserData:getContinueFailInfo()
    return UserData.continueFailInfo
end
-- check连续失败次数
function UserData:checkContinueFail(level, cnt)
    if UserData.continueFailInfo.isGet == 1 or UserData:getCurrentLevel() > level then
        return false
    end
    if self:getContinueFailInfo().level == level and self:getContinueFailInfo().count >= cnt then
        return true
    end
    return false
end
-- 设置标志位
function UserData:updateContinueFailSign()
    UserData.continueFailInfo.isGet = 1
    self:save()
end

-- local function myRandom(n, m)
--     math.randomseed(os.time()+math.random(1, 100))
--     return math.random(n, m)
-- end

-- 产生随机字符串，长度len
function UserData:getRandomString(len)
    if len <= 0 or not len then return "" end
    -- math.randomseed(socket.gettime()*10000)
    local str = ""
    for i=1,len-6 do
        local type = math.random(1, 3)
        if type == 1 then
            str = str .. math.random(0, 9)
        elseif type == 2 then
            str = str .. string.char(math.random(65, 90))
        else
            str = str .. string.char(math.random(97, 122))
        end
    end
    -- 后六位取毫秒时间戳后六位
    local time = tostring(socket.gettime()*10000)
    local tail = string.sub(time, -6)
    str = str .. tail
    return str
end

function UserData:updateDigTimeStamp()
    if UserData.digMapTimeStamp == 0 then
        UserData.digMapTimeStamp = socket.gettime()
        self:updateDigMapIndex()
    else
        local len = #self.digMapIndexTable
        if socket.gettime() - self.digMapTimeStamp > len * 24 * 3600 then
            self:updateDigMapIndex()
        end
    end
end

function UserData:updateDigMapIndex()
    local index1 = 1
    local index2 = 1
    local len = #self.digMapIndexTable
    for i=1,50 do
        index1 = math.random(1,len)
        index2 = math.random(1,len)
        self.digMapIndexTable[index1],self.digMapIndexTable[index2] = self.digMapIndexTable[index2],self.digMapIndexTable[index1]
    end
    self:save()
end

function UserData:getDigMapIndex(leftDays)
    self:updateDigTimeStamp()
    local len = #self.digMapIndexTable
    local index = self.digMapIndexTable[leftDays]
    return  index or math.random(1,len)
end

-- 记录每一关打的次数
function UserData:getLevelCounts(level)

    return UserData.levelCounts[tostring(level)] or 0
end

function UserData:updateLevelCounts(level)
    local counts = UserData.levelCounts[tostring(level)]

    if counts then
        counts = counts + 1
    else
        counts = 1
    end
    UserData.levelCounts[tostring(level)] = counts
    self:save()
end

-- 记录金店每次打开时间戳
function UserData:updateGoldShopOpenCounts()
    -- UserData.openGoldShopSign
    local now = tostring(os.date("%Y-%M-%D %H:%M:%S"))
    table.insert(UserData.openGoldShopSign, now)
    self:save()
end
function UserData:getGoldShopOpenCounts()
    return UserData.openGoldShopSign or {}
end
function UserData:checkGoldShopOpenCounts()
    local counts = UserData.openGoldShopSign or {}
    return table.nums(counts) > 50
end
function UserData:cleanGoldShopOpenCounts()
    UserData.openGoldShopSign = {}
    self:save()
end

-- 宝箱数
function UserData:setBoxNum(num)
    UserData.boxNum = num
    self:save()
end

function UserData:getBoxNum()
    return self.boxNum
end

-- 公告
function UserData:addNotifications(notices)
    for k,v in pairs(notices) do
        for kk,vv in pairs(UserData.notifications) do
            if tostring(v.id) == tostring(vv.id) then
                notices[k] = nil
            end
        end
    end
    if #notices > 0 then
        for k,v in pairs(notices) do
            UserData.notifications[k] = notices[k]
        end
        self:save()
    end
end
function UserData:removeNotification(id)
    if id then
        for k,v in pairs(UserData.notifications) do
            if tostring(v.id) == tostring(id) then
                UserData.notifications[k] = nil
            end
        end
    else
        UserData.notifications = {}
    end
    self:save()
end
function UserData:getAllNotifications()
    return UserData.notifications
end

-- 已处理的公告
function UserData:addWorkedNotifications(id)
    table.insert(UserData.workedNotifications, id)
    self:save()
end
function UserData:getWorkedNotifications()
    return UserData.workedNotifications
end
function UserData:removeWorkedNotifications()
    UserData.workedNotifications = {}
    self:save()
end

--是否是第一次购买+5步道具
function UserData:isFirstBuyStep()
    return self.firstBuyStep == 1
end

--更新+5步道具的购买状态
function UserData:updateFirstBuyStep()
    if self:isFirstBuyStep() then
        self.firstBuyStep = 0
        self:save()
    end
end

-- 限时促销活动
function UserData:setActivity(data)
    UserData.activityConfig = data
    self:save()
end
function UserData:getActivity()
    return UserData.activityConfig
end

function UserData:setPurchaseData(data)
    UserData.purchaseData = data
    self:save()
end
function UserData:getPurchaseData()
    return UserData.purchaseData
end

-- 记录最近失败关卡
function UserData:setLastLostLevel(data)
    UserData.lastLostLevel = data
    self:save()
end
function UserData:getLastLostLevel()
    return UserData.lastLostLevel
end

-- 当前付费促销类型,每关更新(当前有三种方案)
function UserData:updatePayerPromotionType()
    UserData.payerPromotionType = math.random(1,3)
    self:save()
end
function UserData:getPayerPromotionType()
    if not UserData.payerPromotionType or UserData.payerPromotionType < 1 or UserData.payerPromotionType > 3 then
        UserData.payerPromotionType = 1
    end
    return UserData.payerPromotionType
end

-- 记录gold shop购买的最高优先级的促销
function UserData:updatePayedPriority(data)
    if data >= 1 and data <= 5 and data > UserData.payedPriority then
        UserData.payedPriority = data
    end
    self:save()
end
function UserData:getPayedPriority()
    return UserData.payedPriority or 0
end
function UserData:restorePayedPriority()
    UserData.payedPriority = 0
    self:save()
end

-- 记录gold shop 最后购买的价格
function UserData:updateLastPayedPrice(price)
    -- 大于2.99的购买才会记录
    if price > 2.99 then
        UserData.lastPayedPrice = price
    end
    self:save()
end
function UserData:getLastPayedPrice()
    return UserData.lastPayedPrice or 0
end
function UserData:restoreLastPayedPrice()
    UserData.lastPayedPrice = 0
    self:save()
end


function UserData:setCommentData(data)
    UserData.comment = data.scoreApp
    self:save()
end

function UserData:getCommentForKey (key)
  for k,v in pairs(UserData.comment) do
    if k == key then
      return v
    end
  end
  return nil
end

-- 初始化user数据
--[[
info 用户基本信息
submit(bool) 数据不一致是否提交log到服务器
updateLV(bool) 是否强制更新所有关卡信息
updateUserID(bool) 是否更新userid
passLog(bool) 是否跳过log检测发送
]]
function UserData:initUserData(info, submit, updateLV, updateUserID, passLog, updateBack)
    -- 同步配置
    -- ServerProxy.readConfig(function (data)
    --     if data.data then
    --         UserData.comment = data.data.config.scoreApp
    --         self:save()
    --     end
    --     end,function()
    --         dump(UserData.comment)
    -- end)
    if not info then
        do return end
    end
    if info.config then
        UserData:setCommentData(info.config)
    else
        dump("ERR: init get config err!")
    end
    -- 同步数据
    if UserData:getUserId() == "" or updateUserID then
        UserData:setUserId(info.userInfo.uid)
    end
    if not passLog then
        -- 检测用户数据
        if UserData:getGoldCoin() ~= tonumber(info.userInfo.gold_coin) then
            -- 金币不一致
            ServerProxy.logUserInfoERR("gold", UserData:getGoldCoin(), info.userInfo.gold_coin)
        end
        if UserData:getSilverCoin() ~= tonumber(info.userInfo.silver_coin) then
            -- 银币不一致
            ServerProxy.logUserInfoERR("silver", UserData:getSilverCoin(), info.userInfo.silver_coin)
        end
        if UserData:getLife() ~= tonumber(info.userInfo.lives) then
            -- 体力不一致
            ServerProxy.logUserInfoERR("life", UserData:getLife(), info.userInfo.lives)
        end
    end
    -- 刷新数据,服务器为主
    UserData:setName(info.userInfo.username)
    UserData:setGoldCoin(info.userInfo.gold_coin)
    UserData:setSilverCoin(info.userInfo.silver_coin)
    -- 正常体力值,以服务器为主
    if tonumber(info.userInfo.lives) >= 0 and tonumber(info.userInfo.lives) <= 5 then
        UserData:setLife(info.userInfo.lives)
    end
    UserData:setDirectlySend(tonumber(info.isDirectlySend))
    -- 同步道具(道具数目正常情况下)
    if info.Items and #info.Items > 0 then
        for i,v in ipairs(info.Items) do
            if not passLog then
                -- 检测道具是否一致
                if UserData:getItemAmount(tonumber(v.item)) ~= v.number and tonumber(v.item) ~= USER_PROP_ADDBOMB then
                    ServerProxy.logUserItemERR(v.item, UserData:getItemAmount(tonumber(v.item)), v.number)
                end
            end
            -- 同步道具
            if v.number >= 0 then
                UserData:updateItemAmount(v.item, v.number)
            end
        end
        -- -- bomb
        -- if UserData:getSendBombNum() > 0 then
        --     UserData:updateItemAmount(USER_PROP_ADDBOMB, UserData:getItemAmount(USER_PROP_ADDBOMB) + UserData:getSendBombNum())
        --     UserData:setSendBombNum(0)
        -- end
    end
    -- 同步关卡信息
    local localCurrentLV = UserData:getCurrentLevel()
    local needSubmitLog = false
    if info.userInfo.new_level ~= localCurrentLV and submit then
        needSubmitLog = true
    end
    if not passLog then
        -- 检测进度,发送log
        if info.userInfo.new_level ~= localCurrentLV then
            ServerProxy.logLevelDataERR(info.userInfo.new_level-1, localCurrentLV-1)
        end
    end
    -- 以本地数据为主
    -- 若果本地关卡多余服务器，上传本地多余的关卡信息到server
    if info.userInfo.new_level < localCurrentLV then
        if submit then
            local submitCommand = {}
            submitCommand.uuid = UserData:getRovioUUID()
            submitCommand.actions = {}
            submitCommand.configVersion = UserData:getConfigVersion()
            submitCommand.appVersion = UserData:getAppVersion()
            submitCommand.platform = device.platform == 'ios' and 0 or 1
            local timeStamp = utils.getTimeStamp()
            -- 多个关卡统一命令发送服务器
            for i=info.userInfo.new_level, localCurrentLV-1 do
                local score = UserData:getLevelBestScore(i)
                local star = UserData:getLevelStar(i)
                -- type == 5 代表客户端多余的关卡数据同步到服务器上的关卡类型
                local command = {"score/newLevelUpdate", 5, i, score or 0, star or 0, {}, {}, {}}
                -- 时间戳加1，保证时间戳不一致
                timeStamp = timeStamp + 1
                submitCommand.actions[tostring(timeStamp)] = command
            end
            local url = UserData:getZoneServer()
            dump(submitCommand, 'submitLevelCommand')
            -- dump(url)
            require ("app.network.ServerProxy")
            -- 即时同步补发
            ServerProxy.runNetRequest(url, submitCommand, function(data)
                dump(data,"submitLevelCommand success")
            end, function(data)
                dump(data,"submitLevelCommand fail")
            end)
        end
        if updateLV then
            -- 清空多余关卡
            for i=info.userInfo.new_level, localCurrentLV-1 do
                UserData:resetLevelData(i)
            end
            UserData:setCurrentLevel(info.userInfo.new_level)
            UserData:setClickLevel(info.userInfo.new_level)
        end
    else
        UserData:setCurrentLevel(info.userInfo.new_level)
        -- UserData:setClickLevel(info.userInfo.new_level)
    end
    if updateLV or info.userInfo.new_level > localCurrentLV then
        -- 服务器关卡多于本地,获取关卡信息并更新本地
        ServerProxy.getScores(function(data)
            if data and data.data and data.data.scores then
                for i,v in ipairs(data.data.scores) do
                    if v.level and v.score and v.star then
                        if v.score > 0 and v.star > 0 then
                            UserData:updateLevelScore(v.level, v.score, true)
                            UserData:updateLevelStar(v.level, v.star, true)
                        else
                            needSubmitLog = true and submit
                        end
                    end
                    if i == #data.data.scores then
                        self:save()
                        -- 更新关卡回调
                        if updateBack then
                            updateBack()
                        end
                        --pigTower通知
                        cc.UserDefault:getInstance():setIntegerForKey("push_pigTower",UserData:getCurrentTopLevel())
                    end
                end
            end
        end, function(data)
            dump(data.data, "getScores fail")
        end)
    else
        -- 更新关卡回调
        if updateBack then
            updateBack()
        end
    end

    -- 检测piggyTower
    self:setPiggyTowerCfg(info)

    -- 检测是否发送server log
    if info.sendLogBool then
        ServerProxy.sendCommandLog(function(data)
            dump("sendCommandLog success")
        end, function()
            dump("sendCommandLog fail")
        end)
    end

    return needSubmitLog
end

-- 检测设置piggy标志
function UserData:setPiggyTowerCfg(info)
    local piggyTowerData = require "app.data.piggyTowerData"
    -- 赛季
    if info.seasion then
        piggyTowerData:setCheckListPhase(tostring(info.seasion))
    end
    -- 检测pigger时间戳
    if info.residualTime then
        piggyTowerData:setCloseTime(info.residualTime.endTime)
        piggyTowerData:setOpenTime(info.residualTime.startTime)
    end
    -- 检测是否未领取piggy赛季奖励
    if info.userAchieve and table.nums(info.userAchieve) > 0 and info.userAchieve.rank then
        piggyTowerData:setLastRewardSign(true)
        piggyTowerData:setTopMedal(info.userAchieve.bestMedal)
        piggyTowerData:setRank(info.userAchieve.rank or 0)
    end
end

-- 正在转换道具标志位
function UserData:setTransforItemSign(bool)
    UserData.isTransforItem = bool
end
function UserData:getTransforItemSign()
    return UserData.isTransforItem
end

function UserData:updateLevelDiffFailCount(level)
    if not levelConfig then
        levelConfig = utils.json2lua("json/levelConfig.json")
    end
    local t = UserData.levelDiff
    local cfg = levelConfig[tostring(level)]
    local simpleLevel = cfg.simple
    --local simpleLevelLen = #simpleLevel
    local simpleLevelLen = utils.getLevelConfigLen(simpleLevel)
    if simpleLevelLen == 0 then
        do return end
    end
    if  t.recordLevel == level then
        t.failCount = t.failCount + 1
        for i=simpleLevelLen,1,-1 do
            if simpleLevel[i] > 0 and t.failCount >= simpleLevel[i] then
                if i == simpleLevelLen then
                    if t.isLowestDiffUsed == 1 then
                        t.diff = -simpleLevelLen + 1
                    else
                        t.diff = -simpleLevelLen
                    end
                else
                    t.diff = -i
                end
                do break end
            end
        end
        UserData.levelDiff = t
        self:save()
    end
end

function UserData:updateLevelDiff(level)
    if not levelConfig then
        levelConfig = utils.json2lua("json/levelConfig.json")
    end
    local t = UserData.levelDiff
    local cfg = levelConfig[tostring(level)]
    local simpleLevel = cfg.simple
    --local simpleLevelLen = #simpleLevel
    local simpleLevelLen = utils.getLevelConfigLen(simpleLevel)
    if simpleLevelLen == 0 then
        do return end
    end
    --打最新的关卡
    if t.recordLevel == level then
        --如果难度已经是最简单的了，并且最简单关卡包次数还没有用完
        if t.diff == -simpleLevelLen and t.isLowestDiffUsed == 0 then
            t.diff = -simpleLevelLen + 1 --将关卡难度提高到次级难度
            t.isLowestDiffUsed =  1
            UserData.levelDiff = t
            self:save()
        end
    elseif self:getCurrentLevel() == level then --首次进入新关卡，进行初始化操作
        t.recordLevel = level
        t.failCount = 0
        t.timeStamp = utils.getTimeOfDay()
        t.diff = 0
        t.isLowestDiffUsed = 0
        UserData.levelDiff = t
        self:save()
    end
end

function UserData:getLevelDiff(level)
    if not levelConfig then
        levelConfig = utils.json2lua("json/levelConfig.json")
    end
    --如果该关卡已经打过了，则使用默认难度关卡包
    local curLevel = self:getCurrentLevel()
    if level ~= curLevel then
        return 0
    end
    local t = UserData.levelDiff
    local cfg = levelConfig[tostring(level)]
    local simpleLevel = cfg.simple
    --local simpleLevelLen = #simpleLevel
    local simpleLevelLen = utils.getLevelConfigLen(simpleLevel)
    if simpleLevelLen == 0 then
        do return 0 end
    end
    if t.recordLevel == level then
        --检查是否触发次日插入规则并且当前难度不是最简单的难度
        local curTime = os.time()
        local simpleLevelDiff
        if curTime - t.timeStamp > 24 * 3600 then
            simpleLevelDiff = simpleLevel[math.abs(t.diff -1)]
            if t.diff ~= -simpleLevelLen and simpleLevelDiff and simpleLevelDiff > 0 then
                t.diff = t.diff - 1
            end
            t.isLowestDiffUsed = 0
            t.timeStamp = utils.getTimeOfDay()
        end
        simpleLevelDiff = simpleLevel[math.abs(t.diff)]
        --如果发现数据错误，则重置关卡难度
        if not simpleLevelDiff or simpleLevelDiff == 0 then
            t.diff = 0
        end

        UserData.levelDiff = t
        self:save()
        return t.diff
    elseif level == self:getCurrentLevel() then
        return 0
    end
end

-- quest 已领取任务
function UserData:setMasterCompleted(data)
    dump("保存")
    UserData.masterCompleted=data
    self:save()
end
function UserData:addOneMasterCompleted(id)
    dump("one保存")
    table.insert(UserData.masterCompleted,id)
    self:save()
end
function UserData:getMasterCompleted()
    return UserData.masterCompleted;
end

-- 记录邀请好友时间标志(一天只能邀请一次)
function UserData:setInviteTime(num)
    UserData.inviteTime=num
    self:save()
end
function UserData:getInviteTime()
    return UserData.inviteTime or 0
end
function UserData:checkInviteTime()
    return socket.gettime() - UserData:getInviteTime() >= 24*3600
end

-- 记录邀请好友送炸弹数目
function UserData:setSendBombNum(num)
    if num >= 0 then
        UserData.sendBombNum = num
        self:save()
    end
end
function UserData:getSendBombNum()
    return UserData.sendBombNum or 0
end

function UserData:getFriendsCount()
    if UserData.friendsData ~=nil then
        return table.getn(UserData:getFriendsData())
    else
       return 0
    end
end

-- piggyTower各个赛季第一次进入标志
function UserData:getPiggyTowerFirstSign(phase)
    if phase and UserData.piggyTowerFirstSign and not table.keyof(UserData.piggyTowerFirstSign,tostring(phase)) then
        return true
    else
        return false
    end
end
function UserData:setPiggyTowerFirstSign(phase)
    if UserData.piggyTowerFirstSign and not table.keyof(UserData.piggyTowerFirstSign, tostring(phase)) then
        table.insert(UserData.piggyTowerFirstSign, tostring(phase))
        self:save()
    end
end

-- 记录piggy关卡奖励领取情况
function UserData:setPiggyLevelRewardSign(level)
    table.insert(UserData.piggyTowerLevelReward, level)
    self:save()
end
function UserData:getPiggyLevelRewardSign(level)
    for i, v in ipairs(UserData.piggyTowerLevelReward) do
        if v == level then
            return false -- 已领取
        end
    end
    return true
end
-- clean sign
function UserData:cleanPiggyLevelRewardSign()
    UserData.piggyTowerLevelReward = {}
    self:save()
end

--获取用距离第一次打开游戏多久了
--@retrun 距离多少秒
function UserData:getFristOpenFBLikeTime()
    local time = os.time()-cc.UserDefault:getInstance():getIntegerForKey("firstOpenFBLike", 0)
    return time
end

function UserData:ResetFristOpenFBLikeTime()
    cc.UserDefault:getInstance():setIntegerForKey("firstOpenFBLike", os.time())
end

function UserData:getIsOpenFBLikePanel()
    if cc.UserDefault:getInstance():getBoolForKey("firstOpenLike", true) then
        cc.UserDefault:getInstance():setBoolForKey("firstOpenLike", false)
        return true
    elseif UserData:getFristOpenFBLikeTime() >= 1*24*60*60
        and cc.UserDefault:getInstance():getBoolForKey("clickCloseBtn", false) then
            cc.UserDefault:getInstance():setBoolForKey("clickCloseBtn", false)
            UserData:ResetFristOpenFBLikeTime()
            return true
    elseif UserData:getFristOpenFBLikeTime() >= 7*24*60*60
        and cc.UserDefault:getInstance():getBoolForKey("clickLikeBtn", false) then
            cc.UserDefault:getInstance():setBoolForKey("clickLikeBtn", false)
            UserData:ResetFristOpenFBLikeTime()
        return true
    end
end


return UserData
