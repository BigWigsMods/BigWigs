
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackrock Foundry Trash", 988)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	87719, -- Ogron Hauler
	80423, -- Thunderlord Beast-Tender
	78978, -- Darkshard Gnasher
	79208, -- Blackrock Enforcer
	76906, -- Operator Thogar, alternative for Blast Furnace Exhaust (87366)
	87989 -- Forgemistress Flamehand
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.hauler = "Ogron Hauler"
	L.beasttender = "Thunderlord Beast-Tender"
	L.gnasher = "Darkshard Gnasher"
	L.enforcer = "Blackrock Enforcer"
	L.furnace = "Blast Furnace Exhaust"
	L.mistress = "Forgemistress Flamehand"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Ogron Hauler ]]--
		{175765, "TANK"}, -- Overhead Smash
		--[[ Thunderlord Beast-Tender ]]--
		{162663, "FLASH"}, -- Electrical Storm
		--[[ Darkshard Gnasher ]]--
		{159632, "FLASH"}, -- Insatiable Hunger
		--[[ Blackrock Enforcer ]]--
		{160260, "FLASH"}, -- Fire Bomb
		--[[ Blast Furnace Exhaust ]]--
		{174773, "FLASH"}, -- Exhaust Fumes
		--[[ Forgemistress Flamehand ]]--
		{175583, "FLASH", "SAY", "PROXIMITY"},
		{175594, "TANK"},
	}, {
		[175765] = L.hauler,
		[162663] = L.beasttender,
		[159632] = L.gnasher,
		[160260] = L.enforcer,
		[174773] = L.furnace,
		[175583] = L.mistress,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Death("Disable", 87719, 87989) -- Ogron Hauler, Forgemistress Flamehand

	self:Log("SPELL_AURA_APPLIED", "BadStuffUnderYou", 162663, 160260, 174773) -- Electrical Storm, Fire Bomb, Exhaust Fumes
	self:Log("SPELL_PERIODIC_DAMAGE", "BadStuffUnderYou", 162663, 160260, 174773)
	self:Log("SPELL_PERIODIC_MISSED", "BadStuffUnderYou", 162663, 160260, 174773)

	self:Log("SPELL_AURA_APPLIED", "OverheadSmash", 175765)
	self:Log("SPELL_AURA_REMOVED", "OverheadSmashRemoved", 175765)

	self:Log("SPELL_AURA_APPLIED", "InsatiableHunger", 159632)
	self:Log("SPELL_AURA_REMOVED", "InsatiableHungerRemoved", 159632)

	self:Log("SPELL_CAST_START", "LivingBlazeCast", 175583)
	self:Log("SPELL_AURA_APPLIED", "LivingBlaze", 175583)
	self:Log("SPELL_AURA_REMOVED", "LivingBlazeRemoved", 175583)

	self:Log("SPELL_AURA_APPLIED_DOSE", "Burning", 175594)
	self:Log("SPELL_AURA_REMOVED", "BurningRemoved", 175594)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:BadStuffUnderYou(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Ogron Hauler ]]--

function mod:OverheadSmash(args)
	if self:Tank(args.destName) then
		self:TargetBar(args.spellId, 10, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	end
end

function mod:OverheadSmashRemoved(args)
	if self:Tank(args.destName) then
		self:StopBar(args.spellId, args.destName)
	end
end

--[[ Darkshard Gnasher ]]--

function mod:InsatiableHunger(args)
	self:TargetBar(args.spellId, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:InsatiableHungerRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, CL.over:format(args.spellName))
	end
end

--[[ Forgemistress Flamehand ]]--

function mod:LivingBlazeCast(args)
	self:Bar(args.spellId, 23)
end

function mod:LivingBlaze(args)
	self:TargetBar(args.spellId, 10, args.destName)
	if self:Me(args.destGUID) then
		if not self:LFR() then
			self:Say(args.spellId)
		end
		self:OpenProximity(args.spellId, 6)
		self:Flash(args.spellId)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:LivingBlazeRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, CL.over:format(args.spellName))
		self:CloseProximity(args.spellId)
	end
end

function mod:Burning(args)
	if args.amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", args.amount > 6 and "Warning")
	end
end

function mod:BurningRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Warning", CL.over:format(args.spellName))
	end
end

