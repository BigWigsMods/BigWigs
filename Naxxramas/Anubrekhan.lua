----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Anub'Rekhan"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15956
mod.toggleoptions = {"locust", "bosskill"}
mod.consoleCmd = "Anubrekhan"

------------------------------
--      Are you local?      --
------------------------------

local locustTime = 90

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	locust = "Locust Swarm",
	locust_desc = "Warn for Locust Swarm.",

	starttrigger1 = "Just a little taste...",
	starttrigger2 = "Yes, run! It makes the blood pump faster!",
	starttrigger3 = "There is no way out.",
	engagewarn = "Anub'Rekhan engaged! Locust Swarm in ~%d sec",

	gainendwarn = "Locust Swarm ended!",
	gainnextwarn = "Next Locust Swarm in ~85 sec",
	gainwarn10sec = "~10 sec until Locust Swarm",
	gainincbar = "~Next Locust Swarm",
	gainbar = "Locust Swarm",

	castwarn = "Incoming Locust Swarm!",
} end )

L:RegisterTranslations("ruRU", function() return {
	locust = "Жуки-трупоеды",
	locust_desc = "Предупреждать о появлении жуков.",

	starttrigger1 = "Посмотрим, какие вы на вкус!", 
	starttrigger2 = "Бегите, бегите! Я люблю горячую кровь!",  
	starttrigger3 = "Вам отсюда не выбраться.",  --check this
	engagewarn = "Ануб'Рекан вступает в бой! Первая волна жуков через ~%d секунд",

	gainendwarn = "Жуки-трупоеды исчезают!",
	gainnextwarn = "Следующая волна жуков-трупоедов через ~85 секунд",
	gainwarn10sec = "~10 до жуков-трупоедов",
	gainincbar = "Следующая волна жуков-трупоедов",
	gainbar = "Жуки-трупоеды",

	castwarn = "Появляются жуки-трупоеды!",
} end )

L:RegisterTranslations("deDE", function() return {
	locust = "Heuschreckenschwarm",
	locust_desc = "Warnungen und Timer für Heuschreckenschwarm.",

	starttrigger1 = "Nur einmal kosten...",
	starttrigger2 = "Rennt! Das bringt das Blut in Wallung!",
	starttrigger3 = "Es gibt kein Entkommen.",
	engagewarn = "Anub'Rekhan angegriffen! Heuschreckenschwarm in ~%d sek!",

	gainendwarn = "Heuschreckenschwarm vorbei!",
	gainnextwarn = "Nächster Schwarm in ~85 sek",
	gainwarn10sec = "Heuschreckenschwarm in ~10 sek!",
	gainincbar = "~Nächster Schwarm",
	gainbar = "Heuschreckenschwarm",

	castwarn = "Heuschreckenschwarm!",
} end )

L:RegisterTranslations("koKR", function() return {
	locust = "메뚜기 떼",
	locust_desc = "메뚜기 떼를 알립니다.",

	starttrigger1 = "어디 맛 좀 볼까...",
	starttrigger2 = "그래, 도망쳐! 더 신선한 피가 솟구칠 테니!",
	starttrigger3 = "나가는 길은 없다.",
	engagewarn = "아눕레칸 전투시작! 약 %d초 후 첫번째 메뚜기 떼!",

	gainendwarn = "메뚜기 떼 종료!",
	gainnextwarn = "약 85초 이내 다음 메뚜기 떼!",
	gainwarn10sec = "10초 이내 메뚜기 떼",
	gainincbar = "다음 메뚜기 떼",
	gainbar = "메뚜기 떼",

	castwarn = "메뚜기 떼 소환!",
} end )

L:RegisterTranslations("zhCN", function() return {
	locust = "虫群风暴",
	locust_desc = "当施放虫群风暴时发出警报。",

	starttrigger1 = "一些小点心……",
	starttrigger2 = "对，跑吧！那样伤口出血就更多了！",
	starttrigger3 = "你们逃不掉的。",
	engagewarn = "阿努布雷坎已激活 - 约%d秒后，虫群风暴！",

	gainendwarn = "虫群风暴结束了！",
	gainnextwarn = "约85秒后，下一波虫群风暴。",
	gainwarn10sec = "约10秒后，下一波虫群风暴。",
	gainincbar = "<下一虫群风暴>",
	gainbar = "<虫群风暴>",

	castwarn = "虫群风暴！",
} end )

L:RegisterTranslations("zhTW", function() return {
	locust = "蝗蟲風暴",
	locust_desc = "當施放蝗蟲風暴時發出警報。",

	starttrigger1 = "一些小點心……",
	starttrigger2 = "對，跑吧!那樣傷口出血就更多了!",
	starttrigger3 = "你們逃不掉的。",
	engagewarn = "阿努比瑞克漢已進入戰鬥 - %d秒後，蝗蟲風暴！",

	gainendwarn = "蝗蟲風暴結束了！",
	gainnextwarn = "85秒後，下一波蝗蟲風暴！",
	gainwarn10sec = "10秒後，下一波蝗蟲風暴！",
	gainincbar = "<下一蝗蟲風暴>",
	gainbar = "<蝗蟲風暴>",

	castwarn = "蝗蟲風暴！",
} end )

L:RegisterTranslations("frFR", function() return {
	locust = "Nuée de sauterelles",
	locust_desc = "Prévient de l'arrivée des Nuées de sauterelles.",

	starttrigger1 = "Rien qu'une petite bouchée…",
	starttrigger2 = "Oui, courez ! Faites circuler le sang !",
	starttrigger3 = "Nulle part pour s'enfuir.",
	engagewarn = "Anub'Rekhan engagé ! Nuée de sauterelles dans ~%d sec. !",

	gainendwarn = "Fin de la Nuée de sauterelles !",
	gainnextwarn = "Prochaine Nuée de sauterelles dans ~85 sec.",
	gainwarn10sec = "~10 sec. avant la Nuée de sauterelles",
	gainincbar = "~Prochaine Nuée",
	gainbar = "Nuée de sauterelles",

	castwarn = "Arrivée d'une Nuée de sauterelles !",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "GainSwarm", 28785, 54021)
	self:AddCombatListener("SPELL_CAST_START", "Swarm", 28785, 54021)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:GainSwarm(unit, spellId)
	if unit == boss and self.db.profile.locust then
		self:DelayedMessage(20, L["gainendwarn"], "Important")
		self:Bar(L["gainbar"], 20, spellId)
		--self:IfMessage(L["gainnextwarn"], "Urgent", spellId)
		self:DelayedMessage(75, L["gainwarn10sec"], "Important")
		self:Bar(L["gainincbar"], 85, spellId)
	end
end

function mod:Swarm(_, spellId)
	if self.db.profile.locust then
		self:IfMessage(L["castwarn"], "Attention", spellId)
		self:Bar(L["castwarn"], 3, spellId)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.locust and (msg:find(L["starttrigger1"]) or msg == L["starttrigger2"] or msg == L["starttrigger3"]) then
		locustTime = GetRaidDifficulty() == 1 and 102 or 90
		self:Message(L["engagewarn"]:format(locustTime), "Urgent")
		self:DelayedMessage(locustTime - 10, L["gainwarn10sec"], "Important")
		self:Bar(L["gainincbar"], locustTime, 28785)
	end
end

