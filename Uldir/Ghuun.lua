--------------------------------------------------------------------------------
-- TODO:
-- - Dark Bargain bars and counter for each unique add?
-- - Massive Smash bars for each unique add
-- - Decaying Eruption bars for each unique add
-- - Burrow timers and warnings
-- - Thousand Maws add specifics
-- - Stop and Start bars on transitions better
-- - Amount of orbs/energy left until Reorigination Blast
-- - Check ground damage id's
-- - Last target hit for tank warnings?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("G'huun", 1861, 2147)
if not mod then return end
mod:RegisterEnableMob(132998)
mod.engageId = 2122
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

local stage = 1
local waveCounter = 0
local waveOfCorruptionCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage 1
		{272506, "SAY", "SAY_COUNTDOWN"}, -- Explosive Corruption
		270287, -- Blighted Ground
		267509, -- Thousand Maws
		267427, -- Torment
		{267412, "TANK"}, -- Massive Smash
		267409, -- Dark Bargain
		267462, -- Decaying Eruption
		263482, -- Reorigination Blast
		-- Stage 2
		{270447, "TANK"}, -- Growing Corruption
		270373, -- Wave of Corruption
		{263235, "SAY", "SAY_COUNTDOWN"}, -- Blood Feast
		263307, -- Mind-Numbing Chatter
		-- Stage 3
		274582, -- Malignant Growth
		275160, -- Gaze of G'huun
		263321, -- Undulating Mass
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveCorruptionSuccess", 274262, 272505)
	self:Log("SPELL_AURA_APPLIED", "ExplosiveCorruptionApplied", 275756, 272506)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveCorruptionRemoved", 275756, 272506)
	self:Log("SPELL_CAST_START", "ThousandMaws", 267509)
	self:Log("SPELL_CAST_START", "Torment", 267427)
	self:Log("SPELL_CAST_START", "MassiveSmash", 267412)
	self:Log("SPELL_CAST_START", "DarkBargain", 267409)
	self:Log("SPELL_CAST_START", "DecayingEruption", 267462)
	self:Log("SPELL_CAST_START", "ReoriginationBlast", 263482)
	self:Log("SPELL_CAST_SUCCESS", "ReoriginationBlastSuccess", 263482)
	self:Log("SPELL_AURA_REMOVED", "ReoriginationBlastRemoved", 263504)

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "CorruptingBiteApplied", 270443) -- Stage 2 start
	self:Log("SPELL_AURA_APPLIED", "GrowingCorruption", 270447)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingCorruption", 270447)
	self:Log("SPELL_CAST_SUCCESS", "BloodFeastSuccess", 263235)
	self:Log("SPELL_AURA_REMOVED", "BloodFeastRemoved", 263235)
	self:Log("SPELL_CAST_START", "MindNumbingChatter", 263307)
	self:Death("HorrorDeath", 134010)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "Collapse", 276839)
	self:Log("SPELL_CAST_SUCCESS", "MalignantGrowth", 274582)
	self:Log("SPELL_CAST_START", "GazeofGhuun", 275160)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 270287, 263321) -- Blighted Ground, Undulating Mass
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 270287, 263321)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 270287, 263321)
end

function mod:OnEngage()
	stage = 1
	waveCounter = 1

	self:Bar(267509, 25.5, CL.count:format(self:SpellName(267509), waveCounter)) -- Thousand Maws (x)
	self:CDBar(272506, 8) -- Explosive Corruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 270373 then -- Wave of Corruption
		self:Message(spellId, "yellow")
		self:PlaySound(spellId, "alarm")
		waveOfCorruptionCount = waveOfCorruptionCount + 1
		self:Bar(spellId, waveOfCorruptionCount % 2 == 0 and 20.5 or 40.5)
	end
end

-- Stage 1
function mod:CorruptingBiteApplied()
	stage = 2
	self:Message("stages", "cyan", nil, CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	waveOfCorruptionCount = 1

	self:Bar(272506, 9) -- Explosive Corruption
	self:Bar(270373, 15.5) -- Wave of Corruption
	self:Bar(263235, 47) -- Blood Feast
end

function mod:ExplosiveCorruptionSuccess(args)
	self:TargetMessage2(272506, "orange", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(272506, "warning")
	end
	self:CDBar(272506, stage == 1 and 13 or 13.4)
end

function mod:ExplosiveCorruptionApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(272506, "blue", args.destName)
		self:Say(272506)
		self:SayCountdown(272506, 4)
	end
end

function mod:ExplosiveCorruptionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(272506)
	end
end

function mod:ThousandMaws(args)
	self:Message(args.spellId, "cyan", nil, CL.count:format(args.spellName, waveCounter))
	self:PlaySound(args.spellId, "info")
	waveCounter = waveCounter + 1
	self:Bar(args.spellId, 25.5, CL.count:format(args.spellName, waveCounter))
end

function mod:Torment(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:MassiveSmash(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 9.7)
end

function mod:DarkBargain(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 23)
end

function mod:DecayingEruption(args)
	self:Message(args.spellId, "orange")
	if self:Interrupter() then
		self:PlaySound(args.spellId, "warning")
	end
	self:CDBar(args.spellId, 8.5)
end

function mod:ReoriginationBlast(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long")
end

function mod:ReoriginationBlastSuccess(args)
	self:Bar(args.spellId, 24)
	if stage == 1 then -- Stage 1 ending
		self:StopBar(CL.count:format(self:SpellName(267509), waveCounter)) -- Thousand Maws (x)
		self:StopBar(267412) -- Massive Smash
		self:StopBar(267409) -- Dark Bargain
		self:StopBar(272506) -- Explosive Corruption
		self:StopBar(267462) -- Decaying Eruption
	else
		self:PauseBar(272506) -- Explosive Corruption
		self:PauseBar(270373) -- Wave of Corruption
		self:PauseBar(263235) -- Blood Feast
	end
end


function mod:ReoriginationBlastRemoved(args)
	if stage == 2 then -- These bars don't exist in stage 1, no stun happens in stage 3
		self:ResumeBar(272506) -- Explosive Corruption
		self:ResumeBar(270373) -- Wave of Corruption
		self:ResumeBar(263235) -- Blood Feast
	end
end

-- Stage 2
function mod:GrowingCorruption(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm")
end

function mod:BloodFeastSuccess(args)
	self:PlaySound(args.spellId, "warning")
	self:TargetMessage2(args.spellId, "red", args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
	self:CDBar(args.spellId, 62)
	self:CDBar(263307, 20) -- Mind-Numbing Chatter
end

function mod:BloodFeastRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:MindNumbingChatter(args)
	self:Message(args.spellId, "orange", nil, CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 13.5)
end

function mod:HorrorDeath()
	self:StopBar(263307) -- Mind-Numbing Chatter
end


-- Stage 3
function mod:Collapse(args)
	stage = 3
	self:Message("stages", "cyan", nil, CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	self:StopBar(272506) -- Explosive Corruption
	self:StopBar(270373) -- Wave of Corruption
	self:StopBar(263235) -- Blood Feast
	self:StopBar(263482) -- Reorigination Blast

	waveOfCorruptionCount = 1

	self:CastBar("stages", 20, args.spellName, args.spellId) -- Collapse
	self:Bar(274582, 25.5) -- Malignant Growth
	self:Bar(272506, 30) -- Explosive Corruption
	self:Bar(275160, 32.5) -- Gaze of G'huun
	self:Bar(270373, 37.5) -- Wave of Corruption
end

function mod:MalignantGrowth(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 20.5)
end

function mod:GazeofGhuun(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 21.9)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:TargetMessage2(args.spellId, "blue", args.destName, true)
			end
		end
	end
end
