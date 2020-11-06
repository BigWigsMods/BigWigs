
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Warbringer Yenajz", -942, 2198)
if not mod then return end
mod:RegisterEnableMob(140163)
mod.otherMenu = -947
mod.worldBoss = 140163

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.tear = "You stood in a Reality Tear"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		274932, -- Endless Abyss
		274842, -- Void Nova
		274904, -- Reality Tear
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "EndlessAbyss", 274932)
	self:Log("SPELL_CAST_START", "VoidNova", 274842)
	self:Log("SPELL_AURA_APPLIED", "RealityTear", 274904)
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
	self:CDBar(args.spellId, 22.3)
end

function mod:RealityTear(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", L.tear)
		self:PlaySound(args.spellId, "alarm")
	end
end
