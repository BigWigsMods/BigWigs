------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Morogrim Tidewalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local inGrave = {}
local started = nil
local grobulealert

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Morogrim",

	tidal = "Tidal Wave",
	tidal_desc = "Warn when Morogrim casts Tidal Wave.",

	grave = "Watery Grave",
	grave_desc = "Alert who has watery grave and durations.",

	murloc = "Incoming Murlocs",
	murloc_desc = "Warn for incoming murlocs.",

	grobules = "Incoming Grobules",
	grobules_desc = "Warn for incoming Watery Grobules.",

	grave_trigger1 = "^([^%s]+) ([^%s]+) afflicted by Watery Grave",
	grave_trigger2 = "sends his enemies",
	grave_message = "Watery Grave: %s",
	grave_bar = "Watery Graves",
	grave_nextbar = "~Graves Cooldown",

	murloc_bar = "~Murlocs Cooldown",
	murloc_trigger = "Murlocs",
	murloc_message = "Incoming Murlocs!",
	murloc_soon_message = "Murlocs soon!",
	murloc_engaged = "%s Engaged, Murlocs in ~40sec",

	grobules_trigger = "summons",
	grobules_message = "Incoming Grobules!",
	grobules_warning = "Grobules Soon!",
	grobules_bar = "Grobules Despawn",

	tidal_trigger = "Morogrim Tidewalker begins to cast Tidal Wave.",
	tidal_message = "Tidal Wave!",
} end )

L:RegisterTranslations("deDE", function() return {

	tidal = "Gezeitenwelle",
	tidal_desc = "Warnt, wenn Morogrim Gezeitenwelle benutzt.",

	grave = "Nasses Grab",
	grave_desc = "Zeigt an, wer im Nassen Grab ist und wie lange.",

	murloc = "Murlocs",
	murloc_desc = "Warnt vor ankommenden Murlocs.",

	grobules = "Wasserkugeln",
	grobules_desc = "Warnt vor Wasserkugeln.",

	grave_trigger1 = "^([^%s]+) ([^%s]+) von Nasses Grab betroffen",
	grave_trigger2 = "schickt seine Feinde",
	grave_message = "Nasses Grab: %s",
	grave_bar = "Nasses Grab",
	grave_nextbar = "n\195\164chstes Nasses Grab",

	murloc_bar = "n\195\164chste Murlocs",
	murloc_trigger = "Murlocs",
	murloc_message = "Murlocs kommen!",
	murloc_soon_message = "Murlocs bald!",
	murloc_engaged = "%s angegriffen, Murlocs in ~40sec",

	grobules_trigger = "Wasserkugeln",
	grobules_message = "Wasserkugeln kommen!",
	grobules_warning = "Wasserkugeln bald!",
} end )

L:RegisterTranslations("koKR", function() return {
	tidal = "해일",
	tidal_desc = "모고그림의 해일 시전시 경고",

	grave = "수중 무덤",
	grave_desc = "수중 무덤에 걸린 사람과 지속시간 알림",

	murloc = "멀록 등장",
	murloc_desc = "멀록 등장에 대한 경고",

	grobules = "물방울 등장",
	grobules_desc = "물방울 등장에 대한 경고",

	grave_trigger1 = "^([^|;%s]*)(.*)수중 무덤에 걸렸습니다%.$",
	grave_trigger2 = "자신의 적을 수중 무덤으로 내몹니다!",
	grave_message = "수중 무덤: %s",
	grave_bar = "수중 무덤",
	grave_nextbar = "~무덤 대기시간",

	murloc_bar = "~멀록 등장 대기시간",
	murloc_trigger = "멀록들",
	murloc_message = "멀록 등장!",
	murloc_soon_message = "잠시 후 멀록 등장!",
	murloc_engaged = "%s 전투 시작, 약 40초 후 멀록",

	grobules_trigger = "물방울",
	grobules_message = "물방울 등장!",
	grobules_warning = "잠시 후 물방울!",
	grobules_bar = "물방울 사라짐",

	tidal_trigger = "겅둥파도 모로그림|1이;가; 해일 시전을 시작합니다.",
	tidal_message = "해일!",
} end )

L:RegisterTranslations("frFR", function() return {
	tidal = "Raz-de-marée",
	tidal_desc = "Préviens quand Morogrim lance un Raz-de-marée.",

	grave = "Tombeau aquatique",
	grave_desc = "Préviens quand quelqu'un subit le Tombeau aquatique et indique sa durée.",

	murloc = "Arrivée des murlocs",
	murloc_desc = "Préviens de l'arrivée des murlocs.",

	grobules = "Arrivée des globules",
	grobules_desc = "Préviens de l'arrivée des globules.",

	grave_trigger1 = "^([^%s]+) ([^%s]+) les effets .* Tombeau aquatique",
	grave_trigger2 = "envoye ses ennemis", -- à vérifier
	grave_message = "Tombeau aquatique : %s",
	grave_bar = "Tombeaux aquatique",
	grave_nextbar = "~Cooldown Tombeaux",

	murloc_bar = "~Cooldown Murlocs",
	murloc_trigger = "Murlocs",
	murloc_message = "Arrivée des murlocs !",
	murloc_soon_message = "Murlocs imminent !",
	murloc_engaged = "%s engagé, murlocs dans ~40 sec.",

	grobules_trigger = "invoque", -- à vérifier
	grobules_message = "Arrivée des globules !",
	grobules_warning = "Globules imminent !",
	grobules_bar = "Disparation des globules",

	tidal_trigger = "Morogrim Marcheur-des-flots commence à lancer Raz-de-marée.",
	tidal_message = "Raz-de-marée !",
} end )

----------------------------------
--    Module Declaration   --
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
	for k in pairs(inGrave) do inGrave[k] = nil end
	started = nil
	grobulealert = nil
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroGrave", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroTidal", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["tidal_trigger"] then
		self:Sync("MoroTidal")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.grave and msg:find(L["grave_trigger2"]) then
		self:Bar(L["grave_nextbar"], 30, "Spell_Frost_ArcticWinds")
		self:Bar(L["grave_bar"], 6, "Spell_Frost_ArcticWinds")
	elseif self.db.profile.murloc and msg:find(L["murloc_trigger"]) then
		self:CancelScheduledEvent("murloc1")
		self:Message(L["murloc_message"], "Positive")
		self:Bar(L["murloc_bar"], 45, "INV_Misc_Head_Murloc_01")
		self:ScheduleEvent("murloc1", "BigWigs_Message", 41, L["murloc_soon_message"], "Attention")
	elseif self.db.profile.grobules and msg:find(L["grobules_trigger"]) then
		self:Message(L["grobules_message"], "Important", nil, "Alert")
		self:Bar(L["grobules_bar"], 36, "INV_Elemental_Primal_Water")
	end
end

function mod:Event(msg)
	local gplayer, gtype = select(3, msg:find(L["grave_trigger1"]))
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
	end
	for k in pairs(inGrave) do inGrave[k] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.murloc then
			self:Message(L["murloc_engaged"]:format(boss), "Positive")
			self:Bar(L["murloc_bar"], 40, "INV_Misc_Head_Murloc_01")
		end
		if self.db.profile.grave then
			self:Bar(L["grave_nextbar"], 20, "Spell_Frost_ArcticWinds")
		end
	elseif sync == "MoroGrave" and rest then
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
