--
-- Author: pengxianfeng
-- Date: 2017-04-24 15:33:13
--
local UIButton = class("UIButton",function () return cc.Menu:create() end)
local utils = require('app.utils.utils')
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
require "socket"
BUTTON_TAP_Time=0
function UIButton:ctor(btnText)
    self.img = cc.MenuItemImage:create();

    local labelConfig  = {
        text = btnText or mybo.MyboDevice:getLocalString("CommonEmptyString"),
        size = 40,
        x = 0,
        y = 0,
        space = -2
    }
    -- self.label = cc.Label:createWithTTF("","fonts/ABFlockText-Bold.ttf",40);
    self.label = utils:createLabel(labelConfig)
    -- self.label:setAdditionalKerning(-2)
    self.label:enableShadow(cc.c4b(133,10,1,255),cc.size(2,-4),2)
    -- local size =self.img:getContentSize()
    -- self.label:setPosition(size.width*0.5,size.height*0.5)

    self.label:setAlignment(cc.TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    self.label:setAnchorPoint(0.5,0.4)
    self:addChild(self.img);
    self:setPosition(cc.p(0,0))
    self.label:addTo(self.img,10)

    self.panelButton="";

end

function UIButton:updateLabel(lb)
    self.img:removeChild(self.label)
    self.label = utils:createLabel(lb)

end

function UIButton:setString(str)
  self.label:setString(str)
end

function UIButton:setTouchFunc (func,isPlayEffect)
    self.panelButton=AdministrateFrame:getInstance().tab[1]

  if isPlayEffect == nil then
    isPlayEffect = true
  end
  if func then
    self.img:registerScriptTapHandler(function (tag,target)
        -- dump(self.panelButton,"button")
        -- dump(AdministrateFrame:getInstance().tab[1],"layer")
        if not mybo.MyboDevice:getWindowFocusStatus() then
            return
        end
        if self.panelButton and AdministrateFrame:getInstance().tab[1] then
            if AdministrateFrame:getInstance().tab[1]~= self.panelButton then
                return
            end

        end

        if socket.gettime() - BUTTON_TAP_Time > 0.2 then
            BUTTON_TAP_Time=socket.gettime()
        else
            return
        end

      if isPlayEffect then
        mybo.SoundPlayer:getInstance():playEffect("common_click")
      end
      func(tag,target)
    end)
  end
end

function UIButton:setItemPosition (x,y)
    if type(x)=="table" then
        self.img:setPosition(x)
        return
    end
  if x and y then
    self.img:setPosition(cc.p(x,y))
  end
end

function UIButton:getItemPosition()
    return self.img:getPosition()
end

function UIButton:setNormalImage (img)
  if img then
         self.img:setNormalImage(display.newSprite(img));
  end
end

function UIButton:setNormalSprite(img)
    if img then
        self.img:setNormalImage(img);
    end
end

function UIButton:getMenuItem ()
  return self.img
end

return UIButton
