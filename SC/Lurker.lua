------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Lurker Below"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started
local supress
local found
local occured

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Lurker",

	engage_warning = "%s Engaged - Possible Dive in 90sec",

	dive = "Dive",
	dive_desc = ("Timers for when %s dives."):format(boss),
	dive_warning = "Possible Dive in %dsec!",
	dive_bar = "~Dives in",
	dive_message = "Dives - Back in 60sec",

	spout = "Spout",
	spout_desc = "Timers for Spout, may not always be accurate.",
	spout_trigger = "%s takes a deep breath!",
	spout_message = "Casting Spout!",
	spout_warning = "Posible Spout in ~3sec!",
	spout_bar = "Possible Spout",

	whirl = "Whirl",
	whirl_desc = "Whirl Timers",
	whirl_bar = "Possible Whirl",

	emerge_warning = "Back in %dsec",
	emerge_message = "Back - Possible Dive in 90sec",
	emerge_bar = "Back in",

	["Coilfang Guardian"] = true,
	["Coilfang Ambusher"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	dive = "잠수",
	dive_desc = ("%s 초 후 잠수 타이머."):format(boss),

	spout = "분출",
	--spout_desc = "분출 타이머.\n\n이 타이머는 풀링 시점에 맞춰서 작동하기에 정확하지 않습니다.)", --enUS changed

	whirl = "소용돌이",
	whirl_desc = "소용돌이 타이머",

	engage_warning = "%s 전투 시작 - 90초 이내 잠수",

	dive_warning = "%d초 이내 잠수!",
	dive_bar = "~잠수",
	dive_message = "잠수 - 60초 이내 출현",

	emerge_warning = "%d초 이내 출현",
	emerge_message = "출현 - 90초 이내 잠수",
	emerge_bar = "출현",

	spout_message = "분출 시전!",
	spout_warning = "3초 이내 분출!",

	whirl_bar = "소용돌이 주의",

	["Coilfang Guardian"] = "갈퀴송곳니 수호자",
	["Coilfang Ambusher"] = "갈퀴송곳니 복병",
} end )

L:RegisterTranslations("frFR", function() return {
	dive = "Plong\195\169es",
	dive_desc = ("D\195\169lais avant que %s ne plonge."):format(boss),

	spout = "Jet",
	--spout_desc = "D\195\169lais concernant les Jets.\n\nCes délais peuvent \195\170tre impr\195\169cis : ils sont bas\195\169s sur le moment du pull.", --enUS changed

	whirl = "Tourbillonnement",
	whirl_desc = "D\195\169lais concernant les Tourbillonnements.",

	engage_warning = "%s engag\195\169 - Plong\195\169e probable dans 90 sec.",

	dive_warning = "Plong\195\169e probable dans %d sec. !",
	dive_bar = "~Plonge dans",
	dive_message = "Plong\195\169e - De retour dans 60 sec.",

	emerge_warning = "De retour dans %d sec.",
	emerge_message = "De retour - Plong\195\169e probable dans 90 sec.",
	emerge_bar = "De retour dans",

	spout_message = "Incante un Jet !",
	spout_warning = "Jet dans 3 sec. !",

	whirl_bar = "Tourbillonnement probable",

	["Coilfang Guardian"] = "Gardien de Glisseroc",
	["Coilfang Ambusher"] = "Embusqu\195\169 de Glisseroc",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.wipemobs = {L["Coilfang Guardian"], L["Coilfang Ambusher"]}
mod.toggleoptions = {"dive", "spout", "whirl", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LurkWhirl", 10)
	started = nil
	supress = nil
	found = nil
	occured = nil
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
			self:DelayedMessage(37, L["spout_warning"], "Attention")
			self:Bar(L["spout_bar1"], 40, "INV_Weapon_Rifle_02")
		end
		found = nil
		occured = nil
		self:ScheduleRepeatingEvent("BWLurkerTargetSeek", self.DiveCheck, 0.2, self)
	elseif sync == "LurkWhirl" and self.db.profile.whirl then
		self:Bar(L["whirl_bar"], 17, "Ability_Whirlwind")
	end
end

function mod:Spout()
	self:Bar(L["spout_bar"], 70, "Spell_Frost_ChillingBlast")
	self:DelayedMessage(67, L["spout_warning"], "Attention")
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["whirl"]) and not suppress then
		supress = true
		self:Sync("LurkWhirl")
		self:ScheduleEvent(self.StopSupress, 10, self)
	end
end

function mod:StopSupress()
	supress = nil
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.spout and msg == L["spout_trigger"] then
		self:Bar(L["spout_message"], 20, "Spell_Frost_ChillingBlast")
		self:Bar(L["spout_bar"], 50, "Spell_Frost_ChillingBlast")
		self:Message(L["spout_message"], "Attention")
		self:ScheduleEvent("spout1", "BigWigs_Message", 47, L["spout_warning"], "Attention")
		self:TriggerEvent("BigWigs_StopBar", self, L["whirl_bar"])
	end
end

function mod:DiveCheck()
	local num = GetNumRaidMembers()
	for i = 1, num do
		local unit = string.format("raid%starget", num)
		if UnitExists(unit) and UnitName(unit) == boss then
			found = true
		else
			found = nil
		end
	end

	if found = true and occured = true then
		if self.db.profile.dive then
			self:DelayedMessage(30, L["dive_warning"]:format(60), "Positive")
			self:DelayedMessage(60, L["dive_warning"]:format(30), "Positive")
			self:DelayedMessage(80, L["dive_warning"]:format(10), "Positive")
			self:DelayedMessage(85, L["dive_warning"]:format(5), "Urgent", nil, "Alarm")
			self:Bar(L["dive_bar"], 90, "Spell_Frost_ArcticWinds")
		end

		self:TriggerEvent("BigWigs_ShowProximity", self)
		occured = nil
	elseif found = nil and occured = nil then
		if self.db.profile.dive then
			self:Message(L["dive_message"], "Attention")
			self:DelayedMessage(30, L["emerge_warning"]:format(30), "Positive")
			self:DelayedMessage(50, L["emerge_warning"]:format(10), "Positive")
			self:DelayedMessage(55, L["emerge_warning"]:format(5), "Urgent", nil, "Alert")
			self:DelayedMessage(60, L["emerge_message"], "Attention")
			self:Bar(L["emerge_bar"], 60, "Spell_Frost_Stun")
		end

		self:TriggerEvent("BigWigs_HideProximity", self)
		self:CancelScheduledEvent("spout1")
		self:TriggerEvent("BigWigs_StopBar", self, L["spout_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["whirl_bar"])
		occured = true
		if self.db.profile.spout then
			self:Spout()
		end
	end
end
