--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Alysrazor", 800, 194)
if not mod then return end
mod:RegisterEnableMob(52530)

local fieryTornado, firestorm = (GetSpellInfo(99816)), (GetSpellInfo(101659))
local powerWarned = false

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.tornado_trigger = "These skies are MINE!"
	L.claw_message = "%2$dx Claw on %1$s"
	L.fullpower_message = "%s soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99816, 99464,
		99844, {99925, "FLASHSHAKE"},
		{100744, "FLASHSHAKE"}, 100761,
		"berserk", "bosskill"
	}, {
		[99816] = (EJ_GetSectionInfo(2821)),
		[99844] = (EJ_GetSectionInfo(2823)),
		[100744] = "heroic",
		berserk = "general"
	}
end

function mod:OnBossEnable()
	self:Yell("FieryTornado", L["tornado_trigger"])

	self:Log("SPELL_AURA_APPLIED", "Molting", 99464, 99465, 100698)
	self:Log("SPELL_CAST_START", "Firestorm", 100744)
	self:Log("SPELL_CAST_START", "Cataclysm", 100761)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingClaw", 99844)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52530)
end

function mod:OnEngage(diff)
	self:Berserk(600) -- assumed
	self:Bar(99816, fieryTornado, 190, 99816)
	if diff > 2 then
		self:Bar(99816, fieryTornado, 250, 99816)
		self:Bar(100744, firestorm, 93, 100744)
	else
		self:Bar(99464, (GetSpellInfo(99464)), 60, 99464) -- Molting
	end
	powerWarned = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- don't need molting warning for heroic because molting happens at every firestorm
function mod:Molting(_, spellId, _, _, spellName)
	if self:Difficulty() < 3 then
		self:Message(99464, spellName, "Positive", spellId)
		self:Bar(99464, spellName, 60, spellId)
	end
end

function mod:Firestorm(_, spellId, _, _, spellName)
	self:FlashShake(100744)
	self:Message(100744, spellName, "Urgent", spellId, "Alert")
	self:Bar(100744, "~"..spellName, 86, spellId)
	self:Bar(100744, spellName, 15, spellId)
end

function mod:Cataclysm(_, spellId, _, _, spellName)
	self:Message(100761, spellName, "Attention", spellId, "Alarm")
end

function mod:FieryTornado()
	self:SendMessage("BigWigs_StopBar", self, firestorm)
	self:Bar(99816, fieryTornado, 35, 99816)
	self:Message(99816, fieryTornado, "Important", 99816, "Alarm")
	self:RegisterEvent("UNIT_POWER")
end

function mod:BlazingClaw(player, spellId, _, _, _, stack)
	if stack > 5 then -- 50% extra fire and physical damage taken on tank
		self:TargetMessage(99844, L["claw_message"], player, "Urgent", spellId, "Info", stack)
	end
end

function mod:UNIT_POWER()
	local power = UnitPower("boss1", "FOCUS")
	if power > 80 and not powerWarned then
		powerWarned = true
		self:Message(99925, L["fullpower_message"]:format(GetSpellInfo(99925)), "Attention", 99925)
	elseif power < 80 then
		powerWarned = false
	elseif power == 100 then
		self:Message(99925, (GetSpellInfo(99925)), "Urgent", 99925, "Alert")
		self:FlashShake(99925)
		self:UnregisterEvent("UNIT_POWER")
		self:Bar(99816, fieryTornado, 165, 99816)
	end
end

