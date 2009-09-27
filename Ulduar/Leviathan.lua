----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Flame Leviathan", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33113)
mod:Toggle("engage", "MESSAGE")
mod:Toggle(68605, "BAR")
mod:Toggle(62396, "MESSAGE", "BAR")
mod:Toggle("pursue", "MESSAGE", "BAR", "FLASHNSHAKE")
mod:Toggle(62475, "MESSAGE", "BAR")
mod:Toggle("bosskill")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
if L then
	L.engage = "Engage warning"
	L.engage_desc = "Warn when Flame Leviathan is engaged."
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
	self:Log("SPELL_AURA_APPLIED", "Flame", 62396)
	self:Log("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:Log("SPELL_AURA_REMOVED", "FlameFailed", 62396)

	self:Log("SPELL_AURA_APPLIED", "Pyrite", 68605)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Pyrite", 68605)
	self:Log("SPELL_AURA_REFRESH", "Pyrite", 68605)

	self:Death("Win", 33113)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Pyrite(_, spellId, _, _, spellName, _, sFlags)
	if bit.band(sFlags, COMBATLOG_OBJECT_AFFILIATION_MINE or 0x1) ~= 0 then
		self:Bar(68605, spellName, 10, spellId)
	end
end

function mod:Flame(_, spellId, _, _, spellName)
	self:IfMessage(62396, spellName, "Urgent", spellId)
	self:Bar(62396, spellName, 10, spellId)
end

function mod:FlameFailed(_, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, spellName)
end

function mod:Shutdown(unit, spellId, _, _, spellName, _, _, _, dGuid)
	local target = tonumber(dGuid:sub(-12, -7), 16)
	if target ~= 33113 then return end
	self:IfMessage(62475, L["shutdown_message"], "Positive", spellId, "Long")
	self:Bar(62475, spellName, 20, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, message, unit, _, _, player)
	if message:find(L["pursue_trigger"]) then
		self:TargetMessage("pursue", L["pursue"], player, "Personal", 62374, "Alarm")
		self:Bar("pursue", L["pursue_other"]:format(player), 30, 62374)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg, unit)
	if msg:find(L["engage_trigger"]) then
		self:IfMessage("engage", L["engage_message"]:format(unit), "Attention")
	end
end

