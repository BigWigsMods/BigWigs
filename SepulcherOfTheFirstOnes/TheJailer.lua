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

local timersNormal = {
	[360281] = { 11.0, 19.0, 34.0, 33.0, 28.0, 26.0, 0 }, -- Rune of Damnation
	[365436] = { 22.0, 51.0, 69.0, 0, }, -- Torment
	[363893] = { 40.0, 40.0, 40.0, 40.0, 0, }, -- Martyrdom
	[362028] = { 48.0, 60.0, 60.0, 0 }, -- Relentless Domination

	-- from Unholy Attunement
	[365436.2] = { 23, 50.0, 55.0, 44.6, 87.0 }, -- Torment
	[360562] = { 9.0, 57.5, 47.5, 43.0, }, -- Decimator
	[359856] = { 15.5, 13.5, 30.0, 15.0, 31.0, 15.5, }, -- Shattering Blast
	[366285] = { 43.0, 60.0, }, -- Rune of Compulsion

	-- from Unbreakable Grasp
	[360562.3] = { 35.0, 52.0, 42.0, 42.0, 42.0, }, -- Decimator
	[365033] = { 42.0, 60.0, }, -- Desolation
	[370071] = { 51, 75, }, -- Torment
	[365212] = { 52.0, 42.0, 42.0, 42.0, 42.0, 42.0, 42.0, 42.0, }, -- Chains of Anguish
	[365169] = { 55.0, 41.0, 43.0, 43.0, 43.0, 43.0, 43.0, 43.0, }, -- Defile
	[365150] = { 63.0, 84.0, }, -- Rune of Domination
}

local timersHeroic = {
	[360281] = { 22.0, 25.0, 29.0, 21.0, 30.5, 19.5, 0 }, -- Rune of Damnation
	[365436] = { 11.0, 52.0, 45.0, 47.0, 0 }, -- Torment
	[363893] = { 31.0, 40.0, 52.0, 39.0, 0 }, -- Martyrdom
	[362028] = { 55.0, 57.0, 56.0, 0 }, -- Relentless Domination
	[359809] = { 40.0, 48.0, 49.0, 0 }, -- Chains of Oppression

	-- from Unholy Attunement
	[365436.2] = { 3.0, 35.0, 16.1, 5.5, 61.5, 29.0, 30.0, }, -- Torment
	[360562] = { 7.0, 41.0, 35.0, 45.0, 41.0, }, -- Decimator
	[359856] = { 14.0, 16.0, 30.0, 15.0, 29.0, 17.0, 29.0, 14.0, }, -- Shattering Blast
	[366285] = { 22.0, 46.1, 45.0, 47.0, }, -- Rune of Compulsion

	-- from Unbreakable Grasp
	[360562.3] = { 26.4, 38.0, 47.0, 33.0, 40.0, }, -- Decimator
	[365169] = { 33.4, 45.0, 45.0, 52.0, }, -- Defile
	[365212] = { 37.4, 55.0, 43.0, 43.0, 43.0, 43.0, 43.0, 43.0, }, -- Chains of Anguish
	[365033] = { 42.4, 60.0, 64.0, }, -- Desolation
	[370071] = { 51.1, 75, }, -- Torment
	[365150] = { 71.4, 79.0, }, -- Rune of Domination
}

local timers = mod:Easy() and timersNormal or timersHeroic


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rune_of_damnation_countdown = "Countdown"
	L.rune_of_damnation_countdown_icon = 360281 -- Grim Portent
	L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	L.jump = "Jump In"

	L.chain = "Chain"
	L.rune = "Rune"

	L.chain_target = "Chaining %s!"
	L.chains_remaining = "%d/%d Chains Broken"

	L.relentless_domination = mod:SpellName(362028)
	L.chains_of_oppression = "Pull Chains"
	L.unholy_attunement = "Pylons"
	L.decimator = CL.knockback
	L.chains_of_anguish = "Spread Chains"
	L.rune_of_damnation = "Knock Runes"
	L.rune_of_compulsion = "MC Runes"
	L.rune_of_domination = "Heal Runes"
end

--------------------------------------------------------------------------------
-- Initialization
--

local runeOfCompulsionMarker = mod:AddMarkerOption(false, "player", 1, 366285, 1, 2, 3, 4) -- Rune of Compulsion
local chainsOfAnguishMarker = mod:AddMarkerOption(false, "player", 1, 365212, 1, 2, 3, 4) -- Chains of Anguish
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Origin of Domination
		362028, -- Relentless Domination
		362075, -- Domination
		{366132, "SAY"}, -- Tyranny
		359809, -- Chains of Oppression
		{363893, "SAY", "SAY_COUNTDOWN"}, -- Martyrdom
		{366545, "TANK"}, -- Persecution
		365436, -- Torment
		{360281, "SAY_COUNTDOWN"}, -- Rune of Damnation
		{"rune_of_damnation_countdown", "COUNTDOWN"},
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
		365212, -- Chains of Anguish
		chainsOfAnguishMarker,
		365169, -- Defile
		362012, -- Eternity's End
		365810, -- Falling Debris
	},{
		[362028] = -24087, -- Stage One: Origin of Domination
		[360373] = -23925, -- Stage Two: Unholy Attunement
		[365033] = -24252, -- Stage Three: Eternity's End
		[365810] = CL.mythic, -- Mythic
	},{
		-- [362028] = L.relentless_domination, -- Relentless Domination
		[362631] = L.chains_of_oppression, -- Chains of Oppression (Pull Chains)
		[363893] = CL.tank_combo, -- Martyrdom (Tank Combo)
		[360281] = L.rune_of_damnation, -- Rune of Damnation (Knock Runes)
		["rune_of_damnation_countdown"] = L.jump,
		[360373] = L.unholy_attunement, -- Unholy Attunement (Pylons)
		[366285] = L.rune_of_compulsion, -- Rune of Compulsion (MC Runes)
		[365150] = L.rune_of_domination, -- Rune of Domination (Heal Runes)
		[365212] = L.chains_of_anguish, -- Chains of Anguish (Spread Chains)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One: Origin of Domination
	self:Log("SPELL_CAST_START", "RelentlessDomination", 362028, 367851) -- 367851 = transition cast (always #3)
	self:Log("SPELL_AURA_APPLIED", "DominationApplied", 362075)
	self:Log("SPELL_AURA_APPLIED", "TyrannyApplied", 366132)
	self:Log("SPELL_CAST_SUCCESS", "ChainsOfOppression", 359809)
	self:Log("SPELL_AURA_APPLIED", "MartyrdomApplied", 363893)
	self:Log("SPELL_AURA_APPLIED", "PersecutionApplied", 366545)
	self:Log("SPELL_CAST_SUCCESS", "Torment", 365436, 370071) -- p1/p2, p3 (+adds)
	self:Log("SPELL_AURA_APPLIED", "RuneOfDamnationApplied", 360281)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDamnationRemoved", 360281)
	-- Stage Two: Unholy Attunement
	self:Log("SPELL_CAST_START", "UnholyAttunement", 360373, 367290) -- 367290 = transition cast
	self:Log("SPELL_CAST_START", "ShatteringBlast", 359856)
	self:Log("SPELL_AURA_APPLIED", "RuneOfCompulsionApplied", 366285)
	self:Log("SPELL_AURA_REMOVED", "RuneOfCompulsionRemoved", 366285)
	self:Log("SPELL_CAST_START", "Decimator", 360562, 364942) -- 364942 sometimes cast?
	-- Stage Three: Eternity's End
	self:Log("SPELL_CAST_SUCCESS", "UnbreakableGrasp", 363332)
	self:Log("SPELL_CAST_START", "Desolation", 365033)
	self:Log("SPELL_AURA_APPLIED", "RuneOfDominationApplied", 365150)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDominationRemoved", 365150)
	self:Log("SPELL_CAST_START", "ChainsOfAnguish", 365212)
	self:Log("SPELL_AURA_APPLIED", "ChainsOfAnguishApplied", 365222) -- 365219 Initial Target, 365222 Secondary Targets
	self:Log("SPELL_AURA_REMOVED", "ChainsOfAnguishRemoved", 365222)
	self:Log("SPELL_CAST_START", "Defile", 365169)
	self:Log("SPELL_CAST_START", "EternitysEnd", 362012)
	-- -- Mythic
	self:Log("SPELL_CAST_SUCCESS", "FallingDebris", 365810)
end

function mod:OnEngage()
	timers = mod:Easy() and timersNormal or timersHeroic
	self:SetStage(1)

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

	self:Bar(360281, timers[360281][runeOfDamnationCount], CL.count:format(L.rune_of_damnation, runeOfDamnationCount))
	self:Bar(365436, timers[365436][tormentCount], CL.count:format(self:SpellName(365436), tormentCount))
	self:Bar(363893, timers[363893][martyrdomCount], CL.count:format(CL.tank_combo, martyrdomCount))
	self:Bar(362028, timers[362028][relentlessDominationCount], CL.count:format(L.relentless_domination, relentlessDominationCount))
	self:Bar(359809, timers[359809][chainsOfOppressionCount], CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))
	self:Bar("stages", 184, CL.stage:format(2), 360373) -- Unholy Attunement
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EternitysEnd(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

-- Stage One: Origin of Domination

function mod:RelentlessDomination(args)
	self:StopBar(CL.count:format(L.relentless_domination, relentlessDominationCount))
	self:Message(362028, "red", CL.count:format(L.relentless_domination, relentlessDominationCount))
	self:PlaySound(362028, "warning")
	relentlessDominationCount = relentlessDominationCount + 1
	self:Bar(362028, timers[362028][relentlessDominationCount], CL.count:format(L.relentless_domination, relentlessDominationCount))
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
		self:NewTargetsMessage(args.spellId, "red", playerList)
		self:PlaySound(args.spellId, "alarm")
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
			self:Message(args.spellId, "orange")
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
	self:Bar(359809, timers[359809][chainsOfOppressionCount], CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))
end

function mod:MartyrdomApplied(args)
	self:StopBar(CL.count:format(CL.tank_combo, martyrdomCount))
	if self:Me(args.destGUID) then
		self:Yell(args.spellId, CL.tank_combo)
		self:YellCountdown(args.spellId, 3, nil, 2)
	end
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(CL.tank_combo, martyrdomCount))
	self:PlaySound(args.spellId, "alarm")
	martyrdomCount = martyrdomCount + 1
	self:Bar(args.spellId, timers[args.spellId][martyrdomCount], CL.count:format(CL.tank_combo, martyrdomCount))
end

function mod:PersecutionApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
end

function mod:Torment(args)
	self:StopBar(CL.count:format(args.spellName, tormentCount))
	self:Message(365436, "orange", CL.count:format(args.spellName, tormentCount))
	tormentCount = tormentCount + 1
	if self:GetStage() == 2 then
		self:Bar(365436, timers[365436.2][tormentCount], CL.count:format(args.spellName, tormentCount))
	else
		self:Bar(365436, timers[args.spellId][tormentCount], CL.count:format(args.spellName, tormentCount))
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:RuneOfDamnationApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			playerList = {}
			self:StopBar(CL.count:format(L.rune_of_damnation, runeOfDamnationCount))
			runeOfDamnationCount = runeOfDamnationCount + 1
			self:Bar(args.spellId, timers[360281][runeOfDamnationCount], CL.count:format(L.rune_of_damnation, runeOfDamnationCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:SayCountdown(args.spellId, 6)
			self:Bar("rune_of_damnation_countdown", 7.5, L.jump, 360281) -- added some time since jumping in after 0 is weird
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.rune_of_damnation, runeOfDamnationCount-1))
	end

	function mod:RuneOfDamnationRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(L.jump)
			self:CancelSayCountdown(args.spellId)
		end
	end
end

-- Stage Two: Unholy Attunement
function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 364441 then -- Set Floor Layout P2
		self:StopBar(CL.stage:format(2))
		self:StopBar(CL.count:format(self:SpellName(362028), relentlessDominationCount))
		self:StopBar(366020) -- Tyranny
		self:StopBar(CL.count:format(self:SpellName(365436), tormentCount))
		self:StopBar(CL.count:format(L.rune_of_damnation, runeOfDamnationCount))
		self:StopBar(CL.count:format(CL.tank_combo, martyrdomCount))
		self:StopBar(CL.count:format(L.chains_of_oppression, chainsOfOppressionCount))

		self:SetStage(2)
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
		tormentCount = 1

		local diff = 3.4 -- 2.6-3.4?
		self:Bar(360373, diff, CL.count:format(L.unholy_attunement, unholyAttunementCount)) -- Unholy Attunment
		-- timers are from the first Unholy Attunement cast, just add the difference here
		self:Bar(365436, timers[365436.2][tormentCount] + diff, CL.count:format(self:SpellName(365436), tormentCount)) -- Torment
		self:Bar(360562, timers[360562][decimatorCount] + diff, CL.count:format(L.decimator, decimatorCount)) -- Decimator
		self:Bar(359856, timers[359856][shatteringBlastCount] + diff, CL.count:format(self:SpellName(359856), shatteringBlastCount)) -- Shattering Blast
		self:Bar(366285, timers[366285][runeOfCompulsion] + diff, CL.count:format(L.rune_of_compulsion, runeOfCompulsion)) -- Rune of Compulsion
	end
end

function mod:UnholyAttunement(args)
	self:StopBar(CL.count:format(L.unholy_attunement, unholyAttunementCount))
	self:Message(360373, "yellow", CL.count:format(L.unholy_attunement, unholyAttunementCount))
	self:PlaySound(360373, "alert")
	unholyAttunementCount = unholyAttunementCount + 1
	if args.spellId == 367290 then -- Stage 3 Transition
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(3)), false)
		self:Bar("stages", 10.5, CL.stage:format(3), 363332)
		-- safe to just stop everything?
		self:StopBar(CL.count:format(self:SpellName(365436), tormentCount))
		self:StopBar(CL.count:format(L.decimator, decimatorCount))
		self:StopBar(CL.count:format(self:SpellName(359856), shatteringBlastCount))
		self:StopBar(CL.count:format(L.rune_of_compulsion, runeOfCompulsion))
	else
		self:Bar(360373, 45, CL.count:format(L.unholy_attunement, unholyAttunementCount))
	end
end

function mod:ShatteringBlast(args)
	self:StopBar(CL.count:format(args.spellName, shatteringBlastCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, shatteringBlastCount))
	self:PlaySound(args.spellId, "alarm")
	shatteringBlastCount = shatteringBlastCount + 1
	self:Bar(args.spellId, timers[args.spellId][shatteringBlastCount], CL.count:format(args.spellName, shatteringBlastCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:RuneOfCompulsionApplied(args)
		local t = args.time
		if t-prev > 2 then
			self:StopBar(CL.count:format(L.rune_of_compulsion, runeOfCompulsion))
			playerList = {}
			prev = t
			runeOfCompulsion = runeOfCompulsion + 1
			self:Bar(args.spellId, timers[args.spellId][runeOfCompulsion], CL.count:format(L.rune_of_compulsion, runeOfCompulsion))
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.rune)
			self:SayCountdown(args.spellId, 4)
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

local prevDecimator = 0
function mod:Decimator(args)
	self:StopBar(CL.count:format(L.decimator, decimatorCount))
	self:Message(360562, "yellow", CL.count:format(L.decimator, decimatorCount))
	self:PlaySound(360562, "alert")
	-- self:CastBar(360562, 4)
	decimatorCount = decimatorCount + 1
	if self:GetStage() == 3 then
		self:Bar(360562, timers[360562.3][decimatorCount], CL.count:format(L.decimator, decimatorCount))
	else
		-- what is 364942 actually for?
		-- XXX can skip a cast? fucks up the table times, check last?
		self:Bar(360562, timers[360562][decimatorCount], CL.count:format(L.decimator, decimatorCount))
	end
end

-- Stage Three: Eternity's End
function mod:UnbreakableGrasp(args)
	self:StopBar(CL.count:format(self:SpellName(365436), tormentCount))
	self:StopBar(CL.count:format(L.decimator, decimatorCount))
	self:StopBar(CL.count:format(L.unholy_attunement, unholyAttunementCount))
	self:StopBar(CL.count:format(L.rune_of_compulsion, runeOfCompulsion))
	self:StopBar(CL.count:format(self:SpellName(359856), shatteringBlastCount))

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
	self:Bar(args.spellId, 15)

	tormentCount = 1
	decimatorCount = 1

	self:Bar(360562, timers[360562.3][decimatorCount], CL.count:format(L.decimator, decimatorCount)) -- Decimator
	self:Bar(365436, timers[370071][tormentCount], CL.count:format(self:SpellName(365436), tormentCount)) -- Torment
	self:Bar(365033, timers[365033][desolationCount], CL.count:format(self:SpellName(365033), desolationCount)) -- Desolation
	self:Bar(365212, timers[365212][chainsOfAnguishCount], CL.count:format(L.chains_of_anguish, chainsOfAnguishCount)) -- Chains of Anguish
	self:Bar(365150, timers[365150][runeOfDominationCount], CL.count:format(L.rune_of_domination, runeOfDominationCount)) -- Rune of Domination
	if not self:Easy() then
		self:Bar(365169, timers[365169][defileCount], CL.count:format(self:SpellName(365169), defileCount)) -- Defile
	end
end

function mod:Desolation(args)
	self:StopBar(CL.count:format(args.spellName, desolationCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, desolationCount))
	self:PlaySound(args.spellId, "alert")
	desolationCount = desolationCount + 1
	self:Bar(args.spellId, timers[args.spellId][desolationCount] or 60, CL.count:format(args.spellName, desolationCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:RuneOfDominationApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			playerList = {}
			self:StopBar(CL.count:format(L.rune_of_domination, runeOfDominationCount))
			runeOfDominationCount = runeOfDominationCount + 1
			self:Bar(args.spellId, timers[args.spellId][runeOfDominationCount], CL.count:format(L.rune_of_domination, runeOfDominationCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.rune)
			self:SayCountdown(args.spellId, 6)
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.rune_of_domination, runeOfDominationCount-1))
	end

	function mod:RuneOfDominationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
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
		self:Bar(args.spellId, timers[args.spellId][chainsOfAnguishCount], CL.count:format(L.chains_of_anguish, chainsOfAnguishCount))
	end

	function mod:ChainsOfAnguishApplied(args)
		count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
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
	self:Bar(args.spellId, timers[args.spellId][defileCount], CL.count:format(args.spellName, defileCount))
end

function mod:FallingDebris(args)
	self:StopBar(CL.count:format(args.spellName, fallingDebrisCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, fallingDebrisCount))
	self:PlaySound(args.spellId, "alarm")
	fallingDebrisCount = fallingDebrisCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, fallingDebrisCount))
end
