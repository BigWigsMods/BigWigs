
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Warbringer Yenajz", -942, 2198)
if not mod then return end
mod:RegisterEnableMob(140163)
mod.otherMenu = -947
mod.worldBoss = 140163

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		274932, -- Endless Abyss
		274842, -- Void Nova
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "EndlessAbyss", 274932)
	self:Log("SPELL_CAST_START", "VoidNova", 274842)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2147 then
		self:Win()
	end
end

function mod:EndlessAbyss(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 45)
end

function mod:VoidNova(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
end
