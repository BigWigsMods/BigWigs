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
local listToggles = { "MESSAGE", "BAR", "FLASHSHAKE", "ICON", "WHISPER", "SAY", "PING" }

local used = nil
function BigWigs:RegisterOption(key, name, desc)
	if C[key] then error("Don't do that again!") end

	-- Build a list of used shift indexes
	if not used then
		used = {}
		for key, index in pairs(self.db.global.optionShiftIndexes) do
			used[index] = key
		end
		for index, key in next, coreToggles do
			used[index - 1] = key
		end
	end
	
	if self.db.global.optionShiftIndexes[key] then
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
		if not nextShiftIndex then error("BigWigs will now blow up. Please consult your local IT technician.") end
		used[nextShiftIndex] = key
		self.db.global.optionShiftIndexes[key] = nextShiftIndex
		C[key] = bit.lshift(1, nextShiftIndex)
	end

	if name and desc then
		print("Option is visible.")
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

BigWigs.C = C

