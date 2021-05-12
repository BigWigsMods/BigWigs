--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("The Nine", 2450, 2439)
if not mod then return end
mod:RegisterEnableMob(177095, 177094, 175726) -- Kyra, Signe, Skyja
mod:SetEncounterID(2429)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local shardOfDestinyCount = 1
local callOfTheValkyrCount = 1
local formlessMassCount = 1
local wingsOfRageCount = 1
local songOfDissolutionCount = 1
local reverberatingRefrainCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end

--------------------------------------------------------------------------------
-- Initialization
--

local fragmentsMarker = mod:AddMarkerOption(false, "player", 1, 350542, 1, 2, 3, 4, 5) -- Fragments of Destiny
local formlessMassMarker = mod:AddMarkerOption(false, "npc", 8, 350342, 8) -- Formless Mass
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Unending Voice
		{350542, "SAY"}, -- Fragments of Destiny // Note: Placed this first so ordering in bigwigs looks better vs Encounter Journal
		fragmentsMarker,
		350555, -- Shard of Destiny
		-- Kyra, The Unending
		350202, -- Unending Strike
		350342, -- Formless Mass
		formlessMassMarker,
		350339, -- Siphon Vitality
		350365, -- Wings of Rage
		-- Signe, The Voice
		350283, -- Soulful Blast
		350286, -- Song of Dissolution
		350385, -- Reverberating Refrain
		-- Call of the Val'kyr
		350467, -- Call of the Val'kyr
		350031, -- Agatha's Eternal Blade
		{350184, "SAY", "SAY_COUNTDOWN"}, -- Daschla's Mighty Anvil
		350157, -- Annhylde's Bright Aegis
		350098, -- Aradne's Falling Strike
		{350109, "SAY", "SAY_COUNTDOWN"}, -- Brynja's Mournful Dirge
		{350039, "SAY", "SAY_COUNTDOWN"}, -- Arthura's Crushing Gaze
		-- Stage Two: The First of the Mawsworn
		{350475, "TANK"}, -- Pierce Soul
		351399, -- Resentment
		350482, -- Link Essence
		350687, -- Word of Recall
	},{
		["stages"] = "general",
		[350542] = mod:SpellName(-22877), -- Stage One: The Unending Voice
		[350202] = mod:SpellName(-23202), -- Kyra, The Unending
		[350283] = mod:SpellName(-23203), -- Signe, The Voice
		[350467] = mod:SpellName(-23206), -- Call of the Val'kyr
		[350475] = mod:SpellName(-22879), -- Stage Two: The First of the Mawsworn
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One: The Unending Voice
	self:Log("SPELL_AURA_APPLIED", "FragmentsOfDestiny", 350542)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FragmentsOfDestinyStacks", 350542)
	self:Log("SPELL_AURA_APPLIED", "ShardOfDestinyAreaEffect", 350555)
	self:Log("SPELL_PERIODIC_DAMAGE", "ShardOfDestinyAreaEffect", 350555)
	self:Log("SPELL_PERIODIC_MISSED", "ShardOfDestinyAreaEffect", 350555)

	-- Kyra, The Unending
	self:Log("SPELL_CAST_START", "UnendingStrike", 350202)
	self:Log("SPELL_AURA_APPLIED", "UnendingStrikeApplied", 350202)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnendingStrikeApplied", 350202)
	self:Log("SPELL_CAST_START", "FormlessMass", 350342)
	self:Log("SPELL_CAST_START", "SiphonVitality", 350339)
	self:Log("SPELL_CAST_START", "WingsOfRage", 350365)
	self:Death("KyraDeath", 177095)

	-- Signe, The Voice
	self:Log("SPELL_CAST_SUCCESS", "SongOfDissolution", 350286)
	self:Log("SPELL_CAST_START", "ReverberatingRefrain", 350385)
	self:Death("SigneDeath", 177094)

	-- Call of the Val'kyr
	self:Log("SPELL_CAST_START", "CallOfTheValkyr", 350467)
	--self:Log("SPELL_CAST_SUCCESS", "AgathasEternalBlade", 350031) XXX Use a yell?
	self:Log("SPELL_CAST_SUCCESS", "DaschlasMightyAnvil", 350184)
	self:Log("SPELL_CAST_SUCCESS", "DaschlasMightyAnvilApplied", 350184)
	self:Log("SPELL_AURA_APPLIED", "AnnhyldesBrightAegisApplied", 350158)
	--self:Log("SPELL_CAST_SUCCESS", "AradnesFallingStrike", 350098) XXX Use a yell?
	self:Log("SPELL_AURA_APPLIED", "BrynjasMournfulDirgeApplied", 350109)
	self:Log("SPELL_AURA_REMOVED", "BrynjasMournfulDirgeRemoved", 350109)
	self:Log("SPELL_CAST_SUCCESS", "ArthurasCrushingGaze", 350039)
	self:Log("SPELL_AURA_APPLIED", "ArthurasCrushingGazeApplied", 350039)
	self:Log("SPELL_AURA_REMOVED", "ArthurasCrushingGazeRemoved", 350039)

	-- Stage Two: The First of the Mawsworn
	self:Log("SPELL_AURA_APPLIED", "PierceSoulApplied", 350475)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PierceSoulApplied", 350475)
	self:Log("SPELL_CAST_SUCCESS", "Resentment", 351399)
	self:Log("SPELL_AURA_APPLIED", "LinkEssence", 350482)
	self:Log("SPELL_CAST_START", "WordOfRecall", 350687)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	self:SetStage(1)

	shardOfDestinyCount = 1
	callOfTheValkyrCount = 1
	formlessMassCount = 1
	wingsOfRageCount = 1
	songOfDissolutionCount = 1
	reverberatingRefrainCount = 1

	self:Bar(350202, 6) -- Unending Strike
	self:Bar(350342, 12, CL.count:format(self:SpellName(350342), formlessMassCount)) -- Formless Mass
	self:Bar(350467, 14.6, CL.count:format(self:SpellName(350467), callOfTheValkyrCount)) -- Call of the Val'kyr
	self:Bar(350286, 47.5, CL.count:format(self:SpellName(350286), songOfDissolutionCount)) -- Song of Dissolution
	self:Bar(350365, 47.5, CL.count:format(self:SpellName(350365), wingsOfRageCount)) -- Wings of Rage
	self:Bar(350385, 71.5, CL.count:format(self:SpellName(350385), reverberatingRefrainCount)) -- Reverberating Refrain

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss2", "boss3") -- Boss 1: Skyja, Boss 2: Kyra, Boss 3: Signe
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 350745 then -- Maw Power (Set to 00)  [DNT]
		self:SetStage(2)
		self:Message("stages", "green", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		self:Bar(351399, 6.9) -- Resentment
		self:Bar(350475, 9.4) -- Pierce Soul
		self:Bar(350467, 43.9, CL.count:format(self:SpellName(350467), callOfTheValkyrCount)) -- Call of the Val'kyr
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 23 then -- Stage 2 when the first of 2 bosses reaches 20%
		self:Message("stages", "green", CL.soon:format(CL.stage:format(2)), false)
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Stage One: The Unending Voice
do
	local playerList = {}
	local prev = 0
	local allowed = true
	function mod:FragmentsOfDestiny(args)
		-- XXX FIXME
		-- - Use an icon set, only using available icons
		-- - Re-mark when it jumps to a different player, but not if it is an extra stack if you already had one
		-- - Dont warn for jumps, only the initial wave of debuffs
		local t = args.time-- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
			shardOfDestinyCount = shardOfDestinyCount + 1
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		if allowed then
			self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, shardOfDestinyCount-1))
			self:SimpleTimer(1, function() allowed = false end)
			self:SimpleTimer(20, function() allowed = true playerList = {} end)
		end
		self:CustomIcon(fragmentsMarker, args.destName, count)
	end
end

function mod:FragmentsOfDestinyStacks(args)
	-- Warn someone that they got an extra stack, or they are the one collecting
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:ShardOfDestinyAreaEffect(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Kyra, The Unending
function mod:UnendingStrike(args) -- XXX Refine with debuff checking for healers
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	--self:PlaySound(args.spellId, "alert")
end

function mod:UnendingStrikeApplied(args)-- XXX Refine with debuff checking for healers
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 2)
	if amount > 2 then
		self:PlaySound(args.spellId, "alarm")
	end
	self:Bar(args.spellId, 6) -- to _START
end

do
	function mod:FormlessMassMarking(event, unit, guid)
		if self:MobId(guid) == 177407 then -- Formless Mass
			self:CustomIcon(formlessMassMarker, unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	function mod:FormlessMass(args)
		self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(args.spellName, formlessMassCount)))
		self:PlaySound(args.spellId, "long")
		formlessMassCount = formlessMassCount + 1
		self:Bar(args.spellId, 47.5, CL.count:format(args.spellName, formlessMassCount))
		if self:GetOption(formlessMassMarker) then
			self:RegisterTargetEvents("FormlessMassMarking")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end

function mod:SiphonVitality(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:WingsOfRage(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(args.spellName, wingsOfRageCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 9.5) -- 2.5 pre-cast, 7s channel
	wingsOfRageCount = wingsOfRageCount + 1
	self:Bar(args.spellId, 72.9, CL.count:format(args.spellName, wingsOfRageCount))
end

function mod:KyraDeath(args)
	self:StopBar(350202) -- Unending Strike
	self:StopBar(CL.count:format(self:SpellName(350342), formlessMassCount)) -- Formless Mass
	self:StopBar(CL.count:format(self:SpellName(350365), wingsOfRageCount)) -- Wings of Rage
end

-- Signe, The Voice
function mod:SongOfDissolution(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, songOfDissolutionCount))
	self:PlaySound(args.spellId, "alert")
	songOfDissolutionCount = songOfDissolutionCount + 1
	self:CDBar(args.spellId, 20, CL.count:format(args.spellName, songOfDissolutionCount))
end

function mod:ReverberatingRefrain(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(args.spellName, reverberatingRefrainCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 9.5, CL.count:format(args.spellName, reverberatingRefrainCount)) -- 2.5 pre-cast, 7s channel
	reverberatingRefrainCount = reverberatingRefrainCount + 1
	self:Bar(args.spellId, 72.9, CL.count:format(args.spellName, reverberatingRefrainCount))
end


function mod:SigneDeath(args)
	self:StopBar(CL.count:format(self:SpellName(350286), songOfDissolutionCount)) -- Song of Dissolution
	self:StopBar(CL.count:format(self:SpellName(350385), reverberatingRefrainCount)) -- Reverberating Refrain
end

-- Call of the Val'kyr
function mod:CallOfTheValkyr(args)
	self:Message(args.spellId, "orange", CL.incoming:format(CL.count:format(args.spellName, callOfTheValkyrCount)))
	self:PlaySound(args.spellId, "long")
	callOfTheValkyrCount = callOfTheValkyrCount +  1
	self:Bar(args.spellId, 72.9, CL.count:format(args.spellName, callOfTheValkyrCount))
end

-- function mod:AgathasEternalBlade(args)
-- 	self:Message(args.spellId, "cyan")
-- end

function mod:DaschlasMightyAnvil(args)
	self:Message(args.spellId, "cyan")
	self:CastBar(args.spellId, 10)
end

function mod:DaschlasMightyAnvilApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 10)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:AnnhyldesBrightAegisApplied(args)
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "alarm")
end

-- function mod:AradnesFallingStrike(args)
-- 	self:Message(args.spellId, "cyan")
-- 	self:CastBar(args.spellId, 8)
-- end

do
	local playerList = {}
	local prev = 0
	function mod:BrynjasMournfulDirgeApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			self:Message(args.spellId, "yellow")
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "alarm")
		end
	end

	function mod:BrynjasMournfulDirgeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ArthurasCrushingGaze(args)
	self:CastBar(args.spellId, 8)
end

function mod:ArthurasCrushingGazeApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId)
		self:YellCountdown(args.spellId, 8)
	else
		self:PlaySound(args.spellId, "alert")
	end
	self:TargetMessage(args.spellId, "orange", args.destName)
end

function mod:ArthurasCrushingGazeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
end

function mod:PierceSoulApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 3)
	if amount > 2 then
		self:PlaySound(args.spellId, "alarm")
	end
	self:Bar(args.spellId, 9.7)
end

function mod:Resentment(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 8.5)
end

do
	local playerList = {}
	local prev = 0
	function mod:LinkEssence(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			--self:Bar(args.spellId, 6.3)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:WordOfRecall(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 6.3)
end
