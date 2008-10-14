------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Instructor Razuvious"]
local understudy = BB["Deathknight Understudy"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razuvious",

	startwarn = "Instructor Razuvious engaged! ~25sec to shout!",
	starttrigger1 = "The time for practice is over! Show me what you have learned!",
	starttrigger2 = "Sweep the leg... Do you have a problem with that?",
	starttrigger3 = "Show them no mercy!",
	starttrigger4 = "Do as I taught you!",

	shout = "Disrupting Shout",
	shout_desc = "Warn for Disrupting Shout.",
	shout7secwarn = "7 sec to Disrupting Shout",
	shout3secwarn = "3 sec to Disrupting Shout!",
	shoutwarn = "Disrupting Shout!",
	shoutbar = "Next shout",

	taunt = "Taunt Timer",
	taunt_desc = "Show timer for taunt",
	shieldwall = "Shield Wall Timer",
	shieldwall_desc = "Show timer for shieldwall.",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Instruktor Razuvious angegriffen! Unterbrechungsruf in ~25 Sekunden!",
	starttrigger1 = "Die Zeit des \195\156bens ist vorbei! Zeigt mir, was ihr gelernt habt!",
	starttrigger2 = "Streckt sie nieder... oder habt ihr ein Problem damit?",
	starttrigger3 = "Lasst keine Gnade walten!",
	starttrigger4 = "Befolgt meine Befehle!",

	shout = "Unterbrechungsruf",
	shout_desc = "Warnung, wenn Instruktor Razuvious Unterbrechungsruf wirkt.",
	shout7secwarn = "Unterbrechungsruf in 7 Sekunden!",
	shout3secwarn = "Unterbrechungsruf in 3 Sekunden!",
	shoutwarn = "Unterbrechungsruf!",
	shoutbar = "Unterbrechungsruf",

	shieldwall = "Schildwall",
	shieldwall_desc = "Timer f\195\188r Schildwall.",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "훈련교관 라주비어스 전투 시작! 약 25초 이내 외침!",
	starttrigger1 = "훈련은 끝났다! 배운 걸 보여줘라!",
	starttrigger2 = "다리를 후려 차라! 무슨 문제 있나?",
	starttrigger3 = "절대 봐주지 마라!",
	starttrigger4 = "훈련받은 대로 해!",

	shout = "분열의 외침",
	shout_desc = "분열의 외침을 알립니다.",
	shout7secwarn = "7초 후 분열의 외침!",
	shout3secwarn = "3초 후 분열의 외침!",
	shoutwarn = "분열의 외침!",
	shoutbar = "분열의 외침",

	shieldwall = "방패의 벽 타이머",
	shieldwall_desc = "방패의 벽에 대한 타이머 표시",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "教官拉苏维奥斯已激活！ ~25秒后瓦解怒吼",
	starttrigger1 = "练习时间到此为止！都拿出真本事来！",
	starttrigger2 = "绊腿……有什么问题么？",
	starttrigger3 = "仁慈无用！",
	starttrigger4 = "按我教导的去做！",

	shout = "怒吼警报",
	shout_desc = "瓦解怒吼警报",
	shout7secwarn = "7秒后发动瓦解怒吼",
	shout3secwarn = "3秒后发动瓦解怒吼！",
	shoutwarn = "瓦解怒吼！",
	shoutbar = "瓦解怒吼",

	shieldwall = "盾墙计时器",
	shieldwall_desc = "盾墙计时器",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "講師拉祖維斯已進入戰鬥 - 25 秒後混亂怒吼",
	starttrigger1 = "練習時間到此為止！都拿出真本事來！",
	starttrigger2 = "絆腿……有什麼問題嗎？",
	starttrigger3 = "仁慈無用！",
	starttrigger4 = "照我教你的做！",

	shout = "怒吼警報",
	shout_desc = "混亂怒吼警報",
	shout7secwarn = "7秒後發動混亂怒吼",
	shout3secwarn = "3秒後發動混亂怒吼！",
	shoutwarn = "混亂怒吼！",
	shoutbar = "混亂怒吼",

	shieldwall = "盾牆計時器",
	shieldwall_desc = "學員盾牆計時器",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Instructor Razuvious engagé ! ~25 sec. avant le Cri !",
	starttrigger1 = "Les cours sont terminés ! Montrez-moi ce que vous avez appris !",
	starttrigger2 = "Frappe-le à la jambe",
	starttrigger3 = "Pas de quartier !",
	starttrigger4 = "Faites ce que vous ai appris !",

	shout = "Cri",
	shout_desc = "Préviens de l'arrivée des Cris perturbant.",
	shout7secwarn = "7 sec. avant Cri perturbant !",
	shout3secwarn = "3 sec. avant Cri perturbant !",
	shoutwarn = "Cri perturbant !",
	shoutbar = "Cri perturbant",

	shieldwall = "Mur protecteur",
	shieldwall_desc = "Affiche la durée des Murs protecteur.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {boss, understudy}
mod.guid = 16061
mod.toggleoptions = {"shieldwall", "bosskill", "taunt"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:AddCombatListener("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ShieldWall(_, spellID, _, _, spellName)
	if self.db.profile.shieldwall then
		self:Bar(spellName, 20, spellID)
	end
end

function mod:Taunt(_, spellID, _, _, spellName)
	if self.db.profile.taunt then
		self:Bar(spellName, 20, spellID)
	end
end


