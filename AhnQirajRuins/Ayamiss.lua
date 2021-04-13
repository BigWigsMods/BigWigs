
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ayamiss the Hunter", 509)
if not mod then return end
mod:RegisterEnableMob(15369)
mod:SetAllowWin(true)
mod.engageId = 722

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Ayamiss the Hunter"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{25725, "ICON"}, -- Paralyze
		8269, -- Frenzy
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Paralyze", 25725)
	self:Log("SPELL_AURA_REMOVED", "ParalyzeRemoved", 25725)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 8269)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Paralyze(args)
	self:TargetMessage(25725, "yellow", args.destName)
	self:PlaySound(25725, "alarm")
	self:TargetBar(25725, 10, args.destName, 7812, 25725) -- 7812 = Sacrifice
	self:PrimaryIcon(25725, args.destName)
end

function mod:ParalyzeRemoved(args)
	self:PrimaryIcon(25725)
	self:StopBar(7812, args.destName)
end

function mod:Frenzy(args)
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus")
	self:Message(8269, "red")
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 15369 then
		local hp = self:GetHealth(unit)
		if hp < 26 then
			self:UnregisterUnitEvent(event, "target", "focus")
			self:Message(8269, "green", CL.soon:format(self:SpellName(8269)), false)
		end
	end
end
