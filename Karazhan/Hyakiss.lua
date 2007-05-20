------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hyakiss the Lurker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Hyakiss",

	web = "Web",
	web_desc = "Alert when a player gets webbed.",

	web_trigger = "^([^%s]+) ([^%s]+) afflicted by Hyakiss' Web.",
	web_message = "%s has been webbed.",
	web_bar = "Web: %s",
} end )

L:RegisterTranslations("zhTW", function() return {
	cmd = "亞奇斯",

	web = "亞奇斯之網",
	web_desc = "當人員受到亞奇斯之網影響時警告",

	web_trigger = "^(.+)受到(.*)亞奇斯之網",
	web_message = "%s 被網住了！",
	web_bar = "亞奇斯之網：%s",
} end )

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"web", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Web")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Web")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Web")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HyakissWeb", 3)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:Web(msg)
	local wplayer, wtype = select(3, msg:find(L["web_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = UnitName("player")
		end
		self:Sync("HyakissWeb "..wplayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "HyakissWeb" and rest and self.db.profile.web then
		self:Message(L["web_message"]:format(rest), "Urgent")
		self:Bar(L["web_bar"]:format(rest), 8, "Spell_Nature_Web")
	end
end
