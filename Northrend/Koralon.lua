----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Koralon the Flame Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(35013)
mod.toggleOptions = {66725, {67332, "FLASHNSHAKE"}, 66665, "berserk", "bosskill"}

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
	self:Log("SPELL_CAST_START", "Fists", 66725, 66808, 68160, 68161)
	self:Log("SPELL_AURA_APPLIED", "Cinder", 67332, 66684)
	self:Log("SPELL_CAST_START", "Breath", 66665, 67328)
	self:Death("Win", 35013)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fists(_, spellId, _, _, spellName)
	self:IfMessage(66725, spellName, "Attention", spellId)
	self:Bar(66725, spellName, 15, spellId)
end

function mod:Cinder(player, spellId)
	if player ~= pName then return end
	self:LocalMessage(67332, L["cinder_message"], "Personal", spellId, "Alarm")
end

function mod:Breath(_, spellId, _, _, spellName)
	self:IfMessage(66665, spellName, "Attention", spellId)
end
