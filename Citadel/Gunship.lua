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
	L.mage_desc = "Warn when a mage spawns to freeze the gunship cannons."
	L.mage_message = "Mage Spawned!"

	L.enable_trigger_alliance = "Fire up the engines! We got a meetin' with destiny, lads!"
	L.enable_trigger_horde = "Rise up, sons and daughters of the Horde! Today we battle a hated enemy! LOK'TAR OGAR!"

	L.disable_trigger_alliance = "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"
	L.disable_trigger_horde = "The Alliance falter. Onward to the Lich King!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

-- XXX Calculate add respawn timer
-- XXX Calculate mage respawn timer

function mod:OnRegister()
	self:RegisterEnableYell(L["enable_trigger_alliance"], L["enable_trigger_horde"])
end

function mod:OnBossEnable()
	self:Yell("Win", L["disable_trigger_alliance"], L["disable_trigger_horde"])
	self:Log("SPELL_CAST_SUCCESS", "Frozen", 69705)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Frozen(_, spellId)
	self:Message("mage", L["mage_message"], "Positive", spellId, "Info")
end

