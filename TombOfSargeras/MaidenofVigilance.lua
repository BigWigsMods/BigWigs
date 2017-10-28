
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
	L.absorb = "Absorb"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Cast"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"
	L.stacks = "Stacks"
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
		{235028, "INFOBOX"}, -- Titanic Bulwark
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
	self:Log("SPELL_AURA_APPLIED", "UnstableSoul", 243276, 240209, 235117) -- Mythic, LFR, Normal/Heroic
	self:Log("SPELL_AURA_REFRESH", "UnstableSoul", 243276, 240209, 235117) -- Mythic, LFR, Normal/Heroic
	self:Log("SPELL_AURA_REMOVED", "UnstableSoulRemoved", 243276, 240209, 235117) -- Mythic, LFR, Normal/Heroic
	self:Log("SPELL_AURA_APPLIED", "AegwynnsWardApplied", 241593, 236420) -- Heroic, Normal/LFR
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 238028, 238408) -- Light Remanence, Fel Remanence
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 238028, 238408)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 238028, 238408)

	-- Stage One: Divide and Conquer
	self:Log("SPELL_CAST_START", "Infusion", 235271)
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 235240)
	self:Log("SPELL_AURA_APPLIED", "LightInfusion", 235213)
	self:Log("SPELL_AURA_APPLIED", "InfusionLFR", 240219, 240218) -- Fel Infusion (LFR), Light Infusion (LFR)
	self:Log("SPELL_CAST_START", "HammerofCreation", 241635)
	self:Log("SPELL_CAST_START", "HammerofObliteration", 241636)
	self:Log("SPELL_CAST_START", "MassInstability", 235267)

	-- Stage Two: Watcher's Wrath
	self:Log("SPELL_CAST_SUCCESS", "Blowback", 248812)
	self:Log("SPELL_AURA_APPLIED", "TitanicBulwarkApplied", 235028)
	self:Log("SPELL_AURA_REMOVED", "TitanicBulwarkRemoved", 235028)
	self:Log("SPELL_CAST_SUCCESS", "WrathoftheCreators", 234891)
	self:Log("SPELL_AURA_REMOVED", "WrathoftheCreatorsInterrupted", 234891)
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

	if not self:LFR() then
		self:Bar(235271, 2) -- Infusion
		self:Bar(241635, 12, L.lightHammer) -- Hammer of Creation
		self:Bar(235267, 22) -- Mass Instability
		self:Bar(241636, 32, L.felHammer) -- Hammer of Obliteration
		self:Bar(248812, 42.5) -- Blowback
		self:Bar(234891, 43.5) -- Wrath of the Creators
	else
		self:Bar(235267, 6) -- Mass Instability
		self:Bar(235271, 41) -- Infusion
		self:Bar(248812, 46) -- Blowback
		self:Bar(234891, 47.5) -- Wrath of the Creators
	end

	if self:Mythic() then
		self:Bar(239153, 8, CL.count:format(self:SpellName(230932), orbCounter))
	end
	if not self:LFR() then
		self:Berserk(480)
	end
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

do
	local prev = 0
	function mod:UnstableSoul(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:TargetMessage(235117, args.destName, "Personal", "Alarm")
			end
			-- Duration can be longer if the debuff gets refreshed
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:TargetBar(235117, remaining, args.destName)
		end
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
	if self:LFR() then return end
	infusionCounter = infusionCounter + 1
	if infusionCounter == 2 then
		self:Bar(args.spellId, 38.0)
	end
end

do
	local function checkSide(self, newSide, spellName)
		local sideString = newSide == 235240 and L.fel or L.light
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

function mod:InfusionLFR(args)
	if self:Me(args.destGUID) then
		self:Message(235271, "Positive", "Info", args.spellName)
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
	if self:LFR() then
		if massInstabilityCounter < 5 then
			self:Bar(args.spellId, 12)
		end
	else
		if massInstabilityCounter == 2 then
			self:Bar(args.spellId, 36)
		end
	end
end

function mod:Blowback(args)
	self:Message(args.spellId, "Important", "Warning")
end

do
	local timer, castOver, maxAbsorb = nil, 0, 0
	local red, yellow, green = {.6, 0, 0, .6}, {.7, .5, 0}, {0, .5, 0}

	local function updateInfoBox(self, spellId)
		local castTimeLeft = castOver - GetTime()
		local castPercentage = castTimeLeft / 50
		local absorb = UnitGetTotalAbsorbs("boss1")
		local absorbPercentage = absorb / maxAbsorb

		local diff = castPercentage - absorbPercentage
		local hexColor = "ff0000"
		local rgbColor = red
		if diff > 0.1 then -- over 10%
			hexColor = "00ff00"
			rgbColor = green
		elseif diff > 0  then -- below 10%, so it's still close
			hexColor = "ffff00"
			rgbColor = yellow
		end

		self:SetInfoBar(spellId, 1, absorbPercentage, unpack(rgbColor))
		self:SetInfo(spellId, 2, L.absorb_text:format(self:AbbreviateNumber(absorb), hexColor, absorbPercentage * 100))
		self:SetInfoBar(spellId, 3, castPercentage)
		self:SetInfo(spellId, 4, L.cast_text:format(castTimeLeft, hexColor, castPercentage * 100))
		self:SetInfo(spellId, 6, ("%d/30"):format(wrathStacks))
	end

	function mod:TitanicBulwarkApplied(args)
		wrathStacks = 0
		if self:CheckOption(args.spellId, "INFOBOX") then
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfo(args.spellId, 1, L.absorb)
			self:SetInfo(args.spellId, 3, L.cast)
			self:SetInfo(args.spellId, 5, L.stacks)
			castOver = GetTime() + 50 -- Time to 30 stacks
			maxAbsorb = UnitGetTotalAbsorbs("boss1")
			timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self, args.spellId)
		end
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
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
		self:CloseInfo(235028) -- Titanic Bulwark

		if not self:LFR() then
			self:Bar(235271, 2) -- Infusion
			self:Bar(241635, 14, L.lightHammer) -- Hammer of Creation
			self:Bar(235267, 22) -- Mass Instability
			self:Bar(241636, 32, L.felHammer) -- Hammer of Obliteration
			self:Bar(248812, 82.5) -- Blowback
			self:Bar(234891, 83.5) -- Wrath of the Creators
		else
			self:Bar(235267, 8) -- Mass Instability
			self:Bar(248812, 66) -- Blowback
			self:Bar(234891, 68) -- Wrath of the Creators
		end
		if self:Mythic() then
			self:Bar(239153, 8, CL.count:format(self:SpellName(230932), orbCounter))
		end
	end
end
