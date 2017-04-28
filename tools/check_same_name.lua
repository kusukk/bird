#!/usr/bin/env lua

local args = {...}
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
    if not input then do return '' end end
	input = string.gsub(input, "^[ \t\n\r]+", "")
	return string.gsub(input, "[ \t\n\r]+$", "")
end

--获取后缀名
function getExtension(str)
    return str:match(".+%.(%w+)$")
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
	local getinfo = io.popen("ls "..file)
	local fileLists = getinfo:read("*all")
	local filetable = mysplit(fileLists,"\n")
	return filetable
end

local allatlas = {}
--找到所有的atlas
function findAllatlas(lists,path)
	for i,file in ipairs(lists) do
		local extends = getExtension(file)
		if not extends then 
		local t 
		local p 
			if path == "" then 
				p = file
				t = traverse(file)
			else
				p = path .. "/"..file
				-- print(p)
				t = traverse(p)
				-- path = ""
			end
			print("path::",p)
			findAllatlas(t,p)
		elseif extends == "atlas" then 
			if path ~= "" then 
				table.insert(allatlas , path.."/"..file)
			else
				table.insert(allatlas , file)
			end
		end
	end
	return
end


local names = {}
function findSameName(name)
	for i,v in ipairs(names) do
		if name == v then 
			return v
		end
	end
	return nil
end


---------------------------------------------------------------------------------

local atlasList = args
local outputDir = "output"
--os.execute("rm -r "..outputDir)
--os.execute("mkdir -p "..outputDir)


local fileList = traverse("")
findAllatlas(fileList,"")

for i,v in ipairs(allatlas) do
	print("\'".."effect/"..v.."\'"..",")
end

if args[1] == "all" then 
	atlasList = allatlas
end

local repeatNames = {}


for _, atlasfileName in ipairs(atlasList) do
	atlasfile = io.open(atlasfileName, "r")
	if atlasfile then
		atlasfile:read() --跳过第一行
		local pngfile = atlasfile:read()
		local width,height = unpack(string.split(string.trim(string.split(atlasfile:read(),":")[2]),","))
		local _format = atlasfile:read()
		local _filter = atlasfile:read()
		local _repeat = atlasfile:read()
		
		while true do
			local fullName = atlasfile:read()
			if not fullName then 
				break 
			end
			if findSameName(fullName) then 
				table.insert(repeatNames, fullName)
			end 
			table.insert(names,fullName)
			local _path  = string.split(fullName, "/")
			local _dir = "/"
			if #_path > 1 then
				for i = 1,#_path-1 do
					_dir = _dir .. _path[i] .. "/" 
				end
--				os.execute("mkdir -p "..outputDir.._dir)
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
			
		end
		print(atlasfileName .. "    ......OK")
		atlasfile:close()
	end
end

local cwd = os.getenv("PWD")

local nameTable = mysplit(cwd,"/")
local fileName = nameTable[#nameTable]

if #repeatNames > 0 then
    os.execute("touch "..fileName..".lua") 
    local nameFile = io.open(fileName..".lua","w")
    local s = ""
    for i,v in ipairs(repeatNames) do
        s = s .. v .. "\n"
    end
    nameFile:write(s)
    nameFile:close()
end

