
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
		156425, {156401, "FLASH"},
		"siegemaker",
		156928, {157000, "FLASH"},
		{155992, "TANK_HEALER"}, {156096, "FLASH"}, "custom_off_markedfordeath_marker", 156107, 156030, "stages", "bosskill"
	}, {
		[156425] = -8814,
		["siegemaker"] = -8816,
		[156928] = -8818,
		[155992] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "ShatteringSmash", 155992, 159142)
	self:Log("SPELL_AURA_APPLIED", "MarkedForDeathApplied", 156096)
	self:Log("SPELL_AURA_APPLIED", "MarkedForDeathRemoved", 156096)
	-- Stage 1
	self:Emote("Demolition", "156425")
	self:Log("SPELL_PERIODIC_DAMAGE", "MoltenSlagDamage", 156401)
	self:Log("SPELL_PERIODIC_MISSED", "MoltenSlagDamage", 156401)
	-- Stage 2
	self:Emote("Siegemaker", L.siegemaker)
	-- Stage 3
	self:Log("SPELL_CAST_START", "SlagEruption", 156928)
	self:Log("SPELL_CAST_START", "MassiveShatteringSmash", 158054)
	self:Log("SPELL_AURA_APPLIED", "AttachSlagBombs", 157000)
end

function mod:OnEngage()
	phase = 1
	self:Bar(156030, 6) -- Throw Slag Bombs
	self:Bar(156425, 15.5) -- Demolition
	self:Bar(155992, 20) -- Shattering Smash
	self:Bar(156096, 36) -- Marked for Death
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 156998 then -- Throw Slag Bombs
		self:Message(156030, "Attention")
		self:Bar(156030, 25)
	elseif spellId == 161347 then -- Jump To Second Floor
		self:StopBar(156425) -- Demolition
		self:StopBar(156479) -- Massive Demolition
		self:StopBar(156107) -- Impaling Throw

		phase = 2
		self:Message("stages", "Neutral", nil, CL.stage:format(phase))
		self:Bar(156030, 12) -- Throw Slag Bombs
		self:Bar("siegemaker", 16, L.siegemaker, L.siegemaker_icon)
		self:Bar(155992, 25) -- Shattering Smash
		self:Bar(156096, 26) -- Marked for Death

	elseif spellId == 161348 then -- Jump To Third Floor
		self:StopBar(156030) -- Throw Slag Bombs
		self:StopBar(L.siegemaker)
		self:StopBar(156107) -- Impaling Throw

		phase = 3
		self:Message("stages", "Neutral", nil, CL.stage:format(phase))
		self:Bar(157000, 12) -- Attach Slag Bombs
		self:Bar(156096, 16) -- Marked for Death
		self:Bar(155992, 25) -- Shattering Smash
	end
end

function mod:ShatteringSmash(args)
	self:Message(155992, "Urgent", "Warning")
	self:Bar(155992, 30)
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warnTargets(spellId)
		mod:TargetMessage(spellId, list, phase == 3 and "Important" or "Attention", "Alarm", nil, nil, phase == 3)
		scheduled = nil
	end

	function mod:MarkedForDeathApplied(args)
		if not scheduled then
			scheduled = self:ScheduleTimer(warnTargets, 0.1, args.spellId)
			self:Bar(156107, 5) -- Impaling Throw
			self:Bar(args.spellId, phase == 3 and 21 or 16)
		end
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
		end
		if self.profile.custom_off_markedfordeath_marker then
			SetRaidTarget(args.destName, #list)
		end
	end

	function mod:MarkedForDeathRemoved(args)
		if self.profile.custom_off_markedfordeath_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- Stage 1

function mod:Demolition()
	self:Message(156425, "Urgent", "Alert")
	self:Bar(156425, 6, 156479) -- Massive Demolition
	self:Bar(156425, 45.5)
end

do
	local prev = 0
	function mod:MoltenSlagDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

-- Stage 2

function mod:Siegemaker()
	self:Message("siegemaker", "Attention")
	self:Bar("siegemaker", 50)
end

-- Stage 3


function mod:MassiveShatteringSmash(args)
	self:Message(155992, "Urgent", "Warning")
	self:Bar(155992, 25)
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warnTargets(spellId)
		mod:TargetMessage(spellId, list, "Urgent", "Alert", nil, nil, true)
		scheduled = nil
	end
	function mod:AttachSlagBombs(args)
		if not scheduled then
			self:Bar(args.spellId, 5, 157015) -- Slag Bomb
			self:Bar(args.spellId, 25)
		end
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
		end
	end
end

function mod:SlagEruption(args) -- 4:51 5:56
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 65)
end

