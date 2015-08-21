
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

local allowSuppression = nil
local intermission = nil
local ballCount = 1
local felMarks = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fire_bar = "Everyone explodes!"
	L.overwhelming_energy_bar = "Balls hit (%d)"
	L.dominating_power_bar = "MC balls hit (%d)"

	L.volatile_anomaly = -9629 -- Volatile Anomalies
	L.volatile_anomaly_icon = "spell_arcane_arcane04"

	L.custom_off_fel_marker = "Expel Magic: Fel Marker"
	L.custom_off_fel_marker_desc = "Mark Expel Magic: Fel targets with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_fel_marker_icon = 1
end

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
		{162186, "TANK", "ICON", "PROXIMITY", "FLASH", "SAY"}, -- Expel Magic: Arcane
		{172747, "FLASH", "SAY"}, -- Expel Magic: Frost
		{162184, "HEALER"}, -- Expel Magic: Shadow
	}, {
		[163472] = "mythic",
		[160734] = "intermission",
		[161612] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Vulnerability", 160734)
	self:Log("SPELL_AURA_REMOVED", "BarrierRemoved", 156803)
	self:Log("SPELL_AURA_APPLIED", "BarrierApplied", 156803)
	self:Log("SPELL_AURA_APPLIED", "CausticEnergy", 161242)
	self:Log("SPELL_CAST_SUCCESS", "OverwhelmingEnergy", 161612)
	self:Log("SPELL_DAMAGE", "OverwhelmingEnergy", 161576)
	self:Log("SPELL_MISSED", "OverwhelmingEnergy", 161576)
	self:Log("SPELL_CAST_START", "ExpelMagicShadow", 162184)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicFire", 162185)
	self:Log("SPELL_CAST_START", "ExpelMagicArcaneStart", 162186)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicArcaneApplied", 162186) -- Faster than _APPLIED
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicArcaneRemoved", 162186)
	self:Log("SPELL_CAST_START", "ExpelMagicFrost", 172747)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "SuppressionFieldYell")
	self:Log("SPELL_CAST_SUCCESS", "SuppressionFieldCast", 161328)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "DominatingPower", 163472)
	self:Log("SPELL_CAST_START", "ExpelMagicFelCast", 172895)
	self:Log("SPELL_AURA_APPLIED", "ExpelMagicFelApplied", 172895)
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicFelRemoved", 172895)

	self:Log("SPELL_AURA_APPLIED", "ExpelMagicFelDamage", 172917)
	self:Log("SPELL_PERIODIC_DAMAGE", "ExpelMagicFelDamage", 172917)
	self:Log("SPELL_PERIODIC_MISSED", "ExpelMagicFelDamage", 172917)
end

function mod:OnEngage()
	allowSuppression = nil
	intermission = nil
	ballCount = 1
	self:CDBar(162185, 6) -- Expel Magic: Fire
	self:CDBar(162186, 30) -- Expel Magic: Arcane
	self:Bar(161612, 36, L.overwhelming_energy_bar:format(ballCount)) -- Overwhelming Energy
	self:CDBar(172747, 40) -- Expel Magic: Frost
	self:CDBar(162184, 55) -- Expel Magic: Shadow
	if self:Mythic() then
		wipe(felMarks)
		self:CDBar(172895, 8) -- Expel Magic: Fel
	end
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

function mod:OnBossDisable()
	if self:Mythic() and self.db.profile.custom_off_fel_marker then
		for _, player in next, felMarks do
			SetRaidTarget(player, 0)
		end
		wipe(felMarks)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(unit, powerType)
	if powerType == "ALTERNATE" then
		local power = UnitPower(unit, 10)
		if power < 25 then
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", unit)
			self:Message(160734, "Neutral", "Info", CL.soon:format(self:SpellName(160734))) -- Vulnerability soon!
			-- Knockback at 0 power, Vulnerability ~4s later
		end
	end
end

do
	local count = 0
	local function nextAdd(self)
		count = count + 1
		self:Message("volatile_anomaly", "Attention", "Info", ("%s %d/3"):format(self:SpellName(L.volatile_anomaly), count), L.volatile_anomaly_icon)
		if count < 3 then
			self:Bar("volatile_anomaly", 8, CL.count:format(self:SpellName(L.volatile_anomaly), count+1), L.volatile_anomaly_icon)
			self:ScheduleTimer(nextAdd, 8, self)
		end
	end
	function mod:Vulnerability(args)
		self:Message(args.spellId, "Positive", "Long")
		self:Bar(args.spellId, 20)
		count = 0
		self:ScheduleTimer(nextAdd, 1, self)
	end
end

function mod:BarrierRemoved(args)
	intermission = true
	self:Message(160734, "Positive", nil, CL.removed:format(args.spellName)) -- Nullification Barrier removed!
	-- cds pause for the duration of the shield charging phase
	self:PauseBar(161328) -- Suppression Field
	self:PauseBar(162184) -- Expel Magic: Shadow
	self:PauseBar(162185) -- Expel Magic: Fire
	self:PauseBar(162186) -- Expel Magic: Arcane
	self:PauseBar(172747) -- Expel Magic: Frost
	self:PauseBar(172895) -- Expel Magic: Fel
	-- once the balls start dropping, they don't stop
	if self:Mythic() and self:BarTimeLeft(L.dominating_power_bar:format(ballCount)) > 6 then
		self:PauseBar(163472, L.dominating_power_bar:format(ballCount))
		self:CancelDelayedMessage(CL.soon:format(self:SpellName(163472)))
	elseif self:BarTimeLeft(L.overwhelming_energy_bar:format(ballCount)) > 6 then
		self:PauseBar(161612, L.overwhelming_energy_bar:format(ballCount))
		self:CancelDelayedMessage(CL.soon:format(self:SpellName(161612)))
	end
end

function mod:BarrierApplied(args)
	if not self.isEngaged then return end -- Prevent this running when he gains the shield on engage, but before encounter engage events fire. 
	intermission = nil
	self:Message(160734, "Positive", nil, args.spellName)
	self:ResumeBar(161328) -- Suppression Field
	self:ResumeBar(162184) -- Expel Magic: Shadow
	self:ResumeBar(162185) -- Expel Magic: Fire
	self:ResumeBar(162186) -- Expel Magic: Arcane
	self:ResumeBar(172747) -- Expel Magic: Frost
	if self:Mythic() then
		self:ResumeBar(172895) -- Expel Magic: Fel
		self:ResumeBar(163472, L.dominating_power_bar:format(ballCount))
		local cd = self:BarTimeLeft(L.dominating_power_bar:format(ballCount))
		if cd > 0 then
			self:DelayedMessage(163472, cd-6, "Urgent", CL.soon:format(self:SpellName(163472)), 163472) -- Dominating Power soon!
		end
	end
	self:ResumeBar(161612, L.overwhelming_energy_bar:format(ballCount))
	if UnitPower("player", 10) > 0 then -- has alternate power (soaking)
		local cd = self:BarTimeLeft(L.overwhelming_energy_bar:format(ballCount))
		if cd > 0 then
			self:DelayedMessage(161612, cd-6, "Positive", CL.soon:format(self:SpellName(161612)), 161612, "Warning") -- Overwhelming Energy soon!
		end
	end
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

function mod:ExpelMagicShadow(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 63) -- 63-65
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Message(162186, "Personal", "Warning", CL.casting:format(CL.you:format(self:SpellName(162186))))
		else
			self:Message(162186, "Urgent", "Warning", CL.casting:format(self:SpellName(162186)))
		end
	end
	function mod:ExpelMagicArcaneStart(args)
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		self:CDBar(args.spellId, 26.7)
	end
end

function mod:ExpelMagicArcaneApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 8)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, self:Tank())
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:ExpelMagicArcaneRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		if UnitDebuff("player", self:SpellName(162185)) then -- Expel Magic: Fire
			self:OpenProximity(162185, 6)
		end
	end
end

function mod:ExpelMagicFire(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 63) -- 63-65
	self:Bar(args.spellId, 10, L.fire_bar)
	self:OpenProximity(args.spellId, 6)
	self:ScheduleTimer("CloseProximity", 10.5, args.spellId)
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Flash(172747)
			self:Say(172747)
			self:PlaySound(172747, "Alarm")
		elseif self:Range(name) < 30 then
			self:Flash(172747)
			self:PlaySound(172747, "Alarm")
		end
		self:TargetMessage(172747, name, "Neutral")
	end
	function mod:ExpelMagicFrost(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		self:Bar(args.spellId, 21.5, ("<%s>"):format(self:SpellName(84721)), 84721) -- Frozen Orb
		self:CDBar(args.spellId, 60)
	end
end

do
	function mod:SuppressionFieldCast(args)
		allowSuppression = true -- Faster than registering/unregistering the yell
		self:CDBar(args.spellId, 15)
	end
	function mod:SuppressionFieldYell(_, _, _, _, _, suppressionTarget)
		if allowSuppression then
			allowSuppression = nil
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
		local t = GetTime()
		if t-prev > 10 then
			prev = t
			ballCount = ballCount + 1
			local cd = intermission and 60 or 30 -- doesn't actually start the cd until the next time they would have hit if falling during the intermission
			if self:Mythic() and ballCount % 2 == 0 then
				self:CDBar(163472, cd, L.dominating_power_bar:format(ballCount)) -- Dominating Power
				self:DelayedMessage(163472, cd-6, "Urgent", CL.soon:format(self:SpellName(163472))) -- Dominating Power soon!
			else
				self:CDBar(161612, cd, L.overwhelming_energy_bar:format(ballCount)) -- Overwhelming Energy
				if UnitPower("player", 10) > 0 then -- has alternate power (soaking)
					self:DelayedMessage(161612, cd-6, "Positive", CL.soon:format(args.spellName), 161612, "Warning") -- Overwhelming Energy soon!
				end
			end
		end
	end
end

-- Mythic

do
	local scheduled, isOnMe = nil, nil
	function mod:ExpelMagicFelCast(args)
		self:CDBar(args.spellId, 15.7) -- 15-18, mostly 15.7
		wipe(felMarks)
		isOnMe = nil
	end

	local function warn(self, spellId)
		if not isOnMe then
			self:Message(spellId, "Attention")
		end
		scheduled = nil
	end
	function mod:ExpelMagicFelApplied(args)
		felMarks[#felMarks+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
			self:TargetBar(args.spellId, 12, args.destName)
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.3, self, args.spellId)
		end
		if self.db.profile.custom_off_fel_marker then
			SetRaidTarget(args.destName, #felMarks)
		end
	end

	function mod:ExpelMagicFelRemoved(args)
		tDeleteItem(felMarks, args.destName)
		if self:Me(args.destName) then
			self:StopBar(args.spellId, args.destName)
		end
		if self.db.profile.custom_off_fel_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

do
	local prev = 0
	function mod:ExpelMagicFelDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(172895)
			self:Message(172895, "Personal", "Alert", CL.underyou:format(args.spellName))
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
			scheduled = self:ScheduleTimer(warn, 0.2, self, args.spellId)
		end
	end
end

