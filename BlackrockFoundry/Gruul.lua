
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gruul", 988, 1161)
if not mod then return end
mod:RegisterEnableMob(76877)
mod.engageId = 1691

--------------------------------------------------------------------------------
-- Locals
--

local rampaging = nil
local smashCount = 1
local slamCount = 1
local sliceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		165300, -- Flare
		--[[ General ]]--
		155080, -- Inferno Slice
		155301, -- Overhead Smash
		{155078, "FLASH"}, -- Overwhelming Blows
		{155326, "PROXIMITY"}, -- Petrifying Slam
		155539, -- Destructive Rampage
		{173192, "FLASH"}, -- Cave In
		"bosskill"
	}, {
		[165300] = "mythic",
		[155080] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "InfernoSlice", 155080)
	self:Log("SPELL_CAST_START", "OverheadSmash", 155301)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingBlows", 155078)
	self:Log("SPELL_AURA_APPLIED", "PetrifyingSlam", 155323)
	self:Log("SPELL_AURA_APPLIED", "PetrifiedApplied", 155506)
	self:Log("SPELL_AURA_REMOVED", "PetrifiedRemoved", 155506)
	self:Log("SPELL_AURA_APPLIED", "DestructiveRampage", 155539)
	self:Log("SPELL_AURA_REMOVED", "DestructiveRampageOver", 155539)
	self:Log("SPELL_PERIODIC_DAMAGE", "CaveInDamage", 173192)
	self:Log("SPELL_PERIODIC_MISSED", "CaveInDamage", 173192)
end

function mod:OnEngage()
	rampaging = nil
	smashCount, slamCount, sliceCount = 1, 1, 1
	self:Bar(155080, 14.5, CL.count:format(self:SpellName(155080), sliceCount)) -- Inferno Slice
	self:CDBar(155301, 22) -- Overhead Smash
	self:CDBar(155326, 27) -- Petrifying Slam
	self:CDBar(155539, 102) -- Destructive Rampage
	if self:Mythic() then
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Flare", "boss1")
		self:CDBar(165300, 6) -- Flare
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Flare(_, spellName, _, _, spellId)
	if spellId == 165303 then -- Flare (Mythic)
		self:CDBar(165300, 6)
	end
end

function mod:InfernoSlice(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(CL.count:format(args.spellName, sliceCount)))
	sliceCount = sliceCount + 1
	if sliceCount < 7 then
		self:Bar(args.spellId, 17, CL.count:format(args.spellName, sliceCount)) -- slice x6 then rampage
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
		self:CDBar(args.spellId, smashCount == 1 and 21 or 34)
	end
end

do
	local petrifyTargets, petrifyOnMe, scheduled = {}, nil, nil
	local function openProximity(self)
		if not petrifyOnMe then
			self:Message(155326, "Urgent", "Alert") -- Petrifying Slam
			self:Bar(155326, 10, 155530) -- Shatter
			self:OpenProximity(155326, 8, petrifyTargets)
		end
		scheduled = nil
	end

	function mod:PetrifyingSlam(args)
		if not scheduled then
			slamCount = slamCount + 1
			if slamCount < 3 then -- slam slam rampage
				self:CDBar(args.spellId, 61) -- 61-64
			end
			wipe(petrifyTargets)
			petrifyOnMe = nil
			scheduled = self:ScheduleTimer(openProximity, 0.1, self)
		end
		petrifyTargets[#petrifyTargets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Message(155326, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Bar(155326, 7, 155506) -- Petrified
			self:OpenProximity(155326, 8)
			petrifyOnMe = true
		end
	end

	function mod:PetrifiedApplied(args)
		-- don't need proximity after getting stunned (everyone in mythic)
		if not petrifyOnMe then
			self:CloseProximity(155326)
		end
	end

	function mod:PetrifiedRemoved(args)
		-- and close it for everyone else when they get shattered
		self:CloseProximity(155326)
	end
end

function mod:DestructiveRampage(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 30)
	rampaging = true
	self:StopBar(CL.count:format(self:SpellName(155080), sliceCount)) -- Inferno Slice
	self:StopBar(155326) -- Petrifying Slam
	self:StopBar(155301) -- Overhead Smash
end

function mod:DestructiveRampageOver(args)
	self:Message(args.spellId, "Positive", "Info", CL.over:format(args.spellName))
	self:CDBar(args.spellId, 105)
	rampaging = nil
	smashCount, slamCount, sliceCount = 1, 1, 1
	self:Bar(155080, 17, CL.count:format(self:SpellName(155080), sliceCount)) -- Inferno Slice
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

