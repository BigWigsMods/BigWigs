
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Bloodlord Mandokir", 309)
if not mod then return end
mod:RegisterEnableMob(11382, 14988) -- Bloodlord Mandokir, Ohgan
mod:SetAllowWin(true)
mod:SetEncounterID(787)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Bloodlord Mandokir"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{16856, "TANK_HEALER"}, -- Mortal Strike
		{24314, "ICON"}, -- Threatening Gaze
		24318, -- Enrage
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MortalStrike", 16856)
	self:Log("SPELL_AURA_APPLIED", "ThreateningGaze", 24314)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 24318)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MortalStrike(args)
	self:TargetMessage(16856, "purple", args.destName)
	self:PlaySound(16856, "warning")
	self:TargetBar(16856, 5, args.destName)
end

function mod:ThreateningGaze(args)
	self:TargetMessage(24314, "yellow", args.destName)
	self:PlaySound(24314, "info")
	self:PrimaryIcon(24314, args.destName)
end

function mod:Enrage(args)
	self:TargetMessage(24318, "red", args.destName)
	self:PlaySound(24318, "alarm")
end
