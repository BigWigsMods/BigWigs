
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackhand", 988, 959)
if not mod then return end
mod:RegisterEnableMob(77325)
mod.engageId = 1704
mod.respawnTime = 29.5

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local smashCount, markCount, siegemakerCount = 1, 1, 1
local massiveSmashProximity = nil
local oldIcon, tankName = nil, nil -- Massive Shattering Smash marker
local slagBombTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.siegemaker = -9571 -- Siegemaker
	L.siegemaker_icon = "ability_vehicle_siegeenginecharge"

	L.custom_off_markedfordeath_marker = "Marked for Death marker"
	L.custom_off_markedfordeath_marker_desc = "Mark Marked for Death targets with {rt1}{rt2}{rt3}, requires promoted or leader."
	L.custom_off_markedfordeath_marker_icon = 1

	L.custom_off_massivesmash_marker = "Massive Shattering Smash marker"
	L.custom_off_massivesmash_marker_desc = "Mark the tank getting hit with Massive Shattering Smash with {rt6}, requires promoted or leader."
	L.custom_off_massivesmash_marker_icon = 6
end

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
		{156728, "PROXIMITY"}, -- Explosive Round
		--[[ Stage Three: Iron Crucible ]]--
		{158054, "PROXIMITY"}, -- Massive Shattering Smash
		"custom_off_massivesmash_marker",
		156928, -- Slag Eruption
		{157000, "FLASH", "SAY", "PROXIMITY"}, -- Attach Slag Bombs
		--[[ General ]]--
		155992, -- Shattering Smash
		{156096, "FLASH", "SAY"}, -- Marked for Death
		"custom_off_markedfordeath_marker",
		156107, -- Impaling Throw
		156030, -- Throw Slag Bombs
		"stages",
		--[[ Mythic ]]--
		163008, -- Massive Explosion
		162585, -- Falling Debris
	}, {
		[156425] = -8814, -- Stage One: The Blackrock Forge
		["siegemaker"] = -8816, -- Stage Two: Storage Warehouse
		[158054] = -8818, -- Stage Three: Iron Crucible
		[155992] = "general",
		[163008] = "mythic",
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
	self:Log("SPELL_AURA_APPLIED", "AttachSlagBombs", 157000, 159179)
	self:Log("SPELL_AURA_REMOVED", "AttachSlagBombsOver", 157000, 159179)
	self:Log("SPELL_ENERGIZE", "SmashReschedule", 104915)
	-- Mythic
	self:Log("SPELL_CAST_START", "MassiveExplosion", 163008)
	self:Log("SPELL_CAST_SUCCESS", "FallingDebris", 162579)
end

function mod:OnEngage()
	phase = 1
	smashCount = 1
	massiveSmashProximity = nil
	slagBombTimer = nil
	self:Bar(156030, 6) -- Throw Slag Bombs
	self:Bar(156425, 15.5) -- Demolition
	self:Bar(156096, 36) -- Marked for Death
	self:CDBar(155992, 21, CL.count:format(self:SpellName(128270), smashCount)) -- Shattering Smash, 128270 = "Smash"
end

function mod:OnBossDisable()
	if self.db.profile.custom_off_massivesmash_marker and tankName then
		SetRaidTarget(tankName, oldIcon or 0)
		tankName = nil
		oldIcon = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_TARGET(unit)
	local newTarget = self:UnitName("boss1target")
	-- No target or target isn't a tank
	if not newTarget or not self:Tank(newTarget) then return end

	if not tankName then -- He had no target when we tried to open proximity
		tankName = newTarget

		if self.db.profile.custom_off_massivesmash_marker then
			oldIcon = GetRaidTargetIndex(tankName)
			SetRaidTarget(tankName, 6)
		end
	else -- We already have a tank
		if newTarget ~= tankName then -- new tank
			if self.db.profile.custom_off_massivesmash_marker then
				SetRaidTarget(tankName, oldIcon or 0) -- restore old icon
				tankName = newTarget -- mark new tank
				oldIcon = GetRaidTargetIndex(tankName)
				SetRaidTarget(tankName, 6)
			else
				tankName = self:UnitName("boss1target")
			end
		else -- same tank, we don't need to do anything
			return
		end
	end

	self:OpenProximity(158054, 6, tankName, true)
	massiveSmashProximity = true
end

local function closeSmashProximity(self)
	if massiveSmashProximity then
		if self.db.profile.custom_off_massivesmash_marker then
			SetRaidTarget(tankName, oldIcon or 0)
			tankName = nil
			oldIcon = nil
		end

		self:CloseProximity(158054)
		massiveSmashProximity = nil
	end
	self:UnregisterUnitEvent("UNIT_TARGET", "boss1")
end

local function openSmashProximity(self)
	if not massiveSmashProximity then
		tankName = self:UnitName("boss1target")

		if tankName then
			if self.db.profile.custom_off_massivesmash_marker then
				oldIcon = GetRaidTargetIndex(tankName)
				SetRaidTarget(tankName, 6)
			end

			self:OpenProximity(158054, 6, tankName, true)
			massiveSmashProximity = true
		end
		self:ScheduleTimer(closeSmashProximity, 5, self)
		self:RegisterUnitEvent("UNIT_TARGET", nil, "boss1")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 156991 then -- Throw Slag Bombs
		if phase < 3 then
			self:Message(156030, "Attention", self:Melee() and "Long")
			self:Bar(156030, 25)
		end
	elseif spellId == 156425 then -- Demolition
		self:Message(spellId, "Urgent", "Alert")
		local massiveDemolition = self:SpellName(156479) -- Massive Demolition
		local mythic = self:Mythic()
		self:Bar(spellId, 6, CL.count:format(massiveDemolition, 1))
		if mythic then
			self:ScheduleTimer("Bar", 3, spellId, 6, CL.count:format(massiveDemolition, 2))
			self:ScheduleTimer("Message", 3, spellId, "Urgent", "Alert", CL.count:format(massiveDemolition, 2))
			self:ScheduleTimer("Bar", 6, spellId, 6, CL.count:format(massiveDemolition, 3))
			self:ScheduleTimer("Message", 6, spellId, "Urgent", "Alert", CL.count:format(massiveDemolition, 3))
			self:ScheduleTimer("Bar", 9, spellId, 6, CL.count:format(massiveDemolition, 4))
			self:ScheduleTimer("Message", 9, spellId, "Urgent", "Alert", CL.count:format(massiveDemolition, 4))
		else
			self:ScheduleTimer("Bar", 5, spellId, 6, CL.count:format(massiveDemolition, 2))
			self:ScheduleTimer("Bar", 10, spellId, 6, CL.count:format(massiveDemolition, 3))
		end
		self:Bar(spellId, mythic and 30.5 or 45.5)
	elseif spellId == 161347 then -- Jump To Second Floor, after reaching middle, entering p2
		smashCount = 1
		markCount = 1
		siegemakerCount = 1

		self:Bar(156030, 12) -- Throw Slag Bombs
		self:Bar("siegemaker", 16, CL.count:format(self:SpellName(L.siegemaker), siegemakerCount), L.siegemaker_icon)
		self:CDBar(155992, self:Mythic() and 18.5 or 22, CL.count:format(self:SpellName(128270), smashCount)) -- Shattering Smash, 128270 = "Smash"
		self:Bar(156096, 26, CL.count:format(self:SpellName(156096), 1)) -- Marked for Death
		if not self:LFR() and self:Ranged() then
			self:OpenProximity(156728, 7) -- Explosive Round
		end

	elseif spellId == 158021 then -- Marked for Death Clear, before running to middle of room, starting p2
		if phase == 1 then
			self:StopBar(CL.count:format(self:SpellName(128270), smashCount)) -- Shattering Smash (Smash)
			self:StopBar(156425) -- Demolition
			self:StopBar(156107) -- Impaling Throw
			self:StopBar(156096) -- Marked for Death
			self:StopBar(156030) -- Throw Slag Bombs

			phase = 2
			self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
		end
	elseif spellId == 161348 then -- Jump To Third Floor
		self:StopBar(CL.count:format(self:SpellName(128270), smashCount)) -- Shattering Smash (Smash)
		smashCount = 1
		phase = 3

		self:StopBar(156030) -- Throw Slag Bombs
		self:StopBar(CL.count:format(self:SpellName(L.siegemaker), siegemakerCount))
		self:StopBar(CL.count:format(self:SpellName(156096), markCount)) -- Marked for Death
		self:StopBar(156107) -- Impaling Throw
		if not self:LFR() and self:Ranged() then
			self:CloseProximity(156728) -- Explosive Round
		end

		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
		self:Bar(157000, 12) -- Attach Slag Bombs
		self:Bar(156096, 16) -- Marked for Death
		self:CDBar(158054, 26, CL.count:format(self:SpellName(128270), smashCount)) -- Massive Shattering Smash, 128270 = "Smash"
		self:ScheduleTimer(openSmashProximity, 23, self)
		self:Bar(156928, 31.5) -- Slag Eruption
		if self:Mythic() then
			self:Bar(162585, 12) -- Falling Debris
		end
	end
end

function mod:ShatteringSmash(args)
	self:Message(155992, "Urgent", "Warning", CL.count:format(self:SpellName(128270), smashCount)) -- 128270 = "Smash"
	smashCount = smashCount + 1
	local cd = self:Mythic() and 30 or phase == 2 and 45 or (phase == 1 and smashCount == 2 and 35) or 30 -- this is getting a bit unwieldy
	self:CDBar(155992, cd, CL.count:format(self:SpellName(128270), smashCount)) -- 128270 = "Smash"
end

do
	local list = mod:NewTargetList()
	function mod:MarkedForDeathApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, phase == 3 and "Important" or "Attention", "Alarm", phase == 2 and CL.count:format(args.spellName, markCount), nil, phase == 3)
			self:Bar(156107, 5) -- Impaling Throw
			markCount = markCount + 1
			if markCount > 3 and not self:Mythic() then markCount = 1 end
			self:Bar(args.spellId, phase == 3 and 21 or 16, phase == 2 and CL.count:format(args.spellName, markCount))
			-- won't cast Shattering Smash while Marked for Death is out (will also sometimes cast Slag Bombs first)
			local smashTime = self:BarTimeLeft(CL.count:format(self:SpellName(128270), smashCount))
			if smashTime < 6 then
				self:CDBar(155992, 6, CL.count:format(self:SpellName(128270), smashCount))
			end
		end

		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, 28836) -- 28836 = "Mark"
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
	self:Message("siegemaker", "Attention", nil, CL.count:format(self:SpellName(L.siegemaker), siegemakerCount), L.siegemaker_icon)
	siegemakerCount = siegemakerCount + 1
	self:Bar("siegemaker", 50, CL.count:format(self:SpellName(L.siegemaker), siegemakerCount), L.siegemaker_icon)
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

do
	local scheduled = nil
	function mod:SmashReschedule(args)
		if scheduled then
			self:CancelTimer(scheduled)
		end
		local nextSmash = (100-UnitPower("boss1"))/4
		scheduled = self:ScheduleTimer(openSmashProximity, nextSmash-3, self)
		self:CDBar(158054, nextSmash, CL.count:format(self:SpellName(128270), smashCount)) -- 128270 = "Smash"
	end
	function mod:MassiveShatteringSmash(args)
		self:Message(args.spellId, "Urgent", "Warning", CL.count:format(self:SpellName(128270), smashCount)) -- 128270 = "Smash"
		smashCount = smashCount + 1
		self:CDBar(args.spellId, 25, CL.count:format(self:SpellName(128270), smashCount)) -- 128270 = "Smash"
		scheduled = self:ScheduleTimer(openSmashProximity, 22, self) -- 3 sec before + 2 sec cast should be enough
	end
end

do
	local list = mod:NewTargetList()
	function mod:AttachSlagBombs(args)
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			local bomb = self:SpellName(155192) -- Bomb
			self:TargetBar(157000, 5, args.destName, bomb)
			self:Flash(157000)
			self:Say(157000, bomb)
			self:OpenProximity(157000, 10)
		end
		local count = #list
		if count == 1 then
			self:PlaySound(157000, "Alert") -- Play sound ASAP
			self:Bar(157000, 25)
			slagBombTimer = self:ScheduleTimer("TargetMessage", 1.8, 157000, list, "Urgent")
		elseif count == 3 then
			self:CancelTimer(slagBombTimer)
			self:TargetMessage(157000, list, "Urgent")
		end
	end
	function mod:AttachSlagBombsOver(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(157000)
		end
	end
end

function mod:SlagEruption(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 33)
end

function mod:MassiveExplosion(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:Bar(args.spellId, 5)
end

function mod:FallingDebris(args)
	self:Message(162585, "Important", "Alarm")
	self:Bar(162585, 40)
	self:Bar(162585, 6, CL.cast:format(args.spellName))
end

