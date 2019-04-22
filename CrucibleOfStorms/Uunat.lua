--------------------------------------------------------------------------------
-- TODO
--
-- - When infobox is not in use - display who holds a relic (or on the ground)
-- - Mythic Icons Pulse debuff

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Uu'nat, Harbinger of the Void", 2096, 2332)
if not mod then return end
mod:RegisterEnableMob(145371) -- Uu'nat
mod.engageId = 2273
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageWarning = 73
local mindbenderList = {}
local mobCollector = {}
local mindbenderSpawnCount = 0

local oblivionTearCount = 1
local voidCrashCount = 1
local giftCount = 1
local eyesCount = 1
local maddeningCount = 1
local guardianCount = 1
local mindbenderCount = 1
local unknowableTerrorCount = 1
local insatiableTormentCount = 1

local absorbActive = false
local shieldActive = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Uunat can delay some of his abilities. When this option is enabled, the bars for those abilities will stay on your screen."

	L.absorb = "Absorb"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.bubble = "Bubble" -- Custody of the Deep Bubble
	L.cast = "Cast"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.void = "Void" -- Unstable Resonance: Void
	L.ocean = "Ocean" -- Unstable Resonance: Ocean
	L.storm = "Storm" -- Unstable Resonance: Storm
	L.custom_on_repeating_resonance_say = "Repeating Unstable Resonance Say"
	L.custom_on_repeating_resonance_say_desc = "Spam the icons {rt3}{rt5}{rt6} (Void, Ocean and Storm) in say chat to be avoided during Unstable Resonance."
	L.custom_on_repeating_resonance_say_icon = 293653
end

--------------------------------------------------------------------------------
-- Initialization
--

local mindbenderMarker = mod:AddMarkerOption(false, "npc", 1, -19118, 1, 2, 3) -- Primordial Mindbender
function mod:GetOptions()
	return {
		"stages",
		"custom_on_stop_timers",
		"berserk",
		{-19055, "INFOBOX"}, -- Relics of Power
		284722, -- Umbral Shell
		284804, -- Custody of the Deep
		284809, -- Abyssal Collapse
		284583, -- Storm of Annihilation
		{284851, "TANK"}, -- Touch of the End
		285185, -- Oblivion Tear
		285416, -- Void Crash
		285376, -- Eyes of N'Zoth
		285345, -- Maddening Eyes of N'Zoth
		285453, -- Gift of N'Zoth: Obscurity
		285820, -- Call Undying Guardian
		285638, -- Gift of N'Zoth: Hysteria
		-19118, -- Primordial Mindbender
		285427, -- Consume Essence
		mindbenderMarker,
		285562, -- Unknowable Terror
		{285652, "SAY"}, -- Insatiable Torment
		285685, -- Gift of N'Zoth: Lunacy
		{293653, "FLASH", "PULSE"}, -- Unstable Resonance
		"custom_on_repeating_resonance_say",
		{285307, "TANK"}, -- Feed
	},{
		["stages"] = "general",
		[-19055] = -19055, -- Relics of Power
		[284851] = -19104, -- Stage One: His All-Seeing Eyes
		[285638] = -19105, -- Stage Two: His Dutiful Servants
		[285652] = -19106, -- Stage Three: His Unwavering Gaze
		[293653] = "mythic",
	}
end

function mod:OnBossEnable()
	-- Relics of Power XXX Need cooldowns of the spells
	self:Log("SPELL_AURA_APPLIED", "UmbralShellApplied", 284722)
	self:Log("SPELL_AURA_REMOVED", "UmbralShellRemoved", 284722)
	self:Log("SPELL_AURA_APPLIED", "CustodyoftheDeepApplied", 284804)
	self:Log("SPELL_CAST_START", "AbyssalCollapseStart", 284809)
	self:Log("SPELL_CAST_SUCCESS", "AbyssalCollapseSuccess", 284809)
	self:Log("SPELL_AURA_APPLIED", "StormofAnnihilationApplied", 284583)

	-- Stage One: His All-Seeing Eyes
	-- Uu'nat, Harbinger of the Void
	self:Log("SPELL_CAST_SUCCESS", "TouchoftheEndSuccess", 284851)
	self:Log("SPELL_AURA_APPLIED", "TouchoftheEndApplied", 284851)
	self:Log("SPELL_CAST_START", "OblivionTear", 285185)
	self:Log("SPELL_CAST_SUCCESS", "VoidCrash", 285416)
	self:Log("SPELL_CAST_START", "EyesofNZoth", 285376)
	self:Log("SPELL_CAST_START", "MaddeningEyesofNZoth", 285345)
	self:Log("SPELL_CAST_START", "GiftofNZothObscurity", 285453)
	self:Log("SPELL_CAST_START", "CallUndyingGuardian", 285820)
	self:Log("SPELL_AURA_APPLIED", "VoidShieldApplied", 286310)
	self:Log("SPELL_AURA_REMOVED", "VoidShieldRemoved", 286310)

	-- Stage Two: His Dutiful Servants
	self:Log("SPELL_CAST_START", "GiftofNZothHysteria", 285638)
	self:Log("SPELL_CAST_START", "ConsumeEssence", 285427)
	self:Log("SPELL_CAST_START", "UnknowableTerror", 285562)

	-- Stage Three: His Unwavering Gaze
	self:Log("SPELL_CAST_SUCCESS", "InsatiableTormentSuccess", 285652)
	self:Log("SPELL_AURA_APPLIED", "InsatiableTormentApplied", 285652)
	self:Log("SPELL_CAST_START", "GiftofNZothLunacy", 285685)

	-- Mythic
	self:Log("SPELL_CAST_START", "UnstableResonanceStart", 293653)
	self:Log("SPELL_AURA_APPLIED", "UnstableResonanceDebuff", 293663, 293662, 293661) -- Void, Ocean, Storm
	self:Log("SPELL_AURA_REMOVED", "UnstableResonanceDebuffRemoved", 293663, 293662, 293661) -- Void, Ocean, Storm

	-- Undying Guardian (Mythic)
	self:Log("SPELL_CAST_START", "Feed", 285307)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	stage = 1
	nextStageWarning = 73
	mindbenderList = {}
	mobCollector = {}
	mindbenderSpawnCount = 0

	oblivionTearCount = 1
	voidCrashCount = 1
	giftCount = 1
	eyesCount = 1
	maddeningCount = 1
	guardianCount = 1
	mindbenderCount = 1
	unknowableTerrorCount = 1
	insatiableTormentCount = 1

	absorbActive = false
	shieldActive = false

	self:Bar(285416, 7.1, CL.count:format(self:SpellName(285416), voidCrashCount)) -- Void Crash
	self:Bar(285185, 12.2, CL.count:format(self:SpellName(285185), oblivionTearCount)) -- Oblivion Tear
	self:Bar(285453, 20.7, CL.count:format(self:SpellName(285453), giftCount)) -- Gift of N'Zoth: Obscurity
	self:Bar(284851, 26.8) -- Touch of the End
	self:Bar(285820, 30.1, CL.count:format(self:SpellName(285820), guardianCount)) -- Call Undying Guardian
	self:Bar(285376, 42.5, CL.count:format(self:SpellName(285376), eyesCount)) -- Eyes of N'Zoth
	self:Bar(285345, 77.2, CL.count:format(self:SpellName(285345), maddeningCount)) -- Maddening Eyes of N'Zoth

	if self:CheckOption(-19055, "INFOBOX") then
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3", "boss4")
	else
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	end
	if self:GetOption(mindbenderMarker) then
		self:RegisterTargetEvents("MinderbenderMarker")
	end
	self:Berserk(780)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local abilitysToPause = {
		[285416] = true, -- Void Crash
		[285185] = true, -- Oblivion Tear
		[285453] = true, -- Gift of N'Zoth: Obscurity
		[285820] = true, -- Call Undying Guardian
		[285376] = true, -- Eyes of N'Zoth
		[285345] = true, -- Maddening Eyes of N'Zoth
		[285562] = true,  -- Unknowable Terror
		[-19118] = true, -- Primordial Mindbender
		[285638] = true, -- Gift of N'Zoth: Hysteria
		[285652] = true, -- Insatiable Torment
		[285685] = true, -- Gift of N'Zoth: Lunacy
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

-- Relics of Power
do
	local maxAbsorb, absorbRemoved, absorbTarget, maxShield, currentShield, castOver, scheduled = 0, 0, nil, 0, 0, 0, nil
	local red, yellow, green = {.6, 0, 0, .6}, {.7, .5, 0}, {0, .5, 0}

	function mod:updateInfoBox(logUpdate)
		if absorbActive == false and shieldActive == false then
			self:CloseInfo(-19055)
		else
			self:OpenInfo(-19055, self:SpellName(-19055)) -- Relics of Power
			if absorbActive == false then -- Clear Umbral Shell
				self:SetInfo(-19055, 1, "")
				self:SetInfo(-19055, 3, "")
				self:SetInfo(-19055, 4, "")
				self:SetInfoBar(-19055, 3, 0)
			elseif absorbActive == true then
				local absorb = maxAbsorb - absorbRemoved
				local absorbPercentage = absorb / maxAbsorb
				self:SetInfo(-19055, 1, "|T237570:15:15:0:0:64:64:4:60:4:60|t "..self:ColorName(absorbTarget)) -- spell_shadow_twistedfaith
				self:SetInfo(-19055, 3, L.absorb)
				self:SetInfoBar(-19055, 3, absorbPercentage)
				self:SetInfo(-19055, 4, L.absorb_text:format(self:AbbreviateNumber(absorb), "00ff00", absorbPercentage*100))
			end
			if shieldActive == false then -- Clear Abyssal Collapse
				self:SetInfo(-19055, 5, "")
				self:SetInfoBar(-19055, 7, 0)
				self:SetInfo(-19055, 8, "")
				self:SetInfoBar(-19055, 9, 0)
				self:SetInfo(-19055, 10, "")
			elseif shieldActive == true then
				local castTimeLeft = castOver - GetTime()
				local castPercentage = castTimeLeft / 20
				local shieldPercentage = currentShield / maxShield

				local diff = castPercentage - shieldPercentage
				local hexColor = "ff0000"
				local rgbColor = red
				if diff > 0.1 then -- over 10%
					hexColor = "00ff00"
					rgbColor = green
				elseif diff > 0  then -- below 10%, so it's still close
					hexColor = "ffff00"
					rgbColor = yellow
				end

				self:SetInfo(-19055, 5, "|T1320371:15:15:0:0:64:64:4:60:4:60|t "..self:SpellName(284809)) -- spell_winston_bubble, Abyssal Collapse
				self:SetInfo(-19055, 7, L.bubble)
				self:SetInfoBar(-19055, 7, shieldPercentage, unpack(rgbColor))
				self:SetInfo(-19055, 8, L.absorb_text:format(self:AbbreviateNumber(currentShield), hexColor, shieldPercentage*100))
				self:SetInfoBar(-19055, 9, castPercentage)
				self:SetInfo(-19055, 10, L.cast_text:format(castTimeLeft, hexColor, castPercentage*100))
				if not scheduled then
					scheduled = self:ScheduleTimer("CheckRune", 0.1)
				end
				if not logUpdate then
					self:ScheduleTimer("updateInfoBox", 0.1)
				end
			end
		end
	end

	function mod:UNIT_HEALTH_FREQUENT(event, unit)
		if unit == "boss1" then -- Check stage changes
			local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
			if hp < nextStageWarning then -- Intermission at 70% & 45%
				self:Message2("stages", "green", CL.soon:format(CL.intermission), false)
				nextStageWarning = nextStageWarning - 25
				if nextStageWarning < 30 then
					self:UnregisterUnitEvent(event, unit)
				end
			end
		else -- check for Shield
			local guid = UnitGUID(unit)
			if self:MobId(guid) == 146642 then -- Ocean Rune
				shieldActive = true
				maxShield = UnitHealthMax(unit)
				currentShield = UnitHealth(unit)
				self:updateInfoBox(true) -- Abyssal Collapse
			end
		end
	end

	do
		local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
		function mod:UmbralShellAbsorbs()
			local _, subEvent, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, spellId, _, _, absorbed = CombatLogGetCurrentEventInfo()
			if subEvent == "SPELL_ABSORBED" and spellId == 284722 then -- Umbral Shell
				absorbRemoved = absorbRemoved + absorbed
				self:updateInfoBox(true)
			end
		end
	end

	function mod:UmbralShellApplied(args)
		self:TargetMessage2(args.spellId, "cyan", args.destName)
		self:PlaySound(args.spellId, "info", nil, args.destName)
		if self:CheckOption(-19055, "INFOBOX") then
			absorbActive = true
			absorbRemoved = 0
			maxAbsorb = args.amount
			absorbTarget = args.destName
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UmbralShellAbsorbs")
			self:updateInfoBox()
		end
	end

	function mod:UmbralShellRemoved(args)
		self:Message2(args.spellId, "cyan", CL.removed_from:format(args.spellName, self:ColorName(args.destName)))
		self:PlaySound(args.spellId, "info", nil, args.destName)
		if self:CheckOption(-19055, "INFOBOX") then
			absorbActive = false
			absorbTarget = nil
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:updateInfoBox()
		end
	end

	function mod:CheckRune()
		if scheduled then
			mod:CancelTimer(scheduled)
			scheduled = nil
		end
		if mod:GetBossId(146642) then -- Ocean Rune
			scheduled = mod:ScheduleTimer("CheckRune", 0.1)
		elseif shieldActive == true then
			shieldActive = false
			mod:Message2(284809, "cyan" , CL.over:format(mod:SpellName(284809))) -- Abyssal Collapse
			mod:PlaySound(284809, "info")
			mod:StopBar(CL.cast:format(mod:SpellName(284809)))
			if self:CheckOption(-19055, "INFOBOX") then
				self:updateInfoBox()
			end
		end
	end

	function mod:AbyssalCollapseStart(args)
		shieldActive = true
		castOver = GetTime() + 20
		self:Message2(args.spellId, "cyan")
		self:PlaySound(args.spellId, "long")
		self:CastBar(args.spellId, 20)
		scheduled = mod:ScheduleTimer("CheckRune", 0.5)
		if self:CheckOption(-19055, "INFOBOX") then
			self:updateInfoBox()
		end
	end

	function mod:AbyssalCollapseSuccess(args)
		shieldActive = false
		castOver = 0
		self:Message2(args.spellId, "cyan" , CL.over:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:StopBar(CL.cast:format(args.spellName))
		if self:CheckOption(-19055, "INFOBOX") then
			self:updateInfoBox()
		end
	end

	function mod:CustodyoftheDeepApplied(args)
		if self:Me(args.destGUID) then
			self:TargetMessage2(args.spellId, "green", args.destName)
			self:PlaySound(args.spellId, "info")
		end
	end

	function mod:StormofAnnihilationApplied(args)
		self:TargetMessage2(args.spellId, "cyan", args.destName)
		self:PlaySound(args.spellId, "long", nil, args.destName)
		self:CastBar(args.spellId, 15) -- Custody of the Deep
	end
end

-- Stage One: His All-Seeing Eyes
-- Uu'nat, Harbinger of the Void
function mod:TouchoftheEndSuccess(args)
	self:Bar(args.spellId, 25.5)
end

function mod:TouchoftheEndApplied(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:OblivionTear(args)
	self:StopBar(CL.count:format(args.spellName, oblivionTearCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, oblivionTearCount))
	self:PlaySound(args.spellId, "alarm")
	oblivionTearCount = oblivionTearCount + 1
	self:Bar(args.spellId, stage == 3 and 12.2 or 17, CL.count:format(args.spellName, oblivionTearCount))
end

function mod:VoidCrash(args)
	self:StopBar(CL.count:format(args.spellName, voidCrashCount))
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, voidCrashCount))
	self:PlaySound(args.spellId, "warning")
	voidCrashCount = voidCrashCount + 1
	self:Bar(args.spellId, 31.6, CL.count:format(args.spellName, voidCrashCount))
end

function mod:EyesofNZoth(args)
	self:StopBar(CL.count:format(args.spellName, eyesCount))
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, eyesCount))
	self:PlaySound(args.spellId, "long")
	eyesCount = eyesCount + 1
	self:Bar(args.spellId, stage == 3 and 47 or 33, CL.count:format(args.spellName, eyesCount))
end

do
	local prev = 0
	function mod:MaddeningEyesofNZoth(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(args.spellName, maddeningCount))
			self:Message2(args.spellId, "orange", CL.count:format(args.spellName, maddeningCount))
			self:PlaySound(args.spellId, "alarm")
			self:CastBar(args.spellId, 4.5, CL.count:format(args.spellName, maddeningCount))
			maddeningCount = maddeningCount + 1
			self:Bar(args.spellId, 65, CL.count:format(args.spellName, maddeningCount))
		end
	end
end

function mod:GiftofNZothObscurity(args)
	self:StopBar(CL.count:format(args.spellName, giftCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, giftCount))
	self:PlaySound(args.spellId, "warning")
	giftCount = giftCount + 1
	self:Bar(args.spellId, 42.5, CL.count:format(args.spellName, giftCount))
end

function mod:CallUndyingGuardian(args)
	self:StopBar(CL.count:format(args.spellName, guardianCount))
	self:Message2(args.spellId, "cyan", CL.count:format(args.spellName, guardianCount))
	self:PlaySound(args.spellId, "info")
	guardianCount = guardianCount + 1
	self:Bar(args.spellId, stage == 3 and 31.5 or 46.2, CL.count:format(args.spellName, guardianCount))
end


function mod:VoidShieldApplied(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "green", CL.intermission, false)
	self:Bar("stages", 15.8, CL.intermission, args.spellId)

	-- Stage 1 Bars
	self:StopBar(CL.count:format(self:SpellName(285416), voidCrashCount)) -- Void Crash
	self:StopBar(CL.count:format(self:SpellName(285185), oblivionTearCount)) -- Oblivion Tear
	self:StopBar(CL.count:format(self:SpellName(285453), giftCount)) -- Gift of N'Zoth: Obscurity
	self:StopBar(284851) -- Touch of the End
	self:StopBar(CL.count:format(self:SpellName(285820), guardianCount)) -- Call Undying Guardian
	self:StopBar(CL.count:format(self:SpellName(285376), eyesCount)) -- Eyes of N'Zoth
	self:StopBar(CL.count:format(self:SpellName(285345), maddeningCount)) -- Maddening Eyes of N'Zoth

	-- Additional Stage 2 Bars
	self:StopBar(CL.count:format(self:SpellName(285562), unknowableTerrorCount)) -- Unknowable Terror
	self:StopBar(CL.count:format(self:SpellName(-19118), mindbenderCount)) -- Primordial Mindbender
	self:StopBar(CL.count:format(self:SpellName(285638), giftCount)) -- Gift of N'Zoth: Hysteria
end

function mod:VoidShieldRemoved(args)
	stage = stage + 1
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)

	oblivionTearCount = 1
	voidCrashCount = 1
	giftCount = 1
	eyesCount = 1
	maddeningCount = 1
	guardianCount = 1
	mindbenderCount = 1
	unknowableTerrorCount = 1
	insatiableTormentCount = 1

	if stage == 2 then
		self:Bar(285185, 13.3, CL.count:format(self:SpellName(285185), oblivionTearCount)) -- Oblivion Tear
		self:Bar(285562, 18.2, CL.count:format(self:SpellName(285562), unknowableTerrorCount)) -- Unknowable Terror
		self:Bar(284851, 21.9) -- Touch of the End
		self:Bar(285820, 31.6, CL.count:format(self:SpellName(285820), guardianCount)) -- Call Undying Guardian
		self:Bar(-19118, 34.0, CL.count:format(self:SpellName(-19118), mindbenderCount), 285427) -- Primordial Mindbender, Consume Essence icon
		self:Bar(285638, 40.1, CL.count:format(self:SpellName(285638), giftCount)) -- Gift of N'Zoth: Hysteria
	else -- stage 3
		self:Bar(285652, 12.1, CL.count:format(self:SpellName(285652), insatiableTormentCount)) -- Insatiable Torment
		self:Bar(285185, 13.3, CL.count:format(self:SpellName(285185), oblivionTearCount)) -- Oblivion Tear
		self:Bar(284851, 21.8) -- Touch of the End
		self:Bar(285820, 26.7, CL.count:format(self:SpellName(285820), guardianCount)) -- Call Undying Guardian
		self:Bar(285685, 40.0, CL.count:format(self:SpellName(285685), giftCount)) -- Gift of N'Zoth: Lunacy
		self:Bar(285376, 45.7, CL.count:format(self:SpellName(285376), eyesCount)) -- Eyes of N'Zoth
	end
end

-- Stage Two: His Dutiful Servants
function mod:GiftofNZothHysteria(args)
	self:StopBar(CL.count:format(args.spellName, giftCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, giftCount))
	self:PlaySound(args.spellId, "warning")
	giftCount = giftCount + 1
	self:Bar(args.spellId, 42.5, CL.count:format(args.spellName, giftCount))
end

do
	local prev = 0
	function mod:ConsumeEssence(args)
		local t = args.time
		if t-prev > 58 then -- Throttle this 58s as the cooldown is 60s
			prev = t
			mindbenderList = {} -- Reset list for marking
			self:StopBar(CL.count:format(self:SpellName(-19118), mindbenderCount))
			self:Message2(args.spellId, "yellow", CL.count:format(self:SpellName(-19118), mindbenderCount), 285427) -- Primordial Mindbender, Consume Essence icon
			self:PlaySound(args.spellId, "long")
			mindbenderCount = mindbenderCount + 1
			self:CDBar(-19118, 60.0, CL.count:format(self:SpellName(-19118), mindbenderCount), 285427) -- Primordial Mindbender, Consume Essence icon
		end
		if not mobCollector[args.sourceGUID] then
			mindbenderSpawnCount = mindbenderSpawnCount + 1
			mobCollector[args.sourceGUID] = true
			mindbenderList[args.sourceGUID] = (mindbenderSpawnCount % 3) + 1 -- 1, 2, 3
			if #mindbenderList == 3 then
				for k, v in pairs(mindbenderList) do
					local unit = self:findTargetByGUID(k)
					if unit then
						SetRaidTarget(unit, mindbenderList[k])
						mindbenderList[k] = nil
					end
				end
			end
		end

		local _, ready = self:Interrupter(args.sourceGUID)
		if ready then
			self:Message2(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:MinderbenderMarker(event, unit, guid)
	if self:MobId(guid) == 146940 and mindbenderList[guid] then -- Primordial Mindbender
		SetRaidTarget(unit, mindbenderList[guid])
		mindbenderList[guid] = nil
	end
end

function mod:UnknowableTerror(args)
	self:StopBar(CL.count:format(args.spellName, unknowableTerrorCount))
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, unknowableTerrorCount))
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 8, CL.count:format(args.spellName, unknowableTerrorCount))
	unknowableTerrorCount = unknowableTerrorCount + 1
	self:Bar(args.spellId, 41, CL.count:format(args.spellName, unknowableTerrorCount))
end

-- Stage Three: His Unwavering Gaze
function mod:InsatiableTormentSuccess(args)
	self:StopBar(CL.count:format(args.spellName, insatiableTormentCount))
	insatiableTormentCount = insatiableTormentCount + 1
	self:Bar(args.spellId, 20.8, CL.count:format(args.spellName, insatiableTormentCount))
end

function mod:InsatiableTormentApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, insatiableTormentCount-1)) -- count-1 due to Success being before applied
	if self:Me(args.destGUID) then
		self:Say(args.spellId, 143924) -- Leech
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:GiftofNZothLunacy(args)
	self:StopBar(CL.count:format(args.spellName, giftCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, giftCount))
	self:PlaySound(args.spellId, "warning")
	giftCount = giftCount + 1
	self:Bar(args.spellId, 42.6, CL.count:format(args.spellName, giftCount))
end

-- Mythic
do
	local sayTimer = nil
	local debuffMarks = {
		[293663] = 3, -- Void, Diamond
		[293662] = 5, -- Ocean, Moon
		[293661] = 6, -- Storm, Square
	}
	local debuffNames = {
		[293663] = L.void,
		[293662] = L.ocean,
		[293661] = L.storm,
	}
	function mod:UnstableResonanceStart(args)
		self:Message2(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
		--self:Bar(args.spellId, 42.6)
	end

	function mod:UnstableResonanceDebuff(args) -- 293653 Unstable Resonance
		if self:Me(args.destGUID) then
			self:Message2(293653, "blue", CL.you_icon:format(debuffNames[args.spellId], debuffMarks[args.spellId]), args.spellId)
			self:Flash(293653, args.spellId)
			self:PlaySound(293653, "alarm")
			if self:GetOption("custom_on_repeating_resonance_say") then
				local sayText = "{rt"..debuffMarks[args.spellId].."}"
				SendChatMessage(sayText, "SAY")
				sayTimer = self:ScheduleRepeatingTimer(SendChatMessage, 1.5, sayText, "SAY")
			end
		end
	end

	function mod:UnstableResonanceDebuffRemoved(args) -- 293653 Unstable Resonance
		if self:Me(args.destGUID) then
			self:Message2(293653, "green", CL.removed:format(debuffNames[args.spellId]))
			self:PlaySound(293653, "info")
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end
	end
end

-- Undying Guardian
do
	local prev = 0
	function mod:Feed(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "purple")
			self:PlaySound(args.spellId, "alert")
		end
	end
end
