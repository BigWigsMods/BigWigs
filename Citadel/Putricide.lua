--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Professor Putricide", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36678)
mod.toggleOptions = {{70447, "ICON", "WHISPER"}, {72455, "ICON", "WHISPER"}, 71966, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local doprint = 0

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Good news, everyone!"

	L.blight_message = "Blight on %s!"
	L.violation_message = "Violation on %s!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Blight", 72455)
	self:Log("SPELL_AURA_APPLIED", "Violation", 70447)
	self:Log("SPELL_CAST_START", "Experiment", 70351, 71966)

	self:Death("Win", 36678)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])

	if doprint < 2 then
		doprint = doprint + 1
		print("|cFF33FF99BigWigs_Putricide|r: Mod is alpha, timers may be wrong.")
	end
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Blight(player, spellId)
	self:TargetMessage(72455, L["blight_message"], player, "Personal", spellId)
	self:Whisper(72455, player, L["blight_message"])
	self:PrimaryIcon(72455, player)
end

function mod:Violation(player, spellId)
	self:TargetMessage(70447, L["violation_message"], player, "Personal", spellId)
	self:Whisper(70447, player, L["violation_message"])
	self:SecondaryIcon(70447, player)
end

function mod:Experiment(_, spellId, _, _, spellName)
	self:Message(71966, spellName, "Important", spellId)
end

