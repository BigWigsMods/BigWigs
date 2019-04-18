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
local mindbenderCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_off_mindbender_marker = "Primordial Mindbender Marker"
	L.custom_off_mindbender_marker_desc = "Mark Primordial Mindbender with {rt1}{rt2}{rt3}."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		284722, -- Umbral Shell
		284804, -- Custody of the Deep
		284583, -- Storm of Annihilation
		{284851, "TANK"}, -- Touch of the End
		285185, -- Oblivion Tear
		285416, -- Void Crash
		285376, -- Eyes of N'Zoth
		285345, -- Maddening Eyes of N'Zoth
		285367, -- Piercing Gaze of N'Zoth
		285453, -- Gift of N'Zoth: Obscurity
		285820, -- Call Undying Guardian
		285638, -- Gift of N'Zoth: Hysteria
		-19118, -- Primordial Mindbender
		285427, -- Consume Essence
		"custom_off_mindbender_marker",
		285562, -- Unknowable Terror
		{285652, "SAY", "ICON"}, -- Insatiable Torment
		285685, -- Gift of N'Zoth: Lunacy
		{285307, "TANK"}, -- Feed
	},{
		["stages"] = "general",
		[284722] = -19055, -- Relics of Power
		[284851] = -19104, -- Stage One: His All-Seeing Eyes
		[285638] = -19105, -- Stage Two: His Dutiful Servants
		[285652] = -19106, -- Stage Three: His Unwavering Gaze
		[285307] = "mythic",
	}
end

function mod:OnBossEnable()
	-- Relics of Power XXX Need cooldowns of the spells
	self:Log("SPELL_AURA_APPLIED", "UmbralShellApplied", 284722)
	self:Log("SPELL_AURA_REMOVED", "UmbralShellRemoved", 284722)
	self:Log("SPELL_CAST_START", "AbyssalCollapseStart", 284809)
	self:Log("SPELL_AURA_APPLIED", "CustodyoftheDeepApplied", 284804)
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
	self:Log("SPELL_AURA_REMOVED", "InsatiableTormentRemoved", 285652)
	self:Log("SPELL_CAST_START", "GiftofNZothLunacy", 285685)

	-- Mythic
	-- Undying Guardian
	self:Log("SPELL_CAST_START", "Feed", 285307)
end

function mod:OnEngage()
	stage = 1
	nextStageWarning = 73
	mindbenderList = {}
	mobCollector = {}
	mindbenderCount = 0

	self:Bar(285416, 7.1) -- Void Crash
	self:Bar(285185, 12.2) -- Oblivion Tear
	self:Bar(285453, 20.7) -- Gift of N'Zoth: Obscurity
	self:Bar(284851, 26.8) -- Touch of the End
	self:Bar(285820, 30.1) -- Call Undying Guardian
	self:Bar(285376, 42.5) -- Eyes of N'Zoth
	self:Bar(285345, 76) -- Maddening Eyes of N'Zoth

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	if self:GetOption("custom_off_mindbender_marker") then
		self:RegisterTargetEvents("MinderbenderMarker")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Intermission at 70% & 45%
		self:Message2("stages", "green", CL.soon:format(CL.intermission), false)
		nextStageWarning = nextStageWarning - 25
		if nextStageWarning < 30 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:UmbralShellApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	self:PlaySound(args.spellId, "info", nil, args.destName)
end

function mod:UmbralShellRemoved(args)
	self:Message2(args.spellId, "cyan", CL.removed_from:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "info", nil, args.destName)
end


function mod:AbyssalCollapseStart(args) -- XXX Way to detect when the cast is over after shield breaks?
	self:Message2(284804, "cyan") -- Custody of the Deep
	self:PlaySound(284804, "long") -- Custody of the Deep
	self:CastBar(284804, 20) -- Custody of the Deep
end

function mod:CustodyoftheDeepApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(args.spellId, "green")
		self:PlaySound(args.spellId, "info")
	end
end

function mod:StormofAnnihilationApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	self:PlaySound(args.spellId, "long", nil, args.destName)
	self:CastBar(args.spellId, 15) -- Custody of the Deep
end

-- Stage One: His All-Seeing Eyes
-- Uu'nat, Harbinger of the Void
function mod:TouchoftheEndSuccess(args)
	self:Bar(args.spellId, 25.5)
end

function mod:TouchoftheEndApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:OblivionTear(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, stage == 3 and 12.2 or 17)
end

function mod:VoidCrash(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 31.6)
end

function mod:EyesofNZoth(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, stage == 3 and 47 or 33)
end

function mod:MaddeningEyesofNZoth(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 4.5)
	--self:Bar(args.spellId, 33)
end

function mod:GiftofNZothObscurity(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 42.5)
end

function mod:CallUndyingGuardian(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, stage == 3 and 31.5 or 51.4)
end


function mod:VoidShieldApplied(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "green", CL.intermission, false)
	self:Bar("stages", 15.8, CL.intermission, args.spellId)

	-- Stage 1 Bars
	self:StopBar(285416) -- Void Crash
	self:StopBar(285185) -- Oblivion Tear
	self:StopBar(285453) -- Gift of N'Zoth: Obscurity
	self:StopBar(284851) -- Touch of the End
	self:StopBar(285820) -- Call Undying Guardian
	self:StopBar(285376) -- Eyes of N'Zoth
	self:StopBar(285345) -- Maddening Eyes of N'Zoth

	-- Additional Stage 2 Bars
	self:StopBar(285562) -- Unknowable Terror XXX
	self:StopBar(-19118) -- Primordial Mindbender
	self:StopBar(285638) -- Gift of N'Zoth: Hysteria
end

function mod:VoidShieldRemoved(args)
	stage = stage + 1
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	if stage == 2 then
		self:Bar(285185, 13.3) -- Oblivion Tear
		self:Bar(285562, 18.2) -- Unknowable Terror
		self:Bar(284851, 21.9) -- Touch of the End
		self:Bar(285820, 31.6) -- Call Undying Guardian
		self:Bar(-19118, 34.0, -19118, 285427) -- Primordial Mindbender, Consume Essence icon
		self:Bar(285638, 40.1) -- Gift of N'Zoth: Hysteria
	else -- stage 3
		self:Bar(285652, 12.1) -- Insatiable Torment
		self:Bar(285185, 13.3) -- Oblivion Tear
		self:Bar(284851, 21.8) -- Touch of the End
		self:Bar(285820, 26.7) -- Call Undying Guardian
		self:Bar(285685, 40.0) -- Gift of N'Zoth: Lunacy
		self:Bar(285376, 45.7) -- Eyes of N'Zoth
	end
end

-- Stage Two: His Dutiful Servants
function mod:GiftofNZothHysteria(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 42.6)
end

do
	local prev = 0
	function mod:ConsumeEssence(args)
		local t = args.time
		if t-prev > 58 then -- Throttle this 58s as the cooldown is 60s
			prev = t
			mindbenderList = {} -- Reset list for marking
			self:CDBar(-19118, 60.0, -19118, 285427) -- Primordial Mindbender, Consume Essence icon
		end
		if not mobCollector[args.sourceGUID] then
			mindbenderCount = mindbenderCount + 1
			mobCollector[args.sourceGUID] = true
			mindbenderList[args.sourceGUID] = (mindbenderCount % 3) + 1 -- 1, 2, 3
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
	end
end

function mod:UnknowableTerror(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 8)
	self:Bar(args.spellId, 41)
end

-- Stage Three: His Unwavering Gaze
function mod:InsatiableTormentSuccess(args)
	self:Bar(args.spellId, 29.2)
end

function mod:InsatiableTormentApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:InsatiableTormentRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:GiftofNZothLunacy(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 42.6)
end

-- Mythic
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
