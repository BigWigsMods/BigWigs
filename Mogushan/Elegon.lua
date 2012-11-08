
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Elegon", 896, 726)
if not mod then return end
mod:RegisterEnableMob(60410)

--------------------------------------------------------------------------------
-- Locales
--

local drawPowerCounter, annihilateCounter = 0, 0
local phase2SoonWarned, phase2SoonWarned2ndTime = nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "Entering defensive mode.  Disabling output failsafes."

	L.last_phase = "Last Phase"
	L.overcharged_total_annihilation = "Overcharge %d! A bit much?"

	L.floor = "Floor Despawn"
	L.floor_desc = "Warnings for when the floor is about to despawn."
	L.floor_icon = "ability_vehicle_launchplayer"
	L.floor_message = "The floor is falling!"

	L.adds = "Adds"
	L.adds_desc = "Warnings for when a Celestial Protector is about to spawn."
	L.adds_icon = 117954
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		117960, "adds", "ej:6186", {117878, "FLASHSHAKE"},
		119360,
		{"floor", "FLASHSHAKE"},
		"stages", "berserk", "bosskill",
	}, {
		[117960] = "ej:6174",
		[119360] = "ej:6175",
		["floor"] = "ej:6176",
		stages = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Overcharged", 117878)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Overcharged", 117878)
	self:Log("SPELL_AURA_APPLIED", "StabilityFlux", 117911)
	self:Log("SPELL_DAMAGE", "StabilityFluxDamage", 117912)
	self:Log("SPELL_CAST_START", "CelestialBreath", 117960)
	self:Log("SPELL_CAST_START", "TotalAnnihilation", 129711)
	self:Log("SPELL_CAST_START", "MaterializeProtector", 117954)
	self:Log("SPELL_AURA_REMOVED", "UnstableEnergyRemoved", 116994)
	self:Log("SPELL_AURA_APPLIED", "DrawPower", 119387)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrawPower", 119387)

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60410)
end

function mod:OnEngage()
	self:Bar(117960, 117960, 8.5, 117960) -- Celestial Breath
	self:Bar("adds", CL["next_add"], 12, 117954)
	self:Berserk(570)
	drawPowerCounter, annihilateCounter = 0, 0
	phase2SoonWarned, phase2SoonWarned2ndTime = nil, nil
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, _, _, spellId)
	-- Trigger Phase A when the spark hits the conduit
	if spellId == 118189 and unit == "boss1" then
		self:Bar("floor", L["floor"], 6, L.floor_icon)
		self:Message("floor", L["floor_message"], "Personal", L.floor_icon, "Alarm")
		self:FlashShake("floor")
	end
end

function mod:Overcharged(player, spellId, _, _, spellName, buffStack)
	if UnitIsUnit(player, "player") and InCombatLockdown() then
		if (buffStack or 1) >= 6 and buffStack % 2 == 0 then
			self:LocalMessage(spellId, ("%s (%d)"):format(spellName, buffStack), "Personal", spellId)
		end
	end
end

function mod:DrawPower(_, _, _, _, spellName)
	drawPowerCounter = drawPowerCounter + 1
	self:Message(119360, ("%s (%d)"):format(spellName, drawPowerCounter), "Attention", 119360)
	-- XXX need to check for another event that is also called Draw Power and cancell bars there, that should be better
	self:StopBar(117954) -- Materialize Protector
	self:StopBar(117960) -- Celestial Breath
end

function mod:CelestialBreath(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 18, spellId)
end

do
	local overcharged = mod:SpellName(117878)
	function mod:StabilityFlux(_, spellId, _, _, spellName)
		-- this gives an 1 sec warning before damage, might want to check hp for a
		local playerOvercharged, _, _, stack = UnitDebuff("player", overcharged)
		if playerOvercharged and stack > 10 then -- stack count might need adjustment based on difficulty
			self:FlashShake(117878)
			self:LocalMessage(117878, L["overcharged_total_annihilation"]:format(stack), "Personal", 117878) -- needs no sound since total StabilityFlux has one already
		end
	end
	-- This will spam, but it is apparantly needed for some people
	function mod:StabilityFluxDamage(_, spellId, _, _, spellName)
		local playerOvercharged, _, _, stack = UnitDebuff("player", overcharged)
		if playerOvercharged and stack > 10 then -- stack count might need adjustment based on difficulty
			self:FlashShake(117878)
			self:LocalMessage(117878, L["overcharged_total_annihilation"]:format(stack), "Personal", 117878, "Info") -- Does need the sound spam too!
		end
	end
end

function mod:TotalAnnihilation(_, spellId, _, _, spellName)
	annihilateCounter = annihilateCounter + 1
	self:Message("ej:6186", ("%s (%d)"):format(spellName, annihilateCounter), "Important", spellId, "Alert")
	self:Bar("ej:6186", CL["cast"]:format(spellName), 4, spellId)
end

function mod:MaterializeProtector(_, spellId, _, _, spellName)
	self:Message("adds", CL["add_spawned"], "Attention", spellId)
	if self:Heroic() then
		self:Bar("adds", CL["next_add"], 26, spellId)
	else
		self:Bar("adds", CL["next_add"], 36, spellId)
	end
end

function mod:UnstableEnergyRemoved()
	if phase2SoonWarned2ndTime then
		self:Message("stages", L["last_phase"], "Positive")
	else
		drawPowerCounter, annihilateCounter = 0, 0
		self:Message("stages", CL["phase"]:format(1), "Positive")
		self:Bar("adds", CL["next_add"], 15, 117954)
		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 88 and not phase2SoonWarned then -- phase starts at 85
			self:Message(119360, CL["soon"]:format(CL["phase"]:format(2)), "Positive", 119360, "Info")
			phase2SoonWarned = true
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		elseif hp < 53 and not phase2SoonWarned2ndTime then
			self:Message(119360, CL["soon"]:format(CL["phase"]:format(2)), "Positive", 119360, "Info")
			phase2SoonWarned2ndTime = true
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

