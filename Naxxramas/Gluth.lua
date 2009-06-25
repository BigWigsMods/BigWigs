----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Gluth"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15932
mod.toggleoptions = {"frenzy", "decimate", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local enrageTime = 420

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
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
	startwarn = "Глут вступает в бой! ~105 cекунд до появления зомби!",

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

	frenzy = "격노",
	frenzy_desc = "격노를 알립니다.",
	frenzy_message = "격노!",

	decimate = "척살",
	decimate_desc = "척살을 알립니다.",
	decimatesoonwarn = "잠시 후 척살!",
	decimatewarn = "척살!",
	decimatebartext = "좀비 척살",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Gluth angegriffen! ~105 sek bis Dezimieren!",

	frenzy = "Raserei",
	frenzy_desc = "Warnen, wenn Gluth in Raserei verfällt.",
	frenzy_message = "Raserei!",

	decimate = "Dezimieren",
	decimate_desc = "Warnungen und Timer für Dezimieren.",
	decimatesoonwarn = "Dezimieren bald!",
	decimatewarn = "Dezimieren!",
	decimatebartext = "~Dezimieren",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "格拉斯已激活 - 约105秒后，残杀！",

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
	startwarn = "古魯斯已進入戰鬥 - 105秒後，殘殺！",

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
	decimatebartext = "~Prochain Décimer",
} end )

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

function mod:Frenzy(_, spellId)
	if self.db.profile.frenzy then
		self:IfMessage(L["frenzy_message"], "Important", spellId)
	end
end

local last = 0
function mod:Decimate(_, spellId)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if self.db.profile.decimate then
			self:IfMessage(L["decimatewarn"], "Attention", spellId, "Alert")
			self:Bar(L["decimatebartext"], 105, spellId)
			self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		enrageTime = GetCurrentDungeonDifficulty() == 1 and 480 or 420
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if self.db.profile.decimate then
			self:Message(L["startwarn"], "Attention")
			self:Bar(L["decimatebartext"], 105, 54426)
			self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
		end
		if self.db.profile.berserk then
			self:Enrage(enrageTime, true, true)
		end
	end
end

