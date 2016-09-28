
--------------------------------------------------------------------------------
-- TODO List:
-- - Fix all the timers!

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Xavius", 1094, 1726)
if not mod then return end
mod:RegisterEnableMob(103769)
mod.engageId = 1864
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local lurkingEruption = 1
local horrorCount = 0
local isInDream = false
local bladeList, bondList = mod:NewTargetList(), mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_off_blade_marker = "Nightmare Blade marker"
	L.custom_off_blade_marker_desc = "Mark the targets of Nightmare Blades with {rt1}{rt2}, requires promoted or leader."
	L.custom_off_blade_marker_icon = 1

	L.horror = -12973

	L.linked = "Bonds of Terror on YOU! - Linked with %s!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"berserk",
		"stages",
		"altpower",
		208431, -- Decent Into Madness
		207409, -- Madness
		206005, -- Dream Simulacrum

		--[[ Corruption Horror ]]--
		{224649, "TANK"}, -- Tormenting Swipe
		207830, -- Corruption Nova

		--[[ Stage One: The Decent Into Madness ]]--
		{206651, "TANK_HEALER"}, -- Darkening Soul
		{211802, "SAY", "FLASH"}, -- Nightmare Blades
		"custom_off_blade_marker",
		210264, -- Manifest Corruption
		205771, -- Tormenting Fixation
		205741, -- Lurking Eruption (Lurking Terror)

		--[[ Stage Two: From the Shadows ]]--
		{209034, "SAY", "FLASH", "PROXIMITY"}, -- Bonds of Terror
		224508, -- Corruption Meteor
		{209158, "TANK_HEALER"}, -- Blackening Soul
		{209443, "TANK"}, --Nightmare Infusion
		205588, -- Call of Nightmares

		--[[ Stage Three: World of Darkness ]]--
		226194, -- Writhing Deep
	},{
		["berserk"] = "general",
		[206651] = -12971, -- Stage One: The Decent Into Madness
		[209034] = -13152, -- Stage Two: From the Shadows
		[226194] = -13160, -- Stage Three: World of Darkness
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "DecentIntoMadness", 208431)
	self:Log("SPELL_AURA_APPLIED", "Madness", 207409)
	self:Log("SPELL_AURA_APPLIED", "DreamSimulacrum", 206005)
	self:Log("SPELL_AURA_REMOVED", "DreamSimulacrumRemoved", 206005)

	--[[ Stage One: The Decent Into Madness ]]--
	self:Log("SPELL_AURA_APPLIED", "DarkeningSoul", 206651)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkeningSoul", 206651)
	self:Log("SPELL_AURA_APPLIED", "NightmareBlades", 211802)
	self:Log("SPELL_AURA_REMOVED", "NightmareBladesRemoved", 211802)
	self:Log("SPELL_CAST_START", "ManifestCorruption", 210264)
	self:Log("SPELL_AURA_APPLIED", "TormentingFixation", 205771)
	self:Log("SPELL_SUMMON", "LurkingEruption", 205741) -- Lurking Terror

	--[[ Corruption Horror ]]--
	self:Log("SPELL_CAST_SUCCESS", "TormentingSwipe", 224649)
	self:Log("SPELL_CAST_SUCCESS", "CorruptingNova", 207830)

	--[[ Stage Two: From the Shadows ]]--
	self:Log("SPELL_AURA_APPLIED", "CorruptionMeteor", 224508)
	self:Log("SPELL_AURA_APPLIED", "BondsOfTerror", 209034, 210451) -- 2 debuffs, 1st id could also be used for spellcast events
	self:Log("SPELL_AURA_REMOVED", "BondsOfTerrorRemoved", 209034, 210451)
	self:Log("SPELL_AURA_APPLIED", "BlackeningSoul", 209158)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlackeningSoul", 209158)
	self:Log("SPELL_AURA_APPLIED", "NightmareInfusion", 209443)
	self:Log("SPELL_CAST_SUCCESS", "CallOfNightmares", 205588)

	--[[ Stage Three: World of Darkness ]]--
	self:Log("SPELL_CAST_SUCCESS", "WrithingDeep", 226194)
end

function mod:OnEngage()
	phase = 1
	lurkingEruption = 1 -- Purposely init at 1
	horrorCount = 0
	isInDream = false
	wipe(bladeList)
	wipe(bondList)
	self:Bar(206651, 7.5) -- Darkening Soul
	self:Bar(211802, 19.2) -- Nightmare Blades
	self:Bar(210264, 59) -- Manifest Corruption
	self:Bar(205741, 18) -- Lurking Eruption (Lurking Terror)

	self:OpenAltPower("altpower", 208931) -- Nightmare Corruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 226193 then -- Xavius Energize Phase 2
		phase = 2
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
		self:StopBar(206651) -- Darkening Soul
		self:StopBar(211802) -- Nightmare Blades
		self:StopBar(210264) -- Manifest Corruption
		self:StopBar(205741) -- Lurking Eruption (Lurking Terror)
		self:Bar(209034, 7.5) -- Bonds of Terror
		self:Bar(209443, 29) -- Nightmare Infusion
		self:Bar(205588, 55) -- Call of Nightmares
	elseif spellId == 226185 then -- Xavius Energize Phase 3
		self:Message("stages", "Neutral", "Long", CL.stage:format(3), false)
		phase = 3
	end
end

function mod:DecentIntoMadness(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
end

function mod:Madness(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true)
end

function mod:DreamSimulacrum(args)
	if self:Me(args.destGUID) then
		isInDream = true
		self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
		self:TargetBar(args.spellId, 180, args.destName)
	end
end

function mod:DreamSimulacrumRemoved(args)
	if self:Me(args.destGUID) then
		isInDream = false
		self:StopBar(args.spellId, args.destName)
	end
end

do
	local prev = 0
	function mod:LurkingEruption(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			lurkingEruption = lurkingEruption + 1
			if lurkingEruption < 3 then
				self:Bar(args.spellId, 20.5)
			end
		end
	end
end

--[[ Corruption Horror ]]--
function mod:TormentingSwipe(args)
	self:CDBar(args.spellId, 10)
end

function mod:CorruptingNova(args)
	self:Bar(args.spellId, 20.7)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

--[[ Stage One: The Decent Into Madness ]]--
function mod:DarkeningSoul(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 2 and "Warning")
	self:CDBar(args.spellId, 10) -- ~10 early in the fight, ~13-17 later
end

do
	local timer = nil
	function mod:NightmareBlades(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end

		bladeList[#bladeList+1] = args.destName
		if self:GetOption("custom_off_blade_marker") then
			SetRaidTarget(args.destName, #bladeList) -- 1,2
		end

		if #bladeList == 1 then
			self:CDBar(args.spellId, 16)
			timer = self:ScheduleTimer("TargetMessage", 0.5, args.spellId, bladeList, "Important", "Alert")
		else
			self:CancelTimer(timer)
			timer = nil
			self:TargetMessage(args.spellId, bladeList, "Important", "Alert")
		end
	end

	function mod:NightmareBladesRemoved(args)
		if self:GetOption("custom_off_blade_marker") then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:ManifestCorruption(args)
	lurkingEruption = 0
	horrorCount = 0
	self:Message(args.spellId, "Attention", "Info", CL.count:format(self:SpellName(L.horror), horrorCount), false)
	self:Bar(args.spellId, 82.5)
	self:Bar(207830, 15) -- Corrupting Nova
	self:CDBar(224649, 10) -- Tormenting Swipe
	self:Bar(205741, 20.5) -- Lurking Eruption (Lurking Terror)
end

function mod:TormentingFixation(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Long")
	end
end

--[[ Stage Two: From the Shadows ]]--
do
	local timer, isOnMe, otherPlayer = nil, nil, nil
	function mod:BondsOfTerror(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Say(209034)
			self:Flash(209034)
		else
			otherPlayer = args.destName
		end

		bondList[#bondList+1] = args.destName
		if #bondList == 1 then
			self:CDBar(209034, 15)
			timer = self:ScheduleTimer("TargetMessage", 0.3, 209034, bondList, "Important", "Alert")
		else -- applied on both
			if isOnMe and otherPlayer then
				self:Message(209034, "Personal", "Warning", L.linked:format(self:ColorName(otherPlayer)))
				self:OpenProximity(209034, 3, otherPlayer, true)
				wipe(bondList)
			else
				self:CancelTimer(timer)
				timer = nil
				self:TargetMessage(209034, bondList, "Important", "Alert")
			end
		end
	end

	function mod:BondsOfTerrorRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:CloseProximity(209034)
		else
			otherPlayer = nil
		end
	end
end

function mod:BlackeningSoul(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 2 and "Warning")
	self:Bar(args.spellId, 10)
end

function mod:NightmareInfusion(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:Bar(args.spellId, 62)
end

function mod:CallOfNightmares(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	self:Bar(args.spellId, 40)
end

function mod:CorruptionMeteor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Info", nil, nil, isInDream)
	self:TargetBar(args.spellId, 5, args.destName)
	self:Bar(args.spellId, 28)
end

--[[ Stage Three: World of Darkness ]]--
function mod:WrithingDeep(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 21)
end
