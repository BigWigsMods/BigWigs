
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackhand", 988, 959)
if not mod then return end
mod:RegisterEnableMob(77325)
mod.engageId = 1704

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.siegemaker = -9571 -- Siegemaker
	L.siegemaker_icon = "ability_vehicle_siegeenginecharge"

	L.custom_off_markedfordeath_marker = "Marked for Death marker"
	L.custom_off_markedfordeath_marker_desc = "Mark Marked for Death targets with {rt1}{rt2}, requires promoted or leader."
	L.custom_off_markedfordeath_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One: The Blackrock Forge ]]--
		156425, -- Demolition
		{156401, "FLASH"}, -- Molten Slag
		--[[ Stage Two: Storage Warehouse ]]--
		"siegemaker",
		{156653, "SAY"}, -- Fixate
		156667, -- Blackiron Plating
		{156728, "PROXIMITY"},
		--[[ Stage Three: Iron Crucible ]]--
		156928, -- Slag Eruption
		{157000, "FLASH", "SAY"}, -- Attach Slag Bombs
		--[[ General ]]--
		155992, -- Shattering Smash
		{156096, "FLASH"}, -- Marked for Death
		"custom_off_markedfordeath_marker",
		156107, -- Impaling Throw
		156030, -- Throw Slag Bombs
		"stages",
		"bosskill"
	}, {
		[156425] = -8814, -- Stage One: The Blackrock Forge
		["siegemaker"] = -8816, -- Stage Two: Storage Warehouse
		[156928] = -8818, -- Stage Three: Iron Crucible
		[155992] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "ShatteringSmash", 155992, 159142)
	self:Log("SPELL_AURA_APPLIED", "MarkedForDeathApplied", 156096)
	self:Log("SPELL_AURA_REMOVED", "MarkedForDeathRemoved", 156096)
	-- Stage 1
	self:Log("SPELL_PERIODIC_DAMAGE", "MoltenSlagDamage", 156401)
	self:Log("SPELL_PERIODIC_MISSED", "MoltenSlagDamage", 156401)
	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "Siegemaker", 156667) -- Blackiron Plating
	self:Log("SPELL_AURA_REMOVED", "BlackironPlatingRemoved", 156667) -- Blackiron Plating
	self:Log("SPELL_AURA_APPLIED", "Fixate", 156653)
	-- Stage 3
	self:Log("SPELL_CAST_START", "SlagEruption", 156928)
	self:Log("SPELL_CAST_START", "MassiveShatteringSmash", 158054)
	self:Log("SPELL_AURA_APPLIED", "AttachSlagBombs", 157000)
end

function mod:OnEngage()
	phase = 1
	self:Bar(156030, 6) -- Throw Slag Bombs
	self:Bar(156425, 15.5) -- Demolition
	self:CDBar(155992, 21) -- Shattering Smash
	self:Bar(156096, 36) -- Marked for Death
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 156991 then -- Throw Slag Bombs
		if phase < 3 then
			self:Message(156030, "Attention")
			self:Bar(156030, 25)
		end
	elseif spellId == 156425 then -- Demolition
		self:Message(spellId, "Urgent", "Alert")
		local massiveDemolition = self:SpellName(156479) -- Massive Demolition
		self:Bar(spellId, 6, CL.count:format(massiveDemolition, 1))
		self:ScheduleTimer("Bar", 5, spellId, 6, CL.count:format(massiveDemolition, 2))
		self:ScheduleTimer("Bar", 10, spellId, 6, CL.count:format(massiveDemolition, 3))
		self:Bar(spellId, 45.5)
	elseif spellId == 161347 then -- Jump To Second Floor
		self:StopBar(156425) -- Demolition
		self:StopBar(156479) -- Massive Demolition
		self:StopBar(156107) -- Impaling Throw

		phase = 2
		self:Message("stages", "Neutral", nil, CL.stage:format(phase), false)
		self:Bar(156030, 12) -- Throw Slag Bombs
		self:Bar("siegemaker", 16, L.siegemaker, L.siegemaker_icon)
		self:Bar(155992, 23) -- Shattering Smash
		self:Bar(156096, 26) -- Marked for Death
		self:OpenProximity(156728, 7)

	elseif spellId == 161348 then -- Jump To Third Floor
		self:StopBar(156030) -- Throw Slag Bombs
		self:StopBar(L.siegemaker)
		self:StopBar(156107) -- Impaling Throw
		self:CloseProximity(156728)

		phase = 3
		self:Message("stages", "Neutral", nil, CL.stage:format(phase), false)
		self:Bar(157000, 12) -- Attach Slag Bombs
		self:Bar(156096, 16) -- Marked for Death
		self:Bar(155992, 26) -- Shattering Smash
		self:Bar(156928, 31.5) -- Slag Eruption
	end
end

function mod:ShatteringSmash(args)
	self:Message(155992, "Urgent", "Warning")
	self:CDBar(155992, 45)
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, phase == 3 and "Important" or "Attention", "Alarm", nil, nil, phase == 3)
		scheduled = nil
	end

	function mod:MarkedForDeathApplied(args)
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId)
			self:Bar(156107, 5) -- Impaling Throw
			self:Bar(args.spellId, phase == 3 and 21 or 16)
		end
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
		end
		if self.db.profile.custom_off_markedfordeath_marker then
			SetRaidTarget(args.destName, #list)
		end
	end

	function mod:MarkedForDeathRemoved(args)
		if self.db.profile.custom_off_markedfordeath_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- Stage 1

do
	local prev = 0
	function mod:MoltenSlagDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
		end
	end
end

-- Stage 2

function mod:Siegemaker(args)
	self:Message("siegemaker", "Attention", nil, L.siegemaker, L.siegemaker_icon)
	self:Bar("siegemaker", 50, L.siegemaker, L.siegemaker_icon)
end

function mod:BlackironPlatingRemoved(args)
	self:Message(args.spellId, "Attention", "Info", CL.removed:format(args.spellName))
end

function mod:Fixate(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

-- Stage 3

function mod:MassiveShatteringSmash(args)
	self:Message(155992, "Urgent", "Warning")
	self:CDBar(155992, 25)
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, "Urgent", "Alert", nil, nil, true)
		scheduled = nil
	end
	function mod:AttachSlagBombs(args)
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.6, self, args.spellId)
			self:Bar(args.spellId, 25)
		end
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 5, args.destName, 157015) -- Slag Bomb
			self:Flash(args.spellId)
			self:Say(args.spellId, 157015) -- 157015 = Slag Bomb
		end
	end
end

function mod:SlagEruption(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 33)
end

