--
-- Author: pengxianfeng
-- Date: 2017-04-24 15:35:46
--
--
-- Author: Yann
-- Date: 2015-03-22 11:26:31
--
require('app.consts')

if mybo.AppGameConfig:GetIsOpenLocalLanguage() then
  local la = cc.Application:getInstance():getCurrentLanguageCode()
  if  la == "zh" then
    require('app.language.LanguagePosOffset_zh')
    -- require('app.language.LanguagePosOffset_en')
  elseif la == "en" then
    require('app.language.LanguagePosOffset_en')
  elseif la == "ja" then
    require('app.language.LanguagePosOffset_ja')
    -- require('app.language.LanguagePosOffset_en')
  elseif la == "ko" then
    require('app.language.LanguagePosOffset_ko')
    -- require('app.language.LanguagePosOffset_en')
  elseif la == "es" then
    require('app.language.LanguagePosOffset_es')
  elseif la == "fr" then
    require('app.language.LanguagePosOffset_fr')
  elseif la == "ru" then
    require('app.language.LanguagePosOffset_ru')
  elseif la == "tr" then
    require('app.language.LanguagePosOffset_tr')
  elseif la == "de" then
    require('app.language.LanguagePosOffset_de')
  elseif la == "it" then
    require('app.language.LanguagePosOffset_it')
  elseif la == "pt" then
    require('app.language.LanguagePosOffset_pt')
  else
    require('app.language.LanguagePosOffset_en')
  end
else
  require('app.language.LanguagePosOffset_en')
end

local lfs = require("lfs")
local socket = require("socket")
local utils = {}
local languageTag = "en"
local LanguageNotUseTTFList = {"zh","ja","ko"}
local LanguageUseList = {"en","tr","it","fr","de","es","ru","pt","zh","ja","ko"}
local m_isUseTTFLanguage = false

local lastTimeStamp = 0
function utils.getTimeStamp()
    local timeStamp = socket.gettime() * 10000
    if lastTimeStamp == timeStamp then
        timeStamp = timeStamp + 1
    end
    lastTimeStamp = timeStamp
    return timeStamp
end

function utils.tableConnect(t1, t2)
    local rs = {}

    if t1 == nil then
        return t2
    end

    if t2 == nil then
        return t1
    end

    for i,v in pairs(t1) do
        table.insert(rs,v)
    end

    for i,v in pairs(t2) do
        table.insert(rs,v)
    end

    return rs
end

-- daily分享图片
function utils.getFaceBookImgUrl()
    return "https://s3.amazonaws.com/bird-staticfile/pic/daily_share.png"
end

-- 超越分享imgURL
function utils.getFaceBookRankShareImgUrl()
    return "https://s3.amazonaws.com/bird-staticfile/pic/feed.png"
end
-- 关卡超越图片
function utils.getFBRankShareLevelImgUrl()
    return "https://s3.amazonaws.com/bird-staticfile/pic/rank_pass_level.png"
end
-- 分数超越图片
function utils.getFBRankShareScoreImgUrl()
    return "https://s3.amazonaws.com/bird-staticfile/pic/rank_pass_score.png"
end
-- 邀请好友图片
function utils.getFBInviteImgUrl()
    return "https://s3.amazonaws.com/bird-staticfile/pic/pop1.png"
end

function utils.formatNumberThousands(num)
    local formatted = tostring(tonumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function utils.getSpriteFrameByName(name)
    return display.newSprite(name):getSpriteFrame()
end

-- kCCNetworkStatusNotReachable     0
-- kCCNetworkStatusReachableViaWiFi 1
-- kCCNetworkStatusReachableViaWWAN 2
function utils.getInternetConnectionStatus()
    return network.getInternetConnectionStatus()==0
end

function utils.getHatchLevelName(level)
    return "lv_"..(10000+tonumber(level))
end

function utils.setString(str, len)
    if string.utf8len(str) > (len or 5) then
        str=string.sub(str,1,(len or 5))
        str = str .."..."
    end
    return str
end

function utils.createDirectory(path)
    local ret = true
    if not io.exists(path) then
        ret = lfs.mkdir(path)
    end
    return ret
end

function utils.json2lua(jsonFileName)
    local data = cc.FileUtils:getInstance():getStringFromFile(jsonFileName)
    return json.decode(data)
end


function utils:createLabel(tb)
    local offset
    local label
    local origin_size = tb.size
    -- if tb.text then
      -- print("text---------->",tb.text,mybo.MyboDevice:getCurLanguageKey())
    -- end
    if tb.text=="" then
        tb.text = mybo.MyboDevice:getLocalString("CommonEmptyString")
        -- print("EmptyString---------->",tb.text)
    end

    -- 暂时用英文处理
    if not m_isUseTTFLanguage and mybo.MyboDevice:isLanguageHaveList() and mybo.AppGameConfig:GetIsOpenLocalLanguage() then
      if LanguagePosOffset[mybo.MyboDevice:getCurLanguageKey()] then
        offset = LanguagePosOffset[mybo.MyboDevice:getCurLanguageKey()][1]
        if offset then
          tb.size = tb.size + offset.size
        end
      end
        label = require('app.utils.MyboLabelTTF').new(tb.text or "","黑体",tb.size,false)
    else
      if LanguagePosOffset[mybo.MyboDevice:getCurLanguageKey()] then
        offset = LanguagePosOffset[mybo.MyboDevice:getCurLanguageKey()][1]
        if offset then
            tb.size = tb.size+offset.size
        end
      end
        local font="fonts/ABFlockText-Bold.ttf";
        if tb.font ~=nil then
            font=tb.font
        end
        label = require('app.utils.MyboLabelTTF').new(tb.text or "",font,tb.size,true)
    end
    if offset then
      label:setOffsetPos(offset.pos.x,offset.pos.y,origin_size,tb.x,tb.y)
    else
      label:setOffsetPos(0,0,origin_size,tb.x,tb.y)
    end
    label:setPosition(tb.x,tb.y)
    if tb.self then
      tb.self:addChild(label)
    end
    if tb.color then
        if tb.color.a then
            label:setTextColor(tb.color)
        else
            label:setTextColor(cc.c4b(tb.color.r, tb.color.g, tb.color.b, 255))
        end
    end
    if tb.align then
        if tb.align_y then
            label:setAlignment(tb.align,tb.align_y)
        else
            label:setAlignment(tb.align)
        end
    end
    if tb.shadow_color then
        label:enableShadow(tb.shadow_color,tb.shadow_size,tb.shadow_radius)
    end
    if tb.anchor then
       label:setAnchorPoint(tb.anchor)
    end
    if tb.outline_color then
        label:enableOutline(tb.outline_color, tb.outline_size)
    end
    return label
end

function utils:isUseABTTF(text)
    return string.find(text or "",'$',1,true)~=nil or string.find(text or "",'€',1,true)~=nil or string.find(text or "",'£',1,true)~=nil
end

function utils:LanguageInit()
  languageTag = cc.Application:getInstance():getCurrentLanguageCode()
   print("语言标识符----------------->",languageTag)
   if not mybo.AppGameConfig:GetIsOpenLocalLanguage() or not utils:isUseLanguage(languageTag) then
     print("未知语言标识符强制设置成en----------------->",languageTag)
     languageTag = "en"
   end
   m_isUseTTFLanguage = utils:isNotUseTTFLanguage(languageTag)
end

function utils:isUseLanguage(language)
  for k,v in pairs(LanguageUseList) do
    if v == language then
      return true
    end
  end
  return false
end

function utils:isNotUseTTFLanguage(language)
  for k,v in pairs(LanguageNotUseTTFList) do
    if v == language then
      return false
    end
  end
  return true
end

function utils:getLanguage()
    return languageTag
end


function utils.conversionTime(num,type)
    local d=0;
    local h=0
    local m=0;
    local s=0;
    local mm=60
    local hm =mm*mm
    local dm =24*hm

	if  num >= dm then
		d = math.floor(num/dm)
    end

    local b =num%dm

	if b >= hm then
		h = math.floor(b/hm)
    end
    --
    --
    local c= b%hm
	if c >= 60 then
		m=  math.floor(c/mm)
    end
    --
    if c%mm<60 then
        s=b%mm
    end
    local text = ""
    if d==0 and h==0 then
        text =(m<10 and "0"..m or m ).."m "..(s<10 and "0"..s or s ).."s"
    elseif d==0 then
        text = (h<10 and "0"..h or h ).."h "..(m<10 and "0"..m or m ).."m"
    else
        text=" "..d.."d "..(h<10 and "0"..h or h ).."h"
    end



    return text
end

-- 特殊动画,
function utils.specialAn(event,currAnim)
    local str= string.sub(event.animation,0,5)
    local value = currAnim;
    if str=="laugh" then
        value="smilestop_animation"
    elseif event.animation =="smilestop_animation" and currAnim~="smilestop_animation" then
        value="stop_animation";
    end
    return value
end

function utils:registerKeyBack(scene)
    print("utils:registerKeyBack")
    if device.platform ~= "android" or not scene then
        return
    end
    scene:setKeypadEnabled(true)
    scene:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        if event.key == "back" then

            if UserData:isStopBack() then
                return
            end
            local scene = cc.Director:getInstance():getRunningScene()
            scene:onKeyback()
        end
    end)
end

function utils:getCommentTime ()
    local m_time = tonumber(cc.UserDefault:getInstance():getStringForKey("commentTime", "0"))
    local curr_time = tonumber(os.time())
    return curr_time-m_time
end

function utils:getWinNumForDay(daytime,winNum)
  local m_time = tonumber(cc.UserDefault:getInstance():getStringForKey("firstPlayGame"))
  local curr_time = tonumber(os.time())
  print("getWinNumForDay--------->",daytime," ",winNum," ",m_time," ",curr_time," ",cc.UserDefault:getInstance():getIntegerForKey("winNum", 0))
  if curr_time-m_time>= daytime then
    local num = cc.UserDefault:getInstance():getIntegerForKey("winNum", 0)
    if num<winNum then
      return true
    end
  end
  return false
end

function utils.utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + utils.chsize(char)
         startChar = startChar - 1
     end

     local currentIndex = startIndex

     while numChars > 0 and currentIndex <= #str do
         local char = string.byte(str, currentIndex)
         currentIndex = currentIndex + utils.chsize(char)
         numChars = numChars -1
     end
     return str:sub(startIndex, currentIndex - 1)
end

function utils.chsize(char)
          if not char then
        print("not char")
         return 0
     elseif char > 240 then
         return 4
     elseif char > 225 then
         return 3
     elseif char > 192 then
         return 2
     else
         return 1
     end
end

function utils.addBgImg(node, zorde, maxH, minH)
    local pImgArr = {
        {"#yImg_1.png",-100,290,1.3,-10},
        {"#yImg_3.png",200,280,1,0},
        {"#yImg_2.png",50,200,1,0},
        {"#yImg_3.png",-50,100,0.5,0},
        {"#yImg_1.png",-200,0,1.2,180},
        {"#yImg_3.png",130,0,1,-60},
        {"#yImg_3.png",100,-200,0.8,180},
        {"#yImg_1.png",-224,-230,0.9,60},
        {"#yImg_1.png",-234,-350,0.3,90},
        {"#yImg_1.png",234,-230,0.5,-180},
        {"#yImg_1.png",-40,-230,0.5,-180},
        {"#yImg_2.png",0,0,0.7,-90},
        {"#yImg_3.png",170,-290,0.4,-20},
    };

    for i=1,#pImgArr do
        local a = pImgArr[i]
        local im = display.newSprite(a[1])
        im:setPosition(a[2],a[3])
        im:setScale(a[4])
        im:setRotation(a[5])
        node:addChild(im,zorde or 0)
        if maxH and minH then
            if maxH < a[3] or minH > a[3] then
                im:setVisible(false)
            end
        end
    end
end

--table转字符串(只取标准写法，以防止因系统的遍历次序导致ID乱序)
function utils.sz_T2S(_t)
    local szRet = "{"
    function doT2S(_i, _v)
        if "number" == type(_i) then
            szRet = szRet .. "[" .. _i .. "] = "
            if "number" == type(_v) then
                szRet = szRet .. _v .. ","
            elseif "string" == type(_v) then
                szRet = szRet .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                szRet = szRet .. utils.sz_T2S(_v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        elseif "string" == type(_i) then
            szRet = szRet .. '["' .. _i .. '"] = '
            if "number" == type(_v) then
                szRet = szRet .. _v .. ","
            elseif "string" == type(_v) then
                szRet = szRet .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                szRet = szRet .. utils.sz_T2S(_v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        end
    end
    table.foreach(_t, doT2S)
    szRet = szRet .. "}"
    return szRet
end

--字符串转table(反序列化,异常数据直接返回nil)
function utils.t_S2T(_szText)
    --栈
    function stack_newStack()
        local first = 1
        local last = 0
        local stack = {}
        local m_public = {}
        function m_public.pushBack(_tempObj)
            last = last + 1
            stack[last] = _tempObj
        end
        function m_public.temp_getBack()
            if m_public.bool_isEmpty() then
                return nil
            else
                local val = stack[last]
                return val
            end
        end
        function m_public.popBack()
            stack[last] = nil
            last = last - 1
        end
        function m_public.bool_isEmpty()
            if first > last then
                first = 1
                last = 0
                return true
            else
                return false
            end
        end
        function m_public.clear()
            while false == m_public.bool_isEmpty() do
                stack.popFront()
            end
        end
        return m_public
    end
    function getVal(_szVal)
        local s, e = string.find(_szVal,'"',1,string.len(_szVal))
        if nil ~= s and nil ~= e then
            --return _szVal
            return string.sub(_szVal,2,string.len(_szVal)-1)
        else
            return tonumber(_szVal)
        end
    end

    local m_szText = _szText
    local charTemp = string.sub(m_szText,1,1)
    if "{" == charTemp then
        m_szText = string.sub(m_szText,2,string.len(m_szText))
    end
    function doS2T()
        local tRet = {}
        local tTemp = nil
        local stackOperator = stack_newStack()
        local stackItem = stack_newStack()
        local val = ""
        while true do
            local dLen = string.len(m_szText)
            if dLen <= 0 then
                break
            end

            charTemp = string.sub(m_szText,1,1)
            if "[" == charTemp or "=" == charTemp then
                stackOperator.pushBack(charTemp)
                m_szText = string.sub(m_szText,2,dLen)
            elseif '"' == charTemp then
                local s, e = string.find(m_szText, '"', 2, dLen)
                if nil ~= s and nil ~= e then
                    val = val .. string.sub(m_szText,1,s)
                    m_szText = string.sub(m_szText,s+1,dLen)
                else
                    return nil
                end
            elseif "]" == charTemp then
                if "[" == stackOperator.temp_getBack() then
                    stackOperator.popBack()
                    stackItem.pushBack(val)
                    val = ""
                    m_szText = string.sub(m_szText,2,dLen)
                else
                    return nil
                end
            elseif "," == charTemp then
                if "=" == stackOperator.temp_getBack() then
                    stackOperator.popBack()
                    local Item = stackItem.temp_getBack()
                    Item = getVal(Item)
                    stackItem.popBack()
                    if nil ~= tTemp then
                        tRet[Item] = tTemp
                        tTemp = nil
                    else
                        tRet[Item] = getVal(val)
                    end
                    val = ""
                    m_szText = string.sub(m_szText,2,dLen)
                else
                    return nil
                end
            elseif "{" == charTemp then
                m_szText = string.sub(m_szText,2,string.len(m_szText))
                local t = doS2T()
                if nil ~= t then
                    szText = utils.sz_T2S(t)
                    tTemp = t
                    --val = val .. szText
                else
                    return nil
                end
            elseif "}" == charTemp then
                m_szText = string.sub(m_szText,2,string.len(m_szText))
                return tRet
            elseif " " ~= charTemp then
                val = val .. charTemp
                m_szText = string.sub(m_szText,2,dLen)
            else
                m_szText = string.sub(m_szText,2,dLen)
            end
        end
        return tRet
    end
    local t = doS2T()
    return t
end

--获取当天0点值
function utils.getTimeOfDay()
    local date=os.date("*t")
    return os.time{year=date.year,month=date.month,day=date.day,hour=0,min=0,sec=0}
end

function utils.getLevelConfigLen(tbLevel)
    tbLevel = tbLevel or {}
    local num = 0
    for i,v in ipairs(tbLevel) do
        if v > 0 then
            num = num + 1
        else
            do break end
        end
    end
    return num
end

return utils
