--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Lurker Below", 548, 1568)
if not mod then return end
mod:RegisterEnableMob(21217, 21873, 21865) --Lurker, Coilfang Guardian, Coilfang Ambusher
mod:SetEncounterID(2459)

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
		"dive", "spout", 37660, "proximity"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "Whirl", 37363)
	self:Log("SPELL_MISSED", "Whirl", 37363)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:Emote("Spout", self.displayName)

	self:Death("Win", 21217)
end

function mod:OnEngage()
	self:MessageOld("dive", "yellow", nil, L["engage_warning"]:format(self.displayName), false)
	local dwarn = L["dive_warning"]
	self:DelayedMessage("dive", 30, "green", (dwarn):format(60))
	self:DelayedMessage("dive", 60, "green", (dwarn):format(30))
	self:DelayedMessage("dive", 80, "green", (dwarn):format(10))
	self:DelayedMessage("dive", 85, "orange", (dwarn):format(5), false, "alarm")
	self:Bar("dive", 90, L["dive_bar"], "Spell_Frost_ArcticWinds")

	self:CDBar(37660, 17) -- Whirl

	self:DelayedMessage("spout", 34, "yellow", L["spout_warning"])
	self:Bar("spout", 37, L["spout_bar"], "INV_Weapon_Rifle_02")

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

function mod:Spout()
	self:ScanForLurker()
	self:CheckForWipe()
	self:Bar("spout", 20, L["spout_message"], "Spell_Frost_ChillingBlast")
	self:Bar("spout", 50, L["spout_bar"], "Spell_Frost_ChillingBlast")
	self:MessageOld("spout", "red", "alert", L["spout_message"], 37433)
	self:DelayedMessage("spout", 47, "yellow", L["spout_warning"])
	self:StopBar(37660) -- Whirl
end

do
	local timer = nil
	function mod:ScanForLurker()
		-- XXX Fix this as Lurker can come up early when all adds die
		if not self:GetUnitIdByGUID(21217) then
			self:CancelAllTimers()
			timer = nil
			self:CloseProximity()
			self:StopBar(L["spout_bar"])
			self:StopBar(37660) -- Whirl
			self:ScheduleTimer("LurkerUp", 60)

			local ewarn = L["emerge_warning"]
			self:MessageOld("dive", "yellow", nil, L["dive_message"], false)
			self:DelayedMessage("dive", 30, "green", (ewarn):format(30))
			self:DelayedMessage("dive", 50, "green", (ewarn):format(10))
			self:DelayedMessage("dive", 55, "orange", (ewarn):format(5), false, "alert")
			self:DelayedMessage("dive", 60, "yellow", L["emerge_message"])
			self:Bar("dive", 60, L["emerge_bar"], "Spell_Frost_Stun")

			self:Bar("spout", 63, L["spout_bar"], "Spell_Frost_ChillingBlast")
			self:DelayedMessage("spout", 60, "yellow", L["spout_warning"])
			return
		end
		if not timer then
			timer = self:ScheduleRepeatingTimer("ScanForLurker", 1)
		end
	end
end

function mod:LurkerUp()
	local dwarn = L["dive_warning"]
	self:DelayedMessage("dive", 30, "green", (dwarn):format(60))
	self:DelayedMessage("dive", 60, "green", (dwarn):format(30))
	self:DelayedMessage("dive", 80, "green", (dwarn):format(10))
	self:DelayedMessage("dive", 85, "orange", (dwarn):format(5), false, "alarm")
	self:Bar("dive", 90, L["dive_bar"], "Spell_Frost_ArcticWinds")

	self:OpenProximity("proximity", 10)
	self:ScheduleRepeatingTimer("CheckForWipe", 20)
end

