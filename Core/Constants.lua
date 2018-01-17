local C = {}
local L = BigWigsAPI:GetLocale("BigWigs")
local CL = BigWigsAPI:GetLocale("BigWigs: Common")
local BigWigs = BigWigs
local names = {}
local descriptions = {}

local GetSpellInfo, GetSpellTexture, GetSpellDescription, C_EncounterJournal_GetSectionInfo = GetSpellInfo, GetSpellTexture, GetSpellDescription, C_EncounterJournal.GetSectionInfo
local type, next, tonumber, gsub, lshift, band = type, next, tonumber, gsub, bit.lshift, bit.band

-- Option bitflags
local coreToggles = { "BAR", "MESSAGE", "ICON", "PULSE", "SOUND", "SAY", "PROXIMITY", "FLASH", "ME_ONLY", "EMPHASIZE", "TANK", "HEALER", "TANK_HEALER", "DISPEL", "ALTPOWER", "VOICE", "COUNTDOWN", "INFOBOX" }
for i, toggle in next, coreToggles do
	C[toggle] = lshift(1, i - 1)
	if L[toggle] then
		names[toggle] = L[toggle]
		descriptions[toggle] = L[toggle .. "_desc"]
	end
end

-- Toggles that should actually be shown in the interface options
local listToggles = { "MESSAGE", "FLASH", "BAR", "ICON", "SAY", "PROXIMITY", "ALTPOWER", "VOICE", "INFOBOX" }
local roleToggles = { "TANK", "HEALER", "TANK_HEALER", "DISPEL" }

local used = nil
function BigWigs:RegisterOption(key, name, desc)
	if C[key] then error("Don't do that again!") end

	-- Build a list of used shift indexes
	if not used then
		used = {}
		for k, i in next, self.db.global.optionShiftIndexes do
			used[i] = k
		end
		for i, k in next, coreToggles do
			used[i - 1] = k
		end
	end

	if self.db.global.optionShiftIndexes[key] then
		local index = self.db.global.optionShiftIndexes[key]
		if used[index] and used[index] ~= key then
			error("Bit field shift indexes are not consistent with the stored data. BigWigs should automatically handle this, but at the moment it does not. Boss options might be completely fubar at the moment. Have fun.")
		end
		-- Use the stored shift index
		C[key] = lshift(1, self.db.global.optionShiftIndexes[key])
	else
		-- Find the next free shift index
		local nextShiftIndex = nil
		for i = 10, 63 do
			if not used[i] then
				nextShiftIndex = i
				break
			end
		end
		for i, k in next, used do
			if k == key then
				error("That's weird, we seem to have a stored shift index for this key already.")
				break
			end
		end

		if not nextShiftIndex then error("BigWigs will now blow up. Please consult your local IT technician.") end
		used[nextShiftIndex] = key
		self.db.global.optionShiftIndexes[key] = nextShiftIndex
		C[key] = lshift(1, nextShiftIndex)
	end

	if name and desc then
		names[key] = name
		descriptions[key] = desc
		listToggles[#listToggles + 1] = key
	end
end

function BigWigs:GetOptionDetails(key)
	return names[key], descriptions[key]
end

function BigWigs:GetOptions()
	return listToggles
end

function BigWigs:GetRoleOptions()
	return roleToggles
end

-- Display role icon/message in the option, texture 337497 = Interface\\EncounterJournal\\UI-EJ-Icons
local function getRoleStrings(module, key)
	local option = module.toggleDefaults[key]
	if band(option, C.TANK_HEALER) == C.TANK_HEALER then
		return " |T337497:16:16:0:0:64:64:0:19:22:41|t|T337497:16:16:0:0:64:64:20:39:1:20|t", L.tankhealer
	elseif band(option, C.TANK) == C.TANK then
		return " |T337497:16:16:0:0:64:64:0:19:22:41|t", L.tank
	elseif band(option, C.HEALER) == C.HEALER then
		return " |T337497:16:16:0:0:64:64:20:39:1:20|t", L.healer
	elseif band(option, C.DISPEL) == C.DISPEL then
		return " |T337497:16:16:0:0:255:66:229:247:7:27|t", L.dispeller
	end
	return "", ""
end

local function replaceIdWithName(msg)
	local id = tonumber(msg)
	if id > 0 then
		return GetSpellInfo(id) or BigWigs:Print(("No spell name found for boss option using id %d."):format(id))
	else
		local tbl = C_EncounterJournal_GetSectionInfo(-id)
		if not tbl then
			BigWigs:Print(("No journal name found for boss option using id %d."):format(id))
		else
			return tbl.title
		end
	end
end
local function replaceIdWithDescription(msg)
	local id = tonumber(msg)
	if id > 0 then
		return GetSpellDescription(id) or BigWigs:Print(("No spell description found for boss option using id %d."):format(id))
	else
		local tbl = C_EncounterJournal_GetSectionInfo(-id)
		if not tbl then
			BigWigs:Print(("No journal description found for boss option using id %d."):format(id))
		else
			return tbl.description
		end
	end
end

function BigWigs:GetBossOptionDetails(module, bossOption)
	local customBossOptions = BigWigs:GetCustomBossOptions()
	local option = bossOption
	local t = type(option)
	if t == "table" then option = option[1]; t = type(option) end

	if t == "string" then
		if customBossOptions[option] then
			return option, customBossOptions[option][1], customBossOptions[option][2], customBossOptions[option][4]
		else
			local roleIcon, roleDesc
			if option:find("^custom_") then
				roleIcon, roleDesc = "", ""
			else
				roleIcon, roleDesc = getRoleStrings(module, option)
			end

			local L = module:GetLocale(true)
			local title, description = L[option], L[option .. "_desc"]
			if title then
				if type(title) == "number" then
					if not description then description = title end -- Allow a nil description to mean the same id as the title, if title is a number.
					title = replaceIdWithName(title)
				else
					title = gsub(title, "{(%-?%d-)}", replaceIdWithName) -- Allow embedding an id in a string.
				end
				title = title..roleIcon
			end
			if description then
				if type(description) == "number" then
					description = replaceIdWithDescription(description)
				else
					description = gsub(description, "{(%-?%d-)}", replaceIdWithDescription) -- Allow embedding an id in a string.
					description = gsub(description, "{focus}", CL.focus_only) -- Allow embedding the focus prefix.
				end
				description = roleDesc.. gsub(description, "{rt(%d)}", "|T13700%1:15|t")
			end
			local icon = L[option .. "_icon"]
			if icon == option .. "_icon" then icon = nil end
			if type(icon) == "number" then
				if icon > 8 then
					icon = GetSpellTexture(icon)
				elseif icon > 0 then
					icon = icon + 137000 -- Texture id list for raid icons 1-8 is 137001-137008. Base texture path is Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d
				else
					local tbl = C_EncounterJournal_GetSectionInfo(-icon)
					icon = tbl.abilityIcon
				end
				if not icon then
					BigWigs:Print(("No icon found for %s using id %d."):format(module.name, L[option .. "_icon"]))
				end
			elseif type(icon) == "string" and not icon:find("\\", nil, true) then
				icon = "Interface\\Icons\\" .. icon
			end
			return option, title, description, icon
		end
	elseif t == "number" then
		if option > 0 then
			local spellName, _, icon = GetSpellInfo(option)
			if not spellName then
				BigWigs:Error(("Invalid option %d in module %s."):format(option, module.name))
				spellName = option
			end
			local desc = GetSpellDescription(option)
			if not desc then
				BigWigs:Error(("No spell description was returned for id %d!"):format(option))
				desc = option
			end
			local roleIcon, roleDesc = getRoleStrings(module, option)
			return option, spellName..roleIcon, roleDesc..desc, icon
		else
			-- This is an EncounterJournal ID
			local tbl = C_EncounterJournal_GetSectionInfo(-icon)
			local title, description, abilityIcon
			if not tbl then
				BigWigs:Error(("Invalid option %d in module %s."):format(option, module.name))
				title = option
				description = option
			else
				title, description, abilityIcon = tbl.title, tbl.description, tbl.abilityIcon
			end

			local roleIcon, roleDesc = getRoleStrings(module, option)
			return option, title..roleIcon, roleDesc..description, abilityIcon or false
		end
	end
end

BigWigs.C = C

