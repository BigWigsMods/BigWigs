--------------------------------------------------------------------------------
-- TODO:
--
-- - Crushing Doubt duration if troll??

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Restless Cabal", 2096, 2328)
if not mod then return end
mod:RegisterEnableMob(144755, 144754) -- Zaxasj the Speaker, Fa'thuul the Feared
mod.engageId = 2269
mod.respawnTime = 20

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
local visageCount = 1

local absorbActive = false
local shieldActive = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.absorb = "Absorb"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.bubble = "Bubble"
	L.cast = "Cast"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local crushingDoubtMarker = mod:AddMarkerOption(false, "player", 1, 282432, 1, 2) -- Crushing Doubt
local eldritchAbominationMarker = mod:AddMarkerOption(false, "npc", 3, -19060, 3, 4, 5) -- Eldritch Abomination
function mod:GetOptions()
	return {
		-- Relics of Power
		{-18970, "INFOBOX"},
		282741, -- Umbral Shell
		282886, -- Abyssal Collapse
		282742, -- Storm of Annihilation
		282914, -- Power Overwhelming
		-- General
		282675, -- Pact of the Restless
		"berserk",
		-- Zaxasj the Speaker
		282386, -- Aphotic Blast
		282540, -- Agent of Demise
		282589, -- Cerebral Assault
		282561, -- Dark Herald
		282566, -- Promises of Power
		282515, -- Visage from Beyond
		282517, -- Terrifying Echo
		-- Fa'thuul the Feared
		{282384, "TANK"}, -- Shear Mind
		282407, -- Void Crash
		{282432, "SAY", "SAY_COUNTDOWN", "FLASH", "ME_ONLY_EMPHASIZE"}, -- Crushing Doubt
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
	self:Log("SPELL_CAST_SUCCESS", "AbyssalCollapseSuccess", 282886)
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
	self:Log("SPELL_CAST_START", "CerebralAssault", 282589, 285154)
	self:Log("SPELL_AURA_APPLIED", "DarkHerald", 282561)
	self:Log("SPELL_AURA_APPLIED", "PromisesofPower", 282566)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PromisesofPower", 282566)
	self:Log("SPELL_AURA_REMOVED", "PromisesofPowerRemoved", 282566)
	self:Log("SPELL_CAST_SUCCESS", "VisagefromBeyond", 282515)
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
	visageCount = 1

	self:Bar(282384, 7.1) -- Shear Mind
	self:Bar(282561, self:Mythic() and 16.5 or 10.3, CL.count:format(self:SpellName(282561), darkHeraldCount)) -- Dark Herald
	self:Bar(282407, 13.2, CL.count:format(self:SpellName(282407), voidCrashCount)) -- Void Crash
	self:Bar(282589, self:Mythic() and 16.5 or 30.1, CL.count:format(self:SpellName(282589), cerebralAssaultCount)) -- Cerebral Assault
	self:Bar(282432, 18.9, CL.count:format(self:SpellName(282432), crushingDoubtCount)) -- Crushing Doubt
	if self:GetOption(eldritchAbominationMarker) then
		self:RegisterTargetEvents("EldritchMarker")
	end
	if self:CheckOption(-18970, "INFOBOX") then
		self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss3")
	end
	if self:Mythic() then
		self:Berserk(570)
	else
		self:Berserk(780)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Relics of Power
do
	local maxAbsorb, absorbRemoved, absorbTarget, maxShield, currentShield, castOver, scheduled = 0, 0, nil, 0, 0, 0, nil
	local red, yellow, green = {.6, 0, 0, .6}, {.7, .5, 0}, {0, .5, 0}

	function mod:UpdateInfoBox(logUpdate)
		if absorbActive == false and shieldActive == false then
			self:CloseInfo(-18970)
		else
			self:OpenInfo(-18970, self:SpellName(-18970)) -- Relics of Power
			if absorbActive == false then -- Clear Umbral Shell
				self:SetInfo(-18970, 1, "")
				self:SetInfo(-18970, 3, "")
				self:SetInfo(-18970, 4, "")
				self:SetInfoBar(-18970, 3, 0)
			elseif absorbActive == true then
				local absorb = maxAbsorb - absorbRemoved
				local absorbPercentage = absorb / maxAbsorb
				self:SetInfo(-18970, 1, "|T237570:15:15:0:0:64:64:4:60:4:60|t "..absorbTarget) -- spell_shadow_twistedfaith
				self:SetInfo(-18970, 3, L.absorb)
				self:SetInfoBar(-18970, 3, absorbPercentage)
				self:SetInfo(-18970, 4, L.absorb_text:format(self:AbbreviateNumber(absorb), "00ff00", absorbPercentage*100))
			end
			if shieldActive == false then
				self:SetInfo(-18970, 5, "")
				self:SetInfoBar(-18970, 7, 0)
				self:SetInfo(-18970, 8, "")
				self:SetInfoBar(-18970, 9, 0)
				self:SetInfo(-18970, 10, "")
			elseif shieldActive == true then
				local castTimeLeft = castOver - GetTime()
				local castPercentage = castTimeLeft / 20
				local shieldPercentage = currentShield / maxShield

				local diff = castPercentage - shieldPercentage
				local hexColor = "ff0000"
				local rgbColor = red
				if diff > 0.1 then -- over 10%
					hexColor = "00ff00"
					rgbColor = green
				elseif diff > 0  then -- below 10%, so it's still close
					hexColor = "ffff00"
					rgbColor = yellow
				end

				self:SetInfo(-18970, 5, "|T1320371:15:15:0:0:64:64:4:60:4:60|t "..self:SpellName(282886)) -- spell_winston_bubble, Abyssal Collapse
				self:SetInfo(-18970, 7, L.bubble)
				self:SetInfoBar(-18970, 7, shieldPercentage, unpack(rgbColor))
				self:SetInfo(-18970, 8, L.absorb_text:format(self:AbbreviateNumber(currentShield), hexColor, shieldPercentage*100))
				self:SetInfoBar(-18970, 9, castPercentage)
				self:SetInfo(-18970, 10, L.cast_text:format(castTimeLeft, hexColor, castPercentage*100))
				if not scheduled then
					scheduled = self:ScheduleTimer("CheckRune", 0.1)
				end
				if not logUpdate then
					self:ScheduleTimer("UpdateInfoBox", 0.1)
				end
			end
		end
	end

	function mod:UNIT_HEALTH(event, unit)
		local guid = UnitGUID(unit)
		if self:MobId(guid) == 145491 then -- Ocean Rune
			shieldActive = true
			maxShield = UnitHealthMax(unit)
			currentShield = UnitHealth(unit)
			self:UpdateInfoBox(true)
		end
	end

	do
		local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
		function mod:UmbralShellAbsorbs()
			local _, subEvent, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, spellId, _, _, absorbed = CombatLogGetCurrentEventInfo()
			if subEvent == "SPELL_ABSORBED" and spellId == 282741 then -- Umbral Shell
				absorbRemoved = absorbRemoved + absorbed
				self:UpdateInfoBox(true)
			end
		end
	end

	function mod:UmbralShellApplied(args)
		self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(args.spellName, umbralShellCount))
		self:PlaySound(args.spellId, "alarm")
		if self:CheckOption(-18970, "INFOBOX") then
			absorbActive = true
			absorbRemoved = 0
			absorbTarget = args.destName
			maxAbsorb = args.amount
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UmbralShellAbsorbs")
			self:UpdateInfoBox()
		end
		umbralShellCount = umbralShellCount + 1
	end

	function mod:UmbralShellRemoved(args)
		self:Message(args.spellId, "cyan", CL.removed:format(CL.count:format(args.spellName, umbralShellCount-1)))
		self:PlaySound(args.spellId, "info")
		if self:CheckOption(-18970, "INFOBOX") then
			absorbActive = false
			absorbTarget = nil
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:UpdateInfoBox()
		end
	end

	function mod:CheckRune()
		if scheduled then
			mod:CancelTimer(scheduled)
			scheduled = nil
		end
		if mod:GetBossId(145491) then
			scheduled = mod:ScheduleTimer("CheckRune", 0.1)
		elseif shieldActive == true then
			shieldActive = false
			mod:Message(282886, "cyan" , CL.over:format(mod:SpellName(282886))) -- Abyssal Collapse
			mod:PlaySound(282886, "info")
			mod:StopBar(CL.cast:format(mod:SpellName(282886)))
			self:UpdateInfoBox()
		end
	end

	function mod:AbyssalCollapseStart(args)
		castOver = GetTime() + 20
		self:Message(args.spellId, "orange", CL.count:format(args.spellName, abyssalCollapseCount))
		self:PlaySound(args.spellId, "alarm")
		self:CastBar(args.spellId, 20, CL.count:format(args.spellName, abyssalCollapseCount))
		self:UpdateInfoBox()
		abyssalCollapseCount = abyssalCollapseCount + 1
	end

	function mod:AbyssalCollapseSuccess(args)
		shieldActive = false
		castOver = 0
		self:Message(args.spellId, "cyan" , CL.over:format(args.spellName)) -- Custody of the Deep
		self:PlaySound(args.spellId, "info") -- Custody of the Deep
		self:StopBar(CL.cast:format(args.spellName)) -- Custody of the Deep
		self:UpdateInfoBox()
	end

	function mod:StormofAnnihilation(args)
		self:Message(args.spellId, "orange", CL.count:format(args.spellName, stormofAnnihilationCount))
		self:PlaySound(args.spellId, "alarm")
		self:CastBar(args.spellId, 15, CL.count:format(args.spellName, stormofAnnihilationCount))
		stormofAnnihilationCount = stormofAnnihilationCount + 1
	end
end

function mod:PowerOverwhelming(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning")
end

do
	local prev = 0
	function mod:PactoftheRestless(args)
		local t = args.time
		if t-prev > 1 then
			prev = t
			self:Message(args.spellId, "red")
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
	self:TargetMessage(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CerebralAssault(args)
	self:Message(282589, "red", CL.count:format(args.spellName, cerebralAssaultCount))
	self:PlaySound(282589, "warning")
	self:CastBar(282589, 6, CL.count:format(args.spellName, cerebralAssaultCount))
	cerebralAssaultCount = cerebralAssaultCount + 1
	self:Bar(282589, self:Mythic() and 31.5 or 41.3, CL.count:format(args.spellName, cerebralAssaultCount))
end

function mod:DarkHerald(args)
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, darkHeraldCount)) -- Count - 1 since applied is after Success
	self:PlaySound(args.spellId, "alert")
	self:TargetBar(args.spellId, 10, args.destName, CL.count:format(args.spellName, darkHeraldCount))
	darkHeraldCount = darkHeraldCount + 1
	self:CDBar(args.spellId, self:Mythic() and 18.2 or 32.1, CL.count:format(args.spellName, darkHeraldCount))
	-- self:PrimaryIcon(args.spellId, args.destName)
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
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:VisagefromBeyond(args)
	self:Bar(args.spellId, 90, CL.count:format(args.spellName, visageCount))
	visageCount = visageCount + 1
end

function mod:TerrifyingEcho(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, self:Mythic() and 15 or 20)
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
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, voidCrashCount))
	self:PlaySound(args.spellId, "alert")
	voidCrashCount = voidCrashCount + 1
	self:Bar(args.spellId, 13.3, CL.count:format(args.spellName, voidCrashCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:CrushingDoubtApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:CastBar(args.spellId, 12, CL.count:format(args.spellName, crushingDoubtCount)) -- Explosion
			crushingDoubtCount = crushingDoubtCount + 1
			self:Bar(args.spellId, self:Mythic() and 46.5 or 60.5, CL.count:format(args.spellName, crushingDoubtCount))
		end
		if self:GetOption(crushingDoubtMarker) and #playerList < 3 then
			SetRaidTarget(args.destName, #playerList)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, #playerList, #playerList))
			self:SayCountdown(args.spellId, 12)
			self:Flash(args.spellId)
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

function mod:EldritchRevelation()
	eldritchList = {}
end

function mod:WitnesstheEnd(args)
	if self:GetOption(eldritchAbominationMarker) and not mobCollector[args.sourceGUID] then
		eldritchCount = eldritchCount + 1
		mobCollector[args.sourceGUID] = true
		eldritchList[args.sourceGUID] = (eldritchCount % 3) + 3 -- 3, 4, 5
		for k, v in pairs(eldritchList) do
			local unit = self:GetUnitIdByGUID(k)
			if unit then
				SetRaidTarget(unit, eldritchList[k])
				eldritchList[k] = nil
			end
		end
	end
end

function mod:EldritchMarker(event, unit, guid)
	if self:MobId(guid) == 145053 and eldritchList[guid] then -- Eldritch Abomination
		SetRaidTarget(unit, eldritchList[guid])
		eldritchList[guid] = nil
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
