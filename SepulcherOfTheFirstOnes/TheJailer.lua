--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Jailer", 2481, 2464)
if not mod then return end
mod:RegisterEnableMob(180990) -- The Jailer
mod:SetEncounterID(2537)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local relentlessDominationCount = 1
local chainsOfOppressionCount = 1
local martyrdomCount = 1
local tormentCount = 1
local runeOfDamnationCount = 1
local unholyAttunementCount = 1
local shatteringBlastCount = 1
local runeOfCompulsion = 1
local decimatorCount = 1
local desolationCount = 1
local runeOfDominationCount = 1
local chainsOfAnguishCount = 1
local defileCount = 1
local fallingDebrisCount = 1
local currentAzerothHealth = 100
local lastAzerothHealth = 100
local worldCount = 1
local specialCount = 1
local specialTimer = nil

--------------------------------------------------------------------------------
-- Timers
--

local timersNormal = {
	[1] = {
		[365436] = {21.9, 51, 69, 0}, -- Torment
		[363893] = {40, 40, 40, 40, 0}, -- Martyrdom
		[362028] = {48, 60, 60, 0}, -- Relenting Domination
		[359809] = {90, 0}, -- Chains of Oppression
		[360281] = {11, 19, 34, 33.0, 28, 26.0, 0}, -- Rune of Damnation
	},
	[2] = {
		[365436] = {42, 50.0, 55.0, 45.0}, -- Torment
		[360562] = {27.9, 57.5, 47.5, 43.0}, -- Decimator
		[360373] = {18.9, 45, 45, 45, 42.5, 0}, -- Unholy Attunement
		[359856] = {34.5, 13.4, 30, 15, 30.9, 15.5, 28.4, 15.9}, -- Shattering Blast
		[366285] = {61.9, 60, 60}, -- Rune of Compulsion
	},
	[3] = {
		[365436] = {26, 86.9}, -- Torment
		[360562] = {34.9, 52, 41.9, 41.9}, -- Decimator
		[365033] = {41.9, 60, 60}, -- Desolation
		[365150] = {63, 83.9}, -- Rune of Domination
		[365212] = {51.9, 41.9, 41.9, 41.9}, -- Chains of Anguish
		[365169] = {55, 40.9, 43, 42.9}, -- Defile
	},
}

local timersHeroic = {
	[1] = {
		[365436] = {11.0, 52.0, 45.0, 47.0, 0}, -- Torment
		[363893] = {31.0, 40.0, 52.0, 39.0, 0}, -- Martyrdom
		[362028] = {55.0, 57.0, 56.0, 0}, -- Relenting Domination
		[359809] = {40.0, 48.0, 49.0, 0}, -- Chains of Oppression
		[360281] = {22.0, 25.0, 29.0, 21.0, 30.5, 19.5, 0}, -- Rune of Damnation
	},
	[2] = {
		[365436] = {22, 16.0, 35.5, 61.5, 29, 30, 0}, -- Torment
		[360562] = {26, 41.0, 35, 45, 41, 0}, -- Decimator
		[360373] = {19, 45.0, 45.0, 46, 41.9, 0}, -- Unholy Attunement
		[359856] = {33.0, 16.0, 30.0, 15.0, 29.0, 17.0, 29.0, 14.0, 0}, -- Shattering Blast
		[366285] = {41.0, 46.0, 45.0, 47, 0}, -- Rune of Compulsion
	},
	[3] = {
		[365436] = {51, 75}, -- Torment
		[360562] = {26, 38, 47, 33, 40}, -- Decimator
		[365033] = {42, 60, 64}, -- Desolation
		[365150] = {71, 79}, -- Rune of Domination
		[365212] = {37, 55, 43, 43}, -- Chains of Anguish
		[365169] = {33, 45, 45, 52}, -- Defile
	},
}

local timersMythic = {
	[1] = {
		[365436] = {8.0, 42.0, 40.0, 32.0, 44.0, 0}, -- Torment
		[363893] = {30.0, 47.0, 31.0, 43.0}, -- Martyrdom
		[362028] = {44.0, 54.0, 70, 0}, -- Relenting Domination
		[359809] = {16.0, 111.0, 0}, -- Chains of Oppression
		[360281] = {35.0, 23.0, 26.0, 29.0, 27.0, 18.0, 0}, -- Rune of Damnation
		-- Heals are in mythicSpecialTimers
	},
	[2] = {
		[365436] = {33.0, 38.0, 35.0, 25.0, 32.0, 26.0}, -- Torment
		[360562] = {57.0, 42.5, 33.5, 41.0}, -- Decimator
		[360373] = {19.0, 45.0, 45.0, 45.0, 42.0}, -- Unholy Attunement
		[359856] = {35.0, 14.0, 30.0, 15.0, 26.0, 22.0, 26.0, 14.0}, -- Shattering Blast
		[366285] = {27.0, 50, 50.0, 61.0}, -- Rune of Compulsion
		-- Heals are in mythicSpecialTimers
	},
	[3] = {
		[365436] = {58.0, 110.0, 0}, -- Torment
		[360562] = {28.0, 44.0, 39.0, 36.0, 0}, -- Decimator
		[365033] = {39.0, 82.0, 0}, -- Desolation
		[365150] = {85.0, 57.0, 0}, -- Rune of Domination
		[365212] = {36.0, 47.0, 47.5, 40.5, 0}, -- Chains of Anguish
		[365169] = {55.0, 24.0, 39.0, 40, 0}, -- Defile
		-- Heals are in mythicSpecialTimers
	},
}

local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

local mythicSpecialTimers = {
	-- pull/0:00 -> 0:25 -> 1:11 -> 1:43 -> 2:17
	[1] = {25.0, 46.0, 32.0, 34.0},
	-- stage2/2:47 -> 3:40.5 -> 4:22 -> 5:15 -> 5:49
	[2] = {48.5, 46.5, 53, 34},
	-- stage3/6:15 -> 7:00.5 -> 7:21 -> 7:54.5 (2x lines) -> 8:33
	[3] = {45.5, 20.5, 33.5, 38.5},
	-- Dispel Timers in last stage, from Heal Channel _START
	[4] = {40, 30, 29}
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rune_of_damnation_countdown = "Countdown"
	L.rune_of_damnation_countdown_icon = 360281 -- Rune of Damnation
	L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	L.jump = "Jump In"

	L.relentless_domination = "Domination"
	L.chains_of_oppression = "Pull Chains"
	L.unholy_attunement = "Raise Pylons"
	L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "Charms"
	L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "Tank Chain"
	L.chain = "Chain"
	L.chain_target = "Chaining %s!"
	L.chains_remaining = "%d/%d Chains Broken"
	L.rune_of_domination = "Group Soaks"

	L.final = "Final %s"

	L.azeroth_health = "Azeroth Health"
	L.azeroth_health_desc = "Azeroth Health Warnings"

	L.azeroth_new_health_plus = "Azeroth Health: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Azeroth Health: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill"
	L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	L.mythic_blood_soak_stage_2_desc = L.mythic_blood_soak_stage_1_desc
	L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	L.mythic_blood_soak_stage_3_desc = L.mythic_blood_soak_stage_1_desc

	L.mythic_blood_soak_bar = "Heal Azeroth"
	L.mythic_blood_soak_bar_p2 = "Heal Deadline"
	L.mythic_blood_soak_icon = "spell_azerite_essence10"

	L.floors_open = "Floors Open"
	L.floors_open_desc = "Timer for when floors open up"
end

--------------------------------------------------------------------------------
-- Initialization
--

local runeOfDamnationMarker = mod:AddMarkerOption(false, "player", 1, 360281, 1, 2, 3, 4, 5, 6) -- Rune of Damnation
local runeOfCompulsionMarker = mod:AddMarkerOption(false, "player", 1, 366285, 1, 2, 3, 4) -- Rune of Compulsion
local runeOfDominationMarker = mod:AddMarkerOption(false, "player", 1, 365150, 1, 2, 3) -- Rune of Domination
local chainsOfAnguishMarker = mod:AddMarkerOption(false, "player", 8, 365212, 8, 7, 6, 5) -- Chains of Anguish
function mod:GetOptions()
	return {
		"stages",
		"azeroth_health",
		362012, -- Eternity's End
		"floors_open",
		-- Stage One: Origin of Domination
		362028, -- Relentless Domination
		362075, -- Domination
		366132, -- Tyranny
		359809, -- Chains of Oppression
		{363893, "SAY", "SAY_COUNTDOWN"}, -- Martyrdom
		{366545, "TANK"}, -- Persecution
		365436, -- Torment
		{360281, "SAY", "SAY_COUNTDOWN", "ME_ONLY"}, -- Rune of Damnation
		{"rune_of_damnation_countdown", "COUNTDOWN"},
		runeOfDamnationMarker,
		-- Stage Two: Unholy Attunement
		360373, -- Unholy Attunement
		363332, -- Unbreakable Grasp
		359856, -- Shattering Blast
		{366285, "SAY", "SAY_COUNTDOWN"}, -- Rune of Compulsion
		runeOfCompulsionMarker,
		360562, -- Decimator
		-- Stage Three: Eternity's End
		365033, -- Desolation
		{365150, "SAY", "SAY_COUNTDOWN"}, -- Rune of Domination
		runeOfDominationMarker,
		365212, -- Chains of Anguish
		chainsOfAnguishMarker,
		365169, -- Defile
		-- Mythic
		"mythic_blood_soak_stage_1",
		"mythic_blood_soak_stage_2",
		"mythic_blood_soak_stage_3",
		366374, -- World Crusher
		366678, -- World Cracker
		367051, -- World Shatterer
	},{
		["stages"] = "general",
		[362028] = -24087, -- Stage One: Origin of Domination
		[360373] = -23925, -- Stage Two: Unholy Attunement
		[365033] = -24252, -- Stage Three: Eternity's End
		["mythic_blood_soak_stage_1"] = "mythic", -- Stage Three: Eternity's End
	},{
		[362028] = L.relentless_domination, -- Domination
		[362631] = L.chains_of_oppression, -- Chains of Oppression (Pull Chains)
		[363893] = CL.tank_combo, -- Martyrdom (Tank Combo)
		[360279] = CL.bombs, -- Rune of Damnation (Bombs)
		[360373] = L.unholy_attunement, -- Unholy Attunement (Raise Pylons)
		[359856] = L.shattering_blast, -- Shattering Blast (Tank Blast)
		[366285] = L.rune_of_compulsion, -- Rune of Compulsion (Charms)
		[360562] = CL.knockback, -- Decimator (Knockback)
		[365033] = L.desolation, -- Desolation (Azeroth Soak)
		[365150] = L.rune_of_domination, -- Rune of Domination (Heal Runes)
		[365212] = L.chains_of_anguish, -- Chains of Anguish (Tank Chains)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UPDATE_UI_WIDGET", "WIDGET")

	-- Stage One: Origin of Domination
	self:Log("SPELL_CAST_START", "RelentlessDomination", 362028)
	self:Log("SPELL_AURA_APPLIED", "DominationApplied", 362075)
	self:Log("SPELL_AURA_APPLIED", "TyrannyApplied", 366132)
	self:Log("SPELL_CAST_SUCCESS", "ChainsOfOppression", 359809)
	self:Log("SPELL_AURA_APPLIED", "MartyrdomApplied", 363893)
	self:Log("SPELL_AURA_APPLIED", "PersecutionApplied", 366545)
	self:Log("SPELL_CAST_SUCCESS", "Torment", 365436, 370071) -- p1/p2, p3 (+adds)
	self:Log("SPELL_AURA_APPLIED", "TormentApplied", 362401)
	self:Log("SPELL_CAST_SUCCESS", "RuneOfDamnation", 360279)
	self:Log("SPELL_AURA_APPLIED", "RuneOfDamnationApplied", 360281)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDamnationRemoved", 360281)

	-- Stage Two: Unholy Attunement
	self:Log("SPELL_CAST_START", "FinalRelentlessDomination", 367851)
	self:Log("SPELL_CAST_START", "UnholyAttunement", 360373)
	self:Log("SPELL_CAST_START", "ShatteringBlast", 359856)
	self:Log("SPELL_CAST_SUCCESS", "RuneOfCompulsion", 366284)
	self:Log("SPELL_AURA_APPLIED", "RuneOfCompulsionApplied", 366285)
	self:Log("SPELL_AURA_REMOVED", "RuneOfCompulsionRemoved", 366285)
	self:Log("SPELL_CAST_START", "Decimator", 360562, 364942, 364488) -- 3 different types based on distance?
	self:Log("SPELL_CAST_START", "FinalUnholyAttunement", 367290)

	-- Stage Three: Eternity's End
	self:Log("SPELL_CAST_SUCCESS", "UnbreakingGrasp", 363332)
	self:Log("SPELL_CAST_START", "Desolation", 365033)
	self:Log("SPELL_CAST_SUCCESS", "RuneOfDomination", 365147)
	self:Log("SPELL_AURA_APPLIED", "RuneOfDominationApplied", 365150)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDominationRemoved", 365150)
	self:Log("SPELL_CAST_START", "ChainsOfAnguish", 365212)
	self:Log("SPELL_AURA_APPLIED", "ChainsOfAnguishApplied", 365222) -- 365219 Initial Target, 365222 Secondary Targets
	self:Log("SPELL_AURA_REMOVED", "ChainsOfAnguishRemoved", 365222)
	self:Log("SPELL_CAST_START", "Defile", 365169)
	self:Log("SPELL_CAST_START", "EternitysEnd", 362012)

	-- Mythic
	self:Log("SPELL_CAST_START", "WorldCrusher", 366374)
	self:Log("SPELL_CAST_START", "WorldCracker", 366678)
	self:Log("SPELL_CAST_SUCCESS", "WorldShatterer", 367051)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic
	self:SetStage(1)
	currentAzerothHealth = 100
	lastAzerothHealth = 100

	-- Stage 1
	relentlessDominationCount = 1
	chainsOfOppressionCount = 1
	martyrdomCount = 1
	tormentCount = 1
	runeOfDamnationCount = 1
	-- Stage 2
	unholyAttunementCount = 1
	shatteringBlastCount = 1
	runeOfCompulsion = 1
	decimatorCount = 1
	-- Stage 3
	desolationCount = 1
	runeOfDominationCount = 1
	chainsOfAnguishCount = 1
	defileCount = 1
	fallingDebrisCount = 1

	self:Bar(360281, timers[1][360281][runeOfDamnationCount], CL.count:format(CL.bombs, runeOfDamnationCount))
	self:Bar(365436, timers[1][365436][tormentCount], CL.count:format(self:SpellName(365436), tormentCount))
	self:Bar(363893, timers[1][363893][martyrdomCount], CL.count:format(CL.tank_combo, martyrdomCount))
	self:Bar(362028, timers[1][362028][relentlessDominationCount], CL.count:format(L.relentless_domination, relentlessDominationCount))
	self:Bar(359809, timers[1][359809][chainsOfOppressionCount], CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))
	self:Bar("stages", 180, CL.stage:format(2), 360373) -- Unholy Attunement

	if self:Mythic() then
		worldCount = 1
		specialCount = 1
		self:Bar(366374, 3) -- World Crusher
		self:StartSpecialTimer(mythicSpecialTimers[1][specialCount]) -- Heal Azeroth
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local getStatusBarInfo = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo
	function mod:AzerothHealthMessage()
		if currentAzerothHealth > lastAzerothHealth and (currentAzerothHealth - lastAzerothHealth) > 3 then
			local change = currentAzerothHealth - lastAzerothHealth
			mod:Message("azeroth_health", "green", L.azeroth_new_health_plus:format(change, currentAzerothHealth), "inv_heartofazeroth")
		elseif currentAzerothHealth ~= lastAzerothHealth and (lastAzerothHealth - currentAzerothHealth) > 3 then -- only if changed
			local change = lastAzerothHealth - currentAzerothHealth
			mod:Message("azeroth_health", "red", L.azeroth_new_health_minus:format(change, currentAzerothHealth), "inv_heartofazeroth")
		end
		lastAzerothHealth = currentAzerothHealth
		scheduled = nil
	end

	function mod:WIDGET(event, data)
		if data.widgetID == 3554 then -- Azeroth Health Widged
			local info = getStatusBarInfo(data.widgetID)
			if not info or not info.barValue then return end
			self:CancelTimer(scheduled)
			scheduled = self:ScheduleTimer("AzerothHealthMessage", 1.5)
			currentAzerothHealth = info.barValue
		end
	end
end

function mod:EternitysEnd(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

-- Stage One: Origin of Domination
function mod:RelentlessDomination(args)
	self:StopBar(CL.count:format(L.relentless_domination, relentlessDominationCount))
	self:Message(args.spellId, "red", CL.count:format(L.relentless_domination, relentlessDominationCount))
	self:PlaySound(args.spellId, "warning")
	relentlessDominationCount = relentlessDominationCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][relentlessDominationCount], relentlessDominationCount == 3 and L.final:format(CL.count:format(L.relentless_domination, relentlessDominationCount)) or CL.count:format(L.relentless_domination, relentlessDominationCount))
	if not self:Easy() then
		self:Bar(366132, 11.1) -- Tyranny
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:DominationApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			playerList = {}
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "red", playerList)
	end
end

do
	local prev = 0
	function mod:TyrannyApplied(args)
		-- XXX this is the hit debuff, doesn't seem like there is a way to get targets
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(args.spellId)
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:ChainsOfOppression(args)
	self:StopBar(CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))
	self:CastBar(args.spellId, 6, CL.explosion)
	self:PlaySound(args.spellId, "long")
	chainsOfOppressionCount = chainsOfOppressionCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][chainsOfOppressionCount], CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))
end

function mod:MartyrdomApplied(args)
	self:StopBar(CL.count:format(CL.tank_combo, martyrdomCount))
	if self:Me(args.destGUID) then
		self:Yell(args.spellId, CL.tank_combo)
		self:YellCountdown(args.spellId, 3.5, nil, 2)
	end
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(CL.tank_combo, martyrdomCount))
	self:PlaySound(args.spellId, "alarm")
	martyrdomCount = martyrdomCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][martyrdomCount], CL.count:format(CL.tank_combo, martyrdomCount))
end

function mod:PersecutionApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
end

function mod:Torment(args)
	self:StopBar(CL.count:format(args.spellName, tormentCount))
	self:Message(365436, "yellow", CL.count:format(args.spellName, tormentCount))
	tormentCount = tormentCount + 1
	self:Bar(365436, timers[self:GetStage()][365436][tormentCount], CL.count:format(args.spellName, tormentCount))
end

function mod:TormentApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(365436, "warning")
		--self:Say(365436) -- Everyone Gets it, no need I guess
		--self:SayCountdown(365436, 5)
	end
end

do
	local playerList = {}
	function mod:RuneOfDamnation(args)
		self:StopBar(CL.count:format(CL.bombs, runeOfDamnationCount))
		runeOfDamnationCount = runeOfDamnationCount + 1
		self:Bar(360281, timers[self:GetStage()][360281][runeOfDamnationCount], CL.count:format(CL.bombs, runeOfDamnationCount))
		playerList = {}
	end

	function mod:RuneOfDamnationApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(CL.bomb, icon, icon))
			self:SayCountdown(args.spellId, 6, icon)
			self:Bar("rune_of_damnation_countdown", 4.2, L.jump, 360281) -- Jump a bit earlier
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(CL.bombs, runeOfDamnationCount-1))
		self:CustomIcon(runeOfDamnationMarker, args.destName, icon)
	end

	function mod:RuneOfDamnationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:StopBar(L.jump)
		end
		self:CustomIcon(runeOfDamnationMarker, args.destName)
	end
end

-- Stage Two: Unholy Attunement
function mod:FinalRelentlessDomination()
	self:Message(362028, "red", L.final:format(CL.count:format(L.relentless_domination, relentlessDominationCount)))
	self:PlaySound(362028, "warning")
	self:SetStage(2)

	self:StopBar(CL.count:format(L.relentless_domination, relentlessDominationCount)) -- Relentless Domination
	self:StopBar(CL.count:format(L.chains_of_oppression, chainsOfOppressionCount)) -- Chains of Opression
	self:StopBar(CL.count:format(CL.tank_combo, martyrdomCount)) -- Martyrdom
	self:StopBar(CL.count:format(self:SpellName(365436), tormentCount)) -- Torment
	self:StopBar(CL.count:format(CL.bombs, runeOfDamnationCount)) -- Rune of Damnation
	self:StopBar(CL.count:format(L.mythic_blood_soak_bar, specialCount-1)) -- Heal Azeroth
	if specialTimer then
		self:CancelTimer(specialTimer)
		self:CancelDelayedMessage(CL.count:format(L.mythic_blood_soak_bar, specialCount-2))
		specialTimer = nil
	end

	unholyAttunementCount = 1
	shatteringBlastCount = 1
	runeOfCompulsion = 1
	decimatorCount = 1
	tormentCount = 1

	if not self:Easy() then
		self:Bar(366132, 11.1) -- Tyranny
	end

	self:Bar("floors_open", 16, L.floors_open, "inv_engineering_90_blackhole") -- Holes opening up
	self:Bar(360373, timers[2][360373][unholyAttunementCount], CL.count:format(L.unholy_attunement, unholyAttunementCount)) -- Unholy Attunement
	self:Bar(359856, timers[2][359856][shatteringBlastCount], CL.count:format(L.shattering_blast, shatteringBlastCount)) -- Shattering Blast
	self:Bar(366285, timers[2][366285][runeOfCompulsion], CL.count:format(L.rune_of_compulsion, runeOfCompulsion)) -- Rune of Compulsion
	self:Bar(360562, timers[2][360562][decimatorCount], CL.count:format(CL.knockback, decimatorCount)) -- Decimator
	self:Bar(365436, timers[2][365436][tormentCount], CL.count:format(self:SpellName(365436), tormentCount)) -- Torment

	if self:Mythic() then
		worldCount = 1
		specialCount = 1
		self:Bar(366678, 23, CL.count:format(self:SpellName(366678), worldCount)) -- World Cracker
		self:StartSpecialTimer(mythicSpecialTimers[2][specialCount]) -- Heal Azeroth
	end
end

function mod:UnholyAttunement(args)
	self:StopBar(CL.count:format(L.unholy_attunement, unholyAttunementCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.unholy_attunement, unholyAttunementCount))
	self:PlaySound(args.spellId, "alert")
	unholyAttunementCount = unholyAttunementCount + 1
	self:Bar(args.spellId, timers[2][args.spellId][unholyAttunementCount], unholyAttunementCount == 5 and L.final:format(CL.count:format(L.unholy_attunement, unholyAttunementCount)) or CL.count:format(L.unholy_attunement, unholyAttunementCount))
end

function mod:ShatteringBlast(args)
	self:StopBar(CL.count:format(L.shattering_blast, shatteringBlastCount))
	self:Message(args.spellId, "purple", CL.count:format(L.shattering_blast, shatteringBlastCount))
	self:PlaySound(args.spellId, "alarm")
	shatteringBlastCount = shatteringBlastCount + 1
	self:Bar(args.spellId, timers[2][args.spellId][shatteringBlastCount], CL.count:format(L.shattering_blast, shatteringBlastCount))
end

do
	local playerList = {}
	function mod:RuneOfCompulsion(args)
		self:StopBar(CL.count:format(L.rune_of_compulsion, runeOfCompulsion))
		runeOfCompulsion = runeOfCompulsion + 1
		self:Bar(366285, timers[2][366285][runeOfCompulsion], CL.count:format(L.rune_of_compulsion, runeOfCompulsion))
		playerList = {}
	end

	function mod:RuneOfCompulsionApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(L.rune_of_compulsion, icon, icon))
			self:SayCountdown(args.spellId, 4, icon)
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.rune_of_compulsion, runeOfCompulsion-1))
		self:CustomIcon(runeOfCompulsionMarker, args.destName, icon)
	end

	function mod:RuneOfCompulsionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(runeOfCompulsionMarker, args.destName)
	end
end

function mod:Decimator()
	self:StopBar(CL.count:format(CL.knockback, decimatorCount))
	self:Message(360562, "yellow", CL.count:format(CL.knockback, decimatorCount))
	self:PlaySound(360562, "alert")
	decimatorCount = decimatorCount + 1
	self:Bar(360562, timers[self:GetStage()][360562][decimatorCount], CL.count:format(CL.knockback, decimatorCount))
end

function mod:FinalUnholyAttunement(args)
	self:Message(360373, "yellow", L.final:format(CL.count:format(L.unholy_attunement, unholyAttunementCount)))
	self:PlaySound(360373, "alert")

	self:StopBar(CL.count:format(self:SpellName(366678), worldCount)) -- World Cracker
	self:StopBar(CL.count:format(L.unholy_attunement, unholyAttunementCount)) -- Unholy Attunement
	self:StopBar(CL.count:format(L.shattering_blast, shatteringBlastCount)) -- Shattering Blast
	self:StopBar(CL.count:format(L.rune_of_compulsion, runeOfCompulsion)) -- Rune of Compulsion
	self:StopBar(CL.count:format(CL.knockback, decimatorCount)) -- Decimator
	self:StopBar(CL.count:format(self:SpellName(365436), tormentCount)) -- Torment
	self:StopBar(CL.count:format(L.mythic_blood_soak_bar, specialCount-1)) -- Heal Azeroth

	if specialTimer then
		self:CancelTimer(specialTimer)
		self:CancelDelayedMessage(CL.count:format(L.mythic_blood_soak_bar, specialCount-2)) -- Heal Azeroth
		specialTimer = nil
	end

	self:Bar("floors_open", 3.5, L.floors_open, "inv_engineering_90_blackhole") -- Holes opening up
	self:Bar("stages", 10.5, CL.stage:format(3), 363332) -- Unbreaking Grasp
end

-- Stage Three: Eternity's End
function mod:UnbreakingGrasp(args)
	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
	self:Bar(args.spellId, 15)

	tormentCount = 1
	decimatorCount = 1
	desolationCount = 1
	chainsOfAnguishCount = 1
	runeOfDominationCount = 1
	defileCount = 1
	fallingDebrisCount = 1

	self:Bar(360562, timers[3][360562][decimatorCount], CL.count:format(CL.knockback, decimatorCount)) -- Decimator
	self:Bar(365436, timers[3][365436][tormentCount], CL.count:format(self:SpellName(365436), tormentCount)) -- Torment
	self:Bar(365212, timers[3][365212][chainsOfAnguishCount], CL.count:format(L.chains_of_anguish, chainsOfAnguishCount)) -- Chains of Anguish
	self:Bar(365150, timers[3][365150][runeOfDominationCount], CL.count:format(L.rune_of_domination, runeOfDominationCount)) -- Rune of Domination
	if not self:LFR() then
		self:Bar(365033, timers[3][365033][desolationCount], CL.count:format(L.desolation, desolationCount)) -- Desolation
		self:Bar(365169, timers[3][365169][defileCount], CL.count:format(self:SpellName(365169), defileCount)) -- Defile
	end
	if self:Mythic() then
		worldCount = 1
		specialCount = 1
		self:Bar(367051, 21.5, CL.count:format(self:SpellName(367051), worldCount)) -- World Shatterer
		self:StartSpecialTimer(mythicSpecialTimers[3][specialCount]) -- Heal Azeroth
	end
end

function mod:Desolation(args)
	self:StopBar(CL.count:format(L.desolation, desolationCount))
	self:Message(args.spellId, "red", CL.count:format(L.desolation, desolationCount))
	self:PlaySound(args.spellId, "alert")
	desolationCount = desolationCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][desolationCount], CL.count:format(L.desolation, desolationCount))
end

do
	local playerList = {}
	function mod:RuneOfDomination(args)
		self:StopBar(CL.count:format(L.rune_of_domination, runeOfDominationCount))
		runeOfDominationCount = runeOfDominationCount + 1
		self:Bar(365150, timers[3][365150][runeOfDominationCount], CL.count:format(L.rune_of_domination, runeOfDominationCount))
		playerList = {}
	end

	function mod:RuneOfDominationApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(L.rune_of_domination, icon, icon))
			self:SayCountdown(args.spellId, 6, icon)
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.rune_of_domination, runeOfDominationCount-1))
		self:CustomIcon(runeOfDominationMarker, args.destName, icon)
	end

	function mod:RuneOfDominationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(runeOfDominationMarker, args.destName)
	end
end

do
	local playerList = {}
	local removed, count = 0, 0
	function mod:ChainsOfAnguish(args)
		self:StopBar(CL.count:format(L.chains_of_anguish, chainsOfAnguishCount))
		self:Message(args.spellId, "yellow", CL.count:format(L.chain_target:format(self:ColorName(self:UnitName("boss1target") or "???")), chainsOfAnguishCount))
		if self:Tank() then
			self:PlaySound(args.spellId, "warning")
		else
			self:PlaySound(args.spellId, "alert")
		end
		chainsOfAnguishCount = chainsOfAnguishCount + 1
		playerList = {}
		removed, count = 0, 0
		self:Bar(args.spellId, timers[3][args.spellId][chainsOfAnguishCount], CL.count:format(L.chains_of_anguish, chainsOfAnguishCount))
	end

	function mod:ChainsOfAnguishApplied(args)
		count = #playerList+1
		local icon = 9 - count -- 8, 7, 6, 5
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(365212, "warning")
		end
		self:NewTargetsMessage(365212, "yellow", playerList, nil, CL.count:format(L.chains_of_anguish, chainsOfAnguishCount-1))
		self:CustomIcon(chainsOfAnguishMarker, args.destName, icon)
	end

	function mod:ChainsOfAnguishRemoved(args)
		removed = removed + 1
		if self:Me(args.destGUID) then
			self:Message(365212, "blue", CL.removed:format(L.chains_of_anguish))
		end
		self:Message(365212, "green", L.chains_remaining:format(removed, count))
		self:PlaySound(365212, "info")
		self:CustomIcon(chainsOfAnguishMarker, args.destName)
	end
end

function mod:Defile(args)
	self:StopBar(CL.count:format(args.spellName, defileCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, defileCount))
	self:PlaySound(args.spellId, "warning")
	defileCount = defileCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][defileCount], CL.count:format(args.spellName, defileCount))
end

-- Mythic
function mod:StartSpecialTimer(t)
	local stage = self:GetStage()
	local text = L.mythic_blood_soak_bar
	local icon = L.mythic_blood_soak_icon
	local spellId = stage == 1 and "mythic_blood_soak_stage_1" or stage == 2 and "mythic_blood_soak_stage_2" or "mythic_blood_soak_stage_3" -- SetOption:"mythic_blood_soak_stage_1","mythic_blood_soak_stage_2","mythic_blood_soak_stage_3":
	self:Bar(spellId, t, CL.count:format(text, specialCount), icon)
	self:DelayedMessage(spellId, t, "yellow", CL.count:format(text, specialCount), icon, "long")
	specialCount = specialCount + 1
	if mythicSpecialTimers[stage][specialCount] then
		specialTimer = self:ScheduleTimer("StartSpecialTimer", t, mythicSpecialTimers[stage][specialCount])
	end
end

function mod:WorldCrusher(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:WorldCracker(args)
	self:StopBar(CL.count:format(args.spellName, worldCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, worldCount))
	self:PlaySound(args.spellId, "info")
	worldCount = worldCount + 1
	if worldCount < 5 then
		self:Bar(args.spellId, timers[2][360373][unholyAttunementCount], CL.count:format(args.spellName, worldCount)) -- Re-use unholy attunement timers
	end
end

function mod:WorldShatterer(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end
