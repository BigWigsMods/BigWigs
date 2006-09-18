------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Princess Huhuran")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)
local berserkannounced
local prior

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Huhuran",

	wyvern_cmd = "wyvern",
	wyvern_name = "Wyvern Sting Alert",
	wyvern_desc = "Warn for Wyvern Sting",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for Frenzy",

	berserk_cmd = "berserk",
	berserk_name = "Berserk Alert",
	berserk_desc = "Warn for Berserk",

	frenzytrigger = "%s goes into a frenzy!",
	berserktrigger = "%s goes into a berserker rage!",
	frenzywarn = "Frenzy - Tranq Shot!",
	berserkwarn = "Berserk - Give it all you got!",
	berserksoonwarn = "Berserk Soon - Get Ready!",
	stingtrigger = "afflicted by Wyvern Sting",
	stingwarn = "Wyvern Sting!",
	stingdelaywarn = "Possible Wyvern Sting in 3 seconds!",
	bartext = "Wyvern Sting",

	startwarn = "Huhuran engaged, 5 minutes to berserk!",
	berserkbar = "Berserk",
	berserkwarn1 = "Berserk in 1 minute!",
	berserkwarn2 = "Berserk in 30 seconds!",
	berserkwarn3 = "Berserk in 5 seconds!",

} end )

L:RegisterTranslations("deDE", function() return {
	wyvern_name = "Stich des Fl\195\188geldrachen",
	wyvern_desc = "Warnung, wenn Huhuran Stich des Fl\195\188geldrachen wirkt.",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Huhuran in Raserei ger\195\164t.",

	berserk_name = "Berserkerwut",
	berserk_desc = "Warnung, wenn Huhuran in Berserkerwut verf\195\164llt.",

	frenzytrigger = "%s ger\195\164t in Raserei!",
	berserktrigger = "%s verf\195\164llt in Berserkerwut!",
	frenzywarn = "Raserei - Einlullender Schuss!",
	berserkwarn = "Berserkerwut - Volle DPS!",
	berserksoonwarn = "Berserkerwut in K\195\188rze - Bereit machen!",
	stingtrigger = "von Stich des Fl\195\188geldrachen betroffen",
	stingwarn = "Stich des Fl\195\188geldrachen - Krieger reinigen!",
	stingdelaywarn = "M\195\182glicher Stich des Fl\195\188geldrachen in 3 Sekunden!",
	bartext = "Stich",

	startwarn = "Huhuran angegriffen! 5 Minuten bis Berserkerwut!",
	berserkbar = "Berserkerwut",
	berserkwarn1 = "Berserkerwut in 1 Minute!",
	berserkwarn2 = "Berserkerwut in 30 Sekunden!",
	berserkwarn3 = "Berserkerwut in 5 Sekunden!",

} end )

L:RegisterTranslations("zhCN", function() return {
	wyvern_name = "毒性之箭警报",
	wyvern_desc = "毒性之箭警报",

	frenzy_name = "狂暴警报",
	frenzy_desc = "狂暴警报",

	berserk_name = "极度狂暴警报",
	berserk_desc = "极度狂暴警报",
	
	frenzytrigger = "变得狂暴起来！",
	berserktrigger = "变得极度狂暴而愤怒！",
	frenzywarn = "狂暴警报 - 猎人立刻使用宁神射击！",
	berserkwarn = "极度狂暴 - 治疗注意！",
	berserksoonwarn = "即将极度狂暴 - 做好准备！",
	stingtrigger = "受到了致命剧毒效果的影响。",
	stingwarn = "毒性之箭 - 给TANK驱散！",
	stingdelaywarn = "3秒后哈霍兰可能施放毒性之箭！",
	bartext = "毒性之箭",
	
	startwarn = "哈霍兰公主已激活 - 5分钟后进入极度狂暴状态",
	berserkbar = "极度狂暴",
	berserkwarn1 = "1分钟后极度狂暴！",
	berserkwarn2 = "30秒后极度狂暴！",
	berserkwarn3 = "5秒后极度狂暴！",
} end )

L:RegisterTranslations("koKR", function() return {

	wyvern_name = "비룡 쐐기 경고",
	wyvern_desc = "비룡 쐐기에 대한 경고",

	frenzy_name = "광폭화 경고",
	frenzy_desc = "광폭화에 대한 경고",

	berserk_name = "광기 경고",
	berserk_desc = "광기에 대한 경고",

	frenzytrigger = "%s|1이;가; 광란의 상태에 빠집니다!",
	berserktrigger = "%s|1이;가; 광폭해집니다!",
	frenzywarn = "광폭화 - 평정 사격!",
	berserkwarn = "광기 - 독 빈도 증가!",
	berserksoonwarn = "광폭화 경보 - 준비!",
	stingtrigger = "비룡 쐐기에 걸렸습니다.",--"공주 후후란|1이;가; 비룡 쐐기|1으로;로;",
	stingwarn = "비룡 쐐기 - 메인탱커 해제!",
	stingdelaywarn = "비룡 쐐기 3초전!",
	bartext = "비룡 쐐기",
	
	startwarn = "후후란 전투 개시, 5분 후 광기!!",
	berserkbar = "광기",
	berserkwarn1 = "광기 - 1 분전!",
	berserkwarn2 = "광기 - 30 초전!",
	berserkwarn3 = "광기 - 5 초전!",
} end )

L:RegisterTranslations("frFR", function() return {

	frenzytrigger = "%s est pris de fr\195\169n\195\169sie !",
	berserktrigger = "%s entre dans une rage d\195\169mente !",
	stingtrigger = "les effets de Piq\195\187re de wyverne",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHuhuran = BigWigs:NewModule(boss)
BigWigsHuhuran.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsHuhuran.enabletrigger = boss
BigWigsHuhuran.toggleoptions = {"wyvern", "frenzy", "berserk", "bosskill"}
BigWigsHuhuran.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHuhuran:OnEnable()
	prior = nil
	berserkannounced = nil

	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSting")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HuhuranStart", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsHuhuran:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BossEngaged" and rest and rest == boss then
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["berserkbar"], 300, "Interface\\Icons\\INV_Shield_01", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwhuhuranenragewarn1", "BigWigs_Message", 240, L["berserkwarn1"], "Yellow")
			self:ScheduleEvent("bwhuhuranenragewarn2", "BigWigs_Message", 270, L["berserkwarn2"], "Orange")
			self:ScheduleEvent("bwhuhuranenragewarn3", "BigWigs_Message", 295, L["berserkwarn3"], "Red")
		end
	end
end

function BigWigsHuhuran:CHAT_MSG_MONSTER_EMOTE(arg1)
	if self.db.profile.frenzy and arg1 == L["frenzytrigger"] then
		self:TriggerEvent("BigWigs_Message", L["frenzywarn"], "Orange")
	elseif self.db.profile.berserk and arg1 == L["berserktrigger"] then
		self:CancelScheduledEvent("bwhuhuranenragewarn1")
		self:CancelScheduledEvent("bwhuhuranenragewarn2")
		self:CancelScheduledEvent("bwhuhuranenragewarn3")

		self:TriggerEvent("BigWigs_StopBar", self, L["berserkbar"])

		self:TriggerEvent("BigWigs_Message", L["berserkwarn"], "Red")

		berserkannounced = true
	end
end

function BigWigsHuhuran:UNIT_HEALTH(arg1)
	if not self.db.profile.berserk then return end
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 30 and health <= 33 and not berserkannounced then
			self:TriggerEvent("BigWigs_Message", L["berserksoonwarn"], "Red")
			berserkannounced = true
		elseif (health > 40 and berserkannounced) then
			berserkannounced = false
		end
	end
end

function BigWigsHuhuran:checkSting(arg1)
	if not self.db.profile.wyvern then return end
	if not prior and string.find(arg1, L["stingtrigger"]) then
		self:TriggerEvent("BigWigs_Message", L["stingwarn"], "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 25, "Interface\\Icons\\INV_Spear_02", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("BigWigs_Message", 22, L["stingdelaywarn"], "Orange")
		prior = true
	end
end

function BigWigsHuhuran:BigWigs_Message(text)
	if text == L["stingdelaywarn"] then prior = nil end
end
