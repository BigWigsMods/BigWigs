--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nurgash Muckformed", -1525, 2433)
if not mod then return end
mod:RegisterEnableMob(167526)
mod.otherMenu = -1647
mod.worldBoss = 167526

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		338867, -- Hail of Stones
		338868, -- Deep Slumber
		338864, -- Earthen Blast
		{338863, "HEALER"}, -- Stone Stomp
		{338858, "TANK"}, -- Stone Fist
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "HailOfStones", 338867)
	self:Log("SPELL_CAST_START", "DeepSlumber", 338868)
	self:Log("SPELL_CAST_START", "EarthenBlast", 338864)
	self:Log("SPELL_CAST_START", "StoneStomp", 338863)
	self:Log("SPELL_CAST_START", "StoneFist", 338858)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2408 then
		self:Win()
	end
end

function mod:HailOfStones(args)
	self:Message(args.spellId, "orange")
	self:CastBar(args.spellId, 5)
	if self:Ranged() then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:DeepSlumber(args)
	self:Message(args.spellId, "red", CL.percent:format(50, args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 16) -- 6s cast + 10s buff
end

function mod:EarthenBlast(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 15)
end

function mod:StoneStomp(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
end

function mod:StoneFist(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
end
