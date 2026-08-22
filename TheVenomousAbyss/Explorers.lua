
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Lost Explorers", 3004, 2894)
if not mod then return end
mod:RegisterEnableMob(261835, 261843, 261848) -- First Mate Nama, Scrollsage Iku, Trader Gebbo
mod:SetEncounterID(3497)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

-- Staging is kind of weird for this fight, stage 1 is unempowered time, with each other stage tied to a empowered turtle phase
local UNIT_TO_STAGE = {
	boss1 = 2, -- Gebbo
	boss3 = 3, -- Nama
	boss4 = 4, -- Iku
}

local durationEventCount = {}
local currentChannelStart = nil
local currentChannelID = nil

local ascensionCount = 1
local blinkNovaCount = 1
local iceboundFlamesCount = 1
local frostfireVolleyCount = 1
local shellSpinCount = 1
local mightyThudCount = 1
local throwJunkCount = 1
local mushroomTossCount = 1
local explosiveSurpriseCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({
	trader_gebbo = "Gebbo",
	first_mate_nama = "Nama",
	scrollsage_iku = "Iku",
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1296535] = { -- Disgusting Fish
		CL.you:format(mod:SpellName(1296535)),
		CL.other:format(mod:SpellName(1296535), L.trader_gebbo), -- Fish: Gebbo
		CL.other:format(mod:SpellName(1296535), L.first_mate_nama), -- Fish: Nama
		CL.other:format(mod:SpellName(1296535), L.scrollsage_iku), -- Fish: Iku
		original = {
			false,
			CL.other:format(mod:SpellName(1296535), mod:SpellName(-35742)),
			CL.other:format(mod:SpellName(1296535), mod:SpellName(-35764)),
			CL.other:format(mod:SpellName(1296535), mod:SpellName(-35729)),
		},
		-- notes = {},
	},
	[1297022] = { -- Mor'zahi's Command
		CL.over:format(mod:SpellName(47257)), -- Empower over
		CL.other:format(mod:SpellName(47257), L.trader_gebbo), -- Empower: Gebbo
		CL.other:format(mod:SpellName(47257), L.first_mate_nama), -- Empower: Nama
		CL.other:format(mod:SpellName(47257), L.scrollsage_iku), -- Empower: Iku
		original = {
			CL.over:format(mod:SpellName(1297022)),
			CL.other:format(mod:SpellName(1297022), mod:SpellName(-35742)),
			CL.other:format(mod:SpellName(1297022), mod:SpellName(-35764)),
			CL.other:format(mod:SpellName(1297022), mod:SpellName(-35729)),
		},
		-- notes = {},
	},
	[1292779] = {1292779}, -- Final Ascension

	[1290711] = {1290711, CL.you:format(mod:SpellName(1290711)), original = false}, -- Blink Nova
	[1286921] = {1286921}, -- Icebound Flames
	[1295854] = {1295854}, -- Shredding Shards
	[1295886] = {1295886}, -- Frostfire Volley
	[1291390] = {1291390}, -- Cataclysmic Invocation

	[1291759] = {1291759}, -- Shell Spin
	[1296092] = {1296092}, -- Mighty Thud

	[1291933] = {1291933}, -- Throw Junk
	[1295817] = {1295817}, -- Fling Fish
	[1292104] = {1292104}, -- Mushroom Toss
	[1296249] = {1296249}, -- Explosive Surprise
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1295928, soundOnApplied = "warning", header = CL.important}, -- Burning Flames (Fire debuff, clears ice)
	{1295954, soundOnApplied = "warning"}, -- Piercing Frost (Ice debuff, clears fire)
	{1295935, soundOnApplied = "warning", duration = 8}, -- Frostfire Volley (Frost - Targetted)
	{1295886, soundOnApplied = "warning", duration = 8}, -- Frostfire Volley (Fire - Targetted)
	{1296025, soundOnApplied = "warning", duration = 7}, -- Blink Nova (Targetted)
	{1297625, soundOnApplied = "warning", duration = 10}, -- Explosive Surprise (Targeted)
	{1296092, soundOnApplied = "warning"}, -- Mighty Thud (Targeted) XXX not applied to players?
	{1295858, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.general, note = CL.tank_debuff}, -- Shredding Shards
	{1310500, soundOnApplied = "none"}, -- Aftershock
	{1305844, soundOnApplied = "underyou"}, -- Blast Wave (Explosion DoT)
	{1299854, soundOnApplied = "none"}, -- Bounce (Mushroom bounce)
	{1291390, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Cataclysmic Invocation
	{1295952, soundOnApplied = "none"}, -- Elemental Explosion
	{1297649, soundOnApplied = "none"}, -- Fire Patch (Standing in ice)
	{1297648, soundOnApplied = "none"}, -- Frost Patch (Standing in fire)
	{1286922, soundOnApplied = "alarm"}, -- Icebound Flames
	{1291918, soundOnApplied = "underyou"}, -- Shell Spin (Stunned)
	{1308853, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Splinters (Junk stacks)
	{1297650, soundOnApplied = "none"}, -- Spreading Flames
	{1291929, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Steady Strikes
})


function mod:GetOptions()
	return {
		-- Mor'zahi
		{1296535, "ME_ONLY_EMPHASIZE"}, -- Disgusting Fish
		1297022, -- Mor'zahi's Command
		1292779, -- Final Ascension

		-- Scrollsage Iku
		{1290711, "ME_ONLY_EMPHASIZE"}, -- Blink Nova
		1286921, -- Icebound Flames
		{1295854, "TANK"}, -- Shredding Shards
		1295886, -- Frostfire Volley
		1291390, -- Cataclysmic Invocation

		-- First Mate Nama
		1291759, -- Shell Spin
		1296092, -- Mighty Thud

		-- Trader Gebbo
		1291933, -- Throw Junk
		1295817, -- Fling Fish
		1292104, -- Mushroom Toss
		1296249, -- Explosive Surprise
	}, {
		[1290711] = -35729, -- Scrollsage Iku
		[1291759] = -35764, -- First Mate Nama
		[1291933] = -35742, -- Trader Gebbo
		[1292779] = -35748, -- Mor'zahi
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	self:SetStage(1)
	self:ResetCounts()
	ascensionCount = 1

	currentChannelID = nil

	self:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
	-- boss units: 1 gebbo, 2 mor'zani, 3 nama, 4 iku
	self:RegisterUnitEvent("UNIT_FLAGS", "CheckStage", "boss1", "boss3", "boss4")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", nil, "boss2")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", nil, "boss2")
end

function mod:ResetCounts()
	durationEventCount = {}

	blinkNovaCount = 1
	iceboundFlamesCount = 1
	frostfireVolleyCount = 1
	shellSpinCount = 1
	mightyThudCount = 1
	throwJunkCount = 1
	mushroomTossCount = 1
	explosiveSurpriseCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

do
	local scheduled = nil
	local events = {}
	local function dispatch()
		scheduled = nil
		for i = 1, #events do
			local eventInfo = events[i]
			mod:Timeline(nil, eventInfo, events)
		end
		table.wipe(events)
	end
	function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
		if eventInfo.source ~= 0 or self:IsWiping() then return end
		if not scheduled then
			scheduled = true
			C_Timer.After(0, dispatch)
		end
		events[#events + 1] = eventInfo
		return false
	end
end

local function ContainsIf(tbl, pred, delta)
	delta = delta or 0.5
	for k, v in next, tbl do
		if (pred - delta) < v.duration and v.duration < (pred + delta) then
			local state = mod:GetTimelineEventState(v.id)
			if state and state < 2 then
				return true
			end
		end
	end
	return false
end

local function GetStageFromEvents(events)
	if not events or #events < 3 then return end

	-- Check the event list for events unique to the boss.
	if ContainsIf(events, 60) then
		return 1 -- Final Accension
	elseif ContainsIf(events, 27) then
		return 2 -- Gebbo
	elseif ContainsIf(events, 11) then
		return 3 -- Nama
	elseif ContainsIf(events, 16) then
		return 4 -- Iku
	end
end

function mod:Timeline(_, eventInfo, events)
	local barInfo

	local stage = self:GetStage()
	local checkStage = GetStageFromEvents(events)

	if checkStage and checkStage ~= stage then
		self:StopBar(self:GetRename(1297022, checkStage)) -- Empower: Turtle

		stage = checkStage
		self:SetStage(stage)
		self:ResetCounts()

		self:Message(1297022, "cyan", self:GetRename(1297022, stage), false) -- Mor'zahi's Command: Turtle
		if currentChannelStart then
			local commandCD = (currentChannelStart + 60) - GetTime()
			self:Bar(1297022, commandCD, self:GetRename(1297022, 1)) -- Empower over
		end
		self:PlaySound(1297022, "long")
	end

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	-- Unempowered
	if stage == 1 then
		if rounded == 60 then
			barInfo = self:FinalAscension()
		elseif rounded == 20 or rounded == 4 or rounded == 27 or rounded == 23 then
			barInfo = self:ThrowJunk(duration)
			if rounded == 20 then
				self:FlingFish()
			elseif rounded == 4 and throwJunkCount == 4 then
				-- Throw Junk cast with the fish. Cancels instead of finishes (like the original event)
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 30 then
			barInfo = self:ShreddingShards()
		elseif rounded == 10 then
			barInfo = self:BlinkNova()
		elseif rounded == 18 or rounded == 16 or rounded == 15 then
			barInfo = self:ShellSpin()
		elseif rounded == 5 then
			barInfo = self:IceboundFlames()
		elseif rounded == 31 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:IceboundFlames()
			elseif count == 2 then
				barInfo = self:BlinkNova()
			end
		end

	-- Gebbu
	elseif stage == 2 then
		if rounded == 30 then
			barInfo = self:ShreddingShards()
		elseif rounded == 2 or rounded == 16 then
			barInfo = self:IceboundFlames()
		elseif rounded == 3 then
			barInfo = self:MushroomToss()
		elseif rounded == 27 or rounded == 4 then
			barInfo = self:ThrowJunk(duration)
		elseif rounded == 13 then
			barInfo = self:ExplosiveSurprise()
		elseif rounded == 11 or rounded == 17 or rounded == 15 or rounded == 7 then
			barInfo = self:ShellSpin()
		elseif rounded == 32 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:MushroomToss()
			elseif count == 2 then
				barInfo = self:ShellSpin()
			elseif count == 3 then
				barInfo = self:ExplosiveSurprise()
			elseif count == 4 then
				barInfo = self:IceboundFlames()
			end
		end

	-- Nama
	elseif stage == 3 then
		if rounded == 20 or rounded == 4 or rounded == 27 then
			barInfo = self:ThrowJunk(duration)
		elseif rounded == 3 or rounded == 32 then
			barInfo = self:MightyThud()
		elseif rounded == 30 then
			barInfo = self:ShreddingShards()
		elseif rounded == 11 or rounded == 5 or rounded == 22 then
			barInfo = self:IceboundFlames()
		end

	-- Iku
	elseif stage == 4 then
		if rounded == 7 or rounded == 4 or rounded == 11 or rounded == 23 then
			barInfo = self:ThrowJunk(duration)
		elseif rounded == 30 then
			barInfo = self:ShreddingShards()
		elseif rounded == 21 then
			barInfo = self:BlinkNova()
		elseif rounded == 2 or rounded == 13 then
			barInfo = self:IceboundFlames()
		elseif rounded == 17 or rounded == 16 then
			barInfo = self:ShellSpin()
		elseif rounded == 8 then
			barInfo = self:FrostfireVolley()
		elseif rounded == 27 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:FrostfireVolley()
			elseif count == 2 then
				barInfo = self:IceboundFlames()
			elseif count == 3 then
				barInfo = self:ShellSpin()
			end
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
	local state = C_EncounterTimeline.GetEventState(eventID)

	local barInfo = activeBars[eventID]
	if barInfo then
		if state == 2 then -- Finished
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onFinished and self:ShouldShowBars() then
				barInfo:onFinished()
			end
		elseif state == 3 then -- Canceled
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onCanceled and self:ShouldShowBars() then
				barInfo:onCanceled()
			end
		end
	elseif backupBars[eventID] then
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
	activeBars[eventID] = nil
	backupBars[eventID] = nil
end

function mod:StopTimelineBar(barInfo, finished)
	if barInfo then
		self:StopBar(barInfo.msg)
		if finished and barInfo.onFinished and self:ShouldShowBars() and not self:IsWiping() then
			barInfo:onFinished()
		end
		activeBars[barInfo.eventID] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- friendly -> ~4s -> channel stop (Empower) -> channel start (Mor'zahi's Command) -> ~2s -> timers -> enemy

function mod:CheckStage(event, unit, isFriend)
	self:Debug(event, unit, "UnitIsFriend:" .. tostring(UnitIsFriend("player", unit)), "UnitCanAttack:" .. tostring(UnitCanAttack("player", unit)))
	if self.isWinning then return end -- they go friendly after they are all dead D; (in the gap between :Win and :Disable)

	if UnitIsFriend("player", unit) or isFriend then
		local stage = UNIT_TO_STAGE[unit]
		self:Message(1296535, "green", self:GetRename(1296535, stage)) -- Disgusting Fish: Turtle
		self:PlaySound(1296535, "info")

		self:CDBar(1297022, 6.2, self:GetRename(1297022, stage)) -- Empower: Turtle
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_START(event, unit, _, _, castID)
	currentChannelID = castID
	currentChannelStart = GetTime()
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP(event, unit, _, _, _, castID)
	if castID == currentChannelID then
		currentChannelID = nil

		if self:GetStage() ~= 1 and not self:IsWiping() then
			self:StopBar(self:GetRename(1297022, 1)) -- Empower over

			self:SetStage(1)
			self:ResetCounts()

			self:Message(1297022, "green", self:GetRename(1297022, 1), false) -- Mor'zahi's Command over
			self:PlaySound(1297022, "long")
		end
	end
end

do
	local prev = 0
	function mod:UPDATE_EXTRA_ACTIONBAR()
		local t = GetTime()
		if t - prev > 35 and C_ActionBar.HasExtraActionBar() then -- luacheck: ignore
			prev = t
			self:PersonalMessage(1296535, false, self:GetRename(1296535, 1)) -- Digusting Fish
			self:PlaySound(1296535, "info")
		end
	end
end

-- Mor'zahi

function mod:FinalAscension()
	local barText = CL.count:format(self:GetRename(1292779), ascensionCount)
	ascensionCount = ascensionCount + 1
	return {
		msg = barText,
		key = 1292779,
		onFinished = function()
			self:Message(1292779, "red", barText)
			self:PlaySound(1292779, "alarm")
		end,
	}
end

-- Scrollsage Iku

function mod:BlinkNova()
	local barText = CL.count:format(self:GetRename(1290711), blinkNovaCount)
	blinkNovaCount = blinkNovaCount + 1
	return {
		msg = barText,
		key = 1290711,
		onFinished = function()
			local timer = self:ScheduleTimer(function()
				local target = _G.UnitSpellTargetName("boss4")
				if target then
					self:SecretTargetMessage(1290711, "yellow", "boss4", barText)
				else
					self:Message(1290711, "yellow", barText)
				end
			end, 0.35)
			-- Scrollsage Iku targets you with [Blink Nova]!
			self:PersonalMessageFromBlizzMessage(1290711, 0.3, false, self:GetRename(1290711, 2), nil, nil, function() self:CancelTimer(timer) end)
		end,
	}
end

function mod:IceboundFlames()
	local barText = CL.count:format(self:GetRename(1286921), iceboundFlamesCount)
	iceboundFlamesCount = iceboundFlamesCount + 1
	return {
		msg = barText,
		key = 1286921,
		onFinished = function()
			self:Message(1286921, "yellow", barText)
			-- local canInterrupt, ready = self:Interrupter()
			-- if canInterrupt and ready then
			-- 	self:PlaySound(1286921, "alert")
			-- end
		end,
	}
end

function mod:ShreddingShards()
	local barText = self:GetRename(1295854)
	return {
		msg = barText,
		key = 1295854,
		onFinished = function()
			self:Message(1295854, "purple", barText)
			self:PlaySound(1295854, "alert")
		end,
	}
end

function mod:FrostfireVolley()
	local barText = CL.count:format(self:GetRename(1295886), frostfireVolleyCount)
	frostfireVolleyCount = frostfireVolleyCount + 1
	return {
		msg = barText,
		key = 1295886,
		onFinished = function()
			self:Message(1295886, "orange", barText)
			-- self:PlaySound(1295886, "alarm")
		end,
	}
end

function mod:CataclysmicInvocation()
	local barText = self:GetRename(1291390)
	return {
		msg = barText,
		key = 1291390,
		onFinished = function()
			self:Message(1291390, "red", barText)
			self:PlaySound(1291390, "alarm")
		end,
	}
end

-- First Mate Nama

function mod:ShellSpin()
	local barText = CL.count:format(self:GetRename(1291759), shellSpinCount)
	shellSpinCount = shellSpinCount + 1
	return {
		msg = barText,
		key = 1291759,
		onFinished = function()
			self:StopBlizzMessages(1) -- First Mate Nama spins [Shell Spin]!
			self:Message(1291759, "orange", barText)
			self:PlaySound(1291759, "alarm")
		end,
	}
end

function mod:MightyThud()
	local barText = CL.count:format(self:GetRename(1296092), mightyThudCount)
	mightyThudCount = mightyThudCount + 1
	return {
		msg = barText,
		key = 1296092,
		onFinished = function()
			self:Message(1296092, "orange", barText)
			self:PlaySound(1296092, "alert")
		end,
	}
end

-- Trader Gebbo

do
	local fishTimer = nil

	function mod:ThrowJunk(duration)
		local barText = CL.count:format(self:GetRename(1291933), throwJunkCount)
		throwJunkCount = throwJunkCount + 1
		return {
			msg = barText,
			key = 1291933,
			onFinished = function()
				self:Message(1291933, "yellow", barText)
				self:PlaySound(1291933, "alert")
			end,
			onCanceled = function()
				-- Cancel Fling Fish if Throw Junk is canceled while it is running
				if fishTimer then
					self:StopBar(self:GetRename(1295817))
					self:CancelTimer(fishTimer)
					fishTimer = nil
				end
			end,
		}
	end

	function mod:FlingFish()
		local duration = 28
		self:Bar(1295817, duration)
		fishTimer = self:ScheduleTimer(function()
			self:Message(1295817, "green")
			-- self:PlaySound(1295817, "info") -- same time as Throw Junk
			fishTimer = nil
		end, duration)
	end
end

function mod:MushroomToss()
	local barText = CL.count:format(self:GetRename(1292104), mushroomTossCount)
	mushroomTossCount = mushroomTossCount + 1
	return {
		msg = barText,
		key = 1292104,
		onFinished = function()
			self:Message(1292104, "green", barText)
			self:PlaySound(1292104, "info")
		end,
	}
end

function mod:ExplosiveSurprise()
	local barText = CL.count:format(self:GetRename(1296249), explosiveSurpriseCount)
	explosiveSurpriseCount = explosiveSurpriseCount + 1
	return {
		msg = barText,
		key = 1296249,
		onFinished = function()
			self:Message(1296249, "red", barText)
			self:PlaySound(1296249, "alarm")
		end,
	}
end
