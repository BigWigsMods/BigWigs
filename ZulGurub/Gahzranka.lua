
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Gahz'ranka", 309)
if not mod then return end
mod:RegisterEnableMob(15114)
mod:SetAllowWin(true)
mod.engageId = 790

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Gahz'ranka"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		21099, -- Frost Breath
		22421, -- Massive Geyser
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FrostBreath", 21099)
	self:Log("SPELL_CAST_START", "MassiveGeyser", 22421)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FrostBreath(args)
	self:Message(21099, "yellow")
	self:PlaySound(21099, "info")
	self:CastBar(21099, 2)
end

function mod:MassiveGeyser(args)
	self:Message(22421, "orange")
	self:PlaySound(22421, "alarm")
end
