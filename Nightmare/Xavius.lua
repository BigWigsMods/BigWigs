
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Xavius", 1520, 1726)
if not mod then return end
mod:RegisterEnableMob(103769)
mod.engageId = 1864
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local lurkingEruptionCount = 1
local horrorCount = 1
local isInDream = false
local bladeList, bondList = mod:NewTargetList(), mod:NewTargetList()
local dreamHealers = {}
local dreamingCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.horror = -12973

	L.linked = "Bonds of Terror on YOU! - Linked with %s!"
	L.dreamHealers = "Dream Healers"
end

--------------------------------------------------------------------------------
-- Initialization
--

local bladeMarker = mod:AddMarkerOption(false, "player", 1, 211802, 1, 2) -- Nightmare Blades
function mod:GetOptions()
	return {
		--[[ General ]]--
		"berserk",
		"stages",
		"altpower",
		208431, -- Decent Into Madness
		207409, -- Madness
		{206005, "INFOBOX"}, -- Dream Simulacrum
		211634, -- The Infinite Dark

		--[[ Corruption Horror ]]--
		{224649, "TANK"}, -- Tormenting Swipe
		207830, -- Corrupting Nova

		--[[ Stage One: The Decent Into Madness ]]--
		{206651, "TANK_HEALER"}, -- Darkening Soul
		{211802, "SAY", "FLASH"}, -- Nightmare Blades
		bladeMarker,
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

		--[[ Mythic ]]--
		205843, -- The Dreaming
	},{
		["berserk"] = "general",
		[206651] = -12971, -- Stage One: The Decent Into Madness
		[209034] = -13152, -- Stage Two: From the Shadows
		[226194] = -13160, -- Stage Three: World of Darkness
		[205843] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "DecentIntoMadness", 208431)
	self:Log("SPELL_AURA_REMOVED", "DecentIntoMadnessRemoved", 208431)
	self:Log("SPELL_AURA_APPLIED", "Madness", 207409)
	self:Log("SPELL_AURA_APPLIED", "DreamSimulacrum", 206005)
	self:Log("SPELL_AURA_REMOVED", "DreamSimulacrumRemoved", 206005)

	self:Log("SPELL_AURA_APPLIED", "TheInfiniteDark", 211634)
	self:Log("SPELL_PERIODIC_MISSED", "TheInfiniteDark", 211634)
	self:Log("SPELL_PERIODIC_DAMAGE", "TheInfiniteDark", 211634)

	--[[ Stage One: The Decent Into Madness ]]--
	self:Log("SPELL_AURA_APPLIED", "DarkeningSoul", 206651)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkeningSoul", 206651)
	self:Log("SPELL_AURA_APPLIED", "NightmareBlades", 211802)
	self:Log("SPELL_AURA_REMOVED", "NightmareBladesRemoved", 211802)
	self:Log("SPELL_CAST_SUCCESS", "ManifestCorruption", 210264)
	self:Log("SPELL_DAMAGE", "LurkingEruptionUnderYou", 205741)
	self:Log("SPELL_MISSED", "LurkingEruptionUnderYou", 205741)
	self:Log("SPELL_AURA_APPLIED", "TormentingFixation", 205771)
	self:Log("SPELL_SUMMON", "LurkingEruption", 205741) -- Lurking Terror

	--[[ Corruption Horror ]]--
	self:Log("SPELL_CAST_SUCCESS", "TormentingSwipe", 224649)
	self:Log("SPELL_CAST_SUCCESS", "CorruptingNova", 207830)
	self:Death("HorrorDeath", 103695)

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
	lurkingEruptionCount = 1
	horrorCount = 1
	dreamingCount = 1
	wipe(bladeList)
	wipe(bondList)
	wipe(dreamHealers)
	isInDream = false
	self:Bar(206651, 7.5) -- Darkening Soul
	self:Bar(205741, 18) -- Lurking Eruption (Lurking Terror)
	self:Bar(211802, 19.2) -- Nightmare Blades
	self:Bar(210264, 59, CL.count:format(self:SpellName(210264), horrorCount)) -- Manifest Corruption

	self:OpenAltPower("altpower", 208931) -- Nightmare Corruption
	self:OpenInfo(206005, L.dreamHealers)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 226193 then -- Xavius Energize Phase 2
		phase = 2
		self:Message("stages", "cyan", "Long", "65% - ".. CL.stage:format(2), false)
		self:StopBar(206651) -- Darkening Soul
		self:StopBar(211802) -- Nightmare Blades
		self:StopBar(CL.count:format(self:SpellName(210264), horrorCount)) -- Manifest Corruption
		self:StopBar(CL.count:format(self:SpellName(205741), lurkingEruptionCount)) -- Lurking Eruption (Lurking Terror)
		self:Bar(209158, 7) -- Blackening Soul
		self:Bar(205588, (100 - UnitPower("boss1")) / 2.5) -- Call of Nightmares
		if not self:Easy() then
			self:Bar(209034, 15.5) -- Bonds of Terror
		end
		self:Bar(209443, 29) -- Nightmare Infusion
	elseif spellId == 226185 then -- Xavius Energize Phase 3
		self:Message("stages", "cyan", "Long", "30% - ".. CL.stage:format(3), false)
		phase = 3
		self:StopBar(209034) -- Bonds of Terror
		self:StopBar(205588) -- Call of Nightmares
		self:Bar(224508, 20.7) -- Corruption Meteor
		self:Bar(211802, 33) -- Nightmare Blades
		self:Bar(226194, (100 - UnitPower("boss1")) / 4.83) -- Writhing Deep
	elseif spellId == 205843 then -- The Dreaming
		local percentage = dreamingCount == 1 and "97% - " or "60% - "
		if self:Mythic() then
			percentage = dreamingCount == 1 and "97% - " or dreamingCount == 2 and "80% - " or dreamingCount == 3 and "60% - " or "45% - "
			self:CastBar(spellId, 6, CL.count:format(self:SpellName(spellId), dreamingCount))
		end
		self:Message(spellId, "green", "Long", percentage .. CL.count:format(self:SpellName(spellId), dreamingCount))
		dreamingCount = dreamingCount + 1
	end
end

function mod:DecentIntoMadness(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "blue", "Alarm")
		self:TargetBar(args.spellId, 20, args.destName)
	end
end

function mod:DecentIntoMadnessRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:Madness(args)
	self:TargetMessage(args.spellId, args.destName, "red", "Alarm", nil, nil, true)
end

function mod:DreamSimulacrum(args)
	if self:Me(args.destGUID) then
		isInDream = true
		self:TargetMessage(args.spellId, args.destName, "blue", "Info")
		self:TargetBar(args.spellId, 180, args.destName)
	end
	if self:Healer(args.destName) then
		dreamHealers[args.destName] = 1
		self:SetInfoByTable(args.spellId, dreamHealers)
	end
end

function mod:DreamSimulacrumRemoved(args)
	if self:Me(args.destGUID) then
		isInDream = false
		self:StopBar(args.spellId, args.destName)
	end
	if self:Healer(args.destName) then
		dreamHealers[args.destName] = nil
		self:SetInfoByTable(args.spellId, dreamHealers)
	end
end

do
	local prev = 0
	function mod:LurkingEruption(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			lurkingEruptionCount = lurkingEruptionCount + 1
			self:Bar(args.spellId, lurkingEruptionCount % 3 == 0 and 41 or 20.5, CL.count:format(args.spellName, lurkingEruptionCount))
		end
	end
end

do
	local prev = 0
	function mod:TheInfiniteDark(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "blue", "Alert", CL.you:format(args.spellName))
		end
	end
end

--[[ Corruption Horror ]]--
function mod:TormentingSwipe(args)
	self:CDBar(args.spellId, 10)
end

function mod:CorruptingNova(args)
	self:Bar(args.spellId, 20.7)
	self:Message(args.spellId, "yellow", nil, CL.casting:format(args.spellName))
end

function mod:HorrorDeath()
	self:StopBar(207830) -- Corrupting Nova
	self:StopBar(224649) -- Tormenting Swipe
end

--[[ Stage One: The Decent Into Madness ]]--
function mod:DarkeningSoul(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "orange", amount > 2 and "Warning")
	self:CDBar(args.spellId, self:Mythic() and 8.5 or 10) -- ~10 early in the fight, ~13-17 later
end

do
	local timer = nil
	function mod:NightmareBlades(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end

		bladeList[#bladeList+1] = args.destName
		if self:GetOption(bladeMarker) then
			SetRaidTarget(args.destName, #bladeList) -- 1,2
		end

		if #bladeList == 1 then
			self:CDBar(args.spellId, phase == 1 and 15.5 or 31)
			timer = self:ScheduleTimer("TargetMessage", 0.5, args.spellId, bladeList, "red", "Alert")
		else
			self:CancelTimer(timer)
			timer = nil
			self:TargetMessage(args.spellId, bladeList, "red", "Alert")
		end
	end

	function mod:NightmareBladesRemoved(args)
		if self:GetOption(bladeMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:ManifestCorruption(args)
	self:Message(args.spellId, "yellow", "Info", CL.count:format(self:SpellName(L.horror), horrorCount), false)
	self:Bar(args.spellId, 82.5, CL.count:format(args.spellName, horrorCount+1))
	horrorCount = horrorCount + 1
	self:CDBar(207830, 17) -- Corrupting Nova
	self:CDBar(224649, 10) -- Tormenting Swipe
end

function mod:LurkingEruptionUnderYou(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Alert", CL.underyou:format(args.spellName))
	end
end

function mod:TormentingFixation(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "blue", "Long")
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
			self:CDBar(209034, 14.5)
			timer = self:ScheduleTimer("TargetMessage", 0.3, 209034, bondList, "red", "Alert")
		else -- applied on both
			if isOnMe and otherPlayer then
				self:Message(209034, "blue", "Warning", L.linked:format(self:ColorName(otherPlayer)))
				self:OpenProximity(209034, 3, otherPlayer, true)
				wipe(bondList)
			else
				self:CancelTimer(timer)
				timer = nil
				self:TargetMessage(209034, bondList, "red", "Alert")
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
	self:StackMessage(args.spellId, args.destName, amount, "orange", amount > 2 and "Warning")
	self:Bar(args.spellId, self:Mythic() and 8.5 or 10)
end

function mod:NightmareInfusion(args)
	self:TargetMessage(args.spellId, args.destName, "orange", "Alarm", nil, nil, true)
	self:Bar(args.spellId, phase == 2 and 62 or 31.6)
end

function mod:CallOfNightmares(args)
	self:Message(args.spellId, "yellow", "Info", args.spellName)
	self:Bar(args.spellId, 40)
end

function mod:CorruptionMeteor(args)
	self:TargetMessage(args.spellId, args.destName, "yellow", "Info", nil, nil, isInDream)
	self:TargetBar(args.spellId, 5, args.destName)
	self:Bar(args.spellId, phase == 2 and 28 or 35.3)
end

--[[ Stage Three: World of Darkness ]]--
function mod:WrithingDeep(args)
	self:Message(args.spellId, "orange", "Alert")
	self:CDBar(args.spellId, 20.7)
end
