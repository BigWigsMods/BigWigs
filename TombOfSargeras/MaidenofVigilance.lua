
-- GLOBALS: tContains, tDeleteItem

--------------------------------------------------------------------------------
-- TODO List:
-- Orbs alternate colour, maybe something like Krosus Assist?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Maiden of Vigilance", 1147, 1897)
if not mod then return end
mod:RegisterEnableMob(118289) -- Maiden of Vigilance
mod.engageId = 2052
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local massInstabilityCounter = 0
local hammerofCreationCounter = 0
local hammerofObliterationCounter = 0
local infusionCounter = 0
local orbCounter = 1
local mySide = 0
local lightList, felList = {}, {}
local initialOrbs = nil
local orbTimers = {8, 8.5, 7.5, 10.5, 11.5, 8.0, 8.0, 10.0}
local wrathStacks = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.infusionChanged = "Infusion CHANGED: %s"
	L.sameInfusion = "Same Infusion: %s"
	L.fel = "Fel"
	L.light = "Light"
	L.felHammer = "Fel Hammer" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "Light Hammer" -- Better name for "Hammer of Creation"
end
--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
		{235117, "COUNTDOWN"}, -- Unstable Soul
		241593, -- Aegwynn's Ward
		{235271, "PROXIMITY", "FLASH"}, -- Infusion
		241635, -- Hammer of Creation
		238028, -- Light Remanence
		241636, -- Hammer of Obliteration
		238408, -- Fel Remanence
		235267, -- Mass Instability
		248812, -- Blowback
		235028, -- Titanic Bulwark
		234891, -- Wrath of the Creators
		239153, -- Spontaneous Fragmentation
	},{
		["berserk"] = "general",
		[235271] = -14974, -- Stage One: Divide and Conquer
		[248812] = -14975, -- Stage Two: Watcher's Wrath
		[239153] = "mythic",
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "UnstableSoul", 243276, 235117) -- Mythic, Others
	self:Log("SPELL_AURA_REMOVED", "UnstableSoulRemoved", 243276, 235117) -- Mythic, Others
	self:Log("SPELL_AURA_APPLIED", "AegwynnsWardApplied", 241593, 236420) -- Heroic, Normal
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 238028, 238408) -- Light Remanence, Fel Remanence
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 238028, 238408)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 238028, 238408)

	-- Stage One: Divide and Conquer
	self:Log("SPELL_CAST_START", "Infusion", 235271) -- Infusion
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 235240, 240219) -- Heroic, Normal
	self:Log("SPELL_AURA_APPLIED", "LightInfusion", 235213, 240218) -- Heroic, Normal
	self:Log("SPELL_CAST_START", "HammerofCreation", 241635) -- Hammer of Creation
	self:Log("SPELL_CAST_START", "HammerofObliteration", 241636) -- Hammer of Obliteration
	self:Log("SPELL_CAST_START", "MassInstability", 235267) -- Mass Instability

	-- Stage Two: Watcher's Wrath
	self:Log("SPELL_CAST_SUCCESS", "Blowback", 248812) -- Blowback
	self:Log("SPELL_AURA_APPLIED", "TitanicBulwarkApplied", 235028) -- Titanic Bulwark
	self:Log("SPELL_AURA_REMOVED", "TitanicBulwarkRemoved", 235028) -- Titanic Bulwark
	self:Log("SPELL_CAST_SUCCESS", "WrathoftheCreators", 234891) -- Wrath of the Creators
	self:Log("SPELL_AURA_REMOVED", "WrathoftheCreatorsInterrupted", 234891) -- Wrath of the Creators
end

function mod:OnEngage()
	mySide = 0
	wipe(lightList)
	wipe(felList)

	massInstabilityCounter = 0
	hammerofCreationCounter = 0
	hammerofObliterationCounter = 0
	infusionCounter = 0
	orbCounter = 1
	initialOrbs = true
	wrathStacks = 0

	self:Bar(235271, 2.0) -- Infusion
	self:Bar(241635, 14.0, L.lightHammer) -- Hammer of Creation
	self:Bar(235267, 22.0) -- Mass Instability
	self:Bar(241636, 32.0, L.felHammer) -- Hammer of Obliteration
	self:Bar(248812, 42.5) -- Blowback
	self:Bar(234891, 43.5) -- Wrath of the Creators
	if self:Mythic() then
		self:Bar(239153, 8, CL.count:format(self:SpellName(230932), orbCounter))
	end
	self:Berserk(480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 239153 then -- Spontaneous Fragmentation
		self:Message(spellId, "Attention", "Alert", self:SpellName(230932))
		orbCounter = orbCounter + 1
		if orbCounter <= 4 and initialOrbs then
			self:Bar(spellId, 8, CL.count:format(self:SpellName(230932), orbCounter))
		elseif not initialOrbs then
			self:Bar(spellId, orbTimers[orbCounter], CL.count:format(self:SpellName(230932), orbCounter))
		end
	elseif spellId == 234917 or spellId == 236433 then -- Wrath of the Creators
		-- Blizzard didn't give us SPELL_AURA_APPLIED_DOSE events for the stacks,
		-- so we have to count the casts.
		wrathStacks = wrathStacks + 1
		if (wrathStacks >= 10 and wrathStacks % 5 == 0) or (wrathStacks >= 25) then -- 10,15,20,25,26,27,28,29,30
			self:Message(234891, "Urgent", wrathStacks >= 25 and "Alert", CL.count:format(spellName, wrathStacks))
		end
	end
end

function mod:UnstableSoul(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(235117, args.destName, "Personal", "Alarm")
		self:TargetBar(235117, 8, args.destName)
	end
end

function mod:UnstableSoulRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(235117, args.destName)
	end
end

function mod:AegwynnsWardApplied(args)
	if self:Me(args.destGUID) then
		self:Message(241593, "Neutral", "Info")
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Infusion(args)
	self:Message(args.spellId, "Neutral", nil, CL.casting:format(args.spellName))
	infusionCounter = infusionCounter + 1
	if infusionCounter == 2 then
		self:Bar(args.spellId, 38.0)
	end
end

do
	local function checkSide(self, newSide, spellName)
		local sideString = (newSide == 235240 or newSide == 240219) and L.fel or L.light
		if mySide ~= newSide then
			self:Message(235271, "Important", "Warning", mySide == 0 and spellName or L.infusionChanged:format(sideString), newSide)
			self:Flash(235271)
		else
			self:Message(235271, "Positive", "Info", L.sameInfusion:format(sideString), newSide)
		end
		mySide = newSide
	end

	function mod:FelInfusion(args)
		if not tContains(felList, args.destName) then
			felList[#felList+1] = args.destName
		end
		tDeleteItem(lightList, args.destName)
		if self:Me(args.destGUID) then
			self:OpenProximity(235271, 5, lightList) -- Avoid people with Light debuff
			checkSide(self, args.spellId, args.spellName)
		end
	end

	function mod:LightInfusion(args)
		if not tContains(lightList, args.destName) then
			lightList[#lightList+1] = args.destName
		end
		tDeleteItem(felList, args.destName)
		if self:Me(args.destGUID) then
			self:OpenProximity(235271, 5, felList) -- Avoid people with Fel debuff
			checkSide(self, args.spellId, args.spellName)
		end
	end
end

function mod:HammerofCreation(args)
	self:Message(args.spellId, "Urgent", "Alert", L.lightHammer)
	hammerofCreationCounter = hammerofCreationCounter + 1
	if hammerofCreationCounter == 2 then
		self:Bar(args.spellId, 36, L.lightHammer)
	end
end

function mod:HammerofObliteration(args)
	self:Message(args.spellId, "Urgent", "Alert", L.felHammer)
	hammerofObliterationCounter = hammerofObliterationCounter + 1
	if hammerofObliterationCounter == 2 then
		self:Bar(args.spellId, 36, L.felHammer)
	end
end

function mod:MassInstability(args)
	self:Message(args.spellId, "Attention", "Alert")
	massInstabilityCounter = massInstabilityCounter + 1
	if massInstabilityCounter == 2 then
		self:Bar(args.spellId, 36)
	end
end

function mod:Blowback(args)
	self:Message(args.spellId, "Important", "Warning")
end

function mod:TitanicBulwarkApplied()
	wrathStacks = 0
end

function mod:TitanicBulwarkRemoved(args)
	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
end

function mod:WrathoftheCreators(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
end

function mod:WrathoftheCreatorsInterrupted(args)
	self:Message(args.spellId, "Positive", "Long", CL.interrupted:format(args.spellName))
	massInstabilityCounter = 1
	hammerofCreationCounter = 1
	hammerofObliterationCounter = 1
	infusionCounter = 1
	orbCounter = 1
	initialOrbs = nil

	self:Bar(235271, 2) -- Infusion
	if self:Mythic() then
		self:Bar(239153, 8, CL.count:format(self:SpellName(230932), orbCounter))
	end
	self:Bar(241635, 14, L.lightHammer) -- Hammer of Creation
	self:Bar(235267, 22) -- Mass Instability
	self:Bar(241636, 32, L.felHammer) -- Hammer of Obliteration
	self:Bar(248812, 81) -- Blowback
	self:Bar(234891, 83.5) -- Wrath of the Creators
end
