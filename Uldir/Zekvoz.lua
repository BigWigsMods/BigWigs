
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
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageWarning = 68
local lastPower = 0
local eyeBeamCount = 0
local roilingDeceitCount = 0
local roilingDeceitTargets = {}
local surgingDarknessCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.surging_darkness_eruption = "Eruption (%d)"
	L.mythic_adds = "Mythic Adds"
	L.mythic_adds_desc = "Show timers for when the adds will spawn in Mythic (both Qiraji Warrior and Anub'ar Voidweaver spawn at the same time)."
	L.mythic_adds_icon = "inv_misc_ahnqirajtrinket_01"
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
		{264382, "SAY", "ICON", "ME_ONLY_EMPHASIZE"}, -- Eye Beam
		-18390, -- Qiraji Warrior

		--[[ Stage 2 ]]--
		{265360, "SAY", "SAY_COUNTDOWN"}, -- Roiling Deceit
		-18397, -- Anub'ar Voidweaver
		267180, -- Void Bolt

		--[[ Stage 3 ]]--
		267239, -- Orb of Corruption
		{265662, "SAY_COUNTDOWN"}, -- Corruptor's Pact
		265646, -- Will of the Corruptor

		--[[ Mythic ]]--
		"mythic_adds",
	},{
		["stages"] = "general",
		[264382] = CL.stage:format(1),
		[265360] = CL.stage:format(2),
		[267239] = CL.stage:format(3),
		["mythic_adds"] = CL.mythic,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ General ]]--
	self:Log("SPELL_CAST_START", "SurgingDarkness", 265530)
	self:Log("SPELL_CAST_START", "VoidLash", 265231, 265268) -- Initial, Secondary
	self:Log("SPELL_CAST_START", "Shatter", 265248)
	self:Log("SPELL_CAST_SUCCESS", "Stages", 181089) -- Encounter Event spell

	--[[ Stage 1 ]]--
	self:Log("SPELL_CAST_START", "EyeBeam", 264382)

	--[[ Stage 2 ]]--
	self:Log("SPELL_CAST_SUCCESS", "RoilingDeceit", 265358)
	self:Log("SPELL_AURA_APPLIED", "RoilingDeceitApplied", 265360)
	self:Log("SPELL_AURA_REMOVED", "RoilingDeceitRemoved", 265360)
	self:Log("SPELL_CAST_START", "VoidBolt", 267180)

	--[[ Stage 3 ]]--
	self:Log("SPELL_CAST_START", "OrbofCorruption", 267239)
	self:Log("SPELL_AURA_APPLIED", "CorruptorsPact", 265662)
	self:Log("SPELL_AURA_REMOVED", "CorruptorsPactRemoved", 265662)
	self:Log("SPELL_AURA_APPLIED", "WillOfTheCorruptor", 265646)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_SUCCESS", "MythicAdds", 271099)
end

function mod:OnEngage()
	stage = 1
	nextStageWarning = self:Mythic() and 43 or 68
	lastPower = 0
	eyeBeamCount = 0
	roilingDeceitCount = 0
	roilingDeceitTargets = {}

	self:Bar(265231, 15.4) -- Void Lash (Initial)
	self:Bar(265530, 25) -- Surging Darkness
	self:CDBar(264382, 51.8) -- Eye Beam

	if self:Mythic() then
		self:CDBar(265360, 31) -- Roiling Deceit -- Until APPLIED not START
		self:Bar("mythic_adds", 60, CL.adds, L.mythic_adds_icon)
	elseif not self:LFR() then
		self:Bar(-18390, 55.5, nil, 275772) -- Qiraji Warrior
	end

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Mythic: 40%, other: 65% and 30%
		local nextStage = stage + 1
		self:Message2("stages", "green", CL.soon:format(CL.stage:format(nextStage)), false)
		nextStageWarning = nextStageWarning - 35
		if nextStageWarning < 35 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if self:Mythic() then return end -- Adds are handled better in Mythic
	if spellId == 266913 then -- Spawn Qiraji Warrior
		self:Message2(-18390, "cyan", -18390, 275772)
		self:PlaySound(-18390, "long")
		self:Bar(-18390, 60, nil, 275772)
	elseif spellId == 267192 then -- Spawn Anub'ar Caster
		self:Message2(-18397, "cyan", -18397, 267180)
		self:PlaySound(-18397, "long")
		self:Bar(-18397, 80, nil, 267180)
	end
end

--[[ General ]]--
function mod:SurgingDarkness(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 83)
	surgingDarknessCount = 1
	self:StartSurgingDarknessTimer(self:Mythic() and 8 or 10.5)
end

function mod:StartSurgingDarknessTimer(t)
	self:Bar(265530, t, CL.count:format(self:SpellName(265530), surgingDarknessCount))
	surgingDarknessCount = surgingDarknessCount + 1
	local maxEruptions = self:Mythic() and 4 or 3
	if maxEruptions >= surgingDarknessCount then
		self:ScheduleTimer("StartSurgingDarknessTimer", t, self:Mythic() and 4 or 6.5)
	end
end

function mod:VoidLash(args)
	self:PlaySound(265231, "alarm")
	self:Message2(265231, "orange")
	if args.spellId == 265231 then
		self:Bar(265248, 4) -- Shatter
		self:Bar(265231, 6.5) -- Void Lash (Secondary)
	else -- Secondary
		self:Bar(265231, 31.2) -- Void Lash (Time to initial 37.7 - 6.5)
	end
end

function mod:Shatter(args)
	self:PlaySound(args.spellId, "alert")
	self:Message2(args.spellId, "purple")
end

function mod:Stages()
	stage = stage + 1
	self:Message2("stages", "green", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	self:Bar(265530, 80) -- Surging Darkness
	if self:Mythic() then
		self:StopBar(-18390) -- Qiraji Warrior
		self:StopBar(-18397) -- Anub'ar Voidweaver
		self:Bar(267239, 15) -- Orb of Corruption
		self:Bar(265231, 35) -- Void Lash (Initial)
	elseif stage == 2 then
		self:StopBar(-18390) -- Qiraji Warrior
		self:StopBar(264382) -- Eye Beam
		if not self:LFR() then
			self:Bar(-18397, 20.5, nil, 267180) -- Anub'ar Voidweaver
		end
		self:CDBar(265360, 27) -- Roiling Deceit -- Until APPLIED not START
		self:Bar(265231, 30) -- Void Lash (Initial)
	elseif stage == 3 then
		self:StopBar(-18397) -- Anub'ar Voidweaver
		self:StopBar(265360) -- Roiling Deceit
		self:Bar(267239, 12) -- Orb of Corruption
		self:Bar(265231, 30) -- Void Lash (Initial)
	end
end

--[[ Stage 1 ]]--
do
	local function printTarget(self, name, guid)
		local count = CL.count:format(self:SpellName(264382), eyeBeamCount)
		self:TargetMessage2(264382, "yellow", name, count)
		self:PrimaryIcon(264382, name)
		if self:Me(guid) then
			self:PlaySound(264382, "warning")
			self:Say(264382, count)
		else
			self:PlaySound(264382, "alert", nil, name)
		end
		if eyeBeamCount == 3 then
			self:ScheduleTimer("PrimaryIcon", 3, 264382)
		end
	end
	function mod:UNIT_TARGET(event, unit)
		self:UnregisterUnitEvent(event, unit)
		local id = unit.."target"
		printTarget(self, self:UnitName(id), UnitGUID(id))
	end
	function mod:EyeBeam(args)
		local unit = self:GetBossId(args.sourceGUID)
		if unit then
			self:RegisterUnitEvent("UNIT_TARGET", nil, unit)
		else
			self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		end
		self:CastBar(args.spellId, self:Mythic() and 1.5 or 3)
		eyeBeamCount = eyeBeamCount + 1
		if eyeBeamCount == 4 then
			eyeBeamCount = 1
		elseif eyeBeamCount == 3 then
			self:CDBar(args.spellId, self:Mythic() and 52.5 or 32.8)
		end
	end
end

--[[ Stage 2 ]]--
do
	local function printTarget(self, name, guid)
		roilingDeceitTargets[guid] = true
		local count = CL.count:format(self:SpellName(265360), roilingDeceitCount)
		self:TargetMessage2(265360, "yellow", name, count)
		if self:Me(guid) then
			self:PlaySound(265360, "warning")
			self:Say(265360, count)
		end
	end
	function mod:RoilingDeceit(args)
		self:GetBossTarget(printTarget, 1, args.sourceGUID)
		roilingDeceitCount = roilingDeceitCount + 1
		if roilingDeceitCount == 4 then
			roilingDeceitCount = 1
		elseif roilingDeceitCount == 3 then
			self:CDBar(265360, 52.7)
		end
	end

	function mod:RoilingDeceitApplied(args)
		if not roilingDeceitTargets[args.destGUID] then -- Backup for target scan
			self:TargetMessage2(args.spellId, "yellow", args.destName)
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "warning")
				self:SayCountdown(args.spellId, 12)
				self:Say(args.spellId)
			end
		else
			roilingDeceitTargets[args.destGUID] = nil
			if self:Me(args.destGUID) then
				self:SayCountdown(args.spellId, 12)
			end
		end
	end

	function mod:RoilingDeceitRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:VoidBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

--[[ Stage 3 ]]--
function mod:OrbofCorruption(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:CorruptorsPact(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "long")
		self:PersonalMessage(args.spellId)
		self:SayCountdown(args.spellId, 30)
	end
end

function mod:CorruptorsPactRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:WillOfTheCorruptor(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning", nil, args.destName)
end

--[[ Mythic ]]--
function mod:MythicAdds()
	self:Message2("mythic_adds", "cyan", CL.incoming:format(CL.adds), L.mythic_adds_icon)
	self:PlaySound("mythic_adds", "long")
	self:Bar("mythic_adds", 120, CL.adds, L.mythic_adds_icon)
end
