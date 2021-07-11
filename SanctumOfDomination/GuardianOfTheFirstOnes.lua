--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Guardian of the First Ones", 2450, 2446)
if not mod then return end
mod:RegisterEnableMob(175731) -- Guardian of the First Ones
mod:SetEncounterID(2436)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local shieldOnYou = false
local tankList = {}
local meltdownCount = 1
local disintergrationCount = 1
local purgeCount = 1
local threatNeutralizationCount = 1
local obliterateCount = 1
local sunderCount = 1

local normalTimers = {
	[350496] = {5, 11.8, 24.5, 14.6, 11.8}, -- Threat Neutralization (Bombs)
	[352833] = {18, 32.7}, -- Disintegration
}
local heroicTimers = {
	[350496] = {0, 12, 12, 26, 12}, -- Threat Neutralization (Bombs)
	[352833] = {7, 39.5}, -- Disintegration
}
-- local mythicTimers = {
-- 	[350496] = {8.2, 12.3, 18.3, 23.2, 18.4, 23.3, 23.1, 18.4, 18.2, 23.2, 24.4, 17.1, 17.1, 24.4, 23.2, 17.1, 17.3, 23.1}, -- Threat Neutralization
-- 	[352833] = {15.7, 56.2, 33.4, 49.8, 33.1, 44.9, 31.8, 31.7, 25.9, 31.6}, -- Disintegration
-- }

local timers = mod:Heroic() and heroicTimers or normalTimers

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "The Guardian can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."

	L.sentry = mod:SpellName(298200) -- Form Sentry (Sentry)
end

--------------------------------------------------------------------------------
-- Initialization
--

local threatNeutralizationMarker = mod:AddMarkerOption(false, "player", 1, 350496, 1, 2, 3) -- Threat Neutralization
function mod:GetOptions()
	return {
		"custom_on_stop_timers",
		-- Energy Cores
		352385, -- Energizing Link
		350455, -- Unstable Energy
		352394, -- Radiant Energy
		{352589, "EMPHASIZE"}, -- Meltdown
		-- The Guardian
		352538, -- Purging Protocol
		350735, -- Elimination Pattern
		355352, -- Obliterate
		350732, -- Sunder
		352833, -- Disintegration
		352660, -- Form Sentry
		347359, -- Suppression Field
		{350496, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Threat Neutralization
		threatNeutralizationMarker,
	},{
		[352385] = self:SpellName(-23254), -- Energy Cores
		[352538] = self.displayName, -- The Guardian
	},{
		[352385] = CL.link, -- Energizing Link (Link)
		[350455] = CL.no:format(CL.shield), -- Unstable Energy (No Shield)
		[352394] = CL.shield, -- Radiant Energy (Shield)
		[352833] = CL.laser, -- Disintegration (Laser)
		[352660] = L.sentry, -- Form Sentry (Sentry)
		[350496] = CL.bombs, -- Threat Neutralization (Bombs)
	}
end

function mod:OnBossEnable()
	-- Energy Cores
	self:Log("SPELL_AURA_APPLIED", "EnergizingLinkApplied", 352385)
	self:Log("SPELL_AURA_REMOVED", "EnergizingLinkRemoved", 352385)
	self:Log("SPELL_ENERGIZE", "EnergizeCore", 356093)
	self:Log("SPELL_PERIODIC_DAMAGE", "UnstableEnergyDamage", 350455)
	self:Log("SPELL_PERIODIC_MISSED", "UnstableEnergyDamage", 350455)
	self:Log("SPELL_AURA_APPLIED", "RadiantEnergyApplied", 352394)
	self:Log("SPELL_AURA_REMOVED", "RadiantEnergyRemoved", 352394)
	self:Log("SPELL_CAST_START", "Meltdown", 352589)

	-- The Guardian
	self:Log("SPELL_CAST_START", "PurgingProtocol", 352538)
	self:Log("SPELL_CAST_SUCCESS", "PurgingProtocolSuccess", 352538)

	self:Log("SPELL_CAST_START", "Obliterate", 355352)
	self:Log("SPELL_CAST_START", "Sunder", 350732)
	self:Log("SPELL_AURA_APPLIED", "SunderApplied", 350732)
	self:Log("SPELL_CAST_START", "Disintegration", 352833)
	self:Log("SPELL_CAST_START", "FormSentry", 352660)
	self:Log("SPELL_AURA_APPLIED", "SuppressionField", 347359)
	self:Log("SPELL_PERIODIC_DAMAGE", "SuppressionField", 347359)
	self:Log("SPELL_PERIODIC_MISSED", "SuppressionField", 347359)
	self:Log("SPELL_CAST_START", "ThreatNeutralization", 356090)
	self:Log("SPELL_AURA_APPLIED", "ThreatNeutralizationApplied", 350496)
	self:Log("SPELL_AURA_REMOVED", "ThreatNeutralizationRemoved", 350496)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	shieldOnYou = false
	meltdownCount = 1
	disintergrationCount = 1
	purgeCount = 1
	threatNeutralizationCount = 1
	obliterateCount = 1
	sunderCount = 1

	self:CDBar(352660, 4, L.sentry) -- Form Sentry
	self:CDBar(352833, 15.8, CL.count:format(CL.laser, disintergrationCount)) -- Disintegration
	self:CDBar(350735, 25) -- Elimination Pattern
	self:CDBar(350496, 38, CL.count:format(CL.bombs, threatNeutralizationCount)) -- Threat Neutralization
	local purgeTimer = UnitPower("boss1")
	self:Bar(352538, purgeTimer, CL.count:format(self:SpellName(352538), purgeCount)) -- Purging Protocol
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local abilitysToPause = {
		[350496] = true, -- Threat Neutralization
		[352538] = true, -- Purging Protocol
		[352660] = true, -- Form Sentry
		[352833] = true, -- Disintegration
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

-- Energy Cores
do
	local linkedCore = nil
	local scheduled = nil
	function mod:SetLinkTimer()
		local coreUnit = self:GetBossId(linkedCore)
		if coreUnit then
			local linkTimer = ceil(UnitPower(coreUnit) / 5) - 1 -- 5 energy/s (first tick immediately)
			self:CDBar(352589, linkTimer, CL.count:format(self:SpellName(352589), meltdownCount)) -- Meltdown
		end
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
	end

	function mod:EnergizingLinkApplied(args)
		if self:MobId(args.destGUID) == 175731 then -- On the boss
			self:StopBar(CL.count:format(self:SpellName(352538), purgeCount)) -- Purging Protocol
			self:Message(args.spellId, "cyan", CL.onboss:format(CL.link))
			self:PlaySound(args.spellId, "info")
			linkedCore = args.sourceGUID
			self:SetLinkTimer()
			self:CDBar(352660, self:Easy() and 11.7 or 19, L.sentry) -- Form Sentry
			self:CDBar(352833, timers[352833][disintergrationCount], CL.count:format(CL.laser, disintergrationCount)) -- Disintegration 5.5-8s
			self:CDBar(350735, 28.5) -- Elimination Pattern
			--self:CDBar(350496, 0, CL.count:format(CL.bombs, threatNeutralizationCount)) -- Threat Neutralization
		end
	end

	function mod:EnergizingLinkRemoved(args)
		if self:MobId(args.destGUID) == 175731 then -- On the boss
			linkedCore = nil
		end
	end

	function mod:EnergizeCore(args)
		if not scheduled then
			scheduled = self:ScheduleTimer("SetLinkTimer", 0.1)
		end
	end
end

do
	local prev = 0
	function mod:UnstableEnergyDamage(args)
		if not shieldOnYou and self:Me(args.destGUID) then -- warn when taking damage without shield
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
	if self:Me(args.destGUID) then
		shieldOnYou = true
		self:Message(args.spellId, "green", CL.you:format(CL.shield))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:RadiantEnergyRemoved(args)
	if self:Me(args.destGUID) then
		shieldOnYou = false
		self:Message(args.spellId, "red", CL.removed:format(CL.shield))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:Meltdown(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, meltdownCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, meltdownCount))
	meltdownCount = meltdownCount + 1

	purgeCount = 1
	local bossUnit = self:GetBossId(175731)
	if bossUnit then
		local purgeTimer = UnitPower(bossUnit) -- 1 energy/s
		self:CDBar(352538, purgeTimer, CL.count:format(self:SpellName(352538), purgeCount)) -- Purging Protocol
	end
end

-- The Guardian
function mod:PurgingProtocol(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, purgeCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, purgeCount))

	-- Ressetting here as he might cast the first spell before the link event is fired
	-- 150.423	Guardian of the First Ones begins casting Threat Neutralization
	-- 150.652	Guardian of the First Ones is afflicted by Energizing Link from Energy Core 2
	disintergrationCount = 1
	threatNeutralizationCount = 1
	obliterateCount = 1
	sunderCount = 1
end

function mod:PurgingProtocolSuccess(args) -- He can cancel his own cast with the tank combo, increment counter here instead.
	purgeCount = purgeCount + 1
end

function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

function mod:Obliterate(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, obliterateCount))
	self:PlaySound(args.spellId, "warning")
	obliterateCount = obliterateCount + 1
end

function mod:Sunder(args)
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
	self:PlaySound(args.spellId, self:Tank() and "warning" or "alarm")
	sunderCount = sunderCount + 1
	if sunderCount == 2 then
		self:Bar(args.spellId, 8, CL.count:format(args.spellName, sunderCount))
	end
end

function mod:SunderApplied(args)
	if self:Tank() or self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, "purple", args.destName)
		local bossUnit = self:GetBossId(args.sourceGUID)
		if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "warning") -- Not taunted? Play again.
		end
	end
end

function mod:Disintegration(args)
	self:Message(args.spellId, "red", CL.count:format(CL.laser, disintergrationCount))
	self:PlaySound(args.spellId, "alert")
	self:StopBar(CL.count:format(CL.laser, disintergrationCount))
	disintergrationCount = disintergrationCount + 1
	if meltdownCount > 1 then  -- Only happens once before first Link
		self:CDBar(args.spellId, timers[args.spellId][disintergrationCount], CL.count:format(CL.laser, disintergrationCount)) -- 25~30
	end
end

function mod:FormSentry(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(L.sentry))
	self:PlaySound(args.spellId, "long")
	self:StopBar(L.sentry)
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

do
	local playerList = {}
	function mod:ThreatNeutralization()
		playerList = {}
		self:Message(350496, "orange", CL.casting:format(CL.count:format(CL.bombs, threatNeutralizationCount)))
		self:StopBar(CL.count:format(CL.bombs, threatNeutralizationCount))
		threatNeutralizationCount = threatNeutralizationCount + 1
		if meltdownCount > 1 or threatNeutralizationCount == 2 then  -- Only happens 2x before first Link
			self:CDBar(350496, timers[350496][threatNeutralizationCount], CL.count:format(CL.bombs, threatNeutralizationCount))
		end
	end

	function mod:ThreatNeutralizationApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 4)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(CL.bomb, threatNeutralizationCount-1))
		self:CustomIcon(threatNeutralizationMarker, args.destName, count)
	end
end

function mod:ThreatNeutralizationRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:CustomIcon(threatNeutralizationMarker, args.destName)
end
