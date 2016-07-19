
--------------------------------------------------------------------------------
-- TODO List:
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message
-- - We could do some cool positioning stuff on this fight
--   - warning when standing left / right side and beam is incomning there
--   - warning when bridge is breaking and standing there
-- - isolated rage warning (no one in melee) 208203 UNIT_SPELLCAST_SUCCEEDED throttle!

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Krosus", 1088, 1713)
if not mod then return end
mod:RegisterEnableMob(101002)
mod.engageId = 1842
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

local timers = {
	["Left Beam"] = {40.0, 75.0, 32.0, 30.0, 82.0, 31.0, 26.0, 24.0, 18.0},
	["Right Beam"] = {11.0, 59.0, 61.0, 30.0, 43.0, 81.0, 26.0, 17.0, 17.0},
	["Orb of Destruction"] = {22.0, 58.0, 23.0, 63.0, 26.0, 25.0, 15.0, 15.0, 15.0, 30.0, 55.0},
	["Burning Pitch"] = {52.0, 84.0, 90.0, 93.0},
}
local leftBeamCount = 1
local rightBeamCount = 1
local orbCount = 1
local burningPitchCount = 1
local slamCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.left = "Left"
	L.right = "Right"
	L.sidebeam = "%s " .. mod:SpellName(205368)

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
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FelBrand", 206677)
	self:Log("SPELL_CAST_START", "FelBeamLeftCast", 205370)
	self:Log("SPELL_CAST_START", "FelBeamRightCast", 205368)
	self:Log("SPELL_CAST_SUCCESS", "FelBeamLeftSuccess", 205370)
	self:Log("SPELL_CAST_SUCCESS", "FelBeamRightSuccess", 205368)
	self:Log("SPELL_AURA_APPLIED", "OrbOfDescructionApplied", 205344)
	self:Log("SPELL_CAST_START", "SlamCast", 205862)
	self:Log("SPELL_CAST_SUCCESS", "SlamSuccess", 205862)
	self:Log("SPELL_CAST_START", "BurningPitchCast", 205420)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Krosus (Alpha) Engaged (Post Heroic Testing Mod)", 205862)

	leftBeamCount = 1
	rightBeamCount = 1
	orbCount = 1
	burningPitchCount = 1
	slamCount = 1

	self:Bar(206677, 15)
	self:Bar(205862, 33, CL.count:format(self:SpellName(205862), slamCount))
	self:Bar(205862, 93, CL.count:format(L.smashingBridge, 1))
	self:Bar(205368, timers["Left Beam"][leftBeamCount], L.sidebeam:format(L.left))
	self:Bar(205368, timers["Right Beam"][rightBeamCount], L.sidebeam:format(L.right))
	self:Bar(205344, timers["Orb of Destruction"][orbCount])
	self:Bar(205420, timers["Burning Pitch"][burningPitchCount])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FelBrand(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:Bar(args.spellId, 30)
end

function mod:FelBeamLeftCast(args)
  self:Message(205368, "Attention", "Info", CL.casting:format(L.sidebeam:format(L.left)))
end

function mod:FelBeamRightCast(args)
  self:Message(args.spellId, "Attention", "Info", CL.casting:format(L.sidebeam:format(L.right)))
end

function mod:FelBeamLeftSuccess(args)
  self:Message(205368, "Attention", nil, L.sidebeam:format(L.left))
	leftBeamCount = leftBeamCount + 1
	self:Bar(205368, timers["Left Beam"][leftBeamCount], L.sidebeam:format(L.left))
end

function mod:FelBeamRightSuccess(args)
  self:Message(args.spellId, "Attention", nil, L.sidebeam:format(L.right))
	rightBeamCount = rightBeamCount + 1
	self:Bar(args.spellId, timers["Right Beam"][rightBeamCount], L.sidebeam:format(L.right))
end

function mod:OrbOfDescructionApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", CL.count:format(args.spellName, orbCount))
	self:TargetBar(args.spellId, 5, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	orbCount = orbCount + 1
	self:Bar(args.spellId, timers["Orb of Destruction"][orbCount])
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

function mod:BurningPitchCast(args)
	self:Message(args.spellId, "Attention", "Info")
	burningPitchCount = burningPitchCount + 1
	self:Bar(args.spellId, timers["Burning Pitch"][burningPitchCount])
end
