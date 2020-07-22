if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Inerva Darkvein", 2296, 2420)
if not mod then return end
mod:RegisterEnableMob(167517) -- Lady Inerva Darkvein
mod.engageId = 2406
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local cognitionOnMe = nil

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		325379, -- Expose Desires
		325936, -- Shared Cognition
		325382, -- Warped Desires
		325769, -- Bottled Anima
		325713, -- Lingering Anima
		325064, -- Sins and Suffering
		{332664, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Concentrate Anima -- say, countdown, proximity
		{331573, "ME_ONLY"}, -- Unconscionable Guilt
		331550, -- Condemn
	}, {
		[325379] = "general",
		[331573] = -22293,
		[331550] = -22295,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ExposeDesires", 325379)
	self:Log("SPELL_AURA_APPLIED", "SharedCognitionApplied", 325936)
	self:Log("SPELL_AURA_REMOVED", "SharedCognitionRemoved", 325936)
	self:Log("SPELL_AURA_APPLIED", "WarpedDesiresApplied", 325382)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WarpedDesiresApplied", 325382)
	self:Log("SPELL_CAST_SUCCESS", "BottledAnima", 325769)
	self:Log("SPELL_CAST_START", "SinsandSuffering", 325064)
	self:Log("SPELL_AURA_APPLIED", "ConcentrateAnimaApplied", 332664)
	self:Log("SPELL_AURA_REMOVED", "ConcentrateAnimaRemoved", 332664)
	self:Log("SPELL_AURA_APPLIED", "UnconscionableGuiltApplied", 331573)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnconscionableGuiltApplied", 331573)
	self:Log("SPELL_CAST_START", "Condemn", 331550)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 325713, 325718) -- Lingering Anima 2x XXX Check what ID is correct
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 325713, 325718)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 325713, 325718)
end

function mod:OnEngage()
	cognitionOnMe = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ExposeDesires(args)
	if self:Tank() or self:Healer() or cognitionOnMe then
		self:Message2(args.spellId, "purple")
		self:PlaySound(args.spellId, "alert")
	end
	--self:Bar(args.spellId, 25.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:SharedCognitionApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			cognitionOnMe = true
			self:PlaySound(args.spellId, "alarm")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:SharedCognitionRemoved(args)
		if self:Me(args.destGUID) then
			cognitionOnMe = nil
		end
	end
end

function mod:WarpedDesiresApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 25.5)
end

function mod:BottledAnima(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 25.5)
end

function mod:SinsandSuffering(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 25.5)
end

do
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:ConcentrateAnimaApplied(args)
		proxList[#proxList+1] = args.destName
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = true
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
			self:OpenProximity(args.spellId, 8)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)

		if not isOnMe then
			self:OpenProximity(args.spellId, 8, proxList)
		end
	end

	function mod:ConcentrateAnimaRemoved(args)
		tDeleteItem(proxList, args.destName)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:CancelSayCountdown(args.spellId)
			self:CloseProximity(args.spellId)
		end

		if not isOnMe then
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 8, proxList)
			end
		end
	end
end

function mod:UnconscionableGuiltApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "yellow")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:Condem(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(325713, "alarm")
				self:PersonalMessage(325713, "underyou")
			end
		end
	end
end
