
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Baron Geddon", 409, 1524)
if not mod then return end
mod:RegisterEnableMob(12056)
mod.toggleOptions = {{20475, "FLASH", "ICON", "PROXIMITY", "SAY"}, 19695, 20478}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "LivingBomb", 20475)
	self:Log("SPELL_AURA_REMOVED", "LivingBombRemoved", 20475)
	self:Log("SPELL_CAST_SUCCESS", "Inferno", 19695)
	self:Log("SPELL_CAST_SUCCESS", "Armageddon", 20478)

	self:Death("Win", 12056)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LivingBomb(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 9)
		self:Say(args.spellId)
	else
		self:OpenProximity(args.spellId, 9, args.destName)
	end
	self:TargetMessage(args.spellId, args.destName, "blue", "Alarm")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 8, args.destName)
end

function mod:LivingBombRemoved(args)
	self:CloseProximity(args.spellId)
end

function mod:Inferno(args)
	self:Message(args.spellId, "red", "Long")
	self:Bar(args.spellId, 8)
end

function mod:Armageddon(args)
	self:Bar(args.spellId, 8)
	self:Message(args.spellId, "orange")
end

