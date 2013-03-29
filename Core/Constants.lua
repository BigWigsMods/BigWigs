local C = {}
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs", true)
local names = {}
local descriptions = {}

-- Option bitflags
local coreToggles = { "BAR", "MESSAGE", "ICON", "PULSE", "SOUND", "SAY", "PROXIMITY", "FLASH", "ME_ONLY", "EMPHASIZE", "TANK", "HEALER", "TANK_HEALER", "DISPEL" }
for i, toggle in next, coreToggles do
	C[toggle] = bit.lshift(1, i - 1)
	if L[toggle] then
		names[toggle] = L[toggle]
		descriptions[toggle] = L[toggle .. "_desc"]
	end
end

-- Toggles that should actually be shown in the interface options
local listToggles = { "MESSAGE", "FLASH", "BAR", "ICON", "SAY", "PROXIMITY" }
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
			error("Bit field shift indexes are not consistent with the stored data. Big Wigs should automatically handle this, but at the moment it does not. Boss options might be completely fubar at the moment. Have fun.")
		end
		-- Use the stored shift index
		C[key] = bit.lshift(1, self.db.global.optionShiftIndexes[key])
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
		C[key] = bit.lshift(1, nextShiftIndex)
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

local getSpellDescription
do
	local cache = {}
	local scanner = CreateFrame("GameTooltip")
	scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lcache, rcache = {}, {}
	for i = 1, 4 do
		lcache[i], rcache[i] = scanner:CreateFontString(), scanner:CreateFontString()
		lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
		scanner:AddFontStrings(lcache[i], rcache[i])
	end
	function getSpellDescription(spellId)
		if cache[spellId] then return cache[spellId] end
		scanner:ClearLines()
		scanner:SetHyperlink("spell:"..spellId)
		for i = scanner:NumLines(), 1, -1 do
			local desc = lcache[i] and lcache[i]:GetText()
			if desc then
				cache[spellId] = desc
				return desc
			end
		end
	end
end

--display role icon/message in the option
local function getRoleStrings(module, key)
	local option = module.toggleDefaults[key]
	if bit.band(option, C.TANK_HEALER) == C.TANK_HEALER then
		return " |TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:0:19:22:41|t|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:1:20|t", L.tankhealer
	elseif bit.band(option, C.TANK) == C.TANK then
		return " |TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:0:19:22:41|t", L.tank
	elseif bit.band(option, C.HEALER) == C.HEALER then
		return " |TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:1:20|t", L.healer
	elseif bit.band(option, C.DISPEL) == C.DISPEL then
		return " |TInterface\\EncounterJournal\\UI-EJ-Icons.blp:16:16:0:0:255:66:229:247:7:27|t", L.dispeller
	end
	return "", ""
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
			if title then title = title..roleIcon end
			if description then description = roleDesc..description end
			local icon = L[option .. "_icon"]
			if icon == option .. "_icon" then icon = nil end
			if type(icon) == "number" then
				local _
				_, _, icon = GetSpellInfo(icon)
				if not icon then
					print("|cFF33FF99BigWigs|r:", "No icon found for", module, L[option .. "_icon"])
				end
			elseif type(icon) == "string" and not icon:find("\\", nil, true) then
				icon = "Interface\\Icons\\" .. icon
			end
			return option, title, description, icon
		end
	elseif t == "number" then
		if option > 0 then
			local spellName, _, icon = GetSpellInfo(option)
			if not spellName then error(("Invalid option %d in module %s."):format(option, module.name)) end
			local roleIcon, roleDesc = getRoleStrings(module, spellName)
			return spellName, spellName..roleIcon, roleDesc..getSpellDescription(option), icon
		else
			-- This is an EncounterJournal ID
			local title, description, _, abilityIcon, displayInfo = EJ_GetSectionInfo(-option)
			if not title then error(("Invalid option %d in module %s."):format(option, module.name)) end
			local icon = nil
			if displayInfo and displayInfo > 0 then
				-- This is a creature, so we need to get the texture from SetPortraitTexture
				-- Which is impossible; :GetTexture() just returns "Portrait1", for example.
				-- So we need to just pass on the portrait ID and let the display handle it.
				icon = displayInfo
			elseif abilityIcon and abilityIcon:trim():len() > 0 then
				-- abilityIcon is always set but can be a zero-length string ("")
				icon = abilityIcon
			end
			-- So the magic is the, if <icon> is a number, it should be a portrait.
			local roleIcon, roleDesc = getRoleStrings(module, option)
			return option, title..roleIcon, roleDesc..description, icon
		end
	end
end

BigWigs.C = C

