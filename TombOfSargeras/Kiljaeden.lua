
--------------------------------------------------------------------------------
-- TODO List:
-- Rift Activating Timer

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kil'jaeden", 1147, 1898)
if not mod then return end
mod:RegisterEnableMob(117269)
mod.engageId = 2051
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local inIntermission = nil
local singularityCount = 1
local armageddonCount = 1
local focusedDreadflameCount = 1
local burstingDreadflameCount = 1
local felclawsCount = 1
local flamingOrbCount = 1
local wailingCounter = 1
local obeliskCount = 1
local focusWarned = {}
local mobCollector = {}
local stageTwoTimersHeroic = {
	-- Rupturing Singularity
	[235059] = {73.5, 26, 55, 44}, -- Incomplete
	-- Armageddon
	[240910] = {50.4, 76, 35, 31}, -- Incomplete
}
local stageTwoTimersEasy = {
	-- Rupturing Singularity
	[235059] = {73.5, 81},
	-- Armageddon
	[240910] = {50.4, 45, 31, 35, 30.8},
}
local stageOneTimersMythic = {
	-- Rupturing Singularity
	[235059] = {55, 25, 25, 28}, -- Incomplete
	-- Armageddon
	[240910] = {11.0, 54.0, 38}, -- Incomplete
}
local stageTwoTimersMythic = {
	-- Rupturing Singularity
	[235059] = {21.5, 50, 67, 78, 84},
	-- Armageddon
	[240910] = {18.4, 32, 45, 33, 36, 36, 47, 32, 45},
	-- Focused Dreadflame
	[238505] = {28.7, 44, 47, 138, 44},
	-- Bursting Dreadflame
	[238430] = {52.4, 50.0, 45.0, 48.0, 86, 50},
}
local wailingMythicTimers = {49.4, 60.0, 169.1, 60.0}

local stageTwoTimers = mod:Mythic() and stageTwoTimersMythic or mod:Easy() and stageTwoTimersEasy or stageTwoTimersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.singularityImpact = "Singularity Impact"

	L.obeliskExplosion = "Obelisk Explosion"
	L.obeliskExplosion_desc = "Timer for the Obelisk Explosion"
	L.obeliskExplosion_icon = -15543

	L.darkness = "Darkness" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Reflection: Erupting" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Reflection: Wailing" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Reflection: Hopeless" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "Rupturing Singularity Knockback"
	L.rupturingKnock_desc = "Show a timer for the knockback"
	L.rupturingKnock_icon = 235059

	L.meteorImpact = mod:SpellName(182580)
	L.meteorImpact_desc = "Show a timer for the Meteors landing"
	L.meteorImpact_icon = 240910
end

--------------------------------------------------------------------------------
-- Initialization
--

local eruptingMarker = mod:AddMarkerOption(false, "player", 3, 236710, 3, 4, 5) -- Skip marks 1 + 2 for visibility
local decieverAddMarker = mod:AddMarkerOption(false, "npc", 1, 213867, 1, 2, 3, 4, 5)
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		{239932, "TANK"}, -- Felclaws
		235059, -- Rupturing Singularity
		"rupturingKnock",
		240910, -- Armageddon
		"meteorImpact",
		{236710, "SAY", "FLASH"}, -- Shadow Reflection: Erupting
		eruptingMarker,
		{238430, "SAY", "FLASH"}, -- Bursting Dreadflame
		{238505, "SAY", "ICON", "PROXIMITY"}, -- Focused Dreadflame
		{236378, "SAY", "FLASH"}, -- Shadow Reflection: Wailing
		241564, -- Sorrowful Wail
		241721, -- Illidan's Sightless Gaze
		decieverAddMarker,
		238999, -- Darkness of a Thousand Souls
		-15543, -- Demonic Obelisk
		"obeliskExplosion",
		243982, -- Tear Rift
		244856, -- Flaming Orb
		240262, -- Burning
		{237590, "SAY", "FLASH"}, -- Shadow Reflection: Hopeless
	},{
		["stages"] = "general",
		[239932] = -14921, -- Stage One: The Betrayer
		[238430] = -15221, -- Intermission: Eternal Flame
		[236378] = -15229, -- Stage Two: Reflected Souls
		[241721] = -15394, -- Intermission: Deceiver's Veil
		[238999] = -15255, -- Stage Three: Darkness of A Thousand Souls
		[237590] = "mythic", -- Mythic
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 240262) -- Burning (Flaming Orb)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 240262)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 240262)

	-- Stage One: The Betrayer
	self:Log("SPELL_CAST_START", "Felclaws", 239932)
	self:Log("SPELL_AURA_APPLIED", "FelclawsApplied", 239932)
	self:Log("SPELL_CAST_START", "Armageddon", 240910)
	self:Log("SPELL_CAST_SUCCESS", "ArmageddonSuccess", 240910)

	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionErupting", 236710) -- Shadow Reflection: Erupting
	self:Log("SPELL_AURA_REMOVED", "ShadowReflectionEruptingRemoved", 236710) -- Shadow Reflection: Erupting
	self:Log("SPELL_AURA_REMOVED", "LingeringEruptionRemoved", 243536) -- Lingering Eruption, Mythic, Remove marks later than the normal debuff

	-- Intermission: Eternal Flame
	self:Log("SPELL_AURA_APPLIED", "NetherGale", 244834) -- Intermission Start
	self:Log("SPELL_CAST_START", "FocusedDreadflame", 238502) -- Focused Dreadflame
	self:Log("SPELL_CAST_SUCCESS", "FocusedDreadflameSuccess", 238502) -- Focused Dreadflame
	self:Log("SPELL_CAST_SUCCESS", "BurstingDreadflame", 238430) -- Bursting Dreadflame
	self:Log("SPELL_AURA_REMOVED", "NetherGaleRemoved", 244834) -- Intermission End

	-- Stage Two: Reflected Souls
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionWailing", 236378) -- Shadow Reflection: Wailing
	self:Log("SPELL_AURA_REMOVED", "ShadowReflectionWailingRemoved", 236378) -- Shadow Reflection: Wailing
	self:Log("SPELL_CAST_SUCCESS", "SorrowfulWail", 241564) -- Sorrowful Wail
	self:Death("WailingReflectionDeath", 119107) -- Wailing Add

	-- Intermission: Deceiver's Veil
	self:Log("SPELL_CAST_START", "DeceiversVeilCast", 241983) -- Deceiver's Veil Cast
	self:Log("SPELL_AURA_APPLIED", "IllidansSightlessGaze", 241721) -- Illidan's Sightless Gaze
	self:Log("SPELL_AURA_REMOVED", "DeceiversVeilRemoved", 241983) -- Deceiver's Veil Over

	-- Stage Three: Darkness of A Thousand Souls
	self:Log("SPELL_CAST_START", "DarknessofaThousandSouls", 238999) -- Darkness of a Thousand Souls
	self:Log("SPELL_CAST_START", "TearRift", 243982) -- Tear Rift
	self:Log("SPELL_CAST_SUCCESS", "DemonicObelisk", 239785) -- Demonic Obelisk

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionHopeless", 237590) -- Shadow Reflection: Hopeless
	self:Log("SPELL_AURA_REMOVED", "ShadowReflectionHopelessRemoved", 237590) -- Shadow Reflection: Hopeless
end

function mod:OnEngage()
	stage = 1
	inIntermission = nil
	singularityCount = 1
	focusedDreadflameCount = 1
	burstingDreadflameCount = 1
	armageddonCount = 1
	felclawsCount = 1
	flamingOrbCount = 1
	obeliskCount = 1
	wailingCounter = 1
	wipe(focusWarned)
	stageTwoTimers = self:Mythic() and stageTwoTimersMythic or self:Easy() and stageTwoTimersEasy or stageTwoTimersHeroic
	wipe(mobCollector)

	self:Bar(240910, 10, CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	if not self:Easy() then
		self:Bar(236710, self:Mythic() and 18.5 or 20, INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
	end
	self:Bar(239932, 25) -- Fel Claws
	self:Bar(235059, self:Mythic() and 55 or 58, CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	if self:Mythic() then
		self:Bar(236378, 55, INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing
		self:Berserk(840)
	else
		self:Berserk(600)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
-- General

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, target)
	if msg:find("238502") then -- Focused Dreadflame Target
		self:TargetMessage(238505, target, "Attention", "Alarm", nil, nil, true)
		self:TargetBar(238505, 5, target)
		self:PrimaryIcon(238505, target)
		local guid = UnitGUID(target)
		if self:Me(guid) then
			self:Say(238505)
			self:SayCountdown(238505, 5)
		end
		if not self:Easy() then
			self:OpenProximity(238505, 5)
		end
	elseif msg:find("235059") then -- Rupturing Singularity
		self:Message(235059, "Urgent", "Warning", CL.count:format(self:SpellName(235059), singularityCount))
		self:Bar("rupturingKnock", 9.85, CL.count:format(L.singularityImpact, singularityCount), 235059)
		singularityCount = singularityCount + 1
		local timer = 0
		if inIntermission then -- Intermission timer
			if self:Mythic() and stage == 3 then
				timer = singularityCount % 2 == 1 and 20 or 10
			elseif self:Easy() or singularityCount > 2 or self:Mythic() then
				return -- Only time for 2 during intermission, and only on Heroic +  -- They happen in Mythic but do not all trigger a raid warning
			else
				timer = 30
			end
		else
			if stage == 1 then -- Stage 1 cooldown
				timer = self:Mythic() and stageOneTimersMythic[235059][singularityCount] or 56
			else -- Stage 2 timers
				timer = stageTwoTimers[235059][singularityCount]
			end
		end
		self:Bar(235059, timer, CL.count:format(self:SpellName(235059), singularityCount))
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 244856 then -- Flaming Orb
		self:Message(spellId, "Attention", "Alert", CL.count:format(spellName, flamingOrbCount))
		flamingOrbCount = (flamingOrbCount % (self:Mythic() and 3 or 2)) + 1
		self:Bar(spellId, self:Mythic() and (flamingOrbCount == 2 and 15.0 or flamingOrbCount == 3 and 16.0 or 64) or flamingOrbCount == 2 and 30 or 64, CL.count:format(spellName, flamingOrbCount))
	end
end

-- Stage One: The Betrayer
function mod:Felclaws(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
end

function mod:FelclawsApplied(args)
	self:Message(args.spellId, "Important", "Info")
	felclawsCount = felclawsCount + 1
	if stage == 3 and felclawsCount % 4 == 0 then
		self:Bar(args.spellId, 20)
	else
		self:Bar(args.spellId, 24)
	end
	self:TargetBar(args.spellId, 11.5, args.destName)
end

function mod:Armageddon(args)
	self:Message(args.spellId, "Important", "Warning", CL.count:format(args.spellName, armageddonCount))
	armageddonCount = armageddonCount + 1
	local timer = 0
	if inIntermission then -- Intermission timer
		if armageddonCount == 2 then
			timer = self:Mythic() and 58.9 or 29.4
		else
			return -- Only time for 2 during intermission
		end
	else
		if stage == 1 then -- Stage 1 cooldown
			timer = self:Mythic() and stageOneTimersMythic[args.spellId][armageddonCount] or 64
		else -- Stage 2 timers
			timer = stageTwoTimers[args.spellId][armageddonCount]
		end
	end
	self:Bar(args.spellId, timer, CL.count:format(args.spellName, armageddonCount))
end

function mod:ArmageddonSuccess(args)
	self:Bar("meteorImpact", 8, CL.count:format(L.meteorImpact, armageddonCount-1), args.spellId) -- Meteor Impact
end

do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionErupting(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, L.reflectionErupting)
			self:SayCountdown(args.spellId, 8)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:Bar(args.spellId, 8, INLINE_DAMAGER_ICON.." "..CL.adds)
			if stage == 2 and not self:Mythic() then
				self:Bar(args.spellId, 112, INLINE_DAMAGER_ICON.." "..L.reflectionErupting)
			elseif self:Mythic() and stage == 1 then
				self:Bar(args.spellId, 109, INLINE_DAMAGER_ICON.." "..L.reflectionErupting)
			end
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Alert", L.reflectionErupting)
		end

		if self:GetOption(eruptingMarker) then
			SetRaidTarget(args.destName, #playerList+2)  -- Skip marks 1 + 2 for visibility
		end
	end

	function mod:ShadowReflectionEruptingRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(eruptingMarker) and not self:Mythic() then -- Don't remove icons in Mythic
			SetRaidTarget(args.destName, 0)
		end
	end

	function mod:LingeringEruptionRemoved(args) -- Mythic only, Remove icons after this debuff instead
		if self:GetOption(eruptingMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- Intermission: Eternal Flame
function mod:NetherGale(args)
	self:Message("stages", "Positive", "Long", CL.intermission, false)

	self:StopBar(CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	self:StopBar(CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	self:StopBar(INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
	self:StopBar(239932) -- Fel Claws
	self:StopBar(INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing

	inIntermission = true
	singularityCount = 1
	armageddonCount = 1
	focusedDreadflameCount = 1
	felclawsCount = 1
	wailingCounter = 1

	-- First Intermission
	self:CDBar(240910, self:Mythic() and 6.5 or 6.1, CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	self:CDBar(238430, self:Mythic() and 10.1 or 7.7) -- Bursting Dreadflame
	if not self:Easy() then -- During intermission only on Heroic +
		self:CDBar(235059, self:Mythic() and 14 or 13.3, CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	end
	self:CDBar(238505, self:Mythic() and 28.7 or 24.6) -- Focused Dreadflame
	self:CDBar("stages", self:Mythic() and 94.8 or 60.2, CL.intermission, args.spellId) -- Intermission Duration
end

function mod:FocusedDreadflame()
	focusedDreadflameCount = focusedDreadflameCount + 1
	if stage == 1 and focusedDreadflameCount == 2 then
		self:CDBar(238505, self:Mythic() and 39.3 or 13.4)
	elseif stage == 2 then
		self:Bar(238505, self:Mythic() and stageTwoTimersMythic[238505][focusedDreadflameCount] or self:Easy() and 99 or focusedDreadflameCount % 2 == 0 and 46 or 53)
	elseif stage == 3 then
		self:Bar(238505, self:Mythic() and (focusedDreadflameCount % 2 == 0 and 36 or 59) or 95)
	end
end

function mod:FocusedDreadflameSuccess()
	self:PrimaryIcon(238505)
	self:CloseProximity(238505)
end

do
	local playerList = mod:NewTargetList()
	function mod:BurstingDreadflame(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Warning")
			burstingDreadflameCount = burstingDreadflameCount + 1
			if stage == 1 and burstingDreadflameCount == 2 then -- Inside Intermission
				self:CDBar(args.spellId, self:Mythic() and 79 or 46)
			elseif stage == 2 then
				self:Bar(args.spellId, self:Mythic() and stageTwoTimersMythic[args.spellId][burstingDreadflameCount] or burstingDreadflameCount == 2 and 48 or burstingDreadflameCount == 3 and 55 or 50)
			elseif stage == 3 then
				self:Bar(args.spellId, self:Mythic() and (burstingDreadflameCount % 2 == 0 and 52 or 43) or burstingDreadflameCount % 2 == 0 and 25 or 70)
			end
		end
	end
end

function mod:NetherGaleRemoved() -- Stage 2
	inIntermission = nil
	stage = 2
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
	focusedDreadflameCount = 1
	burstingDreadflameCount = 1
	singularityCount = 1
	armageddonCount = 1
	felclawsCount = 0 -- Start at 0 to get timers correct

	self:Bar(239932, 10.4) -- Felclaws
	self:Bar(236710, self:Mythic() and 164 or 13.9, INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
	self:Bar(238505, self:Easy() and 76.4 or 30.4) -- Focused Dreadflame
	if not self:Easy() then
		self:Bar(236378, self:Mythic() and 49.4 or 48.4, INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing
	end
	self:Bar(240910, stageTwoTimers[240910][armageddonCount], CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	self:Bar(238430, 52.4) -- Bursting Dreadflame
	self:Bar(235059, stageTwoTimers[235059][singularityCount], CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	if self:Mythic() then
		self:Bar(237590, 27, INLINE_HEALER_ICON.." "..L.reflectionHopeless) -- Shadow Reflection: Hopeless
	end
end

-- Stage Two: Reflected Souls
do
	function mod:ShadowReflectionWailing(args)
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert", CL.count:format(L.reflectionWailing, wailingCounter), nil, true)
		self:Bar(args.spellId, 7, INLINE_TANK_ICON.." "..CL.add)
		wailingCounter = wailingCounter + 1
		local timer = 0
		if self:Mythic() and stage == 2 then
			timer = wailingMythicTimers[wailingCounter]
		else
			timer = 114
		end
		self:Bar(args.spellId, timer, INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Not seen 2nd add in P1
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, L.reflectionWailing)
			self:SayCountdown(args.spellId, 7)
		end
	end

	function mod:ShadowReflectionWailingRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:Bar(241564, 15.8) -- Sorrowful Wail cast
	end

	function mod:SorrowfulWail(args)
		self:Message(args.spellId, "Attention", "Alarm")
		self:Bar(args.spellId, 15.8)
	end

	function mod:WailingReflectionDeath(args)
		self:StopBar(241564) -- Sorrowful Wail
	end
end

-- Intermission: Deceiver's Veil
do
	local decieversAddMarks = {}
	function mod:DecieverAddMark(event, unit)
		local guid = UnitGUID(unit)
		if self:MobId(guid) == 121193 and not mobCollector[guid] then
			for i = 1, 5 do
				if not decieversAddMarks[i] then
					SetRaidTarget(unit, i)
					decieversAddMarks[i] = guid
					mobCollector[guid] = true
					if i == 5 then
						self:UnregisterTargetEvents()
					end
					return
				end
			end
		end
	end

	function mod:DeceiversVeilCast() -- Stage 3
		stage = 3
		inIntermission = true
		self:Message("stages", "Positive", "Long", CL.intermission, false)
		self:StopBar(CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
		self:StopBar(INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
		self:StopBar(INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing
		self:StopBar(239932) -- Fel Claws
		self:StopBar(238430) -- Bursting Dreadflame
		self:StopBar(238505) -- Focused Dreadflame
		self:StopBar(CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
		self:StopBar(INLINE_HEALER_ICON.." "..L.reflectionHopeless) -- Shadow Reflection: Hopeless

		singularityCount = 1
		self:Bar(235059, 19.1, CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity

		if self:GetOption(decieverAddMarker) then
			wipe(decieversAddMarks)
			self:RegisterTargetEvents("DecieverAddMark")
		end
	end

	function mod:DeceiversVeilRemoved()
		if self:GetOption(decieverAddMarker) then
			self:UnregisterTargetEvents()
		end
		inIntermission = nil
		focusedDreadflameCount = 1
		burstingDreadflameCount = 1
		flamingOrbCount = 1
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:Bar(238999, 2, L.darkness) -- Darkness of a Thousand Souls
		self:Bar(239932, 11) -- Felclaws
		self:Bar(243982, 15) -- Tear Rift
		if not self:Easy() then
			self:Bar(244856, self:Mythic() and 40 or 30, CL.count:format(self:SpellName(244856), flamingOrbCount)) -- Flaming Orb
		end
		self:Bar(238430, self:Mythic() and 30 or 42) -- Bursting Dreadflame
		self:Bar(238505, self:Mythic() and 48 or 80) -- Focused Dreadflame
	end
end

function mod:IllidansSightlessGaze(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Long")
	end
end

-- Stage Three: Darkness of A Thousand Souls
function mod:DarknessofaThousandSouls(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, obeliskCount == 1 and 90 or 95, L.darkness)
	self:CastBar(args.spellId, 9, L.darkness)
	self:StartObeliskTimer(obeliskCount == 1 and 25 or 28)
end

do
	local prev = 0
	function mod:DemonicObelisk(args)
		local t = GetTime()
		if t-prev > 1.5 then
			self:CastBar("obeliskExplosion", 5, L.obeliskExplosion, -15543)
		end
	end
end

function mod:StartObeliskTimer(t)
	self:Bar(-15543, t)
	self:ScheduleTimer("Message", t, -15543, "Attention", "Info", CL.spawned:format(self:SpellName(-15543)))
	self:ScheduleTimer("CastBar", t, "obeliskExplosion", 13, L.obeliskExplosion, -15543) -- will get readjusted in :DemonicObelisk()
	obeliskCount = obeliskCount + 1
	if obeliskCount % 2 == 0 then
		self:ScheduleTimer("StartObeliskTimer", t, 36)
	end
end

function mod:TearRift(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, obeliskCount == 1 and 90 or 95)
end

-- Mythic
do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionHopeless(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, L.reflectionHopeless)
			self:SayCountdown(args.spellId, 8)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:Bar(args.spellId, 196.0, INLINE_HEALER_ICON.." "..L.reflectionHopeless)
			self:Bar(args.spellId, 8, INLINE_HEALER_ICON.." "..CL.adds)
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Alert", L.reflectionHopeless)
		end
	end
	function mod:ShadowReflectionHopelessRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end
