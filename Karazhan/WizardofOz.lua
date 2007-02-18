------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Crone"]
local roar = AceLibrary("Babble-Boss-2.2")["Roar"]
local tinhead = AceLibrary("Babble-Boss-2.2")["Tinhead"]
local strawman = AceLibrary("Babble-Boss-2.2")["Strawman"]
local dorothee = AceLibrary("Babble-Boss-2.2")["Dorothee"]
local tito = AceLibrary("Babble-Boss-2.2")["Tito"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "WizardofOz",

	summon_cmd = "summon",
	summon_name = "Summon Tito",
	summon_desc = ("Alert when %s begins to summon %s"):format(dorothee, tito),

	spawns_cmd = "spawns",
	spawns_name = "Spawn Timers",
	spawns_desc = ("Shows timer for when %s, %s and %s become hostile"):format(roar, tinhead, strawman),

	spawns_roar = "%s attacks!",
	spawns_strawman = "%s attacks!",
	spawns_tinhead = "%s attacks!",
	spawns_tito = "%s summoned!",

	summon_trigger = "Don't let them hurt us Tito! Oh, you won't, will you?",
	summon_message = "Summoning %s!",

	engage_trigger = "Oh Tito, we simply must find a way home!",
} end)

L:RegisterTranslations("deDE", function() return {
	summon_name = "Tito rufen",
	summon_desc = ("Warnt wenn %s beginnt %s zu rufen"):format(dorothee, tito),

	spawns_name = "Spawn Timer",
	spawns_desc = ("Timerbalken wann %s, %s und %s in den Kampf eingreifen"):format(roar, tinhead, strawman),

	spawns_roar = "%s greift an!",
	spawns_strawman = "%s greift an!",
	spawns_tinhead = "%s greift an!",
	spawns_tito = "%s gerufen!",

	summon_trigger = "Lass' nicht zu, dass sie uns wehtun, Tito. Nein, das wirst du nicht, oder?",
	summon_message = "%s herbeigerufen!",

	engage_trigger = "Oh Tito, wir m\195\188ssen einfach einen Weg nach Hause finden!",
} end)


----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsWizardofOz = BigWigs:NewModule(boss)
BigWigsWizardofOz.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsWizardofOz.enabletrigger = {roar, tinhead, strawman, dorothee}
BigWigsWizardofOz.toggleoptions = {"summon", "spawns", "bosskill"}
BigWigsWizardofOz.revision = tonumber(("$Revision$"):sub(12, -3))

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
		self:Message(L["summon_message"]:format(tito), "Attention")
	elseif msg:find(L["engage_trigger"]) and self.db.profile.spawns then
		self:Bar(L["spawns_roar"]:format(roar), 15, "INV_Staff_08")
		self:Bar(L["spawns_strawman"]:format(strawman), 25, "Ability_Druid_ChallangingRoar")
		self:Bar(L["spawns_tinhead"]:format(tinhead), 35, "INV_Chest_Plate06")
		self:Bar(L["spawns_tito"]:format(tito), 48, "Ability_Hunter_Pet_Wolf")
	end
end
