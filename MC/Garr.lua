------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Garr"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Garr",

	pulse = "Antimagic Pulse Bar",
	pulse_desc = "Show a bar for Antimagic Pulse",

	pulse_trigger = "performs Antimagic Pulse",
	pulse_bar = "Antimagic Pulse",
} end)

L:RegisterTranslations("frFR", function() return {
	pulse = "Barre Impulsion anti-magique",
	pulse_desc = "Affiche une barre temporelle pour l'Impulsion anti-magique.",

	pulse_trigger = "effectue Impulsion anti-magique", -- à vérifier
	pulse_bar = "Impulsion anti-magique",
} end)

L:RegisterTranslations("zhTW", function() return {
	cmd = "加爾",

	pulse = "Antimagic Pulse Bar",
	pulse_desc = "Show a bar for Antimagic Pulse",

	pulse_trigger = "performs Antimagic Pulse",
	pulse_bar = "Antimagic Pulse",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
mod.enabletrigger = boss
mod.toggleoptions = {"pulse", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (msg:find(L["pulse_trigger"])) then
		self:Bar(L["pulse_bar"], 18, "Spell_Holy_DispelMagic")
	end
end
