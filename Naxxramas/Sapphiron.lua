------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Sapphiron")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local time

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sapphiron",

	engage_warn = "Sapphiron engaged! 10-24sec to Life Drain!",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Sapphiron begins to cast Deep Breath.",

	lifedrain_cmd = "lifedrain",
	lifedrain_name = "Life Drain",
	lifedrain_desc = "Warns about the Life Drain curse.",

	lifedrain_message = "Life Drain! Possibly new one ~24sec!",
	lifedrain_warn1 = "Life Drain in 5sec!",
	lifedrain_bar = "Life Drain",

	lifedrain_trigger = "afflicted by Life Drain",
	lifedrain_trigger2 = "Life Drain was resisted by",

	deepbreath_trigger = "%s takes in a deep breath...",
	deepbreath_warning = "Ice Bomb Incoming!",
	deepbreath_bar = "Ice Bomb Lands!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSapphiron = BigWigs:NewModule(boss)
BigWigsSapphiron.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsSapphiron.enabletrigger = boss
BigWigsSapphiron.toggleoptions = { "lifedrain", "deepbreath", "bosskill" }
BigWigsSapphiron.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

--[[
--
24, 24, 49, 24
16, 24, 48
18, 24, 
18, 24
12, 24, 44, 24, 24, 60, 24, 24, 44, 24

It seems the first Life Drain happens at 10-24sec, then one at 24sec
Then he lifts for a little while - probably 30sec, then comes down and next life drain in 10-12sec.

]]

function BigWigsSapphiron:OnEnable()
	time = nil

    self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "LifeDrain")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SapphironLifeDrain", 4)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSapphiron:BigWigs_RecvSync( sync, rest, nick )
	if sync == "SapphironLifeDrain" and self.db.profile.lifedrain then
		self:TriggerEvent("BigWigs_Message", L["lifedrain_message"], "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L["lifedrain_bar"], 24, "Interface\\Icons\\Spell_Shadow_LifeDrain02", "Yellow", "Orange", "Red")
	end
end

function BigWigsSapphiron:LifeDrain(msg)
	if string.find(msg, L["lifedrain_trigger"]) or string.find(msg, L["lifedrain_trigger2"]) then
		if not time or (time + 2) > GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "SapphironLifeDrain")
			time = GetTime()
		end
	end
end

function BigWigsSapphiron:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["deepbreath_trigger"] then
		if self.db.profile.deepbreath then
			self:TriggerEvent("BigWigs_Message", L["deepbreath_warning"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["deepbreath_bar"], 8, "Interface\\Icons\\Spell_Frost_FrostShock", "Blue")
		end
	end
end

