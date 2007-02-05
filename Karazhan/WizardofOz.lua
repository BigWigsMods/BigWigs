------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Crone"]
local tito = AceLibrary("Babble-Boss-2.2")["Tito"]
local tinhead = AceLibrary("Babble-Boss-2.2")["Tinhead"]
local strawman = AceLibrary("Babble-Boss-2.2")["Strawman"]
local dorothee = AceLibrary("Babble-Boss-2.2")["Dorothee"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "WizardofOz",

	summon_cmd = "summon",
	summon_name = "Summon Tito",
	summon_desc = "Alert when the Dorothee begins to summon Tito",

	summon_trigger = "Don't let them hurt us Tito! Oh, you won't, will you?",
	summon_message = "Summoning Tito!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsWizardofOz = BigWigs:NewModule(boss)
BigWigsWizardofOz.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsWizardofOz.enabletrigger = {tito, tinhead, strawman, dorothee}
BigWigsWizardofOz.toggleoptions = {"summon", "bosskill"}
BigWigsWizardofOz.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsWizardofOz:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsWizardofOz:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["summon_trigger"]) and self.db.profile.summon then
		self:TriggerEvent("BigWigs_Message", L["summon_message"], "Attention")
	end
end
