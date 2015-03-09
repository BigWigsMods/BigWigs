
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackrock Foundry Trash", 988)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	87411, -- Workshop Guardian
	87719, -- Ogron Hauler
	80423, -- Thunderlord Beast-Tender
	87780, -- Slagshop Brute
	78978, -- Darkshard Gnasher
	79208, -- Blackrock Enforcer
	80708, -- Iron Taskmaster
	76906, -- Operator Thogar, alternative for Blast Furnace Exhaust (87366)
	87989 -- Forgemistress Flamehand
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.guardian = "Workshop Guardian"
	L.hauler = "Ogron Hauler"
	L.beasttender = "Thunderlord Beast-Tender"
	L.brute = "Slagshop Brute"
	L.gnasher = "Darkshard Gnasher"
	L.enforcer = "Blackrock Enforcer"
	L.taskmaster = "Iron Taskmaster"
	L.furnace = "Blast Furnace Exhaust"
	L.mistress = "Forgemistress Flamehand"

	L.furnace_msg1 = "Hmm, kinda toasty isn't it?"
	L.furnace_msg2 = "It's marshmallow time!"
	L.furnace_msg3 = "This can't be good..."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Workshop Guardian ]]--
		{175643, "FLASH"}, -- Spinning Blade
		--[[ Ogron Hauler ]]--
		{175765, "TANK"}, -- Overhead Smash
		--[[ Thunderlord Beast-Tender ]]--
		{162663, "FLASH"}, -- Electrical Storm
		--[[ Slagshop Brute ]]--
		{175993, "FLASH"}, -- Lumbering Strength
		--[[ Darkshard Gnasher ]]--
		{159632, "FLASH"}, -- Insatiable Hunger
		--[[ Blackrock Enforcer ]]--
		{160260, "FLASH"}, -- Fire Bomb
		--[[ Iron Taskmaster ]]--
		163121, -- Held to Task
		177806, -- Furnace Flame (via furnace next to Taskmaster)
		--[[ Blast Furnace Exhaust ]]--
		{174773, "FLASH"}, -- Exhaust Fumes
		--[[ Forgemistress Flamehand ]]--
		{175583, "FLASH", "SAY", "PROXIMITY"},
		{175594, "TANK"},
	}, {
		[175643] = L.guardian,
		[175765] = L.hauler,
		[162663] = L.beasttender,
		[175993] = L.brute,
		[159632] = L.gnasher,
		[160260] = L.enforcer,
		[163121] = L.taskmaster,
		[174773] = L.furnace,
		[175583] = L.mistress,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Death("Disable", 87989) -- Forgemistress Flamehand

	self:Log("SPELL_AURA_APPLIED", "BadStuffUnderYou", 175643, 162663, 160260, 174773) -- Spinning Blade, Electrical Storm, Fire Bomb, Exhaust Fumes
	self:Log("SPELL_PERIODIC_DAMAGE", "BadStuffUnderYou", 175643, 162663, 160260, 174773)
	self:Log("SPELL_PERIODIC_MISSED", "BadStuffUnderYou", 175643, 162663, 160260, 174773)

	self:Log("SPELL_AURA_APPLIED", "OverheadSmash", 175765)
	self:Log("SPELL_AURA_REMOVED", "OverheadSmashRemoved", 175765)

	self:Log("SPELL_AURA_APPLIED", "LumberingStrength", 175993)

	self:Log("SPELL_AURA_APPLIED", "InsatiableHunger", 159632)
	self:Log("SPELL_AURA_REMOVED", "InsatiableHungerRemoved", 159632)

	self:Log("SPELL_AURA_APPLIED", "HeldToTask", 163121)
	self:Log("SPELL_AURA_APPLIED", "FurnaceFlameFun", 177806)

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

--[[ Slagshop Brute ]]--

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then -- Only if it's targetting you
			self:Message(175993, "Important", "Warning")
			self:Bar(175993, 8)
			self:Flash(175993)
		end
	end
	function mod:LumberingStrength(args)
		self:GetUnitTarget(printTarget, 0, args.destGUID)
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

--[[ Iron Taskmaster ]]--

function mod:HeldToTask(args)
	if self:Dispeller("enrage", true) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	else
		self:TargetMessage(args.spellId, args.destName, "Attention")
	end
end

function mod:FurnaceFlameFun(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, L[("furnace_msg%d"):format(random(1,3))])
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

