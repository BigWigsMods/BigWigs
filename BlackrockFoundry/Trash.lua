
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
	81114, -- Gronnling Laborer
	78978, -- Darkshard Gnasher
	79208, -- Blackrock Enforcer
	80708, -- Iron Taskmaster
	78832, -- Grom'kar Man-at-Arms, alternative for Blast Furnace Exhaust (87366)
	84860, -- Iron Earthbinder
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
	L.gronnling = "Gronnling Laborer"
	L.gnasher = "Darkshard Gnasher"
	L.enforcer = "Blackrock Enforcer"
	L.taskmaster = "Iron Taskmaster"
	L.furnace = "Blast Furnace Exhaust"
	L.earthbinder = "Iron Earthbinder"
	L.mistress = "Forgemistress Flamehand"

	L.furnace_msg1 = "Hmm, kinda toasty isn't it?"
	L.furnace_msg2 = "It's marshmallow time!"
	L.furnace_msg3 = "This can't be good..."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Workshop Guardian ]]--
		175643, -- Spinning Blade
		{175624, "HEALER"}, -- Grievous Mortal Wounds
		--[[ Ogron Hauler ]]--
		{175765, "TANK"}, -- Overhead Smash
		--[[ Thunderlord Beast-Tender ]]--
		162663, -- Electrical Storm
		--[[ Slagshop Brute ]]--
		{175993, "FLASH"}, -- Lumbering Strength
		--[[ Gronnling Laborer ]]--
		18501, -- Enrage
		--[[ Darkshard Gnasher ]]--
		{159632, "FLASH"}, -- Insatiable Hunger
		--[[ Blackrock Enforcer ]]--
		160260, -- Fire Bomb
		--[[ Iron Taskmaster ]]--
		163121, -- Held to Task
		177806, -- Furnace Flame (via furnace next to Taskmaster)
		--[[ Blast Furnace Exhaust ]]--
		174773, -- Exhaust Fumes
		--[[ Iron Earthbinder ]]--
		{171613, "FLASH"}, -- Inferno Totem
		--[[ Forgemistress Flamehand ]]--
		{175583, "FLASH", "SAY", "PROXIMITY"}, -- Living Blaze
		{175594, "TANK"}, -- Burning
	}, {
		[175643] = L.guardian,
		[175765] = L.hauler,
		[162663] = L.beasttender,
		[175993] = L.brute,
		[18501] = L.gronnling,
		[159632] = L.gnasher,
		[160260] = L.enforcer,
		[163121] = L.taskmaster,
		[174773] = L.furnace,
		[171613] = L.earthbinder,
		[175583] = L.mistress,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Death("Disable", 87989) -- Forgemistress Flamehand

	self:Log("SPELL_AURA_APPLIED", "BadStuffUnderYou", 175643, 162663, 160260, 174773) -- Spinning Blade, Electrical Storm, Fire Bomb, Exhaust Fumes
	self:Log("SPELL_PERIODIC_DAMAGE", "BadStuffUnderYou", 175643, 162663, 160260, 174773)
	self:Log("SPELL_PERIODIC_MISSED", "BadStuffUnderYou", 175643, 162663, 160260, 174773)

	self:Log("SPELL_AURA_APPLIED", "GrievousMortalWounds", 175624)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrievousMortalWounds", 175624)
	self:Log("SPELL_AURA_REMOVED", "GrievousMortalWoundsRemoved", 175624)

	self:Log("SPELL_AURA_APPLIED", "OverheadSmash", 175765)
	self:Log("SPELL_AURA_REMOVED", "OverheadSmashRemoved", 175765)

	self:Log("SPELL_AURA_APPLIED", "LumberingStrength", 175993)

	self:Log("SPELL_AURA_APPLIED", "Enrage", 18501, 163121) -- Enrage, Held to Task

	self:Log("SPELL_AURA_APPLIED", "InsatiableHunger", 159632)
	self:Log("SPELL_AURA_REMOVED", "InsatiableHungerRemoved", 159632)

	self:Log("SPELL_AURA_APPLIED", "FurnaceFlameFun", 177806)

	self:Log("SPELL_CAST_SUCCESS", "InfernoTotem", 171613)

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
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Enrage(args) -- Enrage / Held to Task
	if self:Dispeller("enrage", true) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	else
		self:TargetMessage(args.spellId, args.destName, "Attention")
	end
end

--[[ Workshop Guardian ]]--

do
	local scheduledPrints = {}
	function mod:GrievousMortalWounds(args)
		-- The multiple NPCs can apply this simultaneously, so throttle it
		if scheduledPrints[args.destGUID] then
			self:CancelTimer(scheduledPrints[args.destGUID])
		end

		local wound = self:SpellName(16405) -- Wound
		scheduledPrints[args.destGUID] = self:ScheduleTimer("StackMessage", 0.2, args.spellId, args.destName, args.amount, "Urgent", "Warning", wound, nil, true)
		self:TargetBar(args.spellId, 60, args.destName, wound)
	end

	function mod:GrievousMortalWoundsRemoved(args)
		scheduledPrints[args.destGUID] = nil
		local wound = self:SpellName(16405) -- Wound
		self:StopBar(wound, args.destName)
		self:Message(args.spellId, "Positive", nil, CL.other:format(CL.removed:format(wound), self:ColorName(args.destName)))
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
		self:StopBar(args.spellName, args.destName)
	end
end

--[[ Slagshop Brute ]]--

function mod:LumberingStrength(args)
	local icon = CombatLog_String_GetIcon(args.destRaidFlags)
	local warn = false
	local npcUnit = self:GetUnitIdByGUID(args.destGUID)
	if npcUnit then
		for unit in self:IterateGroup() do
			if UnitDetailedThreatSituation(unit, npcUnit) then
				warn = true
				-- NPC gains the buff and chases the tank. We try to warn which tank is being chased.
				self:TargetMessage(args.spellId, self:UnitName(unit), "Important", "Warning", icon .. args.spellName)
				if self:Me(UnitGUID(unit)) then
					self:Flash(args.spellId)
				end
				break
			end
		end
	end
	self:Bar(args.spellId, 8, icon .. args.spellName)
	if not warn then
		self:Message(args.spellId, "Important", nil, icon .. args.spellName)
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
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, CL.over:format(args.spellName))
	end
end

--[[ Iron Taskmaster ]]--

function mod:FurnaceFlameFun(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, L[("furnace_msg%d"):format(random(1,3))])
	end
end

--[[ Iron Earthbinder ]]--

function mod:InfernoTotem(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Flash(args.spellId)
end

--[[ Forgemistress Flamehand ]]--

function mod:LivingBlazeCast(args)
	self:Bar(args.spellId, 23)
end

function mod:LivingBlaze(args)
	if self:Me(args.destGUID) then
		if not self:LFR() then
			self:Say(args.spellId)
		end
		self:OpenProximity(args.spellId, 6)
		self:Flash(args.spellId)
		self:TargetBar(args.spellId, 10, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:LivingBlazeRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, CL.over:format(args.spellName))
		self:CloseProximity(args.spellId)
	end
end

function mod:Burning(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
end

function mod:BurningRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Warning", CL.over:format(args.spellName))
	end
end

