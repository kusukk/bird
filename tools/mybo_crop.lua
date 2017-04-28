#!/usr/bin/env lua

local function tbPrint(t)
    do return end
    print('-----------------')
    for k,v in pairs(t) do
        print('k,v:',k,v)
    end
end

local args = {...}
tbPrint(args)
------ suffix
local suffix = args[#args]
--print('suffix:',suffix)
table.remove(args)
-----textureFormat
local textureFormat
if suffix == 'png' then
    textureFormat = 'png'
elseif suffix == 'pvr.ccz' then
    textureFormat = 'pvr2ccz'
elseif suffix == 'pvr' then
    textureFormat = 'pvr'
end
--print(textureFormat)
----format
local format = args[#args]
local dither = '-none-nn'
if format == 'RGBA4444' then
    dither = '-fs-alpha'
elseif format == 'RGB565' then
    dither = '-fs'
end
table.remove(args)
tbPrint(args)
-----effectPath
local effectPath = args[#args]
table.remove(args)
tbPrint(args)
--获取后缀名
function getExtension(str)
    return str:match(".+%.(%w+)$")
end

-- helper 函数
function string.split(input, delimiter)
	input = tostring(input)
	delimiter = tostring(delimiter)
	if (delimiter=='') then return false end
	local pos,arr = 0, {}
	-- for each divider found
	for st,sp in function() return string.find(input, delimiter, pos, true) end do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

function string.trim(input)
	input = string.gsub(input, "^[ \t\n\r]+", "")
	return string.gsub(input, "[ \t\n\r]+$", "")
end


--splice
function mysplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

--遍历当前目录 返回列表
function traverse(file)
    file = effectPath..file
	local getinfo = io.popen("ls "..file)
	local fileLists = getinfo:read("*all")
	local filetable = mysplit(fileLists,"\n")
	return filetable
end

local allatlas = {}
--找到所有的atlas
function findAllatlas(lists,path)
	for _,file in ipairs(lists) do
		local extends = getExtension(file)
		if not extends then 
			local t = traverse(file)
			findAllatlas(t,file)
		elseif extends == "atlas" then 
			if path ~= "" then 
				table.insert(allatlas , effectPath..path.."/"..file)
			else
				table.insert(allatlas , effectPath..file)
			end
		end
	end
	return
end


---------------------------------------------------------------------------------

local atlasList = args
local outputDir = effectPath.."output"
local realLastLine = 0
os.execute("rm -r "..outputDir)
os.execute("mkdir -p "..outputDir)
local finalFile = effectPath..'final.*'
os.execute('rm -r '..finalFile)


local fileList = traverse("")
findAllatlas(fileList,"")

tbPrint(allatlas)

if args[1] == "all" then 
	atlasList = allatlas
end


function cropPicture(atlasfileName,atlasfile,readFirstLine)
	-- for _, atlasfileName in ipairs(atlasList) do
		
		-- print(atlasfileName)
		if atlasfile then
			if readFirstLine then atlasfile:read() end--跳过第一行 
			local pngfile = atlasfile:read()
			local width,height = unpack(string.split(string.trim(string.split(atlasfile:read(),":")[2]),","))
			local _format = atlasfile:read()
			local _filter = atlasfile:read()
			local _repeat = atlasfile:read()
			
			while true do
				local fullName = atlasfile:read()
				realLastLine = 0
				if  fullName == "" then 
					-- realLastLine = 1
					cropPicture(atlasfileName,atlasfile,false)
					break
				end
				if not fullName then 			
					break
				end
				
				if realLastLine ~= 1 then			
					local _path  = string.split(fullName, "/")
					local _dir = "/"
					if #_path > 1 then
						for i = 1,#_path-1 do
							_dir = _dir .. _path[i] .. "/" 
						end
						os.execute(string.format('mkdir -p "%s"',outputDir.._dir))
					end
					local outputPngPath = outputDir.."/"..fullName..".png"
					
					local rotate = string.trim(string.split(atlasfile:read(),":")[2]) == "true"
					local x,y = unpack(string.split(string.trim(string.split(atlasfile:read(),":")[2]),","))
					x = tonumber(x)
					y = tonumber(y)
					
					local sizeW,sizeH = unpack(string.split(string.trim(string.split(atlasfile:read(),":")[2]),","))
					sizeW,sizeH = tonumber(sizeW),tonumber(sizeH)
					
					local origW,origH = unpack(string.split(string.trim(string.split(atlasfile:read(),":")[2]),","))
					origW,origH = tonumber(origW),tonumber(origH)

					local offsetX,offsetY = unpack(string.split(string.trim(string.split(atlasfile:read(),":")[2]),","))
					offsetX,offsetY = tonumber(offsetX),tonumber(offsetY)
					
					local index = string.trim(string.split(atlasfile:read(),":")[2])
					
					--切割
					if rotate then sizeW,sizeH = sizeH,sizeW end
					local p   = mysplit(atlasfileName, "/")
                    table.remove(p)
					local cmd 
					if #p >1 then 
						cmd = 'convert -crop %dx%d+%d+%d "%s" "%s"'
						cmd = string.format(cmd, sizeW,sizeH,x,y, table.concat(p,'/').."/"..pngfile, outputPngPath)
					else
						cmd = 'convert -crop %dx%d+%d+%d "%s" "%s"'
						cmd = string.format(cmd, sizeW,sizeH,x,y, pngfile, outputPngPath)
					end

					os.execute(cmd)
					if rotate then
						os.execute(string.format('convert -rotate 90 "%s" "%s"', outputPngPath, outputPngPath))
					end
				end
			end
			print(atlasfileName .. "    ......OK")
			-- if atlasfile then atlasfile:close() end
		end
	-- end
end

function cropList()
	for _, atlasfileName in ipairs(atlasList) do
		atlasfile = io.open(atlasfileName, "r")
		cropPicture(atlasfileName,atlasfile,true)
	end
end

cropList()


-- 打包
local tp_cmd = string.format("TexturePacker --opt %s --premultiply-alpha --texture-format %s --sheet %s --data final.atlas --format spineatlas --trim-sprite-names --algorithm MaxRects --max-size 4096 --size-constraints AnySize --enable-rotation --dither%s --trim-mode None %s",format,textureFormat,'final.'..suffix,dither,outputDir..'/')
os.execute(tp_cmd)
