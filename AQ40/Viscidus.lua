------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Viscidus")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)
local prior

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Viscidus",
	volley_cmd = "volley",
	volley_name = "Poison Volley Alert",
	volley_desc = "Warn for Poison Volley",

	toxinyou_cmd = "toxinyou",
	toxinyou_name = "Toxin Cloud on You Alert",
	toxinyou_desc = "Warn if you are standing in a toxin cloud",

	toxinother_cmd = "toxinother",
	toxinother_name = "Toxin Cloud on Others Alert",
	toxinother_desc = "Warn if others are standing in a toxin cloud",

	freeze_cmd = "freeze",
	freeze_name = "Freezing States Alert",
	freeze_desc = "Warn for the different frozen states",

	trigger1 	= "begins to slow!",
	trigger2 	= "is freezing up!",
	trigger3 	= "is frozen solid!",
	trigger4 	= "begins to crack!",
	trigger5 	= "looks ready to shatter!",
	trigger6	= "afflicted by Poison Bolt Volley",
	trigger7 	= "^([^%s]+) ([^%s]+) afflicted by Toxin%.$",

	you 		= "You",
	are 		= "are",

	warn1 		= "First freeze phase!",
	warn2 		= "Second freeze phase - GET READY",
	warn3 		= "Third freeze phase - DPS DPS DPS",
	warn4 		= "Cracking up - little more now!",
	warn5 		= "Cracking up - almost there!",
	warn6		= "Poison Bolt Volley!",
	warn7		= "Incoming Poison Bolt Volley in 3~ sec!",
	warn8		= " is in a toxin cloud!",
	warn9		= "You are in the toxin cloud!",

	bar1text	= "Poison Bolt Volley",
} end )

L:RegisterTranslations("zhCN", function() return {
	volley_name = "毒性之箭警报",
	volley_desc = "毒性之箭警报",

	toxinyou_name = "玩家毒云警报",
	toxinyou_desc = "你站在毒云中时发出警报",

	toxinother_name = "队友毒云警报",
	toxinother_desc = "队友站在毒云中时发出警报",

	freeze_name = "冻结状态警报",
	freeze_desc = "冻结状态警报",
	
	trigger1 	= "的速度慢下来了！",
	trigger2 	= "冻结了！",
	trigger3 	= "变成了坚硬的固体！",
	trigger4 	= "开始碎裂了！",
	trigger5 	= "马上就要碎裂的样子！",
	trigger6	= "受到了毒性之箭效果",
	trigger7 	= "^(.+)受(.+)了剧毒效果的影响。$",

	you 		= "你",
	are 		= "到",

	warn1 		= "冻结第一阶段！",
	warn2 		= "冻结第二阶段 - 做好准备",
	warn3 		= "冻结第三阶段 - DPS DPS DPS",
	warn4 		= "即将碎裂 - 加大火力！",
	warn5 		= "即将碎裂 - 几近成功！",
	warn6		= "毒性之箭 - 迅速解毒！",
	warn7		= "3秒后发动毒性之箭！",
	warn8		= "在毒云中 - 快跑开！",
	warn9		= "你在毒云中 - 快跑开！",

	bar1text	= "毒性之箭",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 	= "begins to slow!",
	trigger2 	= "is freezing up!",
	trigger3 	= "is frozen solid!",
	trigger4 	= "begins to crack!",
	trigger5 	= "looks ready to shatter!",
	trigger6	= "afflicted by Poison Bolt Volley",
	trigger7 	= "(.*)독소에 걸렸습니다.",

	you 		= "",
	are 		= "are",
	whopattern = "(.+)|1이;가; ",

	warn1 		= "First freeze phase!",
	warn2 		= "Second freeze phase - GET READY",
	warn3 		= "Third freeze phase - DPS DPS DPS",
	warn4 		= "Cracking up - little more now!",
	warn5 		= "Cracking up - almost there!",
	warn6		= "Poison Bolt Volley - Cleanse Poison!",
	warn7		= "Incoming Poison Bolt Volley in 3~ sec!",
	warn8		= "님이 독소에 걸렸습니다 - 대피!",

	bar1text	= "Poison Bolt Volley",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsViscidus = BigWigs:NewModule(boss)
BigWigsViscidus.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsViscidus.enabletrigger = boss
BigWigsViscidus.toggleoptions = {"freeze", "volley", "toxinyou", "toxinother", "bosskill"}
BigWigsViscidus.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsViscidus:OnEnable()
	prior = nil
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

if (GetLocale() == "koKR") then
	function BigWigsViscidus:CheckVis(arg1)
		if self.db.profile.volley and not prior and string.find(arg1, L"trigger6") then
			self:TriggerEvent("BigWigs_Message", L"warn6", "Orange")
			self:ScheduleEvent("BigWigs_Message", 7, L"warn7", "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 10, 1, "Interface\\Icons\\Spell_Nature_CorrosiveBreath", "Yellow", "Orange", "Red")
			prior = true
		elseif self.db.profile.toxinother and string.find(arg1, L"trigger7") then
			local _,_, pl = string.find(arg1, L"trigger7")
			if pl then
				if pl == L"you" then
					pl = UnitName("player")
				end
				self:TriggerEvent("BigWigs_Message", pl .. L"warn8", "Red")
			end
		end
	end
else
	function BigWigsViscidus:CheckVis(arg1)
		if self.db.profile.volley and not prior and string.find(arg1, L"trigger6") then
			self:TriggerEvent("BigWigs_Message", L"warn6", "Orange")
			self:ScheduleEvent("BigWigs_Message", 7, L"warn7", "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 10, 1, "Interface\\Icons\\Spell_Nature_CorrosiveBreath", "Yellow", "Orange", "Red")
			prior = true
		elseif string.find(arg1, L"trigger7") then
			local _,_, pl, ty = string.find(arg1, L"trigger7")
			if (pl and ty) then
				if self.db.profile.toxinyou and pl == L"you" and ty == L"are" then
					self:TriggerEvent("BigWigs_Message", L"warn9", "Red", true)
				elseif self.db.profile.toxinother then
					self:TriggerEvent("BigWigs_Message", pl .. L"warn8", "Red")
					self:TriggerEvent("BigWigs_SendTell", pl, L"warn9")
				end
			end
		end
	end
end

function BigWigsViscidus:CHAT_MSG_MONSTER_EMOTE(arg1)
	if not self.db.profile.freeze then return end
	if arg1 == L"trigger1" then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Yellow")
	elseif arg1 == L"trigger2" then
		self:TriggerEvent("BigWigs_Message", L"warn2", "Orange")
	elseif arg1 == L"trigger3" then
		self:TriggerEvent("BigWigs_Message", L"warn3", "Red")
	elseif arg1 == L"trigger4" then
		self:TriggerEvent("BigWigs_Message", L"warn4", "Orange")
	elseif arg1 == L"trigger5" then
		self:TriggerEvent("BigWigs_Message", L"warn5", "Red")
	end
end

function BigWigsViscidus:BigWigs_Message(text)
	if text == L"warn7" then prior = nil end
end
