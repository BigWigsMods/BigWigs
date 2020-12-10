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

--------------------------------------------------------------------------------
-- Locals
--

local startTime = 0
local addTimersHeroic = { -- Heroic
	[1] = {
		[-21954] = {35, 100}, -- Rockbound Vanquishers
		[-21993] = {54, 144, 281}, -- Bleakwing Assassin
		[-21952] = {54, 144}, -- Vile Occultists
		[-21953] = {115}, -- Soul Infusers
		[-22082] = {54.5, 95.5}, -- Pestering Fiend
	},
	[2] = { -- From Reflection of Guilt Removed
		[-21954] = {69, 134, 199}, -- Rockbound Vanquishers
		[-21993] = {24, 84, 114, 154, 204, 234, 294, 334}, -- Bleakwing Assassin
		[-21952] = {114, 184, 324}, -- Vile Occultists
		[-21953] = {54, 114, 264, 334}, -- Soul Infusers
		[-22082] = {24, 54, 84, 154, 184, 234, 264, 294}, -- Pestering Fiend
	},
}

local addTimersMythic = { -- Mythic
	[1] = {
		[-21954] = {33, 92, 152, 212}, -- Rockbound Vanquishers
		[-21993] = {92, 122, 152, 247}, -- Bleakwing Assassin
		[-21952] = {99}, -- Vile Occultists
		[-21953] = {}, -- Soul Infusers
		[-22082] = {54.5, 95.5}, -- Pestering Fiend
	},
	[2] = { -- From Reflection of Guilt Removed
		[-21954] = {26, 76.5, 125}, -- Rockbound Vanquishers
		[-21993] = {59.5, 89, 140, 158}, -- Bleakwing Assassin
		[-21952] = {12}, -- Vile Occultists
		[-21953] = {12, 83, 113.5}, -- Soul Infusers
		[-22082] = {49, 108, 128.5}, -- Pestering Fiend
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
local stage = 1
local shadeUp = nil
local concussiveSmashCountTable = {}
local blazingSurgeCount = 1
local emberBlastCount = 1
local cloakofFlamesCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

local vileOccultistMarker = mod:AddMarkerOption(false, "npc", 8, -21952, 8, 7, 6, 5, 4, 3) -- Vile Occultist
local essenceFontMarker = mod:AddMarkerOption(false, "npc", 1, -22232, 1, 2, 3, 4, 5, 6) -- Essence Font
function mod:GetOptions()
	return {
		"stages",
		{326455, "TANK"}, -- Fiery Strike
		326456, -- Burning Remnants
		{325877, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Ember Blast
		329518, -- Blazing Surge
		328579, -- Smoldering Remnants
		328479, -- Eyes on Target
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
		337859,  -- Cloak of Flames
	},{
		["stages"] = "general",
		[326455] = -21966, -- Shade of Kael'thas
		[-21954] = -21951, -- Ministers of Vice
		[326078] = -22231, -- Infusing Essences
		[328889] = -22089, -- High Torturer Darithos
		[338600] = "mythic",
	}
end

function mod:OnBossEnable()
	-- Marking
	self:Death("VileOccultistDeath", 165763) -- Vile Occultist
	self:Log("SPELL_CAST_START", "EssenceOverflow", 329561)
	self:Death("EssenceFontDeath", 165778) -- Essence Font

	-- Shade of Kael'thas
	self:Log("SPELL_AURA_APPLIED", "ReflectionofGuiltApplied", 323402)
	self:Log("SPELL_CAST_START", "FieryStrike", 326455)
	self:Log("SPELL_AURA_APPLIED", "BurningRemnantsApplied", 326456)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningRemnantsApplied", 326456)
	self:Log("SPELL_CAST_START", "EmberBlast", 325877)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Ember Blast Target
	self:Log("SPELL_CAST_START", "BlazingSurge", 329518)
	self:Log("SPELL_AURA_APPLIED", "EyesonTarget", 328479) -- Phoenix Fixate
	self:Log("SPELL_AURA_REMOVED", "ReflectionofGuiltRemoved", 323402)

	-- Ministers of Vice
	self:Log("SPELL_CAST_START", "VanquishingStrike", 325440)
	self:Log("SPELL_AURA_APPLIED", "VanquishedApplied", 325442)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VanquishedApplied", 325442)
	self:Log("SPELL_CAST_START", "ConcussiveSmash", 325506)
	self:Death("RockboundVanquisherDeath", 165764) -- Rockbound Vanquisher
	self:Log("SPELL_AURA_APPLIED", "CrimsonFlurryApplied", 326583)
	self:Log("SPELL_CAST_START", "ReturntoStone", 333145)
	self:Log("SPELL_CAST_START", "VulgarBrand", 333002)

	-- Infusing Essences
	self:Log("SPELL_AURA_APPLIED", "DrainedSoul", 339251)
	self:Log("SPELL_AURA_APPLIED", "InfusersBoonApplied", 326078)

	-- High Torturer Darithos
	self:Log("SPELL_CAST_START", "GreaterCastigation", 328885)
	self:Log("SPELL_AURA_APPLIED", "GreaterCastigationApplied", 332871) -- Pre-debuff
	self:Log("SPELL_MISSED", "GreaterCastigationRemoved", 328889) -- Actual Channeled debuff Immune
	self:Log("SPELL_AURA_REMOVED", "GreaterCastigationRemoved", 328889) -- Actual Channeled debuff
	self:Death("DarithosDeath", 168973) -- High Torturer Darithos

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CloakofFlamesApplied", 337859)
	self:Log("SPELL_AURA_REMOVED", "CloakofFlamesRemoved", 337859)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 328579) -- Smoldering Remnants
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 328579)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 328579)
end

function mod:VerifyEnable(unit, mobId)
	if mobId == 165759 then -- Kael'thas
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp < 50 then
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
	startTime = GetTime()
	nextStageWarning = 42
	mobCollector = {}
	iconsInUse = {}
	stage = 1
	concussiveSmashCountTable = {}
	blazingSurgeCount = 1
	emberBlastCount = 1
	cloakofFlamesCount = 1
	shadeUp = nil

	self:Bar(328889, 5.5) -- Greater Castigation

	for key,count in pairs(addWaveCount) do
		self:StartAddTimer(stage, key, count)
	end

	if self:Mythic() then
		self:Bar(337859, 62, CL.count:format(self:SpellName(337859), cloakofFlamesCount)) -- Cloak of Flames
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")

	if self:GetOption(vileOccultistMarker) or self:GetOption(essenceFontMarker) then
		self:RegisterTargetEvents("SunKingsSalvationMarker")
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

	function mod:StartAddTimer(stage, addType, count)
		if shadeUp or not addTimers[stage] then return end -- Dont start anything new
		local timers = addTimers[stage][addType]
		if not timers[count] then return end

		local time = addTimers[stage][addType][count]
		local length = floor(time - (GetTime() - startTime))
		local spellName, icon = unpack(addStyling[addType])
		local spellId = addType -- SetOption:-21954,-21993,-21952,-21953,-22082:

		self:Bar(spellId, length, CL.count:format(spellName, addWaveCount[spellId]), icon)
		self:DelayedMessage(spellId, length, "yellow", CL.count:format(spellName, addWaveCount[spellId]), icon, "info")
		addWaveCount[spellId] = addWaveCount[spellId] + 1
		addScheduledTimers[spellId] = self:ScheduleTimer("StartAddTimer", length, stage, spellId, addWaveCount[spellId])
	end
end

function mod:UNIT_HEALTH(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp > nextStageWarning then -- Stage changes at 45% and 90%
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
		SetRaidTarget(unit, icon)
		iconsInUse[icon] = guid
		mobCollector[guid] = true
	elseif self:GetOption(essenceFontMarker) and self:MobId(guid) == 165778 and not mobCollector[guid] then -- Essence Font
		for i = 1, 6 do
			if not iconsInUse[i] then
				SetRaidTarget(unit, i)
				iconsInUse[i] = guid
				mobCollector[guid] = true
			end
		end
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
function mod:ReflectionofGuiltApplied(args)
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

		for key, scheduled in pairs(addScheduledTimers) do -- cancel all scheduled add timers
			self:CancelTimer(scheduled)
			addScheduledTimers[key] = nil
		end

		blazingSurgeCount = 1
		emberBlastCount = 1

		self:Bar(326455, 13.5) -- Fiery Strike
		self:Bar(325877, 19.5, CL.count:format(self:SpellName(325877), emberBlastCount)) -- Ember Blast
		self:Bar(329518, 29.5, CL.count:format(self:SpellName(329518), blazingSurgeCount)) -- Blazing Surge
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
		self:StackMessage(args.spellId, args.destName, amount, "blue")
		self:PlaySound(args.spellId, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		if amount > 1 then -- 2+
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local castEnd = 0
	function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, destName)
		if msg:find("325873", nil, true) then -- Ember Blast
			self:TargetMessage(325877, "orange", destName, CL.count:format(self:SpellName(325877), emberBlastCount))
			local guid = UnitGUID(destName)
			if self:Me(guid) then
				self:PlaySound(325877, "warning")
				self:Say(325877)
				self:Flash(325877)
				local castLeft = castEnd - GetTime()
				self:SayCountdown(325877, castLeft)
			else
				self:PlaySound(325877, "alert")
			end
		end
	end

	function mod:EmberBlast(args)
		castEnd = GetTime() + 5
		self:CastBar(args.spellId, 5, CL.count:format(args.spellName, emberBlastCount))
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

function mod:EyesonTarget(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ReflectionofGuiltRemoved()
	self:Message("stages", "green", CL.removed:format(self:SpellName(-21966)), "achievement_raid_revendrethraid_kaelthassunstrider") -- Shade of Kael'thas
	self:PlaySound("stages", "long")
	self:StopBar(326455) -- Fiery Strike
	self:StopBar(CL.count:format(self:SpellName(329518), blazingSurgeCount)) -- Blazing Surge
	self:StopBar(CL.count:format(self:SpellName(325877), emberBlastCount)) -- Ember Blast
	self:StopBar(CL.cast:format(CL.count:format(self:SpellName(325877), emberBlastCount-1))) -- Ember Blast
	self:CancelSayCountdown(325877) -- Ember Blast

	stage = stage + 1
	shadeUp = nil
	addWaveCount = {
		[-21954] = 1, -- Rockbound Vanquishers
		[-21993] = 1, -- Bleakwing Assassin
		[-21952] = 1, -- Vile Occultists
		[-21953] = 1, -- Soul Infusers
		[-22082] = 1, -- Pestering Fiend
	}
	startTime = GetTime()
	for key,count in pairs(addWaveCount) do
		self:StartAddTimer(stage, key, count)
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
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then -- 2+
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
	function mod:ReturntoStone(args)
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
	self:StackMessage(args.spellId, args.destName, amount, "green")
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
	self:StopBar(328889) -- Greater Castigation
end

-- Mythic
function mod:CloakofFlamesApplied(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, cloakofFlamesCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, cloakofFlamesCount))
	cloakofFlamesCount = cloakofFlamesCount + 1
	self:Bar(args.spellId, 60, CL.count:format(args.spellName, cloakofFlamesCount))
end

function mod:CloakofFlamesRemoved(args)
	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	self:StopBar(CL.cast:format(CL.count:format(args.spellName, cloakofFlamesCount-1)))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
