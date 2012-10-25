local C = {}
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs", true)
local names = {}
local descriptions = {}

-- Option bitflags
local coreToggles = { "BAR", "MESSAGE", "ICON", "WHISPER", "SOUND", "SAY", "PROXIMITY", "FLASHSHAKE", "PING", "EMPHASIZE" }
for i, toggle in next, coreToggles do
	C[toggle] = bit.lshift(1, i - 1)
	if L[toggle] then
		names[toggle] = L[toggle]
		descriptions[toggle] = L[toggle .. "_desc"]
	end
end

-- Toggles that should actually be shown in the interface options
local listToggles = { "MESSAGE", "BAR", "FLASHSHAKE", "ICON", "WHISPER", "SAY", "PING", "PROXIMITY" }

local used = nil
function BigWigs:RegisterOption(key, name, desc)
	if C[key] then error("Don't do that again!") end

	-- Build a list of used shift indexes
	if not used then
		used = {}
		for k, i in pairs(self.db.global.optionShiftIndexes) do
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
		for i, k in pairs(used) do
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

function BigWigs:GetBossOptionDetails(module, bossOption)
	local customBossOptions = BigWigs:GetCustomBossOptions()
	local option = bossOption
	local t = type(option)
	if t == "table" then option = option[1]; t = type(option) end
	local bf = module.toggleDefaults[option]
	if t == "string" then
		if customBossOptions[option] then
			local icon = customBossOptions[option][4] and select(3, GetSpellInfo(customBossOptions[option][4])) or nil
			return option, customBossOptions[option][1], customBossOptions[option][2], icon
		else
			local ejID = option:match("^ej:(%d+)$")
			if tonumber(ejID) then
				-- This is an EncounterJournal ID
				local title, description, _, abilityIcon, displayInfo = EJ_GetSectionInfo(tonumber(ejID))
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
				-- So the magic is the, if <icon> is a number, it should be a portrait.
				return option, title, description, icon
			else
				local L = module:GetLocale(true)
				local icon = L[option .. "_icon"]
				if icon == option .. "_icon" then icon = nil end
				if type(icon) == "number" then
					local _
					_, _, icon = GetSpellInfo(icon)
					if not icon then
						print("|cFF33FF99BigWigs|r:", "No icon found for", module, L[option .. "_icon"])
					end
				elseif type(icon) == "string" then
					icon = "Interface\\Icons\\" .. icon
				end
				return option, L[option], L[option .. "_desc"], icon
			end
		end
	elseif t == "number" then
		local spellName, _, icon = GetSpellInfo(option)
		if not spellName then error(("Invalid option %d in module %s."):format(option, module.name)) end
		return spellName, spellName, getSpellDescription(option), icon
	end
end

BigWigs.C = C

