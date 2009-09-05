----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Auriaya"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33515
--Feral Defender = 34035
mod.toggleOptions = {64386, 64389, 64396, 64422, "defender", "berserk", "bosskill"}
mod.consoleCmd = "Auriaya"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local count = 9
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
if L then
	L.fear_warning = "Fear soon!"
	L.fear_message = "Casting Fear!"
	L.fear_bar = "~Fear"

	L.swarm_message = "Swarm"
	L.swarm_bar = "~Swarm"

	L.defender = "Feral Defender"
	L.defender_desc = "Warn for Feral Defender lives."
	L.defender_message = "Defender up %d/9!"

	L.sonic_bar = "~Sonic"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Auriaya")

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	db = self.db.profile
	started = nil

	self:AddCombatListener("SPELL_CAST_START", "Sonic", 64422, 64688)
	self:AddCombatListener("SPELL_CAST_START", "Fear", 64386)
	self:AddCombatListener("SPELL_CAST_START", "Sentinel", 64389, 64678)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Swarm", 64396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Defender", 64455)
	self:AddCombatListener("SPELL_AURA_REMOVED_DOSE", "DefenderKill", 64455)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Sonic(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(L["sonic_bar"], 28, spellId)
end

function mod:Defender(_, spellId)
	if db.defender then
		self:IfMessage(L["defender_message"]:format(count), "Attention", spellId)
	end
end

function mod:DefenderKill(_, spellId)
	count = count - 1
	if db.defender then
		self:Bar(L["defender_message"]:format(count), 34, spellId)
	end
end

function mod:Swarm(player, spellId)
	self:TargetMessage(L["swarm_message"], player, "Attention", spellId)
	self:Bar(L["swarm_bar"], 37, spell)
end

function mod:Fear(_, spellId)
	self:IfMessage(L["fear_message"], "Urgent", spellId)
	self:Bar(L["fear_bar"], 35, spellId)
	self:DelayedMessage(32, L["fear_warning"], "Attention")
end

function mod:Sentinel(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		count = 9
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if self:GetOption(64455) then
			self:Bar(L["defender_message"]:format(count), 60, 64455)
		end
		if self:GetOption(64386) then
			self:Bar(L["fear_bar"], 32, 64386)
			self:DelayedMessage(32, L["fear_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(600, true)
		end
	end
end

