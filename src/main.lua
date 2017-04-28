
cc.FileUtils:getInstance():setPopupNotify(false)
 package.path = package.path .. ";src/app/common/popupview/?.lua"
    package.path = package.path .. ";src/app/battlescene/popupview/?.lua"
    package.path = package.path .. ";src/app/mapscene/popupview/?.lua"
    package.path = package.path .. ";src/app/towerscene/popupview/?.lua"
    package.path = package.path .. ";src/"

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
