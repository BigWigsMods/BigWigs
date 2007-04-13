------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ysondre"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local BZ = AceLibrary("Babble-Zone-2.2")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ysondre",

	engage = "Engage Alert",
	engage_desc = ("Warn when %s is engaged"):format(boss),

	druids = "Druids Alert",
	druids_desc = "Warn for incoming druids",

	noxious = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	engage_message = "%s Engaged! - Noxious Breath in ~10seconds",
	engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!",

	druids_trigger = "Come forth, ye Dreamers - and claim your vengeance!",
	druids_message = "Incoming Druids!",

	noxious_hit = "afflicted by Noxious Breath",
	noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 seconds until Noxious Breath!",
	noxious_message = "Noxious Breath - 30 seconds till next!",
	noxious_bar = "Noxious Breath",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage = "狂怒警報",
	engage_desc = ("當%s狂怒時發出警報"):format(boss),

	--druids = "Druids Alert",
	--druids_desc = "Warn for incoming druids",

	noxious = "毒性吐息警報",
	noxious_desc = "毒性吐息警報",

	engage_message = "%s狂怒！ 10 秒後可能發動毒性吐息",
	engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!",

	--druids_trigger = "Come forth, ye Dreamers - and claim your vengeance!",
	--druids_message = "Incoming Druids!",

	noxious_hit = "受到了毒性吐息效果的影響。",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 秒後發動毒性吐息！",
	noxious_message = "毒性吐息 - 30 秒後再次發動",
	noxious_bar = "毒性吐息",
} end )

L:RegisterTranslations("frFR", function() return {
	engage = "Alerte Engagement",
	engage_desc = ("Pr\195\169viens quand %s est engag\195\169."):format(boss),

	druids = "Alerte Druides",
	druids_desc = "Pr\195\169viens de l'arriv\195\169e des druides.",

	noxious = "Alerte Souffle naus\195\169abond",
	noxious_desc = "Pr\195\169viens de l'arriv\195\169e des Souffles naus\195\169abonds.",

	engage_message = "%s engag\195\169 ! - Souffle naus\195\169abond dans ~10 sec.",
	engage_trigger = "Les fils de la VIE ont \195\169t\195\169 coup\195\169s\194\160! Les R\195\170veurs doivent \195\170tre veng\195\169s\194\160!",

	druids_trigger = "Venez, R\195\170veurs, et demandez vengeance\194\160!",
	druids_message = "Arriv\195\169e des druides !",

	noxious_hit = "les effets de Souffle naus\195\169abond",
	noxious_resist = "Souffle naus\195\169abond, mais .* r\195\169siste",
	noxious_warn = "5 sec. avant Souffle naus\195\169abond !",
	noxious_message = "Souffle naus\195\169abond - 30 sec. avant le suivant !",
	noxious_bar = "Souffle naus\195\169abond",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = {BZ["Ashenvale"], BZ["Duskwood"], BZ["The Hinterlands"], BZ["Feralas"]}
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.toggleoptions = {"engage", -1, "druids", "noxious", "bosskill"}
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
	self:TriggerEvent("BigWigs_ThrottleSync", "YsoNox", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Event(msg)
	if msg:find(L["noxious_hit"]) or msg:find(L["noxious_resist"]) then
		self:Sync("YsoNox")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:Bar(L["noxious_bar"], 10, "Spell_Shadow_LifeDrain02")
	elseif self.db.profile.druids and msg == L["druids_trigger"] then
		self:Message(L["druids_message"], "Positive")
	end
end

function mod:BigWigs_Message(text)
	if text == L["noxious_warn"] then
		self.prior = nil
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "YsoNox" and not self.prior and self.db.profile.noxious then
		self:Message(L["noxious_message"], "Important")
		self:DelayedMessage(25, L["noxious_warn"], "Urgent")
		self:Bar(L["noxious_bar"], 30, "Spell_Shadow_LifeDrain02")
		self.prior = true
	end
end
