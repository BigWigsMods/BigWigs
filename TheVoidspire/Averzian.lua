
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Averzian", 2912, 2733)
if not mod then return end
mod:RegisterEnableMob(240435) -- Imperator Averzian
mod:SetEncounterID(3176)
-- mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1255680, sound = "alarm"}, -- Gnashing Void
	{1275059, sound = "alert"}, -- Black Miasma
	{1249265, 1260203}, -- Umbral Collapse (Targetted)
	-- {1249309, sound = "alarm"}, -- Umbral Collapse (DoT effect), still used?
	-- {1249716, 1265398}, -- Umbral Collapse (Unknown Aura)
	1280023, -- Void Marked
	{1280075, sound = "info"}, -- Lingering Darkness (DoT effect after dispel)
	{1260981, sound = "underyou"}, -- March of the Endless
	{1265540, sound = "alarm"}, -- Blackening Wounds
	1283069, -- Weakened
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local durationEventCount = {}

local shadowAdvanceCount = 1
local umbralCollapseCount = 1
local voidMarkedCount = 1
local oblivionsWrathCount = 1
local voidFallCount = 1
local darkUpheavalCount = 1

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1251361, -- Shadow's Advance
		1249262, -- Umbral Collapse
		1280015, -- Void Marked
		1260712, -- Oblivion's Wrath
		1258883, -- Void Fall
		1249251, -- Dark Upheaval
	},{

	},
	{
		[1251361] = CL.adds, -- Shadow's Advance (Adds)
		[1249262] = CL.soak, -- Umbral Collapse (Soak)
		[1280015] = CL.marks, -- Void Marked (Marks)
		[1260712] = CL.dodge, -- Oblivion's Wrath (Dodge)
		[1258883] = CL.knockback, -- Void Fall (Knockback)
		[1249251] = CL.raid_damage, -- Dark Upheaval (Raid Damage)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	durationEventCount = {}

	shadowAdvanceCount = 1
	umbralCollapseCount = 1
	voidMarkedCount = 1
	oblivionsWrathCount = 1
	voidFallCount = 1
	darkUpheavalCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	local duration = eventInfo.duration
	local barInfo
	if duration == 160 then -- Void Fall
		barInfo = self:VoidFall(eventInfo)
		-- This starts a new rotation, reset counters
		durationEventCount = {}
	elseif duration == 94 or duration == 14 then -- Shadow's Advance
		barInfo = self:ShadowsAdvance(eventInfo)
	elseif duration == 20 then -- Void Marked
		barInfo = self:VoidMarked(eventInfo)
	elseif duration == 4 or duration == 48 or duration == 36 then -- Dark Upheaval
		barInfo = self:DarkUpheaval(eventInfo)
	elseif duration == 32 then -- Umbral Collapse
		barInfo = self:UmbralCollapse(eventInfo)
	elseif duration == 60 or duration == 18 then -- Oblivion's Wrath
		barInfo = self:OblivionsWrath(eventInfo)
	elseif duration == 80 then -- Void Marked, Umbral Collapse, Shadow's Advance (after first stage)
		durationEventCount[duration] = (durationEventCount[duration] or 0) + 1
		if (voidFallCount == 2 and durationEventCount[duration] == 1)
		or (voidFallCount >= 3 and durationEventCount[duration] == 2) then -- Void Marked
			barInfo = self:VoidMarked(eventInfo)
		elseif (voidFallCount == 2 and durationEventCount[duration] == 2)
		or (voidFallCount >= 3 and durationEventCount[duration] == 3) then -- Umbral Collapse
			barInfo = self:UmbralCollapse(eventInfo)
		elseif voidFallCount >= 3 and durationEventCount[duration] == 1 then -- Shadow's Advance
			barInfo = self:ShadowsAdvance(eventInfo)
		end
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 2 or state == 3 then -- Finished or Canceled
			self:StopBar(barInfo.msg)

			if state == 2 and self:ShouldShowBars() and barInfo.callback then -- Finished
				barInfo.callback()
			end

			activeBars[eventID] = nil
		end
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

function mod:ShadowsAdvance(eventInfo)
	local count = shadowAdvanceCount
	-- 94 and 14 appear on pull - where 94 should be bar number 2 and 14 should be bar number 1
	-- 14 also apears every reset
	if eventInfo.duration == 94 then
		count = 2
	elseif eventInfo.duration == 14 and shadowAdvanceCount <= 1 then
		count = 1
	end
	local barText = CL.count:format(CL.adds, shadowAdvanceCount)
	if self:ShouldShowBars() then
		self:Bar(1251361, eventInfo.duration, barText, nil, eventInfo.id)
	end
	shadowAdvanceCount = shadowAdvanceCount + 1
	return {
		msg = barText,
		key = 1251361,
		callback = function()
			self:Message(1251361, "cyan", barText)
			self:PlaySound(1251361, "long")
		end
	}
end

function mod:UmbralCollapse(eventInfo)
	local barText = CL.count:format(CL.soak, umbralCollapseCount)
	if self:ShouldShowBars() then
		self:Bar(1249262, eventInfo.duration, barText, nil, eventInfo.id)
	end
	umbralCollapseCount = umbralCollapseCount + 1
	return {
		msg = barText,
		key = 1249262,
		callback = function()
			self:Message(1249262, "orange", barText)
			self:PlaySound(1249262, "warning")
		end
	}
end

function mod:VoidMarked(eventInfo)
	local barText = CL.count:format(CL.marks, voidMarkedCount)
	if self:ShouldShowBars() then
		self:Bar(1280015, eventInfo.duration, barText, nil, eventInfo.id)
	end
	voidMarkedCount = voidMarkedCount + 1
	return {
		msg = barText,
		key = 1280015,
		callback = function()
			self:Message(1280015, "yellow", barText)
			-- Sound on PAs
		end
	}
end

function mod:OblivionsWrath(eventInfo)
	local barText = CL.count:format(CL.dodge, oblivionsWrathCount)
	if self:ShouldShowBars() then
		self:Bar(1260712, eventInfo.duration, barText, nil, eventInfo.id)
	end
	oblivionsWrathCount = oblivionsWrathCount + 1
	return {
		msg = barText,
		key = 1260712,
		callback = function()
			self:Message(1260712, "purple", barText)
			self:PlaySound(1260712, "alarm")
		end
	}
end

function mod:VoidFall(eventInfo)
	local barText = CL.count:format(CL.knockback, voidFallCount)
	if self:ShouldShowBars() then
		self:Bar(1258883, eventInfo.duration, barText, nil, eventInfo.id)
	end
	voidFallCount = voidFallCount + 1
	return {
		msg = barText,
		key = 1258883,
		callback = function()
			self:Message(1258883, "cyan", barText)
			self:PlaySound(1258883, "long")
		end
	}
end

function mod:DarkUpheaval(eventInfo)
	local barText = CL.count:format(CL.raid_damage, darkUpheavalCount)
	if self:ShouldShowBars() then
		self:Bar(1249251, eventInfo.duration, barText, nil, eventInfo.id)
	end
	darkUpheavalCount = darkUpheavalCount + 1
	return {
		msg = barText,
		key = 1249251,
		callback = function()
			self:Message(1249251, "yellow", barText)
			self:PlaySound(1249251, "alert")
		end
	}
end
