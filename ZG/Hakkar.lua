------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Hakkar")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	-- Chat message triggers
	trigger1 = "FACE THE WRATH OF THE SOULFLAYER!",
	trigger2 = "^Hakkar suffers (.+) from (.+) Blood Siphon",
	flee = "Fleeing will do you no good mortals!",

	-- Warnings and bar texts
	start = "Hakkar engaged - 90 seconds until drain - 10 minutes until enrage",
	warn1 = "60 seconds until drain",
	warn2 = "45 seconds until drain",
	warn3 = "15 seconds until drain",
	warn4 = "Life Drain - 90 seconds until next",
	["Enrage"] = true,
	["Life Drain"] = true,
	
	cmd = "hakkar",
	drain_cmd = "drain",
	drain_name = "Drain Alerts",
	drain_desc = "Warn for Drains",
	
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alerts",
	enrage_desc = "Warn for Enrage",
	
} end)


L:RegisterTranslations("koKR", function() return {
	["Hakkar dies."] = "학카르|1이;가; 죽었습니다.",

	trigger1 = "자만심은 세상의 종말을 불러올 뿐이다. 오너라! 건방진 피조물들이여! 와서 신의 진노에 맞서 보아라!",
	trigger2 = "학카르|1이;가; (.+)의 피의 착취에 의해 (.+)의 자연 피해를 입었습니다.",

	start = "학카르 시작 - 90초후 생명력 흡수 - 10분후 격노",
	warn1 = "생명력 흡수 60초전",
	warn2 = "생명력 흡수 45초전",
	warn3 = "생명력 흡수 15초전",
	warn4 = "생명력 흡수 - 다음 시전은 90초후",
	bosskill = "학카르를 물리쳤습니다!",

	["Enrage"] = "격노",
	["Life Drain"] = "생명력 흡수",
} end)


L:RegisterTranslations("zhCN", function() return {
	["Hakkar dies."] = "哈卡死亡了。",

	trigger1 = "^骄傲会将你送上绝路",
	trigger2 = "^(.+)的酸性血液虹吸使哈卡受到了(%d+)点自然伤害。",
	flee = "逃跑",

	start = "哈卡已经激活 - 90秒后开始生命吸取 - 10分钟后进入激怒状态",
	warn1 = "60秒后开始生命吸取",
	warn2 = "45秒后开始生命吸取",
	warn3 = "15秒后开始生命吸取",
	warn4 = "血液虹吸 - 90秒后再次发动",
	bosskill = "哈卡被击败了！",

	["Enrage"] = "激怒",
	["Life Drain"] = "生命吸取",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHakkar = BigWigs:NewModule(boss)
BigWigsHakkar.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsHakkar.enabletrigger = boss
BigWigsHakkar.bossname = boss
BigWigsHakkar.toggleoptions = {"drain", "enrage", "bosskill"}
BigWigsHakkar.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHakkar:OnEnable()
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsHakkar:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L"trigger1") then
		self:TriggerEvent("BigWigs_Message", L"start", "Green")
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_StartBar", self, L"Enrage", 600, 1, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Purple") end
		self:BeginTimers(true)
	elseif string.find(msg, L"flee") then
		self:TriggerEvent("BigWigs_RebootModule", self)
	end
end


function BigWigsHakkar:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.prior and string.find(msg, L"trigger2") then
		self.prior = true
		self:BeginTimers()
	end
end


function BigWigsHakkar:BigWigs_Message(text)
	if text == L"warn1" then self.prior = nil end
end


function BigWigsHakkar:BeginTimers(first)
	if self.db.profile.drain then
		if not first then self:TriggerEvent("BigWigs_Message", L"warn4", "Green") end
		self:ScheduleEvent("BigWigs_Message", 30, L"warn1", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 45, L"warn2", "Orange")
		self:ScheduleEvent("BigWigs_Message", 75, L"warn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"Life Drain", 90, 2, "Interface\\Icons\\Spell_Shadow_LifeDrain", "Green", "Yellow", "Orange", "Red")
	end
end
