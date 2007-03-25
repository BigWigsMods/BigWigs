------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Fathom-Lord Karathress"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Karathress",

	enrage = "Enrage",
	enrage_desc = "Enrage Timers",

	enrage_trigger = "Guards, attention!",
	enrage_message = "%s engaged, Enrage in 10min",
	enrage_min = "Enrage in %dmin",
	enrage_sec = "Enrage in %dsec",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg:find(L["enrage_trigger"]) then
		self:Message(L["enrage_message"]:format(boss), "Important")
		self:DelayedMessage(300, L["enrage_min"]:format(5), "Positive")
		self:DelayedMessage(420, L["enrage_min"]:format(3), "Positive")
		self:DelayedMessage(540, L["enrage_sec"]:format(60), "Positive")
		self:DelayedMessage(570, L["enrage_sec"]:format(30), "Positive")
		self:DelayedMessage(590, L["enrage_sec"]:format(10), "Urgent")
		self:DelayedMessage(600, L["enrage"], "Attention", nil, "Alarm")
		self:Bar(L["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
	end
end
