if not BigWigsLoader.onTestBuild then return end
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
local rotationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.placeholder = "placeholder"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Firelord's Fury
		421343, -- Brand of Damnation
		421656, -- Cauterizing Wound
		{422577, "SAY", "SAY_COUNTDOWN"}, -- Searing Aftermath
		{421455, "SAY_COUNTDOWN"}, -- Overheated
		421969, -- Flame Waves
		422691, -- Lava Geysers
		421532, -- Smoldering Ground
		-- Stage Two: World In Flames
		426725, -- Encroaching Destruction
		422277, -- Devour Essence
		421858, -- Ignited Essence
		422172, -- World In Flames
	}
end

function mod:OnBossEnable()
	-- Stage One: The Firelord's Fury
	self:Log("SPELL_CAST_START", "BrandofDamnation", 421343)
	self:Log("SPELL_AURA_APPLIED", "CauterizingWoundApplied", 421656)
	self:Log("SPELL_AURA_REMOVED", "CauterizingWoundRemoved", 421656)
	self:Log("SPELL_AURA_APPLIED", "SearingAftermathApplied", 422577)
	self:Log("SPELL_AURA_REMOVED", "SearingAftermathRemoved", 422577)
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

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 421969, 422823, 421532) -- Flame Waves, Lava Geysers, Smoldering Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 421969, 422823, 421532)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 421969, 422823, 421532)
end

function mod:OnEngage()
	self:SetStage(1)
	brandofDamnationCount = 1
	overheatedCount = 1
	lavaGeysersCount = 1
	rotationCount = 1

	self:Bar(421343, 13, CL.count:format(self:SpellName(421343), brandofDamnationCount)) -- Brand of Damnation
	self:Bar(421455, 10.5, CL.count:format(self:SpellName(421455), overheatedCount)) -- Overheated
	self:Bar(422691, 27, CL.count:format(self:SpellName(422691), lavaGeysersCount)) -- Lava Geysers
	self:Bar("stages", 67.2, CL.count:format(CL.stage:format(2), rotationCount), 422172) -- Stage 2
	self:Bar(426725, 395) -- Encroaching Destruction -- XXX Only after last world
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The Firelord's Fury
function mod:BrandofDamnation(args)
	self:StopBar(CL.count:format(args.spellName, brandofDamnationCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, brandofDamnationCount))
	self:PlaySound(args.spellId, "alert")
	brandofDamnationCount = brandofDamnationCount + 1
	if brandofDamnationCount < 9 then -- 8 total
		self:Bar(args.spellId, brandofDamnationCount % 2 == 1 and 69 or 30, CL.count:format(args.spellName, brandofDamnationCount))
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

do
	local playerList = {}
	local prev = 0
	function mod:OverheatedApplied(args)
		local msg = CL.count:format(args.spellName, overheatedCount)
		if args.time - prev > 2 then -- reset
			playerList = {}
			prev = args.time
			self:StopBar(msg)
			self:Message(args.spellId, "yellow", msg)
			overheatedCount = overheatedCount + 1
			if overheatedCount < 9 then -- 8 total
				self:Bar(args.spellId, overheatedCount % 2 == 1 and 69 or 30, CL.count:format(args.spellName, overheatedCount))
			end
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:SayCountdown(args.spellId, 10)
		end
	end

	function mod:OverheatedRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:LavaGeysers(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, lavaGeysersCount))
	self:PlaySound(args.spellId, "alarm") -- watch feet
	lavaGeysersCount = lavaGeysersCount + 1
	if lavaGeysersCount < 9 then -- 8 total
		self:Bar(args.spellId, lavaGeysersCount % 2 == 1 and 77 or 22, CL.count:format(args.spellName, lavaGeysersCount))
	end
end

function mod:BlazingSoulApplied(args)
	self:SetStage(2)
	self:StopBar(CL.count:format(CL.stage:format(2), rotationCount))
end

function mod:BlazingSoulRemoved(args)
	self:SetStage(1)
	rotationCount = rotationCount + 1
	self:Bar("stages", 65, CL.count:format(CL.stage:format(2), rotationCount), 422172)
end

function mod:EncroachingDestruction(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:DevourEssence(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
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

