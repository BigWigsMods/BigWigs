--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ragnaros", 800, 198)
if not mod then return end
mod:RegisterEnableMob(52409, 53231) --Ragnaros, Lava Scion

--------------------------------------------------------------------------------
-- Locals
--

local intermissionwarned, infernoWarned, fixateWarned = false, false, false
local blazingHeatTargets = mod:NewTargetList()
local sons = 8
local phase = 1
local lavaWavesCD, engulfingCD, dreadflameCD = 30, 40, 40
local moltenSeed, lavaWaves, fixate, livingMeteor, wrathOfRagnaros = (GetSpellInfo(98498)), (GetSpellInfo(100292)), (GetSpellInfo(99849)), (GetSpellInfo(99317)), (GetSpellInfo(98263))
local dreadflame, cloudburst, worldInFlames = (GetSpellInfo(100675)), (GetSpellInfo(100714)), (GetSpellInfo(100190))
local meteorCounter, meteorNumber = 1, {1, 2, 4, 6, 8}
local intermissionHandle = nil

--------------------------------------------------------------------------------
-- Localization
--

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
	L.hand_bar = "Knockback"
	L.ragnaros_back_message = "Raggy is back, parry on!" -- yeah thats right PARRY ON!

	L.wound = "Burning Wound"
	L.wound_desc = "Tank alert only. Count the stacks of burning wound and show a duration bar."
	L.wound_icon = 99399
	L.wound_message = "%2$dx Wound on %1$s"
end
L = mod:GetLocale()
L.wound = L.wound.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		98237, 100115, 98164,
		98953, {100460, "ICON", "FLASHSHAKE", "SAY"},
		98498, 100178,
		99317, {99849, "FLASHSHAKE", "SAY"},
		100190, 100479, 100646, 100714, 100997, 100675,
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
	self:Log("SPELL_AURA_APPLIED", "WorldInFlames", 100190, 100171)

	self:Yell("Phase4", L["phase4_trigger"])
	self:Log("SPELL_CAST_START", "BreadthofFrost", 100479)
	self:Log("SPELL_CAST_START", "EntrappingRoots", 100646)
	self:Log("SPELL_CAST_START", "Cloudburst", 100714)
	self:Log("SPELL_CAST_SUCCESS", "EmpowerSulfuras", 100997)

	-- Normal
	self:Yell("IntermissionEnd", L["intermission_end_trigger1"], L["intermission_end_trigger2"], L["intermission_end_trigger3"])

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_CAST_START", "EngulfingFlames", 99236, 99172, 99235, 100175, 100171, 100178, 100181) -- don't add heroic spellIds!
	self:Log("SPELL_CAST_SUCCESS", "HandofRagnaros", 98237, 100383, 100384, 100387)
	self:Log("SPELL_CAST_SUCCESS", "WrathofRagnaros", 100114) -- only 10 man heroic spellId!
	self:Log("SPELL_CAST_SUCCESS", "BlazingHeat", 100460, 100981, 100982, 100983)
	self:Log("SPELL_CAST_SUCCESS", "MagmaTrap", 98164)
	self:Log("SPELL_CAST_START", "SulfurasSmash", 98710, 100890, 100891, 100892)
	self:Log("SPELL_CAST_START", "SplittingBlow", 98953, 98952, 98951, 100880, 100883, 100877, 100885, 100882, 100879, 100884, 100881, 100878)
	self:Log("SPELL_SUMMON", "LivingMeteor", 99317, 100989, 100990, 100991)
	self:Emote("Dreadflame", dreadflame)

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
	lavaWavesCD, dreadflameCD = 30, 40
	if diff > 2 then
		engulfingCD = 60
	else
		engulfingCD = 40
	end
	intermissionwarned, infernoWarned, fixateWarned = false, false, false
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
		self:SendMessage("BigWigs_StopBar", self, lavaWaves)
		self:SendMessage("BigWigs_StopBar", self, moltenSeed)
		phase = 4
		self:OpenProximity(6)
		 -- not sure if we want a different option key or different icon
		self:Message(98953, CL["phase"]:format(phase), "Positive", 98953)
		self:Bar(100479, (GetSpellInfo(100479)), 34, 100479) -- Breadth of Frost
		self:Bar(100714, cloudburst, 51, 100714) -- Cloudburst
		self:Bar(100646, (GetSpellInfo(100646)), 68, 100646) -- Entraping Roots
		self:Bar(100997, (GetSpellInfo(100997)), 90, 100997) -- EmpowerSulfuras
	else
		self:Win()
	end
end

function mod:Dreadflame()
	if not UnitDebuff("player", (GetSpellInfo(101015))) then return end -- No Deluge on you = you don't care
	self:Message(100675, dreadflame, "Important", 100675, "Alarm")
	self:Bar(100675, dreadflame, dreadflameCD, 100675)
	if dreadflameCD > 10 then
		dreadflameCD = dreadflameCD - 5
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
	self:TargetMessage("wound", L["wound_message"], player, "Urgent", spellId, buffStack > 2 and "Info" or nil, buffStack)
end

function mod:MagmaTrap(player, spellId, _, _, spellName)
	self:Bar(98164, "~"..spellName, 25, spellId)
end

do
	local prev = 0
	function mod:LivingMeteor(_, spellId, _, _, spellName)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(99317, ("%s (%d)"):format(spellName, meteorNumber[meteorCounter]), "Attention", spellId)
			meteorCounter = meteorCounter + 1
			self:Bar(99317, spellName, 45, spellId)
		end
	end
end

do
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

function mod:IntermissionEnd()
	self:SendMessage("BigWigs_StopBar", self, L["intermission_bar"])
	if phase == 1 then
		lavaWavesCD = 40
		self:OpenProximity(6)
		if self:Difficulty() > 2 then
			self:Bar(98498, "~"..moltenSeed, 15, 98498)
			self:Bar(98710, lavaWaves, 7.5, 98710)
			self:Bar(100190, worldInFlames, 40, 100190)
		else
			self:Bar(98498, moltenSeed, 22.7, 98498)
			self:Bar(98710, lavaWaves, 55, 98710)
		end
	elseif phase == 2 then
		engulfingCD = 30
		if self:Difficulty() > 2 then
			self:Bar(100190, worldInFlames, engulfingCD, 100190)
		end
		self:Bar(99317, "~"..livingMeteor, 52, 99317)
		self:Bar(98710, lavaWaves, 55, 98710)
		self:RegisterEvent("UNIT_AURA")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end
	phase = phase + 1
	self:Message(98953, L["ragnaros_back_message"], "Positive", 101228) -- ragnaros icon
end

function mod:HandofRagnaros(_, spellId)
	self:Bar(98237, L["hand_bar"], 25, spellId)
end

function mod:WrathofRagnaros(_, spellId, _, _, spellName)
	self:Bar(100115, "~"..spellName, 25, spellId)
end

function mod:SplittingBlow(_, spellId, _, _, spellName)
	if phase == 2 then
		self:CancelAllTimers()
		self:SendMessage("BigWigs_StopBar", self, L["seed_explosion"])
		self:SendMessage("BigWigs_StopBar", self, moltenSeed)
		self:SendMessage("BigWigs_StopBar", self, worldInFlames)
		self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(100178))) -- Engulfing Flames
	end
	self:Message(98953, L["intermission_message"], "Positive", spellId, "Long")
	self:Bar(98953, spellName, 7, spellId)
	self:Bar(98953, L["intermission_bar"], self:Difficulty() > 2 and 60 or 57, spellId) -- They are probably both 60
	self:CloseProximity()
	sons = 8
	self:SendMessage("BigWigs_StopBar", self, L["hand_bar"])
	self:SendMessage("BigWigs_StopBar", self, lavaWaves)
	self:SendMessage("BigWigs_StopBar", self, "~"..wrathOfRagnaros)
	self:SendMessage("BigWigs_StopBar", self, moltenSeed)
end

function mod:SulfurasSmash(_, spellId)
	if phase == 1 and self:Difficulty() ~= 3 then
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
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellName, _, _, spellId)
		if spellName == moltenSeed then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
				self:Message(98498, spellName, "Urgent", spellId, "Alarm")
				self:Bar(98498, L["seed_explosion"], 12, spellId)
				self:Bar(98498, spellName, 60, spellId)
			end
		end
	end
end

function mod:Deaths(mobId)
	if mobId == 53140 then
		sons = sons - 1
		if sons < 4 then
			self:LocalMessage(98953, L["sons_left"]:format(sons), "Positive", 100308) -- the speed buff icon on the sons
		end
	elseif mobId == 52409 then
		self:Win()
	end
end

