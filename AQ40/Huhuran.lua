------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Princess Huhuran")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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

	frenzytrigger = "goes into a frenzy!",
	berserktrigger = "goes into a berserker rage!",
	frenzywarn = "Frenzy - Tranq Shot!",
	berserkwarn = "Berserk - Give it all you got!",
	berserksoonwarn = "Berserk Soon - Get Ready!",
	stingtrigger = "afflicted by Wyvern Sting",
	stingwarn = "Wyvern Sting - Dispel Tanks!",
	stingdelaywarn = "Possible Wyvern Sting in 3 seconds!",
	bartext = "Wyvern Sting",
	
	startwarn = "Huhuran engaged, 5 minutes to berserk!",
	berserkbar = "Berserk",
	berserkwarn1 = "Berserk in 1 minute!",
	berserkwarn2 = "Berserk in 30 seconds!",
	berserkwarn3 = "Berserk in 5 seconds!",

} end )

L:RegisterTranslations("zhCN", function() return {
	frenzytrigger = "变得狂暴起来！",
	berserktrigger = "变得极度狂暴而愤怒！",
	frenzywarn = "狂暴警报 - 猎人立刻使用宁神射击！",
	berserkwarn = "狂暴模式 - 治疗注意！",
	berserksoonwarn = "即将狂暴 - 做好准备！",
	stingtrigger = "受到了致命剧毒效果的影响。",
	stingwarn = "毒性之箭 - 给TANK驱散！",
	stingdelaywarn = "3秒后哈霍兰可能施放毒性之箭！",
	bartext = "毒性之箭",
} end )

L:RegisterTranslations("koKR", function() return {
	frenzytrigger = "광란의 상태에 빠집니다!",
	berserktrigger = "광폭해집니다!",
	frenzywarn = "광폭화 - 평정 사격!",
	berserkwarn = "광기 - 독 빈도 증가!",
	berserksoonwarn = "광폭화 경보 - 준비!",
	stingtrigger = "공주 후후란|1이;가; 비룡 쐐기|1으로;로;",
	stingwarn = "비룡 쐐기 - 메인탱커 해제!",
	stingdelaywarn = "비룡 쐐기 3초전!",
	bartext = "비룡 쐐기",
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
	self.prior = nil
	self.berserkannounced = nil
	self.started = nil
	
	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	
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

function BigWigsHuhuran:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Huhuran_CheckStart")
	if go then
		self:CancelScheduledEvent("Huhuran_CheckStart")
		self:TriggerEvent("BigWigs_SendSync", "HuhuranStart")
	elseif not running then
		self:ScheduleRepeatingEvent("Huhuran_CheckStart", self.PLAYER_REGEN_DISABLED, .5, self )
	end
end

function BigWigsHuhuran:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Huhuran_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Huhuran_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsHuhuran:Scan()
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

function BigWigsHuhuran:BigWigs_RecvSync( sync )
	if sync == "HuhuranStart" then
		if self.db.profile.berserk and not self.started then
			self.started = true
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L"berserkbar", 300, 1, "Interface\\Icons\\INV_Shield_01", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwhuhuranenragewarn1", "BigWigs_Message", 240, L"berserkwarn1", "Yellow")
			self:ScheduleEvent("bwhuhuranenragewarn2", "BigWigs_Message", 270, L"berserkwarn2", "Orange")
			self:ScheduleEvent("bwhuhuranenragewarn3", "BigWigs_Message", 295, L"berserkwarn3", "Red")
		end
	end
end

function BigWigsHuhuran:CHAT_MSG_MONSTER_EMOTE(arg1)
	if self.db.profile.frenzy and arg1 == L"frenzytrigger" then
		self:TriggerEvent("BigWigs_Message", L"frenzywarn", "Orange")
	elseif self.db.profile.berserk and arg1 == L"berserktrigger" then

		self:CancelScheduledEvent("bwhuhuranenragewarn1")
		self:CancelScheduledEvent("bwhuhuranenragewarn2")
		self:CancelScheduledEvent("bwhuhuranenragewarn3")

		self:TriggerEvent("BigWigs_StopBar", self, L"berserkbar")

		self:TriggerEvent("BigWigs_Message", L"berserkwarn", "Red")

		self.berserkannounced = true
	end
end

function BigWigsHuhuran:UNIT_HEALTH(arg1)
	if not self.db.profile.berserk then return end
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if (health > 30 and health <= 33) then
			self:TriggerEvent("BigWigs_Message", L"berserksoonwarn", "Red")
			self.berserkannounced = true
		elseif (health > 40 and self.berserkannounced) then
			self.berserkannounced = false
		end
	end
end

function BigWigsHuhuran:checkSting(arg1)
	if not self.db.profile.wyvern then return end
	if not self.prior and string.find(arg1, L"stingtrigger") then
		self:TriggerEvent("BigWigs_Message", L"stingwarn", "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L"bartext", 25, 2, "Interface\\Icons\\INV_Spear_02", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("BigWigs_Message", 22, L"stingdelaywarn", "Orange")
		self.prior = true
	end
end

function BigWigsHuhuran:BigWigs_Message(text)
	if text == L"stingdelaywarn" then self.prior = nil end
end