----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Gluth"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15932
mod.toggleOptions = {28371, 54426, "berserk", "bosskill"}
mod.consoleCmd = "Gluth"

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
	startwarn = "Gluth engaged, ~105 sec to decimate!",

	decimatesoonwarn = "Decimate Soon!",
	decimatebartext = "~Decimate Zombies",
} end )

L:RegisterTranslations("ruRU", function() return {
	startwarn = "Глут вступает в бой! ~105 cекунд до появления зомби!",

	decimatesoonwarn = "Скоро истребление!",
	decimatebartext = "Истребление",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "글루스 전투 시작! 약 105초 후 좀비 척살!",

	decimatesoonwarn = "잠시 후 척살!",
	decimatebartext = "좀비 척살",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Gluth angegriffen! ~105 sek bis Dezimieren!",

	decimatesoonwarn = "Dezimieren bald!",
	decimatebartext = "~Dezimieren",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "格拉斯已激活 - 约105秒后，残杀！",

	decimatesoonwarn = "即将 吞噬！",
	decimatebartext = "<残杀>",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "古魯斯已進入戰鬥 - 105秒後，殘殺！",

	decimatesoonwarn = "即將 殘殺！",
	decimatebartext = "<殘殺>",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Gluth engagé ! ~105 sec. avant Décimer !",

	decimatesoonwarn = "Décimer imminent !",
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

function mod:Frenzy(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

local last = 0
function mod:Decimate(_, spellId, _, _, spellName)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		self:IfMessage(spellName, "Attention", spellId, "Alert")
		self:Bar(L["decimatebartext"], 105, spellId)
		self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		enrageTime = GetRaidDifficulty() == 1 and 480 or 420
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self:GetOption(54426) then
			self:Message(L["startwarn"], "Attention")
			self:Bar(L["decimatebartext"], 105, 54426)
			self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
		end
		if self.db.profile.berserk then
			self:Enrage(enrageTime, true, true)
		end
	end
end

