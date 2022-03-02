--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vigilant Guardian", 2481, 2458)
if not mod then return end
mod:RegisterEnableMob(184522, 180773) -- Vigilant Custodian, Vigilant Guardian
mod:SetEncounterID(2512)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local refractedBlastCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.sentry = "Tank Add"
	L.materium = "Small Adds"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		360403, -- Force Field
		360458, -- Unstable Core
		360658, -- Pre-Fabricated Sentry
		361001, -- Wave of Disintegration
		364447, -- Dissonance
		365315, -- Volatile Materium
		360906, -- Refracted Blast
		{359610, "SAY", "SAY_COUNTDOWN"}, -- Deresolution
		360412, -- Exposed Core
		{364881, "SAY", "SAY_COUNTDOWN"}, -- Matter Disolution
		360162, -- Split Resolution
		{360414, "TANK"}, -- Pneumatic Impact
		364962, -- Core Overload
	},{
		[360403] = -24374, -- Automa
		[360906] = -23875, -- Stage One: Systems Online!
		[360162] = -23877, -- Stage Two: Roll Out, then Transform
	},{
		[360658] = L.sentry,
	}
end

function mod:OnBossEnable()
	-- Automa
	self:Log("SPELL_AURA_APPLIED", "ForceFieldApplied", 360403)
	self:Log("SPELL_AURA_REMOVED", "ForceFieldRemoved", 360403)
	self:Log("SPELL_AURA_APPLIED", "UnstableCoreApplied", 360458)
	self:Log("SPELL_AURA_REMOVED", "UnstableCoreRemoved", 360458)
	self:Log("SPELL_CAST_SUCCESS", "PreFabricatedSentry", 360658)
	self:Log("SPELL_CAST_START", "WaveOfDisintegration", 361001)
	self:Log("SPELL_CAST_START", "Dissonance", 364447)
	self:Log("SPELL_AURA_APPLIED", "DissonanceApplied", 364447)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DissonanceApplied", 364447)
	self:Log("SPELL_CAST_SUCCESS", "VolatileMaterium", 365315)
	-- Stage One: Systems Online!
	self:Log("SPELL_CAST_SUCCESS", "RefractedBlast", 360906)
	self:Log("SPELL_AURA_APPLIED", "DeresolutionApplied", 359610)
	self:Log("SPELL_CAST_START", "ExposedCore", 360412)
	-- Stage Two: Roll Out, then Transform
	self:Log("SPELL_AURA_REMOVED", "AncientDefensesRemoved", 360879)
	self:Log("SPELL_CAST_START", "SplitResolution", 360162)
	self:Log("SPELL_CAST_SUCCESS", "MatterDisolution", 364881)
	self:Log("SPELL_AURA_APPLIED", "MatterDisolutionApplied", 364881)
	self:Log("SPELL_AURA_REMOVED", "MatterDisolutionRemoved", 364881)
	self:Log("SPELL_CAST_START", "PneumaticImpact", 360414)
	self:Log("SPELL_CAST_SUCCESS", "CoreOverload", 364962)
end

function mod:OnEngage()
	self:SetStage(1)
	refractedBlastCount = 1

	self:Bar(365315, 5, L.materium) -- Volatile Materium
	self:Bar(360906, 16) -- Refracted Blast
	self:Bar(359610, 37.8) -- Deresolution
	self:Bar(360658, 52, L.sentry) -- Pre-Fabricated Sentry
	self:Bar(360412, 90) -- Exposed Core

	if self:Mythic() then
		self:Bar(360162, 47) -- Split Resolution
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ForceFieldApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:ForceFieldRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	end
end

function mod:UnstableCoreApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:UnstableCoreRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	end
end

function mod:PreFabricatedSentry(args)
	self:Message(args.spellId, "yellow", L.sentry)
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 80, L.sentry)
end

do
	local prev = 0
	function mod:WaveOfDisintegration(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local prev = 0
	function mod:Dissonance(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "purple")
			self:PlaySound(args.spellId, "alarm")
		end
	end

	function mod:DissonanceApplied(args)
		if self:Tank() or self:Me(args.destGUID) then
			local amount = args.amount or 1
			if amount % 2 == 1 then -- XXX Finetune
				self:NewStackMessage(args.spellId, "purple", args.destName, amount, 5)
				if self:Me(args.destGUID) then
					self:PlaySound(args.spellId, "alarm")
				end
			end
		end
	end
end

function mod:VolatileMaterium(args)
	self:Message(args.spellId, "yellow", L.materium)
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 60, L.materium)
end

function mod:RefractedBlast(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	refractedBlastCount = refractedBlastCount + 1
	local cd = 15.5
	if self:GetStage() < 2 and refractedBlastCount > 3 and refractedBlastCount % 3 == 1 then -- 4, 7, 10...?
		cd = refractedBlastCount == 4 and 81.5 or 70
	end
	self:Bar(args.spellId, cd)
end

function mod:DeresolutionApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	else
		self:PlaySound(args.spellId, "alarm")
	end
	self:TargetMessage(args.spellId, "red", args.destName)
	self:Bar(args.spellId, 35)
end

function mod:ExposedCore(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 107)
end

function mod:AncientDefensesRemoved(args)
	self:StopBar(360412) -- Exposed Core
	self:StopBar(360906) -- Refracted Blast
	self:StopBar(L.sentry) -- Pre-Fabricated Sentry
	self:StopBar(L.materium) -- Volatile Materium

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	self:Bar(360906, 20) -- Refracted Blast
	self:Bar(360162, 31.5) -- Split Resolution
	self:Bar(364881, 31.5) -- Matter Dissolution
	self:Bar(360414, 31.5) -- Pneumatic Impact
end

function mod:SplitResolution(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 31.5)
end

do
	local playerList = {}
	function mod:MatterDisolution(args)
		playerList = {}
		self:Bar(args.spellId, 20.5)
	end

	function mod:MatterDisolutionApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			local _, _, _, expires = self:UnitDebuff("player", args.spellId)
			if expires and expires > 0 then
				local timeLeft = expires - GetTime()
				self:SayCountdown(args.spellId, timeLeft)
			end
		else
			self:PlaySound(args.spellId, "alert")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:MatterDisolutionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:PneumaticImpact(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 30.4)
end

function mod:CoreOverload(args)
	self:StopBar(360906) -- Refracted Blast
	self:StopBar(360162) -- Split Resolution
	self:StopBar(364881) -- Matter Dissolution
	self:StopBar(360414) -- Pneumatic Impact

	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end
