------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Sapphiron")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "sapphiron",

	engage_warn = "Sapphiron engaged! 10-24sec to Life Drain!",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Sapphiron begins to cast Deep Breath.",

	lifedrain_cmd = "lifedrain",
	lifedrain_name = "Life Drain",
	lifedrain_desc = "Warns about the Life Drain curse.",

	lifedrain_message = "Life Drain! ~24 seconds until next!",
	lifedrain_warn1 = "Life Drain in 5sec!",
	lifedrain_bar = "Life Drain",
	lifedrain_trigger = "afflicted by Life Drain",
	lifedrain_trigger2 = "Life Drain was resisted",

	deepbreath_trigger = "%s takes in a deep breath...",
	deepbreath_warning = "Deep Breath incoming!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSapphiron = BigWigs:NewModule(boss)
BigWigsSapphiron.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsSapphiron.enabletrigger = boss
BigWigsSapphiron.toggleoptions = { "lifedrain", "deepbreath", "bosskill" }
BigWigsSapphiron.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

--[[
--
24, 24, 49, 24
16, 24, 48
18, 24, 
18, 24
12, 24, 44, 24, 24, 60, 24, 24, 44, 24

It seems the first Life Drain happens at 10-24sec, then one at 24sec
Then he lifts for a little while.

]]

function BigWigsSapphiron:OnEnable()

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "LifeDrain")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SapphironStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "SapphironLifeDrain", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSapphiron:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Sapphiron_CheckStart")
	if go then
		self:CancelScheduledEvent("Sapphiron_CheckStart")
		self:TriggerEvent("BigWigs_SendSync", "SapphironStart")
	elseif not running then
		self:ScheduleRepeatingEvent("Sapphiron_CheckStart", self.PLAYER_REGEN_DISABLED, .5, self )
	end
end

function BigWigsSapphiron:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Sapphiron_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Sapphiron_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsSapphiron:Scan()
	if UnitName("target") == boss and UnitAffectingCombat("target") then
		return true
	elseif UnitName("playertarget") == boss and UnitAffectingCombat("playertarget") then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == (boss) and UnitAffectingCombat("raid"..i.."target") then
				return true
			end
		end
	end
	return false
end

function BigWigsSapphiron:BigWigs_RecvSync( sync, rest, nick )
	if sync == "SapphironStart" and self.db.profile.lifedrain then
		self:TriggerEvent("BigWigs_Message", L["engage_warn"], "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L["lifedrain_bar"], 24, "Interface\\Icons\\Spell_Shadow_LifeDrain02", "Yellow", "Orange", "Red")
	elseif sync == "SapphironLifeDrain" and self.db.profile.lifedrain then
		self:TriggerEvent("BigWigs_StopBar", L["lifedrain_bar"])
		self:TriggerEvent("BigWigs_Message", L["lifedrain_message"], "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L["lifedrain_bar"], 24, "Interface\\Icons\\Spell_Shadow_LifeDrain02", "Yellow", "Orange", "Red")
	end
end

function BigWigsSapphiron:LifeDrain(msg)
	if string.find(msg, L["lifedrain_trigger"]) or string.find(msg, L["lifedrain_trigger2"]) then
		self:TriggerEvent("BigWigs_SendSync", "SapphironLifeDrain")
	end
end

function BigWigsSapphiron:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["deepbreath_trigger"] then
		if self.db.profile.deepbreath then self:TriggerEvent("BigWigs_Message", L["deepbreath_warning"], "Red") end
	end
end

