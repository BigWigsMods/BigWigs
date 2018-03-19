
-- GLOBALS: BigWigsKrosusFirstBeamWasLeft, print

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Krosus", 1530, 1713)
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
	[205370] = {9.0, 16.0, 16.0, 16.0, 14.0, 16.0, 27.0, 55.0, 26.0, 4.8, 21.3, 4.8, 12.3, 12.0, 4.8, 13.3, 19.0, 4.8, 25.3, 4.8, 25.3, 4.8},

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
local firstBeamLeft = true
local receivedBeamCom = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.leftBeam = "Left Beam"
	L.rightBeam = "Right Beam"

	L.goRight = "> GO RIGHT >"
	L.goLeft = "< GO LEFT <"

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
	self:RegisterMessage("BigWigs_BossComm")
end

function mod:OnEngage()
	beamCount = 1
	orbCount = 1
	burningPitchCount = 1
	slamCount = 1
	receivedBeamCom = nil
	timers = self:Mythic() and mythicTimers or self:Heroic() and heroicTimers or normalTimers

	self:Bar(205862, self:LFR() and 35 or 33, CL.count:format(self:SpellName(205862), slamCount))
	self:Bar("smashingBridge", self:LFR() and 95 or 93, CL.count:format(L.smashingBridge, 1), L.smashingBridge_icon)
	local firstBeam = timers[205370][beamCount]
	self:Bar(205370, firstBeam, CL.count:format(self:SpellName(221153), beamCount)) -- "Beam"
	self:Bar(205370, timers[205370][beamCount+1] + firstBeam, CL.count:format(self:SpellName(221153), beamCount+1)) -- "Beam"
	self:Bar(205344, timers[205344][orbCount], CL.count:format(self:SpellName(205344), orbCount))
	self:Bar(205420, timers[205420][burningPitchCount], CL.count:format(self:SpellName(205420), burningPitchCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function getBeamText(count)
	if receivedBeamCom then
		if count % 2 == 1 then
			return " " .. (firstBeamLeft and L.goRight or L.goLeft)
		else
			return " " .. (firstBeamLeft and L.goLeft or L.goRight)
		end
	end
	return ""
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
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
	self:Message(args.spellId, "Attention", "Info", args.spellName)
end

do
	local spellName = mod:SpellName(221153) -- "Beam"
	function mod:FelBeamSuccess(args)
		beamCount = beamCount + 1
		local t = timers[args.spellId][beamCount]
		if t then
			local text = CL.count:format(spellName, beamCount) .. getBeamText(beamCount)
			self:Bar(args.spellId, t, text)

			-- Additional timer to plan movement ahead
			local t2 = timers[args.spellId][beamCount+1]
			if t2 then
				local text = CL.count:format(spellName, beamCount+1) .. getBeamText(beamCount+1)
				self:Bar(args.spellId, t+t2, text)
			end
		end
	end
end

function mod:OrbOfDescructionApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", CL.count:format(args.spellName, orbCount), nil, self:Ranged())
	self:TargetBar(args.spellId, 5, args.destName, 230932, args.spellId) -- Orb
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	orbCount = orbCount + 1
	local t = timers[args.spellId][orbCount]
	if t then
		self:Bar(args.spellId, t, CL.count:format(args.spellName, orbCount))
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

function mod:BurningPitchCast(args)
	self:Message(args.spellId, "Attention", "Info")
	burningPitchCount = burningPitchCount + 1
	local t = timers[args.spellId][burningPitchCount]
	if t then
		self:Bar(args.spellId, t, CL.count:format(args.spellName, burningPitchCount))
	end
end

local function fixBars(self)
	-- Next Beam
	local nextBeamText = CL.count:format(self:SpellName(221153), beamCount)
	local nextBeamTime = self:BarTimeLeft(nextBeamText)
	if nextBeamTime > 0 then
		self:StopBar(nextBeamText)
		self:Bar(205370, nextBeamTime, nextBeamText .. getBeamText(beamCount))
	end

	-- Next Beam + 1
	local nextBeamText2 = CL.count:format(self:SpellName(221153), beamCount+1)
	local nextBeamTime2 = self:BarTimeLeft(nextBeamText2)
	if nextBeamTime2 > 0 then
		self:StopBar(nextBeamText2)
		self:Bar(205370, nextBeamTime2, nextBeamText2 .. getBeamText(beamCount+1))
	end
end

function mod:BigWigs_BossComm(_, msg)
	if msg == "firstBeamWasLeft" then
		receivedBeamCom = true
		firstBeamLeft = true
		fixBars(mod)
	elseif msg == "firstBeamWasRight" then
		receivedBeamCom = true
		firstBeamLeft = false
		fixBars(mod)
	end
end

function BigWigsKrosusFirstBeamWasLeft(wasLeft)
	if wasLeft then
		mod:Sync("firstBeamWasLeft")
	else
		mod:Sync("firstBeamWasRight")
	end
end
