------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Morogrim Tidewalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local inGrave = {}
local grobulealert = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Morogrim",

	engage_trigger = "Flood of the deep, take you!",

	tidal = "Tidal Wave",
	tidal_desc = "Warn when Morogrim casts Tidal Wave.",
	tidal_trigger = "Morogrim Tidewalker begins to cast Tidal Wave.",
	tidal_message = "Tidal Wave!",

	grave = "Watery Grave",
	grave_desc = "Alert who has watery grave and durations.",
	grave_trigger = "^([^%s]+) ([^%s]+) afflicted by Watery Grave%.$",
	grave_message = "Watery Grave: %s",
	grave_bar = "Watery Graves",
	grave_nextbar = "~Graves Cooldown",

	murloc = "Murlocs",
	murloc_desc = "Warn for incoming murlocs.",
	murloc_bar = "~Murlocs Cooldown",
	murloc_trigger1 = "By the tides!",
	murloc_trigger2 = "Destroy them, my subjects!",
	murloc_message = "Incoming Murlocs!",
	murloc_soon_message = "Murlocs soon!",
	murloc_engaged = "%s Engaged, Murlocs in ~40sec",

	grobules = "Grobules",
	grobules_desc = "Warn for incoming Watery Grobules.",
	grobules_trigger1 = "Soon it will be finished!",
	grobules_trigger2 = "There is nowhere to hide!",
	grobules_message = "Incoming Grobules!",
	grobules_warning = "Grobules Soon!",
	grobules_bar = "Grobules Despawn",
} end )

L:RegisterTranslations("deDE", function() return {
--	engage_trigger = "Flood of the deep, take you!",

	tidal = "Gezeitenwelle",
	tidal_desc = "Warnt, wenn Morogrim Gezeitenwelle benutzt.",

	grave = "Nasses Grab",
	grave_desc = "Zeigt an, wer im Nassen Grab ist und wie lange.",

	murloc = "Murlocs",
	murloc_desc = "Warnt vor ankommenden Murlocs.",

	grobules = "Wasserkugeln",
	grobules_desc = "Warnt vor Wasserkugeln.",

	grave_trigger = "^([^%s]+) ([^%s]+) von Nasses Grab betroffen%.$",
	grave_message = "Nasses Grab: %s",
	grave_bar = "Nasses Grab",
	grave_nextbar = "n\195\164chstes Nasses Grab",

	murloc_bar = "n\195\164chste Murlocs",
	--murloc_trigger1 = "By the tides!",
	--murloc_trigger2 = "Destroy them, my subjects!",
	murloc_message = "Murlocs kommen!",
	murloc_soon_message = "Murlocs bald!",
	murloc_engaged = "%s angegriffen, Murlocs in ~40sec",

	--grobules_trigger1 = "Soon it will be finished!",
	--grobules_trigger2 = "There is nowhere to hide!",
	grobules_message = "Wasserkugeln kommen!",
	grobules_warning = "Wasserkugeln bald!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "심연의 해일이 집어삼키리라!",

	tidal = "해일",
	tidal_desc = "모로그림의 해일 시전 시 경고합니다.",
	tidal_trigger = "겅둥파도 모로그림|1이;가; 해일 시전을 시작합니다.",
	tidal_message = "해일!",

	grave = "수중 무덤",
	grave_desc = "수중 무덤에 걸린 사람과 지속시간을 알림니다.",
	grave_trigger = "^([^|;%s]*)(.*)수중 무덤에 걸렸습니다%.$",
	grave_message = "수중 무덤: %s",
	grave_bar = "수중 무덤",
	grave_nextbar = "~무덤 대기시간",

	murloc = "멀록 등장",
	murloc_desc = "멀록 등장에 대한 경고입니다.",
	murloc_bar = "~멀록 등장 대기시간",
	murloc_trigger1 = "바다의 힘으로!",
	murloc_trigger2 = "나의 피조물들아, 놈들을 파괴하라!",
	murloc_message = "멀록 등장!",
	murloc_soon_message = "잠시 후 멀록 등장!",
	murloc_engaged = "%s 전투 시작, 약 40초 후 멀록",

	grobules = "물방울 등장",
	grobules_desc = "물방울 등장에 대한 경고입니다.",
	grobules_trigger1 = "곧 끝장내주마!",
	grobules_trigger2 = "숨을 곳은 아무 데도 없다!",
	grobules_message = "물방울 등장!",
	grobules_warning = "잠시 후 물방울!",
	grobules_bar = "물방울 사라짐",

} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Que les flots des profondeurs vous emportent !", -- à vérifier

	tidal = "Raz-de-marée",
	tidal_desc = "Préviens quand Morogrim lance un Raz-de-marée.",
	tidal_trigger = "Morogrim Marcheur-des-flots commence à lancer Raz-de-marée.",
	tidal_message = "Raz-de-marée !",

	grave = "Tombeau aquatique",
	grave_desc = "Préviens quand quelqu'un subit le Tombeau aquatique et indique sa durée.",
	grave_trigger = "^([^%s]+) ([^%s]+) les effets .* Tombeau aquatique%.$",
	grave_message = "Tombeau aquatique : %s",
	grave_bar = "Tombeaux aquatique",
	grave_nextbar = "~Cooldown Tombeaux",

	murloc = "Murlocs",
	murloc_desc = "Préviens de l'arrivée des murlocs.",
	murloc_bar = "~Cooldown Murlocs",
	murloc_trigger1 = "Par les marées !", -- à vérifier
	murloc_trigger2 = "Détruisez-les, mes sujets !", -- à vérifier
	murloc_message = "Arrivée des murlocs !",
	murloc_soon_message = "Murlocs imminent !",
	murloc_engaged = "%s engagé, murlocs dans ~40 sec.",

	grobules = "Globules",
	grobules_desc = "Préviens de l'arrivée des globules.",
	grobules_trigger1 = "Bientôt, ce sera terminé !", -- à vérifier
	grobules_trigger2 = "Il est impossible de m'échapper !", -- à vérifier
	grobules_message = "Arrivée des globules !",
	grobules_warning = "Globules imminent !",
	grobules_bar = "Disparation des globules",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "水很深，抓住你!",

	tidal = "海嘯",
	tidal_desc = "警示海嘯施放",
	tidal_trigger = "潮行者開始施放海嘯",
	tidal_message = "海嘯 - 留意 MT 血量",

	grave = "水之墓",
	grave_desc = "當玩家受到水之墓時通知團隊",
	grave_trigger = "^(.+)受到(.*)水之墓",
	grave_message = "水之墓：%s",
	grave_bar = "水之墓計時",
	grave_nextbar = "水之墓冷卻",

	murloc = "魚人警示",
	murloc_desc = "魚人來臨時警示",
	murloc_bar = "魚人冷卻",
	--murloc_trigger1 = "By the tides!",
	--murloc_trigger2 = "Destroy them, my subjects!",
	murloc_message = "魚人出現！",
	murloc_soon_message = "魚人即將出現，準備 AE！",
	murloc_engaged = "%s 開戰 - 魚人在 40 秒內出現！",

	grobules = "水珠警示",
	grobules_desc = "當水珠來臨時警示",
	--grobules_trigger1 = "Soon it will be finished!",
	--grobules_trigger2 = "There is nowhere to hide!",
	grobules_message = "水珠出現！避開水球！",
	grobules_warning = "水珠即將出現！",
	grobules_bar = "水珠消失",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.toggleoptions = {"tidal", "grave", "murloc", "grobules", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroGrave", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroTidal", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(inGrave) do inGrave[k] = nil end
		grobulealert = nil

		if self.db.profile.murloc then
			self:Message(L["murloc_engaged"]:format(boss), "Positive")
			self:Bar(L["murloc_bar"], 40, "INV_Misc_Head_Murloc_01")
		end
		if self.db.profile.grave then
			self:Bar(L["grave_nextbar"], 20, "Spell_Frost_ArcticWinds")
		end
	elseif self.db.profile.murloc and (msg == L["murloc_trigger1"] or msg == L["murloc_trigger2"]) then
		self:CancelScheduledEvent("murloc1")
		self:Message(L["murloc_message"], "Positive")
		self:Bar(L["murloc_bar"], 45, "INV_Misc_Head_Murloc_01")
		self:ScheduleEvent("murloc1", "BigWigs_Message", 41, L["murloc_soon_message"], "Attention")
	elseif self.db.profile.grobules and (msg == L["grobules_trigger1"] or msg == L["grobules_trigger2"]) then
		self:Message(L["grobules_message"], "Important", nil, "Alert")
		self:Bar(L["grobules_bar"], 36, "INV_Elemental_Primal_Water")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["tidal_trigger"] then
		self:Sync("MoroTidal")
	end
end

function mod:Event(msg)
	local gplayer, gtype = select(3, msg:find(L["grave_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = UnitName("player")
		end
		self:Sync("MoroGrave " .. gplayer)
	end
end

function mod:GraveWarn()
	if self.db.profile.grave then
		local msg = nil
		for k in pairs(inGrave) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["grave_message"]:format(msg), "Important", nil, "Alert")
		self:Bar(L["grave_nextbar"], 28.5, "Spell_Frost_ArcticWinds")
		self:Bar(L["grave_bar"], 4.5, "Spell_Frost_ArcticWinds")
	end
	for k in pairs(inGrave) do inGrave[k] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MoroGrave" and rest then
		inGrave[rest] = true
		self:ScheduleEvent("Grave", self.GraveWarn, 1.5, self)
	elseif sync == "MoroTidal" and self.db.profile.tidal then
		self:Message(L["tidal_message"], "Urgent", nil, "Alarm")
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.grobules then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 26 and health <= 30 and not grobulealert then
			self:Message(L["grobules_warning"], "Positive")
			grobulealert = true
		elseif health > 50 and grobulealert then
			grobulealert = false
		end
	end
end
