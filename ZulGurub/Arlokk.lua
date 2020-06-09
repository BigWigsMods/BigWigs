
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("High Priestess Arlokk", 309)
if not mod then return end
mod:RegisterEnableMob(14515)
mod:SetAllowWin(true)
mod.engageId = 791

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "High Priestess Arlokk"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{12540, "TANK"}, -- Gouge
		{24210, "ICON"}, -- Mark of Arlokk
		24212, -- Shadow Word: Pain
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Gouge", 12540)
	self:Log("SPELL_AURA_APPLIED", "MarkOfArlokk", 24210)
	self:Log("SPELL_AURA_APPLIED", "ShadowWordPain", 24212)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Gouge(args)
	self:TargetMessage2(12540, "purple", args.destName)
	self:PlaySound(12540, "warning")
end

function mod:MarkOfArlokk(args)
	self:TargetMessage2(24210, "red", args.destName)
	self:PlaySound(24210, "alarm")
	self:PrimaryIcon(24210, args.destName)
end

function mod:ShadowWordPain(args)
	self:TargetMessage2(24212, "orange", args.destName)
	if self:Dispeller("magic") then
		self:PlaySound(24212, "alert")
	end
end
