
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vorasius", 2912, 2734)
if not mod then return end
mod:RegisterEnableMob(240434) -- Vorasius
mod:SetEncounterID(3177)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	-- {1243016, sound = "alarm"}, -- Blisterburst (15s debuff) still used?
	1259186, -- Blisterburst
	{1272527, sound = "none"}, -- Creep Spit
	{1243220, 1243270, sound = "underyou"}, -- Dark Goo
	1241844, -- Smashed
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local timelineEventCount = 0

local breathCount = 1
local parasiteCount = 1
local frenzyCount = 1
local roarCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.shadowclaw_slam = "Slams"
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1256855, -- Void Breath
		1254199, -- Parasite Expulsion
		1241692, -- Shadowclaw Slam
		1260052, -- Primordial Roar
	},
	{},
	{
		[1256855] = CL.breath, -- Void Breath (Breath)
		[1254199] = CL.adds, -- Parasite Expulsion (Adds)
		[1241692] = L.shadowclaw_slam, -- Shadowclaw Slam (Slams)
		[1260052] = CL.roar, -- Primordial Roar (Roar)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	timelineEventCount = 0

	breathCount = 1
	parasiteCount = 1
	frenzyCount = 1
	roarCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

do
	local lastSharedCD = 0
	function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
		local duration = eventInfo.duration
		local barInfo
		timelineEventCount = timelineEventCount + 1
		if timelineEventCount <= 5 then -- Pull Events
			lastSharedCD = 0
			if duration == 6 then -- Primordial Roar
				barInfo = self:PrimordialRoar(eventInfo)
			elseif duration == 16 or duration == 136 then -- Smashing Frenzy
				barInfo = self:SmashingFrenzy(eventInfo)
			elseif duration == 57 then -- Parasite Expulsion
				barInfo = self:ParasiteExpulsion(eventInfo)
			elseif duration == 95 then -- Void Breath
				barInfo = self:VoidBreath(eventInfo)
			end
		else
			if duration == 240 then -- Smashing Frenzy
				barInfo = self:SmashingFrenzy(eventInfo)
			elseif duration == 120 and lastSharedCD == 0 then -- Roar (alternates)
				barInfo = self:PrimordialRoar(eventInfo)
				lastSharedCD = 1
			elseif duration == 120 and lastSharedCD == 1 then -- Breath (alternates)
				barInfo = self:VoidBreath(eventInfo)
				lastSharedCD = 0
			elseif duration == 122.5 then -- Parasite Expulsion
				barInfo = self:ParasiteExpulsion(eventInfo)
			end
		end
		if barInfo then
			activeBars[eventInfo.id] = barInfo
		elseif self:ShouldShowBars() and not self:IsWiping() then
			self:ErrorForTimelineEvent(eventInfo)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		self:StopBar(barInfo.msg)

		if state == 2 and self:ShouldShowBars() and barInfo.callback then -- Finished
			barInfo.callback()
		end

		activeBars[eventID] = nil
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		self:StopBar(barInfo.msg)
		activeBars[eventID] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidBreath(eventInfo)
	local barText = CL.count:format(CL.breath, breathCount)
	if self:ShouldShowBars() then
		self:Bar(1256855, eventInfo.duration, barText, nil, eventInfo.id)
	end
	breathCount = breathCount + 1
	return {
		msg = barText,
		key = 1256855,
		callback = function()
			self:Message(1256855, "red", barText)
			self:PlaySound(1256855, "warning")
		end
	}
end

function mod:ParasiteExpulsion(eventInfo)
	local barText = CL.count:format(CL.adds, parasiteCount)
	if self:ShouldShowBars() then
		self:Bar(1254199, eventInfo.duration, barText, nil, eventInfo.id)
	end
	parasiteCount = parasiteCount + 1
	return {
		msg = barText,
		key = 1254199,
		callback = function()
			self:Message(1254199, "cyan", barText)
			self:PlaySound(1254199, "long")
		end
	}
end

function mod:SmashingFrenzy(eventInfo)
	local count = eventInfo.duration == 136 and frenzyCount + 1 or frenzyCount -- it starts 2 bars from the start.
	local barText = CL.count:format(L.shadowclaw_slam, frenzyCount)
	if self:ShouldShowBars() then
		self:Bar(1241692, eventInfo.duration, barText, nil, eventInfo.id)
	end
	frenzyCount = frenzyCount + 1
	return {
		msg = barText,
		key = 1241692,
		callback = function()
			self:Message(1241692, "yellow", barText)
			self:PlaySound(1241692, "alert")
		end
	}
end

function mod:PrimordialRoar(eventInfo)
	local barText = CL.count:format(CL.roar, roarCount)
	if self:ShouldShowBars() then
		self:Bar(1260052, eventInfo.duration, barText, nil, eventInfo.id)
	end
	roarCount = roarCount + 1
	return {
		msg = barText,
		key = 1260052,
		callback = function()
			self:Message(1260052, "orange", barText)
			self:PlaySound(1260052, "alarm")
		end
	}
end
