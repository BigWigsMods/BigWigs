
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gruul", 988, 1161)
if not mod then return end
mod:RegisterEnableMob(76877)
mod.engageId = 1691
mod.respawnTime = 29.5

--------------------------------------------------------------------------------
-- Locals
--

local rampaging = nil
local sliceTimer = nil
local first = nil
local smashCount = 1
local slamCount = 1
local sliceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.first_ability = "Smash or Slam"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		155080, -- Inferno Slice
		155301, -- Overhead Smash
		155078, -- Overwhelming Blows
		{155326, "PROXIMITY"}, -- Petrifying Slam
		155539, -- Destructive Rampage
		{173192, "FLASH"}, -- Cave In
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "InfernoSlice", 155080)
	self:Log("SPELL_CAST_SUCCESS", "InfernoSliceSuccess", 155080)
	self:Log("SPELL_CAST_START", "OverheadSmash", 155301)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingBlows", 155078)
	self:Log("SPELL_AURA_APPLIED", "PetrifyingSlam", 155323)
	self:Log("SPELL_AURA_APPLIED", "DestructiveRampage", 155539)
	self:Log("SPELL_AURA_REMOVED", "DestructiveRampageOver", 155539)
	self:Log("SPELL_PERIODIC_DAMAGE", "CaveInDamage", 173192)
	self:Log("SPELL_PERIODIC_MISSED", "CaveInDamage", 173192)
end

function mod:OnEngage()
	rampaging = nil
	first = nil
	sliceTimer = nil
	smashCount, slamCount, sliceCount = 1, 1, 1
	self:Bar(155080, self:Mythic() and 9.5 or 14.5, CL.count:format(self:SpellName(155080), sliceCount)) -- Inferno Slice
	self:CDBar(155539, 105) -- Destructive Rampage. Seems he'll always wait for 6 (8 or 9? in mythic) Inferno Slices
	-- it seems that one of these is picked to cast first, slam tends to be sooner, smash can be either 21 or 27 (or 30?)
	self:CDBar(155301, 21, L.first_ability, "ability_kilruk_reave") -- what to use for a key? z.z
	self:CDBar(155326, 21, L.first_ability, "ability_kilruk_reave") -- both!?
	--self:CDBar(155301, 21) -- Overhead Smash
	--self:CDBar(155326, 21) -- Petrifying Slam
	self:Berserk(self:Normal() and 480 or 360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function sliceBar(self, spellId, spellName)
		-- gains 50% of his rage if he hits less than 4 targets
		sliceTimer = nil
		self:Bar(spellId, UnitPower("boss1") > 49 and 5 or 10, CL.count:format(spellName, sliceCount))
	end

	function mod:InfernoSlice(args)
		self:StopBar(CL.count:format(args.spellName, sliceCount)) -- just in case
		self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(CL.count:format(args.spellName, sliceCount)))
		sliceCount = sliceCount + 1
	end

	function mod:InfernoSliceSuccess(args)
		if not self:Mythic() then
			self:Bar(args.spellId, 15, CL.count:format(args.spellName, sliceCount))
		else
			sliceTimer = self:ScheduleTimer(sliceBar, 0.5, self, args.spellId, args.spellName)
		end
	end
end

function mod:OverwhelmingBlows(args)
	if self:Tank() and self:Tank(args.destName) and args.amount % 2 == 0 then -- stacks every 3s
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

function mod:OverheadSmash(args)
	if rampaging then return end
	self:Message(args.spellId, "Attention", "Info")
	smashCount = smashCount + 1
	if smashCount < 4 then -- smash smash smash rampage
		self:CDBar(args.spellId, 21)
	end
	if not first then
		self:CDBar(155326, 15) -- Petrifying Slam. Uncommonly second, not sure how predictable this is
		first = true
	end
end

do
	local petrifyTargets, petrifyOnMe, scheduled = {}, nil, nil
	local function openProximity(self)
		if not petrifyOnMe then
			self:Message(155326, "Urgent", "Alert") -- Petrifying Slam
			self:Bar(155326, 9, 155530) -- Shatter
			self:OpenProximity(155326, 8, petrifyTargets)
		end
		self:ScheduleTimer("CloseProximity", 9, 155326)
		scheduled = nil
	end

	function mod:PetrifyingSlam(args)
		if not scheduled then
			slamCount = slamCount + 1
			if slamCount < 3 then -- slam slam rampage
				self:CDBar(155326, 61) -- 61-64
			end
			wipe(petrifyTargets)
			petrifyOnMe = nil
			scheduled = self:ScheduleTimer(openProximity, 0.2, self)
			if not first then
				self:CDBar(155301, 21) -- Overhead Smash 21-24
				first = true
			end
		end
		petrifyTargets[#petrifyTargets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Message(155326, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Bar(155326, 7, 155506) -- Petrified
			-- Shattering Roar is 2s after Petrified, don't think it merits another bar
			self:OpenProximity(155326, 8)
			petrifyOnMe = true
		end
	end
end

function mod:DestructiveRampage(args) -- Phase 2
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 30)
	rampaging = true
	if sliceTimer then
		self:CancelTimer(sliceTimer)
	end
	self:StopBar(CL.count:format(self:SpellName(155080), sliceCount)) -- Inferno Slice
	self:StopBar(155326) -- Petrifying Slam
	self:StopBar(155301) -- Overhead Smash
end

function mod:DestructiveRampageOver(args) -- Phase 2 over
	self:Message(args.spellId, "Positive", "Info", CL.over:format(args.spellName))
	self:CDBar(args.spellId, 113)
	rampaging = nil
	smashCount, slamCount, sliceCount = 1, 1, 1
	self:Bar(155080, self:Mythic() and 13 or 17, CL.count:format(self:SpellName(155080), sliceCount)) -- Inferno Slice
	self:CDBar(155326, 25) -- Petrifying Slam
	self:CDBar(155301, 31) -- Overhead Smash
end

do
	local prev = 0
	function mod:CaveInDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

