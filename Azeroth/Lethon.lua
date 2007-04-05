------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lethon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local BZ = AceLibrary("Babble-Zone-2.2")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Lethon",

	engage = "Engage Alert",
	engage_desc = ("Warn when %s is engaged"):format(boss),

	noxious = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	engage_message = "%s Engaged! - Noxious Breath in ~10seconds",
	engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!",

	noxious_hit = "afflicted by Noxious Breath",
	noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 seconds until Noxious Breath!",
	noxious_message = "Noxious Breath - 30 seconds till next!",
	noxious_bar = "Noxious Breath",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage = "狂怒警報",
	engage_desc = ("當%s狂怒時發出警報"):format(boss),

	noxious = "毒性吐息警報",
	noxious_desc = "毒性吐息警報",

	engage_message = "%s狂怒！ 10 秒後可能發動毒性吐息",
	engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!",

	noxious_hit = "受到了毒性吐息效果的影響。",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 秒後發動毒性吐息！",
	noxious_message = "毒性吐息 - 30 秒後再次發動",
	noxious_bar = "毒性吐息",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = {BZ["Ashenvale"], BZ["Duskwood"], BZ["The Hinterlands"], BZ["Feralas"]}
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.toggleoptions = {"engage", -1, "noxious", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LethNox", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Event(msg)
	if msg:find(L["noxious_hit"]) or msg:find(L["noxious_resist"]) then
		self:Sync("LethNox")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:Bar(L["noxious_bar"], 10, "Spell_Shadow_LifeDrain02")
	end
end

function mod:BigWigs_Message(text)
	if text == L["noxious_warn"] then
		self.prior = nil
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "LethNox" and not self.prior and self.db.profile.noxious then
		self:Message(L["noxious_message"], "Important")
		self:DelayedMessage(25, L["noxious_warn"], "Urgent")
		self:Bar(L["noxious_bar"], 30, "Spell_Shadow_LifeDrain02")
		self.prior = true
	end
end
