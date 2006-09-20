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
	engage_trigger = "FACE THE WRATH OF THE SOULFLAYER!",
	drain_trigger = "^Hakkar suffers (.+) from (.+) Blood Siphon",
	mindcontrol_trigger = "(.*) (.*) afflicted by Cause Insanity",

	you = "You",
	are = "are",

	flee = "Fleeing will do you no good mortals!",

	-- Warnings and bar texts
	start_message = "Hakkar engaged - 90 seconds until drain - 10 minutes until enrage",
	drain_warning_60 = "60 seconds until drain",
	drain_warning_45 = "45 seconds until drain",
	drain_warning_30 = "30 seconds until drain",
	drain_warning_15 = "15 seconds until drain",
	drain_message = "Life Drain - 90 seconds until next",

	mindcontrol_message = "%s is mindcontrolled!",

	["Enrage"] = true,
	["Life Drain"] = true,

	cmd = "Hakkar",

	drain_cmd = "drain",
	drain_name = "Drain Alerts",
	drain_desc = "Warn for Drains",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alerts",
	enrage_desc = "Warn for Enrage",

	mc_cmd = "mc",
	mc_name = "Mind Control",
	mc_desc = "Alert when someone is mind controlled.",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on the mind controlled person (requires promoted or higher)",

} end)

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^EURE \195\156BERHEBLICHKEIT K\195\156NDET BEREITS VOM ENDE DIESER WELT!", -- ?
	drain_trigger = "Hakkar bekommt 'Bluttrinker'.",

	flee = "Fleeing will do you no good mortals!", -- ?

	start_message = "Hakkar angegriffen - 90 Sekunden bis Lebensentzug - 10 Minuten bis Wutanfall",
	drain_warning_60 = "60 Sekunden bis Lebensentzug",
	drain_warning_45 = "45 Sekunden bis Lebensentzug",
	drain_warning_30 = "30 Sekunden bis Lebensentzug",
	drain_warning_15 = "15 Sekunden bis Lebensentzug",
	drain_message = "Lebensentzug - N\195\164chster in 90 Sekunden",
	["Enrage"] = "Wutanfall",
	["Life Drain"] = "Lebensentzug",

	drain_name = "Lebensentzung",
	drain_desc = "Warnung vor Lebensentzug.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Hakkar w\195\188tend wird.",
} end)

L:RegisterTranslations("koKR", function() return {
	-- Chat message triggers
	engage_trigger = "자만심은 세상의 종말을 불러올 뿐이다. 오너라! 건방진 피조물들이여! 와서 신의 진노에 맞서 보아라!",
	drain_trigger = "학카르|1이;가; (.+)의 피의 착취에 의해 (.+)의 자연 피해를 입었습니다.",
	mindcontrol_trigger = "^([^|;%s]*)(.*)정신 착란에 걸렸습니다%.$", -- "(.*) (.*) afflicted by Cause Insanity", -- CHECK

	you = "",
	are = "",

	flee = "도망쳐 봐야 소용없다, 어리석은 생명체여!", -- by turtl

	-- Warnings and bar texts
	start_message = "학카르 시작 - 90초후 생명력 흡수 - 10분후 격노",
	drain_warning_60 = "생명력 흡수 60초전",
	drain_warning_45 = "생명력 흡수 45초전",
	drain_warning_30 = "생명력 흡수 30초전",
	drain_warning_15 = "생명력 흡수 15초전",
	drain_message = "생명력 흡수 - 다음 시전은 90초후",

	mindcontrol_message = "%s|1이;가; 정신 지배되었습니다!",

	["Enrage"] = "격노",
	["Life Drain"] = "생명력 흡수",

	drain_name = "흡수 경고",
	drain_desc = "흡수에 대한 경고",
	
	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	mc_name = "정신 지배",
	mc_desc = "정신 지배 되었을 때 경고",

	icon_name = "아이콘 지정",
	icon_desc = "정신 지배된 사람에게 해골 아이콘 지정 (승급자 이상 필요)",
} end)


L:RegisterTranslations("zhCN", function() return {
	-- Chat message triggers
	engage_trigger = "^骄傲会将你送上绝路",
	drain_trigger = "^(.+)的酸性血液虹吸使哈卡受到了(%d+)点自然伤害。",
	flee = "逃跑",

	-- Warnings and bar texts
	start_message = "哈卡已经激活 - 90秒后开始生命吸取 - 10分钟后进入激怒状态",
	drain_warning_60 = "60秒后发动生命吸取",
	drain_warning_45 = "45秒后发动生命吸取",
	drain_warning_15 = "15秒后发动生命吸取",
	drain_message = "血液虹吸 - 90秒后再次发动",
	["Enrage"] = "激怒",
	["Life Drain"] = "生命吸取",

	drain_name = "生命吸取警报",
	drain_desc = "生命吸取警报",

	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHakkar = BigWigs:NewModule(boss)
BigWigsHakkar.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsHakkar.enabletrigger = boss
BigWigsHakkar.toggleoptions = { "drain", "enrage", -1, "mc", "icon", "bosskill" }
BigWigsHakkar.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHakkar:OnEnable()
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsHakkar:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["engage_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["start_message"], "Green")
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_StartBar", self, L["Enrage"], 600, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Purple") end
		self:BeginTimers(true)
	elseif string.find(msg, L["flee"]) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	end
end

function BigWigsHakkar:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.prior and string.find(msg, L["drain_trigger"]) then
		self.prior = true
		self:BeginTimers()
	end
end

function BigWigsHakkar:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(msg)
	local _,_, mcplayer, mctype = string.find(msg, L["mindcontrol_trigger"])
	if mcplayer then
		if mcplayer == L["you"] then
			mcplayer = UnitName("player")
		end
		if self.db.profile.mc then
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], mcplayer), "Orange")
		end
		if self.db.profile.icon then 
			self:TriggerEvent("BigWigs_SetRaidIcon", mcplayer)
		end
	end
end

function BigWigsHakkar:BigWigs_Message(text)
	if text == L["drain_warning_60"] then self.prior = nil end
end

function BigWigsHakkar:BeginTimers(first)
	if self.db.profile.drain then
		if not first then self:TriggerEvent("BigWigs_Message", L["drain_message"], "Green") end
		self:ScheduleEvent("BigWigs_Message", 30, L["drain_warning_60"], "Green")
		self:ScheduleEvent("BigWigs_Message", 45, L["drain_warning_45"], "Yellow")
		self:ScheduleEvent("BigWigs_Message", 60, L["drain_warning_30"], "Orange")
		self:ScheduleEvent("BigWigs_Message", 75, L["drain_warning_15"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["Life Drain"], 90, "Interface\\Icons\\Spell_Shadow_LifeDrain", "Green", "Yellow", "Orange", "Red")
	end
end

