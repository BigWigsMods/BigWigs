--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Vigilant Steward, Zskarn", 2569, 2532)
if not mod then return end
mod:RegisterEnableMob(202375) -- Zskarn
mod:SetEncounterID(2689)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local golemMarks = {}
local golemCollector = {}
local dragonfireTrapsCount = 1
local animateGolemsCount = 1
local tacticalDestructionCount = 1
local shrapnelBombCount = 1
local unstableEmbersCount = 1
local blastWaveCount = 1
local mySearingClawsStacks = 0
local totalBombs = mod:Easy() and 2 or 3

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.tactical_destruction = "Dragonheads"
	L.bombs_soaked = "Bombs Soaked" -- Bombs Soaked (2/4)
	L.unstable_embers = "Embers"
	L.unstable_ember = "Ember"
end

--------------------------------------------------------------------------------
-- Initialization
--

local animateGolemsMarker = mod:AddMarkerOption(true, "npc", 8, -26394, 8, 7, 6, 5) -- Animate Golems
function mod:GetOptions()
	return {
		-- General
		405736, -- Dragonfire Traps
		405812, -- Animate Golems
		animateGolemsMarker,
		405592, -- Salvage Parts
		406678, -- Tactical Destruction
		406725, -- Shrapnel Bomb
		{404010, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Unstable Embers
		403978, -- Blast Wave
		{404942, "TANK"}, -- Searing Claws
		"berserk",
		-- Mythic
		409942, -- Elimination Protocol
	}, {
		[405736] = "general",
		[409942] = "mythic",
	},{
		[405736] = CL.traps, -- Dragonfire Traps (Traps)
		[405812] = CL.adds, -- Animate Golems (Adds)
		[406678] = L.tactical_destruction, -- Tactical Destruction (Destruction)
		[406725] = CL.bombs, -- Shrapnel Bomb (Bombs)
		[404010] = L.unstable_embers, -- Unstable Embers (Embers)
		[403978] = CL.knockback, -- Blast Wave (Knockback)
		[409942] = CL.beams, -- Elimination Protocol (Beams)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "DragonfireTraps", 405736)
	self:Log("SPELL_CAST_START", "AnimateGolems", 405812)
	self:Log("SPELL_CAST_SUCCESS", "GolemSpawn", 181113)
	self:Log("SPELL_AURA_APPLIED", "SalvageParts", 405592)
	self:Log("SPELL_CAST_START", "TacticalDestruction", 406678)
	self:Log("SPELL_CAST_SUCCESS", "ShrapnelBomb", 406725)
	self:Log("SPELL_DAMAGE", "ShrapnelBombSoaked", 404955)
	self:Log("SPELL_MISSED", "ShrapnelBombSoaked", 404955)
	self:Log("SPELL_CAST_SUCCESS", "UnstableEmbers", 404007)
	self:Log("SPELL_AURA_APPLIED", "UnstableEmbersApplied", 404010)
	self:Log("SPELL_AURA_REMOVED", "UnstableEmbersRemoved", 404010)
	self:Log("SPELL_CAST_START", "BlastWave", 403978)
	self:Log("SPELL_AURA_APPLIED", "SearingClawsApplied", 404942)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingClawsApplied", 404942)
	self:Log("SPELL_AURA_REMOVED", "SearingClawsRemoved", 404942)
end

function mod:OnEngage()
	self:SetStage(1)
	dragonfireTrapsCount = 1
	animateGolemsCount = 1
	tacticalDestructionCount = 1
	shrapnelBombCount = 1
	unstableEmbersCount = 1
	blastWaveCount = 1
	mySearingClawsStacks = 0
	totalBombs = self:Easy() and 2 or 3

	if not self:Easy() then
		self:CDBar(404010, self:Mythic() and 9.2 or 7.4, CL.count:format(L.unstable_embers, unstableEmbersCount)) -- Unstable Embers
	end
	self:CDBar(403978, self:Mythic() and 13 or self:Easy() and 20.4 or 11.0, CL.count:format(CL.knockback, blastWaveCount)) -- Blast Wave
	if not self:LFR() then
		self:CDBar(406725, self:Mythic() and 36 or self:Normal() and 45.1 or 35.0, CL.count:format(CL.bombs, shrapnelBombCount)) -- Shrapnel Bomb
	end
	self:CDBar(405736, self:Mythic() and 19.5 or self:Easy() and 15.5 or 20, CL.count:format(CL.traps, dragonfireTrapsCount)) -- Dragonfire Traps
	self:CDBar(405812, self:Mythic() and 26 or self:Easy() and 35.5 or 54.4, CL.count:format(CL.adds, animateGolemsCount)) -- Animate Golems
	self:CDBar(406678, self:Mythic() and 31 or self:Easy() and 70.7 or 60.5, CL.count:format(L.tactical_destruction, tacticalDestructionCount)) -- Tactical Destruction

	self:Berserk(510, true)

	if self:GetOption(animateGolemsMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DragonfireTraps(args)
	local msg = CL.count:format(CL.traps, dragonfireTrapsCount)
	self:StopBar(msg)
	self:Message(args.spellId, "yellow", msg)
	self:PlaySound(args.spellId, "alert")
	dragonfireTrapsCount = dragonfireTrapsCount + 1
	self:CDBar(args.spellId, self:Mythic() and 34 or self:Easy() and 35.2 or 30.5, CL.count:format(CL.traps, dragonfireTrapsCount))
end

function mod:AnimateGolems(args)
	golemMarks, golemCollector = {}, {}

	local msg = CL.count:format(CL.adds, animateGolemsCount)
	self:StopBar(msg)
	self:Message(args.spellId, "cyan", msg)
	self:PlaySound(args.spellId, "info")
	animateGolemsCount = animateGolemsCount + 1
	self:CDBar(args.spellId, 73, CL.count:format(CL.adds, animateGolemsCount))
end

function mod:GolemSpawn(args)
	if self:GetOption(animateGolemsMarker) then
		for i = 8, 5, -1 do -- 8, 7, 6, 5
			if not golemCollector[args.sourceGUID] and not golemMarks[i] then
				golemMarks[i] = args.sourceGUID
				golemCollector[args.sourceGUID] = i
				return
			end
		end
	end
end

function mod:AddMarking(_, unit, guid)
	if golemCollector[guid] then
		self:CustomIcon(animateGolemsMarker, unit, golemCollector[guid]) -- icon order from SPELL_SUMMON
		golemCollector[guid] = nil
	end
end

function mod:SalvageParts(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:TacticalDestruction(args)
	local msg = CL.count:format(L.tactical_destruction, tacticalDestructionCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "warning")
	tacticalDestructionCount = tacticalDestructionCount + 1
	self:CDBar(args.spellId, self:Mythic() and 73 or 71, CL.count:format(L.tactical_destruction, tacticalDestructionCount))
end

do
	local bombStart = 0
	local bombsSoaked = 0
	local function startBombTimers()
		mod:StopBar(CL.count_amount:format(L.bombs_soaked, bombsSoaked, totalBombs))
		bombStart = GetTime()
		bombsSoaked = 0
		mod:Bar(406725, 30, CL.count_amount:format(L.bombs_soaked, bombsSoaked, totalBombs), "inv_misc_bomb_01")
	end

	function mod:ShrapnelBomb(args)
		local msg = CL.count:format(CL.bombs, shrapnelBombCount)
		self:StopBar(msg)
		self:Message(args.spellId, "yellow", msg)
		self:PlaySound(args.spellId, "alert")
		shrapnelBombCount = shrapnelBombCount + 1
		self:CDBar(args.spellId, self:Mythic() and 45 or 30.3, CL.count:format(CL.bombs, shrapnelBombCount))

		 -- Starting/Stopping Bomb timers after 2s due to flight time
		 self:ScheduleTimer(startBombTimers, 2)
	end

	function mod:ShrapnelBombSoaked()
		self:StopBar(CL.count_amount:format(L.bombs_soaked, bombsSoaked, totalBombs))
		bombsSoaked = bombsSoaked + 1
		if self:Tank() then -- Tanks only
			self:Message(406725, bombsSoaked < totalBombs and "yellow" or "green", CL.count_amount:format(L.bombs_soaked, bombsSoaked, totalBombs), "inv_misc_bomb_01")
		end
		if bombsSoaked < totalBombs then -- Bombs Remaining
			local timeLeft = (bombStart + 30) - GetTime()
			if timeLeft > 0 and timeLeft < 30 then -- safety
				self:Bar(406725, {timeLeft, 30}, CL.count_amount:format(L.bombs_soaked, bombsSoaked, totalBombs), "inv_misc_bomb_01")
			end
		end
	end
end

function mod:UnstableEmbers()
	local msg = CL.count:format(L.unstable_embers, unstableEmbersCount)
	self:StopBar(msg)
	self:Message(404010, "red", msg)
	unstableEmbersCount = unstableEmbersCount + 1
	self:CDBar(404010, 15.8, CL.count:format(L.unstable_embers, unstableEmbersCount))
	if self:Mythic() then
		self:Bar(409942, 10, CL.count:format(CL.beams, unstableEmbersCount)) -- Elimination Protocol
	end
end

function mod:UnstableEmbersApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.unstable_ember)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, L.unstable_ember, nil, "Ember")
		if self:Mythic() then
			self:SayCountdown(args.spellId, 10, nil, 5)
		end
	end
end

function mod:UnstableEmbersRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:BlastWave(args)
	local msg = CL.count:format(CL.knockback, blastWaveCount)
	self:StopBar(msg)
	self:Message(args.spellId, "red", msg)
	self:PlaySound(args.spellId, "alert")
	blastWaveCount = blastWaveCount + 1
	self:CDBar(args.spellId, self:Easy() and 38.6 or 34, CL.count:format(CL.knockback, blastWaveCount))
end

function mod:SearingClawsApplied(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		mySearingClawsStacks = amount
	end
	if amount % 2 == 0 or (amount > 8 and mySearingClawsStacks == 0) then -- 2,4,6 then 8+ (only warn for every application if you have no stacks)
		self:StackMessage(args.spellId, "purple", args.destName, amount, 8)
		if mySearingClawsStacks == 0 and amount >= 8 and self:Tank() then -- No stacks on me, 8+ stacks on other tank
			self:PlaySound(args.spellId, "warning") -- Maybe swap?
		end
	end
end

function mod:SearingClawsRemoved(args)
	if self:Me(args.destGUID) then
		mySearingClawsStacks = 0
	end
end
