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

local fragmentMarks = {}
local fragmentOfDestinyCount = 1
local callOfTheValkyrCount = 1
local incomingValkyrList = {}
local formlessMassCount = 1
local wingsOfRageCount = 1
local songOfDissolutionCount = 1
local reverberatingRefrainCount = 1
local kyraAlive = true
local signeAlive = true
local stage2Health = mod:Mythic() and 20 or mod:Heroic() and 15 or mod:Normal() and 10 or 5

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.fragments = "Fragments" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.unending_strike = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank:16:16:0:0:64:64:4:60:4:60|t Unending Strike" -- [tank icon] Unending Strike
	L.pushback = "Run Away" -- Wings of Rage
	L.song = "Song" -- Short for Song of Dissolution
	L.pullin = "Go in" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Blades" -- Agatha's Eternal Blade
	L.big_bomb = "Big Bombs" -- Daschla's Mighty Impact
	L.big_say = "Big" -- Attached to the countdown
	L.shield = "Shield" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Small Bombs" -- Brynja's Mournful Dirge
	L.recall = "Recall" -- Short for Word of Recall


	L.blades_yell = "Fall before my blade!"
	L.soaks_yell = "You are all outmatched!"
end

--------------------------------------------------------------------------------
-- Initialization
--

local fragmentsMarker = mod:AddMarkerOption(false, "player", 1, 350542, 1, 2, 3) -- Fragments of Destiny
local formlessMassMarker = mod:AddMarkerOption(false, "npc", 8, 350342, 8) -- Formless Mass
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Unending Voice
		{350542, "SAY"}, -- Fragments of Destiny // Note: Placed this first so ordering in bigwigs looks better vs Encounter Journal
		fragmentsMarker,
		350555, -- Shard of Destiny
		-- Kyra, The Unending
		{350202, "TANK_HEALER"}, -- Unending Strike
		350342, -- Formless Mass
		formlessMassMarker,
		350339, -- Siphon Vitality
		350365, -- Wings of Rage
		-- Signe, The Voice
		350283, -- Soulful Blast
		{350286, "TANK"}, -- Song of Dissolution
		350385, -- Reverberating Refrain
		-- Call of the Val'kyr
		350467, -- Call of the Val'kyr
		350031, -- Agatha's Eternal Blade
		{350184, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Daschla's Mighty Impact
		350158, -- Annhylde's Bright Aegis
		350098, -- Aradne's Falling Strike
		{350109, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Brynja's Mournful Dirge
		{350039, "SAY", "SAY_COUNTDOWN"}, -- Arthura's Crushing Gaze
		-- Stage Two: The First of the Mawsworn
		{350475, "TANK"}, -- Pierce Soul
		351399, -- Resentment
		350482, -- Link Essence
		{350687, "INFOBOX"}, -- Word of Recall
	},{
		["stages"] = "general",
		[350542] = mod:SpellName(-22877), -- Stage One: The Unending Voice
		[350202] = mod:SpellName(-23202), -- Kyra, The Unending
		[350283] = mod:SpellName(-23203), -- Signe, The Voice
		[350467] = mod:SpellName(-23206), -- Call of the Val'kyr
		[350475] = mod:SpellName(-22879), -- Stage Two: The First of the Mawsworn
	},{
		[350542] = L.fragments, -- Fragments of Destiny (Fragments)
		[350202] = L.unending_strike, -- Unending Strike ([tank icon] Unending Strike)
		[350342] = CL.add, -- Formless Mass (Add)
		[350365] = L.pushback, -- Wings of Rage (Run Away)
		[350286] = L.song,-- Song of Dissolution (Song)
		[350385] = L.pullin, -- Reverberating Refrain (Go in)
		[350467] = L.valkyr, -- Call of the Val'kyr (Val'kyr)
		[350031] = L.blades, -- Agatha's Eternal Blade (Blades)
		[350184] = L.big_bomb, -- Daschla's Mighty Impact (Big Bombs)
		[350158] = L.shield, -- Annhylde's Bright Aegis (Shield)
		[350098] = L.soaks, -- Aradne's Falling Strike (Soaks)
		[350109] = L.small_bombs, -- Brynja's Mournful Dirge (Small Bombs)
		[350039] = CL.meteor, -- Arthura's Crushing Gaze (Meteor)
		[350687] = L.recall, -- Word of Recall (Recall)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One: The Unending Voice
	self:Log("SPELL_CAST_START", "FragmentsOfDestiny", 350541)
	self:Log("SPELL_AURA_APPLIED", "FragmentsOfDestinyApplied", 350542)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FragmentsOfDestinyStacks", 350542)
	self:Log("SPELL_AURA_REMOVED", "FragmentsOfDestinyRemoved", 350542)
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
	--self:Log("SPELL_CAST_SUCCESS", "AgathasEternalBlade", 350031) -- Using a yell atm, hopefully an event later...
	self:Log("SPELL_CAST_SUCCESS", "DaschlasMightyImpact", 350184)
	self:Log("SPELL_AURA_APPLIED", "DaschlasMightyImpactApplied", 350184)
	self:Log("SPELL_AURA_APPLIED", "AnnhyldesBrightAegisApplied", 350158) -- This is only the buff on the bosses, no spawn event or yells??
	--self:Log("SPELL_CAST_SUCCESS", "AradnesFallingStrike", 350098) -- Using a yell atm, hopefully an event later...
	self:Log("SPELL_AURA_APPLIED", "BrynjasMournfulDirgeApplied", 350109, 351139) -- Valkyr, Recall
	self:Log("SPELL_AURA_REMOVED", "BrynjasMournfulDirgeRemoved", 350109, 351139)
	self:Log("SPELL_CAST_SUCCESS", "ArthurasCrushingGaze", 350039)
	self:Log("SPELL_AURA_APPLIED", "ArthurasCrushingGazeApplied", 350039)
	self:Log("SPELL_AURA_REMOVED", "ArthurasCrushingGazeRemoved", 350039)

	-- Stage Two: The First of the Mawsworn
	self:Log("SPELL_AURA_APPLIED", "PierceSoulApplied", 350475)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PierceSoulApplied", 350475)
	self:Log("SPELL_CAST_SUCCESS", "Resentment", 351399)
	self:Log("SPELL_CAST_START", "LinkEssence", 350482)
	self:Log("SPELL_CAST_SUCCESS", "LinkEssenceSuccess", 350482)
	self:Log("SPELL_AURA_APPLIED", "LinkEssenceApplied", 350482)
	self:Log("SPELL_CAST_START", "WordOfRecall", 350687)
end

function mod:OnEngage()
	self:SetStage(1)

	stage2Health = self:Mythic() and 20 or self:Heroic() and 15 or self:Normal() and 10 or 5
	fragmentMarks = {}
	fragmentOfDestinyCount = 1
	callOfTheValkyrCount = 1
	incomingValkyrList = {}
	formlessMassCount = 1
	wingsOfRageCount = 1
	songOfDissolutionCount = 1
	reverberatingRefrainCount = 1
	kyraAlive = true
	signeAlive = true

	self:Bar(350202, 6, L.unending_strike) -- Unending Strike
	self:Bar(350342, 12, CL.count:format(CL.add, formlessMassCount)) -- Formless Mass
	self:Bar(350467, 14.6, CL.count:format(L.valkyr, callOfTheValkyrCount)) -- Call of the Val'kyr
	self:Bar(350286, 16, CL.count:format(L.song, songOfDissolutionCount)) -- Song of Dissolution
	self:Bar(350365, 47.5, CL.count:format(L.pushback, wingsOfRageCount)) -- Wings of Rage
	self:Bar(350385, 71.5, CL.count:format(L.pullin, reverberatingRefrainCount)) -- Reverberating Refrain

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss2", "boss3") -- Boss 1: Skyja, Boss 2: Kyra, Boss 3: Signe
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UpdateInfoBox()
	for k, v in pairs(incomingValkyrList) do
		self:SetInfo(350687, (k*2)-1, v) -- 1, 3, 5
	 end
end


function mod:CHAT_MSG_MONSTER_YELL(event, msg, npcname)
	if msg:find(L.blades_yell, nil, true) then -- Agatha's Eternal Blade
		self:Message(350031, "yellow", CL.incoming:format(L.blades))
		table.insert(incomingValkyrList, "|T1376744:16:16:0:0:64:64:4:60:4:60|t "..L.blades)
		mod:UpdateInfoBox()
	elseif msg:find(L.soaks_yell, nil, true) then -- Aradne's Falling Strike
		self:Message(350098, "yellow", CL.incoming:format(L.soaks))
		self:CastBar(350098, 10.2, L.soaks) -- 10.2~10.5, yell is not super reliable :(
		table.insert(incomingValkyrList, "|T2103905:16:16:0:0:64:64:4:60:4:60|t "..L.soaks)
		mod:UpdateInfoBox()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 350745 then -- Maw Power (Set to 00)  [DNT]
		self:SetStage(2)
		self:Message("stages", "green", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		self:Bar(351399, 6.9) -- Resentment
		self:Bar(350475, 9.4) -- Pierce Soul
		self:Bar(350482, 24.4) -- Link Essence
		self:Bar(350467, 43.9, CL.count:format(L.valkyr, callOfTheValkyrCount)) -- Call of the Val'kyr
		self:Bar(350687, 76.5, CL.count:format(L.recall, callOfTheValkyrCount)) -- Word of Recall
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < (stage2Health+3) then
		self:Message("stages", "green", CL.soon:format(CL.stage:format(2)), false)
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Stage One: The Unending Voice
do
	local playerList = {}
	local allowed = true
	function mod:FragmentsOfDestiny(args)
		playerList = {}
		allowed = true
		fragmentOfDestinyCount = fragmentOfDestinyCount + 1
		self:CDBar(350542, 47.5, CL.count:format(L.fragments, fragmentOfDestinyCount))
	end

	function mod:FragmentsOfDestinyApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.fragment)
			self:PlaySound(args.spellId, "warning")
		end
		if allowed then
			self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.fragment, fragmentOfDestinyCount-1))
			self:SimpleTimer(1, function() allowed = false end)
		end
		if self:GetOption(fragmentsMarker) then
			for i = 1, 3, 1 do -- 1, 2, 3
				if not fragmentMarks[i] then
					fragmentMarks[i] = args.destGUID
					self:CustomIcon(fragmentsMarker, args.destName, i)
					break
				end
			end
		end
	end
end

function mod:FragmentsOfDestinyStacks(args)
	-- Warn someone that they got an extra stack, or they are the one collecting
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount, nil, L.fragment)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FragmentsOfDestinyRemoved(args)
	if self:GetOption(fragmentsMarker) then
		for i = 1, 3, 1 do -- 1, 2, 3
			if fragmentMarks[i] == args.destGUID then
				fragmentMarks[i] = nil
				self:CustomIcon(fragmentsMarker, args.destName, 0)
				return
			end
		end
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
function mod:UnendingStrike(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
end

function mod:UnendingStrikeApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 3)
	if amount > 4 or (self:Tank() and amount > 3) then -- Tanks swap at 4+, warn others if they havn't
		self:PlaySound(args.spellId, "alarm")
	end
	self:Bar(args.spellId, 6, L.unending_strike) -- to _START
end

do
	function mod:FormlessMassMarking(event, unit, guid)
		if self:MobId(guid) == 177407 then -- Formless Mass
			self:CustomIcon(formlessMassMarker, unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	function mod:FormlessMass(args)
		self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(CL.add, formlessMassCount)))
		self:PlaySound(args.spellId, "long")
		formlessMassCount = formlessMassCount + 1
		self:Bar(args.spellId, 47.5, CL.count:format(CL.add, formlessMassCount))
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
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.pullin, wingsOfRageCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 9.5, L.pullin) -- 2.5 pre-cast, 7s channel
	wingsOfRageCount = wingsOfRageCount + 1
	if kyraAlive then
		self:Bar(args.spellId, 72.9, CL.count:format(L.pullin, wingsOfRageCount))
	end
end

function mod:KyraDeath(args)
	kyraAlive = false
	self:StopBar(L.unending_strike) -- Unending Strike
	self:StopBar(CL.count:format(CL.add, formlessMassCount)) -- Formless Mass
	self:StopBar(CL.count:format(L.pullin, wingsOfRageCount)) -- Wings of Rage
end

-- Signe, The Voice
function mod:SongOfDissolution(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.song, songOfDissolutionCount))
	self:PlaySound(args.spellId, "alert")
	songOfDissolutionCount = songOfDissolutionCount + 1
	self:CDBar(args.spellId, 20, CL.count:format(L.song, songOfDissolutionCount))
end

function mod:ReverberatingRefrain(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.pushback, reverberatingRefrainCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 9.5, CL.count:format(L.pushback, reverberatingRefrainCount)) -- 2.5 pre-cast, 7s channel
	reverberatingRefrainCount = reverberatingRefrainCount + 1
	if signeAlive then
		self:Bar(args.spellId, 72.9, CL.count:format(L.pushback, reverberatingRefrainCount))
	end
end


function mod:SigneDeath(args)
	signeAlive = false
	self:StopBar(CL.count:format(L.song, songOfDissolutionCount)) -- Song of Dissolution
	self:StopBar(CL.count:format(L.pushback, reverberatingRefrainCount)) -- Reverberating Refrain
end

-- Call of the Val'kyr
function mod:CallOfTheValkyr(args)
	self:Message(args.spellId, "orange", CL.incoming:format(CL.count:format(L.valkyr, callOfTheValkyrCount)))
	self:PlaySound(args.spellId, "long")
	callOfTheValkyrCount = callOfTheValkyrCount +  1
	self:Bar(args.spellId, 72.9, CL.count:format(L.valkyr, callOfTheValkyrCount))
	incomingValkyrList = {}
	if self:GetStage() == 2 then
		self:OpenInfo(350687, self:SpellName(350687)) -- Word of Recall
		self:UpdateInfoBox()
	end
end

-- function mod:AgathasEternalBlade(args) -- Yell
-- 	self:Message(args.spellId, "cyan")
-- end

function mod:DaschlasMightyImpact(args)
	self:Message(args.spellId, "cyan", L.big_bomb)
	self:CastBar(args.spellId, 10)
	table.insert(incomingValkyrList, "|T425955:16:16:0:0:64:64:4:60:4:60|t "..L.big_bomb)
	mod:UpdateInfoBox()
end

function mod:DaschlasMightyImpactApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, L.big_bomb)
		self:SayCountdown(args.spellId, 10, L.big_say) -- Big 3, Big 2, Big 1
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:AnnhyldesBrightAegisApplied(args)
	self:Message(args.spellId, "red", CL.on:format(L.shield, args.destName))
	self:PlaySound(args.spellId, "alarm")
end

-- function mod:AradnesFallingStrike(args) -- Yell
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
			self:Message(350109, "yellow", L.small_bombs)
			table.insert(incomingValkyrList, "|T460699:16:16:0:0:64:64:4:60:4:60|t "..L.small_bombs)
			mod:UpdateInfoBox()
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(350109, L.small_bombs)
			self:SayCountdown(350109, 6)
			self:PlaySound(350109, "alarm")
		end
	end

	function mod:BrynjasMournfulDirgeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(350109)
		end
	end
end

function mod:ArthurasCrushingGaze(args)
	self:CastBar(args.spellId, 8, CL.meteor)
	table.insert(incomingValkyrList, "|T135988:16:16:0:0:64:64:4:60:4:60|t "..CL.meteor)
	mod:UpdateInfoBox()
end

function mod:ArthurasCrushingGazeApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, CL.meteor)
		self:YellCountdown(args.spellId, 8)
	else
		self:PlaySound(args.spellId, "alert")
	end
	self:TargetMessage(args.spellId, "orange", args.destName, CL.meteor)
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
	function mod:LinkEssence(args)
		playerList = {}
	end

	function mod:LinkEssenceSuccess(args)
		self:CDBar(args.spellId, 37.5)
	end

	function mod:LinkEssenceApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:WordOfRecall(args)
	-- Using call of the Valkyr count as it's linked with that ability
	self:Message(args.spellId, "cyan", CL.count:format(L.recall, callOfTheValkyrCount-1))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 72, CL.count:format(L.recall, callOfTheValkyrCount))
	self:ScheduleTimer("CloseInfo", 12, args.spellId) -- Last ability should be done after 10s
end
