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

local smallAddCount = 1
local tankAddCount = 1
local matterDisolutionCount = 1
local refractedBlastCount = 1
local exposedCoreCount = 1
local deresolutionCount = 1
local splitResolutionCount = 1
local pneumaticImpactCount = 1
local shieldOnMe = false

local timersMythic = {
	[360906] = {22, 20.0, 20.0, 33.8, 31.8, 20.0, 33.5, 20.0, 32.4, 20.0}, -- Refracted Blast
	[359610] = {47.7, 35.2, 49.9, 35.4, 38.9}, -- Deresolution
	[364881] = {48.5, 31.6, 43.9, 30.5, 30.8, 51.9}, -- Matter Disolution
	[360162] = {48.2, 31.6 , 49.9, 32.9, 31.6}, -- Split Resolution
	[360414] = {34.7, 30.4, 31.6, 50.0, 33.3, 60.8} -- Pneumatic Impact
}
local timers = timersMythic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.sentry = "Tank Add"
	L.materium = "Small Adds"
	L.shield = "Shield" -- Global locale canidate?
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
		[360458] = L.shield, -- Force Field (Shield)
		[360658] = L.sentry, -- Pre-Fabricated Sentry (Tank Add)
		[365315] = L.materium, -- Volatile Materium (Small Adds)
	}
end

function mod:OnBossEnable()
	-- Automa / Adds
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
	self:Log("SPELL_AURA_APPLIED", "ExposedCoreApplied", 360412)
	self:Log("SPELL_AURA_REMOVED", "ExposedCoreRemoved", 360412)
	-- Stage Two: Roll Out, then Transform
	self:Log("SPELL_AURA_REMOVED", "AncientDefensesRemoved", 360879)
	self:Log("SPELL_CAST_SUCCESS", "FracturedCore", 364843) -- for mythic stage 2
	self:Log("SPELL_CAST_START", "SplitResolution", 360162)
	self:Log("SPELL_CAST_SUCCESS", "MatterDisolution", 364881)
	self:Log("SPELL_AURA_APPLIED", "MatterDisolutionApplied", 364881)
	self:Log("SPELL_AURA_REMOVED", "MatterDisolutionRemoved", 364881)
	self:Log("SPELL_CAST_START", "PneumaticImpact", 360414)
	self:Log("SPELL_CAST_SUCCESS", "CoreOverload", 364962)
end

function mod:OnEngage()
	timers = timersMythic
	self:SetStage(1)
	refractedBlastCount = 1
	smallAddCount= 1
	tankAddCount = 1
	exposedCoreCount =  1
	deresolutionCount = 1
	pneumaticImpactCount = 1
	shieldOnMe = false

	self:Bar(365315, 5, CL.count:format(L.materium, smallAddCount)) -- Volatile Materium
	self:Bar(360906, self:Mythic() and 22.5 or 16, CL.count:format(self:SpellName(360906), refractedBlastCount)) -- Refracted Blast
	self:Bar(359610, self:Mythic() and 47 or 37.8, CL.count:format(self:SpellName(359610), deresolutionCount)) -- Deresolution
	self:Bar(360658, self:Mythic() and 66 or 52, CL.count:format(L.sentry, tankAddCount)) -- Pre-Fabricated Sentry
	self:Bar(360412, self:Mythic() and 108 or 90, CL.count:format(self:SpellName(360412), exposedCoreCount)) -- Exposed Core

	if self:Mythic() then
		self:Bar(364881, timers[364881][matterDisolutionCount], CL.count:format(self:SpellName(364881), matterDisolutionCount)) -- Matter Dissolution
		self:Bar(360162, timers[360162][splitResolutionCount], CL.count:format(self:SpellName(360162), splitResolutionCount)) -- Split Resolution
		self:Bar(360414, timers[360414][pneumaticImpactCount]) -- Pneumatic Impact
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ForceFieldApplied(args)
	if self:Me(args.destGUID) then
		shieldOnMe = true
		self:Message(args.spellId, "green", CL.you:format(L.shield))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:ForceFieldRemoved(args)
	if self:Me(args.destGUID) then
		shieldOnMe = false
		self:Message(args.spellId, "cyan", CL.removed:format(L.shield))
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
	self:StopBar(CL.count:format(L.sentry, tankAddCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.sentry, tankAddCount))
	self:PlaySound(args.spellId, "alert")
	tankAddCount = tankAddCount + 1
	self:Bar(args.spellId, self:Mythic() and 87.5 or 80, CL.count:format(L.sentry, tankAddCount))
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
	self:StopBar(CL.count:format(L.materium, smallAddCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.materium, smallAddCount))
	self:PlaySound(args.spellId, "alert")
	smallAddCount = smallAddCount + 1
	self:CDBar(args.spellId, 60, CL.count:format(L.materium, smallAddCount))
end

function mod:RefractedBlast(args)
	self:StopBar(CL.count:format(args.spellName, refractedBlastCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, refractedBlastCount))
	self:PlaySound(args.spellId, "alert")
	refractedBlastCount = refractedBlastCount + 1
	local cd = 15.8
	if self:Mythic() then
		if self:GetStage() == 1 then
			cd = timers[args.spellId][refractedBlastCount]
		end
	elseif self:GetStage() < 2 and refractedBlastCount > 3 and refractedBlastCount % 3 == 1 then -- 4, 7, 10...?
		cd = refractedBlastCount == 4 and 81.5 or 70
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, smallAddCount))
end

function mod:DeresolutionApplied(args)
	self:StopBar(CL.count:format(args.spellName, deresolutionCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	else
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
	self:TargetMessage(args.spellId, "red", args.destName, CL.count:format(args.spellName, deresolutionCount))
	deresolutionCount = deresolutionCount + 1
	local cd = 35
	if self:Mythic() and deresolutionCount == 3 then
		cd = timers[args.spellId][deresolutionCount]
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, deresolutionCount))
end

do
	local shieldCheck = nil
	local function checkForShield()
		if not shieldOnMe and not UnitIsDead("player") then
			mod:Message(360403, "blue", CL.no:format(L.shield))
			mod:PlaySound(360403, "warning")
			shieldCheck = mod:ScheduleTimer(checkForShield, 1)
		end
	end

	function mod:ExposedCore(args)
		self:StopBar(CL.count:format(args.spellName, exposedCoreCount))
		self:Message(args.spellId, "orange", CL.count:format(args.spellName, exposedCoreCount))
		self:PlaySound(args.spellId, "alert")
		exposedCoreCount = exposedCoreCount + 1
		self:Bar(args.spellId, self:Mythic() and 113 or 107, CL.count:format(args.spellName, exposedCoreCount))
	end

	function mod:ExposedCoreApplied(args)
		if self:Me(args.destGUID) and not shieldCheck then
			shieldCheck = mod:ScheduleTimer(checkForShield, 4)
		end
	end

	function mod:ExposedCoreRemoved(args)
		if self:Me(args.destGUID) and shieldCheck then
			self:CancelTimer(shieldCheck)
			shieldCheck = nil
		end
	end
end

function mod:AncientDefensesRemoved(args)
	self:StopBar(CL.count:format(self:SpellName(360412), exposedCoreCount)) -- Exposed Core
	self:StopBar(CL.count:format(self:SpellName(360906), refractedBlastCount)) -- Refracted Blast
	self:StopBar(CL.count:format(L.sentry, tankAddCount)) -- Pre-Fabricated Sentry
	self:StopBar(CL.count:format(L.materium, smallAddCount)) -- Volatile Materium

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	self:Bar(360906, 20, CL.count:format(self:SpellName(360906), refractedBlastCount)) -- Refracted Blast
	self:Bar(360162, 31.5, CL.count:format(self:SpellName(360162), splitResolutionCount)) -- Split Resolution
	self:Bar(364881, 31.5, CL.count:format(self:SpellName(364881), matterDisolutionCount)) -- Matter Dissolution
	self:Bar(360414, 31.5) -- Pneumatic Impact
end

function mod:FracturedCore(args)
	if self:Mythic() then
		self:StopBar(CL.count:format(self:SpellName(360412), exposedCoreCount)) -- Exposed Core
		self:StopBar(CL.count:format(self:SpellName(360906), refractedBlastCount)) -- Refracted Blast
		self:StopBar(CL.count:format(L.sentry, tankAddCount)) -- Pre-Fabricated Sentry
		self:StopBar(CL.count:format(L.materium, smallAddCount)) -- Volatile Materium
		self:StopBar(359610)  -- Deresolution

		self:SetStage(2)
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		self:CDBar(360906, 6, CL.count:format(self:SpellName(360906), refractedBlastCount)) -- Refracted Blast
		self:CDBar(360162, 7.5, CL.count:format(args.spellName, splitResolutionCount)) -- Split Resolution
		self:CDBar(364881, 11.5, CL.count:format(args.spellName, matterDisolutionCount)) -- Matter Dissolution
		self:CDBar(360414, 25) -- Pneumatic Impact
	end
end

function mod:SplitResolution(args)
	self:StopBar(CL.count:format(args.spellName, splitResolutionCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, splitResolutionCount))
	self:PlaySound(args.spellId, "alarm")
	splitResolutionCount = splitResolutionCount + 1
	self:Bar(args.spellId, (self:Mythic() and self:GetStage() == 1) and timers[args.spellId][splitResolutionCount] or 31.5, CL.count:format(args.spellName, splitResolutionCount))
end

do
	local playerList = {}
	function mod:MatterDisolution(args)
		self:StopBar(CL.count:format(args.spellName, matterDisolutionCount))
		playerList = {}
		matterDisolutionCount = matterDisolutionCount + 1
		self:Bar(args.spellId, (self:Mythic() and self:GetStage() == 1) and timers[args.spellId][matterDisolutionCount] or 20.5, CL.count:format(args.spellName, matterDisolutionCount))
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
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, matterDisolutionCount-1))
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
	pneumaticImpactCount = pneumaticImpactCount + 1
	self:Bar(args.spellId, (self:Mythic() and self:GetStage() == 1) and timers[args.spellId][matterDisolutionCount] or 30.4)
end

function mod:CoreOverload(args)
	self:StopBar(CL.count:format(self:SpellName(359610), deresolutionCount)) -- Deresolution
	self:StopBar(CL.count:format(self:SpellName(360906), refractedBlastCount)) -- Refracted Blast
	self:StopBar(CL.count:format(self:SpellName(360162), splitResolutionCount)) -- Split Resolution
	self:StopBar(CL.count:format(self:SpellName(364881), matterDisolutionCount)) -- Matter Dissolution
	self:StopBar(360414) -- Pneumatic Impact

	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end
