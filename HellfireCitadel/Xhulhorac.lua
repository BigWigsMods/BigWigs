
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Xhul'horac", 1026, 1447)
if not mod then return end
mod:RegisterEnableMob(93068)
mod.engageId = 1800

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		186134, -- Feltouched
		186135, -- Voidtouched
		186073, -- Felsinged
		186063, -- Wasting Void
		{186407, "SAY", "PROXIMITY", "FLASH"}, -- Fel Surge
		{186333, "SAY", "PROXIMITY", "FLASH"}, -- Void Surge
		186500, -- Chains of Fel
		{186448, "TANK"}, -- Felblaze Flurry
		{186785, "TANK"}, -- Withering Gaze
		{186271, "TANK_HEALER"}, -- Fel Strike
		{186292, "TANK_HEALER"}, -- Void Strike
		187204, -- Overwhelming Chaos
		186546, -- Black Hole
		-11691, -- Vanguard Akkelion
		-11688, -- Omnus
		-11714, -- Unstable Voidfiend
		-- XXX fix by stage
	}
end

function mod:OnBossEnable()
	-- XXX this stacking may not work out in all cases
	self:Log("SPELL_AURA_APPLIED", "Touched", 186134, 186135) -- Feltouched, Voidtouched
	self:Log("SPELL_AURA_APPLIED", "Felsinged_WastingVoid", 186073, 186063) -- Felsinged, Wasting Void
	self:Log("SPELL_AURA_APPLIED_DOSE", "Felsinged_WastingVoid", 186073, 186063) -- Felsinged, Wasting Void
	self:Log("SPELL_AURA_APPLIED", "Surge", 186407, 186333) -- Fel Surge, Void Surge
	self:Log("SPELL_AURA_REMOVED", "SurgeRemoved", 186407, 186333) -- Fel Surge, Void Surge
	self:Log("SPELL_AURA_APPLIED", "ChainsOfFel", 186500)
	self:Log("SPELL_AURA_APPLIED", "FelblazeFlurry_WitheringGaze", 186448, 186785) -- Felblaze Flurry, Withering Gaze
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelblazeFlurry_WitheringGaze", 186448, 186785) -- Felblaze Flurry, Withering Gaze
	self:Log("SPELL_CAST_START", "Strike", 186271, 186292) -- Fel Strike, Void Strike
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingChaos", 187204)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingChaos", 187204)
	self:Log("SPELL_CAST_START", "BlackHole", 186546)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	wipe(mobCollector)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:CDBar(186271, 8) -- Fel Strike
	self:CDBar(186407, 15) -- Fel Surge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Touched(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Long")
		self:TargetBar(args.spellId, 15, args.destName)
	end
end

function mod:Felsinged_WastingVoid(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, args.amount, "Personal")
	end
end

do
	local list = mod:NewTargetList()
	function mod:Surge(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
			self:CDBar(args.spellId, 30)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10) -- Open to debate
		end
	end
end

function mod:SurgeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

do
	local list = mod:NewTargetList()
	function mod:ChainsOfFel(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent", "Alarm")
			self:CDBar(args.spellId, 23)
		end
	end
end

function mod:FelblazeFlurry_WitheringGaze(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Important")
	self:CDBar(args.spellId, 15)
end

function mod:Strike(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 14.5)
end

function mod:OverwhelmingChaos(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important")
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, amount+1))
end

function mod:BlackHole(args)
	self:Message(args.spellId, "Urgent", "Info", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 29)
end

do
	local adds = {
		[94185] = -11691, -- Vanguard Akkelion
		[94239] = -11688, -- Omnus
		[94397] = -11714, -- Unstable Voidfiend
	}
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 5 do
			local guid = UnitGUID("boss"..i)
			if guid and not mobCollector[guid] then
				mobCollector[guid] = true
				local id = adds[self:MobId(guid)]
				if id then
					self:Message(id, "Neutral", nil, CL.spawned:format(self:SpellName(id)), false)
				end
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 187209 then -- Overwhelming Chaos
		self:Bar(187204, 10)
		self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
	end
end

