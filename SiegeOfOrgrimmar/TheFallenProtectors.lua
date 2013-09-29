--[[
TODO:
	:StopBar
	look if we can get target for Clash
	improve timers by checking how they interact with different Desperate Measures
	look for inferno blast (inferno strike in CLEU) target
	corruption shock target scanning or at least verify how the mobs targeting works
]]--

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

local infernoTarget, infernoTimer = nil, nil

local deathCount = 0

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

	L.inferno_self = "Inferno Strike on you"
	L.inferno_self_desc = "Special countdown when Inferno Strike is on you."
	L.inferno_self_icon = 143962
	L.inferno_self_bar = "You explode!"
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
		{144396, "TANK"}, {143019, "FLASH"}, 143027, {143007, "HEALER"}, 143958, {"defile", "TANK"}, {144357, "FLASH"}, {-7959, "FLASH", "SAY", "PROXIMITY", "ICON"}, {"inferno_self", "SAY", "EMPHASIZE"}, -- Rook Stonetoe
		{143330, "TANK"}, {143292, "FLASH"}, {144367, "FLASH"}, {143840, "FLASH", "PROXIMITY"}, -- He Softfoot
		143446, 143491, 143546, {143423, "SAY"}, -- Sun Tenderheart
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

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "BossSucceeded", "boss1", "boss2", "boss3", "boss4", "boss5")
	self:Log("SPELL_CAST_START", "Heal", 143497)
	-- Sun Tenderheart
	self:Log("SPELL_AURA_APPLIED", "DarkMeditationApplied", 143546)
	self:Log("SPELL_AURA_REMOVED", "DarkMeditationRemoved", 143546)
	self:Log("SPELL_CAST_START", "Calamity", 143491)
	self:Log("SPELL_CAST_SUCCESS", "Bane", 143446)
	self:Log("SPELL_AURA_APPLIED", "BaneApplied", 143434)
	self:Log("SPELL_AURA_REMOVED", "BaneRemoved", 143434)
	self:Log("SPELL_AURA_APPLIED", "ShaSear", 143423)
	-- He Softfoot
	self:RegisterEvent("RAID_BOSS_WHISPER", "Gouge")
	self:Log("SPELL_AURA_APPLIED", "Fixate", 143292)
	self:Log("SPELL_DAMAGE", "NoxiousPoisonDamage", 144367)
	self:Log("SPELL_AURA_APPLIED", "MarkOfAnguishApplied", 143840)
	self:Log("SPELL_AURA_REMOVED", "MarkOfAnguishRemoved", 143840)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringAnguish", 144176)
	-- Rook Stonetoe
	self:Log("SPELL_CAST_SUCCESS", "VengefulStrikes", 144396)
	self:Log("SPELL_CAST_SUCCESS", "Clash", 143027)
	self:Log("SPELL_CAST_SUCCESS", "CorruptionKick", 143007)
	self:Log("SPELL_CAST_SUCCESS", "CorruptionShock", 143958)
	self:Log("SPELL_DAMAGE", "DefiledGroundDamage", 144357)
	self:Log("SPELL_CAST_START", "DefiledGround", 144357)
	self:Log("SPELL_CAST_START", "InfernoStrike", 143962)


	self:Death("Deaths", 71475, 71479, 71480) -- Rook Stonetoe, He Softfoot, Sun Tenderheart
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3")
	wipe(intermission)
	darkMeditationTimer = nil
	deathCount = 0
	infernoTarget, infernoTimer = nil, nil
	self:OpenProximity("proximity", 5) -- this might not be needed in LFR
	self:Berserk(self:Heroic() and 600 or 900) -- Both unverified           -- 600 verified for 10m hc /Mikk
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
			for i = 1, 5 do
				if marksUsed[i] == args.destName then
					marksUsed[i] = false
					SetRaidTarget(args.destName, 0)
				end
			end
		end
	end

	local function markBane(destName)
		for i = 1, 5 do
			if not marksUsed[i] then
				SetRaidTarget(destName, i)
				marksUsed[i] = destName
				return
			end
		end
	end
	local prev = 0
	function mod:BaneApplied(args)
		-- XXX this whole marking probably use some code clean up
		if self.db.profile.custom_off_bane_marks then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				wipe(marksUsed)
			end
			-- no _DOSE for this so gotta get stacks like this:
			local _, _, _, amount = UnitDebuff(args.destName, args.spellName)
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

function mod:ShaSear(args)
	if infernoTarget and self:Me(args.destGUID) then -- Only during Inferno Strike phase (when people are hugging)
		if not self:LFR() then
			self:Say(args.spellId)
		end
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:TargetBar(args.spellId, 5, args.destName)
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

function mod:Gouge(_, msg)
	-- only warn the tank targeted by the mob by using _WHISPER
	if msg:find("143330", nil, true) then
		self:Message(143330, "Urgent", "Alarm")
		self:CDBar(143330, 29)
	end
end

-- Rook Stonetoe

do
	local timeLeft = 8
	local function infernoCountdown()
		timeLeft = timeLeft - 1
		if timeLeft < 6 then
			mod:Say("inferno_self", timeLeft, true)
			if timeLeft < 2 then
				mod:CancelTimer(infernoTimer)
				infernoTimer = nil
			end
		end
	end
	local function checkTarget(sourceGUID)
		local self = mod
		for i = 1, 5 do
			local boss = ("boss%d"):format(i)
			if UnitGUID(boss) == sourceGUID then
				local bossTarget = boss.."target"
				local player = UnitGUID(bossTarget)
				if player then
					infernoTarget = self:UnitName(bossTarget)
					self:TargetMessage(-7959, infernoTarget, "Urgent", "Warning")
					self:TargetBar(-7959, 8.5, infernoTarget)
					self:PrimaryIcon(-7959, infernoTarget)
					if self:Me(player) then
						self:Flash(-7959)
						self:Say(-7959)
						if not self:LFR() then -- Don't spam in LFR
							timeLeft = 8
							if infernoTimer then mod:CancelTimer(infernoTimer) end
							infernoTimer = self:ScheduleRepeatingTimer(infernoCountdown, 1)
						end
						-- Emphasized abilities
						self:StopBar(-7959, infernoTarget)
						self:TargetMessage("inferno_self", infernoTarget, "Urgent", nil, -7959)
						self:Bar("inferno_self", 8.5, L["inferno_self_bar"], -7959)
					elseif not self:Tank() then
						self:CloseProximity("proximity")
						self:OpenProximity(-7959, 8, infernoTarget, true)
					end
				end
				break
			end
		end
	end
	function mod:InfernoStrike(args)
		self:CloseProximity(-7959)
		self:PrimaryIcon(-7959)
		self:ScheduleTimer(checkTarget, 0.5, args.sourceGUID)
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
	if not unit then
		self:Message(args.spellId, "Personal", "Info")
		return
	end

	-- target scanning probably needs improvement
	-- alternative method could be to just scan with a repeating timer for target on the mob, because he only has a target when the cast on the ability finishes
	-- XXX this needs testing and verifying again how the mob changes target
	local target = unit.."target"
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

function mod:CorruptionKick(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:Clash(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 46)
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Flash(143019)
		elseif self:Range(name) < 5 then
			self:RangeMessage(143019)
			self:Flash(143019)
			return
		end
		self:TargetMessage(143019, name, "Personal", "Info")
	end
	function mod:BossSucceeded(unitId, spellName, _, _, spellId)
		if spellId == 143019 then -- Corrupted Brew
			-- timer is all over the place, need to figure out if something delays it or what
			self:CDBar(spellId, 11) -- not sure if there is a point for this like this
			self:GetBossTarget(printTarget, 0.2, UnitGUID(unitId))
		elseif spellId == 138175 and self:MobId(UnitGUID(unitId)) == 71481 then -- Despawn Area Triggers
			self:CloseProximity(-7959)
			self:OpenProximity("proximity", 5)
			self:PrimaryIcon(-7959)
			if infernoTimer then
				self:CancelTimer(infernoTimer)
				infernoTimer = nil
			end
			if infernoTarget then
				self:StopBar(-7959, infernoTarget)
				self:StopBar(L["inferno_self_bar"])
				infernoTarget = nil
			end
		end
	end
end

function mod:VengefulStrikes(args)
	-- only warn for the tank targeted by the mob
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Urgent", "Alarm")
		self:Bar(args.spellId, 3, CL["cast"]:format(args.spellName))
		self:CDBar(args.spellId, 21)
	end
end

function mod:Heal(args)
	self:Bar(args.spellId, 15, ("%s (%s)"):format(args.spellName, args.sourceName)) -- this is too long for a normal bar, but needed so bars don't overwrite each other
	self:Message(args.spellId, "Positive", "Warning")
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local mobId = self:MobId(UnitGUID(unitId))
	if mobId and (mobId == 71475 or mobId == 71479 or mobId == 71480) then
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
end

function mod:Deaths()
	deathCount = deathCount + 1
	if deathCount > 2 then
		self:Win()
	end
end

