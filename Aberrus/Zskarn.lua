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

local mobCollector = {}
local marksUsed = {}
local dragonfireTrapsCount = 1
local animateGolemsCount = 1
local tacticalDestructionCount = 1
local shrapnelBombCount = 1
local unstableEmbersCount = 1
local blastWaveCount = 1

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

local animateGolemsMarker = mod:AddMarkerOption(false, "npc", 8, -26394, 8, 7, 6, 5) -- Animate Golems
function mod:GetOptions()
	return {
		405736, -- Dragonfire Traps
		405812, -- Animate Golems
		animateGolemsMarker,
		405592, -- Salvage Parts
		406678, -- Tactical Destruction
		406725, -- Shrapnel Bomb
		{404010, "SAY", "SAY_COUNTDOWN"}, -- Unstable Embers
		403978, -- Blast Wave
		{404942, "TANK"}, -- Searing Claws
	},{

	},{
		[405736] = CL.traps, -- Dragonfire Traps (Traps)
		[405812] = CL.adds, -- Animate Golems (Adds)
		[406678] = L.tactical_destruction, -- Tactical Destruction (Destruction)
		[404010] = L.unstable_embers, -- Unstable Embers (Embers)
		[403978] = CL.knockback, -- Blast Wave (Knockback)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "DragonfireTraps", 405736)
	self:Log("SPELL_CAST_START", "AnimateGolems", 405812)
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
end

function mod:OnEngage()
	self:SetStage(1)
	mobCollector = {}
	marksUsed = {}
	dragonfireTrapsCount = 1
	animateGolemsCount = 1
	tacticalDestructionCount = 1
	shrapnelBombCount = 1
	unstableEmbersCount = 1
	blastWaveCount = 1

	if not self:Easy() then
		self:Bar(404010, 7, CL.count:format(L.unstable_embers, unstableEmbersCount)) -- Unstable Embers
	end
	self:Bar(403978, self:Easy() and 11 or 11.5, CL.count:format(CL.knockback, blastWaveCount)) -- Blast Wave
	self:Bar(406725, self:Easy() and 4.5 or 36, CL.count:format(CL.bombs, shrapnelBombCount)) -- Shrapnel Bomb
	self:Bar(405736, self:Easy() and 22.5 or 19, CL.count:format(CL.traps, dragonfireTrapsCount)) -- Dragonfire Traps
	self:Bar(405812, self:Easy() and 39 or 26.4, CL.count:format(CL.adds, animateGolemsCount)) -- Animate Golems
	self:Bar(406678, self:Easy() and 60.5 or 31, CL.count:format(L.tactical_destruction, tacticalDestructionCount)) -- Tactical Destruction

	if self:GetOption(animateGolemsMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DragonfireTraps(args)
	self:StopBar(CL.count:format(CL.traps, dragonfireTrapsCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.traps, dragonfireTrapsCount))
	self:PlaySound(args.spellId, "alert")
	dragonfireTrapsCount = dragonfireTrapsCount + 1
	self:Bar(args.spellId, self:Mythic() and 32.8 or 32.5, CL.count:format(CL.traps, dragonfireTrapsCount))
end

function mod:AnimateGolems(args)
	self:StopBar(CL.count:format(CL.adds, animateGolemsCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, animateGolemsCount))
	self:PlaySound(args.spellId, "info")
	animateGolemsCount = animateGolemsCount + 1
	self:Bar(args.spellId, self:Mythic() and 74.1 or self:Heroic() and 60 or 73.3, CL.count:format(CL.adds, animateGolemsCount))

	marksUsed = {}
end

function mod:AddMarking(_, unit, guid)
	if not mobCollector[guid] then
		local mobId = self:MobId(guid)
		if mobId == 203230 then -- Dragonfire Golem
			for i = 8, 5, -1 do -- 8, 7, 6, 5
				if not marksUsed[i] then
					mobCollector[guid] = true
					marksUsed[i] = guid
					self:CustomIcon(animateGolemsMarker, unit, i)
					return
				end
			end
		end
	end
end

function mod:SalvageParts(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:TacticalDestruction(args)
	self:StopBar(CL.count:format(L.tactical_destruction, tacticalDestructionCount))
	self:Message(args.spellId, "orange", CL.count:format(L.tactical_destruction, tacticalDestructionCount))
	self:PlaySound(args.spellId, "warning")
	tacticalDestructionCount = tacticalDestructionCount + 1
	self:Bar(args.spellId, 72, CL.count:format(L.tactical_destruction, tacticalDestructionCount))
end

do
	local bombStart = 0
	local bombsSoaked = 0
	function mod:ShrapnelBomb(args)
		self:StopBar(CL.count_amount:format(L.bombs_soaked, bombsSoaked, 4))
		self:StopBar(CL.count:format(CL.bombs, shrapnelBombCount))
		self:Message(args.spellId, "yellow", CL.count:format(CL.bombs, shrapnelBombCount))
		self:PlaySound(args.spellId, "alert")
		shrapnelBombCount = shrapnelBombCount + 1
		self:Bar(args.spellId, self:Mythic() and 30 or self:Heroic() and 42.5 or 36.5, CL.count:format(CL.bombs, shrapnelBombCount))

		bombStart = args.time
		bombsSoaked = 0
		self:Bar(args.spellId, 30, CL.count_amount:format(L.bombs_soaked, bombsSoaked, 4), "inv_misc_bomb_01")
	end

	function mod:ShrapnelBombSoaked(args)
			self:StopBar(CL.count_amount:format(L.bombs_soaked, bombsSoaked, 4))
			bombsSoaked = bombsSoaked + 1
			if self:Tank() then -- Tanks only
				self:Message(406725, bombsSoaked < 4 and "yellow" or "green", CL.count_amount:format(L.bombs_soaked, bombsSoaked, 4), "inv_misc_bomb_01")
			end
			if bombsSoaked < 4 then -- Bombs Remaining
				local timeLeft = (bombStart + 30) - args.time
				if timeLeft > 0 and timeLeft < 30 then -- safety
					self:Bar(406725, {timeLeft, 30}, CL.count_amount:format(L.bombs_soaked, bombsSoaked, 4), "inv_misc_bomb_01")
				end
			end
	end
end

function mod:UnstableEmbers(args)
	self:Message(404010, "red", CL.count:format(L.unstable_embers, unstableEmbersCount))
	unstableEmbersCount = unstableEmbersCount + 1
	self:Bar(404010, self:Mythic() and 15.5 or 20.5, CL.count:format(L.unstable_embers, unstableEmbersCount))
end

function mod:UnstableEmbersApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.unstable_ember)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, L.unstable_ember)
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
	self:StopBar(CL.count:format(CL.knockback, blastWaveCount))
	self:Message(args.spellId, "red", CL.count:format(CL.knockback, blastWaveCount))
	self:PlaySound(args.spellId, "alert")
	blastWaveCount = blastWaveCount + 1
	self:Bar(args.spellId, self:Easy() and 40.5 or 34, CL.count:format(CL.knockback, blastWaveCount))
end

function mod:SearingClawsApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	if (args.amount or 0) > 5 and self:Tank() and not self:Tanking("boss1") then
		self:PlaySound(args.spellId, "warning")
	end
end
