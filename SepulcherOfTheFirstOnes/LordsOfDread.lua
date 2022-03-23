--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lords of Dread", 2481, 2457)
if not mod then return end
mod:RegisterEnableMob(181398, 181399) -- Mal'Ganis, Kin'tessa
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

local fearTimers = {27.2, 53.5, 29.0, 12.0, 29.2, 49.9, 29.1, 22.1, 58.5, 29.2, 12.8, 29.1, 49.8, 29.2, 23.7} -- 4, 8, 11, 15 are timers from Among Us _End
local fearCasts = 0
local empCarrion = false
local bitesOnMe = false
local bitesSayTimer = nil
local nextAmongUs = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.unto_darkness = "AoE Phase"-- Unto Darkness
	L.cloud_of_carrion = "Carrion" -- Cloud of Carrion
	L.empowered_cloud_of_carrion = "Big Carrion" -- Empowered Cloud of Carrion
	L.manifest_shadows = "Adds" -- Manifest Shadows
	L.leeching_claws = "Frontal (M)" -- Leeching Claws
	L.infiltration_of_dread = "Among Us" -- Infiltration of Dread
	L.infiltration_removed = "Imposters found in %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Fears" -- Fearful Trepidation
	L.slumber_cloud = "Clouds" -- Slumber Cloud
	L.anguishing_strike = "Frontal (K)" -- Anguishing Strike

	L.custom_on_repeating_biting_wound = "Repeating Biting Wound"
	L.custom_on_repeating_biting_wound_desc = "Repeating Biting Wound say messages with icons {rt7} to make it more visible."
end

--------------------------------------------------------------------------------
-- Initialization
--

local fearfulTrepidationMarker = mod:AddMarkerOption(false, "player", 8, 361745, 1, 2) -- Fearful Trepidation
function mod:GetOptions()
	return {
		360374, -- Rampaging Swarm
		"berserk",
		-- Mal'Ganis
		360319, -- Unto Darkness
		360012, -- Cloud of Carrion
		"custom_on_repeating_biting_wound",
		361913, -- Manifest Shadows
		--361923, -- Ravenous Hunger
		361934, -- Incomplete Form
		{359960, "TANK"}, -- Leeching Claws
		359963, -- Opened Veins
		-- Kin'tessa
		360717, -- Infiltration of Dread
		{360146, "SAY", "SAY_COUNTDOWN"}, -- Fearful Trepidation
		fearfulTrepidationMarker,
		360229, -- Slumber Cloud
		{360284, "TANK"}, -- Anguishing Strike
	},{
		[360374] = "general",
		[360319] = -23927, -- Mal'Ganis
		[360417] = -23929, -- Kin'tessa
	},{
		[360319] = L.unto_darkness, -- Unto Darkness
		[366574] = L.cloud_of_carrion, -- Cloud of Carrion
		[361913] = L.manifest_shadows, -- Manifest Shadows
		[359960] = L.leeching_claws, -- Leeching Claws
		[360417] = L.infiltration_of_dread, -- Infiltration of Dread
		[360146] = L.fearful_trepidation, -- Fearful Trepidation
		[360229] = L.slumber_cloud, -- Slumber Cloud
		[360284] = L.anguishing_strike, -- Anguishing Strike
	}
end

function mod:OnBossEnable()
	-- Mal'Ganis
	self:Log("SPELL_CAST_START", "SwarmOfDecay", 360300)
	self:Log("SPELL_CAST_START", "CloudOfCarrion", 360006)
	self:Log("SPELL_AURA_APPLIED", "CloudOfCarrionApplied", 360012)
	self:Log("SPELL_AURA_REMOVED", "CloudOfCarrionRemoved", 360012)
	self:Log("SPELL_AURA_APPLIED", "BitingWoundsApplied", 364985)
	self:Log("SPELL_AURA_REMOVED", "BitingWoundsRemoved", 364985)
	self:Log("SPELL_CAST_START", "ManifestShadows", 361913)
	--self:Log("SPELL_CAST_START", "RavenousHunger", 361923)
	self:Log("SPELL_AURA_REMOVED", "IncompleteFormRemoved", 361934)
	self:Log("SPELL_CAST_START", "LeechingClaws", 359960)
	self:Log("SPELL_AURA_APPLIED", "OpenedVeinsApplied", 359963)
	self:Log("SPELL_CAST_SUCCESS", "RampagingSwarm", 360374)

	-- Kin'tessa
	self:Log("SPELL_CAST_SUCCESS", "InfiltrationOfDread", 360717)
	self:Log("SPELL_AURA_REMOVED", "InfiltrationOfDreadOver", 360418) -- Paranoia
	self:Log("SPELL_CAST_SUCCESS", "FearfulTrepidation", 360145)
	self:Log("SPELL_AURA_APPLIED", "FearfulTrepidationApplied", 360146)
	self:Log("SPELL_AURA_REMOVED", "FearfulTrepidationRemoved", 360146)
	self:Log("SPELL_CAST_START", "SlumberCloud", 360229)
	self:Log("SPELL_CAST_START", "AnguishingStrike", 360284)
	self:Log("SPELL_AURA_APPLIED", "AnguishingStrikeApplied", 360287)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AnguishingStrikeApplied", 360287)

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
	fearCasts = 0
	empCarrion = false
	bitesOnMe = false

	self:Bar(360012, self:Mythic() and 7 or 6, CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount)) -- Cloud of Carrion
	self:Bar(361913, 13, CL.count:format(L.manifest_shadows, manifestShadowsCount)) -- Manifest Shadows
	self:Bar(359960, 15.5, L.leeching_claws) -- Leeching Claws
	self:Bar(360319, 51, CL.count:format(L.unto_darkness, untoDarknessCount)) -- Unto Darkness

	self:Bar(360284, 8.5, L.anguishing_strike) -- Anguishing Strike
	self:Bar(360229, 13, CL.count:format(L.slumber_cloud, slumberCloudCount)) -- Slumber Cloud
	self:Bar(360146, 25.1, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount)) -- Fearful Trepidation
	self:Bar(360717, 124, CL.count:format(L.infiltration_of_dread, infiltrationOfDreadCount)) -- Infiltration of Dread
	nextAmongUs = GetTime() + 124

	if self:Mythic() then
		self:Berserk(540)
	else
		self:Berserk(600)
	end
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
function mod:SwarmOfDecay()
	self:StopBar(CL.count:format(L.unto_darkness, untoDarknessCount))
	self:Message(360319, "yellow", CL.count:format(L.unto_darkness, untoDarknessCount))
	self:PlaySound(360319, "alert")
	untoDarknessCount = untoDarknessCount + 1
	if self:Mythic() then
		empCarrion = true
		self:Bar(360012, 30.5, CL.count:format(L.empowered_cloud_of_carrion, cloudOfCarrionCount))
		self:Bar(361913, 33.6, CL.count:format(L.manifest_shadows, manifestShadowsCount))

		self:StopBar(CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
		local cd = fearCasts == 2 and 40 or 28
		self:Bar(360146, cd, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:CloudOfCarrion(args)
		local text = empCarrion and L.empowered_cloud_of_carrion or L.cloud_of_carrion
		self:StopBar(CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount))
		self:StopBar(CL.count:format(L.empowered_cloud_of_carrion, cloudOfCarrionCount))
		self:Message(360012, "orange", CL.casting:format(CL.count:format(text, cloudOfCarrionCount)))
		self:PlaySound(360012, "alert")
		playerList = {}
		prev = args.time
		cloudOfCarrionCount = cloudOfCarrionCount + 1
		if self:Mythic() then
			if cloudOfCarrionCount % 2 == 0 then
				self:Bar(360012, 21.9, CL.count:format(text, cloudOfCarrionCount))
			end
		else
			if cloudOfCarrionCount % 4 ~= 1 then -- Skip 5, 9, 13...
				self:Bar(360012, cloudOfCarrionCount % 2 == 1 and 51.5 or 21.8, CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount))
			end
		end
	end

	function mod:CloudOfCarrionApplied(args)
		if args.time-prev < 3 then
			playerList[#playerList+1] = args.destName
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "warning")
			end
			self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount-1))
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

function mod:BitingWoundsApplied(args)
	if self:Me(args.destGUID) then
		if self:GetOption("custom_on_repeating_biting_wound") then
			self:Say(false, "{rt7}", true)
			bitesSayTimer = self:ScheduleRepeatingTimer("Say", 1.5, false, "{rt7}", true)
		end
		bitesOnMe = true
	end
end

function mod:BitingWoundsRemoved(args)
	if self:Me(args.destGUID) then
		if bitesSayTimer then
			self:CancelTimer(bitesSayTimer)
			bitesSayTimer = nil
		end
		bitesOnMe = false
	end
end

function mod:ManifestShadows(args)
	self:StopBar(CL.count:format(L.manifest_shadows, manifestShadowsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.manifest_shadows, manifestShadowsCount))
	self:PlaySound(args.spellId, "alert")
	manifestShadowsCount = manifestShadowsCount + 1
	if not self:Mythic() and manifestShadowsCount % 2 == 0 then -- Only start a bar for all even casts
		self:Bar(args.spellId, 72.5, CL.count:format(L.manifest_shadows, manifestShadowsCount))
	end
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
			self:TargetMessage(args.spellId, "yellow", self:UnitName(unit), CL.casting:format(L.leeching_claws))
			break
		elseif i == #tankList then
			self:Message(args.spellId, "yellow", CL.casting:format(L.leeching_claws))
		end
	end
	self:PlaySound(args.spellId, "alarm")
	-- XXX Fix timers around specials
	self:CDBar(args.spellId, 17, L.leeching_claws)
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
do
	local amongUsStart = 0
	function mod:InfiltrationOfDread(args)
		if self:MobId(args.sourceGUID) == 181399 then -- Kin'tessa
			self:StopBar(CL.count:format(L.infiltration_of_dread, infiltrationOfDreadCount))
			self:Message(args.spellId, "yellow", CL.count:format(L.infiltration_of_dread, infiltrationOfDreadCount))
			self:PlaySound(args.spellId, "alert")
			infiltrationOfDreadCount = infiltrationOfDreadCount + 1

			self:StopBar(CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
			self:StopBar(CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount))
			self:StopBar(CL.count:format(L.empowered_cloud_of_carrion, cloudOfCarrionCount))

			self:CDBar(359960, 5, L.leeching_claws) -- Leeching Claws
			self:Bar(360012, 7.5, CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount)) -- Cloud of Carrion
			self:Bar(361913, self:Mythic() and 9.5 or 10, CL.count:format(L.manifest_shadows, manifestShadowsCount)) -- Manifest Shadows
			self:Bar(360319, 51, CL.count:format(L.unto_darkness, untoDarknessCount)) -- Unto Darkness

			self:CDBar(360284, 8, L.anguishing_strike) -- Anguishing Strike
			self:Bar(360717, 126, CL.count:format(L.infiltration_of_dread, infiltrationOfDreadCount)) -- Infiltration of Dread
			nextAmongUs = GetTime() + 126
			if self:Mythic() then
				local cd = 10.7 -- 10.7 on first Among Us
				if infiltrationOfDreadCount == 3 then -- either short or long
					cd = fearCasts == 3 and 5 or 22
				elseif infiltrationOfDreadCount == 4 then -- last one, short or long
					cd = fearCasts == 3 and 10.5 or 17
				end
				self:CDBar(360146, cd, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount)) -- Fearful Trepidation
				self:Bar(360229, cd == 5 and 7 or 5, CL.count:format(L.slumber_cloud, slumberCloudCount)) -- Slumber Cloud
			else
				self:CDBar(360146, fearTimers[fearfulTrepidationCount], CL.count:format(L.fearful_trepidation, fearfulTrepidationCount)) -- Fearful Trepidation
				self:Bar(360229, 5, CL.count:format(L.slumber_cloud, slumberCloudCount)) -- Slumber Cloud
			end
			fearCasts = 0
			empCarrion = false
			amongUsStart = args.time

			-- Pauze to show timers once you finish Among Us
			self:PauseBar(359960, L.leeching_claws) -- Leeching Claws
			self:PauseBar(360012, CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount)) -- Cloud of Carrion
			self:PauseBar(361913, CL.count:format(L.manifest_shadows, manifestShadowsCount)) -- Manifest Shadows
			self:PauseBar(360319, CL.count:format(L.unto_darkness, untoDarknessCount)) -- Unto Darkness

			self:PauseBar(360229, CL.count:format(L.slumber_cloud, slumberCloudCount)) -- Slumber Cloud
			self:PauseBar(360284, L.anguishing_strike) -- Anguishing Strike
			self:PauseBar(360717, CL.count:format(L.infiltration_of_dread, infiltrationOfDreadCount)) -- Infiltration of Dread
			self:PauseBar(360146, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount)) -- Fearful Trepidation
		end
	end

	do
		local prev = 0
		function mod:InfiltrationOfDreadOver(args)
			if args.time - 10 > prev then
				prev = args.time
				self:Message(360717, "green", L.infiltration_removed:format(args.time-amongUsStart), "inv_eyeofnzothpet")
				self:PlaySound(360717, "long")

				-- Resume bars!
				self:ResumeBar(359960, L.leeching_claws) -- Leeching Claws
				self:ResumeBar(360012, CL.count:format(L.cloud_of_carrion, cloudOfCarrionCount)) -- Cloud of Carrion
				self:ResumeBar(361913, CL.count:format(L.manifest_shadows, manifestShadowsCount)) -- Manifest Shadows
				self:ResumeBar(360319, CL.count:format(L.unto_darkness, untoDarknessCount)) -- Unto Darkness

				self:ResumeBar(360229, CL.count:format(L.slumber_cloud, slumberCloudCount)) -- Slumber Cloud
				self:ResumeBar(360284, L.anguishing_strike) -- Anguishing Strike
				self:ResumeBar(360717, CL.count:format(L.infiltration_of_dread, infiltrationOfDreadCount)) -- Infiltration of Dread
				self:ResumeBar(360146, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount)) -- Fearful Trepidation
			end
		end
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:FearfulTrepidation(args)
		playerList = {}
		self:StopBar(CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
		self:Message(360146, "yellow", CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
		self:PlaySound(360146, "alert")
		fearfulTrepidationCount = fearfulTrepidationCount + 1
		fearCasts = fearCasts + 1
		if self:Mythic() then
			if fearfulTrepidationCount ~= 2 or nextAmongUs > GetTime() + 15 then
				self:Bar(360146, 29.1, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
			end
		else
			if fearfulTrepidationCount ~= 4 and fearfulTrepidationCount ~= 8 and fearfulTrepidationCount ~= 11 and fearfulTrepidationCount ~= 15 then
				self:Bar(360146, fearfulTrepidationCount % 2 == 0 and 50 or 30, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount))
			end
		end
	end

	function mod:FearfulTrepidationApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID)then
			local sayIcon = bitesSayTimer and 7 or nil
			local sayText = bitesSayTimer and CL.count_rticon:format(L.fearful_trepidation, icon, sayIcon) or nil
			self:Say(args.spellId, sayText)
			self:SayCountdown(args.spellId, 8, sayIcon, 5)
			if bitesSayTimer then
				self:CancelTimer(bitesSayTimer)
				bitesSayTimer = nil
			end
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(L.fearful_trepidation, fearfulTrepidationCount-1))
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
	self:StopBar(CL.count:format(L.slumber_cloud, slumberCloudCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.slumber_cloud, slumberCloudCount))
	self:PlaySound(args.spellId, "alert")
	slumberCloudCount = slumberCloudCount + 1
	if self:Mythic() then
		local cd = slumberCloudCount % 3 == 2 and 33 or slumberCloudCount % 3 == 0 and 53 or 0
		self:Bar(args.spellId, cd, CL.count:format(L.slumber_cloud, slumberCloudCount))
	else
		if slumberCloudCount % 2 == 0 then -- Only start a bar for all even casts
			local cd = slumberCloudCount == 2 and 69.3 or slumberCloudCount == 4 and 73 or slumberCloudCount == 6 and 75 or slumberCloudCount == 8 and 73
			self:Bar(args.spellId, 72, CL.count:format(L.slumber_cloud, slumberCloudCount))
		end
	end
end

function mod:AnguishingStrike(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	self:Message(args.spellId, "purple", CL.casting:format(L.anguishing_strike))
	if self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "alert")
	end
	-- Stop around specials?
	self:Bar(args.spellId, 9.7, L.anguishing_strike)
end

function mod:AnguishingStrikeApplied(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	local amount = args.amount or 1
	self:NewStackMessage(360284, "purple", args.destName, amount, 3)
	if amount > 2 and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(360284, "alarm")
	end
end
