
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Gruul", 988, 1161)
if not mod then return end
mod:RegisterEnableMob(76877)
--mod.engageId = 1691

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
		{165300, "FLASH"},
		155080, 155301, {155078, "FLASH"}, {155326, "PROXIMITY"}, 155730, 155539,
		"bosskill"
	}, {
		[165300] = "mythic",
		[155080] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "InfernoSlice", 155080)
	self:Log("SPELL_CAST_START", "OverheadSmash", 155301)
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingBlows", 155078)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingBlows", 155078)
	self:Log("SPELL_CAST_SUCCESS", "PetrifyingSlamCast", 155326)
	self:Log("SPELL_AURA_APPLIED", "PetrifyingSlam", 155326)
	self:Log("SPELL_AURA_APPLIED", "PetrifiedApplied", 155506)
	self:Log("SPELL_AURA_REMOVED", "PetrifiedRemoved", 155506)
	self:Log("SPELL_CAST_SUCCESS", "CrumblingRoar", 155730)
	self:Log("SPELL_CAST_START", "DestructiveRampage", 155539)
	--Mythic
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- 165303
	self:Log("SPELL_DAMAGE", "FlareDamage", 165300)
	self:Log("SPELL_MISSED", "FlareDamage", 165300)

	self:Death("Win", 76877)
end

function mod:OnEngage()
	self:Bar(155301, 20) -- Overhead Smash
	self:Bar(155326, 35) -- Petrifying Slam
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:InfernoSlice(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:OverheadSmash(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 25) -- 37.4 25.4 25.3
end

function mod:OverwhelmingBlows(args)
	if self:Tank(args.destName) then
		--self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	else -- you're too close!
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(args.spellId)
	end
end

do
	local petrifyTargets, petrifyOnMe, scheduled = {}, nil, nil

	local function openProximity(spellId)
		if not petrifyOnMe then
			mod:OpenProximity(spellId, 8, petrifyTargets)
		end
		scheduled = nil
	end

	function mod:PetrifyingSlamCast(args)
		self:Message(args.spellId, "Attention", "Info")
		self:Bar(args.spellId, 99)
		wipe(petrifyTargets)
		petrifyOnMe = nil
	end

	function mod:PetrifyingSlam(args)
		petrifyTargets[#petrifyTargets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Bar(args.spellId, 4, 155506) -- Petrified
			self:OpenProximity(args.spellId, 8)
			petrifyOnMe = true
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(openProximity, 0.2, args.spellId)
		end
	end

	function mod:PetrifiedApplied(args)
		-- don't need proximity after getting stunned (everyone in mythic)
		if not petrifyOnMe then
			self:CloseProximity(args.spellId)
		end
	end

	function mod:PetrifiedRemoved(args)
		-- and close it for everyone else when they get shattered
		self:CloseProximity(args.spellId)
	end
end

function mod:CrumblingRoar(args)
	self:Message(args.spellId, "Urgent")
end

function mod:DestructiveRampage(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 30, CL.onboss:format(args.spellName))
	self:CDBar(args.spellId, 110)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 165303 then -- Flare
		--self:Message(165300, "Attention")
		self:CDBar(165300, 6)
	end
end

do
	local prev = 0
	function mod:FlareDamage(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

