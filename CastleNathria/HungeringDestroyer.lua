--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hungering Destroyer", 2296, 2428)
if not mod then return end
mod:RegisterEnableMob(164261) -- Hungering Destroyer
mod:SetEncounterID(2383)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local miasmaCount = 1
local volatileCount = 1
local consumeCount = 1
local expungeCount = 1
local desolateCount = 1
local overwhelmCount = 1
local miasmaPlayerList = {}
local volEjectionList = {}
local scheduledChatMsg = false
local volEjectionOnMe = false
local miasmaOnMe = false
local hasPrinted = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Repeating Miasma Health Yell"
	L.custom_on_repeating_yell_miasma_desc = "Repeating yell messages for Gluttonous Miasma to let others know when you are below 75% health."

	L.custom_on_repeating_say_laser = "Repeating Volatile Ejection Say"
	L.custom_on_repeating_say_laser_desc = "Repeating say messages for Volatile Ejection to help when moving into chat range of players that didn't see your first message."

	L.currentHealth = "%d%%"
	L.currentHealthIcon = "{rt%d}%d%%"

	L.tempPrint = "We've added health yells for Miasma. If you previously used a WeakAura for this, you might want to delete it to prevent double yells."
end

--------------------------------------------------------------------------------
-- Initialization
--

local gluttonousMiasmaMarker = mod:AddMarkerOption(false, "player", 1, 329298, 1, 2, 3, 4) -- Gluttonous Miasma
local volatileEjectionMarker = mod:AddMarkerOption(false, "player", 5, 334266, 5, 6, 7, 8) -- Volatile Ejection
function mod:GetOptions()
	return {
		"berserk",
		{329298, "SAY"}, -- Gluttonous Miasma
		"custom_on_repeating_yell_miasma",
		gluttonousMiasmaMarker,
		{334522, "EMPHASIZE"}, -- Consume
		329725, -- Expunge
		{334266, "SAY", "FLASH", "ME_ONLY_EMPHASIZE"}, -- Volatile Ejection
		"custom_on_repeating_say_laser",
		volatileEjectionMarker,
		329455, -- Desolate
		{329774, "TANK"}, -- Overwhelm
		{332295, "TANK"}, -- Growing Hunger
	}, nil, {
		[329298] = L.miasma, -- Gluttonous Miasma (Miasma)
		[334266] = CL.beam, -- Volatile Ejection (Beam)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GluttonousMiasmaApplied", 329298)
	self:Log("SPELL_AURA_REMOVED", "GluttonousMiasmaRemoved", 329298)
	self:Log("SPELL_CAST_START", "Consume", 334522)
	self:Log("SPELL_CAST_SUCCESS", "ConsumeSuccess", 334522)
	self:Log("SPELL_AURA_APPLIED", "ExpungeApplied", 329725)
	self:Log("SPELL_AURA_APPLIED", "VolatileEjectionApplied", 338614, 334064) -- LFR, everything else
	self:Log("SPELL_AURA_REMOVED", "VolatileEjectionRemoved", 338614, 334064)
	self:Log("SPELL_CAST_START", "VolatileEjection", 334266)
	self:Log("SPELL_CAST_SUCCESS", "VolatileEjectionSuccess", 334266)
	self:Log("SPELL_CAST_START", "Desolate", 329455)
	self:Log("SPELL_CAST_START", "Overwhelm", 329774)
	self:Log("SPELL_AURA_APPLIED", "GrowingHungerApplied", 332295)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingHungerApplied", 332295)

	self:SimpleTimer(function()
		if self:Mythic() and not hasPrinted and IsAddOnLoaded("WeakAuras") then
			hasPrinted = true
			BigWigs:Print(L.tempPrint) -- XXX
		end
	end, 5)
end

function mod:OnEngage()
	miasmaCount = 1
	volatileCount = 1
	consumeCount = 1
	expungeCount = 1
	desolateCount = 1
	overwhelmCount = 1
	scheduledChatMsg = false
	volEjectionOnMe = false
	miasmaOnMe = false
	volEjectionList = {}

	self:Bar(329298, 3, CL.count:format(L.miasma, miasmaCount)) -- Gluttonous Miasma
	if self:Easy() then
		self:Bar(329774, 5.3) -- Overwhelm
		self:Bar(334266, 10.6, CL.count:format(CL.beam, volatileCount)) -- Volatile Ejection
		self:Bar(329455, 23.2, CL.count:format(self:SpellName(329455), desolateCount)) -- Desolate
		self:Bar(329725, 35.7, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		self:Bar(334522, 93.7, CL.count:format(self:SpellName(334522), consumeCount)) -- Consume
	else
		self:Bar(329774, 5) -- Overwhelm
		self:Bar(334266, 10, CL.count:format(CL.beam, volatileCount)) -- Volatile Ejection
		self:Bar(329455, 22, CL.count:format(self:SpellName(329455), desolateCount)) -- Desolate
		self:Bar(329725, 32, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		self:Bar(334522, 89, CL.count:format(self:SpellName(334522), consumeCount)) -- Consume
	end

	if self:Mythic() then
		self:Berserk(420)
	else
		self:Berserk(600)
	end
end

function mod:OnBossDisable()
	volEjectionOnMe = false -- Compensate for the boss dieing mid cast
	miasmaOnMe = false

	if self:GetOption(gluttonousMiasmaMarker) then
		for i = 1, #miasmaPlayerList do
			local name = miasmaPlayerList[i]
			-- Clearing marks on _REMOVED doesn't work great on this boss
			-- The second set of marks is applied before the first is removed
			-- When trying to remove the first set of marks it can clear the second set
			self:CustomIcon(false, name)
		end
	end
	miasmaPlayerList = {}

	-- Compensate for the boss dieing mid cast
	if self:GetOption(volatileEjectionMarker) then
		for i = 1, #volEjectionList do
			local name = volEjectionList[i]
			self:CustomIcon(false, name)
		end
	end
	volEjectionList = {}
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function RepeatingChatMessages()
	local duration = 1.5
	if volEjectionOnMe and mod:GetOption("custom_on_repeating_say_laser") then
		mod:Say(false, CL.beam)
	elseif miasmaOnMe and mod:GetOption("custom_on_repeating_yell_miasma") then -- Repeat Health instead
		local currentHealthPercent = math.floor(mod:GetHealth("player"))
		if currentHealthPercent < 75 then -- Only let players know when you are below 75%
			local myIcon = GetRaidTargetIndex("player")
			local msg = myIcon and L.currentHealthIcon:format(myIcon, currentHealthPercent) or L.currentHealth:format(currentHealthPercent)
			mod:Yell(false, msg, true)
		end
		if not mod:Mythic() then
			duration = 2 -- Slower on non-mythic
		end
	else
		scheduledChatMsg = false
		return -- Nothing had to be repeated, stop repeating
	end
	mod:SimpleTimer(RepeatingChatMessages, duration)
end

do
	local prev = 0
	function mod:GluttonousMiasmaApplied(args)
		if self:MobId(args.sourceGUID) == 164261 then -- Boss only, filter trash
			local t = args.time
			if t-prev > 3 then
				prev = t
				miasmaPlayerList = {}
				miasmaCount = miasmaCount + 1
				self:Bar(args.spellId, 24, CL.count:format(L.miasma, miasmaCount))
			end

			local count = #miasmaPlayerList+1
			miasmaPlayerList[count] = args.destName
			miasmaPlayerList[args.destName] = count -- Set raid marker
			if self:Me(args.destGUID) then
				miasmaOnMe = true
				self:Yell(args.spellId, CL.count_rticon:format(L.miasma, count, count))
				self:PlaySound(args.spellId, "alarm")
				if not scheduledChatMsg and not self:LFR() and self:GetOption("custom_on_repeating_yell_miasma") then
					scheduledChatMsg = true
					self:SimpleTimer(RepeatingChatMessages, 2)
				end
			end
			self:CustomIcon(gluttonousMiasmaMarker, args.destName, count)
			self:NewTargetsMessage(args.spellId, "yellow", miasmaPlayerList, nil, CL.count:format(L.miasma, miasmaCount-1))
		end
	end

	function mod:GluttonousMiasmaRemoved(args)
		if self:Me(args.destGUID) then
			miasmaOnMe = false
		end
	end
end

function mod:Consume(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, consumeCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, consumeCount)) -- 4s Cast
	consumeCount = consumeCount + 1
	if self:Easy() then
		self:Bar(args.spellId, 101, CL.count:format(args.spellName, consumeCount))
	else
		self:Bar(args.spellId, 96, CL.count:format(args.spellName, consumeCount))
	end
end

function mod:ConsumeSuccess(args)
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, consumeCount-1)) -- 6s Channel
end

do
	local prev = 0
	function mod:ExpungeApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "orange", CL.count:format(args.spellName, expungeCount)) -- Expunge
			self:PlaySound(args.spellId, "warning")
			self:CastBar(args.spellId, 5, CL.count:format(args.spellName, expungeCount)) -- Expunge
			expungeCount = expungeCount + 1
			if self:Easy() then
				self:Bar(args.spellId, expungeCount % 2 == 0 and 37.8 or 63, CL.count:format(args.spellName, expungeCount))
			else
				self:Bar(args.spellId, expungeCount % 2 == 0 and 36 or 60, CL.count:format(args.spellName, expungeCount))
			end
		end
	end
end

do
	function mod:VolatileEjectionApplied(args)
		local count = #volEjectionList+1
		volEjectionList[count] = args.destName
		self:NewTargetsMessage(334266, "orange", volEjectionList, self:Mythic() and 4 or 3, CL.beam)
		self:CustomIcon(volatileEjectionMarker, args.destName, count+4)
		if self:Me(args.destGUID) then
			self:PlaySound(334266, "warning")
			self:Flash(334266)
			self:Say(334266, CL.beam)
			volEjectionOnMe = true
			if not scheduledChatMsg and not self:LFR() and self:GetOption("custom_on_repeating_say_laser") then
				scheduledChatMsg = true
				self:SimpleTimer(RepeatingChatMessages, 1.5)
			end
		end
	end

	function mod:VolatileEjectionRemoved(args)
		if self:Me(args.destGUID) then
			volEjectionOnMe = false
		end
	end

	function mod:VolatileEjection()
		volatileCount = volatileCount + 1
		if self:Easy() then
			self:Bar(334266, volatileCount % 3 == 1 and 25.3 or 37.9, CL.count:format(CL.beam, volatileCount))
		else
			self:Bar(334266, volatileCount % 3 == 1 and 24 or 36, CL.count:format(CL.beam, volatileCount))
		end
	end

	function mod:VolatileEjectionSuccess()
		if self:GetOption(volatileEjectionMarker) then
			for i = 1, #volEjectionList do
				local name = volEjectionList[i]
				self:CustomIcon(false, name)
			end
		end
		volEjectionList = {}
		volEjectionOnMe = false
	end
end

function mod:Desolate(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, desolateCount))
	self:PlaySound(args.spellId, "alert")
	desolateCount = desolateCount + 1
	if self:Easy() then
		self:Bar(args.spellId, desolateCount % 2 == 0 and 37.9 or 63.1, CL.count:format(args.spellName, desolateCount)) -- Desolate
	else
		self:Bar(args.spellId, desolateCount % 2 == 0 and 36 or 60, CL.count:format(args.spellName, desolateCount)) -- Desolate
	end
end

function mod:Overwhelm(args)
	self:TargetMessage(args.spellId, "purple", self:UnitName("boss1target"), CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	overwhelmCount = overwhelmCount + 1
	if self:Easy() then
		self:Bar(args.spellId, overwhelmCount % 7 == 1 and 25.2 or 12.6) -- Delayed by Consume every 7th
	else
		self:Bar(args.spellId, overwhelmCount % 7 == 1 and 24 or 12) -- Delayed by Consume every 7th
	end
end

function mod:GrowingHungerApplied(args)
	local amount = args.amount or 1
	if amount % 5 == 0 then -- 5, 10... // Generally doesn't go above 5 if you swap on Overwhelm
		self:NewStackMessage(args.spellId, "purple", args.destName, amount)
		self:PlaySound(args.spellId, "alert")
	end
end
