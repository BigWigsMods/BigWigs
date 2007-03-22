------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Morogrim Tidewalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Morogrim",

	grave = "Watery Grave",
	grave_desc = "Alert who has watery grave",

	gravealert = "Incoming Watery Grave",
	gravealert_desc = "Warn for incoming Watery Graves",

	murloc = "Incoming Murlocs",
	murloc_desc = "Warn for incoming murlocs",

	grobules = "Incoming Grobules",
	grobules_desc = "Warn for incoming Watery Grobules",

	grave_trigger = "^([^%s]+) ([^%s]+) afflicted by Watery Grave",
	grave_message = "Watery Grave: %s",

	gravealert_trigger = "sends his enemies",
	gravealert_message = "Incoming Watery Graves!",

	murloc_trigger = "Murlocs",
	murloc_message = "Incoming Murlocs!",

	grobules_trigger = "watery grobules",
	grobules_message = "Incoming Grobules!",

	you = "You",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"grave", "gravealert", "murloc", "grobules", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MorogrimGrave", 7)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.gravealert and msg:find(L["gravealert_trigger"]) then
		self:Message(L["gravealert_message"], "Attention", nil, "Alarm")
	elseif self.db.profile.murloc and msg:find(L["murloc_trigger"]) then
		self:Message(L["murloc_message"], "Positive")
	elseif self.db.profile.grobules and msg:find(L["grobules_trigger"]) then
		self:Message(L["grobules_message"], "Important", nil, "Alert")
	end
end

function mod:Event(msg)
	local gplayer, gtype = select(3, msg:find(L["grave_trigger"]))
	if gplayer then
		if gplayer == L["you"] then
			gplayer = UnitName("player")
		end
		self:Sync("MorogrimGrave "..gplayer)
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "MorogrimGrave" and rest and self.db.profile.grave then
		self:Message(L["grave_message"]:format(rest), "Urgent")
		self:Bar(L["grave_message"]:format(rest), 5, "Spell_Shadow_DemonBreath")
	end
end

