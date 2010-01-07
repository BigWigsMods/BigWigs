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
	L.adds = "Portals"
	L.adds_desc = "Warn for Portals."
	L.adds_trigger_alliance = "Reavers, Sergeants, attack!"
	L.adds_trigger_horde = "Marines, Sergeants, attack!"
	L.adds_message = "Portals!"

	L.mage = "Mage"
	L.mage_desc = "Warn when a mage spawns to freeze the gunship cannons."
	L.mage_message = "Mage Spawned!"
	L.mage_bar = "Next Mage"

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
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:Yell("Win", L["disable_trigger_alliance"], L["disable_trigger_horde"])
	self:Log("SPELL_CAST_SUCCESS", "Frozen", 69705)
	self:Log("SPELL_AURA_REMOVED", "FrozenCD", 69705)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["adds_trigger_alliance"], L["adds_trigger_horde"]) then
		self:Bar("adds", L["adds"], 60, 53142)
	end
end

function mod:Frozen(_, spellId)
	self:Message("mage", L["mage_message"], "Positive", spellId, "Info")
end

function mod:FrozenCD(_, spellId)
	self:Bar("mage", L["mage_bar"], 35, spellId)
end

