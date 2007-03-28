------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Morogrim Tidewalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local inGrave = {}
local started = nil

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Morogrim",

	enrage = "Enrage",
	enrage_desc = "Warn for the enrage after 10min.",

	tidal = "Tidal Wave",
	tidal_desc = "Warn when Morogrim casts Tidal Wave.",

	grave = "Watery Grave",
	grave_desc = "Alert who has watery grave.",

	gravealert = "Incoming Watery Grave",
	gravealert_desc = "Warn for incoming Watery Graves.",

	murloc = "Incoming Murlocs",
	murloc_desc = "Warn for incoming murlocs.",

	grobules = "Incoming Grobules",
	grobules_desc = "Warn for incoming Watery Grobules.",

	grave_trigger = "^([^%s]+) ([^%s]+) afflicted by Watery Grave",
	grave_message = "Watery Grave: %s",

	gravealert_trigger = "sends his enemies",
	gravealert_message = "Watery Graves soon!",
	grave_bar = "Watery Graves",

	murloc_bar = "Murlocs incoming",
	murloc_trigger = "Murlocs",
	murloc_message = "Incoming Murlocs!",
	murlocs_soon_message = "Murlocs soon!",

	grobules_trigger = "watery grobules",
	grobules_message = "Incoming Grobules!",

	enrage_message = "%s engaged, enrage in 10min!",
	enrage_min = "Enrage in %d min",
	enrage_sec = "Enrage in %d sec!",
	enrage_bar = "Enrage",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage = "Wutanfall",
	enrage_desc = "Warnt vor dem Wutanfall nach 10min.",

	grave = "Nasses Grab",
	grave_desc = "Zeigt an, wer im Nassen Grab ist",

	gravealert = "N\195\164chstes Nasses Grab",
	gravealert_desc = "Warnt vor dem n\195\164chsten Nassen Grab",

	murloc = "Murlocs",
	murloc_desc = "Warnt vor ankommenden Murlocs",

	grobules = "Incoming Grobules", -- to translate
	grobules_desc = "Warn for incoming Watery Grobules", -- to translate

	grave_trigger = "^([^%s]+) ([^%s]+) von Nasses Grab betroffen",
	grave_message = "Nasses Grab: %s",

	gravealert_trigger = "schickt seine Feinde",
	gravealert_message = "Nasses Grab kommt!",
	grave_bar = "Nasses Grab",

	murloc_bar = "n\195\164chste Murlocs",
	murloc_trigger = "Murlocs",
	murloc_message = "Murlocs kommen!",
	murlocs_soon_message = "Murlocs bald!",

	grobules_trigger = "watery grobules", -- to translate
	grobules_message = "Incoming Grobules!", -- to translate

	enrage_message = "%s angegriffen, Wutanfall in 10min!",
	enrage_min = "Wutanfall in %d min",
	enrage_sec = "Wunanfall in %d sec!",
	enrage_bar = "Wutanfall",
	
	tidal_trigger = "Morogrim Tidewalker begins to cast Tidal Wave.",
	tidal_message = "Tidal Wave!",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"tidal", "enrage", "grave", "gravealert", "murloc", "grobules", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	for k in pairs(inGrave) do inGrave[k] = nil end
	started = nil

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
	if self.db.profile.gravealert and msg:find(L["gravealert_trigger"]) then
		self:Message(L["gravealert_message"], "Attention", nil, "Alarm")
		self:Bar(L["grave_bar"], 30, "Spell_Frost_ArcticWinds")
	elseif self.db.profile.murloc and msg:find(L["murloc_trigger"]) then
		self:Message(L["murloc_message"], "Positive")
		self:Bar(L["murloc_bar"], 60, "INV_Misc_Head_Murloc_01")
		self:DelayedMessage(55, L["murlocs_soon_message"], "Attention")
	elseif self.db.profile.grobules and msg:find(L["grobules_trigger"]) then
		self:Message(L["grobules_message"], "Important", nil, "Alert")
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
	end
	for k in pairs(inGrave) do inGrave[k] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.enrage then
			self:Message(L["enrage_message"]:format(boss), "Important")
			self:DelayedMessage(300, L["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(600, L["enrage"], "Attention", nil, "Alarm")
			self:Bar(L["enrage_bar"], 600, "Spell_Shadow_UnholyFrenzy")
		end
		if self.db.profile.murloc then
			self:Bar(L["murloc_bar"], 60, "INV_Misc_Head_Murloc_01")
			self:DelayedMessage(55, L["murlocs_soon_message"], "Attention")
		end
	elseif sync == "MoroGrave" and rest then
		inGrave[rest] = true
		self:ScheduleEvent("Grave", self.GraveWarn, 0.5, self)
	elseif sync == "MoroTidal" and self.db.profile.tidal then
		self:Message(L["tidal_message"], "Urgent", nil, "Alarm")
	end
end

