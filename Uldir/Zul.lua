
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zul", 1861, 2195)
if not mod then return end
mod:RegisterEnableMob(138967)
mod.engageId = 2145
mod.respawnTime = 32

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.crawg = -18541 -- Bloodthirsty Crawg
	L.crawg_msg = "Crawg"
	L.crawg_desc = "Warnings and timers for when the Nazmani Bloodhexer spawns."
	L.crawg_icon = "inv_bloodtrollfemalehead"

	L.bloodhexer = -18540 -- Nazmani Bloodhexer
	L.bloodhexer_msg = "Bloodhexer"
	L.bloodhexer_desc = "Warnings and timers for when the Nazmani Bloodhexer spawns."
	L.bloodhexer_icon = "inv_bloodtrollfemalehead"

	L.crusher = -18539 -- Nazmani Crusher
	L.crusher_msg = "Crusher"
	L.crusher_desc = "Warnings and timers for when the Nazmani Crusher spawns."
	L.crusher_icon = "inv_bloodtrollfemaleheaddire01"
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
		"crusher",
		"bloodhexer",
		"crawg",
		273288, -- Thrumming Pulse
		273451, -- Congeal Blood
		273350, -- Bloodshard
		276299, -- Engorged Burst
		{274358, "SAY_COUNTDOWN"}, -- Rupturing Blood
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
	self:Log("SPELL_CAST_SUCCESS", "RupturingBlood", 274358)
	self:Log("SPELL_AURA_APPLIED", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_REMOVED", "RupturingBloodRemoved", 274358)
	self:Log("SPELL_AURA_APPLIED", "DeathwishApplied", 274271)
	self:Log("SPELL_AURA_REMOVED", "DeathwishRemoved", 274271)
end

function mod:OnEngage()
	stage = 1
	self:Bar(273361, 21) -- Pool of Darkness
	self:Bar(273365, 30) -- Dark Revelation

	self:CDBar("crawg", 37, CL.soon:format(L.crawg_msg), L.crawg_icon)
	self:CDBar("bloodhexer", 50, CL.soon:format(L.bloodhexer_msg), L.bloodhexer_icon)
	self:CDBar("crusher", 75, CL.soon:format(L.crusher_msg), L.crusher_icon)

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
			self:TargetBar(args.spellId, 10, 140995, args.spellId) -- 140995 = "Explode"
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
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
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
	self:Message("crusher", "cyan", nil, CL.soon:format(L.crusher_msg), L.crusher_icon)
	self:PlaySound("crusher", "long")
	self:CDBar("crusher", 62.5, CL.soon:format(L.crusher_msg), L.crusher_icon)
	self:Bar("crusher", 14, CL.spawning:format(L.crusher_msg), L.crusher_icon)
end

function mod:NazmaniBloodhexer(args)
	self:Message("bloodhexer", "cyan", nil, CL.soon:format(L.bloodhexer_msg), L.bloodhexer_icon)
	self:PlaySound("bloodhexer", "long")
	self:CDBar("bloodhexer", 62.5, L.bloodhexer_msg, L.bloodhexer_icon)
	self:Bar("bloodhexer", 14, CL.spawning:format(L.bloodhexer_msg), L.bloodhexer_icon)
end

function mod:BloodthirstyCrawg(args)
	self:Message("crawg", "cyan", nil, CL.soon:format(L.crawg_msg), L.crawg_icon)
	self:PlaySound("crawg", "long")
	self:CDBar("crawg", 42.5, L.crawg_msg, L.crawg_icon)
	self:Bar("crawg", 14, CL.spawning:format(L.crawg_msg), L.crawg_icon)
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
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
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

	if self:Tank() then
		self:CDBar(274358, 10) -- Rupturing Blood
	end
	self:CDBar(273361, 16) -- Pool of Blood
	self:CDBar(274271, 26) -- Death Wish
end

function mod:RupturingBlood(args)
	if self:Tank() then
		self:CDBar(args.spellId, 6.1)
	end
end

function mod:RupturingBloodApplied(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:SayCountdown(args.spellId, 20, nil, 5)
		self:PlaySound(args.spellId, "warning", args.destName)
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	elseif self:Tank() and self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		if amount > 2 then
			self:PlaySound(args.spellId, "warning", args.destName)
		end
	end
end

function mod:RupturingBloodRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
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
