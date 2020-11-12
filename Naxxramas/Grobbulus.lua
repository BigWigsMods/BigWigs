--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Grobbulus", 533)
if not mod then return end
mod:RegisterEnableMob(15931)
mod:SetAllowWin(true)
mod.engageId = 1111

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Grobbulus"

	L.bomb_message = "Injection"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{28169, "ICON", "FLASH"}, -- Mutating Injection
		28240, -- Poison Cloud
		"berserk",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Inject", 28169)
	self:Log("SPELL_CAST_SUCCESS", "Cloud", 28240)
end

function mod:OnEngage()
	self:Berserk(720)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Inject(args)
	self:TargetMessage(28169, "blue", args.destName, L.bomb_message)
	if self:Me(args.destGUID) then
		self:PlaySound(28169, "alert")
		self:FlashShake(28169)
	end
	self:TargetBar(28169, 10, args.destName, L.bomb_message)
	self:PrimaryIcon(28169, args.destName)
end

function mod:Cloud(args)
	self:Message(28240, "yellow")
	self:CDBar(28240, 16.2) -- sometimes 14.5
end
