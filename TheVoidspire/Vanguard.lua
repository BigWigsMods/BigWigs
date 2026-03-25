
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lightblinded Vanguard", 2912, 2737)
if not mod then return end
mod:RegisterEnableMob(240431, 240437, 240438) -- Bellamy, Lightblood, Senn
mod:SetEncounterID(3180)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1276982, sound = "underyou"}, -- Divine Consecration
	{1248985, 1248994}, -- Execution Sentence (Targetted)
	{1249008, 1249024, sound = "none"}, -- Execution Sentence (Soaked Debuff)
	-- {1249122, 1249123} -- Execution Sentance (Unknown)
	{1272324, sound = "underyou"}, -- Divine Tempest
	{1246736, sound = "alarm"}, -- Judgement (Final Verdict)
	{1251857, sound = "alarm"}, -- Judgement (Shield of the Righteous)
	-- {1251840, sound = "alarm"}, -- Judgment of the Righteous, Used?
	{1248652, sound = "alarm"}, -- Divine Toll
	1246487, -- Avenger's Shield (Targetted)
	{1246502, sound = "alarm"}, -- Avenger's Shield (DoT Debuff)
	{1248721, sound = "alarm"}, -- Tyr's Wrath
	-- {1249130, sound = "info"}, -- Elekk Charge (Buff on the NPC's, lol)
	{1258514, sound = "alarm"}, -- Blinding Light
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local durationEventCount = {}
local timelineEventCount = 0
local lastAlternateSpell = nil

local auraWrathCount = 1
local executionCount = 1
local divineStormCount = 1
local sacredTollCount = 1
local judgementRedCount = 1
local auraDevotionCount = 1
local divineTollCount = 1
local avengersShieldCount = 1
local judgementBlueCount = 1
local auraPeaceCount = 1
local tyrsWrathCount = 1
local searingRadianceCount = 1
local sacredShieldCount = 1
local zealousSpiritCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.aura_of_wrath = "Wrath" -- Short for Aura of Wrath
	L.execution_sentence = "Executes" -- Short for Execution Sentence
	L.judgement_red = "Judgement [R]" -- Red for the red icon.
	L.aura_of_devotion = "Devotion" -- Short for Aura of Devotion
	L.judgement_blue = "Judgement [B]" -- Blue for the blue icon.
	L.aura_of_peace = "Peace" -- Short for Aura of Peace
	L.zaelous_spirit = "Spirit" -- Short for Zealous Spirit
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Commander Venel Lightblood
		1248449, -- Aura of Wrath
		1248983, -- Execution Sentence
		1246765, -- Divine Storm
		1246749, -- Sacred Toll
		1246736, -- Judgement (Red)
		-- General Amias Bellamy
		1246162, -- Aura of Devotion
		1248644, -- Divine Toll
		1246485, -- Avenger's Shield
		1251857, -- Judgement (Blue)
		-- War Chaplain Senn
		1248451, -- Aura of Peace
		1248710, -- Tyr's Wrath
		1255738, -- Searing Radiance
		1248674, -- Sacred Shield
		-- Mythic
		1276243, -- Zealous Spirit
	},{
		[1248449] = -33680, -- Commander Venel Lightblood
		[1246162] = -32195, -- General Amias Bellamy
		[1248451] = -33681, -- War Chaplain Senn
		[1276243] = "mythic",
	},{
		[1248449] = L.aura_of_wrath,
		[1248983] = L.execution_sentence,
		[1246749] = CL.raid_damage,
		[1246736] = L.judgement_red,
		[1246162] = L.aura_of_devotion,
		[1248644] = CL.dodge,
		[1251857] = L.judgement_blue,
		[1248451] = L.aura_of_peace,
		[1248710] = CL.heal_absorbs,
		[1248674] = CL.shield,
		[1276243] = L.zaelous_spirit,
	}
end

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersMythic")
	elseif self:Heroic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersHeroic")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimerOther")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	durationEventCount = {}
	timelineEventCount = 0
	lastAlternateSpell = nil

	zealousSpiritCount = 1
	auraWrathCount = 1
	executionCount = 1
	divineStormCount = 1
	sacredTollCount = 1
	judgementRedCount = 1
	auraDevotionCount = 1
	divineTollCount = 1
	avengersShieldCount = 1
	judgementBlueCount = 1
	auraPeaceCount = 1
	tyrsWrathCount = 1
	searingRadianceCount = 1
	sacredShieldCount = 1
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	timelineEventCount = timelineEventCount + 1
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	eventInfo.durationRounded = durationRounded
	local eventId = eventInfo.id
	local spellName = eventInfo.spellName -- only for logging.
	local barInfo = nil
	if timelineEventCount <= 19 then -- Pull Bars
		if durationRounded == 29 then -- Divine Toll
			barInfo = self:DivineToll(eventInfo)
		elseif durationRounded == 26 then -- Aura of Devotion / Judgement (Red)
			lastAlternateSpell = lastAlternateSpell == 1246736 and 1246162 or 1246736 -- Judgement [R] and Aura of Devotion
			if lastAlternateSpell == 1246736 then -- These have the same duration so we just assume the barId and link it
				barInfo = self:JudgementRed(eventInfo)
			else
				barInfo = self:AuraOfDevotion(eventInfo)
			end
		elseif durationRounded == 66 or durationRounded == 12 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 57 or durationRounded == 110 or durationRounded == 4 then -- Zealous Spirit
			barInfo = self:ZealousSpirit(eventInfo)
		elseif durationRounded == 22 then -- Judgement (Blue)
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 132 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		elseif durationRounded == 34 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 135 then -- Tyr's Wrath
			barInfo = self:TyrsWrath(eventInfo)
		elseif durationRounded == 10 or durationRounded == 59 then -- Searing Radiance
			barInfo = self:SearingRadiance(eventInfo)
		elseif durationRounded == 20 then -- Sacred Toll
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 15 or durationRounded == 123 then -- Divine Storm
			barInfo = self:DivineStorm(eventInfo)
		elseif durationRounded == 82 then -- Execution Sentence
			barInfo = self:ExecutionSentence(eventInfo)
		elseif durationRounded == 79 then -- Aura of Wrath
			barInfo = self:AuraOfWrath(eventInfo)
		end
	else
		durationEventCount[duration] = (durationEventCount[duration] or 0) + 1
		local countForDuration = durationEventCount[duration]
		if durationRounded == 4 or durationRounded == 5 or durationRounded == 11 then
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 7 or durationRounded == 16 or durationRounded == 20 or durationRounded == 91 then
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 9 or durationRounded == 144 then
			barInfo = self:DivineStorm(eventInfo)
		elseif durationRounded == 19 or durationRounded == 121 or durationRounded == 170 then
			barInfo = self:SearingRadiance(eventInfo)
		elseif durationRounded == 46 or durationRounded == 61 or durationRounded == 127 then
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 52 then -- Small set
			if countForDuration == 1 then
				barInfo = self:SearingRadiance(eventInfo)
			elseif countForDuration == 2 or countForDuration == 3 then
				barInfo = self:SacredShield(eventInfo)
			end
		elseif durationRounded == 54 then
			if countForDuration == 1 or countForDuration == 3 or countForDuration == 6 or countForDuration == 8 or countForDuration == 11 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 or countForDuration == 4 or countForDuration == 7 or countForDuration == 9 or countForDuration == 12 then
				barInfo = self:JudgementRed(eventInfo)
			elseif countForDuration == 5 or countForDuration == 10 then
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 13 then
				barInfo = self:DivineStorm(eventInfo)
			end
		elseif durationRounded == 72 then
			if countForDuration == 1 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:AvengersShield(eventInfo)
			end
		elseif durationRounded == 90 then
			if countForDuration <= 2 then
				barInfo = self:AvengersShield(eventInfo)
			elseif countForDuration == 3 then
				barInfo = self:SearingRadiance(eventInfo)
			end
		elseif durationRounded == 162 then
			if countForDuration == 2 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 1 or countForDuration == 3 then
				barInfo = self:AvengersShield(eventInfo)
			end
		elseif durationRounded == 36 then
			if countForDuration == 1 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementRed(eventInfo)
			elseif countForDuration == 3 or countForDuration == 5 then
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 4 then
				barInfo = self:AvengersShield(eventInfo)
			elseif countForDuration == 6 or countForDuration == 7 then
				barInfo = self:DivineStorm(eventInfo)
			end
		elseif durationRounded == 159 then
			if countForDuration == 1 or countForDuration == 4 or countForDuration == 7
			 or countForDuration == 10 or countForDuration == 14 or countForDuration == 18 then
				barInfo = self:ZealousSpirit(eventInfo)
			elseif countForDuration == 2 or countForDuration == 12 then
				barInfo = self:AuraOfDevotion(eventInfo)
			elseif countForDuration == 3 or countForDuration == 13 then
				barInfo = self:DivineToll(eventInfo)
			elseif countForDuration == 5 or countForDuration == 16 then
				barInfo = self:AuraOfWrath(eventInfo)
			elseif countForDuration == 6 or countForDuration == 17 then
				barInfo = self:ExecutionSentence(eventInfo)
			elseif countForDuration == 8 or countForDuration == 19 then
				barInfo = self:AuraOfPeace(eventInfo)
			elseif countForDuration == 9 or countForDuration == 20 then
				barInfo = self:TyrsWrath(eventInfo)
			elseif countForDuration == 11 or countForDuration == 15 then
				barInfo = self:SearingRadiance(eventInfo)
			end
		elseif durationRounded == 18 then
			if countForDuration == 1 or countForDuration == 3 or countForDuration == 5
			 or countForDuration == 13 or countForDuration == 17 or countForDuration == 19
			 or countForDuration == 21 or countForDuration == 23 or countForDuration == 31
			 or countForDuration == 36 or countForDuration == 38 or countForDuration == 40
			 or countForDuration == 42 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 2 or countForDuration == 4 or countForDuration == 6
			 or countForDuration == 8 or countForDuration == 18 or countForDuration == 20
			 or countForDuration == 22 or countForDuration == 25 or countForDuration == 28
			 or countForDuration == 32 or countForDuration == 37 or countForDuration == 39
			 or countForDuration == 41 or countForDuration == 45 or countForDuration == 49 then
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 7 or countForDuration == 16 or countForDuration == 24
			 or countForDuration == 35 or countForDuration == 43 or countForDuration == 44
			 or countForDuration == 48 then
				barInfo = self:AvengersShield(eventInfo)
			elseif countForDuration == 9 or countForDuration == 11 or countForDuration == 14
			 or countForDuration == 26 or countForDuration == 29 or countForDuration == 33
			 or countForDuration == 46 or countForDuration == 50 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 10 or countForDuration == 12 or countForDuration == 15
			 or countForDuration == 27 or countForDuration == 30 or countForDuration == 34
			 or countForDuration == 47 or countForDuration == 51 then
				barInfo = self:JudgementRed(eventInfo)
			end
		end
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:TimersHeroic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 1)
	eventInfo.durationRounded = durationRounded
	timelineEventCount = timelineEventCount + 1
	local barInfo = nil
	if timelineEventCount <= 12 then -- Pull Bars
		if durationRounded == 10 then -- Sacred Toll
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 15 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 17 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 18 then -- Divine Storm
			barInfo = self:DivineStorm(eventInfo)
		elseif durationRounded == 26 then -- Judgement Blue
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 30 and not self:IsWiping() then -- Judgement Red
			barInfo = self:JudgementRed(eventInfo)
		elseif durationRounded == 35 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion(eventInfo)
		elseif durationRounded == 38 then -- Divine Toll
			barInfo = self:DivineToll(eventInfo)
		elseif durationRounded == 47 then -- Searing Radiance
			barInfo = self:SearingRadiance(eventInfo)
		elseif durationRounded == 83 then -- Aura of Wrath
			barInfo = self:AuraOfWrath(eventInfo)
		elseif durationRounded == 86 then -- Execution Sentence
			barInfo = self:ExecutionSentence(eventInfo)
		elseif durationRounded == 131 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		end
	else
		durationEventCount[eventInfo.duration] = (durationEventCount[eventInfo.duration] or 0) + 1
		local countForDuration = durationEventCount[eventInfo.duration]
		if durationRounded == 13 or durationRounded == 59
		or durationRounded == 72 or durationRounded == 27
		or durationRounded == 21 or durationRounded == 39 then
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 19 or durationRounded == 43 then
			barInfo = self:DivineStorm(eventInfo)
		elseif durationRounded == 82 or durationRounded == 132 then
			barInfo = self:SearingRadiance(eventInfo)
		elseif durationRounded == 177 or durationRounded == 173 then
			barInfo = self:AuraOfPeace(eventInfo)
		elseif (durationRounded == 65 or durationRounded == 25
		or durationRounded == 12 or durationRounded == 30) and not self:IsWiping() then
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 58 or durationRounded == 89
		or durationRounded == 51 or durationRounded == 64 then
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 42 or durationRounded == 40
		or durationRounded == 16 or durationRounded == 24
		or durationRounded == 52 then -- Judgement Blue and Red
			if countForDuration == 1 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementRed(eventInfo)
			end
		elseif durationRounded == 53 then
			if countForDuration == 1 or countForDuration == 2 then -- Searing Radiance
				barInfo = self:SearingRadiance(eventInfo)
			elseif countForDuration == 3 then -- Avengers Shield
				barInfo = self:AvengersShield(eventInfo)
			elseif countForDuration == 4 then -- Sacred Shield
				barInfo = self:SacredShield(eventInfo)
			elseif countForDuration == 5 then -- Divine Storm
				barInfo = self:DivineStorm(eventInfo)
			end
		elseif durationRounded == 174 then -- Aura of Devotion and Divine Toll
			if countForDuration % 2 == 1 then
				barInfo = self:AuraOfDevotion(eventInfo)
			else
				barInfo = self:DivineToll(eventInfo)
			end
		elseif durationRounded == 175 or durationRounded == 172 then -- Aura of Wrath and Execution Sentence
			if countForDuration == 1 then
				barInfo = self:AuraOfWrath(eventInfo)
			else
				barInfo = self:ExecutionSentence(eventInfo)
			end
		elseif durationRounded == 45 then -- Divine Storm or Sacred Toll
			if countForDuration == 1 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:SacredToll(eventInfo)
			end
		elseif durationRounded == 22 then -- Divine Storm or Avengers Shield
			if countForDuration == 1 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 2 or countForDuration == 3 then
				barInfo = self:AvengersShield(eventInfo)
			end
		elseif durationRounded == 15 then -- Sacred Toll, Divine Storm, or Avengers Shield
			if countForDuration == 1 then
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 3 then
				barInfo = self:AvengersShield(eventInfo)
			end
		elseif durationRounded == 23 then -- Sacred Toll, Judgement Blue, or Judgement Red
			if countForDuration == 1 then
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 3 then
				barInfo = self:JudgementRed(eventInfo)
			end
		elseif durationRounded == 50 then -- Divine Storm or Searing Radiance
			if countForDuration == 1 then
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:SearingRadiance(eventInfo)
			end
		elseif durationRounded == 60 then -- Judgement Blue, Judgement Red, or Sacred Shield
			if countForDuration == 1 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementRed(eventInfo)
			elseif countForDuration == 3 then
				barInfo = self:SacredShield(eventInfo)
			end
		elseif durationRounded == 17 then -- Avengers Shield, Judgement Blue, or Judgement Red
			if countForDuration == 1 then
				barInfo = self:AvengersShield(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 3 then
				barInfo = self:JudgementRed(eventInfo)
			end
		elseif durationRounded == 54 then -- Judgement Blue or Judgement Red
			if countForDuration == 1 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementRed(eventInfo)
			end
		elseif durationRounded == 20 then -- Many
			if countForDuration == 1 or countForDuration == 3 or countForDuration == 13 or countForDuration == 14
			 or countForDuration == 16 or countForDuration == 19 or countForDuration == 20
			 or countForDuration == 22 or countForDuration == 24 or countForDuration == 26 then -- Divine Storm
				barInfo = self:DivineStorm(eventInfo)
			elseif countForDuration == 2 or countForDuration == 4 or countForDuration == 15
			 or countForDuration == 23 or countForDuration == 25 then -- Sacred Toll
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 5 or countForDuration == 6 or countForDuration == 9
			 or countForDuration == 12 or countForDuration == 21 then -- Avenger's Shield
				barInfo = self:AvengersShield(eventInfo)
			elseif countForDuration == 7 or countForDuration == 10 or countForDuration == 17 then -- Judgement Blue
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 8 or countForDuration == 11 or countForDuration == 18 then -- Judgement Red
				barInfo = self:JudgementRed(eventInfo)
			end
		end
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:TimerOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 1)
	eventInfo.durationRounded = durationRounded
	timelineEventCount = timelineEventCount + 1
	local barInfo = nil
	if timelineEventCount <= 10 then -- Pull Bars
		if durationRounded == 10 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 17 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 23 then -- Sacred Toll
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 26 then -- Judgement Blue
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 30 and not self:IsWiping() then -- Judgement Red
			barInfo = self:JudgementRed(eventInfo)
		elseif durationRounded == 35 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion(eventInfo)
		elseif durationRounded == 38 then -- Divine Toll
			barInfo = self:DivineToll(eventInfo)
		elseif durationRounded == 83 then -- Aura of Wrath
			barInfo = self:AuraOfWrath(eventInfo)
		elseif durationRounded == 86 then -- Execution Sentence
			barInfo = self:ExecutionSentence(eventInfo)
		elseif durationRounded == 131 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		end
	else
		durationEventCount[eventInfo.duration] = (durationEventCount[eventInfo.duration] or 0) + 1
		local countForDuration = durationEventCount[eventInfo.duration]
		if durationRounded == 67 or durationRounded == 43 or durationRounded == 23 or
			durationRounded == 17 or durationRounded == 41 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 53 or durationRounded == 33 or durationRounded == 68 or
				durationRounded == 66 or durationRounded == 31 or durationRounded == 22 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 52 then
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 62 or durationRounded == 44 or durationRounded == 28 then
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 92 then
			barInfo = self:JudgementRed(eventInfo)
		elseif durationRounded == 177 then
			barInfo = self:AuraOfPeace(eventInfo)
		elseif durationRounded == 40 then -- Many
			if countForDuration == 1 or countForDuration == 4 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementRed(eventInfo)
			elseif countForDuration == 3 then
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 5 then
				barInfo = self:AvengersShield(eventInfo)
			end
		elseif durationRounded == 42 then -- Judgement Blue or Red
			if countForDuration == 1 then
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:JudgementRed(eventInfo)
			end
		elseif durationRounded == 48 then -- Sacred Shield or Avenger's Shield
			if countForDuration == 1 then
				barInfo = self:SacredShield(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:AvengersShield(eventInfo)
			end
		elseif durationRounded == 174 or durationRounded == 172 then -- Aura of Devotion or Divine Toll
			if countForDuration == 1 then
				barInfo = self:AuraOfDevotion(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:DivineToll(eventInfo)
			end
		elseif durationRounded == 175 or durationRounded == 169 then -- Aura of Wrath or Execution Sentence
			if countForDuration == 1 then
				barInfo = self:AuraOfWrath(eventInfo)
			elseif countForDuration == 2 then
				barInfo = self:ExecutionSentence(eventInfo)
			end
		elseif durationRounded == 20 then -- Many
			if countForDuration == 1 or countForDuration == 2 or countForDuration == 5 or
				countForDuration == 14 or countForDuration == 15 then -- Sacred Toll
				barInfo = self:SacredToll(eventInfo)
			elseif countForDuration == 3 or countForDuration == 6 or countForDuration == 9 or
				countForDuration == 12 or countForDuration == 16 then -- Judgement Blue
				barInfo = self:JudgementBlue(eventInfo)
			elseif countForDuration == 4 or countForDuration == 7 or countForDuration == 10 or
				countForDuration == 13 or countForDuration == 17 then -- Judgement Red
				barInfo = self:JudgementRed(eventInfo)
			elseif countForDuration == 8 or countForDuration == 11 then -- Avengers Shield
				barInfo = self:AvengersShield(eventInfo)
			end
		end
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 2 or state == 3 then -- Finished or Canceled
			self:StopBar(barInfo.msg)
			if state == 2 and barInfo.onFinished and self:ShouldShowBars() then -- Finished
				barInfo.onFinished()
			end
			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
		local newState = C_EncounterTimeline.GetEventState(eventID)
		if newState == 0 then -- Enum.EncounterTimelineEventState.Active
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif newState == 1 then -- Enum.EncounterTimelineEventState.Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif newState == 3 then -- Enum.EncounterTimelineEventState.Canceled
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		elseif newState == 2 then -- Enum.EncounterTimelineEventState.Finished
			local info = C_EncounterTimeline.GetEventInfo(eventID)
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

function mod:JudgementBlue(eventInfo)
	local barText = CL.count:format(L.judgement_blue, judgementBlueCount)
	if self:ShouldShowBars() then
		self:CDBar(1251857, eventInfo.duration, barText, nil, eventInfo.id)
	end
	judgementBlueCount = judgementBlueCount + 1
	return {
		msg = barText,
		key = 1251857,
		onFinished = function()
			self:Message(1251857, "purple", barText)
			self:PlaySound(1251857, "info")
		end
	}
end

function mod:JudgementRed(eventInfo)
	local barText = CL.count:format(L.judgement_red, judgementRedCount)
	if self:ShouldShowBars() then
		self:CDBar(1246736, eventInfo.duration, barText, nil, eventInfo.id)
	end
	judgementRedCount = judgementRedCount + 1
	return {
		msg = barText,
		key = 1246736,
		onFinished = function()
			self:Message(1246736, "purple", barText)
			self:PlaySound(1246736, "info")
		end
	}
end

function mod:SacredToll(eventInfo)
	local barText = CL.count:format(CL.raid_damage, sacredTollCount)
	if self:ShouldShowBars() then
		self:CDBar(1246749, eventInfo.duration, barText, nil, eventInfo.id)
	end
	sacredTollCount = sacredTollCount + 1
	return {
		msg = barText,
		key = 1246749,
		onFinished = function()
			self:Message(1246749, "yellow", barText)
			self:PlaySound(1246749, "alert")
		end
	}
end

function mod:AvengersShield(eventInfo)
	 -- first 2 need to be a set order as they apear the other way around
	local count = eventInfo.durationRounded == 66 and 2 or eventInfo.durationRounded == 12 and 1 or avengersShieldCount
	local barText = CL.count:format(self:SpellName(1246485), avengersShieldCount)
	if self:ShouldShowBars() then
		self:CDBar(1246485, eventInfo.duration, barText, nil, eventInfo.id)
	end
	avengersShieldCount = avengersShieldCount + 1
	return {
		msg = barText,
		key = 1246485,
		onFinished = function()
			self:Message(1246485, "yellow", barText)
			-- Sound from PA's
		end
	}
end

function mod:DivineStorm(eventInfo)
	local count = divineStormCount
	if eventInfo.durationRounded == 15 or eventInfo.durationRounded == 123 then
		count = eventInfo.durationRounded == 15 and 1 or 3
	end
	if divineStormCount == 3 then
		-- set 2nd to correct on pull timers
		count = 2
	end
	local barText = CL.count:format(self:SpellName(1246765), divineStormCount)
	if self:ShouldShowBars() then
		self:CDBar(1246765, eventInfo.duration, barText, nil, eventInfo.id)
	end
	divineStormCount = divineStormCount + 1
	return {
		msg = barText,
		key = 1246765,
		onFinished = function()
			self:Message(1246765, "red", barText)
			self:PlaySound(1246765, "alarm")
		end
	}
end

function mod:SearingRadiance(eventInfo)
	-- 2 timers on pull handling
	local count = eventInfo.durationRounded == 10 and 1 or eventInfo.durationRounded == 59 and 2 or searingRadianceCount
	local barText = CL.count:format(self:SpellName(1255738), count)
	if self:ShouldShowBars() then
		self:CDBar(1255738, eventInfo.duration, barText, nil, eventInfo.id)
	end
	searingRadianceCount = searingRadianceCount + 1
	return {
		msg = barText,
		key = 1255738,
		onFinished = function()
			self:Message(1255738, "orange", barText)
			self:PlaySound(1255738, "alert")
		end
	}
end

function mod:SacredShield(eventInfo)
	local barText = CL.count:format(CL.shield, sacredShieldCount)
	if self:ShouldShowBars() then
		self:CDBar(1248674, eventInfo.duration, barText, nil, eventInfo.id)
	end
	sacredShieldCount = sacredShieldCount + 1
	return {
		msg = barText,
		key = 1248674,
		onFinished = function()
			self:Message(1248674, "red", barText)
			self:PlaySound(1248674, "warning") -- break shield
		end
	}
end

function mod:ZealousSpirit(eventInfo)
	 -- it spawns 3 timers on pull (lol)
	local barCount = eventInfo.durationRounded == 110 and 3 or eventInfo.durationRounded == 57 and 2 or eventInfo.durationRounded == 4 and 1 or zealousSpiritCount
	local barText = CL.count:format(L.zaelous_spirit, barCount)
	if self:ShouldShowBars() then
		self:CDBar(1276243, eventInfo.duration, barText, nil, eventInfo.id)
	end
	zealousSpiritCount = zealousSpiritCount + 1
	return {
		msg = barText,
		key = 1276243,
		onFinished = function()
			self:Message(1276243, "cyan", barText)
			self:PlaySound(1276243, "info") -- new empower
		end
	}
end

function mod:AuraOfWrath(eventInfo)
	local barText = CL.count:format(L.aura_of_wrath, auraWrathCount)
	if self:ShouldShowBars() then
		self:CDBar(1248449, eventInfo.duration, barText, nil, eventInfo.id)
	end
	auraWrathCount = auraWrathCount + 1
	return {
		msg = barText,
		key = 1248449,
		onFinished = function()
			self:Message(1248449, "cyan", barText)
			self:PlaySound(1248449, "long") -- Aura enabled
		end
	}
end

function mod:ExecutionSentence(eventInfo)
	local barText = CL.count:format(L.execution_sentence, executionCount)
	if self:ShouldShowBars() then
		self:CDBar(1248983, eventInfo.duration, barText, nil, eventInfo.id)
	end
	executionCount = executionCount + 1
	return {
		msg = barText,
		key = 1248983,
		onFinished = function()
			self:Message(1248983, "red", barText)
			-- Sound on PA's
		end
	}
end

function mod:AuraOfDevotion(eventInfo)
	local barText = CL.count:format(L.aura_of_devotion, auraDevotionCount)
	if self:ShouldShowBars() then
		self:CDBar(1246162, eventInfo.duration, barText, nil, eventInfo.id)
	end
	auraDevotionCount = auraDevotionCount + 1
	return {
		msg = barText,
		key = 1246162,
		onFinished = function()
			self:Message(1246162, "cyan", barText)
			self:PlaySound(1246162, "long") -- Aura enabled
		end
	}
end

function mod:DivineToll(eventInfo)
	local barText = CL.count:format(CL.dodge, divineTollCount)
	if self:ShouldShowBars() then
		self:CDBar(1248644, eventInfo.duration, barText, nil, eventInfo.id)
	end
	divineTollCount = divineTollCount + 1
	return {
		msg = barText,
		key = 1248644,
		onFinished = function()
			self:Message(1248644, "orange", barText)
			self:PlaySound(1248644, "warning") -- Dodge shields
		end
	}
end

function mod:AuraOfPeace(eventInfo)
	local barText = CL.count:format(L.aura_of_peace, auraPeaceCount)
	if self:ShouldShowBars() then
		self:CDBar(1248451, eventInfo.duration, barText, nil, eventInfo.id)
	end
	auraPeaceCount = auraPeaceCount + 1
	-- Tyr's Wrath is bugged and missing an event/timers, start it here for now.
	local tyrsCD = eventInfo.duration + 5  -- always 5 seconds after Aura of Peace
	activeBars[-eventInfo.id] = self:TyrsWrath({
		duration = tyrsCD,
	})
	self:ScheduleTimer(function() self:ENCOUNTER_TIMELINE_EVENT_REMOVED(nil,-eventInfo.id) end, tyrsCD)
	return {
		msg = barText,
		key = 1248451,
		onFinished = function()
			self:Message(1248451, "cyan", barText)
			self:PlaySound(1248451, "long") -- Aura enabled
		end
	}
end

function mod:TyrsWrath(eventInfo)
	local barText = CL.count:format(CL.heal_absorbs, tyrsWrathCount)
	if self:ShouldShowBars() then
		self:CDBar(1248710, eventInfo.duration, barText, nil, eventInfo.id)
	end
	tyrsWrathCount = tyrsWrathCount + 1
	return {
		msg = barText,
		key = 1248710,
		onFinished = function()
			self:Message(1248710, "orange", barText)
			-- Sound on PA's
		end
	}
end
