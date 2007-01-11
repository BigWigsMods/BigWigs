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

	pulse_cmd = "pulse",
	pulse_name = "Antimagic Pulse Bar",
	pulse_desc = "Show a bar for Antimagic Pulse",

	pulse_trigger = "performs Antimagic Pulse",
	pulse_bar = "Antimagic Pulse",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGarr = BigWigs:NewModule(boss)
BigWigsGarr.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsGarr.enabletrigger = boss
BigWigsGarr.toggleoptions = {"pulse", "bosskill"}
BigWigsGarr.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGarr:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGarr:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (msg:find(L["pulse_trigger"])) then
		self:TriggerEvent("BigWigs_StartBar", self, L["pulse_bar"], 18, "Interface\\Icons\\Spell_Holy_DispelMagic")
	end
end
