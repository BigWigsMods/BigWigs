if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- TODO List:


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Guarm-TrialOfValor", 1114, 1830)
if not mod then return end
mod:RegisterEnableMob(91386, 114344, 114323, 114341, 114343)
--mod.engageId = 0
--mod.respawnTime = 0

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
		{228248, "SAY"}, -- Frost Lick
		{228250, "SAY"}, -- Shadow Lick
		{228228, "SAY"}, -- Flame Lick
		{228187, "FLASH"}, -- Guardian's Breath
		227514, -- Flashing Fangs
		227816, -- Headlong Charge
		227883, -- Roaring Leap
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "FrostLick", 228248, 228247, 228246)
	self:Log("SPELL_AURA_REMOVED", "FrostLickRemoved", 228248, 228247, 228246)

	self:Log("SPELL_AURA_APPLIED", "ShadowLick", 228250, 228251, 228253)
	self:Log("SPELL_AURA_REMOVED", "ShadowLickRemoved", 228250, 228251, 228253)

	self:Log("SPELL_AURA_APPLIED", "FlameLick", 228228, 228226, 228227)
	self:Log("SPELL_AURA_REMOVED", "FlameLickRemoved", 228228, 228226, 228227)

	self:Log("SPELL_CAST_START", "GuardiansBreath", 227669, 227658, 227660, 227666, 227673, 227667)
	self:Log("SPELL_CAST_START", "FlashingFangs", 227514)

	self:Log("SPELL_AURA_APPLIED", "HeadlongCharge", 227816, 227833)

	self:Log("SPELL_CAST_SUCCESS", "RoaringLeap", 227883, 227894)
end

function mod:OnEngage()
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	function mod:FrostLick(args)
		if self:Me(args.destGUID) then
			self:Say(228248)
		end
		self:TargetMessage(228248, args.destName, "Urgent", "Alarm")
	end
	function mod:FrostLickRemoved(args)
		--self:PrimaryIcon(args.spellId)
	end
end

do
	function mod:ShadowLick(args)
		if self:Me(args.destGUID) then
			self:Say(228250)
		end
		self:TargetMessage(228250, args.destName, "Urgent", "Alarm")
	end
	function mod:ShadowLickRemoved(args)
		--self:PrimaryIcon(args.spellId)
	end
end

do
	function mod:FlameLick(args)
		if self:Me(args.destGUID) then
			self:Say(228228)
		end
		self:TargetMessage(228228, args.destName, "Urgent", "Alarm")
	end
	function mod:FlameLickRemoved(args)
		--self:PrimaryIcon(args.spellId)
	end
end

do
	local prev = 0
	function mod:GuardiansBreath(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(228187, "Attention", "Warning")
			self:Bar(228187, 5)
			self:Flash(228187)
		end
	end
end

function mod:FlashingFangs(args)
	self:Message(args.spellId, "Positive", self:Melee() and "Alert")
end

do
	local prev = 0
	function mod:HeadlongCharge(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(227816, "Important", "Long")
		end
	end
end

function mod:RoaringLeap(args)
	self:Message(227883, "Urgent", "Info")
end

