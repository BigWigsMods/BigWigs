------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Curator"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local enrageannounced

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Curator",

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for berserk after 12min.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn for enrage at 10%.",

	weaken_cmd = "weaken",
	weaken_name = "Weaken",
	weaken_desc = "Alert when The Curator is weakened.",

	weaktime_cmd = "weaktime",
	weaktime_name = "Weaken Countdown",
	weaktime_desc = "Countdown warning and bar untill next weaken.",

	weaken_trigger = "Your request cannot be processed.",
	weaken_message = "Evocation - Weakened for 20sec!",
	weaken_bar = "Evocation",
	weaken_fade_message = "Evocation Finished - Weakened Gone!",
	weaken_fade_warning = "Evocation over in 5sec!",

	weaktime_message1 = "Evocation in ~10 seconds",
	weaktime_message2 = "Evocation in ~30 seconds",
	weaktime_message3 = "Evocation in ~70 seconds",
	weaktime_bar = "Next Evocation",

	berserk_trigger = "The Menagerie is for guests only.",
	berserk_message = "Curator engaged, 12min to berserk!",
	berserk_bar = "Berserk",

	enrage_trigger = "", --wtb a message? did he even enrage? need verification, i didn't notice this happen.
	enrage_message = "Enrage!",
	enrage_warning = "Enrage soon!",
} end )

L:RegisterTranslations("deDE", function() return {
	berserk_cmd = "berserk",
	berserk_name = "Berserker",
	berserk_desc = "Warnung f\195\188r Berserker nach 12min.",

	enrage_cmd = "enrage",
	enrage_name = "Rage",
	enrage_desc = "Warnung f\195\188r Rage bei 10%.",

	weaken_cmd = "weaken",
	weaken_name = "Schw\195\164chung",
	weaken_desc = "Warnt wen der Kurator geschw\195\164cht ist.",

	weaktime_cmd = "weaktime",
	weaktime_name = "Schw\195\164chungs Timer",
	weaktime_desc = "Timer und Anzeige f\195\188r die n\195\164chste Schw\195\164chung.",

	weaken_trigger = "Ihre Anfrage kann nicht bearbeitet werden.",
	weaken_message = "Hervorrufung f\195\188r 20 sekunden!",
	weaken_bar = "Hervorrufung",
	weaken_fade_message = "Hervorrufung beendet - Kurator nicht mehr geschw\195\164cht!",
	weaken_fade_warning = "Hervorrufung in 5 sekunden beendet!",

	weaktime_message1 = "Hervorrufung in ~10 sekunden",
	weaktime_message2 = "Hervorrufung in ~30 sekunden",
	weaktime_message3 = "Hervorrufung in ~70 sekunden",
	weaktime_bar = "N\195\164chste Hervorrufung",

	berserk_trigger = "Die Menagerie ist nur f\195\188r G\195\164ste.",
	berserk_message = "Kurator aktiviert, 12min bis Berserker!",
	berserk_bar = "Berserker",

	enrage_trigger = "Die Nichteinhaltung wird zur Angriffshandlungen f\195\188hren.",
	enrage_message = "Kurator in Rage!",
	enrage_warning = "Kurator bald in Rage!",
} end )

----------------------------------
--   Module Declaration   --
----------------------------------

BigWigsCurator = BigWigs:NewModule(boss)
BigWigsCurator.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsCurator.enabletrigger = boss
BigWigsCurator.toggleoptions = {"weaken", "weaktime", "berserk", "enrage", "bosskill"}
BigWigsCurator.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsCurator:OnEnable()
	enrageannounced = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsCurator:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["berserk_trigger"]) and self.db.profile.berserk then
		self:Message(L["berserk_message"], "Attention")
		self:Bar(L["berserk_bar"], 720, "INV_Shield_01")
	elseif msg:find(L["berserk_trigger"]) and self.db.profile.weaktime then
		self:Evocation()
	elseif msg:find(L["weaken_trigger"]) and self.db.profile.weaken then
		self:Message(L["weaken_message"], "Important", nil, "Alarm")
		self:Bar(L["weaken_bar"], 20, "Spell_Nature_Purge")
		self:DelayedMessage(15, L["weaken_fade_warning"], "Urgent")
		self:DelayedMessage(20, L["weaken_fade_message"], "Important", nil, "Alarm")
		self:Evocation()
	end
end

function BigWigsCurator:Evocation()
	if self.db.profile.weaktime then
		self:Bar(L["weaktime_bar"], 109, "Spell_Nature_Purge")
		self:DelayedMessage(39, L["weaktime_message3"], "Positive")
		self:DelayedMessage(79, L["weaktime_message2"], "Attention")
		self:DelayedMessage(99, L["weaktime_message1"], "Urgent")
	end
end

function BigWigsCurator:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 10 and health <= 13 and not enrageannounced then
			self:Message(L["enrage_warning"], "Positive")
			enrageannounced = true
		elseif health > 50 and enrageannounced then
			enrageannounced = false
		end
	end
end
