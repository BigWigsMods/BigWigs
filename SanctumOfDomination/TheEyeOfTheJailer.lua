--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Eye of the Jailer", 2450, 2442)
if not mod then return end
mod:RegisterEnableMob(175725)
mod:SetEncounterID(2433)
mod:SetRespawnTime(35)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local nextStageWarning = 69
local stage = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.chains = "Chains" -- Short for Dragging Chains
	L.pool = "Pool" -- Spreading Misery
	L.pools = "Pools" -- Spreading Misery (multiple)
	L.death_gaze = "Death Gaze" -- Short for Titanic Death Gaze
	L.corruption = mod:SpellName(172) -- Corruption // Short for Slothful Corruption
	L.slow = mod:SpellName(31589) -- Slow
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: His Gaze Upon You
		350828, -- Deathlink
		349979, -- Dragging Chains
		348074, -- Assailing Lance
		-- Stage Two: Double Vision
		349028, -- Titanic Death Gaze
		{350847, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Desolation Beam
		{350022, "ME_ONLY_EMPHASIZE"}, -- Fracture Soul
		{351825, "TANK"}, -- Shared Suffering
		350713, -- Slothful Corruption
		{351827, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Spreading Misery
		-- Stage Three: Immediate Extermination
		351413, -- Annihilating Glare
		{350604, "SAY", "ME_ONLY_EMPHASIZE"}, -- Hopeless Lethargy
		355232, -- Scorn and Ire
	},{
		["stages"] = "general",
		[350803] = mod:SpellName(-22896), -- Stage One: His Gaze Upon You
		[349028] = mod:SpellName(-22897), -- Stage Two: Double Vision
		[351413] = mod:SpellName(-23375), -- Stage Three: Immediate Extermination
		[350604] = "mythic", -- Mythic
	},{
		[349979] = L.chains, -- Dragging Chains (Chains)
		[349028] = L.death_gaze, -- Titanic Death Gaze (Death Gaze)
		[350847] = CL.beam, -- Desolation Beam (Beam)
		[350713] = L.corruption, -- Slothful Corruption (Corruption)
		[351827] = L.pools, -- Spreading Misery (Pools)
		[351413] = CL.laser, -- Annihilating Glare (Laser)
		[350604] = L.slow, -- Hopeless Lethargy (Slow)
	}
end

function mod:OnBossEnable()
	-- Stage One: His Gaze Upon You
	self:Log("SPELL_CAST_START", "Deathlink", 350828)
	self:Log("SPELL_AURA_APPLIED", "DraggingChains", 358609)
	self:Log("SPELL_AURA_APPLIED", "DraggingChainsApplied", 349979)
	self:Log("SPELL_CAST_START", "AssailingLance", 348074)

	-- Stage Two: Double Vision
	self:Log("SPELL_AURA_APPLIED", "StygianDarkshieldApplied", 348805)
	self:Log("SPELL_CAST_START", "TitanicDeathGaze", 349030)
	self:Log("SPELL_CAST_START", "DesolationBeam", 350847)
	self:Log("SPELL_CAST_SUCCESS", "FractureSoul", 350022)
	self:Log("SPELL_AURA_APPLIED", "ShatteredSoulApplied", 350034)
	self:Log("SPELL_AURA_APPLIED", "SharedSufferingApplied", 351825)
	self:Log("SPELL_CAST_START", "SlothfulCorruption", 351835)
	self:Log("SPELL_AURA_APPLIED", "SlothfulCorruptionApplied", 350713)

	self:Log("SPELL_CAST_START", "SpreadingMisery", 350816)
	self:Log("SPELL_AURA_APPLIED", "SpreadingMiseryApplied", 351827)
	self:Log("SPELL_AURA_REMOVED", "SpreadingMiseryRemoved", 351827)
	self:Log("SPELL_AURA_REMOVED", "StygianDarkshieldRemoved", 348805)

	-- Stage Three: Immediate Extermination
	self:Log("SPELL_CAST_START", "ImmediateExtermination", 348974)
	self:Log("SPELL_CAST_START", "AnnihilatingGlare", 351413)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "HopelessLethargyApplied", 350604)
	self:Log("SPELL_AURA_APPLIED", "ScornAndIreApplied", 355240, 355245) -- Scorn, Ire
	self:Log("SPELL_AURA_APPLIED_DOSE", "ScornAndIreApplied", 355240, 355245)
end

function mod:OnEngage()
	self:SetStage(1)
	stage = 1
	nextStageWarning = 69

	self:Bar(350828, 4.5) -- Death Link
	self:Bar(349979, 11, L.chains) -- Dragging Chains
	self:Bar(351413, 25, CL.laser) -- Annihilating Glare
	if self:Mythic() then
		self:Bar(350604, 10.5, L.slow) -- Hopeless Lethargy
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	local currentHealth = self:GetHealth(unit)
	if currentHealth < nextStageWarning then -- Intermission at 66% and 33%
		local nextStage = currentHealth > 50 and CL.stage:format(2) or CL.stage:format(3) -- Sub 33% is Stage 3
		self:Message("stages", "green", CL.soon:format(nextStage), false)
		nextStageWarning = nextStageWarning - 33
		if nextStageWarning < 25 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

-- Stage One: His Gaze Upon You
function mod:Deathlink(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 11)
end

function mod:DraggingChains(args)
	self:TargetMessage(349979, "orange", args.destName, L.chains)
	self:PlaySound(349979, "alarm")
	self:Bar(349979, 4.5, 352684) -- 352684 = Dragged
	self:Bar(349979, 47, L.chains)
end

function mod:DraggingChainsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local function printTarget(self, _, guid)
		if self:Me(guid) then
			self:PersonalMessage(348074)
			self:PlaySound(348074, "alarm")
		end
	end

	function mod:AssailingLance(args)
		self:GetUnitTarget(printTarget, 0.1, args.sourceGUID)
	end
end

-- Stage Two: Double Vision
function mod:StygianDarkshieldApplied()
	self:SetStage(2)
	stage = 2
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	self:StopBar(350828) -- Death Link
	self:StopBar(CL.laser) -- Annihilating Glare
	self:StopBar(L.chains)
	self:StopBar(L.slow)

	self:Bar(350847, self:Mythic() and 21.1 or 8.5, CL.beam) -- Desolation Beam
	self:Bar(351827, 15, L.pools) -- Spreading Misery
	self:Bar(349028, self:Mythic() and 28.1 or 17, L.death_gaze) -- Titanic Death Gaze
	self:Bar(350713, 21, L.corruption) -- Slothful Corruption
	if self:Mythic() then
		self:Bar(355232, 12) -- Scorn and Ire
	end
end

function mod:TitanicDeathGaze()
	self:Message(349028, "orange", CL.casting:format(L.death_gaze))
	self:PlaySound(349028, "alarm")
	self:CastBar(349028, 8, L.death_gaze)
	self:Bar(349028, 33, L.death_gaze)
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Say(350847, CL.beam)
			self:SayCountdown(350847, 6)
			self:PlaySound(350847, "warning")
		end
		self:TargetMessage(350847, "red", name, CL.beam)
	end

	function mod:DesolationBeam(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
		self:Bar(args.spellId, 17, CL.beam)
	end
end

function mod:FractureSoul(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20) -- XXX quite random atm
end

function mod:ShatteredSoulApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(350022)
		self:PlaySound(350022, "warning")
	end
end

function mod:SharedSufferingApplied(args)
	self:Message(args.spellId, "red", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

do
	local prev = 0
	function mod:SlothfulCorruption(args)
		local t = args.time
		if t-prev > 5 then -- Both adds cast it seperately
			prev = t
			self:Message(350713, "orange", CL.incoming:format(L.corruption))
			if self:Healer() then
				self:PlaySound(350713, "alert")
			end
			self:Bar(350713, 25, L.corruption)
		end
	end
end

function mod:SlothfulCorruptionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:SpreadingMisery(args)
		local t = args.time
		if t-prev > 5 then -- Both adds cast it seperately
			prev = t
			self:Bar(351827, 12, L.pools)
		end
	end
end

function mod:SpreadingMiseryApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.pool)
		self:Say(args.spellId, L.pool)
		self:SayCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:SpreadingMiseryRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:StygianDarkshieldRemoved()
	self:StopBar(CL.beam) -- Desolation Beam
	self:StopBar(L.pools) -- Spreading Misery
	self:StopBar(L.death_gaze) -- Titanic Death Gaze
	self:StopBar(L.corruption) -- Slothful Corruption

	if stage == 2 then
		self:SetStage(1)
		stage = 1
		self:Message("stages", "green", CL.stage:format(1), false)
		self:PlaySound("stages", "long")

		self:Bar(350828, 8.3) -- Death Link
		self:Bar(349979, 16, L.chains) -- Dragging Chains
		self:Bar(351413, 30, CL.laser) -- Annihilating Glare
		if self:Mythic() then
			self:Bar(350604, 15.5, L.slow) -- Hopeless Lethargy
		end
	end
end

-- Stage Three: Immediate Extermination
function mod:ImmediateExtermination()
	self:SetStage(3)
	stage = 3
	self:Message("stages", "green", CL.stage:format(3), false)
	self:PlaySound("stages", "long")

	self:Bar(350828, 9) -- Death Link
	self:Bar(349979, 12, L.chains) -- Dragging Chains
	self:Bar(351413, 26, CL.laser) -- Annihilating Glare
	if self:Mythic() then
		self:Bar(350604, 11, L.slow) -- Hopeless Lethargy
	end
end

function mod:AnnihilatingGlare(args)
	self:Message(args.spellId, "yellow", CL.laser)
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 19, CL.laser) -- 4s cast + 15s channel
	self:Bar(args.spellId, self:Mythic() and 47.4 or 69, CL.laser)
end

-- Mythic
do
	local playerList = {}
	local prev = 0
	function mod:HopelessLethargyApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
			self:Bar(args.spellId, 47.4, L.slow)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.slow)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "red", playerList, nil, L.slow)
	end
end

function mod:ScornAndIreApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 or amount > 10 then
			self:StackMessage(355232, "blue", args.destName, amount, amount, args.spellName)
			self:PlaySound(355232, amount > 10 and "warning" or "info")
		end
	end
end
