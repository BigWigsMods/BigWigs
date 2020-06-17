
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Jin'do the Hexxer", 309)
if not mod then return end
mod:RegisterEnableMob(11380)
mod:SetAllowWin(true)
mod.engageId = 792

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Jin'do the Hexxer"

	L.brain_wash_message = "Brain Wash Totem"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{24306, "ICON"}, -- Delusions of Jin'do
		{17172, "DISPEL"}, -- Hex
		24262, -- Summon Brain Wash Totem
		24309, -- Powerful Healing Ward
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "DelusionsOfJindo", 24306)
	self:Log("SPELL_AURA_APPLIED", "Hex", 17172)
	self:Log("SPELL_SUMMON", "BrainWashTotem", 24262)
	self:Log("SPELL_SUMMON", "HealingWard", 24309)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DelusionsOfJindo(args)
	self:TargetMessage2(24306, "yellow", args.destName)
	self:PlaySound(24306, "alarm")
	self:PrimaryIcon(24306, args.destName)
end

function mod:Hex(args)
	if self:Dispeller("magic", nil, 17172) then
		self:TargetMessage2(17172, "yellow", args.destName)
		self:PlaySound(17172, "alert")
	end
end

function mod:BrainWashTotem(args)
	self:Message2(24262, "orange", L.brain_wash_message)
end

function mod:HealingWard(args)
	self:Message2(24309, "red")
end
