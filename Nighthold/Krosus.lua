
--------------------------------------------------------------------------------
-- TODO List:
-- - Verify live timers on all difficulties

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Krosus", 1088, 1713)
if not mod then return end
mod:RegisterEnableMob(101002)
mod.engageId = 1842
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local normalTimers = { -- and LFR Timers
	-- Fel Beam (spell id is the right one), _cast_success
	[205370] = {9.5, 15, 30, 30, 23, 27, 30, 44, 14, 16, 14, 16, 22, 60},

	-- Orb of Destruction, _aura_applied
	[205344] = {70, 40, 60, 25, 60, 37, 15, 15, 30},

	-- Burning Pitch, _cast_start
	[205420] = {38, 102, 85, 90},
}

local heroicTimers = {
	-- Fel Beam (spell id is the right one), _cast_success
	[205370] = {11, 29, 30, 45, 16, 16, 14, 16, 27, 55, 26, 5, 21, 5, 12, 12, 5, 13},

	-- Orb of Destruction, _aura_applied
	[205344] = {20, 60, 23, 62, 27, 25, 15, 15, 15, 30, 55},

	-- Burning Pitch, _cast_start
	[205420] = {50, 85, 90, 94},
}

local mythicTimers = {
	-- Fel Beam (spell id is the right one), _cast_success, didnt have enough logs to make sure they are all .0
	[205370] = {9.0, 16.0, 16.0, 16.0, 14.0, 16.0, 27.0, 54.9, 26.0, 4.8, 21.2, 4.7, 12.3, 12.0, 4.8, 13.3, 18.9, 4.8, 25.3, 4.8, 25.2, 4.9},

	-- Orb of Destruction, _aura_applied
	[205344] = {13, 62, 27, 25, 15, 15, 15, 30, 55, 38, 30, 12, 18},

	-- Burning Pitch, _cast_start
	[205420] = {45, 90, 94, 78},
}

local beamCount = 1
local orbCount = 1
local burningPitchCount = 1
local slamCount = 1
local timers = mod:Mythic() and mythicTimers or mod:Heroic() and heroicTimers or normalTimers

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.leftBeam = "Left Beam"
	L.rightBeam = "Right Beam"

	L.smashingBridge = "Smashing Bridge"
	L.smashingBridge_desc = "Slams which break the bridge. You can use this option to emphasize or enable countdown."
	L.smashingBridge_icon = 205862

	L.removedFromYou = "%s removed from you" -- "Searing Brand removed from YOU!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{206677, "TANK"}, -- Searing Brand
		205370, -- Fel Beam
		{205344, "SAY", "FLASH"}, -- Orb of Destruction
		205862, -- Slam
		"smashingBridge",
		205420, -- Burning Pitch
		208203, -- Isolated Rage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "SearingBrand", 206677)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingBrand", 206677)
	self:Log("SPELL_AURA_REMOVED", "SearingBrandRemoved", 206677)
	self:Log("SPELL_CAST_START", "FelBeamCast", 205370)
	self:Log("SPELL_CAST_SUCCESS", "FelBeamSuccess", 205370)
	self:Log("SPELL_AURA_APPLIED", "OrbOfDescructionApplied", 205344)
	self:Log("SPELL_CAST_START", "SlamCast", 205862)
	self:Log("SPELL_CAST_SUCCESS", "SlamSuccess", 205862)
	self:Log("SPELL_CAST_START", "BurningPitchCast", 205420)
end

function mod:OnEngage()
	beamCount = 1
	orbCount = 1
	burningPitchCount = 1
	slamCount = 1
	timers = self:Mythic() and mythicTimers or self:Heroic() and heroicTimers or normalTimers

	self:Bar(206677, 15)
	self:Bar(205862, 33, CL.count:format(self:SpellName(205862), slamCount))
	self:Bar("smashingBridge", 93, CL.count:format(L.smashingBridge, 1), L.smashingBridge_icon)
	self:Bar(205370, timers[205370][beamCount], CL.count:format(self:SpellName(205370), beamCount))
	self:Bar(205344, timers[205344][orbCount], CL.count:format(self:SpellName(205344), orbCount))
	self:Bar(205420, timers[205420][burningPitchCount], CL.count:format(self:SpellName(205420), burningPitchCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
		if spellId == 208203 then -- Isolated Rage
			local t = GetTime()
			if t-prev > 2.5 then
				prev = t
				self:Message(spellId, "Important", "Alert")
			end
		end
	end
end

function mod:SearingBrand(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 3 then -- 1, 3, 4, 5, 6, 7, 8, ... < this is hc, might need to change for others
		self:StackMessage(args.spellId, args.destName, amount, "Urgent")
	end
end

function mod:SearingBrandRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Urgent", "Warning", L.removedFromYou:format(args.spellName))
	end
end

function mod:FelBeamCast(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
end

do
	local prev = 0
	function mod:FelBeamSuccess(args)
		beamCount = beamCount + 1
		local t = timers[args.spellId][beamCount]
		if t then
			self:Bar(args.spellId, t, CL.count:format(args.spellName, beamCount))
			prev = GetTime()
		else
			t = GetTime() - prev
			print("Unknown BigWigs timer:", self:Difficulty(), args.spellId, args.spellName, beamCount, t)
			prev = GetTime()
		end
	end
end

do
	local prev = 0
	function mod:OrbOfDescructionApplied(args)
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", CL.count:format(args.spellName, orbCount))
		self:TargetBar(args.spellId, 5, args.destName)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		orbCount = orbCount + 1

		local t = timers[args.spellId][orbCount]
		if t then
			self:Bar(args.spellId, t, CL.count:format(args.spellName, orbCount))
			prev = GetTime()
		else
			t = GetTime() - prev
			print("Unknown BigWigs timer:", self:Difficulty(), args.spellId, args.spellName, orbCount, t)
			prev = GetTime()
		end
	end
end

function mod:SlamCast(args)
	if slamCount % 3 == 0 then
		self:Message("smashingBridge", "Important", "Alert", CL.casting:format(CL.count:format(args.spellName, slamCount)) .. " - "..L.smashingBridge, L.smashingBridge_icon)
	else
		self:Message(args.spellId, "Important", "Alert", CL.casting:format(CL.count:format(args.spellName, slamCount)))
	end
end

function mod:SlamSuccess(args)
	self:Message(args.spellId, "Important", nil)
	if slamCount % 3 == 0 and slamCount < 10 then
		self:Bar("smashingBridge", 90, CL.count:format(L.smashingBridge, slamCount/3 + 1), L.smashingBridge_icon)
	end
	slamCount = slamCount + 1
	if slamCount % 3 ~= 0 and slamCount < 12 then -- would mirror the smashing bridge bar otherwise
		self:Bar(args.spellId, 30, CL.count:format(args.spellName, slamCount))
	end
end

do
	local prev = 0
	function mod:BurningPitchCast(args)
		self:Message(args.spellId, "Attention", "Info")
		burningPitchCount = burningPitchCount + 1

		local t = timers[args.spellId][burningPitchCount]
		if t then
			self:Bar(args.spellId, t, CL.count:format(args.spellName, burningPitchCount))
			prev = GetTime()
		else
			t = GetTime() - prev
			print("Unknown BigWigs timer:", self:Difficulty(), args.spellId, args.spellName, burningPitchCount, t)
			prev = GetTime()
		end
	end
end
