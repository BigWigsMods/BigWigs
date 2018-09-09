
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zul", 1861, 2195)
if not mod then return end
mod:RegisterEnableMob(138967)
mod.engageId = 2145
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.crawg = "Crawg"
	L.bloodhexer = "Bloodhexer"
	L.crusher = "Crusher"
	L.spawning = "Spawning: %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

local darkRevelationMarker = mod:AddMarkerOption(false, "player", 1, 273365, 1, 2) -- Dark Revelation
local deathwishMarker = mod:AddMarkerOption(false, "player", 1, 274271, 1, 2) -- Deathwish
function mod:GetOptions()
	return {
		"stages",
		{273365, "SAY", "SAY_COUNTDOWN"}, -- Dark Revelation
		darkRevelationMarker,
		269936, -- Fixate
		273361, -- Pool of Darkness
		-18539, -- Nazmani Crusher
		-18540, -- Nazmani Bloodhexer
		-18541, -- Bloodthirsty Crawg
		273288, -- Thrumming Pulse
		273451, -- Congeal Blood
		273350, -- Bloodshard
		276299, -- Engorged Burst
		{274358, "TANK"}, -- Rupturing Blood
		274271, -- Deathwish
		deathwishMarker,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "DarkRevelation", 273365)
	self:Log("SPELL_AURA_APPLIED", "DarkRevelationApplied", 273365)
	self:Log("SPELL_AURA_REMOVED", "DarkRevelationRemoved", 273365)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 269936, 276020)
	self:Log("SPELL_CAST_START", "NazmaniCrusher", 274119)
	self:Log("SPELL_CAST_START", "NazmaniBloodhexer", 274098)
	self:Log("SPELL_CAST_START", "BloodthirstyCrawg", 273889)
	self:Log("SPELL_CAST_START", "ThrummingPulse", 273288)
	self:Log("SPELL_CAST_SUCCESS", "CongealBlood", 273451)
	self:Log("SPELL_CAST_START", "Bloodshard", 273350)
	self:Log("SPELL_CAST_SUCCESS", "EngorgedBurst", 276299)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "LocusofCorruption", 274168)
	self:Log("SPELL_AURA_APPLIED", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED", "DeathwishApplied", 274271)
	self:Log("SPELL_AURA_REMOVED", "DeathwishRemoved", 274271)
end

function mod:OnEngage()
	stage = 1
	self:Bar(273361, 21) -- Pool of Darkness
	self:Bar(273365, 30) -- Dark Revelation

	self:CDBar(-18541, 37, L.crawg, "achievement_dungeon_infestedcrawg")
	self:CDBar(-18540, 50, L.bloodhexer, "inv_bloodtrollfemalehead")
	self:CDBar(-18539, 75, L.crusher, "inv_bloodtrollfemaleheaddire01")

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 43 then -- 40% Transition
		local nextStage = stage + 1
		self:Message("stages", "green", nil, CL.soon:format(CL.stage:format(nextStage)), false)
		self:UnregisterUnitEvent(event, unit)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 273361 then -- Pool of Darkness
		self:Message(spellId, "orange")
		self:PlaySound(spellId, "info")
		self:Bar(spellId, stage == 1 and 31.5 or 15.8)
	elseif spellId == 274315 then -- Deathwish
		self:Bar(274271, 28)
	end
end

function mod:DarkRevelation(args)
	self:CDBar(args.spellId, 56) -- pull:30.5, 58.4, 56.0, 64.4
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(273365, "ME_ONLY")

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message(273365, "blue", nil, CL.you:format(("|T13700%d:0|t%s"):format(isOnMe, mod:SpellName(273365))))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message(273365, "yellow", nil, CL.other:format(mod:SpellName(273365), msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:DarkRevelationApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.1)
			self:CastBar(args.spellId, 10) -- XXX Change to an 'Exploding Bar' incase more appropriate
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end
		if self:GetOption(darkRevelationMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end
end

function mod:DarkRevelationRemoved(args)
	if self:GetOption(darkRevelationMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

do
	local prev = 0
	function mod:FixateApplied(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:TargetMessage2(269936, "blue", args.destName)
				self:PlaySound(269936, "warning")
			end
		end
	end
end

function mod:NazmaniCrusher(args)
	local messageText = L.crusher
	local icon = "inv_bloodtrollfemaleheaddire01"
	self:Message(-18539, "cyan", nil, CL.incoming:format(messageText), icon)
	self:PlaySound(-18539, "long")
	self:CDBar(-18539, 62.5, messageText, icon)
	self:Bar(-18539, 14, L.spawning:format(messageText), icon)
end

function mod:NazmaniBloodhexer(args)
	local messageText = L.bloodhexer
	local icon = "inv_bloodtrollfemalehead"
	self:Message(-18540, "cyan", nil, CL.incoming:format(messageText), icon)
	self:PlaySound(-18540, "long")
	self:CDBar(-18540, 62.5, messageText, icon)
	self:Bar(-18540, 14, L.spawning:format(messageText), icon)
end

function mod:BloodthirstyCrawg(args)
	local messageText = L.crawg
	local icon = "achievement_dungeon_infestedcrawg"
	self:Message(-18541, "cyan", nil, CL.incoming:format(messageText), icon)
	self:PlaySound(-18541, "long")
	self:CDBar(-18541, 42.5, messageText, icon)
	self:Bar(-18541, 14, L.spawning:format(messageText), icon)
end

function mod:ThrummingPulse(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:CongealBlood(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Bloodshard(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:EngorgedBurst(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
end

function mod:LocusofCorruption(args)
	self:StopBar(L.crawg)
	self:StopBar(L.bloodhexer)
	self:StopBar(L.crusher)
	self:StopBar(273361) -- Pool of Blood
	self:StopBar(273365) -- Dark Revelation

	stage = 2
	self:Message("stages", "green", nil, CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	self:CDBar(274358, 10) -- Rupturing Blood
	self:CDBar(273361, 16) -- Pool of Blood
	self:CDBar(274271, 26) -- Death Wish
end

function mod:RupturingBloodApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	if self:Me(args.destGUID) or amount > 2 then
		self:PlaySound(args.spellId, "warning", args.destName)
	end
	self:CDBar(args.spellId, 6.1)
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(274271, "ME_ONLY")

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message(274271, "blue", nil, CL.you:format(("|T13700%d:0|t%s"):format(isOnMe, mod:SpellName(274271))))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message(274271, "orange", nil, CL.other:format(mod:SpellName(274271), msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:DeathwishApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.1)
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(deathwishMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end
end

function mod:DeathwishRemoved(args)
	if self:GetOption(deathwishMarker) then
		SetRaidTarget(args.destName, 0)
	end
end
