if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

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

function mod:GetOptions()
	return {
		"stages",
		-- Stage 1
		{272506, "SAY"}, -- Explosive Corruption
		270287, -- Blighted Ground
		267509, -- Thousand Maws
		267427, -- Torment
		{267412, "TANK"}, -- Massive Smash
		267409, -- Dark Bargain
		267462, -- Decaying Eruption
		263482, -- Reorigination Blast
		-- Stage 2
		{270447, "TANK"}, -- Growing Corruption
		270428, -- Wave of Corruption
		{263235, "SAY"}, -- Blood Feast
		263307, -- Mind-Numbing Chatter
		-- Stage 3
		274577, -- Malignant Growth
		275160, -- Gaze of G'huun
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_AURA_REMOVED", "BloodShieldRemoved", 263217)
	self:Log("SPELL_AURA_APPLIED", "ExplosiveCorruptionApplied", 272506)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveCorruptionRemoved", 272506)
	self:Log("SPELL_CAST_START", "ThousandMaws", 267509)
	self:Log("SPELL_CAST_START", "Torment", 267427)
	self:Log("SPELL_CAST_START", "MassiveSmash", 267412)
	self:Log("SPELL_CAST_START", "DarkBargain", 267409)
	self:Log("SPELL_CAST_START", "DecayingEruption", 267462)
	self:Log("SPELL_CAST_START", "ReoriginationBlast", 263482)

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "GrowingCorruption", 270447)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingCorruption", 270447)
	self:Log("SPELL_CAST_SUCCESS", "WaveofCorruption", 270428)
	self:Log("SPELL_AURA_APPLIED", "BloodFeastApplied", 263235)
	self:Log("SPELL_AURA_REMOVED", "BloodFeastRemoved", 263235)
	self:Log("SPELL_CAST_START", "MindNumbingChatter", 263307)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "Collapse", 276764)
	self:Log("SPELL_CAST_SUCCESS", "MalignantGrowth", 274577)
	self:Log("SPELL_CAST_START", "GazeofGhuun", 275160)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 270287, 263321) -- Blighted Ground, Undulating Mass
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 270287, 263321)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 270287, 263321)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1
function mod:BloodShieldRemoved(args)
	self:Message("stages", "cyan", nil, CL.removed:format(args.spellName))
	self:PlaySound("stages", "long")
end

do
	local playerList = mod:NewTargetList()
	function mod:ExplosiveCorruptionApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "orange", playerList)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
	end

	function mod:ExplosiveCorruptionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ThousandMaws(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:Torment(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:MassiveSmash(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
end

function mod:DarkBargain(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
end

function mod:DecayingEruption(args)
	self:Message(args.spellId, "orange")
	if self:Interrupter() then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:ReoriginationBlast(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

-- Stage 2
function mod:GrowingCorruption(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 5 then -- 1, 3, 5+
		self:StackMessage(args.spellId, args.destName, args.amount, "red")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:WaveofCorruption(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
end

do
	local playerList = mod:NewTargetList()
	function mod:BloodFeastApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning")
		self:TargetsMessage(args.spellId, "red", playerList)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
		end
	end

	function mod:BloodFeastRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:MindNumbingChatter(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
end

-- Stage 3
function mod:Collapse(args)
	self:Message("stages", "cyan")
	self:PlaySound("stages", "long")
end

function mod:MalignantGrowth(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:GazeofGhuun(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
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
