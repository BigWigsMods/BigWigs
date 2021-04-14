
--------------------------------------------------------------------------------
-- Module declaration
--
-- TODO Hard mode abilities

local mod, CL = BigWigs:NewBoss("Hakkar", 309)
if not mod then return end
mod:RegisterEnableMob(14834)
mod:SetAllowWin(true)
mod.engageId = 793

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Hakkar"

	L.mc_bar = "MC: %s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		24322, -- Blood Siphon
		{24327, "ICON"}, -- Cause Insanity
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "BloodSiphon", 24322)
	self:Log("SPELL_AURA_APPLIED", "CauseInsanity", 24327)
	self:Log("SPELL_AURA_REMOVED", "CauseInsanityRemoved", 24327)
end

function mod:OnEngage()
	self:Berserk(600)

	self:Bar(24327, 20) -- Cause Insanity
	self:Bar(24322, 90) -- Blood Siphon
	self:DelayedMessage(24322, 80, "orange", CL.custom_sec:format(self:SpellName(24322), 10), nil, "alarm")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BloodSiphon(args)
	self:Message(24322, "red")
	self:PlaySound(24322, "long")
	self:Bar(24322, 90)
	self:DelayedMessage(24322, 80, "orange", CL.custom_sec:format(args.spellName, 10), nil, "alarm")
end

function mod:CauseInsanity(args)
	self:TargetMessage(24327, "yellow", args.destName)
	self:PlaySound(24327, "info")
	self:Bar(24327, 10, L.mc_bar:format(args.destName))
	self:CDBar(24327, 20)
	self:PrimaryIcon(24327, args.destName)
end

function mod:CauseInsanityRemoved(args)
	self:StopBar(L.mc_bar:format(args.destName))
end
