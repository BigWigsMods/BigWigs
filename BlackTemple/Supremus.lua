------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Supremus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local started = nil

local UnitName = UnitName
local UnitExists = UnitExists

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Supremus",

	phase = "Phases",
	phase_desc = "Warn about the different phases.",

	punch = "Molten Punch",
	punch_desc = "Alert when he does Molten Punch, and display a countdown bar.",

	target = "Target",
	target_desc = "Warn who he targets during the kite phase, and put a raid icon on them.",

	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Supremus punches the ground in anger!",

	kite_phase_message = "Supremus loose!",
	kite_phase_trigger = "The ground begins to crack open!",

	next_phase_bar = "Next phase",
	next_phase_message = "Phase change in 10sec!",

	target_trigger = "Supremus acquires a new target!",
	target_message = "%s being chased!",
	target_message_nounit = "New target!",

	punch_message = "Punch!",
	punch_trigger = "Supremus casts Molten Punch.",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = { "punch", "target", "phase", "enrage", "bosskill" }
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SupPunch", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["punch_trigger"] then
		self:Sync("SupPunch")
	end
end

local function findTarget()
	if UnitName("target") == boss then
		return UnitName("targettarget")
	elseif UnitName("focus") == boss then
		return UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			local unit = ("raid%starget"):format(num)
			if UnitExists(unit) and UnitName(unit) == boss then
				return UnitName(unit .. "target")
			end
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["normal_phase_trigger"] and self.db.profile.phase then
		self:Message(L["normal_phase_message"], "Positive")
		self:Bar(L["next_phase_bar"], 60, "INV_Helmet_08")
		self:DelayedMessage(50, L["next_phase_message"], "Attention")
	elseif msg == L["kite_phase_trigger"] and self.db.profile.phase then
		self:Message(L["kite_phase_message"], "Positive")
		self:Bar(L["next_phase_bar"], 60, "Spell_Fire_MoltenBlood")
		self:DelayedMessage(50, L["next_phase_message"], "Attention")
	elseif msg == L["target_trigger"] and self.db.profile.target then
		local name = findTarget()
		if name then
			self:Message(L["target_message"]:format(name), "Important")
		else
			self:Message(L["target_message_nounit"], "Important")
		end
		self:Icon(name)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "SupPunch" then
		if not self.db.profile.punch then return end
		self:Message(L["punch_message"], "Attention")
		self:Bar(L["punch_message"], 10, "Spell_Frost_FreezingBreath")
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:Bar(L["next_phase_bar"], 60, "Spell_Fire_MoltenBlood")
			self:DelayedMessage(50, L["next_phase_message"], "Attention")
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 15), "Attention")
			self:DelayedMessage(300, L2["enrage_min"]:format(10), "Positive")
			self:DelayedMessage(600, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(840, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(870, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(890, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(895, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(900, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 900, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

