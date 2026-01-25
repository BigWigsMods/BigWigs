--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Plexus Sentinel", 2810, 2684)
if not mod then return end
mod:SetEncounterID(3129)
mod:SetPrivateAuraSounds({
	{1220679, sound = "info"}, -- Phase Blink
	{1219248, sound = "underyou"}, -- Arcane Radiation
	1219459, -- Manifest Matrices
	{1218625, sound = "alarm"}, -- Displacement Matrix
	{1219354, sound = "underyou"}, -- Potent Residue
	1219439, -- Obliteration Arcanocannon
	1219607, -- Eradicating Salvo
})
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local startedBars = {}
local timelineEventsTracked = 0
local nextStageTwoTime = 0

local manifestMatricesCount = 1
local obliterationArcanocannonCount = 1
local eradicatingSalvoCount = 1
local protocolPurgeCount = 1
local cleanseTheChamberCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cleanse_the_chamber = "Wall"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1219450, CL.pools) -- Manifest Matrices (Pools)
	self:SetSpellRename(1218625, CL.stunned) -- Displacement Matrix (Stunned)
	self:SetSpellRename(1219263, CL.tank_bomb) -- Obliteration Arcanocannon (Tank Bomb)
	self:SetSpellRename(1219607, CL.soak) -- Eradicating Salvo (Soak)
end

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Purge The Intruders
		1219607, -- Eradicating Salvo
		{1219450, "PRIVATE"}, -- Manifest Matrices
		{1219263, "CASTBAR"}, -- Obliteration Arcanocannon
		-- Mythic
		1234733, -- Cleanse the Chamber
	},{
		[1234733] = "mythic",
	},{
		[1219450] = CL.pools, -- Manifest Matrices (Pools)
		[1219263] = CL.tank_bomb, -- Obliteration Arcanocannon (Tank Bomb)
		[1219607] = CL.soak, -- Eradicating Salvo (Soak)
		[1234733] = L.cleanse_the_chamber, -- Cleanse the Chamber (Wall)
	}
end

function mod:OnBossEnable()
	if self:Mythic() then -- Not setup for other difficulties yet
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
	end
end

function mod:OnEncounterStart()
	self:SetStage(1)

	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicatingSalvoCount = 1
	protocolPurgeCount = 1

	nextStageTwoTime = 0
	timelineEventsTracked = 0
end

--------------------------------------------------------------------------------
--- Timeline Events
---

local function isStageTwoSoon(duration) -- Blizzard starts timers and pauses them during the intermissoin, then restarts them all.
	if nextStageTwoTime == 0 then return false end
	local currentTime = GetTime()
	return nextStageTwoTime - (currentTime + duration) <= 0
end

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	local stage = self:GetStage()
	local durationRounded = math.floor(eventInfo.duration + 0.5)
	timelineEventsTracked = timelineEventsTracked + 1
	local barInfo = nil
	if stage == 1 then
		if durationRounded == 8 or durationRounded == 30 then -- Manifest Matrices
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:ManifestMatrices(eventInfo.duration)
		elseif durationRounded == 21 or durationRounded == 36 then -- Obliteration Arcanocannon
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:ObliterationArcanocannon(eventInfo.duration)
		elseif durationRounded == 39 then -- Eradicating Salvo (Also Cleanse the Chamber as stage 2 starts :facepalm:)
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:EradicatingSalvo(eventInfo.duration)
		elseif durationRounded == 60 then -- Protocol: Purge
			nextStageTwoTime = GetTime() + eventInfo.duration
			barInfo = self:ProtocolPurge(eventInfo.duration)
		elseif durationRounded == 61 then -- Stage Two
			return -- Protocol: Purge is always cast 1s before stage 2, no need to double timers
		end
	elseif stage == 2 then -- 2nd Stage 1
		if timelineEventsTracked <= 20 then return end -- Ignore first 20 events of duplicate timers.
		if durationRounded == 3 or durationRounded == 25 then -- Manifest Matrices
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:ManifestMatrices(eventInfo.duration)
		elseif durationRounded == 11 or durationRounded == 34 then -- Obliteration Arcanocannon
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:ObliterationArcanocannon(eventInfo.duration)
		elseif durationRounded == 18 or durationRounded == 30 or durationRounded == 31 then -- Eradicating Salvo
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:EradicatingSalvo(eventInfo.duration)
		elseif durationRounded == 24 or durationRounded == 93 then -- Cleanse the Chamber
			if isStageTwoSoon(eventInfo.duration) then return end
			barInfo = self:CleanseTheChamber(eventInfo.duration)
		elseif durationRounded == 90 then -- Protocol: Purge
			nextStageTwoTime = GetTime() + eventInfo.duration
			barInfo = self:ProtocolPurge(eventInfo.duration)
		elseif durationRounded == 91 then -- Stage Two
			return -- Protocol: Purge is always cast 1s before stage 2, no need to double timers
		end
	elseif stage >= 3 then
		-- Need more Logs
		return
	end
	if barInfo then
		startedBars[eventInfo.id] = barInfo
		return
	end
	print("Unhandled Event: ", eventInfo.id, " Duration: ", eventInfo.duration, durationRounded, eventInfo.spellName, stage)
end

function mod:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventID)
	if startedBars[eventID] then
		local barInfo = startedBars[eventID]
		self:StopBar(barInfo.msg)
		local spellId = barInfo.key
		if barInfo.color then
			self:Message(spellId, barInfo.color, barInfo.msg, barInfo.icon) -- SetOption:123,456:yellow:alert:
		end
		if barInfo.playSound then
			self:PlaySound(spellId, barInfo.playSound) -- SetOption:123,456:yellow:alert:
		end
		startedBars[eventID] = nil

		if spellId == "stages" then
			self:SetStage(self:GetStage() + 1)
			timelineEventsTracked = 0
			manifestMatricesCount = 1
			obliterationArcanocannonCount = 1
			eradicatingSalvoCount = 1
			protocolPurgeCount = 1
		end
	end
end


--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CleanseTheChamber(args)
	local barText = CL.incoming:format(L.cleanse_the_chamber)
	self:CDBar(1219450, duration, barText)
	return {msg = barText, key = 1219450, color = "cyan"}
end

-- Stage One: Purge The Intruders
function mod:ManifestMatrices(duration)
	local barText = CL.count:format(CL.pools, manifestMatricesCount)
	self:CDBar(1219450, duration, barText)
	manifestMatricesCount = manifestMatricesCount + 1
	return {msg = barText, key = 1219450, color = "yellow"} -- Sound on PA's
end

function mod:ObliterationArcanocannon(duration)
	local barText = CL.count:format(CL.tank_bomb, obliterationArcanocannonCount)
	self:CDBar(1219263, duration, barText)
	obliterationArcanocannonCount = obliterationArcanocannonCount + 1
	return {msg = barText, key = 1219263, color = "purple", playSound = "alarm"}
end

function mod:EradicatingSalvo(duration)
	local barText = CL.count:format(CL.soak, eradicatingSalvoCount)
	self:CDBar(1219607, duration, barText)
	eradicatingSalvoCount = eradicatingSalvoCount + 1
	return {msg = barText, key = 1219607, color = "orange", playSound = "alert"}
end

-- Stage Two: The Sieve Awakens
function mod:ProtocolPurge(duration)
	local barText = CL.count:format(CL.stage:format(2), protocolPurgeCount)
	self:CDBar("stages", duration, barText, 1220489)
	protocolPurgeCount = protocolPurgeCount + 1
	return {msg = barText, key = "stages", color = "green", playSound = "alert", icon = 1220489}
end
