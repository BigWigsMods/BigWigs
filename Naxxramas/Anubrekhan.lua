------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Anub'Rekhan"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Anubrekhan",

	locust_cmd = "locust",
	locust_name = "Locust Swarm Alert",
	locust_desc = "Warn for Locust Swarm",

	starttrigger1 = "Just a little taste...",
	starttrigger2 = "Yes, run! It makes the blood pump faster!",
	starttrigger3 = "There is no way out.",
	engagewarn = "Anub'Rekhan engaged. First Locust Swarm in ~90 sec",

	gaintrigger = "Anub'Rekhan gains Locust Swarm.",
	gainendwarn = "Locust Swarm ended!",
	gainnextwarn = "Next Locust Swarm in ~85 sec",
	gainwarn10sec = "~10 Seconds until Locust Swarm",
	gainincbar = "Next Locust Swarm",
	gainbar = "Locust Swarm",

	casttrigger = "Anub'Rekhan begins to cast Locust Swarm.",
	castwarn = "Incoming Locust Swarm!",
} end )

L:RegisterTranslations("deDE", function() return {
	locust_name = "Heuschreckenschwarm",
	locust_desc = "Warnung, wenn Anub'Rekhan Heuschreckenschwarm wirkt.",

	starttrigger1 = "Nur einmal kosten...",
	starttrigger2 = "Rennt! Das bringt das Blut in Wallung!",
	starttrigger3 = "Es gibt kein Entkommen.",
	engagewarn = "Anub'Rekhan angegriffen! Heuschreckenschwarm in ~90 Sekunden!",

	gaintrigger = "Anub'Rekhan bekommt 'Heuschreckenschwarm'.",
	gainendwarn = "Heuschreckenschwarm vorbei!",
	gainnextwarn = "N\195\164chster Schwarm in ~85 Sekunden.",
	gainwarn10sec = "Heuschreckenschwarm in ~10 Sekunden",
	gainincbar = "N\195\164chster Schwarm",
	gainbar = "Heuschreckenschwarm",

	casttrigger = "Anub'Rekhan beginnt Heuschreckenschwarm zu wirken.",
	castwarn = "Heuschreckenschwarm!",
} end )

L:RegisterTranslations("koKR", function() return {
	locust_name = "메뚜기 떼 경고",
	locust_desc = "메뚜기 떼에 대한 경고",

	starttrigger1 = "어디 맛 좀 볼까...",
	starttrigger2 = "그래, 도망쳐! 더 신선한 피가 솟구칠 테니!",
	starttrigger3 = "나가는 길은 없다.",
	engagewarn = "아눕레칸 격노. 대략 90초후 첫번째 메뚜기 떼.",

	gaintrigger = "아눕레칸|1이;가; 메뚜기 떼 효과를 얻었습니다.",
	gainendwarn = "메뚜기 떼 종료!",
	gainnextwarn = "다음 메뚜기 떼 대략 85초후.",
	gainwarn10sec = "10초후 메뚜기 떼",
	gainincbar = "다음 메뚜기 떼",
	gainbar = "메뚜기 떼",

	casttrigger = "아눕레칸|1이;가; 메뚜기 떼|1을;를; 시전합니다.",
	castwarn = "메뚜기 떼 소환!",
} end )

L:RegisterTranslations("zhCN", function() return {
	locust_name = "虫群警报",
	locust_desc = "虫群警报",

	starttrigger1 = "一些小点心……",
	starttrigger2 = "对，跑吧！那样伤口出血就更多了！",
	starttrigger3 = "你们逃不掉的。",
	engagewarn = "阿努布雷坎已激活，~90秒后出现第一波虫群",

	gaintrigger = "阿努布雷坎获得了虫群风暴的效果。",
	gainendwarn = "虫群风暴结束了！",
	gainnextwarn = "~85秒后出现下一波虫群。",
	gainwarn10sec = "~10秒后出现下一波虫群。",
	gainincbar = "下一波虫群",
	gainbar = "虫群风暴",

	casttrigger = "阿努布雷坎开始施放虫群风暴。",
	castwarn = "虫群风暴来了！",
} end )

L:RegisterTranslations("zhTW", function() return {
	locust_name = "蝗蟲風暴警告",
	locust_desc = "蝗蟲風暴的警報",

	starttrigger1 = "一些小點心……",
	starttrigger2 = "對，跑吧！那樣傷口出血就更多了！",
	starttrigger3 = "你們逃不掉的。",
	engagewarn = "阿努比瑞克漢已進入戰鬥 - 90 秒後出現第一波蝗蟲風暴！",

	gaintrigger = "阿努比瑞克漢獲得了蝗蟲風暴的效果。",
	gainendwarn = "蝗蟲風暴結束了！",
	gainnextwarn = "85 秒後出現下一波蝗蟲風暴！",
	gainwarn10sec = "10 秒後出現下一波蝗蟲風暴！",
	gainincbar = "下一波蝗蟲風暴",
	gainbar = "蝗蟲風暴",

	casttrigger = "阿努比瑞克漢開始施放蝗蟲風暴。",
	castwarn = "蝗蟲風暴來了！",
} end )

L:RegisterTranslations("frFR", function() return {
	locust_name = "Alerte Nuée de sauterelles",
	locust_desc = "Préviens quand Anub'Rekhan invoque ses Nuées de sauterelles.",

	starttrigger1 = "Rien qu'une petite bouch\195\169e...",
	starttrigger2 = "Oui, courez ! Faites circuler le sang !",
	starttrigger3 = "Nulle part pour s'enfuir.",
	engagewarn = "Anub'Rekhan engagé. Première Nuée de sauterelles dans ~90 sec.",

	gaintrigger = "Anub'Rekhan gagne Nuée de sauterelles.",
	gainendwarn = "Fin de la Nuée de sauterelles !",
	gainnextwarn = "Prochaine Nuée de sauterelles dans ~85 sec.",
	gainwarn10sec = "~10 sec. avant la Nuée de sauterelles",
	gainincbar = "Prochaine Nuée",
	gainbar = "Nuée de sauterelles",

	casttrigger = "Anub'Rekhan commence à lancer Nuée de sauterelles.",
	castwarn = "Nuée de sauterelles imminente !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAnubrekhan = BigWigs:NewModule(boss)
BigWigsAnubrekhan.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsAnubrekhan.enabletrigger = boss
BigWigsAnubrekhan.toggleoptions = {"locust", "bosskill"}
BigWigsAnubrekhan.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAnubrekhan:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "LocustCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "LocustCast")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AnubLocustInc", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "AnubLocustSwarm", 10)
end

function BigWigsAnubrekhan:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.locust and msg:find(L["starttrigger1"]) or msg == L["starttrigger2"] or msg == L["starttrigger3"] then
		self:TriggerEvent("BigWigs_Message", L["engagewarn"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", 80, L["gainwarn10sec"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["gainincbar"], 90, "Interface\\Icons\\Spell_Nature_InsectSwarm")
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L["gaintrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "AnubLocustSwarm")
	end
end

function BigWigsAnubrekhan:LocustCast( msg )
	if msg == L["casttrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "AnubLocustInc")
	end
end

function BigWigsAnubrekhan:BigWigs_RecvSync( sync )
	if sync == "AnubLocustInc" then
		self:ScheduleEvent("bwanublocustinc", self.TriggerEvent, 3.25, self, "BigWigs_SendSync", "AnubLocustSwarm")
		if self.db.profile.locust then
			self:TriggerEvent("BigWigs_Message", L["castwarn"], "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, L["castwarn"], 3, "Interface\\Icons\\Spell_Nature_InsectSwarm" )
		end
	elseif sync == "AnubLocustSwarm" then
		self:CancelScheduledEvent("bwanublocustinc")
		if self.db.profile.locust then
			self:ScheduleEvent("BigWigs_Message", 20, L["gainendwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["gainbar"], 20, "Interface\\Icons\\Spell_Nature_InsectSwarm")
			self:TriggerEvent("BigWigs_Message", L["gainnextwarn"], "Urgent")
			self:ScheduleEvent("BigWigs_Message", 75, L["gainwarn10sec"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["gainincbar"], 85, "Interface\\Icons\\Spell_Nature_InsectSwarm")
		end
	end
end
