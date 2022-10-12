
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
	[2402] = 168973, -- High Torturer Darithos (Sun King's Salvation)
	[2406] = 165521, -- Lady Inerva Darkvein
	[2412] = 166971, -- Castellan Niklaus (Council of Blood)
	[2399] = 164407, -- Sludgefist
	[2417] = 168112, -- General Kaal (Stone Legion Generals)
	[2407] = 167406, -- Sire Denathrius
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
local p2Count = {}

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

function mod:CheckForAffixes()
	local unit = self:GetBossId(bossToCheck[activeBoss])
	if unit then
		if not emitterDetected and self:UnitBuff(unit, 372419) then -- Fated Power: Reconfiguration Emitter
			emitterDetected = true
			local cd = 5
			if activeBoss == 2407 then -- Denathrius
				cd = 24
			elseif activeBoss == 2399 then -- Sludgefist
				cd = 25
			end
			self:Bar(371254, cd, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		end
		if not chaoticEssenceDetected and self:UnitBuff(unit, 372642) then -- Fated Power: Chaotic Essence
			chaoticEssenceDetected = true
			local cd = 11
			if activeBoss == 2407 then -- Denathrius
				cd = 37.6
			elseif activeBoss == 2399 then -- Sludgefist
				cd = 31.2
			end
			self:Bar(372634, cd, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		end
		if not creationSparkDetected and self:UnitBuff(unit, 372647) then -- Fated Power: Creation Spark
			creationSparkDetected = true
			local cd = 20
			if activeBoss == 2407 then -- Denathrius
				cd = 3
			elseif activeBoss == 2399 then -- Sludgefist
				cd = 40
			end
			self:Bar(369505, cd, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
		if not protoformBarrierDetected and self:UnitBuff(unit, 372418) then -- Fated Power: Protoform Barrier
			protoformBarrierDetected = true
			local cd = 15
			if activeBoss == 2407 then -- Denathrius
				cd = 1
			elseif activeBoss == 2399 then -- Sludgefist
				cd = 30
			end
			self:Bar(371447, cd, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
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

	bar_icon = self:GetOption("custom_on_bar_icon") and bar_icon_texture or ""

	-- Encounters that need adjustments
	if activeBoss == 2398 then -- Shriekwing
		self:Log("SPELL_AURA_REMOVED", "ShriekwingBloodShroudRemoved", 328921)
	elseif activeBoss == 2402 then -- Sun King's Salvation
		self:Log("SPELL_AURA_REMOVED", "SunKingReflectionOfGuiltRemoved", 323402)
	elseif activeBoss == 2412 then -- Council
		self:Log("SPELL_CAST_SUCCESS", "CouncilDanseMacabreBegins", 347376)
		self:Log("SPELL_AURA_REMOVED", "CouncilDanseMacabreOver", 330959)
	elseif activeBoss == 2407 then -- Denathrius
		self:Log("SPELL_CAST_START", "DenathriusMarchOfThePenitentStart", 328117)
		self:Log("SPELL_CAST_SUCCESS", "DenathriusIndignationSuccess", 326005)
	end

	self:ScheduleTimer("CheckForAffixes", 0.1)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChaoticDestruction()
	chaoticEssenceDetected = true
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	self:Message(372634, "yellow")
	self:PlaySound(372634, "alarm")
	chaoticEssenceCount = chaoticEssenceCount + 1
	if activeBoss ~= 2398 or creationSparkCount % 2 == 0 then -- Shriekwing: two per stage one
		local cd = 60
		if activeBoss == 2407 then -- Denathrius
			local stage = self:GetStage()
			cd = stage == 3 and 70 or stage == 2 and 85 or 60
			if stage == 2 and (chaoticEssenceCount - p2Count[372634]) == 1 then
				cd = self:Mythic() and 80 or 85
			end
		elseif activeBoss == 2399 then -- Sludgefist
			cd = self:Mythic() and 69 or 72
		end
		self:Bar(372634, cd, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
end

function mod:ReconfigurationEmitter(args)
	emitterDetected = true
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	if activeBoss ~= 2398 or emitterCount % 2 == 0 then -- Shriekwing: two per stage one
		local cd = 75
		if activeBoss == 2407 then -- Denathrius
			local stage = self:GetStage()
			cd = stage == 3 and 70 or stage == 2 and 85 or 60
			if stage == 2 and (emitterCount - p2Count[args.spellId]) == 1 then
				cd = self:Mythic() and 80 or 85
			end
		elseif activeBoss == 2399 then -- Sludgefist
			cd = self:Mythic() and 69 or 72
		end
		self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end

function mod:ProtoformBarrierApplied(args)
	protoformBarrierDetected = true
	if self:Player(args.destFlags) then return end -- spellsteal? lol
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.on:format(CL.count:format(L.protoform_barrier, barrierCount), args.destName))
	self:PlaySound(args.spellId, "info")
	barrierCount = barrierCount + 1
	if activeBoss ~= 2398 or creationSparkCount % 2 == 0 then -- Shriekwing: two per stage one
		local cd = 60
		if activeBoss == 2407 then -- Denathrius
			local stage = self:GetStage()
			cd = stage == 3 and 70 or stage == 2 and 85 or 57
			if stage == 2 and (barrierCount - p2Count[args.spellId]) == 1 then
				cd = self:Mythic() and 80 or 85
			end
		elseif activeBoss == 2399 then -- Sludgefist
			cd = self:Mythic() and 69 or 72
		end
		self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
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
		creationSparkDetected = true
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			creationSparkCount = creationSparkCount + 1
			if activeBoss ~= 2398 or creationSparkCount % 2 == 0 then -- Shriekwing: two per stage one
				local cd = 45
				if activeBoss == 2407 then -- Denathrius
					local stage = self:GetStage()
					cd = stage == 3 and 70 or stage == 2 and 85 or 58
					if stage == 2 and self:Mythic() and (creationSparkCount - p2Count[args.spellId]) == 1 then
						cd = 80
					end
				elseif activeBoss == 2399 then -- Sludgefist
					cd = self:Mythic() and 69 or 72
				end
				self:Bar(args.spellId, cd, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			end
		end
		playerList[#playerList + 1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(L.creation_spark, creationSparkCount - 1))
		self:PlaySound(args.spellId, "info")
	end
end

-- Boss specific timer resetting
function mod:ShriekwingBloodShroudRemoved()
	if emitterDetected then
		self:CDBar(371254, 5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
	end
	if chaoticEssenceDetected then
		self:Bar(372634, 11.3, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount)) -- Chaotic Essence
	end
	if protoformBarrierDetected then
		self:Bar(371447, 15, bar_icon..CL.count:format(L.protoform_barrier, barrierCount)) -- Protoform Barrier
	end
	if creationSparkDetected then
		self:Bar(369505, 20, bar_icon..CL.count:format(L.creation_spark, creationSparkCount)) -- Creation Spark
	end
end

function mod:SunKingReflectionOfGuiltRemoved()
	-- seems all casts get delayed around shade phase start/end, so this should really
	-- be checking the remaining time and delaying? would need a lot more data z.z
	if emitterCount == 2 then
		-- If the Shade isn't up to summon the second emitter, the cast is delayed 15s
		local text = bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)
		local remaining = self:BarTimeLeft(text)
		if remaining > 0 then
			self:Bar(371254, remaining + 15, text) -- Reconfiguration Emitter
		end
	end
	-- if chaoticEssenceCount == 3 then
	-- 	local text = bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount)
	-- 	local remaining = self:BarTimeLeft(text)
	-- 	if remaining > 0 then
	-- 		self:Bar(372634, remaining + 15, text) -- Chaotic Essence
	-- 	end
	-- end
end

function mod:CouncilDanseMacabreBegins()
	-- Does not pause but has a timer reset when dancing.
	-- Pausing the bar right away so the player can see when the ability will come in line with others.
	if emitterDetected then
		self:CDBar(371254, 3.2, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
		self:PauseBar(371254, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if chaoticEssenceDetected then
		self:CDBar(372634, 9.3, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount)) -- Chaotic Essence
		self:PauseBar(372634, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if protoformBarrierDetected then
		self:CDBar(371447, 13.9, bar_icon..CL.count:format(L.protoform_barrier, barrierCount)) -- Protoform Barrier
		self:PauseBar(371447, bar_icon..CL.count:format(L.protoform_barrier, barrierCount)) -- Protoform Barrier
	end
	if creationSparkDetected then
		self:CDBar(369505, 18.4, bar_icon..CL.count:format(L.creation_spark, creationSparkCount)) -- Creation Spark
		self:PauseBar(369505, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

function mod:CouncilDanseMacabreOver()
	if emitterDetected then
		self:ResumeBar(371254, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
	end
	if chaoticEssenceDetected then
		self:ResumeBar(372634, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount)) -- Chaotic Essence
	end
	if protoformBarrierDetected then
		self:ResumeBar(371447, bar_icon..CL.count:format(L.protoform_barrier, barrierCount)) -- Protoform Barrier
	end
	if creationSparkDetected then
		self:ResumeBar(369505, bar_icon..CL.count:format(L.creation_spark, creationSparkCount)) -- Creation Spark
	end
end

function mod:DenathriusMarchOfThePenitentStart()
	self:SetStage(2)
	if emitterDetected then
		p2Count[371254] = emitterCount
		self:Bar(371254, 27, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
	end
	if protoformBarrierDetected then
		p2Count[371447] = barrierCount
		self:Bar(371447, 31, bar_icon..CL.count:format(L.protoform_barrier, barrierCount)) -- Protoform Barrier
	end
	if chaoticEssenceDetected then
		p2Count[372634] = chaoticEssenceCount
		self:Bar(372634, 38, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount)) -- Chaotic Essence
	end
	if creationSparkDetected then
		p2Count[369505] = creationSparkCount
		self:Bar(369505, 41, bar_icon..CL.count:format(L.creation_spark, creationSparkCount)) -- Creation Spark
	end
end

function mod:DenathriusIndignationSuccess()
	self:SetStage(3)
	if emitterDetected then
		self:Bar(371254, 29.5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount)) -- Reconfiguration Emitter
	end
	if chaoticEssenceDetected then
		self:Bar(372634, 36.5, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount)) -- Chaotic Essence
	end
	if creationSparkDetected then
		self:Bar(369505, 39.5, bar_icon..CL.count:format(L.creation_spark, creationSparkCount)) -- Creation Spark
	end
	if protoformBarrierDetected then
		self:Bar(371447, 45, bar_icon..CL.count:format(L.protoform_barrier, barrierCount)) -- Protoform Barrier
	end
end
