
--------------------------------------------------------------------------------
-- TODO List:


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
		228248, -- Frost Lick
		228253, -- Shadow Lick
		228228, -- Flame Lick
		{228187, "FLASH"}, -- Guardian's Breath
		227514, -- Flashing Fangs
		227816, -- Headlong Charge
		227883, -- Roaring Leap
		"berserk"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "FrostLick", 228248)
	self:Log("SPELL_AURA_APPLIED", "ShadowLick", 228253)
	self:Log("SPELL_AURA_APPLIED", "FlameLick", 228228)

	self:Log("SPELL_CAST_START", "GuardiansBreath", 227669, 227658, 227660, 227666, 227673, 227667)
	self:Log("SPELL_CAST_START", "FlashingFangs", 227514)

	self:Log("SPELL_CAST_SUCCESS", "HeadlongCharge", 227816)

	self:Log("SPELL_CAST_SUCCESS", "RoaringLeap", 227883)
end

function mod:OnEngage()
	if not self:LFR() then -- Probably longer on LFR
		self:Berserk(242)
	end
	self:Bar(228187, 13) -- Guardian's Breath
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:FrostLick(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:ShadowLick(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:FlameLick(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

function mod:GuardiansBreath(args)
	self:Message(228187, "Attention", "Warning")
	self:Bar(228187, 5, CL.cast:format(args.spellName))
	self:Flash(228187)
end

function mod:FlashingFangs(args)
	self:Message(args.spellId, "Positive", self:Melee() and "Alert")
end

function mod:HeadlongCharge(args)
	self:Message(args.spellId, "Important", "Long")
end

function mod:RoaringLeap(args)
	self:Message(args.spellId, "Urgent", "Info")
end

