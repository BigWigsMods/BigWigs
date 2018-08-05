
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vectis", 1861, 2166)
if not mod then return end
mod:RegisterEnableMob(134442)
mod.engageId = 2134
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local pathogenBombCount = 1
local nextLiquify = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{265178, "TANK"}, -- Evolving Affliction
		267242, -- Contagion
		{265212, "SAY", "ICON"}, -- Gestate
		265217, -- Liquefy
		266459, -- Pathogen Bomb
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "EvolvingAffliction", 265178)
	self:Log("SPELL_AURA_APPLIED", "EvolvingAfflictionApplied", 265178)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EvolvingAfflictionApplied", 265178)
	self:Log("SPELL_CAST_START", "Contagion", 267242)
	self:Log("SPELL_CAST_START", "Gestate", 265209)
	self:Log("SPELL_AURA_APPLIED", "GestateApplied", 265212)
	self:Log("SPELL_AURA_REMOVED", "GestateRemoved", 265212)
	self:Log("SPELL_CAST_START", "Liquefy", 265217)
	self:Log("SPELL_AURA_REMOVED", "LiquefyRemoved", 265217)
	self:Log("SPELL_CAST_SUCCESS", "PathogenBomb", 266459)
end

function mod:OnEngage()
	self:Bar(267242, self:Easy() and 20.5 or 11.5) -- Contagion
	self:Bar(265212, self:Easy() and 10.5 or 14.5) -- Gestate

	nextLiquify = GetTime() + 90
	self:Bar(265217, 90) -- Liquefy
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EvolvingAffliction(args)
	if nextLiquify > GetTime() + 8.5 then
		self:Bar(args.spellId, 8.5)
	end
end

function mod:EvolvingAfflictionApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", args.destName)
end

function mod:Contagion(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	local timer = self:Easy() and 23.1 or 13.5
	if nextLiquify > GetTime() + timer then
		self:Bar(args.spellId, timer)
	end
end

do
	local targetFound = false
	local function printTarget(self, name, guid)
		if not self:Tank(name) then
			targetFound = true
			if self:Me(guid) then
				self:PlaySound(265212, "alert", nil, name)
				self:Say(265212)
			end
			self:TargetMessage2(265212, "orange", name)
			self:PrimaryIcon(265212, name)
		end
	end

	function mod:Gestate(args)
		targetFound = false
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		local timer = self:Easy() and 25 or 30
		if nextLiquify > GetTime() + timer then
			self:CDBar(265212, timer)
		end
	end

	function mod:GestateApplied(args)
		if not targetFound then
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "alert")
				self:Say(args.spellId)
				self:SayCountdown(args.spellId, 5)
			end
			self:TargetMessage2(args.spellId, "orange", args.destName)
			self:PrimaryIcon(265212, args.destName)
		elseif self:Me(args.destGUID) then
			self:SayCountdown(args.spellId, 5)
		end
	end

	function mod:GestateRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:PrimaryIcon(args.spellId)
	end
end

function mod:Liquefy(args)
	self:Message(args.spellId, "cyan", nil, CL.intermission)
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 33)

	self:StopBar(265209) -- Gestate
	self:StopBar(267242) -- Contagion
	self:StopBar(265178) -- Evolving Affliction

	pathogenBombCount = 1
	self:Bar(266459, 13.5) -- Pathogen Bomb
end

function mod:LiquefyRemoved(args)
	self:Message(args.spellId, "cyan", nil, CL.over:format(CL.intermission))
	self:PlaySound(args.spellId, "info")

	self:Bar(265178, 5.5) -- Evolving Affliction
	self:Bar(267242, 15.5) -- Contagion
	self:Bar(265212, 19) -- Gestate

	nextLiquify = GetTime() + 93
	self:Bar(args.spellId, 93)
end



function mod:PathogenBomb(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	pathogenBombCount = pathogenBombCount + 1
	if pathogenBombCount < 3 then
		self:Bar(args.spellId, 12.2)
	end
end
