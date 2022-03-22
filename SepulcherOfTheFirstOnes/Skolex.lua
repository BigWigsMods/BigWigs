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
local burrowCount = 1
local devouringBloodTimer = nil
local isInfoOpen = false
local ephemeraDustList = {}

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
		364522, -- Devouring Blood
		364778, -- Destroy
		{359778, "INFOBOX"}, -- Ephemera Dust
		366070, -- Volatile Residue
	},{
		[366070] = "mythic",
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

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 366070) -- Volatile Residue
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 366070)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 366070)
	self:Log("SPELL_AURA_APPLIED", "EphemeraDustApplied", 359778)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EphemeraDustApplied", 359778)
	self:Log("SPELL_AURA_REMOVED", "EphemeraDustRemoved", 359778)
end

function mod:OnEngage()
	tankComboCounter = 1
	flailCount = 1
	retchCount = 1
	burrowCount = 1
	ephemeraDustList = {}
	isInfoOpen = false

	self:Bar(359829, 2, CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
	self:Bar("tank_combo", 9, CL.count:format(CL.tank_combo, tankComboCounter), L.tank_combo_icon) -- Tank Combo
	self:Bar(360451, 24, CL.count:format(self:SpellName(360451), retchCount)) -- Retch
	devouringBloodTimer = self:ScheduleTimer("DevouringBlood", 9)
	self:Bar(364522, 9) -- Devouring Blood
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
		self:CDBar("tank_combo", self:Easy() and 36.5 or 33, CL.count:format(CL.tank_combo, tankComboCounter), L.tank_combo_icon) -- Tank Combo
	end
end

function mod:DevouringBlood()
	self:StopBar(364522)
	local speedUp = self:Mythic() and 0.75 or 0.5
	--self:Message(364522, "orange") -- XXX Disabled until we confirm mythic is correct as well
	--self:PlaySound(364522, "info")
	local cd = 9 - ((burrowCount - 1) * speedUp) -- speeds up after each burrow
	self:Bar(364522, cd)
	self:CancelTimer(devouringBloodTimer)
	devouringBloodTimer = self:ScheduleTimer("DevouringBlood", cd)
end

function mod:RaveningBurrow(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, burrowCount))
	self:PlaySound(args.spellId, "long")
	burrowCount = burrowCount + 1

	local nextTankCombo = self:BarTimeLeft(CL.count:format(CL.tank_combo, tankComboCounter)) + 10
	self:CDBar("tank_combo", nextTankCombo, CL.count:format(CL.tank_combo, tankComboCounter), L.tank_combo_icon) -- Tank Combo

	local nextRetch = self:BarTimeLeft(CL.count:format(self:SpellName(360451), retchCount))
	if nextRetch < 10 then -- skipped, new bar
		self:StopBar(CL.count:format(self:SpellName(360451), retchCount))
		local cd = self:Easy() and 37.5 or 34
		nextRetch = nextRetch + cd
		retchCount = retchCount + 1
		self:Bar(360451, nextRetch, CL.count:format(self:SpellName(360451), retchCount)) -- Retch
	end

	self:StopBar(CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
	flailCount = 1
	self:Bar(359829, 11, CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
end

function mod:DustFlail(args)
	self:StopBar(CL.count:format(args.spellName, flailCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, flailCount))
	self:PlaySound(args.spellId, "alert")
	flailCount = flailCount + 1
	self:CDBar(args.spellId, self:Easy() and 19 or 17, CL.count:format(args.spellName, flailCount))
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

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:EphemeraDustApplied(args)
	if not isInfoOpen then
		isInfoOpen = true
		self:OpenInfo(args.spellId, args.spellName)
	end
	ephemeraDustList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, ephemeraDustList)
end

function mod:EphemeraDustRemoved(args)
	ephemeraDustList[args.destName] = nil
	if next(ephemeraDustList) then
		self:SetInfoByTable(args.spellId, ephemeraDustList)
	elseif isInfoOpen then
		isInfoOpen = false
		self:CloseInfo(args.spellId)
	end
end
