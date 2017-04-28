--
-- Author: pengxianfeng
-- Date: 2017-04-27 17:48:09
--
local LoadingLayer = clase("LoadingLayer",function()
	return display.newNode()
end)

local LoadingLay = nil

function LoadingLayer:getInstance()
	if not LoadingLay then
		LoadingLay = LoadingLayer.new()
		LoadingLay:retain()
	end

	if LoadingLay.listener = nil then
		loadingLay:regListener()
	end
	return LoadingLay
end

function LoadingLayer:regListener()
	local listener = cc.EventListenerTouchOneByOne:creat()
	listener:registerScriptHandler(function(touches,event)
		return true
		end,Handler.EVENT_TOUCH_BEGIN)
	local eventDispatcher = LoadingLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, loadingLay)

	LoadingLay.listener = listener
end



function LoadingLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener)
    self.listener = nil
end

function LoadingLayer:ctor()

    self.width=750.38;
    self.height=1136;
    self.scale=display.width/self.width>= display.height/self.height and  display.width/self.width or display.height/self.height

    self.bombSpine=mybo.SpineCache:getInstance():getSpine("load/loading.json","load/loading.atlas","load/loading.png",self.scale);
    self.bombSpine:retain()
    self.bombSpine:setPosition(display.cx,display.cy)
    self:addChild(self.bombSpine,1)
    self.loadSpine = mybo.SpineCache:getInstance():getSpine("load/loading_icon.json","load/loading_icon.atlas","load/loading_icon.png",self.scale);
    self.loadSpine:retain()
    self.loadSpine:setPosition(display.cx,display.cy)
    self:addChild(self.loadSpine,10)



end


function LoadingLayer:onBegin(callback)
    self.bombSpine:setTimeScale(2)
    self.bombSpine:setAnimation(0,'star',false)
    self.loadSpine:setTimeScale(2)
    self.loadSpine:setAnimation(0,'start',false)
    mybo.SoundPlayer:getInstance():playEffect("ui_leveltransition_open")
    -- dump("LoadingLayer:onBegin")
    self.bombSpine:registerSpineEventHandler(function(event)
        if event.animation=="star" then
            self.bombSpine:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
            if callback then
                callback()
            end
        end

    end,sp.EventType.ANIMATION_COMPLETE)
end

function LoadingLayer:onLoop()
    self.bombSpine:setAnimation(0,'loop',true)
    self.loadSpine:setAnimation(0,'loop',true)
    -- 返回键置为可用
    UserData:setStopBack(false)
end



function LoadingLayer:onEnd(callback)
    self.bombSpine:setAnimation(0,'end',false)
    self.loadSpine:setAnimation(0,'end',false)
    mybo.SoundPlayer:getInstance():playEffect("ui_leveltransition_close")
    -- dump("LoadingLayer:onEnd")
    self.bombSpine:registerSpineEventHandler(function(event)
        if event.animation=="end" then
            self.bombSpine:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
            if callback then
                callback()
            end
            self:removeFromParent()
            self:onExit()
        end

    end,sp.EventType.ANIMATION_COMPLETE)
end

return LoadingLayer



