
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Castle Nathria Affixes", 2296)
if not mod then return end
mod.displayName = CL.affixes
mod:RegisterEnableMob(
	164406, -- Shriekwing
	165066, 165067, 169457, 169458, -- Huntsman Altimor, Margore, Bargast, Hecutis
	164261, -- Hungering Destroyer
	166644, -- Artificer Xy'mox
	165805, 165759, 168973, -- Shade of Kael'thas, Kael'thas, High Torturer Darithos
	165521, -- Lady Inerva Darkvein
	166969, 166970, 166971, -- Baroness Frieda, Lord Stavros, Castellan Niklaus
	164407, -- Sludgefist
	168112, 168113, -- General Kaal, General Grashaal
	167406 -- Sire Denathrius
)

--------------------------------------------------------------------------------
-- Locals
--

local bossToCheck = {
	[2398] = 164406, -- Shriekwing
	[2418] = 165066, -- Huntsman Altimor
	[2383] = 164261, -- Hungering Destroyer
	[2405] = 166644, -- Artificer Xy'mox
	[2402] = 168973, -- High Torturer Darithos
	[2406] = 165521, -- Lady Inerva Darkvein
	[2412] = 166971, -- Castellan Niklaus
	[2399] = 164407, -- Sludgefist
	[2417] = 168112, -- General Kaal
	[2407] = 167406, -- Sire Denathrius
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
local p2EmitterCount = 0

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
		-- (2407) Denathrius activates later
		mod:Bar(371254, activeBoss == 2407 and 25 or 5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
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
	if activeBoss == 2398 then -- Shriekwing
		self:Log("SPELL_AURA_REMOVED", "ShriekwingBloodShroudRemoved", 328921)
	elseif activeBoss == 2412 then -- Council
		self:Log("SPELL_CAST_SUCCESS", "CouncilDanseMacabreBegins", 347376)
		self:Log("SPELL_AURA_REMOVED", "CouncilDanseMacabreOver", 330959)
	elseif activeBoss == 2407 then -- Denathrius
		self:Log("SPELL_CAST_START", "DenathriusMarchOfThePenitentStart", 328117)
		self:Log("SPELL_CAST_SUCCESS", "DenathriusIndignationSuccess", 326005)
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
	self:Bar(372634, 60, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
end

function mod:ReconfigurationEmitter(args)
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	if activeBoss == 2407 then -- Denathrius
		if self:GetStage() == 1 then
			self:Bar(args.spellId, 60, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		elseif self:GetStage() == 2 then
			local cd = 85
			if emitterCount - p2EmitterCount == 1 then
				cd = self:Mythic() and 79 or 84
			end
			self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		elseif self:GetStage() == 3 then
			self:Bar(args.spellId, 70, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		end
	else
		self:Bar(args.spellId, 75, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
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
			if activeBoss ~= 2398 or creationSparkCount % 2 == 0 then -- Shriekwing: two per stage one
				self:Bar(args.spellId, 45, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			end
		end
		playerList[#playerList + 1] = args.destName
		self:NewTargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(L.creation_spark, creationSparkCount - 1))
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Boss specific timer resetting
function mod:ShriekwingBloodShroudRemoved()
	self:Bar(369505, 20, bar_icon..CL.count:format(L.creation_spark, creationSparkCount)) -- Creation Spark
end

function mod:CouncilDanseMacabreBegins()
	-- Does not pause but has a timer reset when dancing.
	-- Pausing the bar right away so the player can see when the ability will come in line with others.
	self:CDBar(371254, 3.2, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
	self:PauseBar(371254, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:CouncilDanseMacabreOver()
	self:ResumeBar(371254, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
end

function mod:DenathriusMarchOfThePenitentStart()
	p2EmitterCount = emitterCount
	self:Bar(371254, 27, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
end

function mod:DenathriusIndignationSuccess()
	self:Bar(371254, 29.5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
end
