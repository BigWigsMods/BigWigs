--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Lurker Below", 548, 1568)
if not mod then return end
mod:RegisterEnableMob(21217, 21873, 21865) --Lurker, Coilfang Guardian, Coilfang Ambusher
mod:SetAllowWin(true)
mod:SetEncounterID(2459)

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_warning = "%s Engaged - Possible Dive in 90sec"

	L.dive = "Dive"
	L.dive_desc = "Timers for when The Lurker Below dives."
	L.dive_icon = "Spell_Frost_ArcticWinds"
	L.dive_warning = "Possible Dive in %dsec!"
	L.dive_bar = "~Dives in"
	L.dive_message = "Dives - Back in 60sec"

	L.spout = "Spout"
	L.spout_desc = "Timers for Spout, may not always be accurate."
	L.spout_icon = "INV_Weapon_Rifle_02"
	L.spout_message = "Casting Spout!"
	L.spout_warning = "Possible Spout in ~3sec!"
	L.spout_bar = "~Spout"

	L.emerge_warning = "Back in %dsec"
	L.emerge_message = "Back - Possible Dive in 90sec"
	L.emerge_bar = "Back in"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"dive",
		"spout",
		37660, -- Whirl
		37478, -- Geyser
		"proximity",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "Whirl", 37363)
	self:Log("SPELL_MISSED", "Whirl", 37363)
	self:Log("SPELL_CAST_SUCCESS", "Geyser", 37478)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Death("Win", 21217)

	-- For the first pull, you can go in to combat
	-- with the boss before the module enables
	if InCombatLockdown() then
		self:CheckForEngage()
	end
end

function mod:OnEngage()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	phase = 1

	self:CDBar(37478, 11) -- Geyser
	self:CDBar(37660, 17) -- Whirl

	self:DelayedMessage("spout", 34, "yellow", L["spout_warning"])
	self:Bar("spout", 37, L["spout_bar"], "INV_Weapon_Rifle_02")

	self:MessageOld("dive", "yellow", nil, L["engage_warning"]:format(self.displayName), false)
	local dwarn = L["dive_warning"]
	self:DelayedMessage("dive", 30, "green", (dwarn):format(60))
	self:DelayedMessage("dive", 60, "green", (dwarn):format(30))
	self:DelayedMessage("dive", 80, "green", (dwarn):format(10))
	self:DelayedMessage("dive", 85, "orange", (dwarn):format(5), false, "alarm")
	self:Bar("dive", 90, L["dive_bar"], "Spell_Frost_ArcticWinds")

	self:ScheduleTimer("ScanForLurker", 85)

	self:OpenProximity("proximity", 10)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local last = 0
	function mod:Whirl()
		local time = GetTime()
		if (time - last) > 10 then
			last = time
			self:CDBar(37660, 17)
		end
	end
end

function mod:Geyser(args)
	self:MessageOld(args.spellId, "yellow")
	self:Bar(args.spellId, 11)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, _, sender)
	if sender == self.displayName then
		self:Bar("spout", 20, L["spout_message"], "Spell_Frost_ChillingBlast")
		self:Bar("spout", 50, L["spout_bar"], "Spell_Frost_ChillingBlast")
		self:MessageOld("spout", "red", "warning", L["spout_message"], 37433)
		self:DelayedMessage("spout", 47, "yellow", L["spout_warning"])

		self:CDBar(37660, 22.7) -- Whirl
		self:CDBar(37478, 25.3) -- Geyser
	end
end

do
	-- :CancelAllTimers kills CheckForWipe, so manually cancel all messages
	function mod:CancelAllMessages()
		for text, timer in next, self.scheduledMessages do
			self:CancelTimer(timer)
			self.scheduledMessages[text] = nil
		end
	end

	local timer = nil
	function mod:ScanForLurker()
		local unit = self:GetUnitIdByGUID(21217)
		if phase == 1 and (not unit or not UnitExists(unit)) then
			self:CancelAllMessages()
			self:CancelTimer(timer)
			timer = nil
			self:ScheduleTimer("ScanForLurker", 3)
			self:LurkerDown()
		elseif phase == 2 and (unit and UnitExists(unit)) then
			self:CancelAllMessages()
			self:CancelTimer(timer)
			timer = nil
			self:ScheduleTimer("ScanForLurker", 85)
			self:LurkerUp()
		elseif not timer then
			timer = self:ScheduleRepeatingTimer("ScanForLurker", 1)
		end
	end
end

function mod:LurkerDown()
	self:CloseProximity()
	self:StopBar(L["dive_bar"])
	self:StopBar(L["spout_bar"])
	self:StopBar(37660) -- Whirl
	self:StopBar(37478) -- Geyser
	phase = 2

	self:MessageOld("dive", "cyan", "info", L["dive_message"], false)
	local ewarn = L["emerge_warning"]
	self:DelayedMessage("dive", 34, "green", (ewarn):format(30))
	self:DelayedMessage("dive", 54, "green", (ewarn):format(10))
	self:DelayedMessage("dive", 59, "orange", (ewarn):format(5), false, "alert")
	self:Bar("dive", 64, L["emerge_bar"], "Spell_Frost_Stun")

	self:CDBar("spout", 65, L["spout_bar"], "Spell_Frost_ChillingBlast")
end

function mod:LurkerUp()
	self:StopBar(L["emerge_bar"])
	self:StopBar(L["spout_bar"])
	phase = 1

	self:MessageOld("dive", "cyan", "long", L["emerge_message"], false)
	local dwarn = L["dive_warning"]
	self:DelayedMessage("dive", 30, "green", (dwarn):format(60))
	self:DelayedMessage("dive", 60, "green", (dwarn):format(30))
	self:DelayedMessage("dive", 80, "green", (dwarn):format(10))
	self:DelayedMessage("dive", 85, "orange", (dwarn):format(5), false, "alarm")
	self:Bar("dive", 90, L["dive_bar"], "Spell_Frost_ArcticWinds")

	self:MessageOld("spout", "yellow", nil, CL.soon:format(L["spout"]), false)

	self:OpenProximity("proximity", 10)
end
