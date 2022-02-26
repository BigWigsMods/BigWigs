--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skolex, the Insatiable Ravener", 2481, 2465)
if not mod then return end
mod:RegisterEnableMob(181395) -- Skolex
mod:SetEncounterID(2542)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local tankComboCounter = 1
local comboCounter = 1
local flailCount = 1
local retchCount = 1
local unendingCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.tank_combo = CL.tank_combo
	L.tank_combo_desc = "Timer for Riftmaw/Rend casts at 100 energy."
	L.tank_combo_icon = 359979
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
		359770, -- Ravening Burrow
		359829, -- Dust Flail
		360451, -- Retch
		"tank_combo", -- Tank Combo
		359979, -- Rend
		359975, -- Riftmaw
		364778, -- Destroy
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "RaveningBurrow", 359770)
	self:Log("SPELL_CAST_START", "DustFlail", 359829)
	self:Log("SPELL_CAST_START", "Retch", 360451)
	self:Log("SPELL_CAST_START", "Rend", 359979)
	self:Log("SPELL_CAST_START", "Riftmaw", 359975)
	self:Log("SPELL_CAST_START", "Destroy", 364778)
end

function mod:OnEngage()
	tankComboCounter = 1
	flailCount = 1
	retchCount = 1
	unendingCount = 1

	self:Bar(359829, 2, CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
	self:Bar("tank_combo", 9, CL.count:format(CL.tank_combo, tankComboCounter), L.tank_combo_icon) -- Tank Combo
	self:Bar(360451, 24.5, CL.count:format(self:SpellName(360451), retchCount)) -- Retch
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 360079 then -- Tank Combo
		self:StopBar(CL.count:format(CL.tank_combo, tankComboCounter))
		comboCounter = 1
		tankComboCounter = tankComboCounter + 1
		self:CDBar("tank_combo", 33, CL.count:format(CL.tank_combo, tankComboCounter), L.tank_combo_icon) -- Tank Combo
	end
end

function mod:RaveningBurrow(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, unendingCount))
	self:PlaySound(args.spellId, "long")
	unendingCount = unendingCount + 1

	local nextTankCombo = self:BarTimeLeft(CL.count:format(CL.tank_combo, tankComboCounter)) + 10
	self:CDBar("tank_combo", nextTankCombo, CL.count:format(CL.tank_combo, tankComboCounter), L.tank_combo_icon) -- Tank Combo

	local nextRetch = self:BarTimeLeft(CL.count:format(self:SpellName(360451), retchCount)) + 10 -- XXX Not Always correct, different logic?
	self:Bar(360451, nextRetch, CL.count:format(self:SpellName(360451), retchCount)) -- Retch

	self:StopBar(CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
	flailCount = 1
	self:Bar(359829, 11, CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
end

function mod:DustFlail(args)
	self:StopBar(CL.count:format(args.spellName, flailCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, flailCount))
	self:PlaySound(args.spellId, "alert")
	flailCount = flailCount + 1
	self:CDBar(args.spellId, 17, CL.count:format(args.spellName, flailCount))
end

function mod:Retch(args)
	self:StopBar(CL.count:format(args.spellName, retchCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, retchCount))
	self:PlaySound(args.spellId, "info")
	retchCount = retchCount + 1
	self:CDBar(args.spellId, 34, CL.count:format(args.spellName, retchCount))
end

function mod:Rend(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, comboCounter))
	self:PlaySound(args.spellId, "alarm")
	comboCounter = comboCounter + 1
end

function mod:Riftmaw(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, comboCounter))
	self:PlaySound(args.spellId, "alarm")
	comboCounter = comboCounter + 1
end

function mod:Destroy(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end
