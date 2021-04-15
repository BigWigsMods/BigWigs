--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Morogrim Tidewalker", 548, 1571)
if not mod then return end
mod:RegisterEnableMob(21213)
mod:SetAllowWin(true)
mod:SetEncounterID(2462)

local inGrave = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.grave_bar = "<Watery Graves>"
	L.grave_nextbar = "~Graves"

	L.murloc = "Murlocs"
	L.murloc_desc = "Warn for incoming murlocs."
	L.murloc_icon = 42365
	L.murloc_bar = "~Murlocs"
	L.murloc_message = "Incoming Murlocs!"
	L.murloc_soon_message = "Murlocs soon!"
	L.murloc_engaged = "%s Engaged, Murlocs in ~40sec"

	L.globules = "Globules"
	L.globules_desc = "Warn for incoming Watery Globules."
	L.globules_icon = "INV_Elemental_Primal_Water"
	L.globules_trigger1 = "Soon it will be finished!"
	L.globules_trigger2 = "There is nowhere to hide!"
	L.globules_message = "Incoming Globules!"
	L.globules_warning = "Globules Soon!"
	L.globules_bar = "Globules Despawn"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		37730, 37850, "murloc", "globules"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Grave", 37850, 38023, 38024, 38025)
	self:Log("SPELL_CAST_START", "Tidal", 37730)
	self:Log("SPELL_CAST_SUCCESS", "Murlocs", 37764)

	self:BossYell("Globules", L["globules_trigger1"], L["globules_trigger2"])
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 21213)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")

	self:MessageOld("murloc", "green", nil, L["murloc_engaged"]:format(self.displayName), false)
	self:Bar("murloc", 40, L["murloc_bar"], 42365)
	self:Bar(37850, 20, L["grave_nextbar"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function graveWarn()
		mod:TargetMessageOld(37850, inGrave, "red", "alert")
		scheduled = nil
	end
	function mod:Grave(args)
		inGrave[#inGrave + 1] = args.destName
		if not scheduled then
			scheduled = true
			self:Bar(37850, 28.5, L["grave_nextbar"])
			self:Bar(37850, 4.5, L["grave_bar"])
			self:ScheduleTimer(graveWarn, 0.4)
		end
	end
end

function mod:Tidal(args)
	self:MessageOld(args.spellId, "orange", "alarm")
end

function mod:Murlocs()
	self:MessageOld("murloc", "green", nil, L["murloc_message"], 42365)
	self:Bar("murloc", 51, L["murloc_bar"], 42365)
	self:DelayedMessage("murloc", 49, "yellow", L["murloc_soon_message"])
end

function mod:Globules()
	self:MessageOld("globules", "red", "alert", L["globules_message"], false)
	self:Bar("globules", 36, L["globules_bar"], "INV_Elemental_Primal_Water")
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 21213 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 25 and hp < 30 then
			self:MessageOld("globules", "green", nil, L["globules_warning"], false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

