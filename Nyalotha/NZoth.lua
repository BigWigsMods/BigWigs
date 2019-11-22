if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("N'Zoth, the Corruptor", 2217, 2375)
if not mod then return end
mod:RegisterEnableMob(158041) -- N'Zoth, the Corruptor
mod.engageId = 2344
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{313609, "SAY_COUNTDOWN"}, -- Gift of N'zoth
		{316711, "TANK"}, -- Mind Wrack
		310184, -- Creeping Anquish
		309991, -- Anguish
		313184, -- Synaptic Shock
		312155, -- Shattered Psyche
		310134, -- Manifest Madness
		310331, -- Void Gaze
		--Exposed Synapse
		314889, -- Probe Mind
		317292, -- Collapsing Mindscape
		-- Nzoth
		315772, -- Mindgrasp
		{309980, "SAY"}, -- Paranoia
		{309713, "TANK"}, -- Void Lash
		310042, -- Tumultuous Burst
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GiftofNzothApplied", 313609)
	self:Log("SPELL_AURA_REMOVED", "GiftofNzothRemoved", 313609)
	self:Log("SPELL_AURA_SUCCESS", "MindWrackSuccess", 316711)
	self:Log("SPELL_AURA_APPLIED", "MindWrackApplied", 316711)
	self:Log("SPELL_AURA_SUCCESS", "CreepingAnquishSuccess", 310184)
	self:Log("SPELL_AURA_APPLIED", "SynapticShockApplied", 313184)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SynapticShockApplied", 313184)
	self:Log("SPELL_AURA_APPLIED", "ShatteredPsyche", 312155)
	self:Log("SPELL_AURA_SUCCESS", "ManifestMadness", 310134)
	self:Log("SPELL_AURA_SUCCESS", "VoidGaze", 310331)
	self:Log("SPELL_AURA_SUCCESS", "ProbeMind", 314889)
	self:Log("SPELL_AURA_START", "CollapsingMindscape", 317292)
	self:Log("SPELL_AURA_START", "Mindgrasp", 315772)
	self:Log("SPELL_AURA_SUCCESS", "Paranoia", 309980)
	self:Log("SPELL_AURA_APPLIED", "ParanoiaApplied", 309980)
	self:Log("SPELL_AURA_SUCCESS", "VoidLash", 309713)
	self:Log("SPELL_AURA_START", "TumultuousBurst", 310042)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 309991) -- Anguish
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 309991)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 309991)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList = mod:NewTargetList()
	function mod:GiftofNzothApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 20)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:GiftofNzothRemoved(args)
		if self:Me(args.spellId) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:MindWrackSuccess(args)
	self:CDBar(args.spellId, 6)
end

function mod:MindWrackApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 2 then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CreepingAnquishSuccess(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 15)
end

function mod:SynapticShockApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "green")
	self:PlaySound(args.spellId, "info")
end

do
	local prev = 0
	function mod:ShatteredPsyche(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "green")
			self:PlaySound(args.spellId, "long")
			self:CastBar(args.spellId, 30)
		end
	end
end

function mod:ManifestMadness(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:VoidGaze(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 34)
end

function mod:ProbeMind(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CollapsingMindscape(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 20)
end

function mod:Mindgrasp(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 12)
end

function mod:Paranoia(args)
	--self:CDBar(args.spellId, 6)
end

do
	local playerList = mod:NewTargetList()
	function mod:ParanoiaApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:VoidLash(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 20)
end

function mod:TumultuousBurst(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 20)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end