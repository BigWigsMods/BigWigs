--------------------------------------------------------------------------------
-- TODO
-- -- Mark the Essence Font with the same marker the Vile Occultist was marked with (SPELL_SUMMON events for GUIDs)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sun King's Salvation", 2296, 2422)
if not mod then return end
mod:RegisterEnableMob(165805, 165759, 168973) -- Shade of Kael'thas, Kael'thas, High Torturer Darithos
mod.engageId = 2402
mod.respawnTime = 30
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local firstVanquisherExpected = 0
local firstVanquisherSpawnTime = 8
local addTimersHeroic = { -- Heroic
	[1] = { -- From pull
		[-21954] = {35, 65}, -- Rockbound Vanquishers
		[-21993] = {54, 90, 137}, -- Bleakwing Assassin
		[-21952] = {54, 90}, -- Vile Occultists
		[-21953] = {115}, -- Soul Infusers
		[-22082] = {54.5, 41}, -- Pestering Fiend
	},
	[2] = { -- From Reflection of Guilt Removed
		[-21954] = {69, 65, 65}, -- Rockbound Vanquishers
		[-21993] = {24, 60, 30, 40, 50, 30, 60, 40}, -- Bleakwing Assassin
		[-21952] = {114, 70, 140}, -- Vile Occultists
		[-21953] = {54, 60, 150, 70}, -- Soul Infusers
		[-22082] = {24, 30, 30, 70, 30, 50, 30, 30}, -- Pestering Fiend
	},
}

local addTimersMythic = { -- Mythic
	[1] = { -- From pull
		[-21954] = {51.7}, -- Rockbound Vanquishers
		[-21993] = {}, -- Bleakwing Assassin
		[-21952] = {}, -- Vile Occultists
		[-21953] = {}, -- Soul Infusers
		[-22082] = {}, -- Pestering Fiend
	},
	[2] = { -- From Reflection of Guilt Removed
		[-21954] = {3.5, 70, 70, 70}, -- Rockbound Vanquishers
		[-21993] = {33.7, 109.8, 70}, -- Bleakwing Assassin
		[-21952] = {33.7, 150, 34.7}, -- Vile Occultists
		[-21953] = {90.7, 100}, -- Soul Infusers
		[-22082] = {53.7, 40, 49.8, 70}, -- Pestering Fiend
	},
}
local addTimers = {}
local addWaveCount = {
	[-21954] = 1, -- Rockbound Vanquishers
	[-21993] = 1, -- Bleakwing Assassin
	[-21952] = 1, -- Vile Occultists
	[-21953] = 1, -- Soul Infusers
	[-22082] = 1, -- Pestering Fiend
}
local addScheduledTimers = {}
local nextStageWarning = 42
local mobCollector = {}
local iconsInUse = {}
local vileOccultistMarkCount = 0
local shadeUp = nil
local concussiveSmashCountTable = {}
local blazingSurgeCount = 1
local emberBlastCount = 1
local cloakOfFlamesCount = 1
local phoenixCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.shield_removed = "%s removed after %.1fs" -- "Shield removed after 1.1s" s = seconds
	L.shield_remaining = "%s remaining: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local vileOccultistMarker = mod:AddMarkerOption(false, "npc", 8, -21952, 8, 7, 6, 5, 4, 3) -- Vile Occultist
local essenceFontMarker = mod:AddMarkerOption(false, "npc", 1, -22232, 1, 2, 3, 4, 5, 6) -- Essence Font
local phoenixMarker = mod:AddMarkerOption(false, "npc", 4, -22090, 1, 2, 3, 4) -- Reborn Phoenix
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		{326455, "TANK"}, -- Fiery Strike
		326456, -- Burning Remnants
		{325877, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Ember Blast
		329518, -- Blazing Surge
		328579, -- Smoldering Remnants
		{328479, "ME_ONLY_EMPHASIZE"}, -- Eyes on Target
		phoenixMarker,
		-21954, -- Rockbound Vanquisher
		{325440, "TANK"}, -- Vanquishing Strike
		{325442, "TANK"}, -- Vanquished
		325506, -- Concussive Smash
		-21993, -- Bleakwing Assassin
		{326583, "SAY", "FLASH"}, -- Crimson Flurry
		333145, -- Return to Stone
		-21952, -- Vile Occultist
		333002, -- Vulgar Brand
		vileOccultistMarker,
		-21953, -- Soul Infuser
		-22082, -- Pestering Fiend
		-- Infusing Essences
		{326078, "HEALER"}, -- Infuser's Boon
		339251, -- Drained Soul
		essenceFontMarker,
		-- High Torturer Darithos
		{328889, "SAY", "PROXIMITY"}, -- Greater Castigation
		-- Mythic
		337859, -- Cloak of Flames
		343026, -- Damage Cloak of Flames
	},{
		["stages"] = "general",
		[326455] = -21966, -- Shade of Kael'thas
		[-21954] = -21951, -- Ministers of Vice
		[326078] = -22231, -- Infusing Essences
		[328889] = -22089, -- High Torturer Darithos
		[338600] = "mythic",
	},{
		[328479] = CL.fixate, -- Eyes on Target (Fixate)
		[337859] = CL.shield, -- Cloak of Flames (Shield)
	}
end

function mod:OnBossEnable()
	-- Marking
	self:Death("VileOccultistDeath", 165763) -- Vile Occultist
	self:Log("SPELL_CAST_START", "EssenceOverflow", 329561)
	self:Death("EssenceFontDeath", 165778) -- Essence Font

	-- Shade of Kael'thas
	self:Log("SPELL_AURA_APPLIED", "ReflectionOfGuiltApplied", 323402)
	self:Log("SPELL_CAST_START", "FieryStrike", 326455)
	self:Log("SPELL_AURA_APPLIED", "BurningRemnantsApplied", 326456)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningRemnantsApplied", 326456)
	self:Log("SPELL_CAST_START", "EmberBlast", 325877)
	self:Log("SPELL_CAST_START", "BlazingSurge", 329518)
	self:Log("SPELL_AURA_APPLIED", "EyesOnTarget", 328479) -- Phoenix Fixate
	self:Log("SPELL_AURA_REMOVED", "ReflectionOfGuiltRemoved", 323402)

	-- Ministers of Vice
	self:Log("SPELL_CAST_START", "VanquishingStrike", 325440)
	self:Log("SPELL_AURA_APPLIED", "VanquishedApplied", 325442)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VanquishedApplied", 325442)
	self:Log("SPELL_CAST_START", "ConcussiveSmash", 325506)
	self:Death("RockboundVanquisherDeath", 165764) -- Rockbound Vanquisher
	self:Log("SPELL_AURA_APPLIED", "CrimsonFlurryApplied", 326583)
	self:Log("SPELL_CAST_START", "ReturnToStone", 333145)
	self:Log("SPELL_CAST_START", "VulgarBrand", 333002)

	-- Infusing Essences
	self:Log("SPELL_AURA_APPLIED", "DrainedSoul", 339251)
	self:Log("SPELL_AURA_APPLIED", "InfusersBoonApplied", 326078)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusersBoonApplied", 326078)

	-- High Torturer Darithos
	self:Log("SPELL_CAST_START", "GreaterCastigation", 328885)
	self:Log("SPELL_AURA_APPLIED", "GreaterCastigationApplied", 332871) -- Pre-debuff
	self:Log("SPELL_MISSED", "GreaterCastigationRemoved", 328889) -- Actual Channeled debuff Immune
	self:Log("SPELL_AURA_REMOVED", "GreaterCastigationRemoved", 328889) -- Actual Channeled debuff
	self:Death("DarithosDeath", 168973) -- High Torturer Darithos

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CloakOfFlamesApplied", 337859, 343026)
	self:Log("SPELL_AURA_REMOVED", "CloakOfFlamesRemoved", 337859, 343026)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 328579) -- Smoldering Remnants
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 328579)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 328579)
end

function mod:VerifyEnable(unit, mobId)
	if mobId == 165759 then -- Kael'thas
		if self:GetHealth(unit) < 50 then
			return true
		end
	else
		return true
	end
end

function mod:OnEngage()
	addWaveCount = {
		[-21954] = 1, -- Rockbound Vanquishers
		[-21993] = 1, -- Bleakwing Assassin
		[-21952] = 1, -- Vile Occultists
		[-21953] = 1, -- Soul Infusers
		[-22082] = 1, -- Pestering Fiend
	}
	addTimers = self:Mythic() and addTimersMythic or addTimersHeroic
	addScheduledTimers = {}
	firstVanquisherExpected = GetTime() + addTimers[1][-21954][1]
	nextStageWarning = 42
	mobCollector = {}
	iconsInUse = {}
	concussiveSmashCountTable = {}
	blazingSurgeCount = 1
	emberBlastCount = 1
	cloakOfFlamesCount = 1
	shadeUp = nil
	phoenixCount = 0
	self:SetStage(1)

	self:Bar(328889, 5.5) -- Greater Castigation

	for key,count in pairs(addWaveCount) do
		self:StartAddTimer(1, key, count)
	end

	if self:Mythic() then
		self:Bar(337859, 62, CL.count:format(CL.shield, cloakOfFlamesCount)) -- Cloak of Flames
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")

	if self:GetOption(vileOccultistMarker) or self:GetOption(essenceFontMarker) or self:GetOption(phoenixMarker) then
		self:RegisterTargetEvents("SunKingsSalvationMarker")
	end

	if not self:Mythic() then
		self:Berserk(840) -- 14 minutes
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local addStyling = {
			[-21954] = {mod:SpellName(-21954), "achievement_dungeon_hallsofattonement_echelon"}, -- Rockbound Vanquishers
			[-21993] = {mod:SpellName(-21993), "achievement_raid_revendrethraid_ladyinervadarkvein"}, -- Bleakwing Assassin
			[-21952] = {mod:SpellName(-21952), "achievement_dungeon_hallsofattonement_aleez"}, -- Vile Occultists
			[-21953] = {mod:SpellName(-21953), "achievement_raid_revendrethraid_altimor"}, -- Soul Infusers
			[-22082] = {mod:SpellName(-22082), "ability_warlock_empoweredimp"}, -- Pestering Fiend
	}

	function mod:StartAddTimer(stage, addType, count, reduced)
		if shadeUp or not addTimers[stage] then return end -- Dont start anything new
		local timers = addTimers[stage][addType]
		if not timers[count] then return end

		local time = addTimers[stage][addType][count]
		if reduced then
			local reduceTimerBy = addTimers[1][-21954][1] - firstVanquisherSpawnTime
			time = time - reduceTimerBy
		end
		local spellName, icon = unpack(addStyling[addType])
		local spellId = addType -- SetOption:-21954,-21993,-21952,-21953,-22082:

		self:Bar(spellId, time, CL.count:format(spellName, addWaveCount[spellId]), icon)
		self:DelayedMessage(spellId, time, "yellow", CL.count:format(spellName, addWaveCount[spellId]), icon, "info")
		addWaveCount[spellId] = addWaveCount[spellId] + 1
		addScheduledTimers[spellId] = self:ScheduleTimer("StartAddTimer", time, stage, spellId, addWaveCount[spellId])
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) > nextStageWarning then -- Stage changes at 45% and 90%
		self:Message("stages", "green", CL.soon:format(self:SpellName(-21966)), "achievement_raid_revendrethraid_kaelthassunstrider")
		nextStageWarning = nextStageWarning + 45
		if nextStageWarning > 90 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:SunKingsSalvationMarker(event, unit, guid)
	if self:GetOption(vileOccultistMarker) and self:MobId(guid) == 165763 and not mobCollector[guid] then -- Vile Occultist
		vileOccultistMarkCount = vileOccultistMarkCount + 1
		local icon = 9 - (vileOccultistMarkCount % 6 + 1) -- 8, 7, 5, 6, 4, 3
		self:CustomIcon(vileOccultistMarker, unit, icon)
		iconsInUse[icon] = guid
		mobCollector[guid] = true
	elseif self:GetOption(essenceFontMarker) and self:MobId(guid) == 165778 and not mobCollector[guid] then -- Essence Font
		for i = 1, 6 do
			if not iconsInUse[i] then
				self:CustomIcon(essenceFontMarker, unit, i)
				iconsInUse[i] = guid
				mobCollector[guid] = true
			end
		end
	elseif self:GetOption(phoenixMarker) and self:MobId(guid) == 168962 and not mobCollector[guid] then -- Phoenix
		phoenixCount = phoenixCount + 1
		self:CustomIcon(phoenixMarker, unit, phoenixCount)
		mobCollector[guid] = true
	end
end

function mod:EssenceOverflow(args)
	tDeleteItem(iconsInUse, args.sourceGUID)
end

function mod:EssenceFontDeath(args)
	tDeleteItem(iconsInUse, args.destGUID)
end

function mod:VileOccultistDeath(args)
	tDeleteItem(iconsInUse, args.destGUID)
end

-- Shade of Kael'thas
function mod:ReflectionOfGuiltApplied(args)
	if not shadeUp then
		shadeUp = true
		self:Message("stages", "green", CL.incoming:format(self:SpellName(-21966)), "achievement_raid_revendrethraid_kaelthassunstrider")
		self:PlaySound("stages", "long")
		self:Bar("stages", 8.75, -21966, "achievement_raid_revendrethraid_kaelthassunstrider") -- Shade of Keal'thas

		for key,count in pairs(addWaveCount) do -- Cancel add bars and scheduled messages
			local text = CL.count:format(self:SpellName(key), count-1)
			self:CancelDelayedMessage(text)
			self:StopBar(text)
		end
		self:StopBar(CL.count:format(CL.shield, cloakOfFlamesCount)) -- Cloak of Flames

		for key, scheduled in pairs(addScheduledTimers) do -- cancel all scheduled add timers
			self:CancelTimer(scheduled)
			addScheduledTimers[key] = nil
		end

		blazingSurgeCount = 1
		emberBlastCount = 1
		cloakOfFlamesCount = 1

		self:Bar(326455, 13.5) -- Fiery Strike
		self:Bar(325877, 19.5, CL.count:format(self:SpellName(325877), emberBlastCount)) -- Ember Blast
		self:Bar(329518, 29.5, CL.count:format(self:SpellName(329518), blazingSurgeCount)) -- Blazing Surge

		if self:Mythic() then
			self:Bar(343026, 38.9, CL.count:format(self:SpellName(343026), cloakOfFlamesCount))
		end
	end
end

function mod:FieryStrike(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 8) --6.8~10.6
end

function mod:BurningRemnantsApplied(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and not self:Tank() then
		self:NewStackMessage(args.spellId, "blue", args.destName, amount)
		self:PlaySound(args.spellId, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then
		self:NewStackMessage(args.spellId, "purple", args.destName, amount, 3)
		if amount > 2 then -- 3+
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:PlaySound(325877, "warning")
			self:Yell(325877)
			self:Flash(325877)
			self:YellCountdown(325877, 3, nil, 2)
		else
			self:PlaySound(325877, "alert")
		end
		self:TargetMessage(325877, "orange", player, CL.count:format(self:SpellName(325877), emberBlastCount-1))
	end

	function mod:EmberBlast(args)
		self:GetNextBossTarget(printTarget, args.sourceGUID)
		self:CastBar(args.spellId, 3, CL.count:format(args.spellName, emberBlastCount))
		emberBlastCount = emberBlastCount + 1
		self:Bar(args.spellId, 20.5, CL.count:format(args.spellName, emberBlastCount))
	end
end

function mod:BlazingSurge(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, blazingSurgeCount))
	self:PlaySound(args.spellId, "alert")
	blazingSurgeCount = blazingSurgeCount + 1
	self:Bar(args.spellId, 19.5, CL.count:format(args.spellName, blazingSurgeCount))
end

function mod:EyesOnTarget(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ReflectionOfGuiltRemoved()
	self:Message("stages", "green", CL.removed:format(self:SpellName(-21966)), "achievement_raid_revendrethraid_kaelthassunstrider") -- Shade of Kael'thas
	self:PlaySound("stages", "long")
	self:StopBar(326455) -- Fiery Strike
	self:StopBar(CL.count:format(self:SpellName(329518), blazingSurgeCount)) -- Blazing Surge
	self:StopBar(CL.count:format(self:SpellName(325877), emberBlastCount)) -- Ember Blast
	self:StopBar(CL.cast:format(CL.count:format(self:SpellName(325877), emberBlastCount-1))) -- Ember Blast
	self:CancelSayCountdown(325877) -- Ember Blast
	self:StopBar(CL.count:format(self:SpellName(343026), cloakOfFlamesCount)) -- Cloak of Flames

	local stage = self:GetStage() + 1
	if stage == 3 then return end -- You win
	self:SetStage(stage)
	shadeUp = nil
	addWaveCount = {
		[-21954] = 1, -- Rockbound Vanquishers
		[-21993] = 1, -- Bleakwing Assassin
		[-21952] = 1, -- Vile Occultists
		[-21953] = 1, -- Soul Infusers
		[-22082] = 1, -- Pestering Fiend
	}
	for key,count in pairs(addWaveCount) do
		self:StartAddTimer(stage, key, count)
	end

	cloakOfFlamesCount = 1
	if self:Mythic() then
		self:Bar(337859, 34.3, CL.count:format(CL.shield, cloakOfFlamesCount))
	end
end

-- Ministers of Vice
function mod:VanquishingStrike(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 6.3)
end

function mod:VanquishedApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 3)
	if amount > 2 then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ConcussiveSmash(args)
	local count = concussiveSmashCountTable[args.sourceGUID] or 1
	self:StopBar(CL.count:format(args.spellName, count))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, count))
	self:PlaySound(args.spellId, "alarm")
	concussiveSmashCountTable[args.sourceGUID] = count + 1
	self:Bar(args.spellId, 19.5, CL.count:format(args.spellName, count))
end

function mod:RockboundVanquisherDeath(args)
	local count = concussiveSmashCountTable[args.sourceGUID] or 1
	self:StopBar(CL.count:format(self:SpellName(325506), count)) -- Concussive Smash
	concussiveSmashCountTable[args.sourceGUID] = nil
	self:StopBar(325440) -- Vanquishing Strike
end

function mod:CrimsonFlurryApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

do
	local prev = 0
	function mod:ReturnToStone(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "cyan")
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:VulgarBrand(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "alarm")
	end
end

-- Infusing Essences
function mod:InfusersBoonApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "green", args.destName, amount)
	self:StopBar(CL.count:format(args.spellName, amount-1), args.destName)
	self:TargetBar(args.spellId, 14, args.destName, CL.count:format(args.spellName, amount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "info")
	end
end

function mod:DrainedSoul(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

-- High Torturer Darithos
function mod:GreaterCastigation(args)
	self:Message(328889, "yellow") -- Greater Castigation
	self:Bar(328889, 15.5) -- Greater Castigation
end

do
	local proxList, isOnMe = {}, nil
	function mod:GreaterCastigationApplied(args)
		proxList[#proxList+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Say(328889) -- Greater Castigation
			self:OpenProximity(328889, 6) -- Greater Castigation
			self:PlaySound(328889, "alarm") -- Greater Castigation
		end
		if not isOnMe then
			self:OpenProximity(328889, 6, proxList) -- Greater Castigation
		end
	end

	function mod:GreaterCastigationRemoved(args)
		tDeleteItem(proxList, args.destName)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:CloseProximity(args.spellId)
		end

		if not isOnMe then
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 6, proxList)
			end
		end
	end
end

function mod:DarithosDeath()
	self:CloseProximity(328889)
	self:StopBar(328889) -- Greater Castigation

	local firstVanquisherRemaining = firstVanquisherExpected - GetTime() -- Always negative if you killed him very late so we dont need a stage check
	if firstVanquisherRemaining > firstVanquisherSpawnTime then -- Reduce all to align with the first spawn for the first Vanquisher
		for key,count in pairs(addWaveCount) do -- Cancel add bars and scheduled messages
			local text = CL.count:format(self:SpellName(key), count-1)
			self:CancelDelayedMessage(text)
			self:StopBar(text)
		end
		for key, scheduled in pairs(addScheduledTimers) do -- cancel all scheduled add timers
			self:CancelTimer(scheduled)
			addScheduledTimers[key] = nil
		end
		-- Restart the timers, but with reduced time
		addWaveCount = {
			[-21954] = 1, -- Rockbound Vanquishers
			[-21993] = 1, -- Bleakwing Assassin
			[-21952] = 1, -- Vile Occultists
			[-21953] = 1, -- Soul Infusers
			[-22082] = 1, -- Pestering Fiend
		}
		for key,count in pairs(addWaveCount) do
			self:StartAddTimer(1, key, count, true)
		end
	end
end

-- Mythic
do
	local prevTime, prevAmount = 0, 0
	function mod:CloakOfFlamesApplied(args)
		prevTime, prevAmount = args.time, args.amount
		self:Message(args.spellId, "red", CL.count:format(CL.shield, cloakOfFlamesCount))
		self:PlaySound(args.spellId, "warning")
		self:CastBar(args.spellId, 6, CL.count:format(CL.shield, cloakOfFlamesCount))
		cloakOfFlamesCount = cloakOfFlamesCount + 1
		self:Bar(args.spellId, shadeUp and 30 or 60, CL.count:format(CL.shield, cloakOfFlamesCount))
	end

	function mod:CloakOfFlamesRemoved(args)
		local amount = args.amount or 0
		if amount > 0 then -- Shield blew up
			local percentRemaining = amount / prevAmount * 100
			self:Message(args.spellId, "red", L.shield_remaining:format(CL.shield, self:AbbreviateNumber(amount), percentRemaining))
		else
			self:Message(args.spellId, "green", L.shield_removed:format(CL.shield, args.time - prevTime))
			self:StopBar(CL.cast:format(CL.count:format(CL.shield, cloakOfFlamesCount-1)))
		end
		self:PlaySound(args.spellId, "info")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
