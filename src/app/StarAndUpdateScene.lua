--
-- Author: pengxianfeng
-- Date: 2017-04-24 15:03:52
--
require("config")
require "app.config.config"
local Button = require "app.common.UIButton"


local StartAndUpdateScene = class("StartAndUpdateScene", function()
	return display.newScene("StartAndUpdateScene")
end)

function StartAndUpdateScene:ctor()
	local bg = display.newSprite("startBg.jpg")
	bg:setAnchorPoint(0.5,0.5)
	bg:setPosition(display.cx,display.cy)
	if display.width > bg:getContentSize().width then
		local s = display.width/bg:getContentSize().width
		bg:setScaleX(s)
	end

	self:addChild(bg)

	local function onNodeEvent(event)
		if event == "enter" then
			self:onEnter()
		elseif event == "exit" then
			self:onExit()
		end
	end

	self:registerScriptHandler(onNodeEvent)

	local lableConfig = {
	       text = "play",
	       size = 45,
	       color = cc.c3b(255,255,255),
	       x = display.cx,
	       y = display.cy
    }
    self.textLabel = utils:createLabel(labelConfig)
    self.textLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.textLabel:enableShadow(cc.c4b(0,49,86,255),cc.size(2,-2),1)
    self.textLabel:setPosition(display.cx, display.cy - 535)
    self:addChild(self.textLabel)
    self.textLabel:setVisible(true)

    self:showPlayMenu()
end

function StartAndUpdateScene:showPlayMenu()
	  local start = Button.new()
            self.startBtn = start
            start:setNormalImage("startsBtn.png")
            start:setAnchorPoint(0.5, 0.5)
            -- start:setScale(0.92)
            start:setPosition(display.cx, 255)
            start:setTouchFunc(function ()
                -- dump(itemLevel)
                UNLOCK_ARR={
                    [26]="dailyMission",
                    [6] = "dailytask",
                };
                for i,v in ipairs(utils.json2lua('json/unlockLevel.json')) do
                    UNLOCK_ARR[v.level]=v.id;
                end

                -- dump(UNLOCK_ARR,"UNLOCK_ARR")
                mybo.SoundPlayer:getInstance():stopBackgroundMusic(true);
                self:onPlay()
            end)
            self:addChild(start)

        end



function StartAndUpdateScene:onPlay()
    transition.execute(self,cc.cc.DelayTime:create(0.5),cc.cc.CallFunc:create(function()
        self:runMapScene()
        end))
end

function StartAndUpdateScene:runMapScene()
    local MapFactory = require('app.data.MapFactory')
    MapFactory:init(require('map')[1],'normal')
    -- if UserData:getCurrentTopLevel() == 0 then 
    --     UserData:setClickLevel(1)
    --     LoadingScene:getInstance():replaceScene('app.battleScene.BattleScene',MapFactory:getLevelData())
    -- else
    --     LoadingScene:getInstance():replaceScene("app.mapscene.MapScene",nil,UserData:getCurrentTopLevel()+1)
    -- end

    LoadingScene:getInstance():replaceScene("app.mapscene.MapScene",nil,UserData:getCurrentTopLevel()+1)
end

function StartAndUpdateScene:onExit()
end

function StartAndUpdateScene:onEnter()

end

	






















