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

	startwarn = "Gluth Engaged! ~105 sec to decimate",

	frenzy = "Enrage",
	frenzy_desc = "Warn for enrage.",
	frenzy_message = "Enraged!",

	decimate = "Decimate",
	decimate_desc = "Decimate warnings.",
	decimatesoonwarn = "Decimate Soon!",
	decimatewarn = "Decimate!",
	decimatebartext = "~Decimate Zombies",
} end )

L:RegisterTranslations("ruRU", function() return {
	startwarn = "Глут в ярости! ~105 cекунд до появления зомби!",

	frenzy = "Бешенство",
	frenzy_desc = "Предупреждать о бешенстве.",
	frenzy_message = "Опасность бешенства!",

	decimate = "Истребление",
	decimate_desc = "Предупреждать об истреблении.",
	decimatesoonwarn = "Скоро истребление!",
	decimatewarn = "Истребление!",
	decimatebartext = "Истребление",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "글루스 전투 시작! 약 105초 후 좀비 척살!",

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
	startwarn = "格拉斯已激活 - 约105秒后，僵尸出现！",

	frenzy = "狂暴",
	frenzy_desc = "当狂暴时发出警报。",
	frenzy_message = "狂暴 - 猎人立刻使用宁神射击！",

	decimate = "残杀",
	decimate_desc = "当施放残杀时发出警报。",
	decimatesoonwarn = "即将 吞噬！",
	decimatewarn = "残杀！",
	decimatebartext = "<残杀>",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "古魯斯已進入戰鬥 - 105秒後，殭屍出現！",

	frenzy = "狂暴",
	frenzy_desc = "當狂暴時發出警報。",
	frenzy_message = "狂暴警報 - 獵人立刻使用寧神射擊！",

	decimate = "殘殺",
	decimate_desc = "當施放殘殺時發出警報",
	decimatesoonwarn = "即將 殘殺！",
	decimatewarn = "殘殺！",
	decimatebartext = "<殘殺>",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Gluth engagé ! ~105 sec. avant Décimer !",

	frenzy = "Enrager",
	frenzy_desc = "Prévient quand Gluth devient enragé.",
	frenzy_message = "Enragé !",

	decimate = "Décimer",
	decimate_desc = "Prévient de l'arrivé des Décimer.",
	decimatesoonwarn = "Décimer imminent !",
	decimatewarn = "Décimer !",
	decimatebartext = "~Décimer",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15932
mod.toggleoptions = {"frenzy", "decimate", "berserk", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Frenzy", 28371, 54427)
	self:AddCombatListener("SPELL_DAMAGE", "Decimate", 28375, 54426)
	self:AddCombatListener("SPELL_MISSED", "Decimate", 28375, 54426)
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
			self:Bar(L["decimatebartext"], 105, 16590)
			self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
		end
		if self.db.profile.enrage then
			self:Enrage(480, true, true)
		end
	end
end

