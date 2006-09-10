------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Flamegor")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "Flamegor begins to cast Wing Buffet",
	trigger2 = "Flamegor begins to cast Shadow Flame.",
	trigger3 = "%s goes into a frenzy!",

	warn1 = "Wing Buffet! 30sec to next!",
	warn3 = "3sec to Wing Buffet!",
	warn4 = "Shadow Flame incoming!",
	warn5 = "Frenzy - Tranq Shot!",

	bar1text = "Wing Buffet",

	cmd = "Flamegor",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when for frenzy",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "弗莱格尔开始施放龙翼打击。",
	trigger2 = "弗莱格尔开始施放暗影烈焰。",
	trigger3 = "变得狂暴起来！",

	warn3 = "3秒后发动龙翼打击！",
	warn4 = "暗影烈焰发动！",
	warn5 = "狂暴警报 - 猎人立刻使用宁神射击！",

	bar1text = "龙翼打击",

	wingbuffet_name = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",

	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",

	frenzy_name = "狂暴警报",
	frenzy_desc = "狂暴警报",
} end)


L:RegisterTranslations("koKR", function() return {
	trigger1 = "플레임고르|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	trigger2 = "플레임고르|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	trigger3 = "광란의 상태에 빠집니다!",

	warn3 = "3초후 폭풍 날개!",
	warn4 = "암흑의 불길 경보!",
	warn5 = "광란 - 평정 사격!",

	bar1text = "폭풍 날개",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger2 = "Flammenmaul beginnt Schattenflamme zu wirken.",
	trigger3 = "%s ger\195\164t in Raserei!",

	warn3 = "3 Sekunden bis Fl\195\188gelsto\195\159!",
	warn4 = "Schattenflamme in K\195\188rze!",
	warn5 = "Raserei - Einlullender Schuss!",

	bar1text = "Fl\195\188gelsto\195\159",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Flammenmaul Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Flammenmaul Schattenflamme wirkt.",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Flammenmaul in Raserei ger\195\164t.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "Flamegor commence \195\160 lancer Frappe des ailes.",
	trigger2 = "Flamegor commence \195\160 lancer Flamme d'ombre.",
	trigger3 = "est pris de fr\195\169n\195\169sie !",

	warn3 = "3 sec avant prochaine Frappe des ailes!",
	warn4 = "Flamme d'ombre imminente!",
	warn5 = "Frenzy - Tranq Shot!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFlamegor = BigWigs:NewModule(boss)
BigWigsFlamegor.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsFlamegor.enabletrigger = boss
BigWigsFlamegor.toggleoptions = {"wingbuffet", "shadowflame", "frenzy", "bosskill"}
BigWigsFlamegor.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFlamegor:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorWingBuffet", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------
function BigWigsFlamegor:Scan()
	if UnitName("target") == boss and UnitAffectingCombat("target") then
		return true
	elseif UnitName("playertarget") == boss and UnitAffectingCombat("playertarget") then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == (boss) and UnitAffectingCombat("raid"..i.."target") then
				return true
			end
		end
	end
	return false
end

function BigWigsFlamegor:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Flamegor_CheckStart")
	if (go) then
		self:CancelScheduledEvent("Flamegor_CheckStart")
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffet")
	elseif not running then
		self:ScheduleRepeatingEvent("Flamegor_CheckStart", self.PLAYER_REGEN_DISABLED, .5, self)
	end
end

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L["trigger1"])) then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffet")
	elseif msg == L["trigger2"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorShadowflame")
	end
end

function BigWigsFlamegor:BigWigs_RecvSync(sync)
	if (sync == "FlamegorWingBuffet" and self.db.profile.wingbuffet) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Red")
		self:ScheduleEvent("BigWigs_Message", 29, L["warn3"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 32, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "FlamegorShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["warn4"], "Red")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE(msg)
	if (msg == L["trigger3"] and self.db.profile.frenzy) then
		self:TriggerEvent("BigWigs_Message", L["warn5"], "Red")
	end
end
