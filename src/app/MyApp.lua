require('config')
require("cocos.init")
-- require("socket")
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
end
function MyApp:loadPackage()
    require("app.data.UserData")
    require("app.data.LogData")
    require "app.config.config"
    require "app.StartAndUpdateScene"
    require("app.utils.utils")
    -- require "app.network.ServerProxy"
    -- require('app.utils.GameCenterIos')
    require("app.LoadingScene")
end

-- function MyApp:getAppVersion()
--     return mybo.MyboDevice:getAppVersion()
-- end

function MyApp:addSearchPath()
    device.cachePath = device.writablePath
    local writablePath = device.writablePath
    -- local appVersion = self:getAppVersion()
    local buildVersion = self:getBuildVersion()
    local updatePath = writablePath.."update/"
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/audio/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/effect/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/map/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/avatar/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/boxcoin/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/feathers/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/game/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/guide/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/magicPig/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/map/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/png/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/start/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/gfx/terrain/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."/res/script/",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/script/app/common/popupview",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/script/app/battlescene/popupview",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/script/app/mapscene/popupview",true)
    cc.FileUtils:getInstance():addSearchPath(updatePath.."res/script/app/towerscene/popupview",true)
    cc.FileUtils:getInstance():addSearchPath(writablePath.."FBUserIcon/",true)

    local zipPath = writablePath.."zip/"..appVersion..'-'..buildVersion.."/"
    cc.FileUtils:getInstance():addSearchPath(zipPath)
    cc.FileUtils:getInstance():addSearchPath(zipPath.."effect/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/avatar/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/boxcoin/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/feathers/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/game/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/guide/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/magicPig/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/map/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/png/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/start/")
    cc.FileUtils:getInstance():addSearchPath(zipPath.."gfx/terrain/")

    local localPath = ""
    cc.FileUtils:getInstance():addSearchPath(localPath)
    cc.FileUtils:getInstance():addSearchPath(localPath.."audio/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."effect/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."map/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/avatar/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/boxcoin/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/feathers/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/game/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/guide/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/magicPig/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/map/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/png/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/start/")
    cc.FileUtils:getInstance():addSearchPath(localPath.."gfx/terrain/")


end

function MyApp:initData()
    -- UserData init
    UserData:init()

    -- LogData init
    LogData:init()
end

function MyApp:sendErrorLog()
    -- 发送UserLog
    local ServerProxy = require "app.network.ServerProxy"
    ServerProxy.sendAllUserLog()
end

function MyApp:switchToStartScene()
    local GameCenterIos =  require('app.utils.GameCenterIos')
    GameCenterIos.gcLogin()
    self:initData()
    -- self:sendErrorLog()
    self:initAudio()
    --PigTower推送
    cc.UserDefault:getInstance():setIntegerForKey("push_pigTower",UserData:getCurrentTopLevel())
    -- 记录运行次数
    UserData:updateRunGameTimes()
    local LoadingScene = require("app.LoadingScene")
    LoadingScene:loadStartSceneRes(function()
        UserData:setCurrentScene("app.StartAndUpdateScene")
        display.replaceScene(require("app.StartAndUpdateScene").new())
    end)
end

function MyApp:getBuildVersion()
    local tmpBuildVersion = mybo.MyboDevice:getBuildVersion()
    local buildVersionList = string.split(tmpBuildVersion,'-')
    return buildVersionList[1]
end

function MyApp:unzipResource()
    local resPath = "zip/res.zip"
    local extraPath = "zip/"
    local appVersion = self:getAppVersion()
    local buildVersion=self:getBuildVersion()
    local newVersion=appVersion..'-'..buildVersion
    local updatePath = device.writablePath..extraPath..newVersion.."/"
    local oldVersion= cc.UserDefault:getInstance():getStringForKey("unzip", "1.0.0-1")
    local oldVersionList=string.split(oldVersion,'-')
    local oldAppVersion=oldVersionList[1]
    local oldBuildVersion=oldVersionList[2]

    if mybo.AppGameConfig:GetIsForceUnzip() or (appVersion > oldAppVersion) or (appVersion == oldAppVersion and tonumber(buildVersion) > tonumber(oldBuildVersion)) then
        local zipPath = device.writablePath..extraPath
        if cc.FileUtils:getInstance():isDirectoryExist(zipPath) then
            cc.FileUtils:getInstance():removeDirectory(zipPath)
            cc.FileUtils:getInstance():createDirectory(zipPath)
        end
        local scene = display.newScene()
        local startBg = display.newSprite('startBg.jpg')
        startBg:setPosition(display.cx,display.cy)
        scene:addChild(startBg)

        local labelConfig  = {
            text = mybo.MyboDevice:getLocalString("MyApp_0001"),
            size = 45,
            self = scene,
            x = display.cx,
            y = display.cy - 535,
            color = cc.c3b(255, 255, 255),
            shadow_color = cc.c4b(0,49,86,255),
            shadow_size = cc.size(2,-2),
            shadow_radius = 1
        }
        local  utils = require("app.utils.utils")
        utils:createLabel(labelConfig)
        display.replaceScene(scene)
        local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
        scheduler.performWithDelayGlobal(function()
            if not cc.FileUtils:getInstance():isDirectoryExist(updatePath) then
                cc.FileUtils:getInstance():createDirectory(updatePath)
            end
            local absResPath = cc.FileUtils:getInstance():fullPathForFilename(resPath)
            mybo.Utils:unzipToDirectory(absResPath,updatePath)
            cc.UserDefault:getInstance():setStringForKey("unzip", newVersion)
            self:delayToSwitch()
        end, 5/60.0)
    else
        self:switchToStartScene()
    end
end

function MyApp:delayToSwitch()
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    scheduler.performWithDelayGlobal(function()
        self:switchToStartScene()
    end,1)
end

function MyApp:run()
    -- local function hot()
    --    local url = "http://192.168.16.211:8080/ab-blast/src/app/language/LanguagePosOffset_en.lua"
    --    local request = network.createHTTPRequest(function(event)
    --        local request = event.request
    --        if event.name == "completed" then
    --            local response = request:getResponseString()
    --            loadstring(response)()
    --
    --         --    local url2 = "http://192.168.16.211:8080/ab-blast/src/app/language/pt.lua"
    --         --    local request2 = network.createHTTPRequest(function(event)
    --         --        local request2 = event.request
    --         --        if event.name == "completed" then
    --         --            local response2 = request2:getResponseString()
    --         --            loadstring(response2)()
    --         --            dump("多语言热更.....")
    --         --        end
    --         --    end, url2, "GET")
    --         --    request2:start()
    --        end
    --    end, url, "GET")
    --    request:start()
    -- end

    -- local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    -- scheduler.scheduleGlobal(hot,1)

    if device.platform == 'ios' then
        self:unzipResource()
    else
        self:switchToStartScene()
    end
end

function MyApp:initAudio()
  local data = cc.FileUtils:getInstance():getStringFromFile("audio/config.json")
  mybo.SoundPlayer:getInstance():init(data
  ,not cc.UserDefault:getInstance():getBoolForKey("music", true)
  ,not cc.UserDefault:getInstance():getBoolForKey("effect", true))
  if device.platform == 'ios' then
    mybo.SoundPlayer:getInstance():playEffect("common_click2");
  end
  -- mybo.SoundPlayer:getInstance():setMusicEnbale(not cc.UserDefault:getInstance():getBoolForKey("music", true))
  -- mybo.SoundPlayer:getInstance():setSFXEnbale(not cc.UserDefault:getInstance():getBoolForKey("effect", true))
end
return MyApp

