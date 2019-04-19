--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Restless Cabal", 2096, 2328)
if not mod then return end
mod:RegisterEnableMob(144755, 144754) -- Zaxasj the Speaker, Fa'thuul the Feared
mod.engageId = 2269
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local eldritchCount = 0
local mobCollector = {}
local eldritchList = {}
local cerebralAssaultCount = 1
local crushingDoubtCount = 1
local darkHeraldCount = 1
local voidCrashCount = 1
local umbralShellCount = 1
local abyssalCollapseCount = 1
local stormofAnnihilationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.absorb = "Absorb"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local crushingDoubtMarker = mod:AddMarkerOption(false, "player", 1, 282432, 1, 2) -- Crushing Doubt
local eldritchAbominationMarker = mod:AddMarkerOption(false, "npc", 3, -19060, 3, 4, 5) -- Eldritch Abomination
function mod:GetOptions()
	return {
		-- Relics of Power
		{282741, "INFOBOX"}, -- Umbral Shell
		282886, -- Abyssal Collapse
		282742, -- Storm of Annihilation
		282914, -- Power Overwhelming
		-- General
		282675, -- Pact of the Restless
		-- Zaxasj the Speaker
		282386, -- Aphotic Blast
		282540, -- Agent of Demise
		282589, -- Cerebral Assault
		{282561, "ICON"}, -- Dark Herald
		282566, -- Promises of Power
		282515, -- Visage from Beyond
		282517, -- Terrifying Echo
		-- Fa'thuul the Feared
		{282384, "TANK"}, -- Shear Mind
		282407, -- Void Crash
		{282432, "SAY", "SAY_COUNTDOWN"}, -- Crushing Doubt
		crushingDoubtMarker,
		eldritchAbominationMarker,
		287876, -- Enveloping Darkness
	},{
		[282741] = -18970, -- Relics of Power
		[282675] = "general",
		[282386] = -18974, -- Zaxasj the Speaker
		[282384] = -18983, -- Fa'thuul the Feared
		--[287876] = "mythic",
	}
end

function mod:OnBossEnable()

	-- Relics of Power
	self:Log("SPELL_AURA_APPLIED", "UmbralShellApplied", 282741)
	self:Log("SPELL_AURA_REMOVED", "UmbralShellRemoved", 282741)
	self:Log("SPELL_CAST_START", "AbyssalCollapseStart", 282886)
	self:Log("SPELL_CAST_SUCCESS", "StormofAnnihilation", 282742)
	self:Log("SPELL_AURA_APPLIED", "PowerOverwhelming", 282914)

	-- General
	self:Log("SPELL_CAST_START", "PactoftheRestless", 282675)

	-- Zaxasj the Speaker
	self:Log("SPELL_AURA_APPLIED", "AphoticBlastApplied", 282386)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AphoticBlastRefresh", 282386)
	self:Log("SPELL_AURA_REFRESH", "AphoticBlastRefresh", 282386)
	self:Log("SPELL_AURA_REMOVED", "AphoticBlastRemoved", 282386)
	self:Log("SPELL_AURA_APPLIED", "AgentofDemise", 282540)
	self:Log("SPELL_CAST_START", "CerebralAssault", 282589)
	self:Log("SPELL_AURA_SUCCESS", "DarkHeraldSuccess", 282561)
	self:Log("SPELL_AURA_APPLIED", "DarkHerald", 282561)
	self:Log("SPELL_AURA_REMOVED", "DarkHeraldRemoved", 282561)
	self:Log("SPELL_AURA_APPLIED", "PromisesofPower", 282566)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PromisesofPower", 282566)
	self:Log("SPELL_AURA_REMOVED", "PromisesofPowerRemoved", 282566)
	self:Log("SPELL_AURA_SUCCESS", "VisagefromBeyond", 282515)
	self:Log("SPELL_CAST_START", "TerrifyingEcho", 282517)

	-- Fa'thuul the Feared
	self:Log("SPELL_CAST_SUCCESS", "ShearMind", 282384)
	self:Log("SPELL_AURA_APPLIED", "ShearMindApplied", 282384)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShearMindApplied", 282384)
	self:Log("SPELL_CAST_START", "VoidCrash", 282407)
	self:Log("SPELL_AURA_APPLIED", "CrushingDoubtApplied", 282432)
	self:Log("SPELL_AURA_REMOVED", "CrushingDoubtRemoved", 282432)
	self:Log("SPELL_CAST_START", "EldritchRevelation", 282617)
	self:Log("SPELL_CAST_START", "WitnesstheEnd", 282621)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 287876) -- Enveloping Darkness
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 287876)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 287876)
end

function mod:OnEngage()
	eldritchCount = 0
	mobCollector = {}
	eldritchList = {}

	cerebralAssaultCount = 1
	crushingDoubtCount = 1
	darkHeraldCount = 1
	voidCrashCount = 1
	umbralShellCount = 1
	abyssalCollapseCount = 1
	stormofAnnihilationCount = 1

	self:Bar(282384, 7.1) -- Shear Mind
	self:Bar(282561, 10.3, CL.count:format(self:SpellName(282432), darkHeraldCount)) -- Dark Herald
	self:Bar(282407, 13.2, CL.count:format(self:SpellName(282432), voidCrashCount)) -- Void Crash
	self:Bar(282589, 15.6, CL.count:format(self:SpellName(282589), cerebralAssaultCount)) -- Cerebral Assault
	self:Bar(282432, 18.9, CL.count:format(self:SpellName(282432), crushingDoubtCount)) -- Crushing Doubt
	if self:GetOption(eldritchAbominationMarker) then
		self:RegisterTargetEvents("eldritchMarker")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Relics of Power
do
	local maxAbsorb, absorbRemoved = 0, 0

	local function updateInfoBox()
		local absorb = maxAbsorb - absorbRemoved
		local absorbPercentage = absorb / maxAbsorb
		mod:SetInfoBar(282741, 1, absorbPercentage)
		mod:SetInfo(282741, 2, L.absorb_text:format(mod:AbbreviateNumber(absorb), "00ff00", absorbPercentage*100))
	end

	do
		local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
		function mod:UmbralShellAbsorbs()
			local _, subEvent, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, spellId, _, _, absorbed = CombatLogGetCurrentEventInfo()
			if subEvent == "SPELL_ABSORBED" and spellId == 282741 then -- Umbral Shell
				absorbRemoved = absorbRemoved + absorbed
				updateInfoBox()
			end
		end
	end

	function mod:UmbralShellApplied(args)
		self:TargetMessage2(args.spellId, "orange", args.destName, CL.count:format(args.spellName, umbralShellCount))
		self:PlaySound(args.spellId, "alarm")
		if self:CheckOption(args.spellId, "INFOBOX") then
			absorbRemoved = 0
			maxAbsorb = args.amount
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfo(args.spellId, 1, L.absorb)
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UmbralShellAbsorbs")
		end
		umbralShellCount = umbralShellCount + 1
	end

	function mod:UmbralShellRemoved(args)
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:Message2(args.spellId, "cyan", CL.removed:format(CL.count:format(args.spellName, umbralShellCount-1)))
		self:PlaySound(args.spellId, "info")
		self:CloseInfo(args.spellId)
	end
end

function mod:AbyssalCollapseStart(args) -- XXX Detect the Ocean Rune cast being over and cancel cast bar.
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, abyssalCollapseCount))
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 20, CL.count:format(args.spellName, abyssalCollapseCount))
	abyssalCollapseCount = abyssalCollapseCount + 1
end

function mod:StormofAnnihilation(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, stormofAnnihilationCount))
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 15, CL.count:format(args.spellName, stormofAnnihilationCount))
	stormofAnnihilationCount = stormofAnnihilationCount + 1
end

function mod:PowerOverwhelming(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning")
end

do
	local prev = 0
	function mod:PactoftheRestless(args)
		local t = args.time
		if t-prev > 1 then
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "alert")
			self:CastBar(args.spellId, 12)
		end
	end
end

-- Zaxasj the Speaker
function mod:AphoticBlastApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm")
		self:TargetBar(args.spellId, 20, args.destName)
	end
end

function mod:AphoticBlastRefresh(args)
	if self:Me(args.destGUID) then
		self:TargetBar(args.spellId, 20, args.destName)
	end
end

function mod:AphoticBlastRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:AgentofDemise(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CerebralAssault(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, cerebralAssaultCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, cerebralAssaultCount))
	cerebralAssaultCount = cerebralAssaultCount + 1
	self:Bar(args.spellId, 31.5, CL.count:format(args.spellName, cerebralAssaultCount))
end


function mod:DarkHeraldSuccess(args)
	darkHeraldCount = darkHeraldCount + 1
	self:CDBar(args.spellId, 33, CL.count:format(args.spellName, cerebralAssaultCount)) -- 32.7-34
end

function mod:DarkHerald(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, darkHeraldCount-1)) -- Count - 1 since applied is after Success
	self:PlaySound(args.spellId, "alert")
	self:TargetBar(args.spellId, 20, args.destName, CL.count:format(args.spellName, darkHeraldCount-1))
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:DarkHeraldRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:PromisesofPower(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 1 then
			self:StackMessage(args.spellId, args.destName, args.amount, "blue")
			self:PlaySound(args.spellId, amount > 5 and "warning" or "info")
		end
	end
end

function mod:PromisesofPowerRemoved(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:VisagefromBeyond(args)
	self:Bar(args.spellId, 90)
end

function mod:TerrifyingEcho(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 6)
end

-- Fa'thuul the Feared
function mod:ShearMind(args)
	self:CDBar(args.spellId, 7) -- To cast_start
end

function mod:ShearMindApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:VoidCrash(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, voidCrashCount))
	self:PlaySound(args.spellId, "alert")
	voidCrashCount = voidCrashCount + 1
	self:Bar(args.spellId, 13.2, CL.count:format(args.spellName, voidCrashCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:CrushingDoubtApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:CastBar(args.spellId, 12, CL.count:format(args.spellName, crushingDoubtCount)) -- Explosion
			crushingDoubtCount = crushingDoubtCount + 1
			self:Bar(args.spellId, 42.5, CL.count:format(args.spellName, crushingDoubtCount))
		end
		if self:GetOption(crushingDoubtMarker) and #playerList < 3 then
			SetRaidTarget(args.destName, #playerList)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, #playerList, #playerList))
			self:SayCountdown(args.spellId, 12)
			self:PlaySound(args.spellId, "alert")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(args.spellName, crushingDoubtCount-1))
	end
end

function mod:CrushingDoubtRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(crushingDoubtMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:EldritchRevelation() -- XXX Do we need a warning for this? We`re already warning for relics.
	eldritchList = {}
end

function mod:WitnesstheEnd(args)
	if not mobCollector[args.sourceGUID] then
		eldritchCount = eldritchCount + 1
		mobCollector[args.sourceGUID] = true
		eldritchList[args.sourceGUID] = (eldritchCount % 3) + 3 -- 3, 4, 5
	end
end

function mod:eldritchMarker(event, unit, guid)
	if self:MobId(guid) == 145053 and eldritchList[guid] then -- Eldritch Abomination
		SetRaidTarget(unit, eldritchList[guid])
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
