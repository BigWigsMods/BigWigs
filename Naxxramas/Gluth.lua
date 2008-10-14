------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Gluth"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gluth",

	startwarn = "Gluth Engaged! ~105 seconds till Zombies!",

	fear = "Fear",
	fear_desc = "Show Terrifying Roar timers and warnings.",
	fear_warning = "5 second until AoE Fear!",
	fear_message = "AoE Fear alert - 20 seconds till next!",
	fear_bar = "AoE Fear",

	frenzy = "Frenzy",
	frenzy_desc = "Warn for frenzy.",
	frenzy_message = "Frenzy Alert!",

	decimate = "Decimate",
	decimate_desc = "Decimate warnings.",
	decimatesoonwarn = "Decimate Soon!",
	decimatewarn = "Decimate!",
	decimatebartext = "Decimate Zombies",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "글루스 전투 시작! 약 105초 후 좀비 척살!",

	fear = "공포",
	fear_desc = "공포를 알립니다.",
	fear_warning = "5초 이내 광역 공포!",
	fear_message = "광역 공포 - 다음은 20초 후!",
	fear_bar = "광역 공포",

	frenzy = "광기",
	frenzy_desc = "광기를 알립니다.",
	frenzy_message = "광기 경고!",

	decimate = "척살",
	decimate_desc = "척살을 알립니다.",
	decimatesoonwarn = "잠시 후 척살!",
	decimatewarn = "척살!",
	decimatebartext = "좀비 척살",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Gluth angegriffen! Zombies in ~105 Sekunden!",

	fear = "Furcht",
	fear_desc = "Warnung vor AoE Furcht.",
	fear_warning = "AoE Furcht in 5 Sekunden!",
	fear_message = "AoE Furcht! N\195\164chste in 20 Sekunden!",
	fear_bar = "Furcht",

	frenzy = "Raserei",
	frenzy_desc = "Warnung, wenn Gluth in Raserei ger\195\164t.",
	frenzy_message = "Raserei!",

	decimate = "Dezimieren",
	decimate_desc = "Warnung vor Dezimieren.",
	decimatesoonwarn = "Dezimieren kurz bevor",
	decimatewarn = "Dezimieren!",
	decimatebartext = "Dezimieren",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "格拉斯已激活 - ~105秒后僵尸出现！",

	fear = "恐惧警报",
	fear_desc = "恐惧警报",
	fear_warning = "5秒后发动群体恐惧！",
	fear_message = "群体恐惧 - 20秒后再次发动",
	fear_bar = "群体恐惧",

	frenzy = "狂暴警报",
	frenzy_desc = "狂暴警报",
	frenzy_message = "狂暴警报 - 猎人立刻使用宁神射击！",

	decimate = "吞噬警报",
	decimate_desc = "吞噬警报",
	decimatesoonwarn = "吞噬来临！",
	decimatewarn = "吞噬 - 所有僵尸！",
	decimatebartext = "吞噬僵尸",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "古魯斯已進入戰鬥 - 105 秒後殭屍出現！",

	fear = "恐嚇咆哮警報",
	fear_desc = "當古魯斯施放恐嚇咆哮時發出警報",
	fear_warning = "5 秒後發動恐嚇咆哮！",
	fear_message = "恐嚇咆哮 - 20 秒後再次發動",
	fear_bar = "恐嚇咆哮",

	frenzy = "狂暴警報",
	frenzy_desc = "當古魯斯狂暴時發出警報",
	frenzy_message = "狂暴警報 - 獵人立刻使用寧神射擊！",

	decimate = "殘殺警報",
	decimate_desc = "當古魯斯發動殘殺時發出警報",
	decimatesoonwarn = "殘殺來臨！",
	decimatewarn = "殘殺 - AE殭屍！",
	decimatebartext = "殘殺",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Gluth engagé ! ~105 sec. avant les zombies !",

	fear = "Peur",
	fear_desc = "Préviens quand Gluth utilise sa peur de zone.",
	fear_warning = "5 sec. avant peur de zone !",
	fear_message = "Peur de zone - 20 sec. avant la suivante !",
	fear_bar = "Peur de zone",

	frenzy = "Frénésie",
	frenzy_desc = "Préviens quand Gluth entre en frénésie.",
	frenzy_message = "Frénésie !",

	decimate = "Décimer",
	decimate_desc = "Préviens quand Gluth utilise son Décimer.",
	decimatesoonwarn = "Décimer imminent !",
	decimatewarn = "Décimer !",
	decimatebartext = "Décimation des zombies",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15932
mod.toggleoptions = {"enrage", "frenzy", "fear", "decimate", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Frenzy", 28371)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Fear", 29685)
	self:AddCombatListener("SPELL_DAMAGE", "Decimate", 28375)
	self:AddCombatListener("SPELL_MISSED", "Decimate", 28375)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Frenzy()
	if self.db.profile.frenzy then
		self:IfMessage(L["frenzy_message"], "Important", 28371)
	end
end

function mod:Fear(_, spellID)
	if self.db.profile.fear then
		self:IfMessage(L["fear_message"], "Important", spellID)
		self:Bar(L["fear_bar"], 20, spellID)
		self:DelayedMessage(15, L["fear_warning"], "Urgent")
	end
end

local last = 0
function mod:Decimate()
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if self.db.profile.decimate then
			self:IfMessage(L["decimatewarn"], "Attention", 16590, "Alert")
			self:Bar(L["decimatebartext"], 105, 16590)
			self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.decimate then
			self:Message(L["startwarn"], "Attention")
			self:Bar(L["decimatebartext"], 105, 28375)
			self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
		end
		if self.db.profile.enrage then
			self:Enrage(360, nil, true)
		end
	end
end

