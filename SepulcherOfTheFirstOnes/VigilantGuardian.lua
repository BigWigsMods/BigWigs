if not IsTestBuild() then return end
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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		360403, -- Force Field
		360458, -- Unstable Core
		361001, -- Wave of Disintegration
		364447, -- Dissonance
		360355, -- Energy Conversion
		360375, -- Deresolution
		360412, -- Exposed Core
		360162, -- Split Resolution
		{364881, "SAY", "SAY_COUNTDOWN"}, -- Matter Disolution
		364962, -- Core Overload
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ForceFieldApplied", 360403)
	self:Log("SPELL_AURA_REMOVED", "ForceFieldRemoved", 360403)
	self:Log("SPELL_AURA_APPLIED", "UnstableCoreApplied", 360458)
	self:Log("SPELL_AURA_REMOVED", "UnstableCoreRemoved", 360458)
	self:Log("SPELL_CAST_START", "WaveOfDisintegration", 361001)
	self:Log("SPELL_CAST_START", "Dissonance", 364447)
	self:Log("SPELL_AURA_APPLIED", "DissonanceApplied", 364447)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DissonanceApplied", 364447)
	self:Log("SPELL_CAST_SUCCESS", "EnergyConversion", 360355)
	self:Log("SPELL_CAST_SUCCESS", "Deresolution", 360375)
	self:Log("SPELL_AURA_APPLIED", "ExposedCoreApplied", 360412)
	self:Log("SPELL_CAST_START", "SplitResolution", 360162)
	self:Log("SPELL_AURA_APPLIED", "MatterDisolutionApplied", 364881)
	self:Log("SPELL_AURA_REMOVED", "MatterDisolutionRemoved", 364881)
	self:Log("SPELL_CAST_SUCCESS", "CoreOverload", 364962)
end

function mod:OnEngage()
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
	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
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

function mod:EnergyConversion(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, duration)
end

function mod:Deresolution(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, duration)
end

function mod:ExposedCoreApplied(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, duration)
end

function mod:SplitResolution(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, duration)
end

do
	local prev = 0
	local playerList = {}
	function mod:MatterDisolutionApplied(args)
		local t = args.time
		if t-prev > 5 then
			playerList = {}
			prev = t
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		else
			self:PlaySound(args.spellId, "alert")
		end
		self:TargetMessage(args.spellId, "orange", args.destName)
	end

	function mod:MatterDisolutionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:CoreOverload(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end
