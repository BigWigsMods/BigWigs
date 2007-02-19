------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doom Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Timers for enrage",

	enrage_trigger1 = "For the Legion! For Kil'Jaeden!",
	enrage_trigger2 = "%s becomes enraged!",
	enrage_warning1 = "%s Engaged- Enrage in 1min",
	enrage_warning2 = "Enrage in 5 sec",
	enrage_message = "Enrage for 10sec!",
	enrage_bar = "Enrage",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

BigWigsKazzak = BigWigs:NewModule(boss)
BigWigsKazzak.zonename = AceLibrary("Babble-Zone-2.2")["Hellfire Peninsula"]
BigWigsKazzak.otherMenu = "Outland"
BigWigsKazzak.enabletrigger = boss
BigWigsKazzak.toggleoptions = {"enrage", "bosskill"}
BigWigsKazzak.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKazzak:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
end

------------------------------
--    Event Handlers     --
------------------------------

function BigWigsKazzak:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.enrage then return end
	if msg == L["enrage_trigger"] then
		self:Message(L["enrage_warning1"]:format(boss), "Attention")
		self:DelayedMessage(5, L["enrage_warning2"], "Urgent")
		self:Bar(L["enrage_bar"], 60, "Spell_Shadow_UnholyFrenzy")
	elseif msg == L["enrage_trigger2"] then
		self:Message(L["enrage_message"], "Important")
		self:Bar(L["enrage_bar"], 10, "Spell_Shadow_UnholyFrenzy")
	end
end
