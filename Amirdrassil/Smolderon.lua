--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Smolderon", 2549, 2563)
if not mod then return end
mod:RegisterEnableMob(200927)
mod:SetEncounterID(2824)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local brandofDamnationCount = 1
local overheatedCount = 1
local lavaGeysersCount = 1
local seekingInfernoCount = 1
local rotationCount = 1
local heatingUpCount = 0
local overheatedOnMe = false
local castingWorldInFlames = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.brand_of_damnation = "Tank Soak"
	L.lava_geysers = "Geysers"
	L.flame_waves = "Tornados"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Firelord's Fury
		{421343, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Brand of Damnation
		421656, -- Cauterizing Wound
		{422577, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Searing Aftermath
		{421455, "ME_ONLY_EMPHASIZE"}, -- Overheated
		421969, -- Flame Waves
		422691, -- Lava Geysers
		421532, -- Smoldering Ground
		-- Stage Two: World In Flames
		426725, -- Encroaching Destruction
		422277, -- Devour Essence
		421858, -- Ignited Essence
		422172, -- World In Flames
		423896, -- Heating Up
		425885, -- Seeking Inferno
	},{
		["stages"] = "general",
		[421343] = -27637, -- Stage One: The Firelord's Fury
		[426725] = -27649, -- Stage Two: World In Flames
		[425885] = "mythic",
	},{
		[421343] = L.brand_of_damnation, -- Brand of Damnation (Tank Soak)
		[422691] = L.lava_geysers, -- Lava Geysers (Geysers)
		[425885] = CL.orbs, -- Seeking Inferno (Orbs)
	}
end

function mod:OnBossEnable()
	-- Stage One: The Firelord's Fury
	self:Log("SPELL_CAST_START", "BrandofDamnation", 421343)
	self:Log("SPELL_AURA_APPLIED", "CauterizingWoundApplied", 421656)
	self:Log("SPELL_AURA_REMOVED", "CauterizingWoundRemoved", 421656)
	self:Log("SPELL_AURA_APPLIED", "SearingAftermathApplied", 422577)
	self:Log("SPELL_AURA_REMOVED", "SearingAftermathRemoved", 422577)
	self:Log("SPELL_CAST_SUCCESS", "Overheated", 430677)
	self:Log("SPELL_AURA_APPLIED", "OverheatedApplied", 421455)
	self:Log("SPELL_AURA_REMOVED", "OverheatedRemoved", 421455)
	self:Log("SPELL_CAST_START", "LavaGeysers", 422691)

	-- Stage Two: World In Flames
	self:Log("SPELL_AURA_APPLIED", "BlazingSoulApplied", 422067)
	self:Log("SPELL_AURA_REMOVED", "BlazingSoulRemoved", 422067)
	self:Log("SPELL_CAST_START", "EncroachingDestruction", 426725)
	self:Log("SPELL_CAST_SUCCESS", "DevourEssence", 422277)
	self:Log("SPELL_AURA_APPLIED", "IgnitedEssenceApplied", 421858)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IgnitedEssenceApplied", 421858)
	self:Log("SPELL_CAST_START", "WorldInFlames", 422172)
	self:Log("SPELL_AURA_APPLIED", "HeatingUpApplied", 423896)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HeatingUpApplied", 423896)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 421969, 422823, 421532) -- Flame Waves, Lava Geysers, Smoldering Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 421969, 422823, 421532)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 421969, 422823, 421532)

	-- Mythic
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	self:SetStage(1)
	brandofDamnationCount = 1
	overheatedCount = 1
	lavaGeysersCount = 1
	seekingInfernoCount = 1
	rotationCount = 1
	heatingUpCount = 0
	overheatedOnMe = false
	castingWorldInFlames = false

	self:Bar(421455, 10.5, CL.count:format(self:SpellName(421455), overheatedCount)) -- Overheated
	self:Bar(421343, 13, CL.count:format(L.brand_of_damnation, brandofDamnationCount)) -- Brand of Damnation
	self:Bar(422691, self:Mythic() and 26.0 or 29.0, CL.count:format(L.lava_geysers, lavaGeysersCount)) -- Lava Geysers
	self:Bar("stages", 67.2, CL.count:format(CL.stage:format(2), rotationCount), 422172) -- Stage 2

	if self:Mythic() then
		self:Bar(425885, 26, CL.count:format(CL.orbs, seekingInfernoCount))
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The Firelord's Fury
function mod:BrandofDamnation(args)
	self:StopBar(CL.count:format(L.brand_of_damnation, brandofDamnationCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.brand_of_damnation, brandofDamnationCount))
	if not overheatedOnMe then -- no circle
		self:PlaySound(args.spellId, "alert") -- stack
		if self:Damager() then
			self:CastBar(args.spellId, 4, L.brand_of_damnation)
		end
	end
	brandofDamnationCount = brandofDamnationCount + 1
	if brandofDamnationCount < (self:Easy() and 13 or 9) and brandofDamnationCount % 2 == 0 then -- 8 total, starting odds after a stage 2
		self:Bar(args.spellId, 30, CL.count:format(L.brand_of_damnation, brandofDamnationCount))
	end
end

function mod:CauterizingWoundApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:CauterizingWoundRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:SearingAftermathApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetBar(args.spellId, 6, args.destName)
end

function mod:SearingAftermathRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:Overheated(args)
	self:StopBar(CL.count:format(args.spellName, overheatedCount))
	self:Message(421455, "yellow", CL.count:format(args.spellName, overheatedCount))
	overheatedCount = overheatedCount + 1
	if overheatedCount < (self:Easy() and 13 or 9) and overheatedCount % 2 == 0 then -- 8 total, starting odds after a stage 2
		self:Bar(421455, 30, CL.count:format(args.spellName, overheatedCount))
	end
	if not self:Easy() then
		self:Bar(421969, 10, L.flame_waves)
	else
		self:Bar(421455, 10, CL.over:format(args.spellName))
	end
end

function mod:OverheatedApplied(args)
	if self:Me(args.destGUID) then
		overheatedOnMe = true
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:OverheatedRemoved(args)
	if self:Me(args.destGUID) then
		overheatedOnMe = false
	end
end

function mod:LavaGeysers(args)
	self:Message(args.spellId, "orange", CL.count:format(L.lava_geysers, lavaGeysersCount))
	self:PlaySound(args.spellId, "alarm") -- watch feet
	lavaGeysersCount = lavaGeysersCount + 1
	if lavaGeysersCount < (self:Easy() and 13 or 9) and lavaGeysersCount % 2 == 0 then -- 8 total, starting odds after a stage 2
		self:Bar(args.spellId, self:Mythic() and 25.0 or 26.0, CL.count:format(L.lava_geysers, lavaGeysersCount))
	end
end

function mod:BlazingSoulApplied(args)
	self:SetStage(2)
	castingWorldInFlames = true
	self:StopBar(CL.count:format(CL.stage:format(2), rotationCount))
end

function mod:BlazingSoulRemoved(args)
	self:SetStage(1)
	castingWorldInFlames = false
	rotationCount = rotationCount + 1

	self:Bar(421455, 10.4, CL.count:format(self:SpellName(421455), overheatedCount)) -- Overheated
	self:Bar(421343, 13.0, CL.count:format(L.brand_of_damnation, brandofDamnationCount)) -- Brand of Damnation
	self:Bar(422691, self:Mythic() and 26.0 or 29.0, CL.count:format(L.lava_geysers, lavaGeysersCount)) -- Lava Geysers
	self:Bar("stages", 60, CL.count:format(CL.stage:format(2), rotationCount), 422172)
	if self:Mythic() then
		self:Bar(425885, 28.0, CL.count:format(CL.orbs, seekingInfernoCount))
	end
end

function mod:EncroachingDestruction(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:DevourEssence(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
end

function mod:HeatingUpApplied(args)
	heatingUpCount = args.amount or 1
	if heatingUpCount < (self:Easy() and 6 or 4) then
		self:Message(args.spellId, "cyan", CL.stack:format(heatingUpCount, args.spellName, args.destName))
		if castingWorldInFlames then
			self:Bar("stages", 33.7, CL.stage:format(1), 422172)
		end
	else
		self:Message(args.spellId, "red", CL.stack:format(heatingUpCount, args.spellName, args.destName))
		if castingWorldInFlames then
			self:Bar(426725, 36) -- Encroaching Destruction
		end
	end
end

function mod:IgnitedEssenceApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:WorldInFlames(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			local key = args.spellId
			if args.spellId == 422823 then -- Lava Geysers
				key = 422691
			end
			prev = args.time
			self:PlaySound(key, "underyou") -- SetOption:421969,422691,421532:::
			self:PersonalMessage(key, "underyou") -- SetOption:421969,422691,421532:::
		end
	end
end

-- Mythic
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 426144 then -- Seeking Inferno
		self:Message(425885, "red", CL.count:format(CL.orbs, seekingInfernoCount))
		self:PlaySound(425885, "warning") -- watch feet
		seekingInfernoCount = seekingInfernoCount + 1
		if seekingInfernoCount < 9 and seekingInfernoCount % 2 == 0 then -- 8 total, starting odds after a stage 2
			self:Bar(425885, 25, CL.count:format(CL.orbs, seekingInfernoCount))
		end
	end
end
