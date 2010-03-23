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
local nextShift = #coreToggles

-- Toggles that should actually be shown in the interface options
local listToggles = { "MESSAGE", "BAR", "FLASHSHAKE", "ICON", "WHISPER", "SAY", "PING" }

function BigWigs:RegisterOption(key, name, desc)
	if C[key] then error("Don't do that again!") end
	C[key] = bit.lshift(1, nextShift)
	nextShift = nextShift + 1

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

BigWigs.C = C

