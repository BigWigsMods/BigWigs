--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Jailer", 2481, 2464)
if not mod then return end
mod:RegisterEnableMob(185421) -- The Jailer
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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rune_of_damnation_countdown = "Countdown"
	L.rune_of_damnation_countdown_icon = 360281 -- Grim Portent
	L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: Origin of Domination
		362028, -- Relentless Domination
		362075, -- Domination
		{366020, "SAY"}, -- Mark of Tyranny
		362631, -- Chains of Oppression
		{363893, "SAY"}, -- Martyrdom
		{362401, "SAY", "SAY_COUNTDOWN"}, -- Torment
		{360281, "SAY_COUNTDOWN"}, -- Rune of Damnation
		{"rune_of_damnation_countdown", "COUNTDOWN"},
		-- Stage Two: Unholy Attunement
		360373, -- Unholy Attunement
		359856, -- Shattering Blast
		366285, -- Rune of Compulsion
		364488, -- Decimator
		-- Stage Three: Eternity's End
		365033, -- Desolation
		365150, -- Rune of Domination
		365212, -- Chains of Anguish
		365169, -- Defile
		365810, -- Falling Debris
	},{
		[362028] = -24087, -- Stage One: Origin of Domination
		[360373] = -23925, -- Stage Two: Unholy Attunement
		[365033] = -24252, -- Stage Three: Eternity's End
	}
end

function mod:OnBossEnable()
	-- Stage One: Origin of Domination
	self:Log("SPELL_CAST_START", "RelentlessDomination", 362028)
	self:Log("SPELL_AURA_APPLIED", "DominationApplied", 362075)
	self:Log("SPELL_AURA_APPLIED", "MarkOfTyrannyApplied", 366020)
	self:Log("SPELL_CAST_SUCCESS", "ChainsOfOppression", 362631)
	self:Log("SPELL_AURA_APPLIED", "MartyrdomApplied", 363893)
	self:Log("SPELL_AURA_APPLIED", "TormentApplied", 362401)
	self:Log("SPELL_AURA_APPLIED", "RuneOfDamnationApplied", 360281)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDamnationRemoved", 360281)
	-- Stage Two: Unholy Attunement
	self:Log("SPELL_CAST_START", "UnholyAttunement", 360373)
	self:Log("SPELL_CAST_START", "ShatteringBlast", 359856)
	self:Log("SPELL_AURA_APPLIED", "runeOfCompulsionApplied", 366285)
	self:Log("SPELL_AURA_REMOVED", "runeOfCompulsionRemoved", 366285)
	self:Log("SPELL_CAST_START", "Decimator", 364488)
	-- Stage Three: Eternity's End
	self:Log("SPELL_CAST_START", "Desolation", 365033)
	self:Log("SPELL_AURA_APPLIED", "RuneOfDominationApplied", 365150)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDominationRemoved", 365150)
	self:Log("SPELL_CAST_START", "ChainsOfAnguish", 365212)
	self:Log("SPELL_AURA_APPLIED", "ChainsOfAnguishApplied", 365219, 365222) -- Initial Target, Secondary Targets
	self:Log("SPELL_AURA_REMOVED", "ChainsOfAnguishRemoved", 365219, 365222)
	self:Log("SPELL_CAST_START", "Defile", 365169)
	self:Log("SPELL_CAST_SUCCESS", "FallingDebris", 365810)
end

function mod:OnEngage()
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

	--self:Bar(362058, 0, CL.count:format(self:SpellName(362058), relentlessDominationCount))
	--self:Bar(362631, 0, CL.count:format(self:SpellName(362631), chainsOfOppressionCount))
	--self:Bar(363893, 0, CL.count:format(self:SpellName(363893), martyrdomCount))
	--self:Bar(362401, 0, CL.count:format(self:SpellName(362401), tormentCount))
	--self:Bar(360281, 0, CL.count:format(self:SpellName(360281), runeOfDamnationCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Origin of Domination
function mod:RelentlessDomination(args)
	self:StopBar(CL.count:format(args.spellName, relentlessDominationCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, relentlessDominationCount))
	self:PlaySound(args.spellId, "warning")
	relentlessDominationCount = relentlessDominationCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, relentlessDominationCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:DominationApplied(args)
		local t = args.time
		if t-prev > 2 then
			playerList = {}
			prev = t
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
	local playerList = {}
	function mod:MarkOfTyrannyApplied(args)
		local t = args.time
		if t-prev > 2 then
			playerList = {}
			prev = t
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId)
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
	end
end

function mod:ChainsOfOppression(args)
	self:StopBar(CL.count:format(args.spellName, chainsOfOppressionCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, chainsOfOppressionCount))
	self:PlaySound(args.spellId, "alert")
	chainsOfOppressionCount = chainsOfOppressionCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, chainsOfOppressionCount))
end

function mod:MartyrdomApplied(args)
	self:StopBar(CL.count:format(args.spellName, martyrdomCount))
	if self:Me(args.destGUID) then
		self:Yell(args.spellId)
		self:YellCountdown(args.spellId, 3, nil, 2)
	end
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, martyrdomCount))
	self:PlaySound(args.spellId, "alarm")
	martyrdomCount = martyrdomCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, martyrdomCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:TormentApplied(args)
		local t = args.time
		if t-prev > 2 then
			self:StopBar(CL.count:format(args.spellName, tormentCount))
			playerList = {}
			prev = t
			tormentCount = tormentCount + 1
			--self:Bar(args.spellId, 0, CL.count:format(args.spellName, tormentCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, tormentCount-1))
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:RuneOfDamnationApplied(args)
		local t = args.time
		if t-prev > 2 then
			self:StopBar(CL.count:format(args.spellName, runeOfDamnationCount))
			playerList = {}
			prev = t
			runeOfDamnationCount = runeOfDamnationCount + 1
			--self:Bar(args.spellId, 0, CL.count:format(args.spellName, runeOfDamnationCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:SayCountdown(args.spellId, 6)
			self:TargetBar("rune_of_damnation_countdown", 6, args.destName, args.spellName)
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, runeOfDamnationCount-1))
	end

	function mod:RuneOfDamnationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:StopBar(args.spellName, args.destName)
		end
	end
end

-- Stage Two: Unholy Attunement
function mod:UnholyAttunement(args)
	self:StopBar(CL.count:format(args.spellName, unholyAttunementCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, unholyAttunementCount))
	self:PlaySound(args.spellId, "alert")
	unholyAttunementCount = unholyAttunementCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, unholyAttunementCount))
end

function mod:ShatteringBlast(args)
	self:StopBar(CL.count:format(args.spellName, shatteringBlastCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, shatteringBlastCount))
	self:PlaySound(args.spellId, "alarm")
	shatteringBlastCount = shatteringBlastCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, shatteringBlastCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:runeOfCompulsionApplied(args)
		local t = args.time
		if t-prev > 2 then
			self:StopBar(CL.count:format(args.spellName, runeOfCompulsion))
			playerList = {}
			prev = t
			runeOfCompulsion = runeOfCompulsion + 1
			--self:Bar(args.spellId, 0, CL.count:format(args.spellName, runeOfCompulsion))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellName)
			self:SayCountdown(args.spellId, 4)
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, runeOfCompulsion-1))
	end

	function mod:runeOfCompulsionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:Decimator(args)
	self:StopBar(CL.count:format(args.spellName, decimatorCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, decimatorCount))
	self:PlaySound(args.spellId, "alert")
	decimatorCount = decimatorCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, decimatorCount))
end

-- Stage Three: Eternity's End
function mod:Desolation(args)
	self:StopBar(CL.count:format(args.spellName, desolationCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, desolationCount))
	self:PlaySound(args.spellId, "alert")
	desolationCount = desolationCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, desolationCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:RuneOfDominationApplied(args)
		local t = args.time
		if t-prev > 2 then
			self:StopBar(CL.count:format(args.spellName, runeOfDominationCount))
			playerList = {}
			prev = t
			runeOfDominationCount = runeOfDominationCount + 1
			--self:Bar(args.spellId, 0, CL.count:format(args.spellName, runeOfDominationCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellName)
			self:SayCountdown(args.spellId, 6.5)
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, runeOfDominationCount-1))
	end

	function mod:RuneOfDominationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local playerList = {}
	function mod:ChainsOfAnguish(args)
		self:StopBar(CL.count:format(args.spellName, chainsOfAnguishCount))
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, chainsOfAnguishCount))
		self:PlaySound(args.spellId, "alert")
		chainsOfAnguishCount = chainsOfAnguishCount + 1
		playerList = {}
		--self:Bar(args.spellId, 0, CL.count:format(args.spellName, chainsOfAnguishCount))
	end

	function mod:ChainsOfAnguishApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(365212, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, runeOfDominationCount-1))
	end

	function mod:ChainsOfAnguishRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(365212, "green", CL.removed:format(args.spellName))
			self:PlaySound(365212, "info")
		end
	end
end

function mod:Defile(args)
	self:StopBar(CL.count:format(args.spellName, defileCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, defileCount))
	self:PlaySound(args.spellId, "warning")
	defileCount = defileCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, defileCount))
end

function mod:FallingDebris(args)
	self:StopBar(CL.count:format(args.spellName, fallingDebrisCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, fallingDebrisCount))
	self:PlaySound(args.spellId, "alarm")
	fallingDebrisCount = fallingDebrisCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, fallingDebrisCount))
end