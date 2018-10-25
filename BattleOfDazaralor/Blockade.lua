if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sea Priest Blockade", 2070, 2337)
if not mod then return end
mod:RegisterEnableMob(146251, 146253, 146256) -- Sister Katherine, Brother Joseph, Laminaria
mod.engageId = 2280
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage 1
		286558, -- Tidal Shroud
		-- Sister Katherine
		284262, -- Voltaic Flash
		284106, -- Crackling Lightning
		-- Brother Joseph
		284362, -- Sea Storm
		284383, -- Sea's Temptation XXX Rename bar to "Add"?
		284406, -- Tempting Song
		-- Stage 2
		{285000, "TANK", "SAY_COUNTDOWN"}, -- Kelp-Wrapped
		{285118, "PROXIMITY"}, -- Sea Swell
		285017, -- Ire of the Deep
		{285350, "SAY_COUNTDOWN"}, -- Storm's Wail
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "TidalShroud", 286558)

	-- Sister Katherine
	self:Log("SPELL_CAST_START", "VoltaicFlash", 284262)
	self:Log("SPELL_CAST_START", "CracklingLightning", 284106)

	-- Brother Joseph
	self:Log("SPELL_CAST_START", "SeaStorm", 284362)
	self:Log("SPELL_CAST_START", "SeasTemptation", 284383)
	--self:Log("SPELL_CAST_SUCCESS", "TemptingSong", 284406)
	self:Log("SPELL_AURA_APPLIED", "TemptingSongApplied", 284405, 284410)

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "KelpWrappedApplied", 285000)
	self:Log("SPELL_AURA_APPLIED_DOSE", "KelpWrappedApplied", 285000)
	self:Log("SPELL_AURA_REMOVED", "KelpWrappedRemoved", 285000)
	self:Log("SPELL_CAST_START", "SeaSwell", 285118)
	self:Log("SPELL_CAST_START", "IreoftheDeep", 285017)

	self:Log("SPELL_AURA_APPLIED", "StormsWailApplied", 285350)
	self:Log("SPELL_AURA_REMOVED", "StormsWailRemoved", 285350)
end

function mod:OnEngage()
	self:CDBar(284362, 7) -- Sea Storm
	self:CDBar(284106, 10.5) -- Crackling Lightning
	self:CDBar(284383, 12) -- Sea's Temptation
	self:CDBar(286558, 15.5) -- Tidal Shroud
	self:CDBar(284262, 24) -- Voltaic Flash
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1
do
	local prev = 0
	function mod:TidalShroud(args)
		local t = args.time
		if t-prev > 1 then
			prev = t
			self:Message2(args.spellId, "cyan")
			self:PlaySound(args.spellId, "long")
			self:CDBar(args.spellId, 17)
		end
	end
end

-- Sister Katherine
function mod:VoltaicFlash(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 17)
end

function mod:CracklingLightning(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 17)
end

-- Brother Joseph
function mod:SeaStorm(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 17)
end

function mod:SeasTemptation(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(284406, 7)
end

function mod:TemptingSongApplied(args)
	self:TargetMessage2(284406, "red", args.destName)
	self:PlaySound(284406, "warning")
end

-- Stage 2
function mod:KelpWrappedApplied(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:SayCountdown(args.spellId, 15, nil, 5)
		self:PlaySound(args.spellId, "warning")
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	elseif self:Tank() and self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		if amount > 7 then
			self:PlaySound(args.spellId, "warning", nil, args.destName)
		end
	end
end

function mod:KelpWrappedRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:SeaSwell(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:OpenProximity(args.spellId, 5) -- XXX Open on stage 2 start
end

function mod:IreoftheDeep(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:StormsWailApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:TargetBar(args.spellId, 10, args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:SayCountdown(args.spellId, 10) -- XXX make it different from tank one (or change tank countdown)
	end
end

function mod:StormsWailRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
