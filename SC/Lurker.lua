------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Lurker Below"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Lurker",

	dive = "Dive",
	dive_desc = ("Timers for when %s dives.\n\nThese timers my be innacurate, they are scheduled from pull."):format(boss),

	spout = "Spout",
	spout_desc = "Timers for Spout.\n\nThese timers my be innacurate, they are scheduled from pull.",

	whirl = "Whirl",
	whirl_desc = "Whirl Timers",

	engage_warning = "%s Engaged - Possible Dive in 90sec",

	dive_warning = "Possible Dive in %dsec!",
	dive_bar = "~Dives in",
	dive_message = "Dives - Back in 60sec",

	emerge_warning = "Back in %dsec",
	emerge_message = "Back - Possible Dive in 90sec",
	emerge_bar = "Back in",

	spout_message1 = "Casting Spout!",
	spout_message2 = "Spout Over!",
	spout_warning = "Spout in 3sec!",
	spout_bar1 = "Spout 1 in ~",
	spout_bar2 = "Spout 2 in ~",

	whirl_bar = "Possible Whirl",
	whirl_trigger = "Whirl",

	["Coilfang Guardian"] = true,
	["Coilfang Ambusher"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
 
	dive = "잠수",
	dive_desc = ("%s 초 후 잠수 타이머.\n\n이 타이머는 풀링 시점에 맞춰서 작동하기에 정확하지 않습니다."):format(boss),

	spout = "분출",
	spout_desc = "분출 타이머.\n\n이 타이머는 풀링 시점에 맞춰서 작동하기에 정확하지 않습니다.)",

	engage_warning = "%s 전투 시작 - 90초 이내 잠수",

	dive_warning = "%d초 안에 잠수!",
	dive_bar = "~ 잠수",
	dive_message = "잠수 - 60초후에 출현합니다.",

	emerge_warning = "%d초 이내 출현",
	emerge_message = "출현 - 90초 이내 잠수",
	emerge_bar = "출현",

	spout_message1 = "분출!",
	spout_message2 = "분출 종료!",
	spout_warning = "3초내에 분출!",
	spout_bar1 = "분출 1",
	spout_bar2 = "분출 2",

	["Coilfang Guardian"] = "갈퀴송곳니 수호자",
	["Coilfang Ambusher"] = "갈퀴송곳니 복병",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.wipemobs = {L["Coilfang Guardian"], L["Coilfang Ambusher"]}
mod.toggleoptions = {"dive", "spout", "whirl", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	started = nil
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:NextDive()
		if self.db.profile.dive then
			self:Message(L["engage_warning"]:format(boss), "Attention")
		end
		if self.db.profile.whirl then
			self:Bar(L["whirl_bar"], 17, "Ability_Whirlwind")
		end
		if self.db.profile.spout then
			self:DelayedMessage(42, L["spout_warning"], "Attention")
			self:DelayedMessage(45, L["spout_message1"], "Attention")
			self:DelayedMessage(65, L["spout_message2"], "Positive")
			self:Bar(L["spout_bar1"], 45, "INV_Weapon_Rifle_02")
			self:ScheduleEvent("bwspoutbar0", self.SpoutBar, 45, self)
		end
	end
end

--loop diving and lazer, no combat log events to register this, can become innacurate
function mod:NextDive()
	if self.db.profile.dive then
		self:DelayedMessage(30, L["dive_warning"]:format(60), "Positive")
		self:DelayedMessage(60, L["dive_warning"]:format(30), "Positive")
		self:DelayedMessage(80, L["dive_warning"]:format(10), "Positive")
		self:DelayedMessage(85, L["dive_warning"]:format(5), "Urgent", nil, "Alarm")
		self:Bar(L["dive_bar"], 90, "Spell_Frost_ArcticWinds")
	end

	self:ScheduleEvent(self.NextSurface, 90, self)
end

function mod:NextSurface()
	if self.db.profile.dive then
		self:Message(L["dive_message"], "Attention")
		self:DelayedMessage(30, L["emerge_warning"]:format(30), "Positive")
		self:DelayedMessage(50, L["emerge_warning"]:format(10), "Positive")
		self:DelayedMessage(55, L["emerge_warning"]:format(5), "Urgent", nil, "Alert")
		self:DelayedMessage(60, L["emerge_message"], "Attention")
		self:Bar(L["emerge_bar"], 60, "Spell_Frost_Stun")
	end
	if self.db.profile.spout then
		self:Bar(L["spout_bar1"], 70, "INV_Weapon_Rifle_02")
		self:Bar(L["spout_bar2"], 120, "INV_Weapon_Rifle_02")
		self:DelayedMessage(67, L["spout_warning"], "Attention")
		self:DelayedMessage(70, L["spout_message1"], "Attention")
		self:DelayedMessage(90, L["spout_message2"], "Positive")
		self:DelayedMessage(117, L["spout_warning"], "Attention")
		self:DelayedMessage(120, L["spout_message1"], "Attention")
		self:DelayedMessage(140, L["spout_message2"], "Positive")
		self:ScheduleEvent("bwspoutbar1", self.SpoutBar, 70, self)
		self:ScheduleEvent("bwspoutbar2", self.SpoutBar, 120, self)
	end

	self:ScheduleEvent(self.NextDive, 60, self)
end

function mod:SpoutBar()
	self:Bar(L["spout_message1"], 20, "INV_Weapon_Rifle_02")
end

function mod:Event(msg)
	if self.db.profile.whirl and msg:find(L["whirl_trigger"]) then
		self:Bar(L["whirl_bar"], 17, "Ability_Whirlwind")
	end
end
