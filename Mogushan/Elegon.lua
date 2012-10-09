
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Elegon", 896, 726)
if not mod then return end
mod:RegisterEnableMob(60410)

--------------------------------------------------------------------------------
-- Locales
--

local celestialBreath, materializeProtector, overcharged = (GetSpellInfo(117960)), (GetSpellInfo(117954)), (GetSpellInfo(117878))
local drawPowerCounter
local totalAnnihilationCounter = 0
local phase2SoonWarned, phase2SoonWarned2ndTime

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.last_phase = "Last Phase"
	L.floor_despawn = "Floor despawn"
	L.overcharged_total_annihilation = "You have (%d) %s, reset your debuff!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		117960, "ej:6177", "ej:6186", {117878, "FLASHSHAKE"},
		119360,
		"ej:6176",
		"berserk", "bosskill",
	}, {
		[117960] = "ej:6174",
		[119360] = "ej:6175",
		["ej:6176"] = "ej:6176",
		berserk = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_AURA_APPLIED", "Overcharged", 117878)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Overcharged", 117878)
	self:Log("SPELL_CAST_START", "CelestialBreath", 117960)
	self:Log("SPELL_CAST_START", "TotalAnnihilation", 129711)
	self:Log("SPELL_CAST_START", "MaterializeProtector", 117954)
	self:Log("SPELL_AURA_REMOVED", "UnstableEnergyRemoved", 116994)
	--cat WoWCombatLog.txt | grep "APPLIED.*Draw Power" | cut -d , -f 10 | sort | uniq
	self:Log("SPELL_AURA_APPLIED", "DrawPower", 119387)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrawPower", 119387)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60410)
end

function mod:OnEngage(diff)
	self:Bar(117960, celestialBreath, 8.5, 117960)
	self:Bar("ej:6177", materializeProtector, 12, 117954)
	self:Berserk(570)
	drawPowerCounter = 0
	totalAnnihilationCounter = 0
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	phase2SoonWarned, phase2SoonWarned2ndTime = false, false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, _, _, spellId)
	-- Trigger Phase A when the spark hits the conduit
	if spellId == 118189 and unit:match("boss") then
		self:Bar("ej:6176", L["floor_despawn"], 7, 116994)
	end
end

function mod:Overcharged(player, spellId, _, _, spellName, buffStack)
	if UnitIsUnit(player, "player") then
		if (buffStack or 1) >= 6 and buffStack % 2 == 0 then
			self:LocalMessage(117878, ("%s (%d)"):format(spellName, buffStack), "Personal", 117878)
		end
	end
end

function mod:DrawPower(_, _, _, _, spellName)
	drawPowerCounter = drawPowerCounter + 1
	self:Message(119360, ("%s (%d)"):format(spellName, drawPowerCounter), "Attention", 119360)
	-- XXX need to check for another event that is also called Draw Power and cancell bars there, that should be better
	self:SendMessage("BigWigs_StopBar", self, materializeProtector)
	self:SendMessage("BigWigs_StopBar", self, celestialBreath)
end

function mod:CelestialBreath(_, _, _, _, spellName)
	self:Bar(117960, spellName, 18, 117960)
	self:Message(117960, spellName, "Urgent", 117960)
end

function mod:TotalAnnihilation(_, _, _, _, spellName)
	totalAnnihilationCounter = totalAnnihilationCounter + 1
	self:Message("ej:6186", ("%s (%d)"):format(spellName, totalAnnihilationCounter), "Important", 129711, "Alert")
	self:Bar("ej:6186", CL["cast"]:format(spellName), 4, 129711)
	local playerOvercharged, _, _, stack = UnitDebuff("player", overcharged)
	if playerOvercharged and stack > 10 then -- stack count might need adjustment based on difficulty
		self:FlashShake(117878)
		self:LocalMessage(117878, L["overcharged_total_annihilation"]:format(buffStack, overcharged), "Personal", 117878) -- needs no sound since total annihilaiton has one already
	end
end

function mod:MaterializeProtector(_, _, _, _, spellName)
	self:Message("ej:6177", spellName, "Attention", 117954)
	self:Bar("ej:6177", spellName, 36, 117954)
end

function mod:UnstableEnergyRemoved()
	if phase2SoonWarned2ndTime then
		self:Message("ej:6176", L["last_phase"], "Positive", 116994)
	else
		drawPowerCounter = 0
		totalAnnihilationCounter = 0
		self:Message("ej:6176", CL["phase"]:format(1), "Positive", 116994)
		self:Bar("ej:6177", materializeProtector, 15, 117954)
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

