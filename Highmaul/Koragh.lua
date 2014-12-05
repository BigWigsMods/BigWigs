
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ko'ragh", 994, 1153)
if not mod then return end
mod:RegisterEnableMob(79015)
mod.engageId = 1723

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.suppression_field_trigger1 = "Quiet!"
	L.suppression_field_trigger2 = "I will tear you in half!"
	L.suppression_field_trigger3 = "I will crush you!"
	L.suppression_field_trigger4 = "Silence!"

	L.fire_bar = "Everyone Explodes!"

	L.custom_off_fel_marker = "Expel Magic: Fel Marker"
	L.custom_off_fel_marker_desc = "Mark Expel Magic: Fel targets with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_fel_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		163472, -- Dominating Power
		172895, -- Expel Magic: Fel
		"custom_off_fel_marker",
		--[[ General ]]--
		161242, -- Caustic Energy
		160734, -- Vulnerability
		{161328, "SAY", "FLASH"}, -- Suppression Field
		{162184, "HEALER"}, -- Expel Magic: Shadow
		{162185, "PROXIMITY"}, -- Expel Magic: Fire
		{162186, "TANK", "ICON", "FLASH", "SAY"}, -- Expel Magic: Arcane
		172747, -- Expel Magic: Frost
		"bosskill"
	}, {
		[163472] = "mythic",
		[161242] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "CausticEnergy", 161242)
	self:Log("SPELL_CAST_START", "ExpelMagicShadow", 162184)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicFire", 162185)
	self:Log("SPELL_CAST_START", "ExpelMagicArcaneStart", 162186)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicArcaneApplied", 162186) -- Faster than _APPLIED
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicArcaneRemoved", 162186)
	self:Log("SPELL_CAST_START", "ExpelMagicFrost", 172747)
	self:Yell("SuppressionField", L.suppression_field_trigger1, L.suppression_field_trigger2, L.suppression_field_trigger3, L.suppression_field_trigger4)
	self:Log("SPELL_CAST_SUCCESS", "SuppressionFieldCast", 161328) -- fallback to fire the timer if the triggers are localized
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "ExpelMagicFelCast", 172895)
	self:Log("SPELL_AURA_APPLIED", "ExpelMagicFelApplied", 172895)
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicFelRemoved", 172895)
	self:Log("SPELL_AURA_APPLIED", "DominatingPower", 163472)
end

function mod:OnEngage()
	if self:Mythic() then
		self:CDBar(172895, 8) -- Expel Magic: Fel
	end
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(unit, powerType)
	if powerType == "ALTERNATE" then
		local power = UnitPower(unit, 10)
		if power < 25 then -- XXX probably need to tweak this (~10s)
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", unit)
			self:Message(160734, "Neutral", "Info", CL.soon:format(self:SpellName(160734)))
			-- Knockback at 0 power, Vulnerability 4s later
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 160734 then -- Vulnerability
		self:Message(spellId, "Positive", "Long", CL.removed:format(self:SpellName(156803))) -- Nullification Barrier removed!
		self:Bar(spellId, 20)
		self:StopBar(161328) -- Suppression Field
		self:StopBar(172895) -- Expel Magic: Fel
	elseif spellId == 156803 then -- Nullification Barrier
		self:Message(160734, "Positive", nil, spellName)
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, unit)
	end
end

function mod:ExpelMagicShadow(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:ExpelMagicArcaneStart(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
end

function mod:ExpelMagicArcaneApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, self:Tank())
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:ExpelMagicArcaneRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:ExpelMagicFire(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 10, L.fire_bar)
	self:OpenProximity(args.spellId, 5)
	self:ScheduleTimer("CloseProximity", 10.5, args.spellId)
end

function mod:ExpelMagicFrost(args)
	self:Message(args.spellId, "Attention") --, self:Dispeller("magic") and "Info"
end

do
	local suppressionTarget = nil
	local function warn(spellId)
		if suppressionTarget then
			if UnitIsUnit("player", suppressionTarget) then
				mod:Flash(spellId)
				mod:Say(spellId)
			end
			mod:TargetMessage(spellId, suppressionTarget, "Attention", "Alarm")
		else
			mod:Message(spellId, "Attention")
		end
	end

	function mod:SuppressionFieldCast(args)
		self:CDBar(args.spellId, 15)
		suppressionTarget = nil
		self:ScheduleTimer(warn, 0.1, args.spellId)
	end

	function mod:SuppressionField(_, _, _, _, target)
		suppressionTarget = target
	end
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(spellId)
		mod:TargetMessage(spellId, list, "Positive")
		scheduled = nil
	end
	function mod:CausticEnergy(args)
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.2, args.spellId)
		end
	end
end

-- Mythic

do
	local marks = 0
	function mod:ExpelMagicFelCast(args)
		self:Bar(args.spellId, 15.7) -- seems like a static timer, not based on absorbed damage
		marks = 0
	end

	function mod:ExpelMagicFelApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
			self:TargetBar(args.spellId, 12, args.destName)
			self:Say(args.spellId)
		end
		if self.db.profile.custom_off_fel_marker then
			marks = marks + 1
			SetRaidTarget(args.destName, marks)
		end
	end

	function mod:ExpelMagicFelRemoved(args)
		if self:Me(args.destName) then
			self:StopBar(args.spellId, args.destName)
		end
		if self.db.profile.custom_off_fel_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(spellId)
		mod:TargetMessage(spellId, list, "Urgent")
		scheduled = nil
	end
	function mod:DominatingPower(args)
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.2, args.spellId)
		end
	end
end

