
--------------------------------------------------------------------------------
-- TODO List:
-- - Figure out how timers work - Breath and Charge could be on some shared cd?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Guarm-TrialOfValor", 1114, 1830)
if not mod then return end
mod:RegisterEnableMob(114323)
mod.engageId = 1962
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--
local breathCounter = 0
local fangCounter = 0
local leapCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{228248, "SAY", "FLASH"}, -- Frost Lick
		{228253, "SAY", "FLASH"}, -- Shadow Lick
		{228228, "SAY", "FLASH"}, -- Flame Lick
		{228187, "FLASH"}, -- Guardian's Breath
		227514, -- Flashing Fangs
		227816, -- Headlong Charge
		227883, -- Roaring Leap
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "FrostLick", 228248)
	self:Log("SPELL_AURA_APPLIED", "ShadowLick", 228253)
	self:Log("SPELL_AURA_APPLIED", "FlameLick", 228228)
	
	self:Log("SPELL_CAST_START", "FlashingFangs", 227514)

	self:Log("SPELL_CAST_SUCCESS", "HeadlongCharge", 227816)

	self:Log("SPELL_CAST_SUCCESS", "RoaringLeap", 227883)
	
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	breathCounter = 0
	fangCounter = 0
	if not self:LFR() then -- Probably longer on LFR
		self:Berserk(307)
	end
	self:Bar(227514, 5) -- Flashing Fangs
	self:Bar(228187, 14) -- Guardian's Breath
	self:Bar(227816, 57) -- Headlong Charge
	self:Bar(227883, 48) -- Roaring Leap
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 228187 then -- Guardian's Breath (starts casting)
		breathCounter = breathCounter + 1
		if breathCounter % 2 == 0 then
			self:Bar(spellId, 51)
			self:Bar(227514, 13.4) -- Adjust Flashing Fangs timer
		else
			self:Bar(spellId, 20.7)
		end
		self:Message(spellId, "Attention", "Warning")
		self:Bar(spellId, 5, CL.cast:format(spellName))
		self:Flash(spellId)
	end
end

do
	local list = mod:NewTargetList()
	function mod:FrostLick(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:ShadowLick(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:FlameLick(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

function mod:FlashingFangs(args)
	fangCounter = fangCounter + 1
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
	self:CDBar(args.spellId, (fangCounter % 2 == 0 and 51) or 20)
end

function mod:HeadlongCharge(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 75.2)
	self:Bar(args.spellId, 7, CL.cast:format(args.spellName))
	self:Bar(228187, 29.1) -- Correct Guardian's Breath timer
end

function mod:RoaringLeap(args)
	leapCounter = leapCounter + 1
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, (leapCounter % 2 == 0 and 22) or 53)
end
