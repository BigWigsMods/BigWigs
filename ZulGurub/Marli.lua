
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("High Priestess Mar'li", 309)
if not mod then return end
mod:RegisterEnableMob(14510)
mod:SetAllowWin(true)
mod.engageId = 786

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "High Priestess Mar'li"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		24083, -- Hatch Eggs
		24300, -- Drain Life
		24099, -- Poison Bolt Volley
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "HatchEggs", 24083)
	self:Log("SPELL_AURA_APPLIED", "DrainLife", 24300)
	self:Log("SPELL_CAST_SUCCESS", "PoisonBoltVolley", 24099)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HatchEggs(args)
	self:Message(24083, "yellow")
	self:PlaySound(24083, "info")
end

function mod:DrainLife(args)
	self:TargetMessage(24300, "orange", args.destName)
	self:PlaySound(24300, "alert")
end

function mod:PoisonBoltVolley(args)
	self:Message(24099, "yellow")
	self:PlaySound(24099, "alarm")
end
