if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Stinky", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36626)
mod.toggleOptions =  {71123, {71127, "FLASHSHAKE"}, "bosskill"}
 --71123: Decimate
 --71127: Mortal wound

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Stinky", "enUS", true)
if L then
	L.wound_message = "%2$dx Mortal Wound on %1$s"
	L.decimate_cd = "~Next Decimate" --33sec cd
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Stinky")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Wound", 71127)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Wound", 71127)

	self:Log("SPELL_CAST_SUCCESS", "Decimate", 71123)

	self:Death("Win", 36626)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	--self:Bar("decimate", spellName, 45, 71123)
end

--------------------------------------------------------------------------------
-- Event handlers
--

function mod:Wound(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(71127, L["wound_message"], player, "Urgent", icon, "Info", stack)
	end
end

function mod:Decimate(player, spellId, _, _, spellName)
	self:Message(71123, spellName, "Attention", spellId)
	self:Bar(71123, L["decimate_cd"], 33, spellId)
end

