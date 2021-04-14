
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Moam", 509)
if not mod then return end
mod:RegisterEnableMob(15340)
mod:SetAllowWin(true)
mod:SetEncounterID(720)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Moam"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		25685, -- Energize
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Energize", 25685)
	self:Log("SPELL_AURA_REMOVED", "EnergizeRemoved", 25685)
end

function mod:OnEngage()
	self:Message(25685, "yellow", CL.custom_start_s:format(self.displayName, self:SpellName(25685), 90), false)
	self:Bar(25685, 90) -- Energize
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Energize(args)
	-- Adds spawned
	self:Message(25685, "yellow")
	self:PlaySouund(25685, "long")
	local duration = 90
	-- Need to find the mana regen rate because he comes back at 100% regardless
	-- local unit = self:GetUnitIdByGUID(args.sourceGUID)
	-- if unit then
	-- 	duration = math.min(90, (100 - UnitPower(unit)) / mps)
	-- end

	self:Bar(25685, duration, args.destName)
end

function mod:EnergizeRemoved(args)
	self:StopBar(args.destName)

	self:Message(25685, "yellow", CL.over:format(args.spellName))
	self:PlaySouund(25685, "long")
	self:Bar(25685, 90)
end
