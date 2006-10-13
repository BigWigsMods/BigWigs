------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ragnaros")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)
local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	knockback_trigger = "^TASTE",
	submerge_trigger = "^COME FORTH,",
	engage_trigger = "^NOW FOR YOU,",

	knockback_message = "Knockback!",
	knockback_soon_message = "5 sec to knockback!",
	submerge_message = "Ragnaros down for 90 sec. Incoming Sons of Flame!",
	emerge_soon_message = "15 sec until Ragnaros emerges!",
	emerge_message = "Ragnaros emerged, 3 minutes until submerge!",
	submerge_60sec_message = "60 sec to submerge!",
	submerge_20sec_message = "20 sec to submerge!",

	knockback_bar = "AoE knockback",
	emerge_bar = "Ragnaros emerge",
	submerge_bar = "Ragnaros submerge",

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
	aoeknock_name = "Knockback alert",
	aoeknock_desc = "Warn for Wrath of Ragnaros knockback",
} end)

L:RegisterTranslations("zhCN", function() return {
	knockback_trigger = "^尝尝萨弗隆的火焰吧",
	submerge_trigger = "^出现吧，我的奴仆",
	engage_trigger = "^现在轮到你们了",

	knockback_message = "群体击退！",
	knockback_soon_message = "5秒后发动群体击退！",
	submerge_message = "拉格纳罗斯消失90秒。烈焰之子出现！",
	emerge_soon_message = "15秒后拉格纳罗斯重新出现！",
	emerge_message = "拉格纳罗斯已经激活，将在3分钟后暂时消失并召唤烈焰之子！",
	submerge_60sec_message = "60秒后拉格纳罗斯将暂时消失并召唤烈焰之子！",
	submerge_20sec_message = "20秒后拉格纳罗斯将暂时消失并召唤烈焰之子！",

	knockback_bar = "群体击退",
	emerge_bar = "拉格纳罗斯出现",
	submerge_bar = "拉格纳罗斯消失",

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
	knockback_trigger = "설퍼론의 유황",
	submerge_trigger = "나의 종들아",
	engage_trigger = "이제 너희",

	knockback_message = "광역 튕겨냄!",
	knockback_soon_message = "5초후 광역 튕겨냄!",
	submerge_message = "90초간 라그나로스 사라짐. 피조물 등장!",
	emerge_soon_message = "15초후 라그나로스 재등장!",
	emerge_message = "라그나로스가 등장했습니다. 3분후 피조물 등장!",
	submerge_60sec_message = "60초후 피조물 등장 & 라그나로스 사라짐!",
	submerge_20sec_message = "20초후 피조물 등장 & 라그라로스 사라짐!",

	knockback_bar = "광역 튕겨냄",
	emerge_bar = "라그나로스 등장",
	submerge_bar = "피조물 등장",

	sonofflame = "화염의 수호물",
	sonsdeadwarn = "%d/8 화염의 수호물 사망!",

	emerge_name = "등장 경고",
	emerge_desc = "라그나로스 등장에 대한 경고",

	sondeath_name = "화염의 수호물 죽음",
	sondeath_desc = "화염의 수호물 죽음 알림",
	
	submerge_name = "사라짐 경고",
	submerge_desc = "라그나로스 사라짐 & 피조물에 대한 경고",
	
	aoeknock_name = "광역 넉백 경고",
	aoeknock_desc = "광역 넉백에 대한 경고",
} end)

L:RegisterTranslations("deDE", function() return {
	knockback_trigger = "^SP\195\156RT DIE FLAMMEN",
	submerge_trigger = "^KOMMT HERBEI, MEINE DIENER", -- ?
	engage_trigger = "^NUN ZU EUCH, INSEKTEN", -- ?

	knockback_message = "AoE Rundumschlag!",
	knockback_soon_message = "AoE Rundumschlag in 5 Sekunden!",
	submerge_message = "Ragnaros untergetaucht f\195\188r 90 Sekunden! S\195\182hne der Flamme kommen!",
	emerge_soon_message = "Ragnaros taucht auf in 15 Sekunden!",
	emerge_message = "Ragnaros aufgetaucht! Untertauchen in 3 Minuten!",
	submerge_60sec_message = "Ragnaros taucht unter in 60 Sekunden!",
	submerge_20sec_message = "Ragnaros taucht unter in 20 Sekunden!",

	knockback_bar = "AoE Rundumschlag",
	emerge_bar = "Auftauchen Ragnaros",
	submerge_bar = "Untertauchen Ragnaros",

	sonofflame = "Sohn der Flamme",
	sonsdeadwarn = "%d/8 S\195\182hne der Flamme tot!",

	emerge_name = "Auftauchen",
	emerge_desc = "Warnung, wenn Ragnaros auftaucht.",

	sondeath_name = "S\195\182hne der Flamme",
	sondeath_desc = "Counter f\195\188r die get\195\182teten S\195\182ohne der Flamme.",

	submerge_name = "Untertauchen",
	submerge_desc = "Warnung, wenn Ragnaros untertaucht und die S\195\182hne der Flamme erscheinen.",

	aoeknock_name = "AoE Rundumschlag",
	aoeknock_desc = "Warnung, wenn Ragnaros AoE Rundumschlag wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	knockback_trigger = "^GO\195\155TEZ ",
	submerge_trigger = "^VENEZ, MES SERVITEURS",
	engage_trigger = "^ET MAINTENANT",

	knockback_message = "AoE Knockback !",
	knockback_soon_message = "5 sec avant AoE Knockback !",
	submerge_message = "Ragnaros dispara\195\174t pour 90 sec. Arriv\195\169e des Fils des flammes !",
	emerge_soon_message = "15 sec avant que Ragnaros n'\195\169merge !",
	emerge_message = "Ragnaros a emerger. 3 min avant l'arriv\195\169e des Fils des flammes !",
	submerge_60sec_message = "60 sec avant l'arriv\195\169e des Fils des flammes !",
	submerge_20sec_message = "20 sec avant l'arriv\195\169e des Fils des flammes !",

	knockback_bar = "AoE knockback",
	emerge_bar = "Ragnaros emerge",
	submerge_bar = "Ragnaros submerge",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRagnaros = BigWigs:NewModule(boss)
BigWigsRagnaros.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
BigWigsRagnaros.enabletrigger = boss
BigWigsRagnaros.wipemobs = { L["sonofflame"] }
BigWigsRagnaros.toggleoptions = { "sondeath", "submerge", "emerge", "aoeknock", "bosskill" }
BigWigsRagnaros.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRagnaros:OnEnable()
	started = nil
	self.sonsdead = 0

	self:RegisterEvent("PLAYER_COMBAT_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_COMBAT_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RagnarosSonDead", .1)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRagnaros:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, L["sonofflame"]) then
		self:TriggerEvent("BigWigs_SendSync", "RagnarosSonDead "..tostring(self.sonsdead + 1) )
	else
		self:GenericBossDeath(msg)
	end
end

function BigWigsRagnaros:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_ENABLED") then
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end
		self:Emerge()
	elseif sync == "RagnarosSonDead" and rest then
		rest = tonumber(rest)
		if not rest then return end
		if rest == (self.sonsdead + 1) then
			self.sonsdead = self.sonsdead + 1
			if self.db.profile.sondeath then
				self:TriggerEvent("BigWigs_Message", string.format(L["sonsdeadwarn"], self.sonsdead), "Urgent")
			end
			if self.sonsdead == 8 then
				self:CancelScheduledEvent("bwragnarosemerge")
				self:TriggerEvent("BigWigs_StopBar", L["emerge_bar"])
				self.sonsdead = 0 -- reset counter
				self:Emerge()
			end
		end
	end
end

function BigWigsRagnaros:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["knockback_trigger"]) and self.db.profile.aoeknock then
		self:TriggerEvent("BigWigs_Message", L["knockback_message"], "Important")
		self:ScheduleEvent("bwragnarosaekbwarn", "BigWigs_Message", 23, L["knockback_soon_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["knockback_bar"], 28, "Interface\\Icons\\Spell_Fire_SoulBurn")
	elseif string.find(msg, L["submerge_trigger"]) then
		self:Submerge()
	end
end

function BigWigsRagnaros:Submerge()
	self:CancelScheduledEvent("bwragnarosaekbwarn")
	self:TriggerEvent("BigWigs_StopBar", self, L["knockback_bar"])

	if self.db.profile.submerge then
		self:TriggerEvent("BigWigs_Message", L["submerge_message"], "Important")
	end
	if self.db.profile.emerge then
		self:ScheduleEvent("bwragnarosemergewarn", "BigWigs_Message", 75, L["emerge_soon_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["emerge_bar"], 90, "Interface\\Icons\\Spell_Fire_Volcano")
	end
	self:ScheduleEvent("bwragnarosemerge", self.Emerge, 90, self)
end

function BigWigsRagnaros:Emerge()
	self:CancelScheduledEvent("bwragnarosemergewarn")
	self:TriggerEvent("BigWigs_StopBar", self, L["emerge_bar"])

	if self.db.profile.emerge then
		self:TriggerEvent("BigWigs_Message", L["emerge_message"], "Attention")
	end
	if self.db.profile.submerge then
		self:ScheduleEvent("BigWigs_Message", 120, L["submerge_60sec_message"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", 160, L["submerge_20sec_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["submerge_bar"], 180, "Interface\\Icons\\Spell_Fire_SelfDestruct")
	end
end

