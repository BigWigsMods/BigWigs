--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Guardian of the First Ones", 2450, 2446)
if not mod then return end
--mod:RegisterEnableMob(164406)
mod:SetEncounterID(2436)
--mod:SetRespawnTime(30)
--mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local shieldOnYou = false
local tankList = {}
local meltdownCount = 1
local disintergrationCount = 1
local sentryCount = 1
local threatNeutralizationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.sentry = mod:SpellName(298200) -- Form Sentry (Sentry)
end

--------------------------------------------------------------------------------
-- Initialization
--

local threatNeutralizationMarker = mod:AddMarkerOption(false, "player", 1, 350502, 1, 2, 3) -- Threat Neutralization
function mod:GetOptions()
	return {
		-- Energy Cores
		352385, -- Energizing Link
		350455, -- Unstable Energy
		352394, -- Radiant Energy
		352589, -- Meltdown
		-- The Guardian
		352538, -- Purging Protocol
		{350735, "TANK"}, -- Elimination Pattern
		{350732, "TANK"}, -- Shatter
		{350734, "TANK"}, -- Obliterate
		352833, -- Disintegration
		352660, -- Form Sentry
		347359, -- Suppression Field
		{350502, "SAY", "SAY_COUNTDOWN"}, -- Threat Neutralization
		threatNeutralizationMarker,
	},{
		[352385] = self:SpellName(-23254), -- Energy Cores
		[352538] = self:SpellName(-23273), -- The Guardian
	},{
		[352385] = CL.link, -- Energizing Link (Link)
		[350455] = CL.no:format(CL.shield), -- Unstable Energy (No Shield)
		[352394] = CL.shield, -- Radiant Energy (Shield)
		[352833] = CL.laser, -- Disintegration (Laser)
		[352660] = L.sentry, -- Form Sentry (Sentry)
	}
end

function mod:OnBossEnable()
	-- Energy Cores
	self:Log("SPELL_AURA_APPLIED", "EnergizingLinkApplied", 352385)
	self:Log("SPELL_PERIODIC_DAMAGE", "UnstableEnergyDamage", 350455)
	self:Log("SPELL_PERIODIC_MISSED", "UnstableEnergyDamage", 350455)
	self:Log("SPELL_AURA_APPLIED", "RadiantEnergyApplied", 352394)
	self:Log("SPELL_AURA_REMOVED", "RadiantEnergyRemoved", 352394)
	self:Log("SPELL_CAST_START", "Meltdown", 352589)

	-- The Guardian
	self:Log("SPELL_CAST_START", "PurgingProtocol", 352538)
	self:Log("SPELL_CAST_SUCCESS", "EliminationPattern", 350735)
	self:Log("SPELL_CAST_START", "Shatter", 350732)
	self:Log("SPELL_AURA_APPLIED", "ShatterApplied", 350732)
	self:Log("SPELL_CAST_START", "Obliterate", 350734)
	self:Log("SPELL_CAST_START", "Disintegration", 352833)
	self:Log("SPELL_CAST_START", "FormSentry", 352660)
	self:Log("SPELL_AURA_APPLIED", "SuppressionField", 347359)
	self:Log("SPELL_PERIODIC_DAMAGE", "SuppressionField", 347359)
	self:Log("SPELL_PERIODIC_MISSED", "SuppressionField", 347359)
	self:Log("SPELL_CAST_SUCCESS", "ThreatNeutralization", 350502)
	self:Log("SPELL_AURA_APPLIED", "ThreatNeutralizationApplied", 350496)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	shieldOnYou = false
	meltdownCount = 1
	disintergrationCount = 1
	sentryCount = 1
	threatNeutralizationCount = 1

	-- self:Bar(350735, 20) -- Elimination Pattern
	-- self:Bar(352833, 20, CL.count:format(CL.laser, disintergrationCount)) -- Disintegration
	-- self:Bar(352660, 20, CL.count:format(L.sentry, sentryCount)) -- Form Sentry
	-- self:Bar(350502, 20, CL.count:format(self:SpellName(350502), threatNeutralizationCount)) -- Threat Neutralization
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Energy Cores
function mod:EnergizingLinkApplied(args)
	self:Message(args.spellId, "cyan", CL.active:format(CL.link))
	self:PlaySound(args.spellId, "info")
end

do
	local prev = 0
	function mod:UnstableEnergyDamage(args)
		if shieldOnYou and self:Me(args.destGUID) then -- warn when taking damage without shield
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "warning")
				self:PersonalMessage(args.spellId, CL.no:format(CL.shield))
			end
		end
	end
end

function mod:RadiantEnergyApplied(args)
	shieldOnYou = true
	self:Message(args.spellId, "green", CL.you:format(CL.shield))
	self:PlaySound(args.spellId, "info")
end

function mod:RadiantEnergyRemoved(args)
	shieldOnYou = false
	self:Message(args.spellId, "red", CL.removed:format(CL.shield))
	self:PlaySound(args.spellId, "info")
end

function mod:Meltdown(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, meltdownCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, meltdownCount))
	meltdownCount = meltdownCount + 1
end

-- The Guardian
function mod:PurgingProtocol(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "warning")
end

function mod:EliminationPattern(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 17)
end

function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

function mod:Shatter(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(args.spellId, "purple", self:UnitName(unit), CL.casting:format(args.spellName))
			break
		elseif i == #tankList then
			self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		end
	end
	self:PlaySound(args.spellId, "warning")
end

function mod:ShatterApplied(args)
	self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
	local bossUnit = self:GetBossId(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- Not taunted? Play again.
	end
end

function mod:Obliterate(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(args.spellId, "purple", self:UnitName(unit), CL.casting:format(args.spellName))
			break
		elseif i == #tankList then
			self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		end
	end
	self:PlaySound(args.spellId, "alarm")
end

function mod:Disintegration(args)
	self:Message(args.spellId, "red", CL.count:format(CL.laser, disintergrationCount))
	self:PlaySound(args.spellId, "long")
	disintergrationCount = disintergrationCount + 1
	--self:Bar(args.spellId, 17, CL.count:format(CL.laser, disintergrationCount))
end

function mod:FormSentry(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.sentry, sentryCount)))
	self:PlaySound(args.spellId, "alert")
	sentryCount = sentryCount + 1
	--self:Bar(args.spellId, 17, CL.count:format(L.sentry, sentryCount))
end

do
	local prev = 0
	function mod:SuppressionField(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:ThreatNeutralization(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, threatNeutralizationCount))
	self:PlaySound(args.spellId, "alarm")
	threatNeutralizationCount = threatNeutralizationCount + 1
	--self:Bar(args.spellId, 17, CL.count:format(ars.spellName, threatNeutralizationCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:ThreatNeutralizationApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList)
		self:CustomIcon(threatNeutralizationMarker, args.destName, count)
	end
end
