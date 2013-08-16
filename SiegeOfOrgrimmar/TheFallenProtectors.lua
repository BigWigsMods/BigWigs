--[[
TODO:
	:StopBar
	look if we can get target for Clash
	improve timers by checking how they interact with different Desperate Measures
	look for inferno blast (inferno strike in CLEU) target
	corruption shock target scanning or at least verify how the mobs targeting works
]]--

if GetBuildInfo() ~= "5.4.0" then return end -- 4th return is 50300 on the PTR ATM so can't use that
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Fallen Protectors", 953, 849)
if not mod then return end
mod:RegisterEnableMob(71475, 71479, 71480) -- Rook Stonetoe, He Softfoot, Sun Tenderheart

--------------------------------------------------------------------------------
-- Locals
--
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGUID = UnitGUID

local marksUsed = {}
local darkMeditationTimer
local intermission = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.defile = "Defiled Ground cast"
	L.defile_desc = select(2, EJ_GetSectionInfo(7958))
	L.defile_icon = 143961

	L.custom_off_bane_marks = "Shadow Word: Bane marker"
	L.custom_off_bane_marks_desc = "To help dispelling assignments, mark the initial people who have Shadow Word: Bane on them with %s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

	L.no_meditative_field = "NO Meditative Field!"

	L.intermission = "Desperate Measures"
	L.intermission_desc = "Warnings for when you are getting close to any of the bosses using Desperate Measures"
end
L = mod:GetLocale()
L.custom_off_bane_marks_desc = L.custom_off_bane_marks_desc:format(
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp:15\124t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{144396, "TANK"}, {143019, "FLASH"}, 143027, {143007, "DISPEL"}, 143958, {"defile", "TANK"}, {144357, "FLASH"}, {-7959, "SAY", "PROXIMITY"}, -- Rook Stonetoe
		{143330, "TANK"}, {143292, "FLASH"}, {144367, "FLASH"}, {143840, "FLASH", "PROXIMITY"}, -- He Softfoot
		143446, 143491, 143546, -- Sun Tenderheart
		"custom_off_bane_marks",
		143497, "intermission", "berserk", "proximity", "bosskill",
	}, {
		[144396] = -7885, -- Rook Stonetoe
		[143330] = -7889, -- He Softfoot
		[143446] = -7904, -- Sun Tenderheart
		["custom_off_bane_marks"] = L.custom_off_bane_marks,
		[143497] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "BossSucceeded", "boss1", "boss2", "boss3")
	self:Log("SPELL_CAST_START", "Heal", 143497)
	-- Sun Tenderheart
	self:Log("SPELL_AURA_APPLIED", "DarkMeditationApplied", 143546)
	self:Log("SPELL_AURA_REMOVED", "DarkMeditationRemoved", 143546)
	self:Log("SPELL_CAST_START", "Calamity", 143491)
	self:Log("SPELL_CAST_SUCCESS", "Bane", 143446)
	self:Log("SPELL_AURA_APPLIED", "BaneApplied", 143434)
	self:Log("SPELL_AURA_REMOVED", "BaneRemoved", 143434)
	-- He Softfoot
	self:Log("SPELL_CAST_START", "Gouge", 143330)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 143292)
	self:Log("SPELL_DAMAGE", "NoxiousPoisonDamage", 144367)
	self:Log("SPELL_AURA_APPLIED", "MarkOfAnguishApplied", 143840)
	self:Log("SPELL_AURA_REMOVED", "MarkOfAnguishRemoved", 143840)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringAnguish", 144176)
	-- Rook Stonetoe
	self:Log("SPELL_AURA_APPLIED", "VengefulStrikes", 144396)
	self:Log("SPELL_CAST_SUCCESS", "Clash", 143027)
	self:Log("SPELL_AURA_APPLIED", "CorruptionKick", 143007, 143010) -- XXX double checks spellIds in 10 man
	self:Log("SPELL_CAST_SUCCESS", "CorruptionShock", 143958)
	self:Log("SPELL_DAMAGE", "DefiledGroundDamage", 144357)
	self:Log("SPELL_CAST_START", "DefiledGround", 144357)
	self:Log("SPELL_CAST_START", "InfernoStrike", 143962)


	--self:Death("Win", 100000)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3")
	wipe(intermission)
	darkMeditationTimer = nil
	self:OpenProximity("proximity", 5) -- this might not be needed in LFR
	self:Berserk(900) -- XXX assumed, more than 10 min
	self:Bar(144396, 7) -- VengefulStrikes
	self:Bar(143019, 16) -- Corrupted Brew
	self:CDBar(143027, 44) -- Clash
	self:CDBar(143330, 23) -- Gouge
	self:CDBar(143446, 14) -- Bane
	self:Bar(143491, 29) -- Calamity
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Sun Tenderheart

do
	local function warnDarkMeditation(spellName)
		if UnitDebuff("player", mod:SpellName(143564)) or not UnitAffectingCombat("player") then -- Meditative Field
			mod:CancelTimer(darkMeditationTimer)
			darkMeditationTimer = nil
		else
			mod:Message(143546, "Personal", "Info", L["no_meditative_field"])
		end
	end

	function mod:DarkMeditationRemoved(args)
		if not self:Tank() then
			mod:CancelTimer(darkMeditationTimer)
		end
	end
	function mod:DarkMeditationApplied(args)
		self:Message(args.spellId, "Important", "Alert")
		if not self:Tank() then
			darkMeditationTimer = self:ScheduleRepeatingTimer(warnDarkMeditation, 3, self:SpellName(143546))
		end
	end
end

function mod:Calamity(args)
	self:CDBar(args.spellId, 40)
	self:Bar(args.spellId, 5, CL["cast"]:format(args.spellName))
	self:Message(args.spellId, "Attention", nil, CL["casting"]:format(args.spellName))
end

do
	function mod:BaneRemoved(args)
		if self.db.profile.custom_off_bane_marks then
			for i = 1, 7 do
				if marksUsed[i] == args.destName then
					marksUsed[i] = false
					SetRaidTarget(args.destName, 0)
				end
			end
		end
	end

	local function markBane(destName)
		for i = 1, 7 do
			if not marksUsed[i] then
				SetRaidTarget(destName, i)
				marksUsed[i] = destName
				return
			end
		end
	end
	function mod:BaneApplied(args)
		if self.db.profile.custom_off_bane_marks then
			-- no _DOSE for this so gotta get stacks like this:
			local amount = select(4, UnitDebuff(args.destName, args.spellName))
			if amount and amount == 3 then -- only mark the initial cast
				markBane(args.destName)
			end
		end
	end
end

function mod:Bane(args)
	if self:Dispeller("magic") then
		self:Message(args.spellId, "Urgent", "Alarm")
		self:CDBar(args.spellId, 14)
	end
end

-- He Softfoot

function mod:LingeringAnguish(args)
	-- inform the player with the debuff if stacks are getting high, the values might need adjusting (one warning about every 6 sec atm)
	if UnitDebuff("player", self:SpellName(143840)) and (args.amount > 7 and args.amount%2==0) then -- MarkOfAnguish
		self:StackMessage(143840, args.destName, args.amount, "Personal", "Info", 144176, 144176)
	end
end

function mod:MarkOfAnguishRemoved(args)
	self:CloseProximity(args.spellId)
	self:OpenProximity("proximity", 5)
end

function mod:MarkOfAnguishApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	else
		self:CloseProximity("proximity")
		self:OpenProximity(args.spellId, 30, args.destName, true)
	end
end

do
	local prev = 0
	function mod:NoxiousPoisonDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:Fixate(args)
	if not UnitIsFriend("player", args.destName) then return end
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Attention", "Long")
end

function mod:Gouge(args)
	local unit = mod:GetUnitIdByGUID(args.sourceGUID)
	local target = unit.."target"
	-- only warn for the tank targeted by the mob
	if UnitExists(target) then
		if self:Me(UnitGUID(target)) then
			self:Message(args.spellId, "Urgent", "Alarm")
			self:CDBar(args.spellId, 29)
		end
	end
end

-- Rook Stonetoe

do
	local target
	local function checkTarget(sourceGUID)
		local unit = mod:GetUnitIdByGUID(sourceGUID)
		if not unit then return end
		if UnitExists(unit.."target") and unit.."target" ~= target then
			target = unit.."target"
			if mod:Me(UnitGUID(target)) then
				mod:Flash(-7959)
			else
				mod:CloseProximity("proximity")
				mod:OpenProximity(-7959, 8, target, true)
			end
			mod:TargetBar(-7959, 7, mod:UnitName(target)) -- 9-2
		else
			mod:CloseProximity(-7959)
			mod:OpenProximity("proximity", 5)
		end
	end
	function mod:InfernoStrike(args)
		-- no debuff, no target no nothing, one gypsy implementation of an ability marked as "Important" in the EJ
		-- this probably could use that static shock like say countdown once we can actually reliably determine the target maybe
		if target then
			self:StopBar(-7959, target)
		end
		self:CloseProximity(-7959)
		self:ScheduleTimer(checkTarget, 2, args.sourceGUID)
	end
end

function mod:DefiledGround(args)
	local unit = mod:GetUnitIdByGUID(args.sourceGUID)
	local target = unit.."target"
	-- only warn for the tank targeted by the mob
	if UnitExists(target) then
		if self:Me(UnitGUID(target)) then
			self:CDBar("defile", 10, 144357)
			self:Message("defile", "Urgent", "Alarm", 144357)
		end
	end
end

do
	local prev = 0
	function mod:DefiledGroundDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:CorruptionShock(args)
	-- in 10 man one cast resulted in 2 bolts, so obviously can only warn for 1 target, since CLEU does not supply target
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	local target
	if unit then
		target = unit.."target"
	end
	-- target scanning probably needs improvement
	-- alternative method could be to just scan with a repeating timer for target on the mob, because he only has a target when the cast on the ability finishes
	-- XXX this needs testing and verifying again how the mob changes target
	if UnitExists(target) then
		if self:Me(UnitGUID(target)) then
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
		elseif self:Range(target) < 4 then
			self:RangeMessage(args.spellId)
			self:Flash(args.spellId)
		else
			self:TargetMessage(args.spellId, self:UnitName(target), "Personal", "Info") -- XXX for debug only for now
		end
	else
		self:ScheduleTimer("TargetMessage", 0.1, args.spellId, self:UnitName(target), "Personal", "Info")
	end
end

do
	local corrruptionKickTargets, scheduled = mod:NewTargetList(), nil
	local function warnKick()
		scheduled = nil
		mod:TargetMessage(143007, corrruptionKickTargets, "Important", "Alarm")
	end
	function mod:CorruptionKick(args)
		if self:Dispeller("curse", nil, args.spellId) then
			corrruptionKickTargets[#corrruptionKickTargets+1] = args.destName
			if not scheduled then
				scheduled = self:ScheduleTimer(warnKick, 0.2)
			end
		elseif self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
		end
	end
end

function mod:Clash(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 46)
end

do
	local timer
	local function warnCorruptedBrewTarget(unitId)
		local target = unitId.."target"
		if not UnitExists(target) or mod:Tank(target) or UnitDetailedThreatSituation(target, unitId) then return end
		if mod:Me(UnitGUID(target)) then
			mod:Flash(143019)
			mod:Message(143019, "Personal", "Info", CL["you"]:format(mod:SpellName(143019)))
		elseif mod:Range(target) < 5 then
			mod:RangeMessage(143019)
			mod:Flash(143019)
		else
			mod:TargetMessage(143019, mod:UnitName(target), "Personal", "Info")
		end
		mod:CancelTimer(timer)
		timer = nil
	end
	function mod:BossSucceeded(unitId, spellName, _, _, spellId)
		if spellId == 143019 then -- Corrupted Brew
			-- timer is all over the place, need to figure out if something delays it or what
			self:CDBar(spellId, 11) -- not sure if there is a point for this like this
			if not timer then
				timer = self:ScheduleRepeatingTimer(warnCorruptedBrewTarget, 0.05, unitId)
			end
		end
	end
end

function mod:VengefulStrikes(args)
	local unit = mod:GetUnitIdByGUID(args.sourceGUID)
	local target = unit.."target"
	-- only warn for the tank targeted by the mob
	if UnitExists(target) then
		if self:Me(UnitGUID(target)) then
			self:Message(args.spellId, "Urgent", "Alarm")
			self:Bar(args.spellId, 3, CL["cast"]:format(args.spellName))
			self:CDBar(args.spellId, 21)
		end
	end
end

function mod:Heal(args)
	self:Bar(args.spellId, 15)
	self:Message(args.spellId, "Positive", "Warning")
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	local GUID = UnitGUID(unitId) -- XXX not sure if unitIds reliably reset after intermissions, so just be safe and track by GUID rather than unitId
	if hp < 70 and not intermission[GUID] then -- 66%
		self:Message("intermission", "Neutral", "Info", CL["soon"]:format(("%s (%s)"):format(L["intermission"], self:UnitName(unitId))), false)
		intermission[GUID] = 1
	elseif hp < 37 and intermission[GUID] and intermission[GUID] == 1 then -- 33%
		self:Message("intermission", "Neutral", "Info", CL["soon"]:format(("%s (%s)"):format(L["intermission"], self:UnitName(unitId))), false)
		intermission[GUID] = 2
	end
	if intermission[UnitGUID("boss1")] and intermission[UnitGUID("boss1")] == 2 and intermission[UnitGUID("boss2")] and intermission[UnitGUID("boss2")] == 2 and intermission[UnitGUID("boss3")] and intermission[UnitGUID("boss3")] == 2 then
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3")
	end
end
