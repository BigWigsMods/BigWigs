
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackrock Foundry Trash", 988)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	87719, -- Ogron Hauler
	78978, -- Darkshard Gnasher
	79208, -- Blackrock Enforcer
	76906 -- Operator Thogar, alternative for Blast Furnace Exhaust
	--87366 -- Blast Furnace Exhaust
)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.hauler = "Ogron Hauler"
	L.gnasher = "Darkshard Gnasher"
	L.enforcer = "Blackrock Enforcer"
	L.furnace = "Blast Furnace Exhaust"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Ogron Hauler ]]--
		{175765, "TANK"}, -- Overhead Smash
		--[[ Darkshard Gnasher ]]--
		{159632, "FLASH"}, -- Insatiable Hunger
		--[[ Blackrock Enforcer ]]--
		{160260, "FLASH"}, -- Fire Bomb
		--[[ Blast Furnace Exhaust ]]--
		{174773, "FLASH"}, -- Exhaust Fumes
	}, {
		[175765] = L.hauler,
		[159632] = L.gnasher,
		[160260] = L.enforcer,
		[174773] = L.furnace,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Death("Disable", 87719) -- Ogron Hauler

	self:Log("SPELL_AURA_APPLIED", "OverheadSmash", 175765)
	self:Log("SPELL_AURA_REMOVED", "OverheadSmashRemoved", 175765)

	self:Log("SPELL_AURA_APPLIED", "InsatiableHunger", 159632)
	self:Log("SPELL_AURA_REMOVED", "InsatiableHungerRemoved", 159632)

	self:Log("SPELL_AURA_APPLIED", "FireBomb", 160260)
	self:Log("SPELL_PERIODIC_DAMAGE", "FireBomb", 160260)
	self:Log("SPELL_PERIODIC_MISSED", "FireBomb", 160260)

	self:Log("SPELL_AURA_APPLIED", "ExhaustFumes", 174773)
	self:Log("SPELL_PERIODIC_DAMAGE", "ExhaustFumes", 174773)
	self:Log("SPELL_PERIODIC_MISSED", "ExhaustFumes", 174773)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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

--[[ Blackrock Enforcer ]]--

do
	local prev = 0
	function mod:FireBomb(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Blast Furnace Exhaust ]]--

do
	local prev = 0
	function mod:ExhaustFumes(args) -- Dem trolls yo
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

