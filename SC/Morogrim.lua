------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Morogrim Tidewalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local inGrave = {}
local grobulealert = nil
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Morogrim",

	engage_trigger = "Flood of the deep, take you!",

	tidal = "Tidal Wave",
	tidal_desc = "Warn when Morogrim casts Tidal Wave.",
	tidal_message = "Tidal Wave!",

	grave = "Watery Grave",
	grave_desc = "Alert who has watery grave and durations.",
	grave_message = "Watery Grave: %s",
	grave_bar = "Watery Graves",
	grave_nextbar = "~Graves Cooldown",

	murloc = "Murlocs",
	murloc_desc = "Warn for incoming murlocs.",
	murloc_bar = "~Murlocs Cooldown",
	murloc_message = "Incoming Murlocs!",
	murloc_soon_message = "Murlocs soon!",
	murloc_engaged = "%s Engaged, Murlocs in ~40sec",

	globules = "Globules",
	globules_desc = "Warn for incoming Watery Globules.",
	globules_trigger1 = "Soon it will be finished!",
	globules_trigger2 = "There is nowhere to hide!",
	globules_message = "Incoming Globules!",
	globules_warning = "Globules Soon!",
	globules_bar = "Globules Despawn",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Die Fluten der Tiefen werden euch verschlingen!",

	tidal = "Gezeitenwelle",
	tidal_desc = "Warnt, wenn Morogrim Gezeitenwelle benutzt.",
	tidal_message = "Gezeitenwelle!",

	grave = "Nasses Grab",
	grave_desc = "Zeigt an, wer im Nassen Grab ist und wie lange.",
	grave_message = "Nasses Grab: %s",
	grave_bar = "Nasses Grab",
	grave_nextbar = "n\195\164chstes Nasses Grab",

	murloc = "Murlocs",
	murloc_desc = "Warnt vor ankommenden Murlocs.",
	murloc_bar = "n\195\164chste Murlocs",
	murloc_message = "Murlocs kommen!",
	murloc_soon_message = "Murlocs bald!",
	murloc_engaged = "%s angegriffen, Murlocs in ~40sec",

	globules = "Wasserkugeln",
	globules_desc = "Warnt vor Wasserkugeln.",
	globules_trigger1 = "Bald ist es vor\195\188ber!",
	globules_trigger2 = "Es gibt kein Entkommen!",
	globules_message = "Wasserkugeln kommen!",
	globules_warning = "Wasserkugeln bald!",
	globules_bar = "Wasserkugeln Despawn",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "심연의 해일이 집어삼키리라!",

	tidal = "해일",
	tidal_desc = "모로그림의 해일 시전 시 경고합니다.",
	tidal_message = "해일!",

	grave = "수중 무덤",
	grave_desc = "수중 무덤에 걸린 사람과 지속시간을 알림니다.",
	grave_message = "수중 무덤: %s",
	grave_bar = "수중 무덤",
	grave_nextbar = "~무덤 대기시간",

	murloc = "멀록",
	murloc_desc = "멀록 등장에 대한 경고입니다.",
	murloc_bar = "~멀록 등장 대기시간",
	murloc_message = "멀록 등장!",
	murloc_soon_message = "잠시 후 멀록 등장!",
	murloc_engaged = "%s 전투 시작, 약 40초 후 멀록",

	globules = "물방울",
	globules_desc = "물방울 등장에 대한 경고입니다.",
	globules_trigger1 = "곧 끝장내주마!",
	globules_trigger2 = "숨을 곳은 아무 데도 없다!",
	globules_message = "물방울 등장!",
	globules_warning = "잠시 후 물방울!",
	globules_bar = "물방울 사라짐",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Que les flots des profondeurs vous emportent !",

	tidal = "Raz-de-marée",
	tidal_desc = "Préviens quand Morogrim lance un Raz-de-marée.",
	tidal_message = "Raz-de-marée !",

	grave = "Tombeau aquatique",
	grave_desc = "Préviens quand quelqu'un subit le Tombeau aquatique et indique sa durée.",
	grave_message = "Tombeau aquatique : %s",
	grave_bar = "Tombeaux aquatique",
	grave_nextbar = "~Cooldown Tombeaux",

	murloc = "Murlocs",
	murloc_desc = "Préviens de l'arrivée des murlocs.",
	murloc_bar = "~Cooldown Murlocs",
	murloc_message = "Arrivée des murlocs !",
	murloc_soon_message = "Murlocs imminent !",
	murloc_engaged = "%s engagé, murlocs dans ~40 sec.",

	globules = "Globules",
	globules_desc = "Préviens de l'arrivée des globules.",
	globules_trigger1 = "Bientôt, ce sera terminé.",
	globules_trigger2 = "Il est impossible de m'échapper !",
	globules_message = "Arrivée des globules !",
	globules_warning = "Globules imminent !",
	globules_bar = "Disparation des globules",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "深渊中的洪水会淹没你们！",

	tidal = "海潮之波",
	tidal_desc = "当施放海潮之波时发出警报。",
	tidal_message = "海潮之波！",

	grave = "水之墓穴",
	grave_desc = "当玩家受到水之墓穴发出警报。",
	grave_message = "水之墓穴：>%s<！",
	grave_bar = "<水之墓穴>",
	grave_nextbar = "<水之墓穴 冷却>",

	murloc = "鱼群",
	murloc_desc = "当鱼群来临时发出警报。",
	murloc_bar = "<鱼群 冷却>",
	murloc_message = "鱼群 来临！",
	murloc_soon_message = "即将 鱼群！",
	murloc_engaged = "%s激活！约40秒后，鱼群出现！",

	globules = "水泡",
	globules_desc = "当水泡来临时发出警报。",
	globules_trigger1 = "很快就都结束了。",
	globules_trigger2 = "你们无处可逃！",
	globules_message = "水泡 来临！",
	globules_warning = "即将 水泡！",
	globules_bar = "<水泡 消失>",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "深海的洪水，淹沒吧!",

	tidal = "海嘯",
	tidal_desc = "警示海嘯施放",
	tidal_message = "海嘯 - 留意 MT 血量",

	grave = "水之墓",
	grave_desc = "當玩家受到水之墓時通知團隊",
	grave_message = "水之墓：[%s]",
	grave_bar = "水之墓計時",
	grave_nextbar = "水之墓冷卻",

	murloc = "魚人警示",
	murloc_desc = "魚人來臨時警示",
	murloc_bar = "魚人冷卻",
	murloc_message = "魚人出現！",
	murloc_soon_message = "魚人即將出現，準備 AE！",
	murloc_engaged = "%s 開戰 - 魚人在 40 秒內出現！",

	globules = "水珠警示",
	globules_desc = "當水珠來臨時警示",
	globules_trigger1 = "很快，這一切都將結束!",
	globules_trigger2 = "這裡是無處可躲的!",
	globules_message = "水珠出現！避開水球！",
	globules_warning = "水珠即將出現！",
	globules_bar = "水珠消失",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.toggleoptions = {"tidal", "grave", "murloc", "globules", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Grave", 37850, 38023, 38024, 38025)
	self:AddCombatListener("SPELL_CAST_START", "Tidal", 37730)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Murlocs", 37764)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Grave(player)
	if db.grave then
		inGrave[player] = true
		self:ScheduleEvent("BWMoroGrave", self.GraveWarn, 0.4, self)
	end
end

function mod:Tidal()
	if db.tidal then
		self:IfMessage(L["tidal_message"], "Urgent", 37730, "Alarm")
	end
end

function mod:Murlocs()
	if db.murloc then
		self:CancelScheduledEvent("murloc1")
		self:IfMessage(L["murloc_message"], "Positive", 42365)
		self:Bar(L["murloc_bar"], 51, 42365)
		self:ScheduleEvent("murloc1", "BigWigs_Message", 51, L["murloc_soon_message"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(inGrave) do inGrave[k] = nil end
		grobulealert = nil

		if db.murloc then
			self:Message(L["murloc_engaged"]:format(boss), "Positive")
			self:Bar(L["murloc_bar"], 40, "INV_Misc_Head_Murloc_01")
		end
		if db.grave then
			self:Bar(L["grave_nextbar"], 20, "Spell_Frost_ArcticWinds")
		end
	elseif db.globules and (msg == L["globules_trigger1"] or msg == L["globules_trigger2"]) then
		self:Message(L["globules_message"], "Important", nil, "Alert")
		self:Bar(L["globules_bar"], 36, "INV_Elemental_Primal_Water")
	end
end

function mod:GraveWarn()
	local msg = nil
	for k in pairs(inGrave) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["grave_message"]:format(msg), "Important", 37850, "Alert")
	self:Bar(L["grave_nextbar"], 28.5, 37850)
	self:Bar(L["grave_bar"], 4.5, 37850)
	for k in pairs(inGrave) do inGrave[k] = nil end
end

function mod:UNIT_HEALTH(msg)
	if not db.globules then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 26 and health <= 30 and not grobulealert then
			self:Message(L["globules_warning"], "Positive")
			grobulealert = true
		elseif health > 50 and grobulealert then
			grobulealert = false
		end
	end
end

