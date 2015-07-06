
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
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Phase 1 ]]--
		{186271, "TANK_HEALER"}, -- Fel Strike
		{186407, "SAY", "PROXIMITY", "FLASH"}, -- Fel Surge
		{186448, "TANK"}, -- Felblaze Flurry
		186500, -- Chains of Fel
		--[[ Phase 2 ]]--
		{186292, "TANK_HEALER"}, -- Void Strike
		{186333, "SAY", "PROXIMITY", "FLASH"}, -- Void Surge
		{186785, "TANK"}, -- Withering Gaze
		186546, -- Black Hole
		--[[ Phase 4 ]]--
		187204, -- Overwhelming Chaos
		--[[ General ]]--
		186134, -- Feltouched
		186135, -- Voidtouched
		186073, -- Felsinged
		186063, -- Wasting Void
		"stages",
	}, {
		[186271] = CL.phase:format(1),
		[186292] = CL.phase:format(2),
		[187204] = CL.phase:format(4),
		[186134] = "general",
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
	self:Log("SPELL_AURA_APPLIED", "FelblazeFlurry", 186448) -- Felblaze Flurry
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelblazeFlurry", 186448) -- Felblaze Flurry
	self:Log("SPELL_AURA_APPLIED", "WitheringGaze", 186785) -- Withering Gaze
	self:Log("SPELL_AURA_APPLIED_DOSE", "WitheringGaze", 186785) -- Withering Gaze
	self:Log("SPELL_CAST_START", "FelStrike", 186271, 190223) -- Fel Strike XXX 186271 still used?
	self:Log("SPELL_CAST_START", "VoidStrike", 186292, 190224) -- Void Strike XXX 186292 still used?
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingChaos", 187204)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingChaos", 187204)
	self:Log("SPELL_CAST_START", "BlackHole", 186546)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Death("Deaths", 94185, 94239) -- Vanguard Akkelion, Omnus
end

function mod:OnEngage()
	phase = 1
	wipe(mobCollector)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:CDBar(186271, 8) -- Fel Strike
	self:CDBar(186407, 15) -- Fel Surge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	if args.mobId == 94185 then
		self:StopBar(186271) -- Fel Strike
		self:StopBar(186407) -- Fel Surge
		self:StopBar(186448) -- Felblaze Flurry
		self:StopBar(186500) -- Chains of Fel
		phase = 2
		self:Message("stages", "Neutral", "Info", CL.phase:format(2), false)
	elseif args.mobId == 94239 then
		self:StopBar(186292) -- Void Strike
		self:StopBar(186333) -- Void Surge
		self:StopBar(186785) -- Withering Gaze
		self:StopBar(186546) -- Black Hole
		phase = 3
		self:Message("stages", "Neutral", "Info", CL.phase:format(3), false)
	end
end

function mod:Touched(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Long", CL.you:format(args.spellName))
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
			self:CDBar(args.spellId, 34) -- rarely (consistently) 31, mostly 34
		end
	end
end

function mod:FelblazeFlurry(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Important")
	self:CDBar(args.spellId, 17)
end

function mod:WitheringGaze(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Important")
	self:CDBar(args.spellId, 24)
end

function mod:FelStrike(args)
	self:Message(186271, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CDBar(186271, phase == 3 and 15 or 16) -- 15.8
end

function mod:VoidStrike(args)
	self:Message(186292, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CDBar(186292, phase == 3 and 15 or 17) -- 17.1/18.2
end

function mod:OverwhelmingChaos(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important")
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, amount + 1))
end

function mod:BlackHole(args)
	self:Message(args.spellId, "Urgent", "Info", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 29)
end

do
	local adds = {
		[94185] = -11691, -- Vanguard Akkelion
		[94239] = -11688, -- Omnus
	}
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 5 do
			local guid = UnitGUID("boss"..i)
			if guid and not mobCollector[guid] then
				mobCollector[guid] = true
				local id = adds[self:MobId(guid)]
				if id then
					self:Message("stages", "Neutral", nil, CL.spawned:format(self:SpellName(id)), false)
				end
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 187209 then -- Overwhelming Chaos
		self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
		self:StopBar(186271) -- Fel Strike
		self:StopBar(186407) -- Fel Surge
		self:StopBar(186292) -- Void Strike
		self:StopBar(186333) -- Void Surge
		self:Message("stages", "Neutral", "Info", CL.phase:format(4), false)
		self:Bar(187204, 10) -- Overwhelming Chaos
	end
end

