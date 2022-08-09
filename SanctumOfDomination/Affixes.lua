
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sanctum of Domination Affixes", 2450)
if not mod then return end
mod.displayName = CL.affixes
mod:RegisterEnableMob(
	175611, -- The Tarragrue
	175725, -- he Eye of the Jailer
	177095, 177094, 175726, -- Kyra, Signe, Skyja
	175729, 177117, -- Remnant of Ner'zhul, Orb of Torment
	175727, 175728, -- Soulrender Dormazain, Garrosh Hellscream
	176523, -- Painsmith Raznal
	175731, -- Guardian of the First Ones
	175730, -- Fatescribe Roh-Kalo
	175559, 176703, 176973, 176974, 176929, -- Kel'Thuzad, Frostbound Devoted, Unstoppable Abomination, Soul Reaver, Remnant of Kel'Thuzad
	175732 -- Sylvanas Windrunner
)

--------------------------------------------------------------------------------
-- Locals
--

local bossToCheck = {
	[2423] = 175611, -- The Tarragrue
	[2433] = 175725, -- The Eye of the Jailer
	[2429] = 177095, -- Kyra (The Nine)
	[2432] = 175729, -- Remnant of Ner'zhul
	[2434] = 175727, -- Soulrender Dormazain
	[2430] = 176523, -- Painsmith Raznal
	[2436] = 175731, -- Guardian of the First Ones
	[2431] = 175730, -- Fatescribe Roh-Kalo
	[2422] = 175559, -- Kel'Thuzad
	[2435] = 175732, -- Sylvanas Windrunner
}
local activeBoss = nil

local emitterDetected = false
local chaoticEssenceDetected = false
local creationSparkDetected = false
local protoformBarrierDetected = false
local replicatingEssenceDetected = false

local chaoticEssenceCount = 1
local creationSparkCount = 1
local barrierCount = 1
local emitterCount = 1

local bar_icon_texture = "|A:ui-ej-icon-empoweredraid-large:0:0|a "
local bar_icon = bar_icon_texture

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_bar_icon = "Bar Icon"
	L.custom_on_bar_icon_desc = bar_icon_texture.."Show the Fated Raid icon on bars."

	L.chaotic_essence = "Essence"
	L.creation_spark = "Sparks"
	L.protoform_barrier = "Barrier"
	L.reconfiguration_emitter = "Interrupt Add"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_on_bar_icon",
		372634, -- Chaotic Essence
		369505, -- Creation Spark
		371447, -- Protoform Barrier
		371254, -- Reconfiguration Emitter
	}, nil, {
		[372634] = L.chaotic_essence, -- Chaotic Essence (Essence)
		[369505] = L.creation_spark, -- Creation Spark (Sparks)
		[371447] = L.protoform_barrier, -- Protoform Barrier (Barrier)
		[371254] = L.reconfiguration_emitter, -- Reconfiguration Emitter (Interrupt Add)
	}
end

function mod:VerifyEnable()
	if C_ModifiedInstance.GetModifiedInstanceInfoFromMapID(self.instanceId) then
			return true
	end
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "OnBossEngage")
	self:RegisterEvent("ENCOUNTER_END")

	-- Chaotic Essence
	self:Log("SPELL_CAST_START", "ChaoticDestruction", 372638)
	-- Reconfiguration Emitter
	self:Log("SPELL_SUMMON", "ReconfigurationEmitter", 371254)
	-- Protoform Barrier
	self:Log("SPELL_AURA_APPLIED", "ProtoformBarrierApplied", 371447)
	self:Log("SPELL_AURA_REMOVED", "ProtoformBarrierRemoved", 371447)
	-- Creation Spark
	self:Log("SPELL_AURA_APPLIED", "CreationSpark", 369505)

	activeBoss = nil
end

function mod:ENCOUNTER_END(_, id, _, _, _, status)
	if activeBoss == id then
		if status == 1 then
			self:Disable()
		elseif status == 0 then
			self:SendMessage("BigWigs_StopBars", self)
			self:SimpleTimer(function()
				self:Disable(true)
				self:Enable(true)
			end, 5)
		end
	end
end

local function checkForAffixes()
	local unit = mod:GetBossId(bossToCheck[activeBoss])
	if not unit then return end

	if not emitterDetected and mod:UnitBuff(unit, 372419) then -- Fated Power: Reconfiguration Emitter
		emitterDetected = true
		mod:Bar(371254, 5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if not chaoticEssenceDetected and mod:UnitBuff(unit, 372642) then -- Fated Power: Chaotic Essence
		chaoticEssenceDetected = true
		mod:Bar(372634, 11, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if not creationSparkDetected and mod:UnitBuff(unit, 372647) then -- Fated Power: Creation Spark
		creationSparkDetected = true
		mod:Bar(369505, 20, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
	if not protoformBarrierDetected and mod:UnitBuff(unit, 372418) then -- Fated Power: Protoform Barrier
		protoformBarrierDetected = true
		mod:Bar(371447, 15, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if not replicatingEssenceDetected and mod:UnitBuff(unit, 372424) then -- Fated Power: Replicating Essence
		replicatingEssenceDetected = true
		-- Not used so far
	end
end

function mod:OnBossEngage(_, module, diff)
	self.isEngaged = true
	activeBoss = module.engageId

	emitterDetected = false
	chaoticEssenceDetected = false
	creationSparkDetected = false
	protoformBarrierDetected = false
	replicatingEssenceDetected = false

	chaoticEssenceCount = 1
	creationSparkCount = 1
	barrierCount = 1
	emitterCount = 1

	bar_icon = self:GetOption("custom_on_bar_icon") and bar_icon_texture or ""

	-- Encounters that need adjustments
	-- if activeBoss == 0 then
	-- end

	self:SimpleTimer(checkForAffixes, 0.1) -- Delaying for council fights with more than boss1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChaoticDestruction(args)
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	self:Message(372634, "yellow")
	self:PlaySound(372634, "alarm")
	chaoticEssenceCount = chaoticEssenceCount + 1
	if activeBoss ~= 2435 or stage ~= 2 then -- Sylvanas Stage 2 is a mystery.
		self:Bar(372634, 60, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
end

function mod:ReconfigurationEmitter(args)
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	self:Bar(args.spellId, 75, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:ProtoformBarrierApplied(args)
	if self:Player(args.destFlags) then return end -- spellsteal? lol
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.on:format(CL.count:format(L.protoform_barrier, barrierCount), args.destName))
	self:PlaySound(args.spellId, "info")
	barrierCount = barrierCount + 1
	self:Bar(args.spellId, 60, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
end

function mod:ProtoformBarrierRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(L.protoform_barrier))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = {}
	local prev = 0
	function mod:CreationSpark(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			creationSparkCount = creationSparkCount + 1
			self:Bar(args.spellId, 45, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
		playerList[#playerList + 1] = args.destName
		self:NewTargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(L.creation_spark, creationSparkCount - 1))
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Boss specific timer resetting
