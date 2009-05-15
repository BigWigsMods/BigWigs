----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Flame Leviathan"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33113
mod.toggleoptions = {"flame", "pursue", "shutdown", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------


--[[
<vhaarr> Pneumatus: does it launch the passenger onto the leviathan, or do you need to target with it?
<Pneumatus> vhaarr: you have to target it on to his body, like all the rest of the abilties
<vhaarr> Pneumatus: right, so you can miss
<Pneumatus> vhaarr: yes, you can :)
<vhaarr> Pneumatus: is it best to allow him to do a full flame vent cast and use that time to throw people on? I'm trying to iron out some strategy tips for when we are doing his hardmode
<vhaarr> or is it very easy to hit
<Pneumatus> vhaarr: there's a bit of leniance with the place the target lands, as you get some grappling hook thing that pulls them to the correct landing spot, but if you target miles off the passenger wil just get thrown to that location
<Pneumatus> we've only done 2 towers, but we always cancel flame vents and just throw people up as soon as they get back in their demolishers after the last shutdown
<vhaarr> Pneumatus: alright thanks
<vhaarr> Pneumatus: do you throw a healer up or ranged/melee?
<vhaarr> I was thinking 1 healer + ranged dps
<Pneumatus> never melee
<Pneumatus> 1 healer 2/3 casters
<vhaarr> cool
<Pneumatus> the more people you send up though, the less pyerite barrels the demolishers can fire
<Pneumatus> as they dont have the top seat passenger to hook in new pyerite when they use it up
<vhaarr> how often do you need to reload that pyrite?
<Pneumatus> vhaarr: the demolisher has 100 pyerite at the start, and each cast of the "pyerite barrel" ability uses something like 10, so ideally you want to spam pyerite after a shutdown, then refill with 2 barrels in the kiting phase
<Pneumatus> each barrel gives 50 pyerite
<Megalon> 50, 5 per barrel, 25 refill
<vhaarr> ah cool
<Megalon> but quite the same
<Pneumatus> ah, might be that then, i think i probably read in percent
<Megalon> and siege tank gunners should try to take down some barrels
<Pneumatus> yeh, as you're likely to only have 1 demolisher passenger in their vehicle 100% of the time
<Megalon> so that the guys in demolisher just hop in, reload and fired back on leviathan as quickly as possible
<Megalon> and if you don't do 4 towers, you can have one demolisher seated 100%
<Megalon> don't know if that also works out on 4 towers, but I don't think so
<Pneumatus> one alternative idea is to use less than the full amount of motorbikes, and swap alternative passengers into the demolisher seats once people have been thrown up
<Pneumatus> so you start the fight with a couple of passengers in the motorbikes ready to switch into demolisher seats once the first guys get thrown up
<Megalon> and just throw all shadowpriests
<Pneumatus> yeh if you can throw a shadowpriest up, and put the other casters in his group you dont need a healer
<Pneumatus> on 2 towers at least the damage up top wasnt too bad, VE could probably heal trhough it
<sb|work> is it possible to cause multiple shutdowns?
<Pneumatus> the motorbikes can heal the people up top as well once they get picked up

]]

local db = nil
local started = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Leviathan",

	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s Engaged!",

	flame = "Flame Jet",
	flame_desc = "Warn when Flame Leviathan casts a Flame Jet.",
	flame_message = "Flame Jet!",

	pursue = "Pursuit",
	pursue_desc = "Warn when Flame Leviathan pursues a player.",
	pursue_trigger = "^%%s pursues",
	pursue_other = "Leviathan pursues %s!",
	pursue_you = "Leviathan pursues YOU!",

	shutdown = "Systems Shutdown",
	shutdown_desc = "Warn when the systems shut down.",
	shutdown_message = "Systems down!",
	--overload_trigger = "%s's curcuits overloaded.",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^적대적인 존재 감지.",
	engage_message = "%s 전투 시작!",

	flame = "화염 분출",
	flame_desc = "거대 화염전차으 화염 분출 시전을 알립니다.",
	flame_message = "화염 분출!",

	pursue = "추격",
	pursue_desc = "플레이어에게 거대 화염전차의 추적을 알립니다.",
	pursue_trigger = "([^%s]+)|1을;를; 쫓습니다.$",
	pursue_other = "%s 추격!",
	pursue_you = "당신을 추격!",

	shutdown = "시스템 작동 정지",
	shutdown_desc = "거대 화염전차의 시스템 작동 정지를 알립니다.",
	shutdown_message = "시스템 작동 정지!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Entités hostiles détectées.",
	engage_message = "%s engagé !",

	flame = "Décharges de flammes",
	flame_desc = "Prévient quand le Léviathan des flammes incante des Décharges de flammes.",
	flame_message = "Décharges de flammes !",

	pursue = "Poursuite",
	pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur.",
	pursue_trigger = "^%%s poursuit",
	pursue_other = "Poursuivi(e) : %s",
	pursue_you = "Léviathan des flammes VOUS poursuit !",

	shutdown = "Extinction des systèmes",
	shutdown_desc = "Prévient quand le Léviathan des flammes éteint ses systèmes.",
	shutdown_message = "Extinction des systèmes !",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Feindeinheiten erkannt",
	engage_message = "%s angegriffen!",

	flame = "Flammenstrahl",
	flame_desc = "Warnung und Timer für Flammenstrahl.",
	flame_message = "Flammenstrahl!",

	pursue = "Verfolgung",
	pursue_desc = "Warnt, wenn der Flammenleviathan einen Spieler verfolgt.",
	pursue_trigger = "^%%s verfolgt",
	pursue_other = "%s wird verfolgt!",
	pursue_you = "DU wirst verfolgt!",

	shutdown = "Systemabschaltung",
	shutdown_desc = "Warnung für Systemabschaltung.",
	shutdown_message = "Systemabschaltung!",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s已激怒！",

	flame = "Flame Jet",
	flame_desc = "当烈焰巨兽施放Flame Jet时发出警报。",
	flame_message = "Flame Jet！",

	pursue = "Pursuit",
	pursue_desc = "当烈焰巨兽pursues玩家时发出警报。",
--	pursue_trigger = "^%%s pursues",
	pursue_other = "烈焰巨兽pursues：>%s<！",
	pursue_you = ">你< 烈焰巨兽pursues！",

	shutdown = "Systems Shutdown",
	shutdown_desc = "当烈焰巨兽Systems Shutdown时发出警报。",
	shutdown_message = "Systems Shutdown！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "發現敵意實體。啟動威脅評估協定。首要目標接近中。30秒後將再度評估。",
	engage_message = "%s已狂怒！",

	flame = "烈焰噴洩",
	flame_desc = "當烈焰戰輪施放烈焰噴洩時發出警報。",
	flame_message = "烈焰噴洩！",

	pursue = "獵殺",
	pursue_desc = "當烈焰戰輪獵殺玩家時發出警報。",
	pursue_trigger = "^%%s緊追",
	pursue_other = "烈焰戰輪獵殺：>%s<！",
	pursue_you = ">你< 烈焰戰輪獵殺！",

	shutdown = "系統關閉",
	shutdown_desc = "當烈焰戰輪系統關閉時發出警報。",
	shutdown_message = "系統關閉！",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "^Обнаружены противники.",
	engage_message = "%s вступает в бой!",

	flame = "Огненная струя",
	flame_desc = "Сообщать когда Огненный Левиафан применяет огненную струю.",
	flame_message = "Огненная струя!",

	pursue = "Погоня",
	pursue_desc = "Сообщать когда Огненный Левиафан преследует игрока.",
	pursue_trigger = "^%%s наводится на",
	pursue_other = "Левиафан преследует |3-3(%s)!",
	pursue_you = "Левиафан преследует ВАС!",

	shutdown = "Отключение системы",
	shutdown_desc = "Сообщать когда Огненный Левиафан отключает системы",
	shutdown_message = "Отключение системы!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 62396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FlameFailed", 62396)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame()
	if db.flame then
		self:IfMessage(L["flame_message"], "Urgent", 62396)
		self:Bar(L["flame"], 10, 62396)
	end
end

function mod:FlameFailed()
	self:TriggerEvent("BigWigs_StopBar", self, L["flame"])
end

function mod:Shutdown()
	if db.shutdown then
		self:IfMessage(L["shutdown_message"], "Positive", 62475, "Long")
		self:Bar(L["shutdown"], 20, 62475)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == boss then
		if db.pursue and message:find(L["pursue_trigger"]) then
			local other = fmt(L["pursue_other"], player)
			if player == pName then
				self:LocalMessage(L["pursue_you"], "Personal", 62374, "Alarm")
				self:WideMessage(other)
			else
				self:IfMessage(other, "Attention", 62374)
			end
			self:Bar(other, 30, 62374)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:IfMessage(L["engage_message"]:format(boss), "Attention")
	end
end

