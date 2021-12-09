if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lihuvim, Principal Architect", 2481, 2461)
if not mod then return end
-- mod:RegisterEnableMob(0) -- TODO
mod:SetEncounterID(2539)
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
		364652, -- Protoform Cascade
		363088, -- Cosmic Shift
		{363795, "SAY", "SAY_COUNTDOWN"}, -- Deconstructing Energy
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ProtoformCascade", 364652)
	self:Log("SPELL_CAST_START", "CosmicShift", 363088)
	self:Log("SPELL_AURA_APPLIED", "DeconstructingEnergyApplied", 363795)
	self:Log("SPELL_AURA_REMOVED", "DeconstructingEnergyRemoved", 363795)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ProtoformCascade(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, duration)
end

function mod:CosmicShift(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, duration)
end


do
	local prev = 0
	local playerList = {}
	function mod:DeconstructingEnergyApplied(args)
		local t = args.time
		if t-prev > 5 then
			playerList = {}
			prev = t
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		else
			self:PlaySound(args.spellId, "alert")
		end
		self:TargetMessage(args.spellId, "orange", args.destName)
	end

	function mod:DeconstructingEnergyRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end