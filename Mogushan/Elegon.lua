if not GetNumGroupMembers then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Elegon", 896, 726)
if not mod then return end
mod:RegisterEnableMob(60410)

--------------------------------------------------------------------------------
-- Locales
--

local celestialBreath = (GetSpellInfo(117960))
local drawPowerCounter

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.floor_despawn = "Floor despawn"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		117960, "ej:6177", "ej:6186",
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
	self:Log("SPELL_CAST_START", "CelestialBreath", 117960)
	self:Log("SPELL_CAST_START", "TotalAnnihilation", 129711)
	self:Log("SPELL_CAST_START", "MaterializeProtector", 117954)
	self:Log("SPELL_AURA_APPLIED", "UnstableEnergyApplied", 116994)
	self:Log("SPELL_AURA_REMOVED", "UnstableEnergyRemoved", 116994)
	--cat WoWCombatLog.txt | grep "APPLIED.*Draw Power" | cut -d , -f 10 | sort | uniq
	self:Log("SPELL_AURA_APPLIED", "DrawPower", 119387)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrawPower", 119387)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60410)
end

function mod:OnEngage(diff)
	self:Bar(117960, celestialBreath, 8.5, 117960)
	self:Berserk(570)
	drawPowerCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DrawPower(_, _, _, _, spellName)
	drawPowerCounter = drawPowerCounter + 1
	self:Message(119360, ("%s (%d)"):format(spellName, drawPowerCounter), "Attention", 119360)
end

function mod:CelestialBreath(_, _, _, _, spellName)
	self:Bar(117960, spellName, 18, 117960)
	self:Message(117960, spellName, "Urgent", 117960)
end

function mod:TotalAnnihilation(_, _, _, _, spellName)
	self:Message("ej:6186", spellName, "Important", 129711, "Alert")
end

function mod:MaterializeProtector(_, _, _, _, spellName)
	self:Message("ej:6177", spellName, "Attention", 117954)
	self:Bar("ej:6177", spellName, 36, 117954)
end

function mod:UnstableEnergyApplied()
	self:Message("ej:6176", CL["phase"]:format(3), "Positive", 116994)
	self:Bar("ej:6176", L["floor_despawn"], 4, 116994)
end

function mod:UnstableEnergyRemoved()
	drawPowerCounter = 0
	self:Message("ej:6176", CL["phase"]:format(1), "Positive", 116994)
end



