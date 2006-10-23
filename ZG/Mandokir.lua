------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Bloodlord Mandokir"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Mandokir",

	you_cmd = "you",
	you_name = "You're being watched alert",
	you_desc = "Warn when you're being watched",

	other_cmd = "other",
	other_name = "Others being watched alert",
	other_desc = "Warn when others are being watched",

	icon_cmd = "icon",
	icon_name = "Raid icon on watched",
	icon_desc = "Puts a raid icon on the watched person",

	watch_trigger = "([^%s]+)! I'm watching you!$",
	enrage_trigger = "goes into a rage after seeing his raptor fall in battle!$",

	watched_warning_self = "You are being watched!",
	watched_warning_other = "%s is being watched!",
	enraged_message = "Ohgan down! Mandokir enraged!",	
} end )

L:RegisterTranslations("frFR", function() return {
	you_name = "Alerte quand vous \195\170tes surveill\195\169",
	you_desc = "Vous alerte lorsque vous \195\170tes surveill\195\169.",

	other_name = "Alerte quand d'autres sont surveill\195\169s",
	other_desc = "Vous alerte quand d'autres joueurs sont surveill\195\169s.",

	icon_name = "Ic\195\180ne de raid",
	icon_desc = "Place une ic\195\180ne de raid sur la derni\195\168re personne surveill\195\169e (requiert d'\195\170tre promus ou plus)",

	watch_trigger = "([^%s]+), je vous ai à l'œil !",
	enrage_trigger = "devient fou furieux en voyant son raptor mourir durant le combat !",

	watched_warning_self = "Tu es surveill\195\169 !",
	watched_warning_other = "%s est surveill\195\169 !",
	enraged_message = "Ohgan est mort ! Mandokir enrag\195\169 !",
} end )

L:RegisterTranslations("deDE", function() return {
	you_name = "Du wirst beobachtet",
	you_desc = "Warnung, wenn Du beobachtet wirst.",

	other_name = "X wird beobachtet",
	other_desc = "Warnung, wenn andere Spieler beobachtet werden.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler der beobachtet wird. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	watch_trigger = "([^%s]+)! Ich behalte Euch im Auge!$",
	enrage_trigger = "%s ger\195\164t in Rage, als er sieht, dass sein Raptor im Kampf stirbt!",

	watched_warning_self = "Du wirst beobachtet!",
	watched_warning_other = "%s wird beobachtet!",
	enraged_message = "Ohgan get\195\182tet! Mandokir w\195\188tend!",
} end )

L:RegisterTranslations("zhCN", function() return {
	you_name = "玩家被盯警报",
	you_desc = "你被血领主盯上时发出警报",

	other_name = "队友被盯警报",
	other_desc = "队友被血领主盯上时发出警报",

	icon_name = "标记被盯上的玩家",
	icon_desc = "团队标记被盯上的玩家",

	watch_trigger = "(.+)！我正在看着你！$",
	enrage_trigger = "怒不可遏！$",

	watched_warning_self = "你被盯上了 - 停止一切动作！",
	watched_warning_other = "%s被盯上了！",
	enraged_message = "奥根死了！血领主进入激怒状态！",	
} end )


L:RegisterTranslations("zhTW", function() return {
	-- Bloodlord Mandokir 血領主曼多基爾
	you_name = "玩家被盯警報",
	you_desc = "你被血領主盯上時發出警報",

	other_name = "隊友被盯警報",
	other_desc = "隊友被血領主盯上時發出警報",

	icon_name = "標記被盯上的玩家",
	icon_desc = "團隊標記被盯上的玩家",

	watch_trigger = "(.+)！我正在監視你！$",
	enrage_trigger = "怒不可遏！$",

	watched_warning_self = "*** 你被盯上了！停止一切動作！ ***",
	watched_warning_other = "*** %s被盯上了！ ***",
	enraged_message = "*** 奧根死了！血領主進入狂怒！ ***",
} end )

L:RegisterTranslations("koKR", function() return {
	you_name = "자신 경고",
	you_desc = "자신을 보고 있을 때 경고",
	
	other_name = "타인 경고",
	other_desc = "타인을 보고 있을 때 경고",

	icon_name = "보고있을 때 아이콘 표시",
	icon_desc = "보고 있는 사람에게 아이콘 표시",

	watch_trigger = "(.+)! 널 지켜보고 있겠다!",
	enrage_trigger = "전장에서 자신의 랩터가 쓰러지는 모습을 보자 분노에 휩싸입니다!",

	watched_warning_self = "당신을 지켜보고 있습니다 - 모든 동작 금지!",
	watched_warning_other = "%s님을 지켜봅니다!",
	enraged_message = "오간이 죽자, 만도키르가 분노합니다.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMandokir = BigWigs:NewModule(boss)
BigWigsMandokir.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsMandokir.enabletrigger = boss
BigWigsMandokir.toggleoptions = {"you", "other", "icon", "bosskill"}
BigWigsMandokir.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMandokir:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Events              --
------------------------------

function BigWigsMandokir:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["enrage_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["enraged_message"], "Urgent")
	end
end

function BigWigsMandokir:CHAT_MSG_MONSTER_YELL(msg)
	local _,_, n = string.find(msg, L["watch_trigger"])
	if n then
		if n == UnitName("player") and self.db.profile.you then
			self:TriggerEvent("BigWigs_Message", L["watched_warning_self"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["watched_warning_other"], UnitName("player")), "Attention", nil, nil, true)
		elseif self.db.profile.other then
			self:TriggerEvent("BigWigs_Message", string.format(L["watched_warning_other"], n), "Attention")
			self:TriggerEvent("BigWigs_SendTell", n, L["watched_warning_self"])
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", n)
		end
	end
end

