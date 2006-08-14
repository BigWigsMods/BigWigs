------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ragnaros")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "^TASTE",
	trigger2 = "^COME FORTH,",
	trigger3 = "^NOW FOR YOU,",

	warn1 = "AoE Knockback!",
	warn2 = "5 seconds until AoE Knockback!",
	warn3 = "Ragnaros Down for 90 Seconds. Incoming Sons of Flame!",
	warn4 = "15 seconds until Ragnaros emerges!",
	warn5 = "Ragnaros has emerged. 3 minutes until submerge!",
	warn6 = "60 seconds until Ragnaros submerge & Sons of Flame!",
	warn7 = "20 seconds until Ragnaros submerge & Sons of Flame!",

	bar1text = "AoE knockback",
	bar2text = "Ragnaros emerge",
	bar3text = "Ragnaros submerge",

	sonofflame = "Son of Flame",
	sonsdeadwarn = "%d/8 Sons of Flame dead!",

	cmd = "Ragnaros",

	emerge_cmd = "emerge",
	emerge_name = "Emerge alert",
	emerge_desc = "Warn for Ragnaros Emerge",

	sondeath_cmd = "sondeath",
	sondeath_name = "Son of Flame dies",
	sondeath_desc = "Warn when a son dies",

	submerge_cmd = "submerge",
	submerge_name = "Submerge alert",
	submerge_desc = "Warn for Ragnaros Submerge & Sons of Flame",

	aoeknock_cmd = "aoeknock",
	aoeknock_name = "AoE knockback alert",
	aoeknock_desc = "Warn for AoE KnockBack",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^尝尝萨弗隆的火焰吧",
	trigger2 = "^出现吧，我的奴仆",
	trigger3 = "^现在轮到你们了",

	warn1 = "群体击退！",
	warn2 = "5秒后发动群体击退！",
	warn3 = "拉格纳罗斯消失90秒。烈焰之子出现！",
	warn4 = "15秒后拉格纳罗斯重新出现！",
	warn5 = "拉格纳罗斯已经激活，将在3分钟后暂时消失并召唤烈焰之子！",
	warn6 = "60秒后拉格纳罗斯将暂时消失并召唤烈焰之子！",
	warn7 = "20秒后拉格纳罗斯将暂时消失并召唤烈焰之子！",

	bar1text = "群体击退",
	bar2text = "拉格纳罗斯出现",
	bar3text = "拉格纳罗斯消失",

	sonofflame = "烈焰之子",
	sonsdeadwarn = "%d/8个烈焰之子死亡了！",

	emerge_name = "出现警报",
	emerge_desc = "出现警报",

	sondeath_name = "烈焰之子死亡",
	sondeath_desc = "当一个烈焰之子死亡时发出警报",

	submerge_name = "消失警报",
	submerge_desc = "消失警报",

	aoeknock_name = "群体击退警报",
	aoeknock_desc = "群体击退警报",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "설퍼론의 유황",
	trigger2 = "나의 종들아",
	trigger3 = "이제 너희",

	warn1 = "광역 튕겨냄!",
	warn2 = "5초후 광역 튕겨냄!",
	warn3 = "90초간 라그나로스 사라짐. 피조물 등장!",
	warn4 = "15초후 라고나로스 재등장!",
	warn5 = "라그나로스가 등장했습니다. 3분후 피조물 등장!",
	warn6 = "60초후 피조물 등장 & 라그나로스 사라짐!",
	warn7 = "20초후 피조물 등장 & 라그라로스 사라짐!",

	bar1text = "광역 튕겨냄",
	bar2text = "라그나로스 등장",
	bar3text = "피조물 등장",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^SP\195\156RT DIE FLAMMEN",
	trigger2 = "^VORW\195\134RTS,", -- ? "^KOMMT HERBEI, MEINE DIENER"
	trigger3 = "^UND JETZT ZU EUCH,", -- ? "^NUN ZU EUCH, INSEKTEN"

	warn1 = "AoE Rundumschlag!",
	warn2 = "5 Sekunden bis AoE Rundumschlag!",
	warn3 = "Ragnaros f\105\188r 90 Sekunden untergetaucht. S\195\162hne der Flamme kommen!",
	warn4 = "15 Sekunden bis Ragnaros auftaucht!",
	warn5 = "Ragnaros ist aufgetaucht. 3 Minuten bis zum Untertauchen!",
	warn6 = "60 Sekunden bis Ragnaros untertaucht & S\195\162hne der Flamme!",
	warn7 = "20 Sekunden bis Ragnaros untertaucht & S\195\162hne der Flamme!",

	bar1text = "AoE Rundumschlag",
	bar2text = "Auftauchen Ragnaros",
	bar3text = "Untertauchen Ragnaros",

	sonofflame = "Sohn der Flamme",
	sonsdeadwarn = "%d/8 S\195\162hne der Flamme tot!",

	cmd = "Ragnaros",
	
	emerge_cmd = "emerge",
	emerge_name = "Auftauchen",
	emerge_desc = "Warnung, wenn Ragnaros auftaucht.",
	
	sondeath_cmd = "sondeath",
	sondeath_name = "S\195\162hne der Flamme",
	sondeath_desc = "Warnung, wenn ein Sohn der Flamme stirbt.",
	
	submerge_cmd = "submerge",
	submerge_name = "Untertauchen",
	submerge_desc = "Warnung, wenn Ragnaros untertaucht und die S\195\162hne der Flamme erscheinen.",
	
	aoeknock_cmd = "aoeknock",
	aoeknock_name = "AoE Rundumschlag",
	aoeknock_desc = "Warnung, wenn Ragnaros AoE Rundumschlag wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^GO\195\155TEZ ",
	trigger2 = "^VENEZ, MES SERVITEURS",
	trigger3 = "^ET MAINTENANT",

	warn1 = "AoE Knockback!",
	warn2 = "5 sec avant AoE Knockback!",
	warn3 = "Ragnaros dispara\195\174t pour 90 sec. Arriv\195\169e des Fils des flammes!",
	warn4 = "15 sec avant que Ragnaros n'\195\169merge!",
	warn5 = "Ragnaros a emerger. 3 min avant l'arriv\195\169e des Fils des flammes!",
	warn6 = "60 sec avant l'arriv\195\169e des Fils des flammes!!",
	warn7 = "20 sec avant l'arriv\195\169e des Fils des flammes!!",

	bar1text = "AoE knockback",
	bar2text = "Ragnaros emerge",
	bar3text = "Ragnaros submerge",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRagnaros = BigWigs:NewModule(boss)
BigWigsRagnaros.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
BigWigsRagnaros.enabletrigger = boss
BigWigsRagnaros.toggleoptions = {"sondeath", "submerge", "emerge", "aoeknock", "bosskill"}
BigWigsRagnaros.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRagnaros:OnEnable()
	self.sonsdead = 0

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RagnarosSonDead", .1)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRagnaros:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, L"sonofflame") then
		self:TriggerEvent("BigWigs_SendSync", "RagnarosSonDead "..tostring(self.sonsdead + 1) )
	else
		self:GenericBossDeath(msg)
	end
end

function BigWigsRagnaros:BigWigs_RecvSync(sync, rest)
	if sync ~= "RagnarosSonDead" then return end
	if not rest then return end
	rest = tonumber(rest)

	if rest == (self.sonsdead + 1) then
		self.sonsdead = self.sonsdead + 1
		if self.db.profile.sondeath then
			self:TriggerEvent("BigWigs_Message", string.format(L"sonsdeadwarn", self.sonsdead), "Orange")
		end

		if self.sonsdead == 8 then
			self:CancelScheduledEvent("bwragnarosemerge")
			self:TriggerEvent("BigWigs_StopBar", L"bar2text")
			self.sonsdead = 0 -- reset counter
			self:Emerge()
		end
	end
end

function BigWigsRagnaros:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L"trigger1") and self.db.profile.aoeknock) then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Red")
		self:ScheduleEvent("BigWigs_Message", 23, L"warn2", "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 28, "Interface\\Icons\\Spell_Fire_SoulBurn", "Yellow", "Orange", "Red")
	elseif (string.find(msg, L"trigger2") and self.db.profile.submerge) then
		self:TriggerEvent("BigWigs_Message", L"warn3", "Red")
		self:ScheduleEvent("BigWigs_Message", 75, L"warn4", "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar2text", 90, "Interface\\Icons\\Spell_Fire_Volcano", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwragnarosemerge", self.Emerge, 90, self)
	elseif (string.find(msg, L"trigger3") and self.db.profile.emerge) then
		self:Emerge()
	end
	self:ScheduleEvent("BigWigsRagnarosReset", "BigWigs_RebootModule", 95, self)
end

function BigWigsRagnaros:Emerge()
	self:TriggerEvent("BigWigs_Message", L"warn5", "Yellow")
	self:ScheduleEvent("BigWigs_Message", 120, L"warn6", "Orange")
	self:ScheduleEvent("BigWigs_Message", 160, L"warn7", "Red")
	self:TriggerEvent("BigWigs_StartBar", self, L"bar3text", 180, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Green", "Yellow", "Orange", "Red")
	self:ScheduleEvent("BigWigsRagnarosReset", "BigWigs_RebootModule", 95, self)
end

function BigWigsRagnaros:Event(msg)
	if (string.find(msg, boss)) then
		if (not self:IsEventScheduled("BigWigsRagnarosReset")) then
			self:ScheduleEvent("BigWigsRagnarosReset", "BigWigs_RebootModule", 95, self)
			self:Emerge()
		else
			self:ScheduleEvent("BigWigsRagnarosReset", "BigWigs_RebootModule", 95, self)
		end
	end
end
