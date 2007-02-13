------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Crone"]
local roar = AceLibrary("Babble-Boss-2.2")["Roar"]
local tinhead = AceLibrary("Babble-Boss-2.2")["Tinhead"]
local strawman = AceLibrary("Babble-Boss-2.2")["Strawman"]
local dorothee = AceLibrary("Babble-Boss-2.2")["Dorothee"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "WizardofOz",

	summon_cmd = "summon",
	summon_name = "Summon Tito",
	summon_desc = "Alert when the Dorothee begins to summon Tito",

	spawns_cmd = "spawns",
	spawns_name = "Spawn Timers",
	spawns_desc = "Shows timer for when Roar, Tinhead and Strawman become hostile",

	spawns_roar = "Roar attacks!",
	spawns_strawman = "Strawman attacks!",
	spawns_tinhead = "Tinhead attacks!",
	spawns_tito = "Tito summoned!",

	summon_trigger = "Don't let them hurt us Tito! Oh, you won't, will you?",
	summon_message = "Summoning Tito!",

	engage_trigger = "Oh Tito, we simply must find a way home!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsWizardofOz = BigWigs:NewModule(boss)
BigWigsWizardofOz.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsWizardofOz.enabletrigger = {roar, tinhead, strawman, dorothee}
BigWigsWizardofOz.toggleoptions = {"summon", "spawns", "bosskill"}
BigWigsWizardofOz.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsWizardofOz:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function BigWigsWizardofOz:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["summon_trigger"]) and self.db.profile.summon then
		self:Message(L["summon_message"], "Attention")
	elseif msg:find(L["engage_trigger"]) and self.db.profile.spawns then
		self:Bar(self, L["spawns_roar"], 15, "INV_Staff_08")
		self:Bar(self, L["spawns_strawman"], 25, "Ability_Druid_ChallangingRoar")
		self:Bar(self, L["spawns_tinhead"], 35, "INV_Chest_Plate06")
		self:Bar(self, L["spawns_tito"], 48, "Ability_Hunter_Pet_Wolf")
	end
end
