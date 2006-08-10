------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Bloodlord Mandokir")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "mandokir",
	
	you_cmd = "you",
	you_name = "You're being watched alert",
	you_desc = "Warn when you're being watched",
	
	other_cmd = "other",
	other_name = "Others being watched alert",
	other_desc = "Warn when others are being watched",

	trigger1 = "([^%s]+)! I'm watching you!$",
	trigger2 = "goes into a rage after seeing his raptor fall in battle!$",

	warn1 = "You are being watched - stop all actions!",
	warn2 = "%s is being watched!",
	warn3 = "Ohgan down! Mandokir enraged!",	
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 =  "([^%s]+), je vous ai \195\160 l'\197\147il";

	warn1 = "Tu es surveill\195\169 !",
	warn2 = "%s est surveill\195\169 !",
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 =  "([^%s]+)! Ich behalte Euch im Auge!";

	warn1 = "Du wirst beobachtet!",
	warn2 = "%s wird beobachtet!",
} end )

L:RegisterTranslations("zhCN", function() return {
	you_name = "玩家被盯警报",
	you_desc = "你被血领主盯上时发出警报",
	
	other_name = "队友被盯警报",
	other_desc = "队友被血领主盯上时发出警报",
	
	trigger1 = "(.+)！我正在看着你！$",
	trigger2 = "怒不可遏！$",

	warn1 = "你被盯上了 - 停止一切动作！",
	warn2 = "%s被盯上了！",
	warn3 = "奥根死了！血领主进入激怒状态！",	
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "(.+)! 널 지켜보고 있겠다!",

	warn1 = "당신을 지켜보고 있습니다 - 모든 동작 금지!",
	warn2 = "%s님을 지켜봅니다!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMandokir = BigWigs:NewModule(boss)
BigWigsMandokir.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsMandokir.enabletrigger = boss
BigWigsMandokir.toggleoptions = {"you", "other", "bosskill"}
BigWigsMandokir.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMandokir:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsMandokir:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L"trigger2") then self:TriggerEvent("BigWigs_Message", L"warn3", "Orange") end
end


function BigWigsMandokir:CHAT_MSG_MONSTER_YELL(msg)
	local _,_, n = string.find(msg, L"trigger1")
	if n then
		if n == UnitName("player") then
			if self.db.profile.you then self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true, "Alarm") end
		elseif self.db.profile.other then
			self:TriggerEvent("BigWigs_Message", string.format(L"warn2", n), "Yellow")
			self:TriggerEvent("BigWigs_SendTell", n, L"warn1")
		end
		self:TriggerEvent("BigWigs_SetRaidIcon", n )
	end
end