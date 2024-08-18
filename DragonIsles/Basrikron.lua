--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Basrikron, The Shale Wing", -2022, 2506)
if not mod then return end
mod:RegisterEnableMob(193535) -- Basrikron
mod.otherMenu = -1978
mod.worldBoss = 193535

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		386259, -- Sundering Crash
		386059, -- Awaken Crag
		385270, -- Fracturing Tremors
		385137, -- Shale Breath
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Log("SPELL_CAST_START", "SunderingCrash", 386259)
	self:Log("SPELL_CAST_START", "AwakenCrag", 386059)
	self:Log("SPELL_CAST_START", "ShaleBreath", 385137)
	self:Log("SPELL_AURA_APPLIED", "ShaleBreathApplied", 385137)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2640 then
		self:Win()
	end
end

do
	local prev = ""
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castId, spellId)
		if spellId == 385270 and prev ~= castId then
			prev = castId
			self:Message(385270, "orange")
			self:PlaySound(385270, "alarm")
		end
	end
end

function mod:SunderingCrash(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

function mod:AwakenCrag(args)
	self:Message(args.spellId, "yellow")
end

function mod:ShaleBreath(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShaleBreathApplied(args)
	if self:Tank(args.destName) then
		self:TargetMessage(args.spellId, "purple", args.destName)
		if self:Tank() and not self:Me(args.destGUID) and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
			self:PlaySound(args.spellId, "warning") -- tauntswap
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm") -- On you
		end
	elseif self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end
