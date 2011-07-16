--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ragnaros", 800, 198)
if not mod then return end
mod:RegisterEnableMob(52409)

--------------------------------------------------------------------------------
-- Locals
--

local seedWarned, intermissionwarned, infernoWarned, wrathWarned, meteorWarned = false, false, false, false, false
local blazingHeatTargets = mod:NewTargetList()
local sons = 8
local phase = 1
local lavaWavesCD, engulfingCD = 30, 40
local moltenSeed, lavaWaves, fixate, livingMeteor = (GetSpellInfo(98498)), (GetSpellInfo(100292)), (GetSpellInfo(99849)), (GetSpellInfo(99317))
local meteorCounter, meteorIncrementer = 0, 1
local fixateTable = {}
local fixateList = mod:NewTargetList()
local intermissionHandle = nil

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.phase4_trigger = "Too soon..."
	L.seed_explosion = "Seed explosion!"
	L.intermission_bar = "Intermission!"
	L.intermission_message = "Intermission... Got cookies?"
	L.sons_left = "%d sons left"
	L.engulfing_close = "Close quarters Engulfed!"
	L.engulfing_middle = "Middle section Engulfed!"
	L.engulfing_far = "Far side Engulfed!"
	L.hand_bar = "Next knockback"
	L.ragnaros_back_message = "Raggy is back, parry on!" -- yeah thats right PARRY ON!
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98237, 100115,
		98953, {100460, "ICON", "FLASHSHAKE", "SAY"},
		{98498, "FLASHSHAKE"}, 100178,
		99317, {99849, "FLASHSHAKE"},
		100190,
		98710, "proximity", "berserk", "bosskill"
	}, {
		[98237] = "ej:2629",
		[98953] = L["intermission_bar"],
		[98498] = "ej:2640",
		[99317] = "ej:2655",
		[100190] = "heroic",
		[98710] = "general"
	}
end

function mod:OnBossEnable()
	-- Heroic
	self:Log("SPELL_AURA_APPLIED", "WorldInFlames", 100190)


	-- Normal
	self:Log("SPELL_DAMAGE", "MoltenInferno", 98518, 100252, 100254)
	self:Log("SPELL_DAMAGE", "MoltenSeed", 98498, 100579, 100580, 100581)
	self:Log("SPELL_CAST_START", "EngulfingFlames", 99236, 99172, 99235, 100175, 100171, 100178, 100181) -- don't add heroic spellIds!
	self:Log("SPELL_CAST_SUCCESS", "HandofRagnaros", 98237, 100383, 100384, 100387)
	self:Log("SPELL_CAST_SUCCESS", "BlazingHeat", 100460, 100981, 100982, 100983)
	self:Log("SPELL_CAST_SUCCESS", "WrathOfRagnaros", 98263, 100113, 100114, 100115)
	self:Log("SPELL_CAST_START", "SulfurasSmash", 98710, 100890, 100891, 100892)
	self:Log("SPELL_CAST_START", "SplittingBlow", 98953, 98952, 98951, 100880, 100883, 100877, 100885, 100882, 100879, 100884, 100881, 100878)
	self:Log("SPELL_SUMMON", "LivingMeteor", 99317, 100989, 100990, 100991)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 100250)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Fixate", 100250)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 52409, 53140) -- Ragnaros, Son of Flame
end

function mod:OnEngage(diff)
	self:Bar(98237, L["hand_bar"], 25, 98237)
	self:Bar(98710, lavaWaves, 30, 98710)
	self:OpenProximity(6)
	self:Berserk(1080)
	lavaWavesCD, engulfingCD = 30, 40
	seedWarned, intermissionwarned, infernoWarned, wrathWarned, meteorWarned = false, false, false, false, false
	sons = 8
	phase = 1
	wipe(fixateList)
	meteorCounter, meteorIncrementer = 0, 1
	intermissionHandle = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--


do
	local function setMeteorWarned()
		meteorWarned = false
	end

	function mod:LivingMeteor(_, spellId, _, _, spellName)
		if not meteorWarned then
			meteorWarned = true
			meteorCounter = meteorCounter + meteorIncrementer
			meteorIncrementer = meteorIncrementer + 1
			self:Message(99317, ("%s (%d)"):format(spellName, meteorCounter), "Attention", spellId)
			self:Bar(99317, spellName, 45, spellId)
			self:ScheduleTimer(setMeteorWarned, 5)
		end
	end
end

do
	local function fixateWarn()
		if fixateList[1] then
			mod:TargetMessage(99849, fixate, fixateList, "Important", 99849, "Info")
		end
	end

	-- Need to verify how fast a fixate gets applied after a knockback
	function mod:Fixate()
		for i=1, GetNumRaidMembers() do
			local unit = GetRaidRosterInfo(i)
			if UnitDebuff(unit, fixate) then
				if not fixateTable[i] then
					if UnitIsUnit(unit, "player") then
						self:FlashShake(99849)
					end
					fixateList[#fixateList+1] = unit
					fixateTable[i] = true
					self:ScheduleTimer(fixateWarn, 0.1) -- increase this if you want it less spammy
				end
			else
				fixateTable[i] = false
			end
		end
	end
end

local function moltenInferno()
	-- don't overwrite an accurate timer with a scheduled timer
	if not seedWarned then
		mod:Bar(98498, L["seed_explosion"], 10, 100252)
	end
end

do
	local function setWrathWarned()
		wrathWarned = false
	end

	function mod:WrathOfRagnaros(_, spellId, _, _, spellName)
		if not wrathWarned then
			mod:Bar(100115, spellName, 30, spellId)
			mod:ScheduleTimer(setWrathWarned, 5)
			wrathWarned = true
		end
	end
end

local function intermissionSpamControl()
	intermissionwarned = false
end

local function intermissionEnd()
	if intermissionHandle then
		mod:CancelTimer(intermissionHandle, true)
	end
	mod:SendMessage("BigWigs_StopBar", mod, L["intermission_bar"])
	if not intermissionwarned then
		if phase == 1 then
			lavaWavesCD = 40
			mod:ScheduleTimer(intermissionSpamControl, 45)
			mod:OpenProximity(6)
			if mod:Difficulty() > 2 then
				mod:ScheduleTimer(moltenInferno, 18)
				mod:Bar(98498, "~"..moltenSeed, 18, 98498)
				mod:Bar(98710, lavaWaves, 7.5, 98710)
			else
				mod:Bar(98498, moltenSeed, 24, 98498)
				mod:Bar(98710, lavaWaves, 55, 98710)
			end
		elseif phase == 2 then
			engulfingCD = 30
			mod:Bar(99317, "~"..livingMeteor, 52, 99317)
			mod:Bar(98710, lavaWaves, 55, 98710)
			for i=1, GetNumRaidMembers() do
				fixateTable[i] = false
			end
		end
		phase = phase + 1
		intermissionwarned = true
		mod:Message(98953, L["ragnaros_back_message"], "Positive", 101228) -- ragnaros icon
	end
end

function mod:HandofRagnaros(_, spellId)
	self:Bar(98237, L["hand_bar"], 25, spellId)
end

function mod:SplittingBlow(_, spellId, _, _, spellName)
	if phase == 2 then
		self:CancelAllTimers()
		self:SendMessage("BigWigs_StopBar", self, L["seed_explosion"])
		self:SendMessage("BigWigs_StopBar", self, moltenSeed)
	end
	self:Message(98953, L["intermission_message"], "Positive", spellId, "Long")
	self:Bar(98953, spellName, 7, spellId)
	if self:Difficulty() > 2 then
		self:Bar(98953, L["intermission_bar"], 60, spellId)
		intermissionHandle = self:ScheduleTimer(intermissionEnd, 60)
	else
		self:Bar(98953, L["intermission_bar"], 45, spellId)
		intermissionHandle = self:ScheduleTimer(intermissionEnd, 45)
	end
	self:CloseProximity()
	sons = 8
	self:SendMessage("BigWigs_StopBar", self, L["hand_bar"])
	self:SendMessage("BigWigs_StopBar", self, lavaWaves)
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(100115))) -- Wrath of Ragnaros
	self:SendMessage("BigWigs_StopBar", self, moltenSeed)
end

function mod:SulfurasSmash(_, spellId)
	self:Message(98710, lavaWaves, "Attention", spellId, "Info")
	self:Bar(98710, lavaWaves, lavaWavesCD, spellId)
end

function mod:WorldInFlames(_, spellId, _, _, spellName)
	self:Message(100190, spellName, "Important", spellId, "Alert")
	self:Bar(100190, spellName, engulfingCD, spellId)
end

function mod:EngulfingFlames(_, spellId)
	if spellId == 100175 then
		self:Message(100178, L["engulfing_close"], "Important", spellId, "Alert")
	elseif spellId == 100171 or spellId == 100178 then
		self:Message(100178, L["engulfing_middle"], "Important", spellId, "Alert")
	elseif spellId == 100181 then
		self:Message(100178, L["engulfing_far"], "Important", spellId, "Alert")
	end
end

do
	local scheduled = nil
	local iconCounter = 1
	local function blazingHeatWarn(spellName)
		mod:TargetMessage(100460, spellName, blazingHeatTargets, "Attention", 100460, "Info")
		scheduled = nil
	end
	function mod:BlazingHeat(player, spellID, _, _, spellName)
		blazingHeatTargets[#blazingHeatTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:Say(100460, CL["say"]:format(spellName))
			self:FlashShake(100460)
		end
		if iconCounter == 1 then
			self:PrimaryIcon(100460, player)
			iconCounter = 2
		else
			self:SecondaryIcon(100460, player)
			iconCounter = 1
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(blazingHeatWarn, 0.3, spellName)
		end
	end
end

do
	local function moltenSeedWarned()
		seedWarned = false
	end
	function mod:MoltenSeed(_, spellId, _, _, spellName)
		-- This might not always trigger, since if you play correctly you can compeltely avoid damage taken from this
		if not seedWarned then
			self:ScheduleTimer(moltenSeedWarned, 5)
			self:Message(98498, spellName, "Urgent", spellId, "Alarm")
			self:Bar(98498, L["seed_explosion"], 10, spellId)
			seedWarned = true
		end
	end
end

do
	local function moltenInfernoWarned()
		infernoWarned = false
	end
	function mod:MoltenInferno(_, spellId)
		-- This is more reliable, because you always take damage from this
		if not infernoWarned then
			self:ScheduleTimer(moltenInfernoWarned, 5)
			self:ScheduleTimer(moltenInferno, 50)
			self:Message(98498, L["seed_explosion"], "Urgent", spellId, "Alarm")
			self:Bar(98498, moltenSeed, 50, 98498)
			infernoWarned = true
		end
	end
end

function mod:Deaths(mobId)
	if mobId == 53140 then
		sons = sons - 1
		if sons < 3 and sons > 0 then
			self:Message(98953, L["sons_left"]:format(sons), "Positive", 100308) -- the speed buff icon on the sons
		elseif sons == 0 then
			intermissionEnd()
		end
	elseif mobId == 52409 then
		self:Win()
	end
end

