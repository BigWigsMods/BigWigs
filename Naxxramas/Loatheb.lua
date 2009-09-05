----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Loatheb"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 16011
mod.toggleOptions = {55593, 29865, 29204, 29234, "bosskill"}
mod.consoleCmd = "Loatheb"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local doomTime = 30
local sporeCount = 1
local doomCount = 1
local sporeTime = 16

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!",

	aura_message = "Necrotic Aura - Duration 17 sec!",
	aura_warning = "Aura gone in 3 sec!",

	deathbloom_warning = "Bloom in 5 sec!",

	doombar = "Inevitable Doom %d",
	doomwarn = "Doom %d! %d sec to next!",
	doomwarn5sec = "Doom %d in 5 sec!",
	doomtimerbar = "Doom every 15sec",
	doomtimerwarn = "Doom timer changes in %s sec!",
	doomtimerwarnnow = "Doom now happens every 15 sec!",

	sporewarn = "Spore %d!",
	sporebar = "Summon Spore %d",
} end )

L:RegisterTranslations("ruRU", function() return {
	startwarn = "Лотхиб вступает в бой, 2 минуты до неотвратимого рока!",

	aura_message = "Мертвенная аура - продолжительность 17 сек!",
	aura_warning = "Мертвенная аура спадает через 3 сек!",

	deathbloom_warning = "Бутон смерти через 5 сек!",

	doombar = "Неотвратимый рок %d",
	doomwarn = "Неотвратимый рок %d! %d секунд до следующего!",
	doomwarn5sec = "Неотвратимый рок %d через 5 секунд!",
	doomtimerbar = "Рок каждые 15 секунд",
	doomtimerwarn = "Рок теперь каждые %s секунд!",
	doomtimerwarnnow = "Рок теперь накладывается каждые 15 секунд!",

	sporewarn = "Появляется %d спора",
	sporebar = "Призвана спора %d",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "로데브 전투시작!, 2분 후 피할 수 없는 파멸!",

	aura_message = "강령술의 오라 - 17초 지속!",
	aura_warning = "3초 후 강령술의 오라 사라짐!",

	deathbloom_warning = "5초 후 죽음의 꽃!",

	doombar = "피할 수 없는 파멸 %d",
	doomwarn = "피할 수 없는 파멸 %d! 다음은 %d초 후!",
	doomwarn5sec = "5초 후 피할 수 없는 파멸 %d!",
	doomtimerbar = "파멸 - 매 15초",
	doomtimerwarn = "%s초 후로 피할 수 없는 파멸의 시간변경!",
	doomtimerwarnnow = "피할 수 없는 파멸! 지금부터 매 15초마다.",

	sporewarn = "포자 %d 소환됨!",
	sporebar = "포자 소환! %d",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Loatheb angegriffen! 2min bis Unausweichliches Schicksal!",

	aura_message = "Nekrotische Aura - Dauer 17 sek!",
	aura_warning = "Nekrotische Aura schwindet in 3 sek!",

	deathbloom_warning = "Todesblüte in 5 sek!",

	doombar = "Unausweichliches Schicksal (%d)",
	doomwarn = "Unausweichliches Schicksal (%d)! %d sek bis zum nächsten.",
	doomwarn5sec = "Unausweichliches Schicksal (%d) in 5 sek!",
	doomtimerbar = "Schicksal alle 15 sek",
	doomtimerwarn = "Schicksal: Timer Wechsel in %s sek!",
	doomtimerwarnnow = "Unausweichliches Schicksal nun alle 15 sek!",

	sporewarn = "Spore (%d)!",
	sporebar = "Spore (%d)",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "洛欧塞布已激活 - 2分钟后，必然的厄运！",

	aura_message = "死灵光环 - 持续17秒！",
	aura_warning = "3秒后，死灵光环消失！",

	deathbloom_warning = "5秒后，死亡之花!",

	doombar = "<必然的厄运：%d>",
	doomwarn = "必然的厄运%d，%d秒后！",
	doomwarn5sec = "5秒后，必然的厄运%d！",
	doomtimerbar = "<每隔15秒 必然的厄运>",
	doomtimerwarn = "%s秒后改变必然的厄运发动频率！",
	doomtimerwarnnow = "必然的厄运现在每隔15秒发动一次！",

	sporewarn = "孢子：>%d<！",
	sporebar = "<孢子：%d>",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "憎恨者已進入戰鬥 - 2分鐘後，無可避免的末日！",

	aura_message = "亡域光環 - 持續17秒！",
	aura_warning = "3秒後，亡域光環消失！",

	deathbloom_warning = "5秒後，死亡之花！",

	doombar = "<無可避免的末日：%d>",
	doomwarn = "無可避免的末日%d，%s秒後！",
	doomwarn5sec = "5秒後，無可避免的末日%d！",
	doomtimerbar = "<每隔15秒 無可避免的末日>",
	doomtimerwarn = "%s秒後改變無可避免的末日發動頻率！",
	doomtimerwarnnow = "無可避免的末日現在每隔15秒發動一次！",

	sporewarn = "孢子：>%d<！",
	sporebar = "<孢子：%d>",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Horreb engagé ! 2 min. avant la 1ère Malédiction inévitable !",

	aura_message = "Aura nécrotique pendant 17 sec. !",
	aura_warning = "Fin de l'Aura nécrotique dans 3 sec. !",

	deathbloom_warning = "Mortelle floraison dans 5 sec. !",

	doombar = "Malédiction inévitable %d",
	doomwarn = "Malédiction inévitable %d ! Prochaine dans %d sec. !",
	doomwarn5sec = "Malédiction inévitable %d dans 5 sec. !",
	doomtimerbar = "Malé. toutes les 15 sec.",
	doomtimerwarn = "Changement du délai des malédictions dans %s sec. !",
	doomtimerwarnnow = "La Malédiction inévitable arrive désormais toutes les 15 sec. !",

	sporewarn = "Spore %d invoquée",
	sporebar = "Invocation de spore %d",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Aura", 55593)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Deathbloom", 29865, 55053)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Doom", 29204, 55052)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spore", 29234)
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

function mod:Aura(_, spellId, _, _, spellName)
	self:IfMessage(L["aura_message"], "Important", spellId)
	self:Bar(spellName, 17, spellId)
	self:DelayedMessage(14, L["aura_warning"], "Attention")
end

function mod:Deathbloom(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 30, spellId)
	self:DelayedMessage(15, L["deathbloom_warning"], "Attention")
end

function mod:Doom(_, spellId)
	self:IfMessage(L["doomwarn"]:format(doomCount, doomTime), "Urgent", spellId)
	doomCount = doomCount + 1
	self:Bar(L["doombar"]:format(doomCount), doomTime, spellId)
	self:DelayedMessage(doomTime - 5, L["doomwarn5sec"]:format(doomCount), "Urgent")
end

function mod:Spore()
	--spellId is a question mark, so we use our own: 38755
	self:IfMessage(L["sporewarn"]:format(sporeCount), "Important", 38755)
	sporeCount = sporeCount + 1
	self:Bar(L["sporebar"]:format(sporeCount), sporeTime, 38755)
end

local function swapTime()
	doomTime = 15
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		doomTime = 30
		sporeCount = 1
		doomCount = 1
		sporeTime = GetRaidDifficulty() == 1 and 36 or 16
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self:GetOption(29204) then
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

