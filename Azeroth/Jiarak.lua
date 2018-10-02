
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ji'arak", -862, 2141)
if not mod then return end
mod:RegisterEnableMob(132253)
mod.otherMenu = -947
mod.worldBoss = 132253

--------------------------------------------------------------------------------
-- Locals
--

local firstStorm, firstCall = true, true

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		260908, -- Storm Wing
		261088, -- Hurricane Crash
		261467, -- Matriarch's Call
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "StormWing", 260908)
	self:Log("SPELL_CAST_SUCCESS", "HurricaneCrash", 261088)
	self:Log("SPELL_CAST_SUCCESS", "MatriarchsCall", 261467)
end

function mod:OnEngage()
	firstStorm, firstCall = true, true
	self:CheckForWipe()
	self:CDBar(260908, 11) -- Storm Wing
	self:CDBar(261467, 30) -- Matriarch's Call
	self:CDBar(261088, 45) -- Hurricane Crash
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2149 then
		self:Win()
	end
end

function mod:StormWing(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, firstStorm and 60 or 45) -- pull:11.0, 59.9, 45.2
	firstStorm = false
end

function mod:HurricaneCrash(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 45)
end

function mod:MatriarchsCall(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, firstCall and 12 or 45) -- pull:29.2, 12.3, 47.8
	firstCall = false
end
