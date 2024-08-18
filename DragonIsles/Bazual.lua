--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Bazual, The Dreaded Flame", -2024, 2517)
if not mod then return end
mod:RegisterEnableMob(193532) -- Bazual
mod.otherMenu = -1978
mod.worldBoss = 193532

--------------------------------------------------------------------------------
-- Locals
--

local nextHundred = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		389514, -- Lava Breath
		389725, -- Magma Eruption
		389431, -- Deterring Flame
		391247, -- Flame Infusion
		390635, -- Rain of Destruction
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "LavaBreath", 389514)
	self:Log("SPELL_CAST_START", "MagmaEruption", 389725)
	self:Log("SPELL_CAST_START", "DeterringFlame", 389431)
	self:Log("SPELL_CAST_START", "FlameInfusion", 391247)
	self:Log("SPELL_CAST_SUCCESS", "RainOfDestruction", 390635)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2653 then
		self:Win()
	end
end

function mod:LavaBreath(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:MagmaEruption(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
end

function mod:DeterringFlame(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 64)
	nextHundred = args.time + 64
end

function mod:FlameInfusion(args)
	self:Message(args.spellId, "cyan", CL.percent:format(40, args.spellName))
	self:PlaySound(args.spellId, "long")
	local cd = nextHundred - args.time
	if cd > 0 and cd < 65 then
		self:StopBar(389431) -- Deterring Flame
		self:Bar(390635, { math.max(cd, 3), 64 }) -- Rain of Destruction
	end
end

function mod:RainOfDestruction(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 64)
end
