-- V.1 Made by JustBenDev
-- OVER COMPLICATED AS USUAL

JBenL = {}

function JBenL.Load_CL(path)
	if SERVER then
		AddCSLuaFile(path)
	else
		include(path)
	end
end

function JBenL.Load_SH(path)
	AddCSLuaFile(path)
	include(path)
end

function JBenL.Load_SV(path)
	if SERVER then
		include(path)
	end
end

function JBenL.Load_Dir(dir)
	local Cur_Files = {}
	local fil, fol = file.Find(dir .. "/*", "LUA")

	for k,v in pairs(fil) do -- ORDER SHIT
		if v == "loader.lua" then JBenL.Load_SH(dir.."/"..v) print("RUNNED LOADER") return end
		local clear_filename = string.gsub(v, "([[:<:]]cl_|[[:<:]]sh_|[[:<:]]sv_)", "")
		print("CLEAR FILENAME : "..tostring(v))
		local _,_,Priority = string.find(clear_filename, "[[:<:]]\\d*_")
		print("Priority : "..tostring(Priority))
		if Priority != nil then
			Priority = tonumber(string.Replace(Priority, "_", ""))
			if Cur_Files[Priority] == nil then
				fil[k] = nil
				Cur_Files[Priority] = {
					filename = v,
					fullpath = dir .. "/" .. v
				}
			end
		end
	end

	for k,v in pairs(fil) do -- LOAD SHARED FILES
		local path = dir .. "/" .. v
		if v:StartWith("sh_") then
			JBenL.Load_SH(path)
		end
	end

	for k,v in pairs(fil) do -- FINALLY LOAD CLIENT AND SERVER FILES
		local path = dir .. "/" .. v
		if v:StartWith("cl_") then
			JBenL.Load_CL(path)
		elseif v:StartWith("sv_") then
			JBenL.Load_SV(path)
		end
	end

	for k,v in pairs(fol) do -- REPEAT :)
		JBenL.Load_Dir(dir .. "/" .. v)
	end
end




-- Load libs
JBenL.Load_Dir("libs")

-- Load Addons
JBenL.Load_Dir("addons")