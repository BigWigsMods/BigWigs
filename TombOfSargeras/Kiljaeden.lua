
--------------------------------------------------------------------------------
-- TODO List:
-- Change Bursting Dreadflame to SPELL_CAST_SUCCESS warnings instead of RAID_BOSS_WHISPER

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kil'jaeden", 1147, 1898)
if not mod then return end
mod:RegisterEnableMob(117269)
mod.engageId = 2051
mod.respawnTime = 30 -- XXX Unconfirmed

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local intermissionPhase = nil
local singularityCount = 1
local ArmageddonCount = 1
local focusedDreadflameCount = 1
local felclawsCount = 1
local flamingOrbCount = 1
local focusWarned = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{239932, "TANK"}, -- Felclaws
		235059, -- Rupturing Singularity
		240910, -- Armageddon
		{236710, "SAY", "FLASH"}, -- Shadow Reflection: Erupting
		{238429, "SAY", "FLASH"}, -- Bursting Dreadflame
		{238502, "SAY"}, -- Focused Dreadflame
		{236378, "SAY", "FLASH"}, -- Shadow Reflection: Wailing
		236555, -- Deceiver's Veil
		241721, -- Illidan's Sightless Gaze
		238999, -- Darkness of a Thousand Souls
		239785, -- Demonic Obelisk
		243982, -- Tear Rift
		244856, -- Flaming Orb
		{237590, "SAY", "FLASH"}, -- Shadow Reflection: Hopeless
	},{
		["stages"] = "general",
		[239932] = -14921, -- Stage One: The Betrayer
		[238429] = -15221, -- Intermission: Eternal Flame
		[236378] = -15229, -- Stage Two: Reflected Souls
		[236555] = -15394, -- Intermission: Deceiver's Veil
		[238999] = -15255, -- Stage Three: Darkness of A Thousand Souls
		[237590] = "mythic", -- Mythic
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- Stage One: The Betrayer
	self:Log("SPELL_CAST_START", "Felclaws", 239932)
	self:Log("SPELL_AURA_APPLIED", "FelclawsApplied", 239932)
	self:Log("SPELL_CAST_START", "Armageddon", 240910)

	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionErupting", 236710) -- Shadow Reflection: Erupting

	-- Intermission: Eternal Flame
	self:Log("SPELL_AURA_APPLIED", "NetherGale", 244834) -- Intermission Start
	self:Log("SPELL_CAST_START", "FocusedDreadflame", 238502) -- Focused Dreadflame
	self:Log("SPELL_CAST_SUCCESS", "BurstingDreadflame", 238429) -- Bursting Dreadflame
	self:Log("SPELL_AURA_REMOVED", "NetherGaleRemoved", 244834) -- Intermission End

	-- Stage Two: Reflected Souls
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionWailing", 239932) -- Shadow Reflection: Wailing

	-- Intermission: Deceiver's Veil
	self:Log("SPELL_CAST_START", "DeceiversVeilCast", 241983) -- Deceiver's Veil Cast
	self:Log("SPELL_AURA_APPLIED", "IllidansSightlessGaze", 241721) -- Illidan's Sightless Gaze
	self:Log("SPELL_AURA_REMOVED", "DeceiversVeilRemoved", 241983) -- Deceiver's Veil Over

	-- Stage Three: Darkness of A Thousand Souls
	self:Log("SPELL_CAST_START", "DarknessofaThousandSouls", 238999) -- Darkness of a Thousand Souls
	self:Log("SPELL_CAST_START", "TearRift", 243982) -- Tear Rift

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionHopeless", 236710) -- Shadow Reflection: Hopeless
end

function mod:OnEngage()
	phase = 1
	intermissionPhase = nil
	singularityCount = 1
	focusedDreadflameCount = 1
	ArmageddonCount = 1
	felclawsCount = 1
	flamingOrbCount = 1
	wipe(focusWarned)

	self:Bar(240910, 10) -- Armageddon
	self:Bar(236710, 20) -- Shadow Reflection: Erupting
	self:Bar(239932, 25) -- Fel Claws
	self:Bar(235059, 58) -- Rupturing Singularity
end

--------------------------------------------------------------------------------
-- Event Handlers
--
-- General
function mod:RAID_BOSS_WHISPER(_, msg)
	if msg:find("238430") then -- Bursting Dreadflame
		self:Message(238430, "Personal", "Alarm", CL.you:format(self:SpellName(238430)))
		self:Flash(238430)
		self:Say(238430)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, sender, _, _, target)
	if msg:find("238502") then -- Focused Dreadflame Target
		self:TargetMessage(238505, target, "Attention", "Warning")
		self:TargetBar(238505, 5, target)
	elseif msg:find("235059") then -- Rupturing Singularity
		singularityCount = singularityCount + 1
		self:Message(235059, "Personal", "Alarm", CL.you:format(self:SpellName(235059)))
		if intermissionPhase and singularityCount == 2 then
			self:Bar(235059, 30)
		else
			self:Bar(235059, 56)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 244856 then -- Flaming Orb
		self:Message(spellId, "Attention", "Alert")
		flamingOrbCount = flamingOrbCount + 1
		self:Bar(spellId, flamingOrbCount % 2 == 0 and 30 or 64)
	end
end

-- Stage One: The Betrayer
function mod:Felclaws(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
end

function mod:FelclawsApplied(args)
	self:Message(args.spellId, "Important", "Info")
	felclawsCount = felclawsCount + 1
	if phase == 3 and felclawsCount % 4 == 0 then
		self:Bar(args.spellId, 20)
	else
		self:Bar(args.spellId, 24)
	end
	self:TargetBar(args.spellId, 11, args.destName)
end

function mod:Armageddon(args)
	self:Message(args.spellId, "Important", "Warning")
	ArmageddonCount = ArmageddonCount + 1
	if intermissionPhase and ArmageddonCount == 2 then
		self:Bar(args.spellId, 29.4)
	else
		self:Bar(args.spellId, phase == 1 and 54)
	end
	self:Bar(args.spellId, 9, self:SpellName(182580), args.spellId) -- Meteor Impact
end

do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionErupting(args)
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			if phase == 2 then
				self:Bar(args.spellId, 112)
			end
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alert")
		end
	end
end

-- Intermission: Eternal Flame
function mod:NetherGale(args)
	intermissionPhase = true
	singularityCount = 1
	ArmageddonCount = 1
	focusedDreadflameCount = 1
	felclawsCount = 1

	self:StopBar(240910) -- Armageddon
	self:StopBar(236710) -- Shadow Reflection: Erupting
	self:StopBar(239932) -- Fel Claws

	-- First Intermission
	self:Bar(240910, 6.1) -- Armageddon
	self:Bar(238429, 7.7) -- Bursting Dreadflame
	self:Bar(235059, 13.3) -- Rupturing Singularity
	self:Bar(238502, 23.5) -- Focused Dreadflame

end

function mod:FocusedDreadflame(args)
	focusedDreadflameCount = focusedDreadflameCount + 1
	if phase == 1 and focusedDreadflameCount == 2 then
		self:Bar(238505, 13.4)
	elseif phase == 2 then
		self:Bar(238505, focusedDreadflameCount % 2 == 0 and 46 or 53)
	elseif phase == 3 then
		--self:Bar(238505, 95)
	end
end

function mod:BurstingDreadflame(args)
	self:Message(args.spellId, "Important", "Warning")
	burstingDreadflameCount = burstingDreadflameCount + 1
	if phase == 1 and burstingDreadflameCount == 2 then
		self:Bar(238505, 45)
	elseif phase == 2 then
		self:Bar(238505, 46)
	elseif phase == 3 then
		self:Bar(238505, burstingDreadflameCount % 2 == 0 and 25 or 70)
	end
end

function mod:NetherGaleRemoved(args)
	intermissionPhase = nil
	phase = 2
	self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
	focusedDreadflameCount = 1
	singularityCount = 1
	felclawsCount = 0 -- Start at 0 to get timers correct

	self:Bar(239932, 10.4) -- Felclaws
	self:Bar(236710, 12.4) -- Shadow Reflection: Erupting
	self:Bar(236378, 48.4) -- Shadow Reflection: Wailing
	self:Bar(240910, 50.4) -- Armageddon
	self:Bar(235059, 73.5) -- Rupturing Singularity
end

-- Stage Two: Reflected Souls
do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionWailing(args)
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:Bar(args.spellId, 114.2)
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alert")
		end
	end
end

-- Intermission: Deceiver's Veil
function mod:DeceiversVeilCast(args)
	self:Message(args.spellId, "Positive", "Long")
	self:StopBar(240910) -- Armageddon
	self:StopBar(236710) -- Shadow Reflection: Erupting
	self:StopBar(236378) -- Shadow Reflection: Wailing
	self:StopBar(239932) -- Fel Claws
	self:StopBar(238429) -- Bursting Dreadflame
	self:StopBar(238502) -- Focused Dreadflame
	self:StopBar(235059) -- Rupturing Singularity
end

function mod:DeceiversVeilRemoved(args)
	phase = 3
	self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
	self:Bar(238999, 2) -- Darkness of a Thousand Souls
	self:Bar(239932, 11) -- Felclaws
	self:Bar(243982, 15) -- Tear Rift
	self:Bar(244856, 30) -- Flaming Orb
	self:Bar(238429, 42) -- Bursting Dreadflame
	self:Bar(238502, 80) -- Focused Dreadflame
end


function mod:IllidansSightlessGaze(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Long")
	end
end

-- Stage Three: Darkness of A Thousand Souls
function mod:DarknessofaThousandSouls(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 90)
	self:CastBar(args.spellId, 9)
end

function mod:TearRift(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 95)
end

-- Mythic
do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionHopeless(args)
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alert")
		end
	end
end
