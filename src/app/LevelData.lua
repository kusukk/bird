--
-- Author: pengxianfeng
-- Date: 2017-04-27 17:32:58
--
require('app.consts')
local utils = require('app.utils.utils')
local targetCfg = utils.json2lua("json/target.json")
local LevelData = {}


function LevelData:init(parmes)
	  assert(params ~= nil)
    setmetatable(self, {__index = params})
    --需要修改的项拷贝一份
    self.targets = self:getTarget(params.targets)
    self.difficulty = params.difficulty or 1
    self.originTargets = params.targets
    return self
end


function LevelData:getTarget(targets)
    local target = {}
    for k,v in pairs(targets) do
        if type(v) == 'table' and #v == 2 then
            table.insert(target,{[1]= targetCfg[tostring(v[1])] or v[1],[2]=v[2]})
        end
    end
    return target
end

function LevelData:toJson()
    local t = {}

    local mt = getmetatable(self)
    for k,v in pairs(mt.__index) do
        if type(v) ~= 'function' then
            t[k] = v
        end
    end

    for k,v in pairs(self) do
        if type(v) ~= 'function' then
            t[k] = v
        end
    end
    return json.encode(t)
end

return LevelData
