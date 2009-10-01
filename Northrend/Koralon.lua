----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Koralon the Flame Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(35013)
mod:Toggle(66725, "MESSAGE", "BAR")
mod:Toggle(67332, "MESSAGE", "FLASHNSHAKE")
mod:Toggle("berserk")
mod:Toggle("bosskill")

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
	self:Log("SPELL_CAST_START", "Fists", 66725, 66808)
	self:Log("SPELL_AURA_APPLIED", "Cinder", 67332, 66684)
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

