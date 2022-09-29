
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
	[2544] = 181551, -- Prototype of Duty (Prototype Pantheon)
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

local chaoticEssenceCount = 1
local creationSparkCount = 1
local barrierCount = 1
local emitterCount = 1

local startTime = 0

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

function mod:CheckForAffixes(count)
	count = count or 1
	if count > 3 then return end -- Jailer likes to take his sweet time

	local unit = self:GetBossId(bossToCheck[activeBoss])
	if unit then
		if not emitterDetected and self:UnitBuff(unit, 372419) then -- Fated Power: Reconfiguration Emitter
			emitterDetected = true
			local cd = 5
			if activeBoss == 2543 then -- Lords of Dread
				cd = 10
			elseif activeBoss == 2549 then -- Rygelon
				cd = self:Mythic() and 81.5 or 76.5 -- casts after Massive Bang
			elseif activeBoss == 2537 then -- The Jailer
				cd = 6
			end
			self:Bar(371254, cd, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		end
		if not chaoticEssenceDetected and self:UnitBuff(unit, 372642) then -- Fated Power: Chaotic Essence
			chaoticEssenceDetected = true
			local cd = 11
			if activeBoss == 2543 then -- Lords of Dread
				cd = 16.3
			elseif activeBoss == 2549 then -- Rygelon
				cd = self:Mythic() and 85 or 81 -- casts after Massive Bang
			end
			self:CDBar(372634, cd, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		end
		if not creationSparkDetected and self:UnitBuff(unit, 372647) then -- Fated Power: Creation Spark
			creationSparkDetected = true
			local cd = 20
			if activeBoss == 2543 then -- Lords of Dread
				cd = 25
			elseif activeBoss == 2549 then -- Rygelon
				cd = self:Mythic() and 81 or 77 -- casts after Massive Bang
			elseif activeBoss == 2537 then -- The Jailer
				cd = 1
			end
			self:Bar(369505, cd, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
		if not protoformBarrierDetected and self:UnitBuff(unit, 372418) then -- Fated Power: Protoform Barrier
			protoformBarrierDetected = true
			local cd = 15
			if activeBoss == 2543 then -- Lords of Dread
				-- delays a bit to keep it consistent (~19.3s cast after the 100 energy ability finishes)
				cd = 20
			elseif activeBoss == 2549 then -- Rygelon
				cd = self:Mythic() and 81.5 or 77 -- casts after Massive Bang
			elseif activeBoss == 2537 then -- The Jailer
				cd = 16
			end
			self:Bar(371447, cd, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
	end

	if not emitterDetected and not chaoticEssenceDetected and not creationSparkDetected and not protoformBarrierDetected then
		self:ScheduleTimer("CheckForAffixes", 0.1, count + 1)
	end
end

function mod:OnBossEngage(_, module)
	self.isEngaged = true
	activeBoss = module.engageId
	self:SetStage(1)

	emitterDetected = false
	chaoticEssenceDetected = false
	creationSparkDetected = false
	protoformBarrierDetected = false

	chaoticEssenceCount = 1
	creationSparkCount = 1
	barrierCount = 1
	emitterCount = 1

	startTime = GetTime()

	bar_icon = self:GetOption("custom_on_bar_icon") and bar_icon_texture or ""

	-- Encounters that need adjustments
	if activeBoss == 2539 then -- Lihuvim
		self:Log("SPELL_CAST_START", "LihuvimSynthesize", 363130)
	elseif activeBoss == 2529 then -- Halondrus
		self:Log("SPELL_CAST_START", "HalondrusRelocationForm", 359236)
		self:Log("SPELL_CAST_START", "HalondrusReclamationForm", 359235)
	elseif activeBoss == 2546 then -- Anduin
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
		self:Log("SPELL_AURA_REMOVED", "AnduinDominationsGraspRemoved", 362505)
		self:Log("SPELL_CAST_START", "AnduinBeaconOfHope", 365872)
	elseif activeBoss == 2543 then -- Lords of Dread
		self:Log("SPELL_CAST_SUCCESS", "LordsOfDreadInfiltrationOfDread", 360717)
		self:Log("SPELL_AURA_REMOVED", "LordsOfDreadInfiltrationOfDreadOver", 360418)
	elseif activeBoss == 2537 then -- The Jailer
		self:Log("SPELL_CAST_START", "TheJailerFinalRelentlessDomination", 367851)
		self:Log("SPELL_CAST_SUCCESS", "TheJailerUnbreakingGrasp", 363332)
		self:Log("SPELL_CAST_SUCCESS", "TheJailerDivertedLifeShield", 368383)
	end

	self:ScheduleTimer("CheckForAffixes", 0.1)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function fixedCastTime(first, period)
	-- tries to cast at every Xs
	local t = GetTime() - startTime
	local _, f = math.modf((t - first) / period)
	local remaining = (1 - f) * period
	return remaining
end

function mod:ChaoticDestruction()
	chaoticEssenceDetected = true
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	self:Message(372634, "yellow")
	self:PlaySound(372634, "alarm")
	chaoticEssenceCount = chaoticEssenceCount + 1
	local cd = 60
	if activeBoss == 2512 then -- Vigilant Guardian
		-- can delays if near the Exposed Core cast, then the next time is adjusted
		cd = fixedCastTime(11, 60)
	elseif activeBoss == 2543 then -- Lords of Dread
		if barrierCount % 2 == 0 then -- after Swarm cast (static)
			cd = 73
		else -- after Among Us cast (gets paused)
			cd = 50
		end
	elseif activeBoss == 2549 then -- Rygelon
		cd = self:Mythic() and 112 or 107 -- casts after Massive Bang
	end
	self:CDBar(372634, cd, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
end

function mod:ReconfigurationEmitter(args)
	emitterDetected = true
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	local cd = 75
	if activeBoss == 2543 then -- Lords of Dread
		if barrierCount % 2 == 0 then -- after Swarm cast (static)
			cd = 73
		else -- after Among Us cast (gets paused)
			cd = 50
		end
	elseif activeBoss == 2544 then -- Pantheon
		if self:Mythic() and emitterCount > 3 then
			cd = 85
		end
	elseif activeBoss == 2549 then -- Rygelon
		cd = self:Mythic() and 112 or 107 -- casts after Massive Bang
	end
	self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:ProtoformBarrierApplied(args)
	protoformBarrierDetected = true
	if self:Player(args.destFlags) then return end -- spellsteal? lol
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.on:format(CL.count:format(L.protoform_barrier, barrierCount), args.destName))
	self:PlaySound(args.spellId, "info")
	barrierCount = barrierCount + 1
	local cd = 60
	if activeBoss == 2512 then -- Vigilant Guardian
		-- can delays if near the Exposed Core cast, then the next time is adjusted
		cd = fixedCastTime(15, 60)
	elseif activeBoss == 2544 then -- Pantheon
		cd = fixedCastTime(15, 60)
	elseif activeBoss == 2543 then -- Lords of Dread
		if barrierCount % 2 == 0 then -- after Swarm cast (static)
			cd = 73
		else -- after Among Us cast (gets paused)
			cd = 50
		end
	elseif activeBoss == 2549 then -- Rygelon
		cd = self:Mythic() and 112 or 107 -- casts after Massive Bang
	end
	self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
end

function mod:ProtoformBarrierRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(L.protoform_barrier))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = {}
	local prev = 0
	function mod:CreationSpark(args)
		creationSparkDetected = true
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			creationSparkCount = creationSparkCount + 1
			if activeBoss ~= 2537 or not self:Mythic() then -- Jailer only casts after phase transitions in mythic
				local cd = 45
				if activeBoss == 2543 then -- Lords of Dread
					if barrierCount % 2 == 0 then -- after Swarm cast (static)
						cd = 73
					else -- after Among Us cast (gets paused)
						cd = 50
					end
				elseif activeBoss == 2549 then -- Rygelon
					cd = self:Mythic() and 112 or 107 -- casts after Massive Bang
				end
				self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			end
		end
		playerList[#playerList + 1] = args.destName
		-- Lihuvim throwing out 4 for the first?
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.creation_spark, creationSparkCount - 1))
		self:PlaySound(args.spellId, "info")
	end
end

-- Boss specific timer resetting
function mod:LihuvimSynthesize()
	if emitterDetected then
		self:Bar(371254, 24.5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if chaoticEssenceDetected then
		self:CDBar(372634, 31.5, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if protoformBarrierDetected then
		self:Bar(371447, 34.5, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if creationSparkDetected then
		self:Bar(369505, 39.5, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

function mod:HalondrusRelocationForm()
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
end

function mod:HalondrusReclamationForm()
	if emitterDetected then
		self:Bar(371254, 11.1, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if chaoticEssenceDetected then
		self:CDBar(372634, 18.2, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if protoformBarrierDetected then
		self:Bar(371447, 21.1, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if creationSparkDetected then
		self:Bar(369505, 26.1, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 363976 then -- Anduin: Shadestep // Intermission
		self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

function mod:AnduinDominationsGraspRemoved()
	local stage = self:GetStage()
	stage = stage + 1
	self:SetStage(stage)
	if stage == 2 then
		if emitterDetected then
			self:Bar(371254, 8.6, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		end
		if protoformBarrierDetected then
			self:Bar(371447, 19.1, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
		if creationSparkDetected then
			self:Bar(369505, 23.6, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
	end
end

function mod:AnduinBeaconOfHope()
	-- if you skip to p3, the cast time isn't reset
	if self:GetStage() < 3 then return end

	if emitterDetected then
		self:Bar(371254, 9.5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if protoformBarrierDetected then
		self:Bar(371447, 21.2, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if creationSparkDetected then
		self:Bar(369505, 24.5, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

function mod:LordsOfDreadInfiltrationOfDread(args)
	if self:MobId(args.sourceGUID) ~= 181399 then return end -- Kin'tessa

	-- Pauze to show timers once you finish Among Us
	if emitterDetected then
		self:Bar(371254, 9.6, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		self:PauseBar(371254, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if chaoticEssenceDetected then
		self:CDBar(372634, 16.4, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		self:PauseBar(372634, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if protoformBarrierDetected then
		self:Bar(371447, 19.3, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		self:PauseBar(371447, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if creationSparkDetected then
		self:Bar(369505, 24.2, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		self:PauseBar(369505, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

do
	local prev = 0
	function mod:LordsOfDreadInfiltrationOfDreadOver(args)
		if args.time - 10 < prev then return end
		prev = args.time

		if emitterDetected then
			self:ResumeBar(371254, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		end
		if creationSparkDetected then
			self:ResumeBar(369505, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
		if protoformBarrierDetected then
			self:ResumeBar(371447, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
		if chaoticEssenceDetected then
			self:ResumeBar(372634, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		end
	end
end

function mod:TheJailerFinalRelentlessDomination()
	if creationSparkDetected then
		self:Bar(369505, self:Mythic() and 13 or 33, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
	if chaoticEssenceDetected then
		self:CDBar(372634, self:Mythic() and 15 or 24, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if protoformBarrierDetected then
		self:Bar(371447, self:Mythic() and 13 or 28, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if emitterDetected then
		self:Bar(371254, self:Mythic() and 15.5 or 18, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end

function mod:TheJailerUnbreakingGrasp()
	if creationSparkDetected then
		self:Bar(369505, self:Mythic() and 13 or 33, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
	if chaoticEssenceDetected then
		self:CDBar(372634, self:Mythic() and 14 or 25, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if protoformBarrierDetected then
		self:Bar(371447, self:Mythic() and 13 or 28, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if emitterDetected then
		self:Bar(371254, self:Mythic() and 15.5 or 18, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end

function mod:TheJailerDivertedLifeShield()
	self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	-- if creationSparkDetected then
	-- 	self:Bar(369505, 0.5, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	-- end
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	-- if protoformBarrierDetected then
	-- 	self:Bar(371447, 0.5 bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	-- end
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	if chaoticEssenceDetected then
		self:CDBar(372634, 2.6, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	if emitterDetected then
		self:Bar(371254, 3.1, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end
