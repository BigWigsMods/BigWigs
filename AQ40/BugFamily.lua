------------------------------
--      Are you local?      --
------------------------------

local kri = AceLibrary("Babble-Boss-2.2")["Lord Kri"]
local yauj = AceLibrary("Babble-Boss-2.2")["Princess Yauj"]
local vem = AceLibrary("Babble-Boss-2.2")["Vem"]
local boss = AceLibrary("Babble-Boss-2.2")["The Bug Family"]

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local deaths = 0
local fearstatus

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "BugFamily",
	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for Fear",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for Heal",

	healtrigger = "Princess Yauj begins to cast Great Heal.",
	healwarn = "Casting heal!",

	feartrigger = "is afflicted by Fear%.",
	fearbar = "AoE Fear",
	fearwarn1 = "AoE Fear! Next in 20 Seconds!",
	fearwarn2 = "AoE Fear in 5 Seconds!",
} end )

L:RegisterTranslations("frFR", function() return {
	fear_name = "Alerte Peur",
	fear_desc = "Pr\195\169viens des Peurs de zone.",

	heal_name = "Alerte Soins",
	heal_desc = "Pr\195\169viens lors de l'incantation de soins.",

	healtrigger = "Princesse Yauj commence \195\160 lancer Soins exceptionnels.",
	healwarn = "Princesse Yauj commence \195\160 se soigner - Interrompez-la !",

	feartrigger = "subit les effets de Peur%.",
	fearbar = "Peur de zone",
	fearwarn1 = "Peur de zone ! prochain dans 20 secondes",
	fearwarn2 = "Peur de zone dans 5 secondes !",
} end )

L:RegisterTranslations("deDE", function() return {
	fear_name = "Furcht",
	fear_desc = "Warnung, wenn wenn Prinzessin Yauj AoE Furcht wirkt.",

	heal_name = "Heilung",
	heal_desc = "Warnung, wenn Prinzessin Yauj versucht sich zu heilen.",

	healtrigger = "Prinzessin Yauj beginnt Gro\195\159es Heilen zu wirken.",
	healwarn = "Prinzessin Yauj versucht sich zu heilen!",

	feartrigger = "ist von Furcht betroffen.",
	fearbar = "AoE Furcht",
	fearwarn1 = "AoE Furcht! N\195\164chste in 20 Sekunden!",
	fearwarn2 = "AoE Furcht in 5 Sekunden!",
} end )

L:RegisterTranslations("zhCN", function() return {
	fear_name = "恐惧警报",
	fear_desc = "敌人发动群体恐惧时发出警报",

	heal_name = "治疗警报",
	heal_desc = "亚尔基公主施放治疗时发出警报",

	healtrigger = "亚尔基公主开始施放强效治疗术。",
	healwarn = "亚尔基公主正在施放治疗 - 迅速打断！",

	feartrigger = "受到了恐惧效果的影响。",
	fearbar = "群体恐惧",
	fearwarn1 = "群体恐惧 - 20秒后再次发动",
	fearwarn2 = "5秒后发动群体恐惧！",
} end )

L:RegisterTranslations("zhTW", function() return {
	fear_name = "恐懼警報",
	fear_desc = "敵人發動群體恐懼時發出警報",

	heal_name = "治療警報",
	heal_desc = "亞爾基公主施放治療時發出警報",

	healtrigger = "亞爾基公主開始施放強效治療術。",
	healwarn = "正在施放治療！ 打斷！",

	feartrigger = "受到恐懼術的傷害",
	fearbar = "群體恐懼",
	fearwarn1 = "群體恐懼 - 20 秒後再次發動",
	fearwarn2 = "5 秒後群體恐懼！",
} end )

L:RegisterTranslations("koKR", function() return {
	fear_name = "공포 경고",
	fear_desc = "공포에 대한 경고",

	heal_name = "치유 경고",
	heal_desc = "치유에 대한 경고",

	healtrigger = "공주 야우즈|1이;가; 상급 치유|1을;를; 시전합니다.",
	healwarn = "치유 시전 - 시전 방해!",

	feartrigger = "공포에 걸렸습니다.",
	fearbar = "공포",
	fearwarn1 = "공포 시전! 다음 시전 20초후!",
	fearwarn2 = "5초후 공포!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBugFamily = BigWigs:NewModule(boss)
BigWigsBugFamily.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsBugFamily.enabletrigger = {kri, yauj, vem}
BigWigsBugFamily.toggleoptions = {"fear", "heal", "bosskill"}
BigWigsBugFamily.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBugFamily:OnEnable()
	deaths = 0
	fearstatus = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "FearEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "FearEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "FearEvent")
	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBugFamily:FearEvent(msg)
	if not fearstatus and string.find(msg, L["feartrigger"]) and self.db.profile.fear then
		fearstatus = true
		self:TriggerEvent("BigWigs_StartBar", self, L["fearbar"], 20, "Interface\\Icons\\Spell_Shadow_Possession")
		self:TriggerEvent("BigWigs_Message", L["fearwarn1"], "Important")
		self:ScheduleEvent("BigWigs_Message", 15, L["fearwarn2"], "Urgent")
	end
end

function BigWigsBugFamily:BigWigs_Message(txt)
	if fearstatus and txt == L["fearwarn2"] then fearstatus = nil end
end

function BigWigsBugFamily:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if (msg == string.format(UNITDIESOTHER, kri) or msg == string.format(UNITDIESOTHER, yauj) or msg == string.format(UNITDIESOTHER, vem)) then
		deaths = deaths + 1
		if (deaths == 3) then
			if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], boss), "Bosskill", nil, "Victory") end
			self.core:ToggleModuleActive(self, false)
		end
	end
end

function BigWigsBugFamily:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["healtrigger"] and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["healwarn"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["healwarn"], 2, "Interface\\Icons\\Spell_Holy_Heal")
	end
end
