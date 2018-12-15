
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Hailstone Construct", -896, 2197)
if not mod then return end
mod:RegisterEnableMob(140252)
mod.otherMenu = -947
mod.worldBoss = 140252

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{274895, "FLASH"}, -- Freezing Tempest
		274891, -- Glacial Breath
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "FreezingTempest", 274895)
	self:Log("SPELL_CAST_START", "GlacialBreath", 274891)
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(274895, 59) -- Freezing Tempest
	self:CDBar(274891, 21) -- Glacial Breath
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2148 then
		self:Win()
	end
end

function mod:FreezingTempest(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 66) -- pull:59.6, 77.5, 66.1, 80.7 -- pull:59.8, 80.9, 89.6 -- pull:59.9, 73.7, 65.4
	self:Flash(args.spellId)
end

function mod:GlacialBreath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 44) -- pull:21.4, 48.8, 46.0, 47.5, 48.9, 43.9, 44.2
end
