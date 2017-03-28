
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Maiden of Vigilance", 1147, 1897)
if not mod then return end
mod:RegisterEnableMob(118289) -- Maiden of Vigilance
mod.engageId = 2052
mod.respawnTime = 30 -- XXX Unconfirmed

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local shieldActive = false
local massInstabilityCounter = 0
local hammerofCreationCounter = 0
local hammerofObliterationCounter = 0
local infusionCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end
--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
		240209, -- Unstable Soul
		241593, -- Aegwynn's Ward
		{235271, "PROXIMITY"}, -- Infusion
		241635, -- Hammer of Creation
		241636, -- Hammer of Obliteration
		235267, -- Mass Instability
		237722, -- Blowback
		235028, -- Titanic Bulwark
		234891, -- Wrath of the Creators
		239153, -- Spontaneous Fragmentation
	},{
		["berserk"] = "general",
		[235271] = -14974, -- Stage One: Divide and Conquer
		[237722] = -14975, -- Stage Two: Watcher's Wrath
		[239153] = "mythic",
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "UnstableSoul", 240209) -- Unstable Soul
	self:Log("SPELL_AURA_APPLIED", "AegwynnsWardApplied", 241593) -- Aegwynn's Ward

	-- Stage One: Divide and Conquer
	self:Log("SPELL_CAST_START", "Infusion", 235271) -- Infusion
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 235240, 240219) -- Fel Infusion
	self:Log("SPELL_AURA_APPLIED", "LightInfusion", 235213, 240218) -- Light Infusion
	self:Log("SPELL_CAST_SUCCESS", "HammerofCreation", 241635) -- Hammer of Creation
	self:Log("SPELL_CAST_SUCCESS", "HammerofObliteration", 241636) -- Hammer of Obliteration
	self:Log("SPELL_CAST_SUCCESS", "MassInstability", 235267) -- Mass Instability

	-- Stage Two: Watcher's Wrath
	self:Log("SPELL_CAST_SUCCESS", "Blowback", 237722) -- Blowback
	self:Log("SPELL_AURA_APPLIED", "TitanicBulwarkApplied", 235028) -- Titanic Bulwark
	self:Log("SPELL_AURA_REMOVED", "TitanicBulwarkRemoved", 235028) -- Titanic Bulwark
	self:Log("SPELL_CAST_SUCCESS", "WrathoftheCreators", 234891) -- Wrath of the Creators
	self:Log("SPELL_AURA_APPLIED", "WrathoftheCreatorsApplied", 237339) -- Wrath of the Creators
	self:Log("SPELL_AURA_APPLIED_DOSE", "WrathoftheCreatorsApplied", 237339) -- Wrath of the Creators
	self:Log("SPELL_AURA_REMOVED", "WrathoftheCreatorsInterrupted", 234891) -- Wrath of the Creators

	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "SpontaneousFragmentation", 239153) -- Hammer of Creation
end

function mod:OnEngage()
	phase = 1
	shieldActive = false

	massInstabilityCounter = 0
	hammerofCreationCounter = 0
	hammerofObliterationCounter = 0
	infusionCounter = 0

	self:Bar(235271, 2.0) -- Infusion
	self:Bar(241635, 14.0) -- Hammer of Creation
	self:Bar(235267, 24.0) -- Mass Instability
	self:Bar(241636, 32.0) -- Hammer of Obliteration
	self:Bar(237722, 41.0) -- Blowback
	self:Bar(234891, 43.5) -- Wrath of the Creators
	self:Berserk(480) -- Confirmed Heroic
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UnstableSoul(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:AegwynnsWardApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Neutral", "Info")
	end
end

function mod:Infusion(args)
	infusionCounter = infusionCounter + 1
	self:Message(args.spellId, "Neutral", "Info", CL.casting:format(args.spellName))
	if infusionCounter == 2 then
		self:Bar(args.spellId, 38.0)
	end
end

do
	local lightList, felList = {}, {}

	function mod:FelInfusion(args)
		felList[#felList+1] = args.destName
		tDeleteItem(lightList, args.destName)
		if self:Me(args.destGUID) then
			self:TargetMessage(235271, args.destName, "Personal", "Warning", args.spellName, args.spellId)
			self:OpenProximity(235271, 5, lightList) -- Avoid people with Light debuff
		end
	end

	function mod:LightInfusion(args)
		lightList[#lightList+1] = args.destName
		tDeleteItem(felList, args.destName)
		if self:Me(args.destGUID) then
			self:TargetMessage(235271, args.destName, "Personal", "Warning", args.spellName, args.spellId)
			self:OpenProximity(235271, 5, felList) -- Avoid people with Fel debuff
		end
	end
end

function mod:HammerofCreation(args)
	hammerofCreationCounter = hammerofCreationCounter + 1
	self:Message(args.spellId, "Urgent", "Alert")
	if hammerofCreationCounter == 2 then
		self:Bar(args.spellId, 36)
	end
end

function mod:HammerofObliteration(args)
	hammerofObliterationCounter = hammerofObliterationCounter + 1
	self:Message(args.spellId, "Urgent", "Alert")
	if hammerofObliterationCounter == 2 then
		self:Bar(args.spellId, 36)
	end
end

function mod:MassInstability(args)
	massInstabilityCounter = massInstabilityCounter + 1
	self:Message(args.spellId, "Attention", "Alert")
	if massInstabilityCounter == 2 then
		self:Bar(args.spellId, 36.0)
	end
end

function mod:Blowback(args)
	phase = 2
	self:Message(args.spellId, "Important", "Warning")
end

function mod:TitanicBulwarkApplied(args)
	shieldActive = true
end

function mod:TitanicBulwarkRemoved(args)
	shieldActive = false
	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
end

function mod:WrathoftheCreators(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
end

function mod:WrathoftheCreatorsApplied(args)
	if self:Interrupter(args.sourceGUID) and not shieldActive then
		self:Message(234891, "Important", "Warning", args.spellName)
	end
end

function mod:WrathoftheCreatorsInterrupted(args)
	phase = 1
	self:Message(args.spellId, "Positive", "Long", CL.interrupted:format(args.spellName))
	massInstabilityCounter = 1
	hammerofCreationCounter = 1
	hammerofObliterationCounter = 1
	infusionCounter = 1

	self:Bar(235271, 2.0) -- Infusion
	self:Bar(241635, 14.0) -- Hammer of Creation
	self:Bar(235267, 22.0) -- Mass Instability
	self:Bar(241636, 32.0) -- Hammer of Obliteration
	self:Bar(237722, 81) -- Blowback
	self:Bar(234891, 83.5) -- Wrath of the Creators
end

function mod:SpontaneousFragmentation(args)
	self:Message(args.spellId, "Important", "Alarm")
end
