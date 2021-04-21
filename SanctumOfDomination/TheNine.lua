--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("The Nine", 2450, 2439)
if not mod then return end
mod:RegisterEnableMob(178738, 178736, 175726) -- Kyra, Signe, Skyja
mod:SetEncounterID(2429)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

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
		350184, -- Daschla's Mighty Anvil
		350157, -- Annhylde's Bright Aegis
		350098, -- Aradne's Falling Strike
		{350109, "SAY", "SAY_COUNTDOWN"}, -- Brynja's Mournful Dirge
		{350039, "SAY", "SAY_COUNTDOWN"}, -- Arthura's Crushing Gaze
		-- Stage Two: The First of the Mawsworn
		350475, -- Pierce Soul
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

	-- Signe, The Voice
	self:Log("SPELL_CAST_START", "SoulfulBlast", 350283)
	self:Log("SPELL_CAST_SUCCESS", "SongOfDissolution", 350286)
	self:Log("SPELL_CAST_START", "ReverberatingRefrain", 350385)

	-- Call of the Val'kyr
	self:Log("SPELL_CAST_START", "CallOfTheValkyr", 350467)
	self:Log("SPELL_CAST_SUCCESS", "AgathasEternalBlade", 350031)
	self:Log("SPELL_CAST_SUCCESS", "DaschlasMightyAnvil", 350184)
	self:Log("SPELL_CAST_SUCCESS", "AnnhyldesBrightAegis", 350157)
	self:Log("SPELL_CAST_SUCCESS", "AradnesFallingStrike", 350098)
	self:Log("SPELL_CAST_SUCCESS", "BrynjasMournfulDirge", 350109)
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
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1", "boss2")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 23 then -- Stage 2 when the first of 2 bosses reaches 20%
		self:Message("stages", "green", CL.soon:format(2), false)
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Stage One: The Unending Voice
do
	local playerList = {}
	local prev = 0
	function mod:FragmentsOfDestiny(args)
		-- XXX FIXME
		-- - Use an icon set, only using available icons
		-- - Re-mark when it jumps to a different player, but not if it is an extra stack if you already had one
		-- - Dont warn for jumps, only the initial wave of debuffs
		local t = args.time-- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList)
		self:CustomIcon(fragmentsMarker, args.destName, count)
	end
end

function mod:FragmentsOfDestinyStacks(args)
	-- Warn someone that they got an extra stack, or they are the one collecting
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:NewStackMessage(args.spellId, "blue", args.destName, amount)
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
	--self:Bar(args.spellId, 6.3)
end

do
	function mod:FormlessMassMarking(event, unit, guid)
		if self:MobId(guid) == 177407 then -- Formless Mass
			self:CustomIcon(formlessMassMarker, unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	function mod:FormlessMass(args)
		self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
		self:PlaySound(args.spellId, "long")
		--self:Bar(args.spellId, 25.6)
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
	--self:Bar(args.spellId, 6.3)
end

function mod:WingsOfRage(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 9.5) -- 2.5 pre-cast, 7s channel
	--self:Bar(args.spellId, 25.6)
end

-- Signe, The Voice
function mod:SoulfulBlast(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
	--self:Bar(args.spellId, 6.3)
end

function mod:SongOfDissolution(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 6.3)
end

function mod:ReverberatingRefrain(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 9.5) -- 2.5 pre-cast, 7s channel
	--self:Bar(args.spellId, 25.6)
end

-- Call of the Val'kyr
function mod:CallOfTheValkyr(args)
	self:Message(args.spellId, "orange", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 6.3)
end

function mod:AgathasEternalBlade(args)
	self:Message(args.spellId, "cyan")
end

function mod:DaschlasMightyAnvil(args)
	self:Message(args.spellId, "cyan")
	self:CastBar(args.spellId, 10)
end

function mod:AnnhyldesBrightAegis(args)
	-- XXX Warn when bosses have the shield
	self:Message(args.spellId, "cyan")
end

function mod:AradnesFallingStrike(args)
	self:Message(args.spellId, "cyan")
	self:CastBar(args.spellId, 8)
end

function mod:BrynjasMournfulDirge(args)
	self:Message(args.spellId, "cyan")
end

do
	local playerList = {}
	local prev = 0
	function mod:BrynjasMournfulDirgeApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "alarm")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList)
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
	--self:Bar(args.spellId, 6.3)
end

function mod:Resentment(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 6.3)
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
