
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gruul", 988, 1161)
if not mod then return end
mod:RegisterEnableMob(76877)
--mod.engageId = 1691

--------------------------------------------------------------------------------
-- Locals
--

local rampaging = nil
local smashCount = 1
local slamCount = 1

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
		165300,
		155080, 155301, {155078, "FLASH"}, {155326, "PROXIMITY"}, 155730, 155539, {173192, "FLASH"},
		"bosskill"
	}, {
		[165300] = "mythic",
		[155080] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "InfernoSlice", 155080)
	self:Log("SPELL_CAST_START", "OverheadSmash", 155301)
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingBlows", 155078)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingBlows", 155078)
	self:Log("SPELL_AURA_APPLIED", "PetrifyingSlam", 155323)
	self:Log("SPELL_AURA_APPLIED", "PetrifiedApplied", 155506)
	self:Log("SPELL_AURA_REMOVED", "PetrifiedRemoved", 155506)
	self:Log("SPELL_CAST_SUCCESS", "CrumblingRoar", 155730)
	self:Log("SPELL_AURA_APPLIED", "DestructiveRampage", 155539)
	self:Log("SPELL_AURA_REMOVED", "DestructiveRampageOver", 155539)
	self:Log("SPELL_PERIODIC_DAMAGE", "CaveInDamage", 173192)
	self:Log("SPELL_PERIODIC_MISSED", "CaveInDamage", 173192)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	rampaging = nil
	smashCount, slamCount = 1, 1
	self:Bar(155080, 14) -- Inferno Slice
	self:CDBar(155539, 105) -- Destructive Rampage (105-115)
	-- XXX not sure about these... can cast either first around 22s, then the second varies (30~43s), then they stablize
	--self:CDBar(155326, 22) -- Petrifying Slam
	--self:CDBar(155301, 30) -- Overhead Smash
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 165303 then -- Flare (Mythic)
		self:CDBar(165300, 6)
	end
end

function mod:InfernoSlice(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 17.5) -- slice x6 then rampage
end

function mod:OverwhelmingBlows(args)
	if self:Tank(args.destName) then
		--self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	else -- you're too close!
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(args.spellId)
	end
end

function mod:OverheadSmash(args)
	if rampaging then return end
	self:Message(args.spellId, "Attention")
	if smashCount < 3 then -- smash smash rampage
		self:CDBar(args.spellId, smashCount == 1 and 22 or 38)
	end
	smashCount = smashCount + 1
end

do
	local petrifyTargets, petrifyOnMe, scheduled = {}, nil, nil
	local function openProximity()
		if not petrifyOnMe then
			mod:Message(155326, "Attention", "Info")
			mod:OpenProximity(155326, 8, petrifyTargets)
		end
		scheduled = nil
	end

	function mod:PetrifyingSlam(args)
		if not scheduled then
			if slamCount < 2 then -- slam rampage
				self:Bar(args.spellId, 60.7)
			end
			slamCount = slamCount + 1
			wipe(petrifyTargets)
			petrifyOnMe = nil
			scheduled = self:ScheduleTimer(openProximity, 0.1)
		end
		petrifyTargets[#petrifyTargets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Message(155326, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Bar(155326, 4, 155506) -- Petrified
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

function mod:CrumblingRoar(args)
	self:Message(args.spellId, "Urgent")
end

function mod:DestructiveRampage(args)
	self:Message(args.spellId, "Important")
	self:Bar(args.spellId, 30)
	rampaging = true
	self:StopBar(155080) -- Inferno Slice
	self:StopBar(155326) -- Petrifying Slam
	self:StopBar(155301) -- Overhead Smash
end

function mod:DestructiveRampageOver(args)
	self:Message(args.spellId, "Positive", "Info", CL.over:format(args.spellName))
	self:Bar(args.spellId, self:LFR() and 115 or 80)
	rampaging = nil
	smashCount, slamCount = 1, 1
	self:Bar(155080, 17) -- Inferno Slice
	self:Bar(155326, 25.3) -- Petrifying Slam
	self:Bar(155301, 46) -- Overhead Smash
end

do
	local prev = 0
	function mod:CaveInDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 3 then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

