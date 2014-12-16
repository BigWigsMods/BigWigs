
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ko'ragh", 994, 1153)
if not mod then return end
mod:RegisterEnableMob(79015)
mod.engageId = 1723

--------------------------------------------------------------------------------
-- Locals
--

local allowSuppression = false
local ballCount = 1
local nextBall, nextMC = 0, 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fire_bar = "Everyone explodes!"
	L.overwhelming_energy_bar = "Balls hit (%d)"

	L.volatile_anomaly = -9629 -- Volatile Anomalies
	L.volatile_anomaly_icon = "spell_arcane_arcane04"

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
		{172895, "FLASH", "SAY"}, -- Expel Magic: Fel
		"custom_off_fel_marker",
		--[[ Intermission ]]--
		160734, -- Vulnerability
		161242, -- Caustic Energy
		"volatile_anomaly",
		--[[ General ]]--
		161612, -- Overwhelming Energy
		{161328, "FLASH", "SAY"}, -- Suppression Field
		{162185, "PROXIMITY"}, -- Expel Magic: Fire
		{162186, "TANK", "ICON", "FLASH", "SAY"}, -- Expel Magic: Arcane
		{172747, "FLASH", "SAY"}, -- Expel Magic: Frost
		{162184, "HEALER"}, -- Expel Magic: Shadow
		"bosskill"
	}, {
		[163472] = "mythic",
		[160734] = "intermission",
		[161612] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Intermission", "boss1")
	self:Log("SPELL_AURA_APPLIED", "CausticEnergy", 161242)
	self:Log("SPELL_CAST_SUCCESS", "OverwhelmingEnergy", 161612)
	self:Log("SPELL_CAST_START", "ExpelMagicShadow", 162184)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicFire", 162185)
	self:Log("SPELL_CAST_START", "ExpelMagicArcaneStart", 162186)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicArcaneApplied", 162186) -- Faster than _APPLIED
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicArcaneRemoved", 162186)
	self:Log("SPELL_CAST_START", "ExpelMagicFrost", 172747)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "SuppressionFieldYell")
	self:Log("SPELL_CAST_SUCCESS", "SuppressionFieldCast", 161328) -- fallback to fire the timer if the triggers aren't localized
	-- Mythic
	self:Log("SPELL_CAST_START", "ExpelMagicFelCast", 172895)
	self:Log("SPELL_AURA_APPLIED", "ExpelMagicFelApplied", 172895)
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicFelRemoved", 172895)
	self:Log("SPELL_AURA_APPLIED", "DominatingPower", 163472)
end

function mod:OnEngage()
	allowSuppression = false
	ballCount = 1
	nextBall = GetTime() + 36
	self:Bar(161612, 36, L.overwhelming_energy_bar:format(ballCount)) -- Overwhelming Energy
	if self:Mythic() then
		self:CDBar(172895, 8) -- Expel Magic: Fel
		nextMC = GetTime() + 90
		self:Bar(163472, 90) -- Dominating Power
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
			self:Message(160734, "Neutral", "Info", CL.soon:format(self:SpellName(160734))) -- Vulnerability soon!
			-- Knockback at 0 power, Vulnerability 4s later
		end
	end
end

do
	local count = 0
	local function nextAdd(self)
		count = count + 1
		self:Message("volatile_anomaly", "Attention", "Info", ("%s %d/3"):format(self:SpellName(L.volatile_anomaly), count), L.volatile_anomaly_icon)
		if count < 3 then
			self:Bar("volatile_anomaly", 8, L.volatile_anomaly, L.volatile_anomaly_icon)
			self:ScheduleTimer(nextAdd, 8, self)
		end
	end

	function mod:Intermission(unit, spellName, _, _, spellId)
		if spellId == 160734 then -- Vulnerability
			self:Message(spellId, "Positive", "Long", CL.removed:format(self:SpellName(156803))) -- Nullification Barrier removed!
			self:Bar(spellId, 20)
			self:StopBar(161328) -- Suppression Field
			self:StopBar(172747) -- Expel Magic: Frost
			self:StopBar(172895) -- Expel Magic: Fel

			count = 0
			self:ScheduleTimer(nextAdd, 1, self)

			local t = GetTime()
			if nextBall-t > 5 then
				nextBall = nextBall + 20
				self:CDBar(161612, nextBall-t, L.overwhelming_energy_bar:format(ballCount))
			end
			if self:Mythic() and nextMC-t > 5 then -- really need to combine these
				nextMC = nextMC + 20
				self:CDBar(163472, nextMC-t)
			end
		elseif spellId == 156803 then -- Nullification Barrier
			self:Message(160734, "Positive", nil, spellName)
			self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, unit)
			if self:Mythic() then
				self:Bar(172895, 6) -- Expel Magic: Fel
			end
		end
	end
end

function mod:ExpelMagicShadow(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:ExpelMagicArcaneStart(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 26.7)
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

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Flash(172747)
			self:Say(172747)
		end
		if self:Range(name) < 30 then
			self:PlaySound(172747, "Alarm")
		end
	end
	function mod:ExpelMagicFrost(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		self:Message(args.spellId, "Neutral")
		self:Bar(args.spellId, 21.5, ("<%s>"):format(self:SpellName(84721)), 84721) -- Frozen Orb
		self:Bar(args.spellId, 60)
	end
end

do
	function mod:SuppressionFieldCast(args)
		allowSuppression = true
		self:CDBar(args.spellId, 15)
	end

	function mod:SuppressionFieldYell(_, _, _, _, _, suppressionTarget)
		if allowSuppression then
			allowSuppression = false
			if UnitIsUnit("player", suppressionTarget) then
				self:Flash(161328)
				self:Say(161328)
			elseif self:Range(suppressionTarget) < 10 then -- actually 8 yards
				self:RangeMessage(161328)
				self:Flash(161328)
				return
			end
			self:TargetMessage(161328, suppressionTarget, "Attention", "Alarm")
		end
	end
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, "Positive")
		scheduled = nil
	end
	function mod:CausticEnergy(args)
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.2, self, args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:OverwhelmingEnergy(args)
		if self:Me(args.destGUID) and UnitPower("player", 10) > 0 then -- check alternate power, too
			self:Message(args.spellId, "Positive", "Warning") -- green to keep it different looking
		end
		local t = GetTime()
		if t-prev > 10 then
			ballCount = ballCount + 1
			nextBall = GetTime() + 30
			self:Bar(args.spellId, 30, L.overwhelming_energy_bar:format(ballCount)) -- XXX in mythic, don't fire this bar if it's going to cause mcs
			prev = t
		end
	end
end

-- Mythic

do
	local marks = 0
	function mod:ExpelMagicFelCast(args)
		self:Message(args.spellId, "Attention")
		self:CDBar(args.spellId, 15.7) -- 15-18, mostly 15.7
		marks = 0
	end

	function mod:ExpelMagicFelApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
			self:TargetBar(args.spellId, 12, args.destName)
			self:Flash(args.spellId)
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
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, "Urgent")
		scheduled = nil
	end
	function mod:DominatingPower(args)
		list[#list+1] = args.destName
		if not scheduled then
			nextMC = GetTime() + 60
			self:Bar(args.spellId, 60)
			scheduled = self:ScheduleTimer(warn, 0.2, self, args.spellId)
		end
	end
end

