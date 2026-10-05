
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

local pullTime = 0
local durationEventCount = {}
local timelineEventCount = 0
local storedTimelineEvents = {}
local scheduleBackups = nil

local auraWrathCount = 1
local executionCount = 1
local sacredTollCount = 1
local judgementRedCount = 1
local auraDevotionCount = 1
local divineTollCount = 1
local judgementBlueCount = 1
local auraPeaceCount = 1
local tyrsWrathCount = 1
local sacredShieldCount = 1
local zealousSpiritCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
	aura_of_wrath = "Wrath", -- Short for Aura of Wrath
	execution_sentence = "Executes", -- Short for Execution Sentence
	executes_mythic = "Executes + Dodge",
	judgement_red = "Judgement [R]", -- Red for the red icon.
	aura_of_devotion = "Devotion", -- Short for Aura of Devotion
	judgement_blue = "Judgement [B]", -- Blue for the blue icon.
	aura_of_peace = "Peace", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Absorbs + Executes",
	divine_toll_mythic = "Dodge + Absorbs",

	empowered_searing_radiance = "Empowered Searing Radiance",
	empowered_searing_radiance_desc = "Show the timer for the empowered Searing Radiance.",
	empowered_searing_radiance_icon = 1255738,

	empowered_avengers_shield = "Empowered Avenger's Shield",
	empowered_avengers_shield_desc = "Show the timer for the empowered Avenger's Shield.",
	empowered_avengers_shield_icon = 1246485,

	empowered_divine_storm = "Empowered Divine Storm",
	empowered_divine_storm_desc = "Show the timer for the empowered Divine Storm.",
	empowered_divine_storm_icon = 1246765,
	tornadoes = "Tornadoes",

	empowered = "[E] %s", -- Empowered version of an ability, %s for the spell name.
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1248449] = {L.aura_of_wrath}, -- Aura of Wrath (Wrath)
	[1248983] = {L.executes_mythic, L.execution_sentence, notes={CL.mythicOnlyNote, CL.otherDifficultiesNote}}, -- Execution Sentence (Executes)
	[1246765] = {1246765}, -- Divine Storm
	[1246749] = {CL.raid_damage}, -- Sacred Toll (Raid Damage)
	[1246736] = {L.judgement_red}, -- Judgement (Judgement [R])
	[1246162] = {L.aura_of_devotion}, -- Aura of Devotion (Devotion)
	[1248644] = {L.divine_toll_mythic, CL.dodge, notes={CL.mythicOnlyNote, CL.otherDifficultiesNote}}, -- Divine Toll (Dodge)
	[1246485] = {1246485}, -- Avenger's Shield
	[1251857] = {L.judgement_blue}, -- Judgement (Judgement [B])
	[1248451] = {L.aura_of_peace}, -- Aura of Peace (Peace)
	[1248710] = {L.tyrs_wrath_mythic, CL.heal_absorbs, notes={CL.mythicOnlyNote, CL.otherDifficultiesNote}}, -- Tyr's Wrath (Heal Absorbs)
	[1255738] = {1255738}, -- Searing Radiance
	[1248674] = {CL.shield}, -- Sacred Shield (Shield)
	[1276243] = {CL.spirit}, -- Zealous Spirit (Spirit)
	["empowered_divine_storm"] = {L.empowered:format(L.tornadoes), original = 1246765}, -- Empowered Divine Storm ([E] Tornadoes)
	["empowered_avengers_shield"] = {L.empowered:format(mod:SpellName(1246485)), original = 1246485}, -- Empowered Avenger's Shield ([E] Avenger's Shield)
	["empowered_searing_radiance"] = {L.empowered:format(mod:SpellName(1255738)), original = 1255738}, -- Empowered Searing Radiance ([E] Searing Radiance)
})

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Commander Venel Lightblood
		1248449, -- Aura of Wrath
		1248983, -- Execution Sentence
		{1246765, "OFF"}, -- Divine Storm
		1246749, -- Sacred Toll
		{1246736, "TANK"}, -- Judgement (Red)
		-- General Amias Bellamy
		1246162, -- Aura of Devotion
		1248644, -- Divine Toll
		1246485, -- Avenger's Shield
		{1251857, "TANK"}, -- Judgement (Blue)
		-- War Chaplain Senn
		1248451, -- Aura of Peace
		1248710, -- Tyr's Wrath
		{1255738, "HEALER"}, -- Searing Radiance
		1248674, -- Sacred Shield
		-- Mythic
		{1276243, "OFF"}, -- Zealous Spirit
		"empowered_divine_storm",
		"empowered_avengers_shield",
		{"empowered_searing_radiance", "HEALER"},
	},{
		[1248449] = -33680, -- Commander Venel Lightblood
		[1246162] = -32195, -- General Amias Bellamy
		[1248451] = -33681, -- War Chaplain Senn
		[1276243] = "mythic",
	}
end

function mod:OnBossEnable()
	if self:Mythic() then
		self:SetTimelineHandler("TimersMythic")
	elseif self:Heroic() then
		self:SetTimelineHandler("TimersHeroic")
	else
		self:SetTimelineHandler("TimerOther")
	end
end

function mod:OnEncounterStart()
	durationEventCount = {}
	timelineEventCount = 0
	storedTimelineEvents = {}
	scheduleBackups = nil

	zealousSpiritCount = 1
	auraWrathCount = 1
	executionCount = 1
	sacredTollCount = 1
	judgementRedCount = 1
	auraDevotionCount = 1
	divineTollCount = 1
	judgementBlueCount = 1
	auraPeaceCount = 1
	tyrsWrathCount = 1
	sacredShieldCount = 1
	pullTime = GetTime()
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

-- Several abilities can only be told apart once an earlier one finishes, so an event we
-- can't identify yet is stored. Finishing a bar claims the oldest stored event, and
-- anything still stored half a second later was never claimed, so it falls back to a
-- backup bar the way an unrecognised event would.
local ClaimNextStoredEvent

-- Chains claiming onto whatever the ability already does when it finishes.
local function TrackStored(barInfo)
	if not barInfo then return barInfo end
	local onFinished = barInfo.onFinished
	barInfo.onFinished = function(info, eventId, module)
		if onFinished then
			onFinished(info, eventId, module)
		end
		ClaimNextStoredEvent(info)
	end
	return barInfo
end

function ClaimNextStoredEvent(barInfo)
	-- skipTracking is set per bar, a missing `this` means the ability never claims at all
	if barInfo.skipTracking or not barInfo.this then return end
	local storedEventInfo = table.remove(storedTimelineEvents, 1)
	if storedEventInfo then
		mod:HandleTimelineEvent(storedEventInfo, TrackStored(barInfo.this(mod, storedEventInfo, barInfo.empowered)))
	end
end

-- Returns false so the prototype leaves the event alone instead of reporting it as one we
-- failed to recognise, because it may still be claimed.
function mod:StoreEvent(eventInfo)
	eventInfo.timestamp = GetTime()
	table.insert(storedTimelineEvents, eventInfo)
	if scheduleBackups then
		self:CancelTimer(scheduleBackups)
	end
	scheduleBackups = self:ScheduleTimer(function()
		scheduleBackups = nil
		for _, event in next, storedTimelineEvents do
			if not self:IsWiping() then
				event.duration = event.duration - (GetTime() - event.timestamp)
				self:HandleTimelineEvent(event, nil) -- Never claimed, so a backup bar and an error
			end
		end
		table.wipe(storedTimelineEvents)
	end, 0.5)
	return false
end

function mod:TimersMythic(eventInfo)
	timelineEventCount = timelineEventCount + 1
	local durationRounded = self:RoundNumber(eventInfo.duration, 2)
	local barInfo = nil
	if timelineEventCount <= 19 then -- Pull Bars
		if durationRounded == 29 then -- Divine Toll
			barInfo = self:DivineToll()
			barInfo.skipTracking = true
		elseif durationRounded == 26 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion()
		elseif durationRounded == 66 or durationRounded == 12 then -- Avenger's Shield
			barInfo = self:AvengersShield(nil, durationRounded == 66)
		elseif durationRounded == 4 or durationRounded == 57 or durationRounded == 110 then -- Zealous Spirit
			barInfo = self:ZealousSpirit(durationRounded)
			barInfo.skipTracking = true
		elseif durationRounded == 62 then -- Judgement (Red)
			barInfo = self:JudgementRed()
		elseif durationRounded == 58 then -- Judgement (Blue)
			barInfo = self:JudgementBlue()
		elseif durationRounded == 132 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		elseif durationRounded == 30 then -- Sacred Shield
			barInfo = self:SacredShield()
		elseif durationRounded == 135 then -- Tyr's Wrath
			barInfo = self:TyrsWrath()
			barInfo.skipTracking = true
		elseif durationRounded == 7 or durationRounded == 59 then -- Searing Radiance
			barInfo = self:SearingRadiance(nil, durationRounded == 7)
		elseif durationRounded == 20 then -- Sacred Toll
			barInfo = self:SacredToll()
		elseif durationRounded == 15 or durationRounded == 123 then -- Divine Storm
			barInfo = self:DivineStorm(nil, durationRounded == 123)
		elseif durationRounded == 82 then -- Execution Sentence
			barInfo = self:ExecutionSentence()
			barInfo.skipTracking = true
		elseif durationRounded == 79 then -- Aura of Wrath
			barInfo = self:AuraOfWrath()
			barInfo.skipTracking = true
		end
	else
		local combatTime = GetTime() - pullTime
		if combatTime > 179 and combatTime < 181 then
			-- Empowered Searing Radiance sometimes happens here based on spell queueing.
			-- If it is then the DurationRounded can possibly be 159.00. Capture it here to avoid it messing with the modulo rotation below.
			barInfo = self:SearingRadiance(nil, true)
		elseif durationRounded == 159 then -- Some of these get delayed, handle it ourselves.
			-- Zaelous spirit sometimes has a late ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED,
			-- Because of this we cant rely on this event to pass along the next cast.
			-- By capturing all 159.00 durations we avoid any bars starting with the wrong spell.
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if durationEventCount[durationRounded] % 8 == 1 or durationEventCount[durationRounded] % 8 == 4 or durationEventCount[durationRounded] % 8 == 7 then
				barInfo = self:ZealousSpirit(durationRounded)
			elseif durationEventCount[durationRounded] % 8 == 2 then
				barInfo = self:AuraOfDevotion()
			elseif durationEventCount[durationRounded] % 8 == 3 then
				barInfo = self:DivineToll()
			elseif durationEventCount[durationRounded] % 8 == 5 then
				barInfo = self:AuraOfWrath()
			elseif durationEventCount[durationRounded] % 8 == 6 then
				barInfo = self:ExecutionSentence()
			elseif durationEventCount[durationRounded] % 8 == 0 then
				barInfo = self:TyrsWrath()
			end
			barInfo.skipTracking = true
		else
			if combatTime > 107 and combatTime < 114 then
				-- At this point these 3 abilities can happen with a delayed ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED
				if durationRounded == 18 then
					barInfo = self:SacredToll()
				elseif durationRounded == 36 then
					barInfo = self:JudgementBlue()
				elseif durationRounded > 50 then
					barInfo = self:SearingRadiance(nil, true)
				end
			else
				return self:StoreEvent(eventInfo)
			end
		end
	end
	return TrackStored(barInfo)
end

function mod:TimersHeroic(eventInfo)
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	timelineEventCount = timelineEventCount + 1
	local barInfo = nil
	if timelineEventCount <= 12 then -- Pull Bars
		if durationRounded == 10 then -- Sacred Toll
			barInfo = self:SacredToll()
		elseif durationRounded == 15 then -- Avenger's Shield
			barInfo = self:AvengersShield()
		elseif durationRounded == 17 then -- Sacred Shield
			barInfo = self:SacredShield()
		elseif durationRounded == 18 then -- Divine Storm
			barInfo = self:DivineStorm()
		elseif durationRounded == 26 then -- Judgement Blue
			barInfo = self:JudgementBlue()
		elseif durationRounded == 30 and not self:IsWiping() then -- Judgement Red
			barInfo = self:JudgementRed()
		elseif durationRounded == 35 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion()
		elseif durationRounded == 38 then -- Divine Toll
			barInfo = self:DivineToll()
		elseif durationRounded == 47 then -- Searing Radiance
			barInfo = self:SearingRadiance()
		elseif durationRounded == 83 then -- Aura of Wrath
			barInfo = self:AuraOfWrath()
		elseif durationRounded == 86 then -- Execution Sentence
			barInfo = self:ExecutionSentence()
		elseif durationRounded == 131 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		end
	else
		durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
		if durationRounded == 16 and durationEventCount[durationRounded] == 1 then -- this is a judgement which loses track. we re-force it here.
			barInfo = self:JudgementBlue()
		else
			return self:StoreEvent(eventInfo)
		end
	end
	return TrackStored(barInfo)
end

function mod:TimerOther(eventInfo)
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	timelineEventCount = timelineEventCount + 1
	local barInfo = nil
	if timelineEventCount <= 10 then -- Pull Bars
		if durationRounded == 10 then -- Avenger's Shield
			barInfo = self:AvengersShield()
		elseif durationRounded == 17 then -- Sacred Shield
			barInfo = self:SacredShield()
		elseif durationRounded == 23 then -- Sacred Toll
			barInfo = self:SacredToll()
		elseif durationRounded == 26 then -- Judgement Blue
			barInfo = self:JudgementBlue()
		elseif durationRounded == 30 and not self:IsWiping() then -- Judgement Red
			barInfo = self:JudgementRed()
		elseif durationRounded == 35 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion()
		elseif durationRounded == 38 then -- Divine Toll
			barInfo = self:DivineToll()
		elseif durationRounded == 83 then -- Aura of Wrath
			barInfo = self:AuraOfWrath()
		elseif durationRounded == 86 then -- Execution Sentence
			barInfo = self:ExecutionSentence()
		elseif durationRounded == 131 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		end
	else
		return self:StoreEvent(eventInfo)
	end
	return TrackStored(barInfo)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:JudgementBlue()
	local barText = CL.count:format(self:GetRename(1251857), judgementBlueCount)
	judgementBlueCount = judgementBlueCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1251857, "purple", barText)
				self:PlaySound(1251857, "info")
			end
		end,
		key = 1251857,
		this = self.JudgementBlue
	}
end

function mod:JudgementRed()
	local barText = CL.count:format(self:GetRename(1246736), judgementRedCount)
	judgementRedCount = judgementRedCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1246736, "purple", barText)
				self:PlaySound(1246736, "info")
			end
		end,
		key = 1246736,
		this = self.JudgementRed
	}
end

function mod:SacredToll()
	local barText = CL.count:format(self:GetRename(1246749), sacredTollCount)
	sacredTollCount = sacredTollCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1246749, "yellow", barText)
				self:PlaySound(1246749, "warning") -- Deadly in Mythic
			end
		end,
		key = 1246749,
		this = self.SacredToll
	}
end

function mod:AvengersShield(_, empowered)
	local barText = self:GetRename(1246485)
	if empowered then
		barText = self:GetRename("empowered_avengers_shield")
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				if empowered then
					self:Message("empowered_avengers_shield", "red", barText, 1246485)
				else
					self:Message(1246485, "yellow", barText)
				end
				-- Sound from PA's
			end
		end,
		key = empowered and "empowered_avengers_shield" or 1246485,
		icon = 1246485,
		this = self.AvengersShield,
		empowered = empowered
	}
end

function mod:DivineStorm(_, empowered)
	local barText = self:GetRename(1246765)
	if empowered then
		barText = self:GetRename("empowered_divine_storm")
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() and empowered then
				self:Message("empowered_divine_storm", "red", barText, 1246765)
				self:PlaySound("empowered_divine_storm", "alarm")
			end
		end,
		key = empowered and "empowered_divine_storm" or 1246765,
		icon = 1246765,
		this = self.DivineStorm,
		empowered = empowered
	}
end

function mod:SearingRadiance(_, empowered)
	local barText = self:GetRename(1255738)
	if empowered then
		barText = self:GetRename("empowered_searing_radiance")
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				if empowered then
					self:Message("empowered_searing_radiance", "orange", barText, 1255738)
					self:PlaySound("empowered_searing_radiance", "alert")
				else
					self:Message(1255738, "orange", barText)
					self:PlaySound(1255738, "alert")
				end
			end
		end,
		key = empowered and "empowered_searing_radiance" or 1255738,
		icon = 1255738,
		this = self.SearingRadiance,
		empowered = empowered
	}
end

function mod:SacredShield()
	local barText = CL.count:format(self:GetRename(1248674), sacredShieldCount)
	sacredShieldCount = sacredShieldCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248674, "yellow", CL.casting:format(barText))
				self:PlaySound(1248674, "alert") -- break shield
			end
		end,
		key = 1248674,
		this = self.SacredShield
	}
end

function mod:ZealousSpirit(durationRounded)
	local barCount = zealousSpiritCount
	-- Only the three pull casts are told apart by their duration, and a stored event is
	-- never claimed until well after those, so the argument is unused on that path
	if zealousSpiritCount <= 3 then -- it spawns 3 timers on pull (lol)
		barCount = durationRounded == 4 and 1 or durationRounded == 57 and 2 or 3
	end
	local barText = CL.count:format(self:GetRename(1276243), barCount)
	zealousSpiritCount = zealousSpiritCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1276243, "cyan", barText)
				self:PlaySound(1276243, "info") -- new empower
			end
		end,
		key = 1276243
	}
end

function mod:AuraOfWrath()
	local barText = CL.count:format(self:GetRename(1248449), auraWrathCount)
	auraWrathCount = auraWrathCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248449, "cyan", barText)
				self:StopBlizzMessages(0.5)
				self:PlaySound(1248449, "long") -- Aura enabled
			end
		end,
		key = 1248449,
		this = self.AuraOfWrath
	}
end

function mod:ExecutionSentence()
	local spellName = self:Mythic() and self:GetRename(1248983, 1) or self:GetRename(1248983, 2)
	local barText = CL.count:format(spellName, executionCount)
	executionCount = executionCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248983, "red", barText)
				-- Sound on PA's
			end
		end,
		key = 1248983,
		this = self.ExecutionSentence
	}
end

function mod:AuraOfDevotion()
	local barText = CL.count:format(self:GetRename(1246162), auraDevotionCount)
	auraDevotionCount = auraDevotionCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1246162, "cyan", barText)
				self:StopBlizzMessages(0.5)
				self:PlaySound(1246162, "long") -- Aura enabled
			end
		end,
		key = 1246162,
		this = self.AuraOfDevotion
	}
end

function mod:DivineToll()
	local spellName = self:Mythic() and self:GetRename(1248644, 1) or self:GetRename(1248644, 2)
	local barText = CL.count:format(spellName, divineTollCount)
	divineTollCount = divineTollCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248644, "orange", barText)
				self:PlaySound(1248644, "warning") -- Dodge shields
			end
		end,
		key = 1248644,
		this = self.DivineToll
	}
end

function mod:AuraOfPeace(eventInfo)
	local barText = CL.count:format(self:GetRename(1248451), auraPeaceCount)
	auraPeaceCount = auraPeaceCount + 1
	local tyrsCD = eventInfo.duration + 5  -- always 5 seconds after Aura of Peace
	local tyrsBarInfo
	if not self:Mythic() then
		-- Tyr's Wrath is bugged and missing an event/timers, start it here for now. There is no
		-- timeline event behind this bar, so it is started and stopped by hand.
		tyrsBarInfo = self:TyrsWrath()
		if self:ShouldShowBars() then
			self:CDBar(1248710, tyrsCD, tyrsBarInfo.msg)
		end
	end
	return {
		msg = barText,
		onFinished = function()
			if not self:Mythic() then
				if self:ShouldShowBars() then
					-- as this cast can be delayed, update the remaining time and cancel it in 5s
					self:CDBar(1248710, {5, tyrsCD}, CL.count:format(self:GetRename(1248710, 2), tyrsWrathCount - 1))
				end
				self:ScheduleTimer(function()
					self:StopBar(tyrsBarInfo.msg)
				end, 0.5)
			end
			if self:ShouldShowBars() then
				self:Message(1248451, "cyan", barText)
				self:StopBlizzMessages(0.5)
				self:PlaySound(1248451, "long")
			end
		end,
		onCanceled = function()
			if not self:Mythic() then
				-- if the event is canceled, remove the linked Tyr's Wrath timer
				self:StopBar(tyrsBarInfo.msg)
			end
		end,
		key = 1248451,
		this = self.AuraOfPeace
	}
end

function mod:TyrsWrath()
	local spellName = self:Mythic() and self:GetRename(1248710, 1) or self:GetRename(1248710, 2)
	local barText = CL.count:format(spellName, tyrsWrathCount)
	tyrsWrathCount = tyrsWrathCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248710, "orange", barText)
				-- Sound on PA's
			end
		end,
		key = 1248710
	}
end
