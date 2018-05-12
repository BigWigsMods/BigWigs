if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

--------------------------------------------------------------------------------
-- TODO:
-- - Impact timers for Surging Darkness
-- - Mythic

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zek'voz, Herald of N'zoth", 1861, 2169)
if not mod then return end
mod:RegisterEnableMob(134445) -- Zek'voz
mod.engageId = 2136
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageWarning = 70

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.stage2_yell = "Yogg-Saron data loading." -- Full Yell: Disc accessed. Yogg-Saron data loading.
	L.stage3_yell = "Corrupted data loading." -- Full Yell: Disc accessed. Corrupted data loading.
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		265530, -- Surging Darkness
		265231, -- Void Lash
		{265248, "TANK"}, -- Shatter

		--[[ Stage 1 ]]--
		264382, -- Eye Beam
		-18390, -- Qiraji Warrior

		--[[ Stage 2 ]]--
		265360, -- Roiling Deceit
		-18397, -- Anub'ar Voidweaver
		267180, -- Void Bolt

		--[[ Stage 3 ]]--
		267239, -- Orb of Corruption
		265662, -- Corruptor's Pact
	},{
		[265530] = "general",
		[264382] = CL.stage:format(1),
		[265360] = CL.stage:format(2),
		[267239] = CL.stage:format(3),
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ General ]]--
	self:Log("SPELL_CAST_START", "SurgingDarkness", 265530)
	self:Log("SPELL_CAST_START", "VoidLash", 265231, 265268) -- Initial, Secondary
	self:Log("SPELL_CAST_START", "Shatter", 265248)

	--[[ Stage 1 ]]--
	self:Log("SPELL_CAST_START", "EyeBeam", 264382)

	--[[ Stage 2 ]]--
	self:Log("SPELL_CAST_START", "RoilingDeceit", 265358)
	self:Log("SPELL_AURA_APPLIED", "RoilingDeceitApplied", 265360)
	self:Log("SPELL_AURA_REMOVED", "RoilingDeceitRemoved", 265360)
	self:Log("SPELL_CAST_START", "VoidBolt", 267180)

	--[[ Stage 3 ]]--
	self:Log("SPELL_CAST_START", "OrbofCorruption", 267239)
	self:Log("SPELL_AURA_APPLIED", "CorruptorsPact", 265662)
	self:Log("SPELL_AURA_REMOVED", "CorruptorsPactRemoved", 265662)
end

function mod:OnEngage()
	stage = 1
	self:Bar(265231, 15.5) -- Void Lash (Initial)
	self:Bar(265530, 33.5) -- Surging Darkness
	self:Bar(-18390, 70, nil, 275772) -- Qiraji Warrior
	self:CDBar(264382, 96) -- Eye Beam

	nextStageWarning = 73
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then
		local nextStage = stage + 1
		self:Message("stages", "green", nil, CL.soon:format(CL.stage:format(nextStage)), false)
		nextStageWarning = nextStageWarning - 30
		if nextStageWarning < 40 then
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.stage2_yell) then
		stage = 2
		self:Message("stages", "green", "Long", CL.stage:format(stage), false)
		self:StopBar(-18390) -- Qiraji Warrior
		self:StopBar(264382) -- Eye Beam
		self:CDBar(265360, 27) -- Roiling Deceit
		self:Bar(265231, 30) -- Void Lash (Initial)
		self:Bar(265530, 60.5) -- Surging Darkness
	elseif msg:find(L.stage3_yell) then
		stage = 3
		self:Message("stages", "green", "Long", CL.stage:format(stage), false)
		self:StopBar(-18397) -- Anub'ar Voidweaver
		self:StopBar(265360) -- Roiling Deceit
		self:Bar(267239, 17.5) -- Orb of Corruption
		self:Bar(265231, 35) -- Void Lash (Initial)
		self:Bar(265530, 60.5) -- Surging Darkness
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
	if spellId == 266913 then -- Spawn Qiraji Warrior
		self:Message(-18390, "cyan", nil, nil, 275772)
		self:PlaySound(-18390, "long")
		self:Bar(-18390, 60, nil, 275772)
	elseif spellId == 267192 then -- Spawn Anub'ar Caster
		self:Message(-18397, "cyan", nil, nil, 267180)
		self:PlaySound(-18397, "long")
		self:Bar(-18397, 62, nil, 267180)
	end
end

--[[ General ]]--
function mod:SurgingDarkness(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 63.5)
end

function mod:VoidLash(args)
	self:PlaySound(265231, "alarm")
	self:Message(265231, "orange")
	if args.spellId == 265231 then
		self:Bar(265248, 4) -- Shatter
		self:Bar(265231, 6.5) -- Void Lash (Secondary)
	else -- Secondary
		self:Bar(265231, 31.5) -- Void Lash (Initial)
	end
end

function mod:Shatter(args)
	self:PlaySound(args.spellId, "alert")
	self:Message(args.spellId, "cyan") -- XXX purple for tank?
end

--[[ Stage 1 ]]--
do
	local prev = 0
	local function printTarget(self, name, guid)
		self:TargetMessage2(264382, "yellow", name)
		self:PlaySound(264382, "alert")
		if self:Me(guid) then
			self:Say(264382)
		end
	end
	function mod:EyeBeam(args)
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		self:CastBar(args.spellId, 3)
		local t = GetTime()
		if t-prev > 15 then -- Casts it in sets of 3, we only need the cooldown between the sets
			prev = t
			self:CDBar(args.spellId, 46)
		end
	end
end

--[[ Stage 2 ]]--
do
	local prev, targetFound = 0, false
	local function printTarget(self, name, guid)
		if not self:Tank(name) then
			targetFound = true
			self:TargetMessage2(265360, "yellow", name)
			if self:Me(guid) then
				self:PlaySound(265360, "warning")
				self:Say(265360)
			end
		end
	end
	function mod:RoilingDeceit(args)
		targetFound = false
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		local t = GetTime()
		if t-prev > 15 then -- Casts it in sets of 3, we only need the cooldown between the sets
			prev = t
			self:CDBar(265360, 46)
		end
	end

	function mod:RoilingDeceitApplied(args)
		if not targetFound then
			self:TargetMessage2(args.spellId, "yellow", args.destName)
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "warning")
				self:SayCountdown(args.spellId, 12)
				self:Say(args.spellId)
			end
		elseif self:Me(args.destGUID) then
			self:SayCountdown(args.spellId, 12)
		end
	end

	function mod:RoilingDeceitRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:VoidBolt(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

--[[ Stage 3 ]]--
function mod:OrbofCorruption(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 90)
end

function mod:CorruptorsPact(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "long")
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:SayCountdown(args.spellId, 20)
	end
end

function mod:CorruptorsPactRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
