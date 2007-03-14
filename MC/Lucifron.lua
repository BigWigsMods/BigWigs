------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lucifron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local prior1
local prior2

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Lucifron",

	curse = "Lucifron's Curse alert",
	curse_desc = "Warn for Lucifron's Curse",

	doom = "Impending Doom alert",
	doom_desc = "Warn for Impending Doom",

	mc = "Mind Control alert",
	mc_desc = "Warn about afflicted players",

	icon = "Place Icon",
	icon_desc = "Place a skull icon on the mind controlled person (requires promoted or higher)",

	curse_trigger = "afflicted by Lucifron",
	curse_message = "Lucifron's Curse - 20 seconds until next!",
	curse_warn = "5 seconds until Lucifron's Curse!",
	curse_bar = "Lucifron's Curse",

	doom_trigger = "afflicted by Impending Doom",
	doom_message = "Impending Doom - 20 seconds until next!",
	doom_warn = "5 seconds until Impending Doom!",
	doom_bar = "Impending Doom",

	mc_trigger = "^([^%s]+) ([^%s]+) afflicted by Dominate Mind.$",
	mc_message = "%s is Mind Controlled!",
	mc_bar = "MC: %s",

	you = "you",
} end)

L:RegisterTranslations("zhCN", function() return {
	curse = "诅咒警报",
	curse_desc = "诅咒警报",

	doom = "末日降临警报",
	doom_desc = "末日降临警报",

	--mc = "Mind Control alert",
	--mc_desc = "Warn about afflicted players",

	icon = "标记精神控制",
	icon_desc = "团队标记被精神控制者 (需要助力或更高权限)",

	curse_trigger = "受到了鲁西弗隆的诅咒",
	curse_message = "鲁西弗隆的诅咒 - 20秒后再次发动",
	curse_warn = "5秒后发动鲁西弗隆的诅咒！",
	curse_bar = "鲁西弗隆的诅咒",

	doom_trigger = "受到了末日降临",
	doom_message = "末日降临 - 20秒后再次发动",
	doom_warn = "5秒后发动末日降临！",
	doom_bar = "末日降临",

	--mc_trigger = "^([^%s]+) ([^%s]+) afflicted by Dominate Mind.$",
	--mc_message = "%s is Mind Controlled!",
	--mc_bar = "MC: %s",

	you = "你",
} end)

L:RegisterTranslations("zhTW", function() return {
	curse = "詛咒警報",
	curse_desc = "當魯西弗隆使用群體詛咒技能時發出警報",

	doom = "末日降臨警報",
	doom_desc = "當魯西弗隆使用末日降臨技能時發出警報",

	--mc = "Mind Control alert",
	--mc_desc = "Warn about afflicted players",

	icon = "標記被精神控制的隊友",
	icon_desc = "在被精神控制的隊友頭上設置標記 (需要助手或領隊權限)",

	curse_trigger = "受到了魯西弗隆的詛咒",
	curse_message = "群體詛咒 - 20 秒後再次發動",
	curse_warn = "群體詛咒 5 秒後發動！",
	curse_bar = "群體詛咒",

	doom_trigger = "受到了末日降臨",
	doom_message = "末日降臨 - 20 秒後再次發動",
	doom_warn = "末日降臨 5 秒後發動！",
	doom_bar = "末日降臨",

	--mc_trigger = "^([^%s]+) ([^%s]+) afflicted by Dominate Mind.$",
	--mc_message = "%s is Mind Controlled!",
	--mc_bar = "MC: %s",

	you = "你",
} end)

L:RegisterTranslations("koKR", function() return {
	curse = "루시프론의 저주 경고",
	curse_desc = "루시프론의 저주에 대한 경고",

	doom = "파멸의 예언 경고",
	doom_desc = "파멸의 예언에 대한 경고",

	mc = "정신 지배 경고",
	mc_desc = "정신 지배에 걸린 사람에 대한 경고",

	icon = "아이콘 지정",
	icon_desc = "정신 지배된 사람에게 해골 아이콘 지정 (승급자 이상 필요)",

	curse_trigger = "루시프론의 저주에 걸렸습니다.",
	curse_message = "루시프론의 저주 - 다음 저주는 20초후!",
	curse_warn = "5초후 루시프론의 저주!",
	curse_bar = "루시프론의 저주",

	doom_trigger = "파멸의 예언에 걸렸습니다.",
	doom_message = "파멸의 예언 - 다음 예언은 20초후!",
	doom_warn = "5초후 파멸의 예언!",
	doom_bar = "파멸의 예언",

	mc_trigger = "^([^|;%s]*)(.*)정신 지배에 걸렸습니다.$", -- CHECK
	mc_message = "%s 정신 지배!",
	mc_bar = "정배: %s",

	--you = "",
} end)

L:RegisterTranslations("deDE", function() return {
	curse = "Lucifrons Fluch",
	curse_desc = "Warnung vor Lucifrons Fluch.",

	doom = "Drohende Verdammnis",
	doom_desc = "Warnung vor Drohender Verdammnis.",

	--mc = "Mind Control alert",
	--mc_desc = "Warn about afflicted players",

	icon = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der unter Gedankenkontrolle steht. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	curse_trigger = "von Lucifrons Fluch betroffen",
	curse_message = "Lucifrons Fluch - N\195\164chster in 20 Sekunden!",
	curse_warn = "Lucifrons Fluch in 5 Sekunden!",
	curse_bar = "Lucifrons Fluch",

	doom_trigger = "von Drohende Verdammnis betroffen",
	doom_message = "Drohende Verdammnis - N\195\164chste in 20 Sekunden!",
	doom_warn = "Drohende Verdammnis in 5 Sekunden!",
	doom_bar = "Drohende Verdammnis",

	--mc_trigger = "^([^%s]+) ([^%s]+) afflicted by Dominate Mind.$",
	--mc_message = "%s is Mind Controlled!",
	--mc_bar = "MC: %s",

	you = "Ihr",
} end)

L:RegisterTranslations("frFR", function() return {
	curse = "Alerte Mal\195\169diction de Lucifron",
	curse_desc = "Pr\195\169viens des mal\195\169dictions de Lucifron.",

	doom = "Alerte Mal\195\169diction imminente",
	doom_desc = "Pr\195\169viens des mal\195\169dictions imminentes.",

	mc = "Alerte Contr\195\180le mental",
	mc_desc = "Pr\195\169viens quand un joueur est sous contr\195\180le mental.",

	icon = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur la personne sous contr\195\180le mental (n\195\169cessite d'\195\170tre promu ou mieux).",

	curse_trigger = "subit les effets de Mal\195\169diction de Lucifron",
	curse_message = "Mal\195\169diction de Lucifron - 20 sec avant prochaine !",
	curse_warn = "5 secondes avant Mal\195\169diction de Lucifron !",
	curse_bar = "Mal\195\169diction de Lucifron",

	doom_trigger = "subit les effets de Mal\195\169diction imminente.",
	doom_message = "Mal\195\169diction imminente - 20 sec avant prochaine !",
	doom_warn = "5 secondes avant Mal\195\169diction imminente !",
	doom_bar = "Mal\195\169diction imminente",

	mc_trigger = "^([^%s]+) ([^%s]+) les effets de Emprise.$", -- à vérifier
	mc_message = "%s est sous Contr\195\180le mental !",
	mc_bar = "CM : %s",

	you = "Vous",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
mod.enabletrigger = boss
mod.toggleoptions = {"curse", "doom", -1, "mc", "icon", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	prior1 = nil
	prior2 = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Event(msg)
	if (not prior1 and msg:find(L["curse_trigger"]) and self.db.profile.curse) then
		self:TriggerEvent("BigWigs_Message", L["curse_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 15, L["curse_warn"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 20, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		prior1 = true
	elseif (not prior2 and msg:find(L["doom_trigger"]) and self.db.profile.doom) then
		self:TriggerEvent("BigWigs_Message", L["doom_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 15, L["doom_warn"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["doom_bar"], 20, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
		prior2 = true
	end
end

function mod:BigWigs_Message(msg)
	if (msg == L["curse_warn"]) then prior1 = nil
	elseif (msg == L["doom_warn"]) then prior2 = nil end
end

function mod:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(msg)
	local mcplayer, mctype = select(3, msg:find(L["mc_trigger"]))
	if mcplayer then
		if mcplayer == L["you"] then
			mcplayer = UnitName("player")
		end
		if self.db.profile.mc then
			self:TriggerEvent("BigWigs_Message", string.format(L["mc_message"], mcplayer), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mc_bar"], mcplayer), 15, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate")
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", mcplayer)
		end
	end
end
