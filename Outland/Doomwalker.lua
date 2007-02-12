------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doomwalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Doomwalker",

	overrun_cmd = "overrun",
	overrun_name = "Overrun",
	overrun_desc = "Alert when Doomwalker uses his Overrun ability.",

	earthquake_cmd = "earthquake",
	earthquake_name = "Earthquake",
	earthquake_desc = "Alert when Doomwalker uses his Earthquake ability.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn about enrage around 20% hitpoints.",

	engage_message = "Doomwalker engaged, Earthquake in ~30sec!",

	earthquake_trigger = "You are afflicted by Earthquake.",

	earthquake_message = "Earthquake! ~70sec to next!",
	earthquake_bar = "Earthquake",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsDoomwalker = BigWigs:NewModule(boss, "AceHook-2.1")
BigWigsDoomwalker.zonename = AceLibrary("Babble-Zone-2.2")["Shadowmoon Valley"]
BigWigsDoomwalker.otherMenu = "Outland"
BigWigsDoomwalker.enabletrigger = boss
BigWigsDoomwalker.toggleoptions = { "overrun", "earthquake", "enrage", "bosskill" }
BigWigsDoomwalker.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsDoomwalker:OnEnable()
	started = nil

	self:Hook("ChatFrame_MessageEventHandler", "ChatFrame_MessageEventHandler", true)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "DoomwalkerEarthquake", 10)
end

------------------------------
--      Hooks               --
------------------------------

function BigWigsDoomwalker:ChatFrame_MessageEventHandler(event, ...)
	if event:find("EMOTE") and (type(arg2) == "nil" or not arg2) then
		arg2 = boss
	end
	return self.hooks["ChatFrame_MessageEventHandler"](event, ...)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsDoomwalker:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.earthquake then
			self:Message(L["engage_message"], "Attention")
			self:Bar(L["earthquake_bar"], 30, "Spell_Nature_Earthquake")
		end
	elseif sync == "DoomwalkerEarthquake" and self.db.profile.earthquake then
		self:Message(L["earthquake_message"], "Important")
		self:Bar(L["earthquake_bar"], 70, "Spell_Nature_Earthquake")
	end
end

function BigWigsDoomwalker:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if msg:find(L["earthquake_trigger"]) then
		self:Sync("DoomwalkerEarthquake")
	end
end


