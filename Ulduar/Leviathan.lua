----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Flame Leviathan"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = boss
mod.zoneName = "Ulduar"
mod.enabletrigger = 33113
mod.guid = 33113
mod.toggleOptions = {68605, 62396, "pursue", 62475, "bosskill"}
mod.consoleCmd = "Leviathan"

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
if L then
	L.engage_trigger = "^Hostile entities detected."
	L.engage_message = "%s Engaged!"

	L.pursue = "Pursuit"
	L.pursue_desc = "Warn when Flame Leviathan pursues a player."
	L.pursue_trigger = "^%%s pursues"
	L.pursue_other = "Leviathan pursues %s!"

	L.shutdown_message = "Systems down!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Flame Leviathan")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 62396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FlameFailed", 62396)

	self:AddCombatListener("SPELL_AURA_APPLIED", "Pyrite", 68605)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Pyrite", 68605)
	self:AddCombatListener("SPELL_AURA_REFRESH", "Pyrite", 68605)

	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Pyrite(_, spellId, _, _, spellName, _, sFlags)
	if bit.band(sFlags, COMBATLOG_OBJECT_AFFILIATION_MINE or 0x1) ~= 0 then
		self:Bar(spellName, 10, spellId)
	end
end

function mod:Flame(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
	self:Bar(spellName, 10, spellId)
end

function mod:FlameFailed(_, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, spellName)
end

function mod:Shutdown(unit, spellId, _, _, spellName)
	if unit ~= mod.bossName then return end
	self:IfMessage(L["shutdown_message"], "Positive", spellId, "Long")
	self:Bar(spellName, 20, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, message, unit, _, _, player)
	if unit == mod.bossName and self.db.profile.pursue and message:find(L["pursue_trigger"]) then
		self:TargetMessage(L["pursue"], player, "Personal", 62374, "Alarm")
		self:Bar(L["pursue_other"]:format(player), 30, 62374)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["engage_trigger"]) then
		self:IfMessage(L["engage_message"]:format(mod.bossName), "Attention")
	end
end

