
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Baron Geddon", 409)
if not mod then return end
mod:RegisterEnableMob(12056)
mod:SetAllowWin(true)
mod.engageId = 668

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{20475, "FLASH", "ICON", "PROXIMITY", "SAY"}, -- Living Bomb
		19695, -- Inferno
		20478, -- Armageddon
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "LivingBomb", self:SpellName(20475))
	self:Log("SPELL_AURA_REMOVED", "LivingBombRemoved", self:SpellName(20475))
	self:Log("SPELL_CAST_SUCCESS", "Inferno", self:SpellName(19695))
	self:Log("SPELL_CAST_SUCCESS", "Armageddon", self:SpellName(20478))

	self:Death("Win", 12056)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LivingBomb(args)
	if self:Me(args.destGUID) then
		self:Flash(20475)
		self:OpenProximity(20475, 9)
		self:Say(20475)
	else
		self:OpenProximity(20475, 9, args.destName)
	end
	self:TargetMessage(20475, args.destName, "blue", "Alarm")
	self:PrimaryIcon(20475, args.destName)
	self:TargetBar(20475, 8, args.destName)
end

function mod:LivingBombRemoved(args)
	self:CloseProximity(20475)
end

function mod:Inferno(args)
	self:Message(19695, "red", "Long")
	self:Bar(19695, 8)
end

function mod:Armageddon(args)
	self:Bar(20478, 8)
	self:Message(20478, "orange")
end
