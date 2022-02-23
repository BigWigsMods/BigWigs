--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lords of Dread", 2481, 2457)
if not mod then return end
mod:RegisterEnableMob(181398, 181334) -- Mal'Ganis, Kin'tessa
mod:SetEncounterID(2543)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local untoDarknessCount = 1
local cloudOfCarrionCount = 1
local manifestShadowsCount = 1
local infiltrationOfDreadCount = 1
local fearfulTrepidationCount = 1
local slumberCloudCount = 1
local tankList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

-- MARK 183138 XXX
local fearfulTrepidationMarker = mod:AddMarkerOption(false, "player", 8, 361745, 1, 2) -- Fearful Trepidation
function mod:GetOptions()
	return {
		360374, -- Rampaging Swarm
		-- Mal'Ganis
		360319, -- Unto Darkness
		366574, -- Cloud of Carrion
		361913, -- Manifest Shadows
		--361923, -- Ravenous Hunger
		362020, -- Incomplete Form
		{359960, "TANK"}, -- Leeching Claws
		359963, -- Opened Veins
		-- Kin'tessa
		360417, -- Infiltration of Dread
		{360428, "SAY"}, -- Moment of Clarity
		{360146, "SAY", "SAY_COUNTDOWN"}, -- Fearful Trepidation
		fearfulTrepidationMarker,
		360229, -- Slumber Cloud
		{360284, "TANK"}, -- Anguishing Strike
	},{
		[360374] = "general",
		[360319] = -23927, -- Mal'Ganis
		[360417] = -23929, -- Kin'tessa
	}
end

function mod:OnBossEnable()
	-- Mal'Ganis
	self:Log("SPELL_CAST_SUCCESS", "UntoDarkness", 360319)
	self:Log("SPELL_CAST_SUCCESS", "CloudOfCarrion", 366573)
	self:Log("SPELL_AURA_APPLIED", "CloudOfCarrionApplied", 366574)
	self:Log("SPELL_AURA_REMOVED", "CloudOfCarrionRemoved", 366574)
	self:Log("SPELL_CAST_START", "ManifestShadows", 361913)
	--self:Log("SPELL_CAST_START", "RavenousHunger", 361923)
	self:Log("SPELL_AURA_REMOVED", "IncompleteFormRemoved", 362020)
	self:Log("SPELL_CAST_START", "LeechingClaws", 359960)
	self:Log("SPELL_AURA_APPLIED", "OpenedVeinsApplied", 359963)
	self:Log("SPELL_CAST_SUCCESS", "RampagingSwarm", 360374)

	-- Kin'tessa
	self:Log("SPELL_CAST_SUCCESS", "InfiltrationOfDread", 360417)
	self:Log("SPELL_CAST_SUCCESS", "MomentOfClarity", 360428) -- No debuff, perhaps a target?
	self:Log("SPELL_AURA_APPLIED", "FearfulTrepidationApplied", 360146)
	self:Log("SPELL_AURA_REMOVED", "FearfulTrepidationRemoved", 360146)
	self:Log("SPELL_CAST_START", "SlumberCloud", 360229)
	self:Log("SPELL_CAST_START", "AnguishingStrike", 360284)
	self:Log("SPELL_AURA_APPLIED", "AnguishingStrikeApplied", 366632)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AnguishingStrikeApplied", 366632)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	untoDarknessCount = 1
	cloudOfCarrionCount = 1
	manifestShadowsCount = 1
	infiltrationOfDreadCount = 1
	fearfulTrepidationCount = 1
	slumberCloudCount = 1

	--self:Bar(360319, 30) -- Unto Darkness
	--self:Bar(366573, 30) -- Cloud of Carrion
	--self:Bar(361913, 30) -- Manifest Shadows
	--self:Bar(359960, 30) -- Leeching Claws

	--self:Bar(360417, 30) -- Infiltration of Dread
	--self:Bar(360146, 30) -- Fearful Trepidation
	--self:Bar(360229, 30) -- Fearful Trepidation
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

function mod:RampagingSwarm(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

-- Mal'Ganis
function mod:UntoDarkness(args)
	self:StopBar(CL.count:format(args.spellName, untoDarknessCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, untoDarknessCount))
	self:PlaySound(args.spellId, "alert")
	untoDarknessCount = untoDarknessCount + 1
	--self:Bar(args.spellId, 100, CL.count:format(args.spellName, untoDarknessCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:CloudOfCarrion(args)
		self:StopBar(CL.count:format(args.spellName, cloudOfCarrionCount))
		playerList = {}
		prev = args.time
		cloudOfCarrionCount = cloudOfCarrionCount + 1
		--self:Bar(366574, 100, CL.count:format(args.spellName, cloudOfCarrionCount))
	end

	function mod:CloudOfCarrionApplied(args)
		if args.time-prev < 1 then
			playerList[#playerList+1] = args.destName
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "warning")
			end
			self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, cloudOfCarrionCount-1))
		else -- Personal warnings only
			if self:Me(args.destGUID) then
				self:PersonalMessage(args.spellId)
				self:PlaySound(args.spellId, "warning")
			end
		end
	end

	function mod:CloudOfCarrionRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:ManifestShadows(args)
	self:StopBar(CL.count:format(args.spellName, manifestShadowsCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, manifestShadowsCount))
	self:PlaySound(args.spellId, "alert")
	manifestShadowsCount = manifestShadowsCount + 1
	--self:Bar(args.spellId, 100, CL.count:format(args.spellName, manifestShadowsCount))
end

-- function mod:RavenousHunger(args)
-- 	local canDo, ready = self:Interrupter(args.sourceGUID)
-- 	if canDo then
-- 		self:Message(args.spellId, "yellow")
-- 		if ready then
-- 			self:PlaySound(args.spellId, "alert")
-- 		end
-- 	end
-- end

function mod:IncompleteFormRemoved(args)
	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:LeechingClaws(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(args.spellId, "yellow", self:UnitName(unit), CL.casting:format(args.spellName))
			break
		elseif i == #tankList then
			self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
		end
	end
	self:PlaySound(args.spellId, "alarm")
	--self:CDBar(args.spellId, 17)
end

function mod:OpenedVeinsApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		self:TargetMessage(args.spellId, "purple", args.destName)
		self:PlaySound(args.spellId, "warning") -- You should swap, prolly.
	elseif self:Me(args.destGUID) then -- Not a tank
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

-- Kin'tessa
function mod:InfiltrationOfDread(args)
	self:StopBar(CL.count:format(args.spellName, infiltrationOfDreadCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, infiltrationOfDreadCount))
	self:PlaySound(args.spellId, "alert")
	infiltrationOfDreadCount = infiltrationOfDreadCount + 1
	--self:Bar(args.spellId, 100, CL.count:format(args.spellName, infiltrationOfDreadCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:MomentOfClarity(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID)then
			self:Yell(args.spellId)
		end
		self:NewTargetsMessage(args.spellId, "green", playerList)
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:FearfulTrepidationApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			self:StopBar(CL.count:format(args.spellName, fearfulTrepidationCount))
			self:Message(args.spellId, "yellow", CL.count:format(args.spellName, fearfulTrepidationCount))
			self:PlaySound(args.spellId, "alert")
			fearfulTrepidationCount = fearfulTrepidationCount + 1
			--self:Bar(args.spellId, 100, CL.count:format(args.spellName, fearfulTrepidationCount))
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID)then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, icon, icon))
			self:SayCountdown(args.spellId, 8, icon)
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(args.spellName, fearfulTrepidationCount-1))
		self:CustomIcon(fearfulTrepidationMarker, args.destName, icon)
	end

	function mod:FearfulTrepidationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(fearfulTrepidationMarker, args.destName)
	end
end

function mod:SlumberCloud(args)
	self:StopBar(CL.count:format(args.spellName, slumberCloudCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, slumberCloudCount))
	self:PlaySound(args.spellId, "alert")
	slumberCloudCount = slumberCloudCount + 1
	--self:Bar(args.spellId, 100, CL.count:format(args.spellName, slumberCloudCount))
end

function mod:AnguishingStrike(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	if self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "alert")
	end
	--self:Bar(args.spellId, 12)
end

function mod:AnguishingStrikeApplied(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	local amount = args.amount or 1
	self:NewStackMessage(360284, "purple", args.destName, amount, 3)
	if amount > 2 and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(360284, "alarm")
	end
end
