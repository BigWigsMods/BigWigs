
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sepulcher of the First Ones Affixes", 2481)
if not mod then return end
mod.displayName = CL.affixes
mod:RegisterEnableMob(
	184522, 180773, -- Vigilant Custodian, Vigilant Guardian
	181395, -- Skolex
	183501, -- Artificer Xy'mox
	181224, -- Dausegne
	181549, 181548, 181546, 181551, -- Prototype of War, Prototype of Absolution, Prototype of Renewal, Prototype of Duty
	182169, -- Lihuvim
	180906, -- Halondrus
	181954, -- Anduin Wrynn
	181398, 181399, -- Mal'Ganis, Kin'tessa
	182777, -- Rygelon
	180990 -- The Jailer
)

--------------------------------------------------------------------------------
-- Locals
--

local bossToCheck = {
	[2512] = 180773, -- Vigilant Guardian
	[2542] = 181395, -- Skolex
	[2553] = 183501, -- Artificer Xy'mox
	[2540] = 181224, -- Dausegne
	[2544] = 181549, -- Prototype of War (Prototype Pantheon)
	[2539] = 182169, -- Lihuvim
	[2529] = 180906, -- Halondrus
	[2546] = 181954, -- Anduin Wrynn
	[2543] = 181398, -- Mal'Ganis (Lords of Dread)
	[2549] = 182777, -- Rygelon
	[2537] = 180990, -- The Jailer
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
		-- Rygelon casts after Massive Bang
		mod:Bar(372634, activeBoss == 2549 and (mod:Mythic() and 83 or 78) or 11, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if not creationSparkDetected and mod:UnitBuff(unit, 372647) then -- Fated Power: Creation Spark
		creationSparkDetected = true
		if activeBoss ~= 2537 then -- Jailer first cast is at 1s
			mod:Bar(369505, 20, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
	end
	if not protoformBarrierDetected and mod:UnitBuff(unit, 372418) then -- Fated Power: Protoform Barrier
		protoformBarrierDetected = true
		-- Lords of Dread delays a bit to keep it consistent (~19.3s cast after the 100 energy ability finishes)
		mod:Bar(371447, activeBoss == 2549 and 20 or 15, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if not replicatingEssenceDetected and mod:UnitBuff(unit, 372424) then -- Fated Power: Replicating Essence
		replicatingEssenceDetected = true
		-- Not used so far
	end
end

function mod:OnBossEngage(_, module, diff)
	self.isEngaged = true
	activeBoss = module.engageId
	self:SetStage(1)

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
	if activeBoss == 2539 then -- Lihuvim
		self:Log("SPELL_CAST_START", "LihuvimSynthesize", 363130)
	elseif activeBoss == 2529 then -- Halondrus
		self:Log("SPELL_CAST_START", "HalondrusRelocationForm", 359236)
		self:Log("SPELL_CAST_START", "HalondrusReclamationForm", 359235)
	elseif activeBoss == 2546 then -- Anduin
		self:Log("SPELL_AURA_REMOVED", "AnduinDominationsGraspRemoved", 362505)
	elseif activeBoss == 2543 then -- Lords of Dread
		self:Log("SPELL_CAST_SUCCESS", "LordsOfDreadInfiltrationOfDread", 360717)
		self:Log("SPELL_AURA_REMOVED", "LordsOfDreadInfiltrationOfDreadOver", 360418)
	elseif activeBoss == 2537 then -- The Jailer
		self:Log("SPELL_CAST_START", "TheJailerFinalRelentlessDomination", 367851)
		self:Log("SPELL_CAST_SUCCESS", "TheJailerUnbreakingGrasp", 363332)
		-- and cast 0.5s after Diverted Life Shield
	end

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
	-- Rygelon casts after Massive Bang
	self:Bar(372634, activeBoss == 2549 and (self:Mythic() and 112 or 107) or 60, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
end

function mod:ReconfigurationEmitter(args)
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	-- Pantheon later casts are longer in mythic
	self:Bar(args.spellId, activeBoss == 2544 and self:Mythic() and emitterCount > 3 and 85 or 75, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:ProtoformBarrierApplied(args)
	if self:Player(args.destFlags) then return end -- spellsteal? lol
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.on:format(CL.count:format(L.protoform_barrier, barrierCount), args.destName))
	self:PlaySound(args.spellId, "info")
	barrierCount = barrierCount + 1
	if activeBoss == 2543 then -- Lords of Dread
		if barrierCount % 2 == 0 then -- after Swarm cast (static)
			self:Bar(args.spellId, 73, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		else -- after Among Us cast (gets paused)
			self:Bar(args.spellId, 50, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
	else
		self:Bar(args.spellId, 60, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
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
			if activeBoss ~= 2537 or not self:Mythic() then
				-- Jailer only appears to cast after phase transitions in mythic
				self:Bar(args.spellId, 45, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			end
		end
		playerList[#playerList + 1] = args.destName
		-- Lihuvim throwing out 4 for the first?
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.creation_spark, creationSparkCount - 1))
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Boss specific timer resetting
function mod:LihuvimSynthesize()
	self:Bar(369505, 39.5, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
end

function mod:HalondrusRelocationForm()
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
end

function mod:HalondrusReclamationForm()
	self:Bar(372634, 18.2, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
end

function mod:AnduinDominationsGraspRemoved()
	local stage = self:GetStage()
	stage = stage + 1
	self:SetStage(2)
	if stage == 2 then
		self:Bar(371254, 8.6, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	elseif stage == 3 then
		self:Bar(371254, self:Mythic() and 11.8 or 18.8, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end

function mod:LordsOfDreadInfiltrationOfDread(args)
	if self:MobId(args.sourceGUID) == 181399 then -- Kin'tessa
		self:Bar(371447, 19.3, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		-- Pauze to show timers once you finish Among Us
		self:PauseBar(371447, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
end

do
	local prev = 0
	function mod:LordsOfDreadInfiltrationOfDreadOver(args)
		if args.time - 10 > prev then
			prev = args.time
			self:ResumeBar(371447, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
	end
end

function mod:TheJailerFinalRelentlessDomination()
	self:Bar(369505, self:Mythic() and 13 or 33, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
end

function mod:TheJailerUnbreakingGrasp()
	self:Bar(369505, self:Mythic() and 13 or 33, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
end
