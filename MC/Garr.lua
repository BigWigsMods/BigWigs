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

	pulse_name = "Antimagic Pulse Bar",
	pulse_desc = "Show a bar for Antimagic Pulse",

	pulse_trigger = "performs Antimagic Pulse",
	pulse_bar = "Antimagic Pulse",
} end)

L:RegisterTranslations("frFR", function() return {
	pulse_name = "Barre Impulsion anti-magique",
	pulse_desc = "Affiche une barre temporelle pour l'Impulsion anti-magique.",

	pulse_trigger = "effectue Impulsion anti-magique", -- à vérifier
	pulse_bar = "Impulsion anti-magique",
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
		self:TriggerEvent("BigWigs_StartBar", self, L["pulse_bar"], 18, "Interface\\Icons\\Spell_Holy_DispelMagic")
	end
end
