
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

function mod:CheckForAffixes()
	local unit = self:GetBossId(bossToCheck[activeBoss])
	if unit then
		if not emitterDetected and self:UnitBuff(unit, 372419) then -- Fated Power: Reconfiguration Emitter
			emitterDetected = true
			self:Bar(371254, 5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
		end
		if not chaoticEssenceDetected and self:UnitBuff(unit, 372642) then -- Fated Power: Chaotic Essence
			chaoticEssenceDetected = true
			-- 2436 = Guardian
			self:Bar(372634, activeBoss == 2436 and 41 or 11, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		end
		if not creationSparkDetected and self:UnitBuff(unit, 372647) then -- Fated Power: Creation Spark
			creationSparkDetected = true
			self:Bar(369505, 20, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
		if not protoformBarrierDetected and self:UnitBuff(unit, 372418) then -- Fated Power: Protoform Barrier
			protoformBarrierDetected = true
			self:Bar(371447, 15, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
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

	startTime = GetTime()

	bar_icon = self:GetOption("custom_on_bar_icon") and bar_icon_texture or ""

	-- Encounters that need adjustments
	if activeBoss == 2433 then -- The Eye
		self:Log("SPELL_AURA_APPLIED", "TheEyeStygianDarkshieldApplied", 348805)
		self:Log("SPELL_AURA_REMOVED", "TheEyeStygianDarkshieldRemoved", 348805)
	elseif activeBoss == 2430 then -- Painsmith Raznal
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
		self:Log("SPELL_AURA_REMOVED", "PainsmithForgeWeaponOver", 355525)
	elseif activeBoss == 2431 then -- Fatescribe Roh-Kalo
		self:Log("SPELL_AURA_APPLIED", "FatescribeRealignFateApplied", 357739)
		self:Log("SPELL_AURA_REMOVED", "FatescribeRealignFateRemoved", 357739)
	elseif activeBoss == 2422 then -- Kel'Thuzad
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
		self:Log("SPELL_AURA_APPLIED", "KelThuzadNecroticSurgeApplied", 352051)
		self:Log("SPELL_AURA_APPLIED_DOSE", "KelThuzadNecroticSurgeApplied", 352051)
	elseif activeBoss == 2435 then -- Sylvanas Windrunner
		self:Log("SPELL_AURA_APPLIED", "SylvanasBansheeShroudApplied", 350857)
		self:Log("SPELL_CREATE", "SylvanasCreateBridge", 348093, 351840, 351841, 351837, 348148, 351838)
		self:Log("SPELL_CAST_SUCCESS", "SylvanasBlasphemySuccess", 357729)
	end

	self:ScheduleTimer("CheckForAffixes", 0.1) -- Delaying for council fights with more than boss1
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
	-- Sylvanas (2435) Stage 2 is curated and Guardian (2436) stops at least at link, so 60s isn't going to happen
	if (activeBoss ~= 2435 or self:GetStage() ~= 2) and activeBoss ~= 2436 then
		self:Bar(372634, 60, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
end

function mod:ReconfigurationEmitter(args)
	emitterDetected = true
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.reconfiguration_emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	-- 2431 = Fatescribe
	self:Bar(args.spellId, activeBoss == 2431 and 80 or 75, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:ProtoformBarrierApplied(args)
	protoformBarrierDetected = true
	if self:Player(args.destFlags) then return end -- spellsteal? lol
	self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.on:format(CL.count:format(L.protoform_barrier, barrierCount), args.destName))
	self:PlaySound(args.spellId, "info")
	barrierCount = barrierCount + 1
	if activeBoss == 2433 then
		-- tries to cast at every 60s
		local t = GetTime() - startTime
		local _, f = math.modf((t - 15) / 60)
		if f > 0.95 then f = 0 end -- round up if we're a bit (<3s) early
		local remaining = (1 - f) * 60
		self:Bar(args.spellId, remaining, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
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
		creationSparkDetected = true
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:StopBar(bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
			creationSparkCount = creationSparkCount + 1
			-- 2431 = Fatescribe
			self:Bar(args.spellId, activeBoss == 2431 and 80 or 45, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
		end
		playerList[#playerList + 1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(L.creation_spark, creationSparkCount - 1))
		self:PlaySound(args.spellId, "info")
	end
end

-- Boss specific timer resetting
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 355555 then -- Painsmith: [DNT] Upstairs
		self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	elseif spellId == 351625 then -- Kel'Thuzad: Cosmetic Death
		self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end

function mod:TheEyeStygianDarkshieldApplied()
	self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:TheEyeStygianDarkshieldRemoved()
	if chaoticEssenceDetected then
		self:CDBar(372634, 3, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if emitterDetected then
		-- tries to cast at every 60s
		local t = GetTime() - startTime
		local _, f = math.modf((t - 15) / 60)
		local remaining = (1 - f) * 60
		-- but won't go over 30s (?) after a phase, in 5s increments
		while remaining > 35 do
			remaining = remaining - 5
		end
		self:Bar(372634, remaining, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
end

function mod:PainsmithForgeWeaponOver()
	if chaoticEssenceDetected then
		self:CDBar(372634, 17.5, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
	end
	if emitterDetected then
		self:Bar(372634, 21, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
end

function mod:FatescribeRealignFateApplied()
	self:StopBar(bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
end

function mod:FatescribeRealignFateRemoved()
	if emitterDetected then
		self:CDBar(372634, 10, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
	if creationSparkCount then
		self:CDBar(369505, 25.6, bar_icon..CL.count:format(L.creation_spark, creationSparkCount))
	end
end

function mod:KelThuzadNecroticSurgeApplied()
	if protoformBarrierDetected then
		self:Bar(372634, 15, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
	if emitterDetected then
		self:CDBar(372634, 5, bar_icon..CL.count:format(L.reconfiguration_emitter, emitterCount))
	end
end

function mod:SylvanasBansheeShroudApplied()
	if self:GetStage() == 1 then
		self:SetStage(1.5)
		self:StopBar(bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		self:StopBar(bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
	end
end

do
	local bridgeCount = 1
	function mod:SylvanasCreateBridge()
		if self:GetStage() < 2 then
			self:SetStage(2)
			bridgeCount = 1
		end
			if not self:Mythic() then
				if bridgeCount == 2 then
					if chaoticEssenceDetected then
						self:Bar(372634, 11.5, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
					end
					if protoformBarrierDetected then
						self:Bar(372634, 15, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
					end
				elseif bridgeCount == 3 then
					if protoformBarrierDetected then
						self:Bar(372634, 10, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
					end
				elseif bridgeCount == 5 then
					if chaoticEssenceDetected then
						self:Bar(372634, 17.2, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
					end
				end
			else -- Mythic
				if bridgeCount == 2 then
					if chaoticEssenceDetected then
						self:Bar(372634, 15.7, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
					end
					if protoformBarrierDetected then
						self:Bar(372634, 9.2, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
					end
				elseif bridgeCount == 4 then
					if chaoticEssenceDetected then
						self:Bar(372634, 7.1, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
					end
				elseif bridgeCount == 6 then
					if protoformBarrierDetected then
						self:Bar(372634, 14.3, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
					end
				end
			end
		bridgeCount = bridgeCount + 1
	end
end

function mod:SylvanasBlasphemySuccess()
	if self:GetStage() < 3 then
		self:SetStage(3)
		if chaoticEssenceDetected then
			self:Bar(372634, 26.6, bar_icon..CL.count:format(L.chaotic_essence, chaoticEssenceCount))
		end
		if protoformBarrierDetected then
			self:Bar(372634, 30, bar_icon..CL.count:format(L.protoform_barrier, barrierCount))
		end
	end
end
