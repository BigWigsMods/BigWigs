
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Pride", 953, 867)
if not mod then return end
mod:RegisterEnableMob(71734)
mod.engageId = 1604

--------------------------------------------------------------------------------
-- Locals
--

local titans, titanCounter = {}, 1
local auraOfPride, auraOfPrideGroup, auraOfPrideOnMe = mod:SpellName(146817), {}, nil
local swellingPrideCounter = 1
local wrChecker = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.projection_green_arrow = "GREEN ARROW"

	L.titan_pride = "Titan+Pride: %s"

	L.custom_off_titan_mark = "Gift of the Titans marker"
	L.custom_off_titan_mark_desc = "Mark people that have Gift of the Titans with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_titan_mark_icon = 1

	L.custom_off_fragment_mark = "Corrupted Fragment marker"
	L.custom_off_fragment_mark_desc = "Mark the Corrupted Fragments with {rt8}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_fragment_mark_icon = 8
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		145215, 147207, "custom_off_fragment_mark",
		"custom_off_titan_mark",
		{146595, "PROXIMITY"}, 144400, -8257, {-8258, "FLASH"}, {146817, "FLASH", "PROXIMITY"}, -8270, {144351, "DISPEL"}, {144358, "TANK", "FLASH", "EMPHASIZE"}, -8262, 144800, 144563, 144832, -8349,
		"altpower", "berserk", "bosskill",
	}, {
		[145215] = "mythic",
		["custom_off_titan_mark"] = L.custom_off_titan_mark,
		[146595] = "general",
	}
end

function mod:OnBossEnable()
	if IsEncounterInProgress() then
		self:OpenAltPower("altpower", 144343) -- Pride
	end

	-- Mythic
	self:Log("SPELL_AURA_REMOVED", "WeakenedResolveOver", 147207)
	self:Log("SPELL_AURA_APPLIED", "WeakenedResolveBegin", 147207)
	self:Log("SPELL_AURA_APPLIED", "Banishment", 145215)
	-- Normal
	self:Log("SPELL_CAST_START", "UnleashedStart", 144832)
	self:Log("SPELL_CAST_SUCCESS", "Unleashed", 144832)
	self:Log("SPELL_AURA_APPLIED", "ImprisonApplied", 144574, 144684, 144683, 144636)
	self:Log("SPELL_CAST_START", "Imprison", 144563)
	self:Log("SPELL_CAST_SUCCESS", "SelfReflection", 144800)
	self:Log("SPELL_CAST_SUCCESS", "WoundedPride", 144358)
	self:Log("SPELL_CAST_SUCCESS", "MarkOfArrogance", 144351)
	self:Log("SPELL_AURA_REMOVED", "AuraOfPrideRemoved", 146817)
	self:Log("SPELL_AURA_APPLIED", "AuraOfPrideApplied", 146817)
	self:Log("SPELL_CAST_SUCCESS", "SwellingPrideSuccess", 144400)
	self:Log("SPELL_CAST_START", "SwellingPride", 144400)
	self:Log("SPELL_CAST_SUCCESS", "TitanGiftSuccess", 146595)
	self:Log("SPELL_AURA_APPLIED", "TitanGiftApplied", 144359, 146594)
	self:Log("SPELL_AURA_REMOVED", "TitanGiftRemoved", 144359, 146594)
end

function mod:OnEngage()
	swellingPrideCounter, titanCounter = 1, 1
	wipe(titans)
	wipe(auraOfPrideGroup)
	auraOfPrideOnMe = nil
	self:Bar(146595, 7) -- Titan Gift
	self:Bar(144400, 77, CL.count:format(self:SpellName(144400), swellingPrideCounter)) -- Swelling Pride
	self:Bar(-8262, 60, CL.big_add, 144379) -- signature ability icon
	self:DelayedMessage(-8262, 55, "Urgent", CL.spawning:format(CL.big_add), 144379)
	self:Bar(144800, 25, CL.small_adds)
	self:Bar(144563, 52.5) -- Imprison
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	if self:Mythic() then
		self:Bar(145215, 37.4) -- Banishment
		wrChecker = nil
	end
	if not self:LFR() then
		self:CDBar(144358, 11) -- Wounded Pride
		self:Berserk(600)
	end
	self:OpenAltPower("altpower", 144343) -- Pride
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Mythic
do
	local function warnWeakenedResolve(spellId, spellName)
		if not UnitAffectingCombat("player") then
			mod:CancelTimer(wrChecker)
			wrChecker = nil
		else
			mod:Message(spellId, "Personal", nil, CL.no:format(spellName))
		end
	end
	function mod:WeakenedResolveOver(args)
		if self:Me(args.destGUID) and UnitAffectingCombat("player") then
			self:Message(args.spellId, "Personal", nil, CL.over:format(args.spellName))
			wrChecker = self:ScheduleRepeatingTimer(warnWeakenedResolve, 6, args.spellId, args.spellName)
		end
	end
end

function mod:WeakenedResolveBegin(args)
	if wrChecker and self:Me(args.destGUID) then
		self:CancelTimer(wrChecker)
		wrChecker = nil
	end
end

do
	local mobTbl, counter, UnitGUID = {}, 8, UnitGUID
	local function CheckUnit(event, firedUnit)
		local unit = firedUnit and firedUnit.."target" or "mouseover"
		local guid = UnitGUID(unit)
		if guid and not mobTbl[guid] and mod:MobId(guid) == 72569 then
			mobTbl[guid] = true
			SetRaidTarget(unit, counter)
			counter = counter - 1
			if counter == 6 then
				mod:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
				mod:UnregisterEvent("UNIT_TARGET")
			end
		end
	end

	local banishmentList, scheduled = mod:NewTargetList(), nil
	local function warnBanishment(spellId)
		mod:TargetMessage(spellId, banishmentList, "Attention")
		scheduled = nil
	end
	function mod:Banishment(args)
		banishmentList[#banishmentList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnBanishment, 0.2, args.spellId)

			if self.db.profile.custom_off_fragment_mark then
				wipe(mobTbl)
				counter = 8
				self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", CheckUnit)
				self:RegisterEvent("UNIT_TARGET", CheckUnit)
			end
		end
	end
end

-- normal
function mod:UnleashedStart(args)
	self:Message(args.spellId, "Neutral", "Info", "30% - ".. CL.casting:format(args.spellName))
	if not self:LFR() then
		self:CDBar(144358, 11) -- Wounded Pride
	end
	self:StopBar(CL.count:format(self:SpellName(144400), swellingPrideCounter)) -- Swelling Pride
	self:StopBar(144563) -- Imprison
	self:StopBar(145215) -- Banishment
	self:StopBar(CL.small_adds)
	self:StopBar(CL.big_add)
	self:CancelDelayedMessage(CL.spawning:format(CL.big_add))
end

function mod:Unleashed() -- Final Gift
	self:StopBar(146595) -- Gift of the Titans
	self:Message(-8349, "Neutral", "Info") -- Final Gift
	self:Bar(144400, 74, CL.count:format(self:SpellName(144400), swellingPrideCounter)) -- Swelling Pride
	self:Bar(-8262, 60, CL.big_add, 144379)
	self:DelayedMessage(-8262, 55, "Urgent", CL.spawning:format(CL.big_add), 144379)
	self:Bar(144800, 16.3, CL.small_adds)
	self:Bar(144563, 43.6) -- Imprison
	if self:Mythic() then
		self:Bar(145215, 29) -- Banishment
	end
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 34 then -- 30%
		self:Message(144832, "Neutral", "Info", CL.soon:format(self:SpellName(144832))) -- Unleashed
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

do
	local prisoned, scheduled = mod:NewTargetList(), nil
	local function warnImprison()
		mod:TargetMessage(144563, prisoned, "Neutral")
		scheduled = nil
	end
	function mod:ImprisonApplied(args)
		prisoned[#prisoned+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnImprison, 0.2)
		end
	end
end

function mod:Imprison(args)
	self:Message(args.spellId, "Neutral", nil, CL.casting:format(args.spellName))
end

function mod:SelfReflection(args)
	self:Message(args.spellId, "Important", nil, CL.small_adds)
end

function mod:WoundedPride(args)
	-- mainly warn the guy not getting the debuff
	local notOnMe = not self:Me(args.destGUID)
	if notOnMe then
		self:Flash(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Important", notOnMe and "Warning", nil, nil, true) -- play sound for the other tanks
	self:CDBar(args.spellId, 30)
end

function mod:MarkOfArrogance(args)
	if self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "Important", "Alarm")
		self:Bar(args.spellId, 20)
	end
end

function mod:AuraOfPrideRemoved(args)
	self:CloseProximity(args.spellId)
	wipe(auraOfPrideGroup)
	auraOfPrideOnMe = nil
end

function mod:AuraOfPrideApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alert", CL.you:format(args.spellName))
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 5)
		auraOfPrideOnMe = true
	else
		auraOfPrideGroup[#auraOfPrideGroup+1] = args.destName
	end
	if not auraOfPrideOnMe then
		self:OpenProximity(args.spellId, 5, auraOfPrideGroup)
	end
end

do
	local mindcontrolled, scheduled = mod:NewTargetList(), nil
	local function warnOvercome()
		mod:TargetMessage(-8270, mindcontrolled, "Attention")
		scheduled = nil
	end
	function mod:SwellingPrideSuccess(args)
		if not self:LFR() then
			self:CDBar(144358, 10.5) -- Wounded Pride, 10-11.2
		end
		if self:Mythic() then
			self:Bar(145215, 37.4) -- Banishment
		end
		self:Bar(144563, 53) -- Imprison
		self:Bar(-8262, 60, CL.big_add, 144379) -- when the add is actually up
		self:DelayedMessage(-8262, 55, "Urgent", CL.soon:format(CL.big_add), 144379)
		self:DelayedMessage(-8262, 60, "Urgent", CL.spawning:format(CL.big_add), 144379, self:Damager() and "Alert")
		self:Bar(144800, 25.6, CL.small_adds)

		-- lets do some fancy stuff
		local playerPower = UnitPower("player", 10)
		local playerBursting = playerPower > 24 and playerPower < 50
		if playerBursting then
			self:Message(-8257, "Personal", "Alarm", CL.underyou:format(self:SpellName(144911))) -- bursting pride
		elseif playerPower > 49 and playerPower < 75 then
			local you = CL.you:format(self:SpellName(-8258))
			self:Message(-8258, "Personal", "Warning", ("%s (|cFF00FF00%s|r)"):format(you, L.projection_green_arrow), "Achievement_pvp_g_01.png") -- better fitting icon imo
			self:Flash(-8258, "Achievement_pvp_g_01.png")
			self:Bar(-8258, 6, you, "Achievement_pvp_g_01.png")
		end

		local warned = nil
		for unit in self:IterateGroup() do
			local power = UnitPower(unit, 10)
			if power == 100 then
				mindcontrolled[#mindcontrolled+1] = self:UnitName(unit)
				if not scheduled then
					scheduled = self:ScheduleTimer(warnOvercome, 0.1)
				end
			elseif not warned and not playerBursting and power > 24 and power < 50 and self:Range(unit) < 5 then -- someone near has bursting pride, but not you
				warned = true
				self:RangeMessage(-8257)
			end
		end
	end
end

function mod:SwellingPride(args)
	self:Message(args.spellId, "Attention", "Info", CL.count:format(args.spellName, swellingPrideCounter)) -- play sound so people can use personal CDs
	swellingPrideCounter = swellingPrideCounter + 1
	self:Bar(args.spellId, 77, CL.count:format(args.spellName, swellingPrideCounter))
end

do
	local isOnMe = nil
	local function titansCasted()
		if isOnMe then
			isOnMe = nil
			mod:OpenProximity(146595, 8, titans, true)
		end
		titanCounter = 1
		wipe(titans)
	end
	function mod:TitanGiftRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(146595)
		end
		if self.db.profile.custom_off_titan_mark then
			SetRaidTarget(args.destName, 0)
		end
	end
	function mod:TitanGiftApplied(args)
		local _, _, _, _, _, _, prideExpires = UnitDebuff(args.destName, auraOfPride) -- this is to check if the person has aura of pride then later spawn remaining duration bar
		if self:Me(args.destGUID) then
			isOnMe = true
			if prideExpires then -- Aura of Pride 5 yard aoe
				self:Message(146595, "Neutral", "Long", CL.you:format(("%s + %s"):format(args.spellName,auraOfPride)))
				self:Flash(146817) -- Aura of Pride flash
			else
				self:Message(146595, "Positive", "Long", CL.you:format(args.spellName))
			end
		else
			titans[#titans+1] = args.destName
		end

		if self.db.profile.custom_off_titan_mark then
			if prideExpires then
				local remaining = prideExpires-GetTime()
				self:TargetBar(146595, remaining, args.destName, L.titan_pride)
				self:ScheduleTimer(SetRaidTarget, remaining, args.destName, titanCounter)
			else
				SetRaidTarget(args.destName, titanCounter)
			end
			titanCounter = titanCounter + 1
		end
	end
	function mod:TitanGiftSuccess(args)
		self:Bar(args.spellId, 25)
		self:ScheduleTimer(titansCasted, 0.3)
	end
end

