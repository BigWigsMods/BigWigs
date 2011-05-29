if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Alysrazor", 800)
if not mod then return end
mod:RegisterEnableMob(52530)

local fieryTornado = GetSpellInfo(99816)
local powerWarned = false

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.ultimate_firepower = "Ultimate Firepower" -- maybe should get this from the EJ
	L.re_ignition = "Re-Ignition" -- maybe should get this from the EJ

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
		99816,
		99844, {99925, "FLASHSHAKE"},
		"berserk", "bosskill"
	}, {
		[99816] = L["ultimate_firepower"],
		[99844] = L["re_ignition"],
		berserk = "general"
	}
end

function mod:OnBossEnable()
	self:Yell("FieryTorndo", L["tornado_trigger"])

	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingClaw", 99844)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52530)
end

function mod:OnEngage(diff)
	self:Berserk(600) -- assumed
	self:Bar(99816, fieryTornado, 190, 99816)
	powerWarned = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FieryTorndo()
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

