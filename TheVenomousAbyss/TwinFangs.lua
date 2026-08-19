
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Twin Fangs", 3004, 2887)
if not mod then return end
mod:RegisterEnableMob(257361, 257368) -- Vexhul, Ithraz
mod:SetEncounterID(3421)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local countForDuration = {}

local submergeCount = 1
local causticDelugeCount = 1
local coilingToxinCount = 1
local beckonProgenyCount = 1
local surgeCount = 1
local corrosiveSpitCount = 1
local ravenousFeastCount = 1
local bloodTorrentCount = 1
local stirTheDepthsCount = 1
local stoneBreakerCount = 1
local barrageCount = 1
local floodCount = 1
local rouseTheBroodCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({
	coiling_toxin = "Toxin", -- Short for Coiling Toxin
	corrosive_spit = "Spit", -- Short for Corrosive Spit
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1308556] = {1308556}, -- Submerge
	-- Vexhul
	[1289192] = {CL.orbs}, -- Caustic Deluge
	[1291404] = {CL.adds}, -- Venomous Emergence
	[1291478] = {L.corrosive_spit}, -- Corrosive Spit
	[1290956] = {CL.waves}, -- Stir the Depths
	[1294293] = {1294293}, -- Vile Flood
	-- Ithraz
	[1303230] = {CL.heal_absorb}, -- Blood Torrent
	[1290516] = {CL.soak}, -- Ravenous Feast
	[1290809] = {L.coiling_toxin}, -- Coiling Ichor
	[1288538] = {1288538}, -- Stone Breaker
	[1306872] = {1306872}, -- Sanguine Storm
	[1308356] = {CL.kicks}, -- Rouse the Brood
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({ -- TODO
	{1289192, soundOnApplied = "none", duration = 5}, -- Caustic Deluge
	{1290814, soundOnApplied = "none", duration = 12}, -- Coiling Ichor
	{1292552, 1306925, soundOnApplied = "none"}, -- Congealed Gore
	{1293979, soundOnApplied = "none", duration = 5}, -- Corrosive Spit
	{1290336, soundOnApplied = "none"}, -- Eternal Venom
	{1289092, soundOnApplied = "none"}, -- Stone Breaker
	{1309471, soundOnApplied = "none"}, -- Noxious Slick
	{1292807, soundOnApplied = "none"}, -- Stir the Depths
	{1294605, soundOnApplied = "none"}, -- Vile Flood
	{1303230, 1303235, soundOnApplied = "none", mythic = true}, -- Blood Torrent
	{1310360, soundOnApplied = "none", mythic = true}, -- Envenomed
	{1310096, soundOnApplied = "none", duration = 8, mythic = true}, -- Feasted
	{1310102, soundOnApplied = "none", mythic = true}, -- Tainted Blood
	{1308386, soundOnApplied = "none", mythic = true}, -- Visceral Burst
})


function mod:GetOptions()
	return {
		1308556, -- Submerge

		-- Vexhul
		1289192, -- Caustic Deluge
		1291404, -- Venomous Emergence
		1291478, -- Corrosive Spit
		1290956, -- Stir the Depths
		{1294293, "CASTBAR"}, -- Vile Flood

		-- Ithraz
		1303230, -- Blood Torrent
		1308356, -- Rouse the Brood
		1290516, -- Ravenous Feast
		1290809, -- Coiling Ichor
		{1288538, "TANK"}, -- Stone Breaker
		1306872, -- Sanguine Storm
	}, {
		{
			tabName = self:SpellName(-35616), -- Vexhul
			{ 1308556, 1289192, 1291404, 1291478, 1290956, 1294293 },
		},
		{
			tabName = self:SpellName(-35618), -- Ithraz
			{ 1308556, 1303230, 1308356, 1290516, 1290809, 1288538, 1306872 },
		},
	-- 	[1289192] = -35616, -- Vexhul
	-- 	[1303230] = -35618, -- Ithraz
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "MythicEvents")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "OtherEvents")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	countForDuration = {}

	submergeCount = 1
	causticDelugeCount = 1
	coilingToxinCount = 1
	beckonProgenyCount = 1
	surgeCount = 1
	corrosiveSpitCount = 1
	ravenousFeastCount = 1
	bloodTorrentCount = 1
	stirTheDepthsCount = 1
	stoneBreakerCount = 1
	barrageCount = 1
	floodCount = 1
	rouseTheBroodCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--
function mod:MythicEvents(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if durationRounded == 6 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 2 == 1 then-- Sanguine Storm > Flood
			barInfo = self:Barrage()
		else
			barInfo = self:VileFlood()
		end
	elseif durationRounded == 8 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 2 == 1 then-- Caustic > Blood
			barInfo = self:CausticDeluge()
		else
			barInfo = self:BloodTorrent()
		end
	elseif durationRounded == 18 then
		barInfo = self:StoneBreaker()
	elseif durationRounded == 33 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 2 == 1 then -- Rouse
			barInfo = self:RouseTheBrood()
		else
			barInfo = self:BeckonProgeny()
		end
	elseif durationRounded == 40 then
		barInfo = self:CoilingToxin()
	elseif durationRounded == 47 then
		barInfo = self:StirTheDepths()
	elseif durationRounded == 57 then
		barInfo = self:RavenousFeast()
	elseif durationRounded == 61 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 8 == 1 then -- Caustic Deluge > Blood Torrent > Stone Breaker > Rouse > Emergence > Coiling Ichor > Stir the Depths > Feast
			barInfo = self:CausticDeluge()
		elseif countForDuration[durationRounded] % 8 == 2 then
			barInfo = self:BloodTorrent()
		elseif countForDuration[durationRounded] % 8 == 3 then
			barInfo = self:StoneBreaker()
		elseif countForDuration[durationRounded] % 8 == 4 then
			barInfo = self:RouseTheBrood()
		elseif countForDuration[durationRounded] % 8 == 5 then
			barInfo = self:BeckonProgeny()
		elseif countForDuration[durationRounded] % 8 == 6 then
			barInfo = self:CoilingToxin()
		elseif countForDuration[durationRounded] % 8 == 7 then
			barInfo = self:StirTheDepths()
		elseif countForDuration[durationRounded] % 8 == 0 then
			barInfo = self:RavenousFeast()
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:CDBar(barInfo.key, barInfo.duration or eventInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
		end
	elseif barInfo == nil and self:ShouldShowBars() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:OtherEvents(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if durationRounded == 163 or durationRounded == 162 then -- 162.5~ so account for precision rounding
		barInfo = self:Submerge()
	elseif durationRounded == 6 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 2 == 1 then-- Sanguine Storm > Flood
			barInfo = self:Barrage()
		else
			barInfo = self:VileFlood()
		end
	elseif durationRounded == (self:Easy() and 50 or 44) then
		barInfo = self:CoilingToxin()
	elseif durationRounded == (self:Easy() and 71 or 63) then
		barInfo = self:RavenousFeast()
	elseif durationRounded == (self:Easy() and 23 or 20) or durationRounded == 22 then -- Stone Breaker timer is 22.5 exactly, dips round down to 22
		barInfo = self:StoneBreaker()
	elseif durationRounded ==  (self:Easy() and 41 or 37) then
		barInfo = self:BeckonProgeny()
	elseif durationRounded == (self:Easy() and 10 or 9) then
		barInfo = self:CausticDeluge()
	elseif durationRounded ==  (self:Easy() and 59 or 52) then
		barInfo = self:StirTheDepths()
	elseif durationRounded == (self:Easy() and 76 or 68) then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 6 == 1 then -- Caustic > Stone > Beckon > Coiling > Stir > Ravenous
			barInfo = self:CausticDeluge()
		elseif countForDuration[durationRounded] % 6 == 2 then
			barInfo = self:StoneBreaker()
		elseif countForDuration[durationRounded] % 6 == 3 then
			barInfo = self:BeckonProgeny()
		elseif countForDuration[durationRounded] % 6 == 4 then
			barInfo = self:CoilingToxin()
		elseif countForDuration[durationRounded] % 6 == 5 then
			barInfo = self:StirTheDepths()
		elseif countForDuration[durationRounded] % 6 == 0 then
			barInfo = self:RavenousFeast()
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:CDBar(barInfo.key, barInfo.duration or eventInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
		end
	elseif barInfo == nil and self:ShouldShowBars() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 2 then -- Finished
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onFinished and self:ShouldShowBars() then
				barInfo.onFinished()
			end
		elseif state == 3 then -- Canceled
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onCanceled and self:ShouldShowBars() then
				barInfo.onCanceled()
			end
		end
	elseif backupBars[eventID] then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 0 then -- Enum.EncounterTimelineEventState.Active
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif state == 1 then -- Enum.EncounterTimelineEventState.Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif state == 2 or state == 3 then -- Enum.EncounterTimelineEventState.Finished / Enum.EncounterTimelineEventState.Canceled
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		self:StopBar(barInfo.msg)
		activeBars[eventID] = nil
	elseif backupBars[eventID] then
		backupBars[eventID] = nil
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Submerge()
	local barText = CL.count:format(self:GetRename(1308556), submergeCount)
	submergeCount = submergeCount + 1
	return {
		msg = barText,
		key = 1308556,
		onFinished = function()
			self:Message(1308556, "cyan", barText)
			self:PlaySound(1308556, "info")
		end,
	}
end

function mod:CausticDeluge()
	local barText = CL.count:format(self:GetRename(1289192), causticDelugeCount)
	causticDelugeCount = causticDelugeCount + 1
	return {
		msg = barText,
		key = 1289192,
		onFinished = function()
			self:StopBlizzMessages(2) -- delayed blizzard message with target but it's always the tank?
			self:Message(1289192, "orange", barText)
			self:PlaySound(1289192, "alarm")
		end
	}
end

do
	local function CoilingToxinSound(self)
		self:PlaySound(1290809, "warning")
	end

	function mod:CoilingToxin()
		local barText = CL.count:format(self:GetRename(1290809), coilingToxinCount)
		coilingToxinCount = coilingToxinCount + 1
		return {
			msg = barText,
			key = 1290809,
			onFinished = function()
				self:Message(1290809, "yellow", barText)
				self:PersonalMessageFromBlizzMessage(1290809, 5, nil, barText, nil, nil, CoilingToxinSound) -- delayed a lot
			end
		}
	end
end

function mod:BeckonProgeny()
	local barText = CL.count:format(self:GetRename(1291404), beckonProgenyCount)
	beckonProgenyCount = beckonProgenyCount + 1
	return {
		msg = barText,
		key = 1291404,
		onFinished = function()
			self:StopBlizzMessages(2)
			self:Message(1291404, "cyan", barText)
			self:PlaySound(1291404, "info") -- adds
		end
	}
end

function mod:Surge()
	local barText = CL.count:format(self:GetRename(1294293), surgeCount)
	surgeCount = surgeCount + 1
	return {
		msg = barText,
		key = 1294293,
		onFinished = function()
			self:Message(1294293, "yellow", barText)
			self:PlaySound(1294293, "long")
		end
	}
end

function mod:CorrosiveSpit()
	local barText = CL.count:format(self:GetRename(1291478), corrosiveSpitCount)
	corrosiveSpitCount = corrosiveSpitCount + 1
	return {
		msg = barText,
		key = 1291478,
		onFinished = function()
			self:Message(1291478, "orange", barText)
			self:PlaySound(1291478, "alarm") -- avoid
		end
	}
end

function mod:RavenousFeast()
	local barText = CL.count:format(self:GetRename(1290516), ravenousFeastCount)
	ravenousFeastCount = ravenousFeastCount + 1
	return {
		msg = barText,
		key = 1290516,
		onFinished = function()
			self:StopBlizzMessages(2)
			self:Message(1290516, "orange", barText)
			self:PlaySound(1290516, "alarm") -- soak feast
		end
	}
end

function mod:BloodTorrent()
	local barText = CL.count:format(self:GetRename(1303230), bloodTorrentCount)
	bloodTorrentCount = bloodTorrentCount + 1
	return {
		msg = barText,
		key = 1303230,
		onFinished = function()
			self:Message(1303230, "yellow", barText)
			if self:Healer() then
				self:PlaySound(1303230, "alert") -- heal absorbs
			end
		end
	}
end

function mod:StirTheDepths()
	local barText = CL.count:format(self:GetRename(1290956), stirTheDepthsCount)
	stirTheDepthsCount = stirTheDepthsCount + 1
	return {
		msg = barText,
		key = 1290956,
		onFinished = function()
			self:Message(1290956, "orange", barText)
			self:PlaySound(1290956, "alarm") -- dodge waves
		end
	}
end

function mod:StoneBreaker()
	local barText = CL.count:format(self:GetRename(1288538), stoneBreakerCount)
	stoneBreakerCount = stoneBreakerCount + 1
	return {
		msg = barText,
		key = 1288538,
		onFinished = function()
			self:Message(1288538, "purple", barText)
			-- self:PlaySound(1288538, "alarm") -- tank slams + knockback
		end
	}
end

function mod:Barrage()
	local barText = CL.count:format(self:GetRename(1306872), barrageCount)
	barrageCount = barrageCount + 1
	return {
		msg = barText,
		key = 1306872,
		onFinished = function()
			self:Message(1306872, "yellow", barText)
			self:PlaySound(1306872, "alert") -- avoid pools
		end
	}
end

function mod:VileFlood()
	local barText = CL.count:format(self:GetRename(1294293), floodCount)
	floodCount = floodCount + 1
	return {
		msg = barText,
		key = 1294293,
		onFinished = function()
			self:Message(1294293, "yellow", barText)
			self:CastBar(1294293, 18, barText) -- 4s cast + 14s channel as one bar
			self:PlaySound(1294293, "long") -- Ithraz full energy
		end
	}
end

function mod:RouseTheBrood()
	local barText = CL.count:format(self:GetRename(1308356), rouseTheBroodCount)
	rouseTheBroodCount = rouseTheBroodCount + 1
	return {
		msg = barText,
		key = 1308356,
		onFinished = function()
			self:Message(1308356, "red", barText)
			self:PlaySound(1308356, "warning") -- interrupts
		end
	}
end
