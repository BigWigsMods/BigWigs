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
		284360, -- Sea Storm
		284383, -- Sea's Temptation XXX Rename bar to "Add"?
		284405, -- Tempting Song
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
	self:Log("SPELL_CAST_SUCCESS", "SeaStorm", 284360)
	self:Log("SPELL_CAST_START", "SeasTemptation", 284383)
	self:Log("SPELL_CAST_SUCCESS", "TemptingSong", 284405)

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
		end
	end
end

-- Sister Katherine
function mod:VoltaicFlash(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CracklingLightning(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

-- Brother Joseph
function mod:SeaStorm(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:SeasTemptation(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:TemptingSong(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	end
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
