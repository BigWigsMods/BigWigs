--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ragnaros", 800, 198)
if not mod then return end
mod:RegisterEnableMob(52409)

--------------------------------------------------------------------------------
-- Locals
--

local seedWarned, intermissionwarned, infernoWarned, meteorWarned, fixateWarned = false, false, false, false, false
local blazingHeatTargets = mod:NewTargetList()
local sons = 8
local phase = 1
local lavaWavesCD, engulfingCD = 30, 40
local moltenSeed, lavaWaves, fixate, livingMeteor, wrathOfRagnaros = (GetSpellInfo(98498)), (GetSpellInfo(100292)), (GetSpellInfo(99849)), (GetSpellInfo(99317)), (GetSpellInfo(98263))
local meteorCounter, meteorNumber = 1, {1, 2, 4, 6, 8}
local intermissionHandle = nil

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.intermission_end_trigger1 = "Sulfuras will be your end"
	L.intermission_end_trigger2 = "Fall to your knees"
	L.intermission_end_trigger3 = "I will finish this"
	L.phase4_trigger = "Too soon..."
	L.seed_explosion = "Seed explosion!"
	L.intermission_bar = "Intermission!"
	L.intermission_message = "Intermission... Got cookies?"
	L.sons_left = "%d |4son left:sons left;"
	L.engulfing_close = "Close quarters Engulfed!"
	L.engulfing_middle = "Middle section Engulfed!"
	L.engulfing_far = "Far side Engulfed!"
	L.hand_bar = "Next knockback"
	L.ragnaros_back_message = "Raggy is back, parry on!" -- yeah thats right PARRY ON!

	L.wound = "Burning Wound "..INLINE_TANK_ICON
	L.wound_desc = "Tank alert only. Count the stacks of burning wound and show a duration bar."
	L.wound_icon = 99399
	L.wound_message = "%2$dx Wound on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98237, 100115, 98164,
		98953, {100460, "ICON", "FLASHSHAKE", "SAY"},
		{98498, "FLASHSHAKE"}, 100178,
		99317, {99849, "FLASHSHAKE", "SAY"},
		100190, 100479, 100646, 100714, 100997,
		98710, "wound", "proximity", "berserk", "bosskill"
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

	self:Yell("Phase4", L["phase4_trigger"])
	self:Log("SPELL_CAST_START", "BreadthofFrost", 100479)
	self:Log("SPELL_CAST_START", "EntrappingRoots", 100646)
	self:Log("SPELL_CAST_START", "Cloudburst", 100714)
	self:Log("SPELL_CAST_START", "EmpowerSulfuras", 100997)

	-- Normal
	self:Yell("IntermissionEnd", L["intermission_end_trigger1"], L["intermission_end_trigger2"], L["intermission_end_trigger3"])

	self:Log("SPELL_DAMAGE", "MoltenInferno", 98518, 100252, 100253, 100254)
	self:Log("SPELL_MISSED", "MoltenInferno", 98518, 100252, 100253, 100254)
	self:Log("SPELL_DAMAGE", "MoltenSeed", 98498, 100579, 100580, 100581)
	self:Log("SPELL_CAST_START", "EngulfingFlames", 99236, 99172, 99235, 100175, 100171, 100178, 100181) -- don't add heroic spellIds!
	self:Log("SPELL_CAST_SUCCESS", "HandofRagnaros", 98237, 100383, 100384, 100387)
	self:Log("SPELL_CAST_SUCCESS", "BlazingHeat", 100460, 100981, 100982, 100983)
	self:Log("SPELL_CAST_SUCCESS", "MagmaTrap", 98164)
	self:Log("SPELL_CAST_START", "SulfurasSmash", 98710, 100890, 100891, 100892)
	self:Log("SPELL_CAST_START", "SplittingBlow", 98953, 98952, 98951, 100880, 100883, 100877, 100885, 100882, 100879, 100884, 100881, 100878)
	self:Log("SPELL_SUMMON", "LivingMeteor", 99317, 100989, 100990, 100991)

	self:Log("SPELL_AURA_APPLIED", "Wound", 101238, 101239, 101240, 99399)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Wound", 101238, 101239, 101240, 99399)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 52409, 53140) -- Ragnaros, Son of Flame
end

function mod:OnEngage(diff)
	self:Bar(98237, L["hand_bar"], 25, 98237)
	self:Bar(98710, lavaWaves, 30, 98710)
	self:OpenProximity(6)
	self:Berserk(1080)
	lavaWavesCD, engulfingCD = 30, 40
	seedWarned, intermissionwarned, infernoWarned, meteorWarned, fixateWarned = false, false, false, false, false
	sons = 8
	phase = 1
	meteorCounter = 1
	intermissionHandle = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Phase4()
	--10% Yell is Phase 4 for heroic, and victory for normal
	if self:Difficulty() > 2 then
		self:SendMessage("BigWigs_StopBar", self, livingMeteor)
		phase = 4
		self:OpenProximity(6)
		 -- not sure if we want a different option key or different icon
		mod:Message(98953, CL["phase"]:format(phase), "Positive", 98953)
		self:Bar(100479, (GetSpellInfo(100479)), 34, 100479) -- Breadth of Frost
		self:Bar(100714, (GetSpellInfo(100714)), 51, 100714) -- Cloudburst
		self:Bar(100646, (GetSpellInfo(100646)), 68, 100646) -- Entraping Roots
		self:Bar(100997, (GetSpellInfo(100997)), 90, 100997) -- EmpowerSulfuras
	else
		self:Win()
	end
end

function mod:EmpowerSulfuras(_, spellId, _, _, spellName)
	self:Message(100997, spellName, "Urgent", spellId)
	self:Bar(100997, "~"..spellName, 56, spellId)
	self:Bar(100997, spellName, 5, spellId)
end

function mod:Cloudburst(_, spellId, _, _, spellName)
	self:Message(100714, spellName, "Positive", spellId)
end

function mod:EntrappingRoots(_, spellId, _, _, spellName)
	self:Message(100646, spellName, "Positive", spellId)
	self:Bar(100646, spellName, 56, spellId)
end

function mod:BreadthofFrost(_, spellId, _, _, spellName)
	self:Message(100479, spellName, "Positive", spellId)
	self:Bar(100479, spellName, 45, spellId)
end

function mod:Wound(player, spellId, _, _, _, buffStack)
	if UnitGroupRolesAssigned("player") ~= "TANK" then return end
	if not buffStack then buffStack = 1 end
	self:SendMessage("BigWigs_StopBar", self, L["wound_message"]:format(player, buffStack - 1))
	self:Bar("wound", L["wound_message"]:format(player, buffStack), 21, spellId)
	self:TargetMessage("wound", L["wound_message"], player, "Urgent", spellId, "Info", buffStack)
end

function mod:MagmaTrap(player, spellId, _, _, spellName)
	self:Bar(98164, "~"..spellName, 25, spellId)
end

do
	local function setMeteorWarned()
		meteorWarned = false
	end

	function mod:LivingMeteor(_, spellId, _, _, spellName)
		if not meteorWarned then
			meteorWarned = true
			self:Message(99317, ("%s (%d)"):format(spellName, meteorNumber[meteorCounter]), "Attention", spellId)
			meteorCounter = meteorCounter + 1
			self:Bar(99317, spellName, 45, spellId)
			self:ScheduleTimer(setMeteorWarned, 5)
		end
	end
end

do
	local prev = 0
	function mod:UNIT_AURA(_, unit)
		if unit ~= "player" then return end
		local fixated = UnitDebuff("player", fixate)
		if fixated and not fixateWarned then
			fixateWarned = true
			self:LocalMessage(99849, CL["you"]:format(fixate), "Personal", 99849, "Long")
			self:Say(99849, CL["say"]:format(fixate))
			self:FlashShake(99849)
		elseif not fixated and fixateWarned then
			fixateWarned = false
		end
	end
end

local function moltenInferno()
	-- don't overwrite an accurate timer with a scheduled timer
	if not seedWarned then
		mod:Bar(98498, L["seed_explosion"], 10, 100252)
	end
end

function mod:IntermissionEnd()
	self:SendMessage("BigWigs_StopBar", self, L["intermission_bar"])
	if phase == 1 then
		lavaWavesCD = 40
		self:OpenProximity(6)
		if self:Difficulty() > 2 then
			self:ScheduleTimer(moltenInferno, 15)
			self:Bar(98498, "~"..moltenSeed, 15, 98498)
			self:Bar(98710, lavaWaves, 7.5, 98710)
		else
			self:Bar(98498, moltenSeed, 24, 98498)
			self:Bar(98710, lavaWaves, 55, 98710)
		end
	elseif phase == 2 then
		engulfingCD = 30
		self:Bar(99317, "~"..livingMeteor, 52, 99317)
		self:Bar(98710, lavaWaves, 55, 98710)
		self:RegisterEvent("UNIT_AURA")
	end
	phase = phase + 1
	self:Message(98953, L["ragnaros_back_message"], "Positive", 101228) -- ragnaros icon
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
	else
		self:Bar(98953, L["intermission_bar"], 45, spellId)
	end
	self:CloseProximity()
	sons = 8
	self:SendMessage("BigWigs_StopBar", self, L["hand_bar"])
	self:SendMessage("BigWigs_StopBar", self, lavaWaves)
	self:SendMessage("BigWigs_StopBar", self, "~"..wrathOfRagnaros)
	self:SendMessage("BigWigs_StopBar", self, moltenSeed)
end

function mod:SulfurasSmash(_, spellId)
	if phase == 1 then
		self:Bar(100115, "~"..wrathOfRagnaros, 12, 100115)
	end
	self:Message(98710, lavaWaves, "Attention", spellId, "Info")
	self:Bar(98710, lavaWaves, lavaWavesCD, spellId)
end

function mod:WorldInFlames(_, spellId, _, _, spellName)
	self:Message(100190, spellName, "Important", spellId, "Alert")
	self:Bar(100190, spellName, engulfingCD, spellId)
end

function mod:EngulfingFlames(_, spellId, _, _, spellName)
	if spellId == 100175 or spellId == 99172 then
		self:Message(100178, L["engulfing_close"], "Important", spellId, "Alert")
	elseif spellId == 100171 or spellId == 100178 or spellId == 99235 then
		self:Message(100178, L["engulfing_middle"], "Important", spellId, "Alert")
	elseif spellId == 100181 or spellId == 99236 then
		self:Message(100178, L["engulfing_far"], "Important", spellId, "Alert")
	end
	self:Bar(100178, spellName, engulfingCD, spellId)
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
		if sons < 4 then
			self:Message(98953, L["sons_left"]:format(sons), "Positive", 100308) -- the speed buff icon on the sons
		end
	elseif mobId == 52409 then
		self:Win()
	end
end

