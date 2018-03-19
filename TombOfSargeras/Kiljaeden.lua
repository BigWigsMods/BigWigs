
-- GLOBALS: INLINE_TANK_ICON, INLINE_HEALER_ICON, INLINE_DAMAGER_ICON

--------------------------------------------------------------------------------
-- TODO List:
-- Rift Activating Timer

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kil'jaeden", 1676, 1898)
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
local darknessCount = 1
local currentZoom = 0
local focusedTarget = nil
local resetMinimap = nil
local timerMinimap = nil
local mobCollector = {}
local timersLFR = {
	[240910] = { -- Armageddon
		{10, 22, 42, 22, 30}, -- Stage 1
		{56, 27.7, 56.7, 26.7, 12.2, 18.9, 18.9}, -- Stage 2
	},
	[238430] = { -- Bursting Dreadflame
		{7.7, 17, 13.4, 17}, -- Stage 1 (Intermission)
		{58.2, 53.3, 61.1, 56.7}, -- Stage 2
		{42, 25, 70}, -- Stage 3, 25/70 Repeating
	},
}
local timersNormal = {
	[240910] = { -- Armageddon
		{10, 64}, -- Stage 1
		{50.4, 45, 31, 35, 31, 78}, -- Stage 2
	},
	[235059] = { -- Rupturing Singularity
		{58, 56}, -- Stage 1
		{73.5, 81}, -- Stage 2
	},
	[238430] = { -- Bursting Dreadflame
		{7.7, 46}, -- Stage 1 (Intermission)
		{52.4, 48, 55, 50}, -- Stage 2
		{42, 25, 70}, -- Stage 3, 25/70 Repeating
	},
	[238505] = { -- Focused Dreadflame
		{24.6, 13.4}, -- Stage 1 (Intermission)
		{76.4, 99}, -- Stage 2
		{80, 95, 95}, -- Stage 3, 95 Repeating
	},
}
local timersHeroic = {
	[240910] = { -- Armageddon
		{10, 64}, -- Stage 1
		{50.4, 76, 35, 31}, -- Stage 2
	},
	[235059] = { -- Rupturing Singularity
		{58, 56}, -- Stage 1
		{73.5, 26, 55, 44}, -- Stage 2
	},
	[238430] = { -- Bursting Dreadflame
		{7.7, 46}, -- Stage 1 (Intermission)
		{52.4, 48, 55, 50}, -- Stage 2
		{42, 25, 70}, -- Stage 3, 25/70 Repeating
	},
	[238505] = { -- Focused Dreadflame
		{24.6, 13.4}, -- Stage 1 (Intermission)
		{30.4, 46, 53, 46}, -- Stage 2
		{80, 95, 95}, -- Stage 3, 95 Repeating
	},
}
local timersMythic = {
	[240910] = { -- Armageddon
		{11, 54.0, 38}, -- Stage 1
		{18.4, 32, 45, 33, 36, 36, 47, 32, 45}, -- Stage 2
	},
	[235059] = { -- Rupturing Singularity
		{55, 25, 25, 28}, -- Stage 1
		{21.5, 50, 67, 78, 84}, -- Stage 2
	},
	[238430] = { -- Bursting Dreadflame
		{10.1, 79}, -- Stage 1 (Intermission)
		{52.4, 50.0, 45.0, 48.0, 86, 50}, -- Stage 2
		{30, 52, 43} -- Stage 3, 52/43 Repeating
	},
	[238505] = { -- Focused Dreadflame
		{28.7, 38.9}, -- Stage 1 (Intermission)
		{30.4, 44, 47, 138, 44}, -- Stage 2
		{48, 36, 59}, -- Stage 3, 36/59 Repeating
	},
}
local wailingMythicTimers = {49.4, 60.0, 169.1, 60.0}
local timers = mod:Mythic() and timersMythic or mod:Heroic() and timersHeroic or mod:Normal() and timersNormal or mod:LFR() and timersLFR

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

	L.countx = "%s (%dx)"

	L.shadowsoul = "Shadowsoul Health Tracker"
	L.shadowsoul_desc = "Show the info box displaying the current health of the 5 Shadowsoul adds."
	L.shadowsoul_icon = 241702

	L.custom_on_track_illidan = "Automatically Track Humanoids"
	L.custom_on_track_illidan_desc = "If you are a hunter or a feral druid, this option will automatically enable tracking of humanoids so you can track Illidan."
	L.custom_on_track_illidan_icon = 19883

	L.custom_on_zoom_in = "Automatically Zoom Minimap"
	L.custom_on_zoom_in_desc = "This feature will set the minimap zoom to level 4 to make it easier to track Illidan, and then restore it to your previous level once the stage has ended."
	L.custom_on_zoom_in_icon = 131220
end

--------------------------------------------------------------------------------
-- Initialization
--

local eruptingMarker = mod:AddMarkerOption(false, "player", 3, 236710, 3, 4, 5) -- Skip marks 1 + 2 for visibility
local shadowsoulMarker = mod:AddMarkerOption(false, "npc", 1, -15397, 1, 2, 3, 4, 5) -- Shadowsoul
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
		{"shadowsoul", "INFOBOX"}, -- Shadowsoul
		shadowsoulMarker,
		"custom_on_track_illidan",
		"custom_on_zoom_in",
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
	self:Log("SPELL_AURA_REFRESH", "IllidansSightlessGaze", 241721) -- Illidan's Sightless Gaze
	self:Log("SPELL_AURA_REMOVED", "IllidansSightlessGazeRemoved", 241721) -- Illidan's Sightless Gaze
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
	darknessCount = 1
	currentZoom = 0
	focusedTarget = nil
	timerMinimap = nil
	timers = self:Mythic() and timersMythic or self:Heroic() and timersHeroic or self:Normal() and timersNormal or self:LFR() and timersLFR
	wipe(mobCollector)

	self:Bar(240910, timers[240910][stage][armageddonCount], CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	if not self:Easy() then
		self:Bar(236710, self:Mythic() and 18.5 or 20, INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
	end
	self:Bar(239932, 25) -- Felclaws
	if not self:LFR() then
		self:Bar(235059, timers[235059][stage][singularityCount], CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	end
	if self:Mythic() then
		self:Bar(236378, 55, INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing
		self:Berserk(840)
	else
		self:Berserk(600)
	end
end

function mod:OnWipe()
	if inIntermission and stage == 2 then
		resetMinimap(self)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
-- General

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, target)
	if msg:find("238502", nil, true) then -- Focused Dreadflame Target
		self:TargetMessage(238505, target, "Attention", "Alarm", nil, nil, true)
		self:TargetBar(238505, 5, target)
		self:PrimaryIcon(238505, target)
		local guid = UnitGUID(target)
		focusedTarget = guid
		if self:Me(guid) then
			self:Say(238505)
			self:SayCountdown(238505, 5)
		end
		if not self:Easy() then
			self:OpenProximity(238505, 5)
		end
		-- Schedule fake success in case the target uses invis, etc
		self:ScheduleTimer("FocusedDreadflameSuccess", 5.5)
	elseif msg:find("235059", nil, true) then -- Rupturing Singularity
		self:Message(235059, "Urgent", "Warning", CL.count:format(self:SpellName(235059), singularityCount))
		self:Bar("rupturingKnock", 9.85, CL.count:format(L.singularityImpact, singularityCount), 235059)
		singularityCount = singularityCount + 1
		local timer = 0
		if inIntermission then -- Intermission timer
			if self:Mythic() and stage == 2 then
				timer = singularityCount % 2 == 1 and 20 or 10
			elseif self:Easy() or singularityCount > 2 or self:Mythic() then
				return -- Only time for 2 during intermission, and only on Heroic +  -- They happen in Mythic but do not all trigger a raid warning
			else
				timer = 30
			end
		else
			timer = timers[235059][stage][singularityCount]
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
	if self:Mythic() and stage == 3 then
		self:Bar(args.spellId, felclawsCount % 4 == 0 and 29 or felclawsCount % 4 == 1 and 16 or 24)
	elseif self:LFR() then
		self:Bar(args.spellId, stage == 2 and 27.7 or 25)
	elseif stage == 3 and felclawsCount % 4 == 1 then
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
		timer = timers[args.spellId][stage][armageddonCount]
	end
	self:Bar(args.spellId, timer, CL.count:format(args.spellName, armageddonCount))
end

function mod:ArmageddonSuccess(args)
	self:Bar("meteorImpact", 8, CL.count:format(L.meteorImpact, armageddonCount-1), args.spellId) -- Meteor Impact
end

do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionErupting(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, self:Easy() and L.reflectionErupting or CL.count_rticon:format(L.reflectionErupting, #playerList, #playerList+2))
			self:SayCountdown(args.spellId, 8)
		end
		if #playerList == 1 then
			self:Bar(args.spellId, 8, INLINE_DAMAGER_ICON.." "..CL.adds)
			if stage == 2 and not self:Mythic() then
				self:Bar(args.spellId, self:LFR() and 124.4 or 112, INLINE_DAMAGER_ICON.." "..L.reflectionErupting)
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
	self:StopBar(239932) -- Felclaws
	self:StopBar(INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing

	inIntermission = true
	singularityCount = 1
	armageddonCount = 1
	focusedDreadflameCount = 1
	felclawsCount = 1
	wailingCounter = 1

	-- First Intermission
	self:CDBar(240910, self:Mythic() and 6.5 or 6.1, CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	self:CDBar(238430, timers[238430][stage][burstingDreadflameCount]) -- Bursting Dreadflame
	if not self:Easy() then -- During intermission only on Heroic +
		self:CDBar(235059, self:Mythic() and 14 or 13.3, CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	end
	if not self:LFR() then
		self:CDBar(238505, timers[238505][stage][focusedDreadflameCount]) -- Focused Dreadflame
	end
	self:CDBar("stages", self:Mythic() and 94.8 or 60.2, CL.intermission, args.spellId) -- Intermission Duration
end

function mod:FocusedDreadflame()
	focusedDreadflameCount = focusedDreadflameCount + 1
	self:Bar(238505, timers[238505][stage][stage == 3 and (focusedDreadflameCount % 2 == 0 and 2 or 3) or focusedDreadflameCount])
end

function mod:FocusedDreadflameSuccess()
	if focusedTarget then
		focusedTarget = nil
		self:PrimaryIcon(238505)
		self:CloseProximity(238505)
	end
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
			self:Bar(args.spellId, timers[args.spellId][stage][stage == 3 and (burstingDreadflameCount % 2 == 0 and 2 or 3) or burstingDreadflameCount])
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
	felclawsCount = 1

	self:Bar(239932, 10.4) -- Felclaws
	self:Bar(236710, self:Mythic() and 164 or 13.9, INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
	if not self:Easy() then
		self:Bar(236378, self:Mythic() and 49.4 or 48.4, INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing
	end
	self:Bar(240910, timers[240910][stage][armageddonCount], CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
	self:Bar(238430, timers[238430][stage][burstingDreadflameCount]) -- Bursting Dreadflame
	if not self:LFR() then
		self:Bar(238505, timers[238505][stage][focusedDreadflameCount]) -- Focused Dreadflame
		self:Bar(235059, timers[235059][stage][singularityCount], CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
	end
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
		local timer = 114
		if self:Mythic() and stage == 2 then
			timer = wailingMythicTimers[wailingCounter]
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

	function mod:WailingReflectionDeath()
		self:StopBar(241564) -- Sorrowful Wail
	end
end

-- Intermission: Deceiver's Veil
do
	local decieversAddMarks = {} -- Marks we set
	local addMaxHP = -1
	local addDmg = {} -- Damage done per add
	local addMarks = {} -- Current marks on each add

	function mod:ShadowsoulScanner(event, unit)
		local guid = UnitGUID(unit)
		if self:MobId(guid) == 121193 and not mobCollector[guid] then
			for i = 1, 5 do
				if not decieversAddMarks[i] then
					if self:GetOption(shadowsoulMarker) then
						SetRaidTarget(unit, i)
					end
					decieversAddMarks[i] = guid
					mobCollector[guid] = true
					if i == 5 then
						self:UnregisterTargetEvents()
					end
					break
				end
			end
			local maxHp = UnitHealthMax(unit)
			if addMaxHP == -1 then
				addMaxHP = maxHp
			end
			addDmg[guid] = maxHp - UnitHealth(unit)
			local icon = GetRaidTargetIndex(unit)
			if icon and icon > 0 and icon < 9 then
				addMarks[guid] = icon
			end
		end
	end

	local marks = {
		[0x00000001] = 1, -- COMBATLOG_OBJECT_RAIDTARGET1
		[0x00000002] = 2, -- COMBATLOG_OBJECT_RAIDTARGET2
		[0x00000004] = 3, -- COMBATLOG_OBJECT_RAIDTARGET3
		[0x00000008] = 4, -- COMBATLOG_OBJECT_RAIDTARGET4
		[0x00000010] = 5, -- COMBATLOG_OBJECT_RAIDTARGET5
		[0x00000020] = 6, -- COMBATLOG_OBJECT_RAIDTARGET6
		[0x00000040] = 7, -- COMBATLOG_OBJECT_RAIDTARGET7
		[0x00000080] = 8, -- COMBATLOG_OBJECT_RAIDTARGET8
	}
	local timer = nil
	local function updateInfoBox(self)
		if addMaxHP < 0 then return end -- no max hp yet
		local i = 1
		for guid, dmg in pairs(addDmg) do
			if i > 5 then break end -- safety
			local percentage = (addMaxHP - dmg) / addMaxHP
			if percentage > 0 then
				if addMarks[guid] then
					self:SetInfo("shadowsoul", i*2-1, ("%s |T13700%d:0|t"):format(CL.count:format(CL.add, i), addMarks[guid]))
				else
					self:SetInfo("shadowsoul", i*2-1, CL.count:format(CL.add, i))
				end
				self:SetInfo("shadowsoul", i*2, ("%.0f%%"):format(percentage*100))
			else
				self:SetInfo("shadowsoul", i*2-1, "")
				self:SetInfo("shadowsoul", i*2, "")
			end
			self:SetInfoBar("shadowsoul", i*2, percentage)
			i = i + 1
		end
	end

	local function damageToMob(guid, dmg, overkill, raidFlags)
		addMarks[guid] = marks[raidFlags]
		if overkill > 0 then
			addDmg[guid] = addMaxHP
		else
			addDmg[guid] = (addDmg[guid] or 0) + dmg
		end
	end

	function mod:IntermissionAddDamage(args)
		if addDmg[args.destGUID] then
			-- :Log isn't designed for _DAMAGE events, so we'll have to switch some things around:
			-- - extraSpellId is the amount of damage inflicted
			-- - extraSpellName is the amount of overkill
			damageToMob(args.destGUID, args.extraSpellId, args.extraSpellName, args.destRaidFlags)
		end
	end

	function mod:IntermissionAddDamageSwing(args)
		if addDmg[args.destGUID] then
			-- :Log isn't designed for _DAMAGE events, so we'll have to switch some things around:
			-- - spellId is the amount of damage inflicted
			-- - spellName is the amount of overkill
			damageToMob(args.destGUID, args.spellId, args.spellName, args.destRaidFlags)
		end
	end

	local function loopTracking(self, n)
		local _, _, active = GetTrackingInfo(n)
		if not active then
			SetTracking(n, true)
		else
			self:CancelTimer(timerMinimap)
			timerMinimap = nil
		end
	end

	function mod:DeceiversVeilCast() -- Intermission 2
		inIntermission = true
		self:Message("stages", "Positive", "Long", CL.intermission, false)
		self:StopBar(CL.count:format(self:SpellName(240910), armageddonCount)) -- Armageddon
		self:StopBar(INLINE_DAMAGER_ICON.." "..L.reflectionErupting) -- Shadow Reflection: Erupting
		self:StopBar(INLINE_TANK_ICON.." "..CL.count:format(L.reflectionWailing, wailingCounter)) -- Shadow Reflection: Wailing
		self:StopBar(239932) -- Felclaws
		self:StopBar(238430) -- Bursting Dreadflame
		self:StopBar(238505) -- Focused Dreadflame
		self:StopBar(CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
		self:StopBar(INLINE_HEALER_ICON.." "..L.reflectionHopeless) -- Shadow Reflection: Hopeless

		singularityCount = 1
		if self:Mythic() then
			self:Bar(235059, 19.1, CL.count:format(self:SpellName(235059), singularityCount)) -- Rupturing Singularity
		end

		local shadowsoulOption = self:CheckOption("shadowsoul", "INFOBOX")
		if self:GetOption(shadowsoulMarker) or shadowsoulOption then
			wipe(decieversAddMarks)

			if shadowsoulOption then
				wipe(addDmg)
				wipe(addMarks)
				addMaxHP = -1
				self:Log("SPELL_DAMAGE", "IntermissionAddDamage", "*")
				self:Log("SPELL_PERIODIC_DAMAGE", "IntermissionAddDamage", "*")
				self:Log("RANGE_DAMAGE", "IntermissionAddDamage", "*")
				self:Log("SWING_DAMAGE", "IntermissionAddDamageSwing", "*")
				self:OpenInfo("shadowsoul", self:SpellName(-15397)) -- Shadowsoul
				for i = 1, 5 do
					self:SetInfo("shadowsoul", i*2-1, CL.count:format(CL.add, i))
					self:SetInfo("shadowsoul", i*2, "100%")
				end
				timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self)
			end

			self:RegisterTargetEvents("ShadowsoulScanner")
		end

		if self:GetOption("custom_on_track_illidan") then
			local trackHumanoids = self:SpellName(19883)
			for i = 1, GetNumTrackingTypes() do
				local name = GetTrackingInfo(i)
				if name == trackHumanoids then
					timerMinimap = self:ScheduleRepeatingTimer(loopTracking, 0.1, self, i)
					break
				end
			end
		end

		if self:GetOption("custom_on_zoom_in") then
			currentZoom = Minimap:GetZoom() or 0
			Minimap:SetZoom(4)
		end
	end

	function resetMinimap(self)
		if timerMinimap then
			self:CancelTimer(timerMinimap)
			timerMinimap = nil
		end
		if self:GetOption("custom_on_track_illidan") then
			local trackHumanoids = self:SpellName(19883)
			for i = 1, GetNumTrackingTypes() do
				local name = GetTrackingInfo(i)
				if name == trackHumanoids then
					SetTracking(i, false)
					break
				end
			end
		end
		if self:GetOption("custom_on_zoom_in") then
			Minimap:SetZoom(currentZoom)
		end
	end

	function mod:DeceiversVeilRemoved() -- Stage 3
		stage = 3
		inIntermission = nil
		darknessCount = 1
		focusedDreadflameCount = 1
		burstingDreadflameCount = 1
		flamingOrbCount = 1
		felclawsCount = 1
		resetMinimap(self)

		local shadowsoulOption = self:CheckOption("shadowsoul", "INFOBOX")
		if self:GetOption(shadowsoulMarker) or shadowsoulOption then
			self:UnregisterTargetEvents()

			if shadowsoulOption then
				self:CloseInfo("shadowsoul")
				self:RemoveLog("SPELL_DAMAGE", "*")
				self:RemoveLog("SPELL_PERIODIC_DAMAGE", "*")
				self:RemoveLog("RANGE_DAMAGE", "*")
				self:RemoveLog("SWING_DAMAGE", "*")
				if timer then
					self:CancelTimer(timer)
					timer = nil
				end
			end
		end

		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:Bar(238999, 2, CL.count:format(L.darkness, darknessCount)) -- Darkness of a Thousand Souls
		self:Bar(239932, 11) -- Felclaws
		self:Bar(243982, 15) -- Tear Rift
		if not self:Easy() then
			self:Bar(244856, self:Mythic() and 40 or 30, CL.count:format(self:SpellName(244856), flamingOrbCount)) -- Flaming Orb
		end
		self:Bar(238430, timers[238430][stage][burstingDreadflameCount]) -- Bursting Dreadflame
		if not self:LFR() then
			self:Bar(238505, timers[238505][stage][focusedDreadflameCount]) -- Focused Dreadflame
		end
	end
end

do
	local prev = 0
	function mod:IllidansSightlessGaze(args)
		local t = GetTime()
		if self:Me(args.destGUID) then
			if t-prev > 1.5 then
				prev = t
				self:Message(args.spellId, "Personal", "Long", CL.you:format(args.spellName))
			end
			self:Bar(args.spellId, 20)
		end
	end
end

function mod:IllidansSightlessGazeRemoved(args)
	if stage == 2 and self:Me(args.destGUID) then -- Don't warn in p3
		self:Message(args.spellId, "Personal", "Alert", CL.removed:format(args.spellName))
	end
end

-- Stage Three: Darkness of A Thousand Souls
function mod:DarknessofaThousandSouls(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(CL.count:format(args.spellName, darknessCount)))
	self:CastBar(args.spellId, 9, CL.count:format(L.darkness, darknessCount))
	darknessCount = darknessCount + 1
	self:Bar(args.spellId, darknessCount == 2 and 90 or 95, CL.count:format(L.darkness, darknessCount))
	self:StartObeliskTimer(darknessCount == 2 and 25 or 28)
end

do
	local prev = 0
	function mod:DemonicObelisk()
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:CastBar("obeliskExplosion", 5, L.obeliskExplosion, -15543)
		end
	end
end

function mod:StartObeliskTimer(t)
	local obeliskCounter = self:Mythic() and (obeliskCount+2) or self:Heroic() and (darknessCount+1) or darknessCount -- Mythic: 3-4-5-6-7... Heroic: 3-3-4-4-5... Normal: 2-2-3-3-4...
	self:Bar(-15543, t, L.countx:format(self:SpellName(-15543), obeliskCounter))
	self:ScheduleTimer("Message", t, -15543, "Attention", "Info", CL.spawned:format(L.countx:format(self:SpellName(-15543), obeliskCounter)))
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
