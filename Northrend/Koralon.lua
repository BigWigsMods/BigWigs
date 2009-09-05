----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Koralon the Flame Watcher"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = boss
mod.zoneName = "Vault of Archavon"
mod.otherMenu = "Northrend"
mod.enabletrigger = 35013
mod.guid = 35013
mod.toggleOptions = {66725, 67332, "berserk", "bosskill"}
mod.consoleCmd = "Koralon"

------------------------------
--      Are you local?      --
------------------------------

local started = nil

------------------------------
--      English Locale      --
------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsKoralon the Flame Watcher", "enUS", true)
if L then
end

L = LibStub("AceLocale-3.0"):GetLocale("BigWigsKoralon the Flame Watcher")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fists", 66725, 66808)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Cinder", 67332, 66684)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterMessage("BigWigs_RecvSync")

	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fists(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:Cinder(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 20, spellId)
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:Enrage(360, true)
		end
	end
end

