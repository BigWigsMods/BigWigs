--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rasha'nan", 2657, 2609)
if not mod then return end
mod:RegisterEnableMob(214504) -- Rasha'nan
mod:SetEncounterID(2918)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	439790, -- Rolling Acid
	{439815, extra = {455284}}, -- Infested Spawn XXX Still unknown which is exactly used, neither in WCL.
	{439783}, -- Spinneret's Strands
})

--------------------------------------------------------------------------------
-- Locals
--

-- Counts are {totalCount, stageCount}
local rollingAcidCount = {1, 1}
local infestedSpawnCount = {1, 1}
local spinneretsStrandsCount = {1, 1}
local erosiveSprayCount = {1, 1}
local envelopingWebsCount = {1, 1}
local causticHailCount = 1
local webReaveCount = 1
local canStartPhase = false

-- the stages are just segments of the fight with different cast sequences
-- grouping by spell id instead of stage to make copy pasta easier
local timersNormal = { -- 8:38
	[439789] = { -- Rolling Acid
		{43.3, 0},
		{18.4, 0},
		{65.5, 0},
		{65.5, 0},
		{18.4, 0},
	},
	[455373] = { -- Infested Spawn
		{62.8, 0},
		{41.9, 0},
		{16.4, 0},
		{42.0, 0},
		{63.5, 0},
	},
	[439784] = { -- Spinneret's Strands
		{14.8, 0},
		{62.5, 0},
		{40.9, 0},
		{15.4, 0},
		{41.0, 0},
	},
}
local timersHeroic = { -- 10:26
	[439789] = { -- Rolling Acid
		{41.4, 0},
		{16.8, 30.3, 0},
		{61.2, 0},
		{61.2, 0},
		{16.8, 29.7, 20.3, 0},
		{42.0, 0},
	},
	[455373] = { -- Infested Spawn
		{59.2, 0},
		{40.5, 0},
		{15.3, 29.7, 20.3, 0},
		{40.5, 0},
		{59.7, 0},
		{15.3, 29.8, 20.2, 0},
	},
	[439784] = { -- Spinneret's Strands
		{14.2, 29.7, 20.2, 0},
		{59.2, 0},
		{40.0, 0},
		{14.7, 30.3, 19.7, 0},
		{40.0, 0},
		{59.3, 0},
	},
}
local timersMythic = { -- 5:42
	[439789] = { -- Rolling Acid
		{16.2, 30.3, 0},
		{61.2, 0},
		{16.8, 29.7, 14.7, 0},
		{},
	},
	[455373] = { -- Infested Spawn
		{39.9, 0},
		{20.8, 24.2, 0},
		{20.8, 0},
		{15.3, 25.3, 0},
	},
	[439784] = { -- Spinneret's Strands
		{19.6, 45.0, 0},
		{40.0, 0},
		{40.0, 0},
		{20.3, 38.9, 0},
	},
	[454989] = { -- Enveloping Webs
		{60.1, 0},
		{14.7, 50.0, 0},
		{64.8, 0},
		{45.1, 19.7, 0},
	},
}
local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

local function cd(spellId, count)
	-- not knowing the full fight sequence makes normal table lookups sketchy without metatables
	local stage = mod:GetStage()
	return timers[spellId] and timers[spellId][stage] and timers[spellId][stage][count] or nil
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rolling_acid = "Waves"
	L.spinnerets_strands = "Strands"
	L.enveloping_webs = "Webs"
	L.enveloping_web_say = "Web" -- Singular of Webs
	L.erosive_spray = "Spray"
	L.caustic_hail = "Next Position"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{439789, "PRIVATE"}, -- Rolling Acid
			439785, -- Corrosion
			439787, -- Acidic Stupor
			439776, -- Acid Pool (Damage)
		{455373, "PRIVATE"}, -- Infested Spawn
			455287, -- Infested Bite
		{439784, "PRIVATE"}, -- Spinneret's Strands
		{444687, "TANK_HEALER"}, -- Savage Assault
			{458067, "TANK"}, -- Savage Wound
		439811, -- Erosive Spray
		452806, -- Acidic Eruption
			457877, -- Acidic Carapace
		{439795, "CASTBAR"}, -- Web Reave
		439792, -- Tacky Burst

		-- Mythic
		{454989, "SAY"}, -- Enveloping Webs
	}, {
		[454989] = "mythic",
	}, {
		[439789] = L.rolling_acid, -- Rolling Acid (Waves)
		[455373] = CL.adds, -- Infested Spawn (Adds)
		[439784] = L.spinnerets_strands, -- Spinneret's Strands (Strands)
		[439795] = CL.soak, -- Web Reave (Soak)
		[439811] = L.erosive_spray, -- Erosive Spray (Spray)
		[454989] = L.enveloping_webs, -- Enveloping Webs (Webs)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SavageAssault", 444687)
	self:Log("SPELL_AURA_APPLIED", "SavageWoundApplied", 458067)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SavageWoundApplied", 458067)
	self:Log("SPELL_CAST_START", "RollingAcid", 439789)
	self:Log("SPELL_AURA_APPLIED", "AcidicStuporApplied", 439787)
	self:Log("SPELL_AURA_APPLIED", "CorrosionApplied", 439785)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CorrosionApplied", 439785)
	self:Log("SPELL_CAST_START", "InfestedSpawn", 455373)
	self:Log("SPELL_AURA_APPLIED", "InfestedBiteApplied", 455287)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfestedBiteApplied", 455287)
	self:Log("SPELL_CAST_START", "SpinneretsStrands", 439784)
	self:Log("SPELL_CAST_START", "ErosiveSpray", 439811)
	self:Log("SPELL_CAST_SUCCESS", "TackyBurst", 439792)
	-- Mythic
	self:Log("SPELL_CAST_START", "EnvelopingWebs", 454989)
	self:Log("SPELL_AURA_APPLIED", "EnvelopingWebsApplied", 454991)

	-- Phase
	self:Log("SPELL_CAST_START", "CausticHail", 456853)
	self:Log("SPELL_CAST_SUCCESS", "CausticHailDone", 456762)
	self:Log("SPELL_CAST_START", "AcidicEruption", 452806)
	self:Log("SPELL_AURA_APPLIED", "AcidicCarapace", 457877)
	self:Log("SPELL_INTERRUPT", "AcidicEruptionInterrupted", "*")
	self:Log("SPELL_CAST_START", "WebReave", 439795)
	-- Damage
	self:Log("SPELL_AURA_APPLIED", "AcidPoolDamage", 439776)
	self:Log("SPELL_PERIODIC_DAMAGE", "AcidPoolDamage", 439776)
	self:Log("SPELL_PERIODIC_MISSED", "AcidPoolDamage", 439776)
end

function mod:OnEngage()
	self:SetStage(1)
	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic

	rollingAcidCount = {1, 1}
	infestedSpawnCount = {1, 1}
	spinneretsStrandsCount = {1, 1}
	erosiveSprayCount = {1, 1}
	envelopingWebsCount = {1, 1}
	causticHailCount = 1
	webReaveCount = 1
	canStartPhase = false

	self:Bar(439811, 3.0, CL.count:format(L.erosive_spray, erosiveSprayCount[1])) -- Erosive Spray
	self:Bar(439784, cd(439784, spinneretsStrandsCount[2]), CL.count:format(L.spinnerets_strands, spinneretsStrandsCount[1])) -- Spinneret's Strands
	self:Bar(439789, cd(439789, rollingAcidCount[2]), CL.count:format(L.rolling_acid, rollingAcidCount[1])) -- Rolling Acid
	self:Bar(455373, cd(455373, infestedSpawnCount[2]), CL.count:format(CL.adds, infestedSpawnCount[1])) -- Infested Spawn
	self:Bar("stages", self:Mythic() and 87 or self:Easy() and 90.0 or 104.5, CL.count:format(L.caustic_hail, causticHailCount), "inv_dragonflypet_red") -- Caustic Hail, better icon
	if self:Mythic() then
		self:Bar(439795, 51.2, CL.count:format(CL.soak, webReaveCount)) -- Web Reave
		self:Bar(454989, cd(454989, envelopingWebsCount[2]), CL.count:format(L.enveloping_webs, envelopingWebsCount[1])) -- Enveloping Webs
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SavageAssault(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
	-- XXX can skip the short cast? that's annoying
	-- [10.5] 14.8, 23.7, 5.9, 14.8, 3.7, 39.0
	-- self:Bar(args.spellId, 10)
end

function mod:SavageWoundApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:RollingAcid(args)
	self:StopBar(CL.count:format(L.rolling_acid, rollingAcidCount[1]))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.rolling_acid, rollingAcidCount[1])))
	-- self:PlaySound(args.spellId, "alert")
	rollingAcidCount[1] = rollingAcidCount[1] + 1 -- Total
	rollingAcidCount[2] = rollingAcidCount[2] + 1 -- Stage
	self:Bar(args.spellId, cd(args.spellId, rollingAcidCount[2]), CL.count:format(L.rolling_acid, rollingAcidCount[1]))
end

function mod:AcidicStuporApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CorrosionApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:InfestedSpawn(args)
	self:StopBar(CL.count:format(CL.adds, infestedSpawnCount[1]))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, infestedSpawnCount[1]))
	self:PlaySound(args.spellId, "info") -- adds
	infestedSpawnCount[1] = infestedSpawnCount[1] + 1 -- Total
	infestedSpawnCount[2] = infestedSpawnCount[2] + 1 -- Stage
	self:Bar(args.spellId, cd(args.spellId, infestedSpawnCount[2]), CL.count:format(CL.adds, infestedSpawnCount[1]))
end

function mod:InfestedBiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 5)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:SpinneretsStrands(args)
	self:StopBar(CL.count:format(L.spinnerets_strands, spinneretsStrandsCount[1]))
	self:Message(args.spellId, "orange", CL.count:format(L.spinnerets_strands, spinneretsStrandsCount[1]))
	self:PlaySound(args.spellId, "alert")
	spinneretsStrandsCount[1] = spinneretsStrandsCount[1] + 1
	spinneretsStrandsCount[2] = spinneretsStrandsCount[2] + 1
	self:Bar(args.spellId, cd(args.spellId, spinneretsStrandsCount[2]), CL.count:format(L.spinnerets_strands, spinneretsStrandsCount[1]))
end

function mod:ErosiveSpray(args)
	self:StopBar(CL.count:format(L.erosive_spray, erosiveSprayCount[1]))
	self:Message(args.spellId, "yellow", CL.count:format(L.erosive_spray, erosiveSprayCount[1]))
	self:PlaySound(args.spellId, "alert")
	erosiveSprayCount[1] = erosiveSprayCount[1] + 1 -- Total
	erosiveSprayCount[2] = erosiveSprayCount[2] + 1 -- Stage

	local cd = 0
	if self:GetStage() == 1 then -- 3 casts before the first move
		if self:Easy() then
			local timer = { 3.0, 31.4, 47.1 }
			cd = timer[erosiveSprayCount[2]]
		else
			local timer = {3.0, 29.6, 44.4}
			cd = timer[erosiveSprayCount[2]]
		end
	elseif erosiveSprayCount[2] == 2 then -- then 2 per
		cd = self:Easy() and 47.0 or 44.4
	end
	self:Bar(args.spellId, cd, CL.count:format(L.erosive_spray, erosiveSprayCount[1]))
end

function mod:TackyBurst(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:EnvelopingWebs(args)
	self:StopBar(CL.count:format(L.enveloping_webs, envelopingWebsCount[1]))
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.enveloping_webs, envelopingWebsCount[1])))
	self:PlaySound(args.spellId, "alarm") -- watch feet
	envelopingWebsCount[1] = envelopingWebsCount[1] + 1 -- Total
	envelopingWebsCount[2] = envelopingWebsCount[2] + 1 -- Stage
	self:Bar(args.spellId, cd(args.spellId, envelopingWebsCount[2]), CL.count:format(L.enveloping_webs, envelopingWebsCount[1]))
end

function mod:EnvelopingWebsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(454989)
		self:PlaySound(454989, "warning") -- debuff applied
		self:Yell(454989, L.enveloping_web_say, nil, "Web") -- break me
	end
end

-- Phase

function mod:CausticHail()
	self:StopBar(CL.count:format(L.caustic_hail, causticHailCount))
	self:Message("stages", "cyan", CL.count:format(L.caustic_hail, causticHailCount), "inv_dragonflypet_red")
	self:PlaySound("stages", "long")
	causticHailCount = causticHailCount + 1

	-- local timer = {14.0, 20.5, 25.1, 14.3}
	-- self:CastBar(args.spellId, timer[causticHailCount])
	canStartPhase = false
end

function mod:CausticHailDone(args)
	-- XXX non-mythic lockout? casts 456853 -> 456841(x?) -> 456762, but interrupts before 456762 don't start the next phase
	-- XXX mythic casts 456853 -> 456762(x?) so this still works, but ???
	-- self:StopCastBar(args.spellId)
	-- self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
	canStartPhase = true
end

function mod:AcidicEruption(args)
	local _, ready = self:Interrupter(args.sourceGUID)
	self:Message(args.spellId, "yellow")
	if ready then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:AcidicCarapace(args)
	self:Message(args.spellId, "cyan", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:AcidicEruptionInterrupted(args)
	if args.extraSpellId == 452806 and canStartPhase then -- Acidic Eruption
		self:Message(452806, "green", CL.interrupted:format(args.extraSpellName))
		self:PlaySound(452806, "info")
		local stage = self:GetStage() + 1
		self:SetStage(stage)

		-- Reset Stage Counts only
		rollingAcidCount[2] = 1
		infestedSpawnCount[2] = 1
		spinneretsStrandsCount[2] = 1
		erosiveSprayCount[2] = 1
		envelopingWebsCount[2] = 1

		self:Bar(439789, cd(439789, rollingAcidCount[2]), CL.count:format(self:SpellName(439789), rollingAcidCount[1])) -- Rolling Acid
		self:Bar(455373, cd(455373, infestedSpawnCount[2]), CL.count:format(self:SpellName(455373), infestedSpawnCount[1])) -- Infested Spawn
		self:Bar(439784, cd(439784, spinneretsStrandsCount[2]), CL.count:format(self:SpellName(439784), spinneretsStrandsCount[1])) -- Spinneret's Strands
		if self:Mythic() then
			self:Bar(454989, cd(454989, envelopingWebsCount[2]), CL.count:format(self:SpellName(454989), envelopingWebsCount[1])) -- Enveloping Webs
		end
		-- self:Bar(439795, 3.6, CL.count:format(self:SpellName(439795), webReaveCount)) -- Web Reave
		self:Bar(439811, self:Easy() and 35.0 or 33.3, CL.count:format(self:SpellName(439811), erosiveSprayCount[1])) -- Erosive Spray
		self:Bar("stages", self:Easy() and 90.5 or 87.0, CL.count:format(L.caustic_hail, causticHailCount), "inv_dragonflypet_red") -- Caustic Hail, better icon
	end
end

function mod:WebReave(args)
	self:StopBar(CL.count:format(CL.soak, webReaveCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(CL.soak, webReaveCount)))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(CL.soak, webReaveCount))
	webReaveCount = webReaveCount + 1
end

-- Damage

do
	local prev = 0
	function mod:AcidPoolDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
