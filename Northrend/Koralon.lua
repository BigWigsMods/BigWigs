----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Koralon the Flame Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod.enabletrigger = 35013
mod.toggleOptions = {66725, 67332, "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")

------------------------------
--      English Locale      --
------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Koralon the Flame Watcher", "enUS", true)
if L then
	L.cinder_message = "Flame on YOU!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Koralon the Flame Watcher")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Fists", 66725, 66808)
	self:Log("SPELL_AURA_APPLIED", "Cinder", 67332, 66684)
	self:Death("Win", 35013)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fists(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:Cinder(player, spellId)
	if player ~= pName then return end
	self:LocalMessage(L["cinder_message"], "Personal", spellId, "Alarm")
end

