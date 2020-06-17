
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Kurinnaxx", 509)
if not mod then return end
mod:RegisterEnableMob(15348)
mod:SetAllowWin(true)
mod.engageId = 718

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Kurinnaxx"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{25646, "TANK"}, -- Mortal Wound
		25656, -- Sand Trap
		26527, -- Frenzy
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MortalWound", 25646)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalWound", 25646)
	self:Log("SPELL_AURA_REMOVED", "MortalWoundRemoved", 25646)
	self:Log("SPELL_CREATE", "SandTrap", 25648)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 26527)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MortalWound(args)
	local amount = args.amount or 1
	self:StackMessage(25646, args.destName, amount, "purple")
	self:TargetBar(25646, 15, args.destName)
	if amount > 2 then -- warn at 3? 5?
		self:PlaySound(25646, "warning")
	end
end

function mod:MortalWoundRemoved(args)
	self:StopBar(25646, args.destName)
end

function mod:SandTrap()
	self:Message2(25656, "orange")
	self:PlaySound(25656, "alert")
end

function mod:Frenzy(args)
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus")
	self:Message2(26527, "red", "30% - ", args.spellName)
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(UnitGUID(unit)) == 15348 then
		local hp = UnitHealth(unit)
		if hp < 36 then
			self:UnregisterUnitEvent(event, "target", "focus")
			self:Message2(26527, "green", CL.soon:format(self:SpellName(26527)), false)
		end
	end
end
