--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Instructor Razuvious", 533)
if not mod then return end
mod:RegisterEnableMob(16061)
mod:SetAllowWin(true)
mod.engageId = 1113
mod.toggleOptions = {29107, 55550, 29061, 29060, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Instructor Razuvious"

	L.shout_warning = "Disrupting Shout in 5sec!"
	L.shout_next = "Shout Cooldown"

	L.taunt_warning = "Taunt ready in 5sec!"
	L.shieldwall_warning = "Barrier gone in 5sec!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Shout", 29107, 55543)
	self:Log("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:Log("SPELL_AURA_APPLIED", "Knife", 55550)
	self:Log("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:Death("Win", 16061)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Shout()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Shout(_, spellId, _, _, spellName)
	if spellName then
		self:Message(29107, spellName, "Important", 55543)
	end
	self:Bar(29107, L["shout_next"], 15, 55543)
	self:DelayedMessage(29107, 12, L["shout_warning"], "Attention")
end

function mod:ShieldWall(_, spellId, _, _, spellName)
	self:Message(29061, spellName, "Positive", spellId)
	self:Bar(29061, spellName, 20, spellId)
	self:DelayedMessage(29061, 15, L["taunt_warning"], "Attention")
end

function mod:Taunt(_, spellId, _, _, spellName)
	self:Message(29060, spellName, "Positive", spellId)
	self:Bar(29060, spellName, 20, spellId)
	self:DelayedMessage(29060, 15, L["shieldwall_warning"], "Attention")
end

function mod:Knife(player, spellId, _, _, spellName)
	self:TargetMessage(55550, spellName, player, "Important", spellId)
end

