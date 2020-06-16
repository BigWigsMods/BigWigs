--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Broodlord Lashlayer", 469)
if not mod then return end
mod:RegisterEnableMob(12017)
mod:SetAllowWin(true)
mod.engageId = 612

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Broodlord Lashlayer"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{24573, "ICON"}, -- Mortal Strike
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MortalStrike", self:SpellName(24573))
	self:Log("SPELL_AURA_REMOVED", "MortalStrikeOver", self:SpellName(24573))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MortalStrike(args)
	self:TargetMessage(24573, args.destName, "yellow")
	self:PrimaryIcon(24573, args.destName)
	self:TargetBar(24573, 5, args.destName)
end

function mod:MortalStrikeOver()
	self:PrimaryIcon(24573)
end

