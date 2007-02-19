------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Nightbane"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local ground
local groundcount

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Nightbane",

	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for Bellowing Roar",

	charr_cmd = "charr",
	charr_name = "Charred Earth on You",
	charr_desc = "Warn when you are on Charred Earth",

	charrtime_cmd = "charrtime",
	charrtime_name = "Charred Earth Despawn",
	charrtime_desc = "Timer for when Charred Earth despawns",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = ("Warn when %s switches between phases"):format(boss),

	engage_cmd = "engage",
	engage_name = "Engage",
	engage_desc = "Engage alert",

	fear_trigger = "cast Bellowing Roar",
	fear_message = "Fear in 2 sec!",
	fear_bar = "Fear",

	charr_trigger = "You are afflicted by Charred Earth.",
	charr_message = "Charred Earth on YOU!",

	charrtime_trigger = "afflicted by Charred Earth",
	charrtime_warning = "Charred Earth (%d) over in 15sec",
	charrtime_message = "Charred Earth (%d) over in 5sec",
	charrtime_bar = "Charred Earth (%d)",

	airphase_trigger = "Miserable vermin. I shall exterminate you from the air!",
	landphase_trigger = "Enough! I shall land and crush you myself!",
	airphase_message = "Flying!",
	landphase_message = "Landing!",

	engage_trigger = "What fools! I shall bring a quick end to your suffering!",
	engage_message = "%s Engaged",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsNightbane = BigWigs:NewModule(boss)
BigWigsNightbane.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsNightbane.enabletrigger = boss
BigWigsNightbane.toggleoptions = {"engage", "phase", "fear", -1, "charr", "charrtime", "bosskill"}
BigWigsNightbane.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNightbane:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NightbaneFear", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "NightbaneCharr", 14)

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_Message")
	ground = nil
	groundcount = 1
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsNightbane:BigWigs_RecvSync( sync, rest, nick )
	if sync == "NightbaneFear" and self.db.profile.fear then
		self:Bar(L["fear_bar"], 2, "Spell_Shadow_PsychicScream")
		self:Message(L["fear_warn"], "Positive")
	elseif sync == "NightbaneCharr" and self.db.profile.charrtime then
		self:Bar(L["charrtime_bar"]:format(groundcount), 30, "Spell_Fire_LavaSpawn")
		self:DelayedMessage(15, L["charrtime_warning"]:format(groundcount), "Attention", true)
		self:DelayedMessage(25, L["charrtime_message"]:format(groundcount), "Attention")
		groundcount = groundcount + 1
	end
end

function BigWigsNightbane:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["fear_trigger"]) then
		self:Sync("NightbaneFear")
	end
end

function BigWigsNightbane:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Positive")
	elseif self.db.profile.phase and msg == L["airphase_trigger"] then
		self:Message(L["airphase_message"], "Attention", nil, "Info")
	elseif self.db.profile.phase and msg == L["landphase_trigger"] then
		self:Message(L["landphase_message"], "Important", nil, "Long")
	end
end

function BigWigsNightbane:Event(msg)
	if self.db.profile.charr and msg == L["char_trigger"] then
		self:Message(L["charr_message"], "Urgent", true, "Alarm")
	elseif not ground and msg:find(L["charrtime_trigger"]) then
		self:Sync("NightbaneCharr")
		ground = true
	end
end

function BigWigsNightbane:BigWigs_Message(text)
	if text == L["charrtime_warning"] then
		ground = nil
	end
end
