------------------------------
--      Are you local?    --
------------------------------
local boss = AceLibrary("Babble-Boss-2.2")["Leotheras the Blind"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local imagewarn
local wwhelp = 0

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Leotheras",

	enrage = "Enrage",
	enrage_desc = "Time untill enrage",

	whirlwind = "Whirlwind",
	whirlwind_desc = "Whirlwind Timers",

	phase = "Demon Phase",
	phase_desc = "Estimated demon phase timers",

	image = "Image",
	image_desc = "20% Image alerts",

	whisper = "Insidious Whisper",
	whisper_desc = "Alert what players have Insidious Whisper",

	enrage_trigger = "Finally, my banishment ends!",
	enrage_message = "%s Engaged - Enrage in 10min",
	enrage_min = "Enrage in %d min",
	enrage_sec = "Enrage in %d sec",

	whirlwind_trigger = "Leotheras the Blind gains Whirlwind",
	whirlwind_gain = "Whirlwind for 12 sec",
	whirlwind_fade = "Whirlwind Over",
	whirlwind_bar = "Whirlwind",
	whirlwind_bar2 = "next Whirlwind",
	whirlwind_warn = "Whirlwind soon",

	phase_trigger = "I am in control now",
	phase_demon = "Demon Phase for 60sec",
	phase_demonsoon = "Demon Phase in 5sec!",
	phase_normal = "Normal Phase in 5sec",
	demon_bar = "Demon",
	demon_nextbar = "Next Demon Phase",

	image_trigger = "I am the master! Do you hear?",
	image_message = "Image Created!",
	image_warning = "Image Soon!",

	whisper_trigger = "^([^%s]+) ([^%s]+) afflicted by Insidious Whisper",
	whisper_message = "InnerDemon: %s",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "whirlwind", "phase", "image", "whisper", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")


	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LeoWhisp", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "LeoWW", 4)

	self:RegisterEvent("UNIT_HEALTH")
	imagewarn = nil
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"]:format(boss), "Important")
		self:DelayedMessage(300, L["enrage_min"]:format(5), "Positive")
		self:DelayedMessage(420, L["enrage_min"]:format(3), "Positive")
		self:DelayedMessage(540, L["enrage_min"]:format(1), "Positive")
		self:DelayedMessage(570, L["enrage_sec"]:format(30), "Positive")
		self:DelayedMessage(590, L["enrage_sec"]:format(10), "Urgent")
		self:DelayedMessage(600, L["enrage"], "Attention", nil, "Alarm")
		self:Bar(L["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(3, L["whirlwind_warn"], "Attention")
		wwhelp = 0
		self:ScheduleEvent("bwdemon", self.DemonSoon, 16, self)
	elseif self.db.profile.phase and msg:find(L["phase_trigger"]) then
		self:Message(L["phase_demon"], "Attention")
		self:DelayedMessage(55, L["phase_normal"], "Important")
		self:DelayedMessage(61, L["whirlwind_warn"], "Attention")
		self:Bar(L["demon_bar"], 60, "Spell_Shadow_Metamorphosis")
		self:ScheduleEvent("bwdemon", self.DemonSoon, 60, self)
		wwhelp = 0
	elseif msg:find(L["image_trigger"]) then
		self:CancelScheduledEvent("bwdemon")
		if self.db.profile.image then
			self:Message(L["phase_demon"], "Important")
		end
	end
end

function mod:DemonSoon()
	self:DelayedMessage(55, L["phase_demonsoon"], "Urgent")
	self:Bar(L["demon_nextbar"], 60, "Spell_Shadow_Metamorphosis")
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["whirlwind_trigger"]) then
		self:Sync("LeoWW")
	end
end

function mod:WhirlwindBar()
	self:Bar(L["whirlwind_bar2"], 18, "Ability_Whirlwind")
	self:DelayedMessage(18, L["whirlwind_warn"], "Attention")
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.image then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 21 and health <= 24 and not imagewarn then
			self:Message(L["image_warning"], "Urgent")
			imagewarn = true
		elseif health > 30 and imagewarn then
			imagewarn = false
		end
	end
end

function mod:Event(msg)
	local wplayer, wtype = select(3, msg:find(L["whisper_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = UnitName("player")
		end
		self:Sync("LeoWhisp "..wplayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "LeoWhisp" and rest and self.db.profile.whisper then
		self:Message(L["whisper_message"]:format(rest), "Attention")
		self:Bar(L["whisper_message"], 30, "Spell_Shadow_ManaFeed")
	elseif sync == "LeoWW" and self.db.profile.whirlwind then
		self:Message(L["whirlwind_gain"], "Important", nil, "Alert")
		self:DelayedMessage(12, L["whirlwind_fade"], "Attention")
		self:Bar(L["whirlwind_bar"], 12, "Ability_Whirlwind")
		if wwhelp == 0 or imagewarn then
			self:ScheduleEvent("bwwhirlwind", self.WhirlwindBar, 12, self)
		end
		wwhelp = 1
	end
end
