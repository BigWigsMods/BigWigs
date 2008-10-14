------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Loatheb"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local doomTime = 30
local sporeCount = 1
local doomCount = 1

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Loatheb",

	startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!",

	doom = "Inevitable Doom",
	doom_desc = "Warn for Inevitable Doom",
	doombar = "Inevitable Doom %d",
	doomwarn = "Inevitable Doom %d! %d sec to next!",
	doomwarn5sec = "Inevitable Doom %d in 5 sec!",
	doomtimerbar = "Doom every 15sec",
	doomtimerwarn = "Doom timerchange in %s sec!",
	doomtimerwarnnow = "Inevitable Doom now happens every 15sec!",

	spore = "Spore Spawning",
	spore_desc = "Warn when a spore spawns",
	sporewarn = "Spore %d Spawned",
	sporebar = "Summon Spore %d",

	curse = "Remove Curse",
	curse_desc = "Warn when curses are removed from Loatheb",
	removecursewarn = "Curses removed on Loatheb",
	removecursebar = "Remove Curse",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "로데브 전투시작!, 2분 후 피할 수 없는 파멸!",

	doom = "파멸",
	doom_desc = "피할 수 없는 파멸을 알립니다.",
	doombar = "피할 수 없는 파멸 %d",
	doomwarn = "피할 수 없는 파멸 %d! 다음은 %d초 후!",
	doomwarn5sec = "5초 후 피할 수 없는 파멸!",
	doomtimerbar = "파멸 - 매 15초",
	doomtimerwarn = "%s초 후로 피할 수 없는 파멸의 시간변경!",
	doomtimerwarnnow = "피할 수 없는 파멸! 지금부터 매 15초마다.",

	spore = "포자",
	spore_desc = "포자 소환을 알립니다.",
	sporewarn = "포자 %d 소환됨!",
	sporebar = "포자 소환! %d",

	curse = "저주 해제",
	curse_desc = "로데브의 저주 해제를 알립니다.",
	removecursewarn = "로데브 저주 해제 시전!",
	removecursebar = "저주 해제",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Loatheb angegriffen! 2 Minuten bis Unausweichliches Schicksal!",

	doom = "Unausweichliches Schicksal",
	doom_desc = "Warnung f\195\188r Unausweichliches Schicksal.",
	doombar = "Unausweichliches Schicksal %d",
	doomwarn = "Unausweichliches Schicksal %d! %d Sekunden bis zum n\195\164chsten.",
	doomwarn5sec = "Unausweichliches Schicksal %d in 5 Sekunden",
	doomtimerbar = "Unausweichliches Schicksal alle 15 Sekunden",
	doomtimerwarn = "Unausweichliches Schicksal Timer Wechsel in %s Sekunden!",
	doomtimerwarnnow = "Unausweichliches Schicksal nun alle 15s!",

	spore = "Warnung bei Sporen",
	spore_desc = "Warnung wenn Sporen auftauchen",
	sporewarn = "Spore %d aufgetaucht",
	sporebar = "Spore beschw\195\182ren %d",

	curse = "Fluch-Aufhebungs Warnung",
	curse_desc = "Warnung wenn Fl\195\188che bei Loatheb aufgehoben wurden",
	removecursewarn = "Fl\195\188che bei Loatheb aufgehoben",
	removecursebar = "Fluch aufheben",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "洛欧塞布已激活 - 2分钟后发动必然的厄运！",

	doom = "必然的厄运警报",
	doom_desc = "必然的厄运警报",
	doombar = "必然的厄运 %d",
	doomwarn = "必然的厄运 %d! - %d秒后再次发动",
	doomwarn5sec = "5秒后发动必然的厄运%d！",
	doomtimerbar = "每隔15秒发动必然的厄运",
	doomtimerwarn = "必然的厄运计时%s秒后改变！",
	doomtimerwarnnow = "必然的厄运现在每隔15秒发动一次！",

	spore = "孢子警报",
	spore_desc = "孢子警报",
	sporewarn = "%d 孢子出现",
	sporebar = "召唤孢子 %d",

	curse = "诅咒驱散警报",
	curse_desc = "洛欧塞布驱散了一个诅咒效果时发出警报",
	removecursewarn = "洛欧塞布驱散了一个诅咒效果",
	removecursebar = "驱散诅咒",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "洛斯伯已進入戰鬥 - 2 分鐘後發動無可避免的末日！",

	doom = "無可避免的末日警報",
	doom_desc = "無可避免的末日警報",
	doombar = "無可避免的末日",
	doomwarn = "無可避免的末日 - %s 秒後再次發動",
	doomwarn5sec = "5 秒後發動無可避免的末日！",
	doomtimerbar = "每隔 15 秒發動無可避免的末日",
	doomtimerwarn = "無可避免的末日計時 %s 秒後改變！",
	doomtimerwarnnow = "無可避免的末日現在每隔 15 秒發動一次！",

	spore = "孢子警報",
	spore_desc = "孢子警報",
	sporewarn = "孢子出現",
	sporebar = "召喚孢子",

	curse = "詛咒驅散警報",
	curse_desc = "洛斯伯驅散了一個詛咒效果時發出警報",
	removecursewarn = "洛斯伯消除了一個詛咒效果",
	removecursebar = "消除詛咒",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Horreb engagé, 2 min. avant Malédiction inévitable !",

	doom = "Malédiction inévitable",
	doom_desc = "Préviens de l'arrivée des Warn Malédictions inévitables.",
	doombar = "Malédiction inévitable %d",
	doomwarn = "Malédiction inévitable %d! Prochaine dans %d sec. !",
	doomwarn5sec = "Malédiction inévitable %d dans 5 sec. !",
	doomtimerbar = "Malé. toutes les 15 sec.",
	doomtimerwarn = "Doom timerchange dans %s sec. !",
	doomtimerwarnnow = "Malédiction inévitable désormais toutes les 15 sec. !",

	spore = "Invocation de spore",
	spore_desc = "Préviens quand une spore est invoquée.",
	sporewarn = "Spore %d invoquée",
	sporebar = "Invocation de spore %d",

	curse = "Délivrance des malé.",
	curse_desc = "Préviens quand Horreb enlève les malédictions qui l'affectent.",

	removecursewarn = "Malédictions enlevées sur Loatheb",
	removecursebar = "Délivrance des malé.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 16011
mod.toggleoptions = {"doom", "spore", "curse", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Doom", 29204)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spore", 29234)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Decurse", 30281)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	doomTime = 30
	sporeCount = 1
	doomCount = 1
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Doom(_, spellID)
	if not self.db.profile.doom then return end

	self:IfMessage(L["doomwarn"]:format(doomCount, doomTime), "Urgent", spellID)
	doomCount = doomCount + 1
	self:Bar(L["doombar"]:format(doomCount), doomTime, spellID)
	self:DelayedMessage(doomTime - 5, L["doomwarn5sec"]:format(doomCount), "Urgent")
end

function mod:Spore()
	if not self.db.profile.spore then return end

	--spellID is a question mark, so we use our own: 38755
	self:IfMessage(L["sporewarn"]:format(sporeCount), "Important", 38755)
	sporeCount = sporeCount + 1
	self:Bar(L["sporebar"]:format(sporeCount), 12, 38755)
end

function mod:Decurse(_, spellID)
	if self.db.profile.curse then
		self:IfMessage(L["removecursewarn"], "Positive", spellID)
		self:Bar(L["removecursebar"], 30, spellID)
	end
end

local function swapTime()
	doomTime = 15
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.doom then
			self:Bar(L["doomtimerbar"], 300, 29204)
			self:DelayedMessage(240, L["doomtimerwarn"]:format(60), "Attention")
			self:DelayedMessage(270, L["doomtimerwarn"]:format(30), "Attention")
			self:DelayedMessage(290, L["doomtimerwarn"]:format(10), "Urgent")
			self:DelayedMessage(295, L["doomtimerwarn"]:format(5), "Important")
			self:DelayedMessage(300, L["doomtimerwarnnow"], "Important")

			self:ScheduleEvent("BWLoathebDoomTimer", swapTime, 300)

			self:Message(L["startwarn"], "Attention")
			self:Bar(L["doombar"]:format(doomCount), 120, 29204)
			self:DelayedMessage(115, L["doomwarn5sec"]:format(doomCount), "Urgent")
		end
	end
end

