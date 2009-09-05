----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Maexxna"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15952
mod.toggleOptions = {29484, 28622, 54123, "bosskill"}
mod.consoleCmd = "Maexxna"

------------------------------
--      Are you local?      --
------------------------------

local inCocoon = mod:NewTargetList()
local started = nil
local enrageannounced = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	webspraywarn30sec = "Cocoons in 10 sec",
	webspraywarn20sec = "Cocoons! Spiders in 10 sec!",
	webspraywarn10sec = "Spiders! Spray in 10 sec!",
	webspraywarn5sec = "WEB SPRAY in 5 seconds!",
	webspraywarn = "Web Spray! 40 sec until next!",
	enragewarn = "Enrage - SQUISH SQUISH SQUISH!",
	enragesoonwarn = "Enrage Soon - Bugsquatters out!",

	webspraybar = "Web Spray",
	cocoonbar = "Cocoons",
	spiderbar = "Spiders",
} end )

L:RegisterTranslations("ruRU", function() return {
	webspraywarn30sec = "Паутина через 10 секунд",
	webspraywarn20sec = "Паутина! 10 секунд до появления пауков!",
	webspraywarn10sec = "Пауки! 10 секунд до паутины!",
	webspraywarn5sec = "Паутина через 5 секунд!",
	webspraywarn = "Паутина! 40 секунд до следующей!",
	enragewarn = "Бешенство - ХЛЮП ХЛЮП ХЛЮП!",
	enragesoonwarn = "Скоро бешенство",

	webspraybar = "Летящая паутина",
	cocoonbar = "Коконы",
	spiderbar = "Пауки",
} end )

L:RegisterTranslations("deDE", function() return {
	webspraywarn30sec = "Fangnetz in 10 sek!",
	webspraywarn20sec = "Fangnetz! Spinnen in 10 sek!",
	webspraywarn10sec = "Spinnen! Gespinstschauer in 10 sek!",
	webspraywarn5sec = "Gespinstschauer in 5 sek!",
	webspraywarn = "Gespinstschauer! Nächster in 40 sek!",
	enragewarn = "Raserei!",
	enragesoonwarn = "Raserei bald!",

	webspraybar = "Gespinstschauer",
	cocoonbar = "Fangnetz",
	spiderbar = "Spinnen",
} end )

L:RegisterTranslations("koKR", function() return {
	webspraywarn30sec = "10초 이내 거미줄 감싸기",
	webspraywarn20sec = "거미줄 감싸기. 10초 후 거미 소환!",
	webspraywarn10sec = "거미 소환. 10초 후 거미줄 뿌리기!",
	webspraywarn5sec = "5초 후 거미줄 뿌리기!",
	webspraywarn = "거미줄 뿌리기! 다음은 40초 후!",
	enragewarn = "광기!",
	enragesoonwarn = "잠시 후 광기!",

	webspraybar = "거미줄 뿌리기",
	cocoonbar = "거미줄 감싸기",
	spiderbar = "거미 소환",
} end )

L:RegisterTranslations("zhCN", function() return {
	webspraywarn30sec = "10秒后，蛛网裹体！",
	webspraywarn20sec = "蛛网裹体！10秒后小蜘蛛出现！",
	webspraywarn10sec = "小蜘蛛出现！10秒后蛛网喷射！",
	webspraywarn5sec = "蛛网喷射5秒！",
	webspraywarn = "40秒后，蛛网裹体！",
	enragewarn = "激怒！",
	enragesoonwarn = "即将 激怒！",

	webspraybar = "<蛛网喷射>",
	cocoonbar = "<蛛网裹体>",
	spiderbar = "<出现 小蜘蛛>",
} end )

L:RegisterTranslations("zhTW", function() return {
	webspraywarn30sec = "10秒後，纏繞之網！",
	webspraywarn20sec = "纏繞之網！10秒後小蜘蛛出現！",
	webspraywarn10sec = "小蜘蛛出現！10秒後撒網！",
	webspraywarn5sec = "撒網5秒！",
	webspraywarn = "40秒後 撒網！",
	enragewarn = "狂怒！",
	enragesoonwarn = "即將 狂怒！",

	webspraybar = "<撒網>",
	cocoonbar = "<纏繞之網>",
	spiderbar = "<出現 小蜘蛛>",
} end )

L:RegisterTranslations("frFR", function() return {
	webspraywarn30sec = "Entoilage dans 10 sec.",
	webspraywarn20sec = "Entoilage ! 10 sec. avant les araignées !",
	webspraywarn10sec = "Araignées ! 10 sec. avant le Jet de rets !",
	webspraywarn5sec = "Jet de rets dans 5 sec. !",
	webspraywarn = "Jet de rets ! 40 sec. avant le suivant !",
	enragewarn = "Frénésie !",
	enragesoonwarn = "Frénésie imminente !",

	webspraybar = "Jet de rets",
	cocoonbar = "Entoilage",
	spiderbar = "Araignées",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cocoon", 28622)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 54123, 54124) --Norm/Heroic
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spray", 29484, 54125)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("UNIT_HEALTH")

	wipe(inCocoon)
	started = nil
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

local function cocoonWarn()
	mod:TargetMessage(L["cocoonbar"], inCocoon, "Important", 745, "Alert")
end

function mod:Cocoon(player)
	inCocoon[#inCocoon + 1] = player
	self:ScheduleEvent("Cocoons", cocoonWarn, 0.3)
end

function mod:Spray()
	self:IfMessage(L["webspraywarn"], "Important", 54125)
	self:DelayedMessage(10, L["webspraywarn30sec"], "Attention")
	self:DelayedMessage(20, L["webspraywarn20sec"], "Attention")
	self:DelayedMessage(30, L["webspraywarn10sec"], "Attention")
	self:DelayedMessage(35, L["webspraywarn5sec"], "Attention")
	self:Bar(L["webspraybar"], 40, 54125)
	if self:GetOption(28622) then
		self:Bar(L["cocoonbar"], 20, 745)
	end
	self:Bar(L["spiderbar"], 30, 17332)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		self:Spray()
	end
end

function mod:Enrage(_, spellId)
	self:IfMessage(L["enragewarn"], "Attention", spellId, "Alarm")
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 30 and health <= 33 and not enrageannounced then
			if self:GetOption(54123) then
				self:Message(L["enragesoonwarn"], "Important")
			end
			enrageannounced = true
		elseif health > 40 and enrageannounced then
			enrageannounced = nil
		end
	end
end

