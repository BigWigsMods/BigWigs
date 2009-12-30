--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Icecrown Gunship Battle", "Icecrown Citadel")
if not mod then return end
mod.toggleOptions = {"mage", "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.mage = "Mage"
	L.mage_desc = "Warn when a mage spawns to freeze your guns."
	L.mage_message = "Mage Spawned!"
	L.mage_trigger_alliance = "We're taking hull damage, get a battle-mage out here to shut down those cannons!"
	L.mage_trigger_horde = "Need Horde Yell Here - Fake Placeholder"

	L.enable_trigger_alliance = "Fire up the engines! We got a meetin' with destiny, lads!"
	L.enable_trigger_horde = "Rise up, sons and daughters of the Horde! Today we battle a hated enemy! LOK'TAR OGAR!"

	L.disable_trigger_alliance = "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"
	L.disable_trigger_horde = "The Alliance falter. Onward to the Lich King!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:RegisterEnableYell(L["enable_trigger_alliance"], L["enable_trigger_horde"])
end

function mod:OnBossEnable()
	self:Yell("Mages", L["mage_trigger_alliance"], L["mage_trigger_horde"])
	self:Yell("Win", L["disable_trigger_alliance"], L["disable_trigger_horde"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Mages()
	self:Message("mage", L["mage_message"], "Positive", 69705, "Info")
end

