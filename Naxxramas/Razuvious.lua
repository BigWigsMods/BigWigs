----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Instructor Razuvious", "$Revision$")
if not mod then return end
mod.zoneName = "Naxxramas"
mod.enabletrigger = 16061
mod.guid = 16061
mod.toggleOptions = {29107, 55550, -1, 29061, 29060, "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Instructor Razuvious", "enUS", true)
if L then
	L.shout_warning = "Disrupting Shout in 5sec!"
	L.shout_next = "Shout Cooldown"

	L.taunt_warning = "Taunt ready in 5sec!"
	L.shieldwall_warning = "Barrier gone in 5sec!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Instructor Razuvious")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shout", 29107, 55543)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Knife", 55550)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shout(_, spellId, _, _, spellName)
	if spellName then
		self:IfMessage(spellName, "Important", 55543)
	end
	self:Bar(L["shout_next"], 15, 55543)
	self:DelayedMessage(12, L["shout_warning"], "Attention")
end

function mod:ShieldWall(_, spellId, _, _, spellName)
	self:Message(spellName, "Positive", nil, nil, nil, spellId)
	self:Bar(spellName, 20, spellId)
	self:DelayedMessage(15, L["taunt_warning"], "Attention")
end

function mod:Taunt(_, spellId, _, _, spellName)
	self:Message(spellName, "Positive", nil, nil, nil, spellId)
	self:Bar(spellName, 20, spellId)
	self:DelayedMessage(15, L["shieldwall_warning"], "Attention")
end

function mod:Knife(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Important", spellId)
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		if self:GetOption(29107) then
			self:Shout()
		end
	end
end

