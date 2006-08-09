------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Lord Kazzak")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local supremetime = 180

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "kazzak",
	
	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode",
	
	starttrigger = "For the Legion! For Kil'Jaeden!",
		
	engagewarn	 = "Lord Kazzak engaged, 3mins until Supreme!",
		
	supreme1min	 = "Supreme mode in 1 minute!",
	supreme30sec = "Supreme mode in 30 seconds!",
	supreme10sec = "Supreme mode in 10 seconds!",
		
	bartext = "Supreme mode",	
} end )

L:RegisterTranslations("zhCN", function() return {
	supreme_name = "无敌警报",
	supreme_desc = "无敌警报",
	
	starttrigger = "为了燃烧军团！为了基尔加丹！",
		
	engagewarn	 = "卡扎克已激活 - 3分钟后无敌！",
		
	supreme1min	 = "1分钟后无敌！",
	supreme30sec = "30秒后无敌！",
	supreme10sec = "10秒后无敌！",
		
	bartext = "无敌模式",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKazzak = BigWigs:NewModule(boss)
BigWigsKazzak.zonename = { AceLibrary("AceLocale-2.0"):new("BigWigs")("Outdoor Raid Bosses Zone"), AceLibrary("Babble-Zone-2.0")("Blasted Lands") }
BigWigsKazzak.enabletrigger = boss
BigWigsKazzak.toggleoptions = {"supreme", "bosskill"}
BigWigsKazzak.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKazzak:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsKazzak:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.supreme and msg == L"starttrigger" then 
		self:TriggerEvent("BigWigs_Message", L"engagewarn", "Red")
		self:ScheduleEvent("BigWigs_Message", supremetime - 60, L"supreme1min", "Yellow")
		self:ScheduleEvent("BigWigs_Message", supremetime - 30, L"supreme1min", "Orange")
		self:ScheduleEvent("BigWigs_Message", supremetime - 10, L"supreme1min", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bartext", supremetime, 1, "Interface\\Icons\\Spell_Shadow_ShadowWordPain", "Green", "Yellow", "Orange", "Red")
	end
end

