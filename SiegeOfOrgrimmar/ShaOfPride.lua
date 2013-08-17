--[[
TODO:
	do some intelligent proximity meter ( would need multi target reverse proximity )
]]--

if select(4, GetBuildInfo()) < 50400 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Pride", 953, 867)
if not mod then return end
mod:RegisterEnableMob(71734)

--------------------------------------------------------------------------------
-- Locals
--

local UnitPower = UnitPower
local GetRaidRosterInfo = GetRaidRosterInfo

local marksUsed = {}
local auraOfPride = mod:SpellName(146817)
local auraOfPrideGroup = {}
local alterPride
local prisoned = mod:NewTargetList()
local swellingPrideCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_off_titan_mark = "Gift of the Titans marker"
	L.custom_off_titan_mark_desc = "To help spotting others with Gift of the Titans, mark the people who have Gift of the Titans on them with %s%s%s%s%s%s%s%s (players with Aura of Pride and tanks are not marked), requires promoted or leader."

	L.projection_message = "Go to |cFF00FF00GREEN|r arrow!"
	L.projection_explosion = "Projection explosion"

	L.big_add_bar = "Big add"
	L.big_add_spawning = "Big add spawning!"
	L.small_adds = "Small adds"
end
L = mod:GetLocale()
L.custom_off_titan_mark_desc = L.custom_off_titan_mark_desc:format(
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8.blp:15\124t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		145215, 147207,
		"custom_off_titan_mark",
		146595, 144400, -8257, {-8258, "FLASH"}, {146817, "FLASH", "PROXIMITY"}, -8270, 144351, {144358, "TANK", "FLASH"}, -8262, 144800, 144563, -8349,
		"berserk", "bosskill",
	}, {
		[145215] = "heroic",
		["custom_off_titan_mark"] = L.custom_off_titan_mark,
		[146595] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- heroic
	self:Log("SPELL_AURA_REMOVED", "WeakenedResolveOver", 147207)
	self:Log("SPELL_AURA_APPLIED", "Banishment", 145215)
	-- normal
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

	self:Death("Win", 71734)
end

function mod:OnEngage()
	swellingPrideCounter = 1
	wipe(marksUsed)
	wipe(auraOfPrideGroup)
	self:Bar(146595, 7) -- Titan Gift
	self:Bar(144400, 62, CL["count"]:format(self:SpellName(144400), swellingPrideCounter)) -- Swelling Pride
	if self:Tank() then
		alterPride = nil
		self:CDBar(144358, 11) -- Wounded Pride
	end
	self:Bar(-8262, 50, L["big_add_bar"], 144379) -- signature ability icon
	self:ScheduleTimer("Message", 45, -8262, "Urgent", nil, L["big_add_spawning"], 144379)
	self:Bar(144800, 21, L["small_adds"])
	self:Bar(144563, 40) -- Imprison
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- heroic
function mod:WeakenedResolveOver(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, CL["over"]:format(args.spellName))
	end
end

function mod:Banishment(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

-- normal
function mod:Unleashed()
	self:CancelAllTimers()
	self:Message(-8349, "Neutral", "Info")
	self:Bar(146595, 7) -- Titan Gift
	self:Bar(144400, 62) -- Swelling Pride
	if self:Tank() then
		alterPride = nil
		self:CDBar(144358, 11) -- Wounded Pride
	end
	self:Bar(-8262, 50, L["big_add_bar"], 144379)
	self:ScheduleTimer("Message", 45, -8262, "Urgent", nil, L["big_add_spawning"], 144379)
	self:Bar(144800, 21, L["small_adds"])
	self:Bar(144563, 40) -- Imprison
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 33 then -- 30%
		self:Message(-8349, "Neutral", "Info", CL["soon"]:format(EJ_GetSectionInfo(8349)))
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

do
	local scheduled
	local function warnImprison(spellId)
		mod:TargetMessage(spellId, prisoned, "Neutral")
		scheduled = nil
	end
	function mod:ImprisonApplied(args)
		prisoned[#prisoned+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnImprison, 0.1, 144563)
		end
	end
end

function mod:Imprison(args)
	self:Message(args.spellId, "Neutral", nil, CL["casting"]:format(args.spellName))
	self:Bar(args.spellId, 62)
end

function mod:SelfReflection(args)
	self:Message(args.spellId, "Important", nil, L["small_adds"])
	self:Bar(args.spellId, 62, L["small_adds"])
end

function mod:WoundedPride(args)
	-- mainly warn the guy not getting the debuff
	local onMe = self:Me(args.destGUID)
	if not onMe then
		self:Flash(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Important", onMe and nil or "Warning", nil, nil, true) -- play sound for the other tanks
	self:CDBar(args.spellId, alterPride and 36 or 25)
	alterPride = not alterPride
end

function mod:MarkOfArrogance(args)
	if self:Dispeller("magic") then
		self:Message(args.spellId, "Important", "Alarm")
		self:Bar(args.spellId, 20)
	end
end

do
	local function findPlayerInIndexedTable(t, player)
		for k, name in next, t do
			if name == player then
				return k
			end
		end
		return false
	end
	function mod:AuraOfPrideRemoved(args)
		local index = findPlayerInIndexedTable(auraOfPrideGroup, args.destName)
		if index then
			table.remove(auraOfPrideGroup, index)
		end
		if self:Me(args.destGUID) and #auraOfPrideGroup > 0 then
			self:OpenProximity(args.spellId, 5, auraOfPrideGroup)
		elseif not self:Me(args.destGUID) and #auraOfPrideGroup > 0 then
			self:OpenProximity(args.spellId, 5, auraOfPrideGroup)
		elseif #auraOfPrideGroup == 0 then
			self:CloseProximity(args.spellId)
		end
	end
end

function mod:AuraOfPrideApplied(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Message(args.spellId, "Personal", "Alert", CL["you"]:format(args.spellName))
		self:OpenProximity(args.spellId, 5)
	else
		auraOfPrideGroup[#auraOfPrideGroup+1] = args.destName
		self:OpenProximity(args.spellId, 5, auraOfPrideGroup)
	end
end

do
	local prev = 0
	local mindcontrolled = mod:NewTargetList()
	function mod:SwellingPrideSuccess(args)
		self:Bar(-8262, 50, L["big_add_bar"], 144379) -- when the add is actually up
		self:ScheduleTimer("Message", 45, -8262, "Urgent", nil, L["big_add_spawning"], 144379)
		-- lets do some fancy stuff
		local playerPower = UnitPower("player", ALTERNATE_POWER_INDEX)
		if playerPower > 24 and playerPower < 50 then
			self:Message(-8257, "Personal", "Alarm", CL["underyou"]:format(self:SpellName(144911))) -- bursting pride
		elseif playerPower > 49 and playerPower < 75 then
			self:Message(-8258, "Personal", "Warning", L["projection_message"], "Achievement_pvp_g_01.png") -- better fitting icon imo
			self:Flash(-8258, "Achievement_pvp_g_01.png")
			self:Bar(-8258, 6, L["projection_explosion"])
		end
		local unit, power
		for i=1, GetNumGroupMembers() do
			unit = GetRaidRosterInfo(i)
			power = UnitPower(unit, ALTERNATE_POWER_INDEX)
			if power > 24 and power < 50 and self:Range(unit) < 5 and (playerPower < 25 or playerPower > 49) then -- someone near have it, but not the "player"
				local t = GetTime()
				if t-prev > 2 then -- don't spam
					prev = t
					self:RangeMessage(-8257) -- bursting pride
				end
			elseif power == 100 then
				mindcontrolled[#mindcontrolled+1] = unit
				self:ScheduleTimer("TargetMessage", 0.1, -8270, mindcontrolled, "Attention")
			end
		end
	end
end

function mod:SwellingPride(args)
	self:Message(args.spellId, "Attention", "Info", CL["count"]:format(args.spellName, swellingPrideCounter)) -- play sound so people can use personal CDs
	swellingPrideCounter = swellingPrideCounter + 1
	self:Bar(args.spellId, 62, CL["count"]:format(args.spellName, swellingPrideCounter))
end

do
	function mod:TitanGiftRemoved(args)
		if self.db.profile.custom_off_titan_mark then
			for i = 1, 8 do
				if marksUsed[i] == args.destName then
					marksUsed[i] = false
					SetRaidTarget(args.destName, 0)
				end
			end
		end
	end
	local function markTitans(destName)
		for i = 1, 8 do
			if not marksUsed[i] then
				SetRaidTarget(destName, i)
				marksUsed[i] = destName
				return
			end
		end
	end
	function mod:TitanGiftApplied(args)
		if self:Me(args.destGUID) then
			if UnitDebuff("player", auraOfPride) then  -- Aura of Pride 5 yard aoe
				self:Message(146595, "Natural", "Long", CL["you"]:format(("%s + %s"):format(args.spellName,auraOfPride)))
				self:Flash(146817) -- Aura of Pride flash
			else
				self:Message(146595, "Positive", "Long", CL["you"]:format(args.spellName))
			end
		end
		if self.db.profile.custom_off_titan_mark and not UnitDebuff(args.destName, auraOfPride) and not self:Tank(args.destName) then
			markTitans(args.destName)
		end
	end
end

function mod:TitanGiftSuccess(args)
	self:Bar(args.spellId, 25)
end

