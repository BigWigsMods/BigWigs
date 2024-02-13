--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gnarlroot", 2549, 2564)
if not mod then return end
mod:RegisterEnableMob(209333) -- Gnarlroot
mod:SetEncounterID(2820)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local taintedTreantMarks = {}
local emberCharredOnMe = nil
local flamingPestilenceCount = 1
local controlledBurnCount = 1
local torturedScreamCount = 1
local shadowflameCleaveCount = 1
local dreadfireBarrageCount = 1
local intermissionCount = 0
local dreadfireBarrageOnMe = false
local allowTankWarnings = true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.tortured_scream = "Scream"
end

--------------------------------------------------------------------------------
-- Initialization
--

local controlledBurnMarker = mod:AddMarkerOption(true, "player", 1, 421972, 1, 2, 3, 4) -- Controlled Burn
local taintedTreantMarker = mod:AddMarkerOption(true, "npc", 8, -28350, 8, 7, 6, 5) -- Tainted Treant
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Garden of Despair
		421898, -- Flaming Pestilence
		422053, -- Shadow Spines
		{421972, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Controlled Burn
		controlledBurnMarker,
		422023, -- Shadow-Scorched Earth
		{424352, "TANK", "EMPHASIZE"}, -- Dreadfire Barrage
		422026, -- Tortured Scream
		422039, -- Shadowflame Cleave
		-- Stage Two: Agonizing Growth
		421038, -- Ember-Charred
		424970, -- Toxic Loam
		421840, -- Uprooted Agony
		taintedTreantMarker,
		425816, -- Blazing Pollen
		{425820, "SAY"}, -- Flaming Sap
	},{
		["stages"] = "general",
		[421898] = -27467, -- Stage One: Garden of Despair
		[421038] = -27475, -- Stage Two: Agonizing Growth
		[taintedTreantMarker] = "mythic",
	},{
		[421898] = CL.adds, -- Flaming Pestilence (Adds)
		[421972] = CL.bombs, -- Controlled Burn (Bombs)
		[422026] = L.tortured_scream, -- Tortured Scream (Scream)
		[422039] = CL.frontal_cone, -- Shadowflame Cleave (Frontal Cone)
		[421840] = CL.weakened, -- Uprooted Agony (Weakened)
	}
end

function mod:OnBossEnable()
	-- Stage One: Garden of Despair
	self:Log("SPELL_CAST_SUCCESS", "FlamingPestilence", 421898)
	self:Log("SPELL_AURA_APPLIED", "ShadowSpinesApplied", 422053)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowSpinesApplied", 422053)
	self:Log("SPELL_CAST_SUCCESS", "ControlledBurn", 421971)
	self:Log("SPELL_AURA_APPLIED", "ControlledBurnApplied", 421972)
	self:Log("SPELL_AURA_REMOVED", "ControlledBurnRemoved", 421972)
	self:Log("SPELL_CAST_START", "DreadfireBarrage", 424352)
	self:Log("SPELL_AURA_REMOVED", "DreadfireBarrageStop", 424352)
	self:Log("SPELL_AURA_APPLIED", "DreadfireBarrageApplied", 426106)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreadfireBarrageApplied", 426106)
	self:Log("SPELL_AURA_REMOVED", "DreadfireBarrageRemoved", 426106)
	self:Log("SPELL_CAST_START", "TorturedScream", 422026)
	self:Log("SPELL_CAST_START", "ShadowflameCleave", 422039)

	-- Stage Two: Agonizing Growth
	self:Log("SPELL_CAST_SUCCESS", "DoomCultivation", 421090)
	self:Log("SPELL_AURA_APPLIED", "EmberCharredApplied", 421038)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EmberCharredApplied", 421038)
	self:Log("SPELL_AURA_REMOVED", "EmberCharredRemoved", 421038)
	self:Log("SPELL_AURA_APPLIED", "UprootedAgonyApplied", 421840)
	self:Log("SPELL_AURA_REMOVED", "UprootedAgonyRemoved", 421840)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 424970, 422023) -- Toxic Loam, Shadow-Scorched Earth
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 424970, 422023)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 424970, 422023)

	-- Mythic
	self:Log("SPELL_SUMMON", "FlamingPestilenceSummon", 425366) -- Flaming Pestilence
	self:Death("TaintedTreantDeath", 211904) -- Tainted Treant
	self:Log("SPELL_CAST_START", "BlazingPollen", 425816)
	self:Log("SPELL_AURA_APPLIED", "FlamingSapApplied", 425820)
end

function mod:OnEngage()
	self:SetStage(1)
	emberCharredOnMe = nil
	flamingPestilenceCount = 1
	controlledBurnCount = 1
	torturedScreamCount = 1
	shadowflameCleaveCount = 1
	dreadfireBarrageCount = 1
	intermissionCount = 1
	dreadfireBarrageOnMe = false
	allowTankWarnings = true
	mobCollector = {}
	taintedTreantMarks = {}

	self:CDBar(422026, 3.3, CL.count:format(L.tortured_scream, torturedScreamCount)) -- Tortured Scream
	self:CDBar(424352, self:Easy() and 10 or 9, CL.count:format(self:SpellName(424352), dreadfireBarrageCount)) -- Dreadfire Barrage
	self:CDBar(421898, self:Easy() and 16.5 or 15, CL.count:format(CL.adds, flamingPestilenceCount)) -- Flaming Pestilence
	self:CDBar(422039, self:Easy() and 22.4 or 20, CL.count:format(CL.frontal_cone, shadowflameCleaveCount)) -- Shadowflame Cleave
	self:CDBar(421972, self:Mythic() and 36 or self:Heroic() and 32 or 35.3, CL.count:format(CL.bombs, controlledBurnCount)) -- Controlled Burn
	self:CDBar("stages", 91, CL.count:format(CL.stage:format(2), intermissionCount), 421013) -- Doom Cultivation

	if self:GetOption(taintedTreantMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Garden of Despair
function mod:FlamingPestilence(args)
	self:StopBar(CL.count:format(CL.adds, flamingPestilenceCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.adds, flamingPestilenceCount))
	self:PlaySound(args.spellId, "alert")
	flamingPestilenceCount = flamingPestilenceCount + 1
	if flamingPestilenceCount < 3 then -- 2 per rotation
		self:CDBar(args.spellId, self:Heroic() and 38 or 42, CL.count:format(CL.adds, flamingPestilenceCount))
	end
end

function mod:ShadowSpinesApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local playerList = {}
	function mod:ControlledBurn(args)
		playerList = {}
		self:StopBar(CL.count:format(CL.bombs, controlledBurnCount))
		controlledBurnCount = controlledBurnCount + 1
		if controlledBurnCount < 3 then -- 2 per rotation
			self:CDBar(421972, self:Easy() and 37.8 or 34.0, CL.count:format(CL.bombs, controlledBurnCount))
		end
	end

	function mod:ControlledBurnApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(CL.bomb, count, count), nil, ("Bomb (%d{rt%d})"):format(count, count))
			self:SayCountdown(args.spellId, 6, count)
		end
		self:CustomIcon(controlledBurnMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "yellow", playerList, 4, CL.count:format(CL.bombs, controlledBurnCount))
	end

	function mod:ControlledBurnRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(controlledBurnMarker, args.destName)
	end
end

function mod:DreadfireBarrage(args)
	allowTankWarnings = false
	self:StopBar(CL.count:format(args.spellName, dreadfireBarrageCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, dreadfireBarrageCount), nil, true) -- Disable emphasize
	dreadfireBarrageCount = dreadfireBarrageCount + 1

	local cd
	if self:Mythic() then
		local timer = { 9.0, 20.0, 20.0, 14.0, 18.0, 0 }
		cd = timer[dreadfireBarrageCount]
	elseif self:Easy() then
		local timer = { 10.0, 27.8, 27.8, 0 }
		cd = timer[dreadfireBarrageCount]
	else
		local timer = { 10.3, 25.0, 25.0, 25.0, 0 }
		cd = timer[dreadfireBarrageCount]
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, dreadfireBarrageCount))
end

function mod:DreadfireBarrageStop()
	allowTankWarnings = true -- Using this as our throttle as I'm not convinced there will always be 5 stacks exactly, the final stack should always apply to the tank after this ends
end

function mod:DreadfireBarrageApplied(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		dreadfireBarrageOnMe = true
	end
	if allowTankWarnings or amount % 5 == 0 then -- Only warn for the final stack, or every 5/10/15..
		if not dreadfireBarrageOnMe and self:Tank() then -- No stacks on me
			self:StackMessage(424352, "purple", args.destName, amount, 5)
			self:PlaySound(424352, "warning") -- Taunt
		else
			self:StackMessage(424352, "purple", args.destName, amount, 100) -- Prevent emphasize when on you
		end
	end
end

function mod:DreadfireBarrageRemoved(args)
	if self:Me(args.destGUID) then
		dreadfireBarrageOnMe = false
	end
end

function mod:TorturedScream(args)
	self:StopBar(CL.count:format(L.tortured_scream, torturedScreamCount))
	self:Message(args.spellId, "red", CL.count:format(L.tortured_scream, torturedScreamCount))
	self:PlaySound(args.spellId, "alert")
	torturedScreamCount = torturedScreamCount + 1

	local cd
	if self:Mythic() then
		local timer = { 3.0, 23.0, 28.0, 22.0, 0 }
		cd = timer[torturedScreamCount]
	elseif self:Easy() then
		local timer = { 3.3, 25.5, 25.6, 26.7, 0 }
		cd = timer[torturedScreamCount]
	else
		local timer = { 3.0, 23.0, 23.0, 24.0, 0 }
		cd = timer[torturedScreamCount]
	end
	self:CDBar(args.spellId, cd, CL.count:format(L.tortured_scream, torturedScreamCount))
end

function mod:ShadowflameCleave(args)
	self:StopBar(CL.count:format(CL.frontal_cone, shadowflameCleaveCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.frontal_cone, shadowflameCleaveCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameCleaveCount = shadowflameCleaveCount + 1
	if self:Mythic() then
		local timer = { 21.4, 24.0, 27.0, 0 }
		self:CDBar(args.spellId, timer[shadowflameCleaveCount], CL.count:format(CL.frontal_cone, shadowflameCleaveCount))
	elseif shadowflameCleaveCount < 4 then -- 3 per
		self:CDBar(args.spellId, self:Easy() and 26.7 or 24.0, CL.count:format(CL.frontal_cone, shadowflameCleaveCount))
	end
end

-- Stage Two: Agonizing Growth
function mod:DoomCultivation(args)
	self:StopBar(CL.count:format(self:SpellName(424352), dreadfireBarrageCount)) -- Dreadfire Barrage
	self:StopBar(CL.count:format(CL.adds, flamingPestilenceCount)) -- Flaming Pestilence
	self:StopBar(CL.count:format(CL.bombs, controlledBurnCount)) -- Controlled Burn
	self:StopBar(CL.count:format(L.tortured_scream, torturedScreamCount)) -- Tortured Scream
	self:StopBar(CL.count:format(CL.frontal_cone, shadowflameCleaveCount)) -- Shadowflame Cleave
	self:StopBar(CL.count:format(CL.stage:format(2), intermissionCount)) -- Stage Two: Agonizing Growth / Doom Cultivation

	self:Message("stages", "yellow", CL.stage:format(2), false)
	self:PlaySound("stages", "info")
	self:SetStage(2)

	-- Timer for Splintered Charcoal? every 8s from cast _SUCCESS, is there an event?
	-- Timer / How often is Toxic Loam for healers?
	-- How Many Doom Roots? Can we track stacks until stage ends?
end

function mod:EmberCharredApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm")
		emberCharredOnMe = true
	end
end

function mod:EmberCharredRemoved(args)
	if self:Me(args.destGUID) then
		emberCharredOnMe = false
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			if args.spellId == 424970 and not emberCharredOnMe then return end -- Don't warn in soil if you are Charred
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:UprootedAgonyApplied(args)
	self:Message(args.spellId, "green", CL.count:format(CL.weakened, intermissionCount))
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 20, CL.count:format(CL.weakened, intermissionCount))
end

function mod:UprootedAgonyRemoved(args)
	self:Message("stages", "yellow", CL.stage:format(1), false)
	self:PlaySound("stages", "info")
	self:SetStage(1)

	flamingPestilenceCount = 1
	controlledBurnCount = 1
	torturedScreamCount = 1
	shadowflameCleaveCount = 1
	dreadfireBarrageCount = 1
	intermissionCount = intermissionCount + 1
	mobCollector = {}
	taintedTreantMarks = {}

	self:CDBar(422026, self:LFR() and 4.4 or 5, CL.count:format(L.tortured_scream, torturedScreamCount)) -- Tortured Scream
	self:CDBar(424352, self:Easy() and 11.4 or 10.4, CL.count:format(self:SpellName(424352), dreadfireBarrageCount)) -- Dreadfire Barrage
	self:CDBar(421898, self:Easy() and 18 or 16.4, CL.count:format(CL.adds, flamingPestilenceCount)) -- Flaming Pestilence
	self:CDBar(422039, self:Easy() and 24 or 21.4, CL.count:format(CL.frontal_cone, shadowflameCleaveCount)) -- Shadowflame Cleave
	self:CDBar(421972, self:Heroic() and 33 or 37.4, CL.count:format(CL.bombs, controlledBurnCount)) -- Controlled Burn
	self:CDBar("stages", 92.2, CL.count:format(CL.intermission, intermissionCount), 421013) -- Intermission / Doom Cultivation
end

-- Mythic
function mod:FlamingPestilenceSummon(args)
	if self:GetOption(taintedTreantMarker) then
		for i = 8, 5, -1 do -- 8, 7, 6, 5
			if not mobCollector[args.destGUID] and not taintedTreantMarks[i] then
				taintedTreantMarks[i] = args.destGUID
				mobCollector[args.destGUID] = i
				return
			end
		end
	end
end

function mod:AddMarking(_, unit, guid)
	if mobCollector[guid] then
		self:CustomIcon(taintedTreantMarker, unit, mobCollector[guid]) -- icon order from SPELL_SUMMON
		mobCollector[guid] = nil
	end
end

function mod:TaintedTreantDeath(args)
	for i = 8, 5, -1 do -- 8, 7, 6, 5
		if taintedTreantMarks[i] == args.destGUID then
			taintedTreantMarks[i] = nil
			return
		end
	end
end

function mod:BlazingPollen(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:FlamingSapApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId, nil, nil, "Flaming Sap")
	end
end
