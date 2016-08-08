
--------------------------------------------------------------------------------
-- TODO List:
-- - Tuning sounds / message colors
-- - Remove beta engaged message
-- - We could do some cool positioning stuff on this fight
--   - warning when standing left / right side and beam is incoming there
--   - warning when bridge is breaking and standing there
-- - Needs to be tested in all difficulties

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
	[205368] = {9.5, 15, 30, 30, 23, 27, 30, 44, 14, 16, 14, 16, 22, 60},

	-- Orb of Destruction, _aura_applied
	[205344] = {70, 40, 60, 25, 60, 37, 15, 15, 30},

	-- Burning Pitch, _cast_start
	[205420] = {38, 102, 85, 90},
}

local heroicTimers = {
	-- Fel Beam (spell id is the right one), _cast_success
	[205368] = {11, 29, 30, 45, 16, 16, 14, 16, 27, 55, 26, 5, 21, 5, 12, 12, 5, 13},

	-- Orb of Destruction, _aura_applied
	[205344] = {20, 60, 23, 62, 27, 25, 15, 15, 15, 30, 55},

	-- Burning Pitch, _cast_start
	[205420] = {50, 85, 90, 94},
}

local mythicTimers = {
	-- Fel Beam (spell id is the right one), _cast_success, didnt have enough logs to make sure they are all .0
	[205368] = {9.0, 16.0, 16.0, 16.0, 14.0, 16.0, 27.0, 54.9, 26.0, 4.8, 21.2, 4.7, 12.3, 12.0, 4.8, 13.3, 18.9, 4.8, 25.3, 4.8, 25.2, 4.9},

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
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{206677, "TANK"}, -- Fel Brand
		205368, -- Fel Beam (right)
		{205344, "SAY", "FLASH"}, -- Orb of Destruction
		205862, -- Slam
		205420, -- Burning Pitch
		208203, -- Isolated Rage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "FelBrand", 206677)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelBrand", 206677)
	self:Log("SPELL_CAST_START", "FelBeamCast", 205370, 205368) -- left, right
	self:Log("SPELL_CAST_SUCCESS", "FelBeamSuccess", 205370, 205368) -- left, right
	self:Log("SPELL_AURA_APPLIED", "OrbOfDescructionApplied", 205344)
	self:Log("SPELL_CAST_START", "SlamCast", 205862)
	self:Log("SPELL_CAST_SUCCESS", "SlamSuccess", 205862)
	self:Log("SPELL_CAST_START", "BurningPitchCast", 205420)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Krosus Engaged (Beta v2)", 205862)

	beamCount = 1
	orbCount = 1
	burningPitchCount = 1
	slamCount = 1
	timers = self:Mythic() and mythicTimers or self:Heroic() and heroicTimers or normalTimers

	self:Bar(206677, 15)
	self:Bar(205862, 33, CL.count:format(self:SpellName(205862), slamCount))
	self:Bar(205862, 93, CL.count:format(L.smashingBridge, 1))
	self:Bar(205368, timers[205368][beamCount], CL.count:format(self:SpellName(205368), beamCount))
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

function mod:FelBrand(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 4 then -- 1, 3, 5, 6, 7, 8, ...
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Alarm") -- check taunt amount
	end
end

function mod:FelBeamCast(args)
	self:Message(205368, "Attention", "Info", CL.casting:format(args.spellId == 205370 and L.leftBeam or L.rightBeam))
end

do
	local prev = 0
	function mod:FelBeamSuccess(args)
		self:Message(205368, "Attention", nil, args.spellId == 205370 and L.leftBeam or L.rightBeam)
		beamCount = beamCount + 1
		local t = timers[205368][beamCount]
		if t then
			if self:LFR() or self:Normal() then
				self:Bar(205368, t, CL.count:format(args.spellId == 205370 and L.rightBeam or L.leftBeam, beamCount)) -- alternating beams, 205370 is the left beam
			else
				self:Bar(205368, t, CL.count:format(args.spellName, beamCount))
			end
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
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(CL.count:format(args.spellName, slamCount)) .. (slamCount % 3 == 0 and " - "..L.smashingBridge or ""))
end

function mod:SlamSuccess(args)
	self:Message(args.spellId, "Important", nil)
	if slamCount % 3 == 0 and slamCount < 10 then
		self:Bar(args.spellId, 90, CL.count:format(L.smashingBridge, slamCount/3 + 1))
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
