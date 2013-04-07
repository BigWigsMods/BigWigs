--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lei Shen", 930, 832)
if not mod then return end
mod:RegisterEnableMob(68397, 68398, 68696, 68697, 68698) -- Lei Shen, Static Shock Conduit, Diffusion Chain Conduit, Overcharge Conduit, Bouncing Bolt Conduit

--------------------------------------------------------------------------------
-- Locals
--

local SetRaidTarget = SetRaidTarget
local UnitExists = UnitExists
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGUID = UnitGUID
local GetTime = GetTime

local phase = 1
local proximityOpen = nil
local tooCloseForOvercharged = nil
local adds = {}
local markerTimer = nil
local marksUsed = {}
local activeProximityAbilities = {}
local thunderstruckCounter = 1
local whipCounter = 1
local stunDuration = {
	[119381] = 5, -- Leg Sweep
	[119072] = 3, -- Holy Wrath
	[30283] = 3, -- Shadowfury
}

local function isConduitAlive(mobId)
	for i=1, 5 do
		local boss = ("boss%d"):format(i)
		if mobId == mod:MobId(UnitGUID(boss)) then
			return boss
		end
	end
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_off_diffused_marker = "Diffused Lightning Marker"
	L.custom_off_diffused_marker_desc = "Mark the Diffused Lightning adds using all raid icons, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the adds is the fastest way to mark them.|r"

	L.stuns = "Stuns"
	L.stuns_desc = "Show bars for stun durations, for use with handling Ball Lightnings."

	L.aoe_grip = "AoE grip"
	L.aoe_grip_desc = "Warning for when a Death Knight uses Gorefiend's Grasp, for use with handling Ball Lightnings."

	L.last_inermission_ability = "Last intermission ability used!"
	L.safe_from_stun = "You're probably safe from Overcharge stuns"
	L.intermission = "Intermission"
	L.diffusion_add = "Diffusion add"
	L.shock = "Shock"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_off_diffused_marker",
		{139011, "FLASH"},
		{134912, "TANK", "FLASH"}, 135095, {135150, "FLASH"},
		{136478, "TANK"}, {136543, "PROXIMITY"}, {136850, "FLASH"},
		{136914, "TANK"}, 136889,
		{135695, "PROXIMITY", "SAY", "FLASH"}, {135991, "PROXIMITY"}, {136295, "SAY"}, 136366,
		"stages", {"aoe_grip", "SAY"}, "stuns", "berserk", "proximity", "bosskill",
	}, {
		["custom_off_diffused_marker"] = L.custom_off_diffused_marker,
		[139011] = "heroic",
		[134912] = -7178,
		[136478] = -7192,
		[136914] = -7209,
		[135695] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- Ball Lightning helpers
	self:Log("SPELL_CAST_SUCCESS", "Stuns", 119381, 119072, 30283) -- Leg Sweep, Holy Wrath, Shadowfury
	self:Log("SPELL_CAST_SUCCESS", "Grip", 108199) -- Gorefiend's Grasp
	-- Marking
	self:Log("SPELL_DAMAGE", "ChainLightning", 136018, 136019, 136021)
	self:Log("SPELL_SUMMON", "SummonSmallDiffusedLightning", 135992)

	-- Heroic
	self:Log("SPELL_AURA_APPLIED", "HelmOfCommand", 139011)
	-- Stage 3
	self:Log("SPELL_AURA_APPLIED_DOSE", "ElectricalShock", 136914)
	-- Stage 2
	self:Log("SPELL_CAST_START", "LightningWhip", 136850)
	self:Log("SPELL_PERIODIC_DAMAGE", "LightningWhipDamage", 136853)
	self:Log("SPELL_CAST_SUCCESS", "SummonBallLightning", 136543)
	self:Log("SPELL_CAST_START", "FusionSlash", 136478)
	-- Intermission
	self:Emote("IntermissionEnd", "137176")
	self:Log("SPELL_CAST_START", "IntermissionStart", 137045)
	-- Stage 1
	self:Log("SPELL_DAMAGE", "CrashingThunder", 135150)
	self:Log("SPELL_PERIODIC_DAMAGE", "CrashingThunder", 135153)
	self:Log("SPELL_CAST_START", "Thunderstruck", 135095)
	self:Log("SPELL_AURA_APPLIED", "Decapitate", 134912)
	-- Conduits: Overcharged -- Diffusion Chain -- Static Shock -- Bouncing Bolt
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Boss1Succeeded", "boss1")
	self:Log("SPELL_AURA_APPLIED", "Overcharged", 136295)
	self:Log("SPELL_CAST_SUCCESS", "DiffusionChain", 135991)
	self:Log("SPELL_DAMAGE", "DiffusionChainDamage", 135991) -- add spawn
	self:Log("SPELL_MISS", "DiffusionChainDamage", 135991) -- add spawn
	self:Log("SPELL_AURA_REMOVED", "DiffusionChainRemoved", 135681)
	self:Log("SPELL_AURA_APPLIED", "DiffusionChainApplied", 135681)
	self:Log("SPELL_AURA_REMOVED", "StaticShockRemoved", 135695)
	self:Log("SPELL_AURA_APPLIED", "StaticShockApplied", 135695)

	self:Death("Win", 68397) -- Lei Shen
	self:Death("AddDeaths", 68397, 69014, 69013, 69012) -- Greater Diffused Lightning, Diffused Lightning, Lesser Diffused Lightning
end

function mod:OnEngage()
	self:Berserk(720) -- XXX assumed
	proximityOpen = nil
	markerTimer = nil
	phase = 1
	tooCloseForOvercharged = nil
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	self:CDBar(134912, 40) -- Decapitate
	self:CDBar(135095, 25) -- Thunderstruck
	wipe(adds)
	wipe(marksUsed)
	wipe(activeProximityAbilities)
	thunderstruckCounter = 1
	whipCounter = 1

	if self.db.profile.custom_off_diffused_marker then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Grip(args)
	if phase < 2 then return end
	if self:Me(args.sourceGUID) then
		self:Say("aoe_grip", L["aoe_grip"]) -- to help with aoe stuns
	end
	self:TargetMessage("aoe_grip", args.sourceName, "Urgent", nil, L["aoe_grip"], 108199)
end

function mod:Stuns(args)
	if phase < 2 then return end
	local target = self:NewTargetList()
	target[1] = args.sourceName
	self:Bar("stuns", stunDuration[args.spellId], ("Stun: %s"):format(target[1]), args.spellId)
end

local function updateProximity()
	if not activeProximityAbilities[1] then
		if activeProximityAbilities[2] then
			mod:OpenProximity("proximity", 8)
		elseif activeProximityAbilities[3] then
			mod:OpenProximity("proximity", 6)
		elseif activeProximityAbilities[4] then
			mod:OpenProximity("proximity", 3)
		else
			mod:CloseProximity("proximity")
		end
	end
end

local function stopConduitAbilityBars()
	mod:StopBar(135695)
	mod:StopBar(136295)
	mod:StopBar(135991)
	mod:StopBar(136366)
end

do
	-- Add Marking
	local function getMark()
		for i=8,1,-1 do
			if not marksUsed[i] then
				return i
			end
		end
		return false
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		local GUID = UnitGUID("mouseover")
		if not GUID then return end
		local mobId = self:MobId(GUID)
		if mobId == 69014 or mobId == 69012 or mobId == 69013 then
			if adds[GUID] ~= "marked" then
				adds[GUID] = "marked"
				local mark = getMark()
				if mark then
					SetRaidTarget("mouseover", mark)
					marksUsed[mark] = GUID
				end
			end
		end
	end

	function mod:MarkCheck()
		for GUID in next, adds do
			if adds[GUID] ~= "marked" then
				local unitId = mod:GetUnitIdByGUID(GUID)
				local mark = getMark()
				if unitId and mark then
					adds[GUID] = "marked"
					SetRaidTarget(unitId, mark)
					marksUsed[mark] = GUID
				end
			end
		end
	end

	function mod:StopMarkCheck()
		self:CancelTimer(markerTimer)
		markerTimer = nil
	end

	function mod:ChainLightning(args)
		local mobId = self:MobId(args.sourceGUID)
		if mobId == 69014 or mobId == 69012 or mobId == 69013 then
			if not adds[args.sourceGUID] then
				adds[args.sourceGUID] = true
			end
		end
	end
	function mod:SummonSmallDiffusedLightning(args)
		local mobId = self:MobId(args.destGUID)
		if mobId == 69014 or mobId == 69012 or mobId == 69013 then
			if not adds[args.destGUID] then
				adds[args.destGUID] = true
			end
		end
		if self.db.profile.custom_off_diffused_marker and not markerTimer then
			markerTimer = self:ScheduleRepeatingTimer("MarkCheck", 0.2)
			self:ScheduleTimer("StopMarkCheck", 15) -- scan for 15 sec
		end
	end

	function mod:AddDeaths(args)
		for i=8,1,-1 do
			if marksUsed[i] == args.destGUID then
				marksUsed[i] = nil
				return
			end
		end
	end
end

----------------------------------------
-- Heroic
--

do
	local helmOfCommandList, scheduled = mod:NewTargetList(), nil
	local function warnHelmOfCommand(spellId)
		mod:TargetMessage(spellId, helmOfCommandList, "Urgent", "Alert")
		scheduled = nil
	end
	function mod:HelmOfCommand(args)
		helmOfCommandList[#helmOfCommandList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
		end
		self:Bar(args.spellId, 24)
		if not scheduled then
			scheduled = self:ScheduleTimer(warnHelmOfCommand, 0.1, args.spellId)
		end
	end
end


----------------------------------------
-- Stage 3
--

function mod:ElectricalShock(args)
	if args.amount % 5 == 0 then -- don't be too spammy, should be taunting when your debuff wears off (somewhere between 10 and 15)
		self:StackMessage(args.spellId, args.destName, args.amount, "Important", "Warning", L["shock"])
	end
end

----------------------------------------
-- Stage 2
--

do
	local function whipSoon(spellId, spellName)
		mod:Message(spellId, "Important", "Warning", CL["soon"]:format(("%s (%d)"):format(spellName, whipCounter)))
		mod:Flash(spellId)
	end
	function mod:LightningWhip(args)
		if phase == 3 then
			self:Message(args.spellId, "Urgent", "Alert", ("%s (%d)"):format(args.spellName, whipCounter))
			whipCounter = whipCounter + 1
			self:Bar(args.spellId, 30.3, ("%s (%d)"):format(args.spellName, whipCounter))
			self:ScheduleTimer(whipSoon, 27, args.spellId, args.spellName)
		else
			self:Message(args.spellId, "Urgent", "Alert")
			self:Bar(args.spellId, 45.1)
		end
	end
end

do
	local prev = 0
	function mod:LightningWhipDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(136850, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(136850)
		end
	end
end

do
	local prev = 0
	local function warnBallsSoon(spellId, spellName)
		mod:Message(spellId, "Attention", nil, CL["soon"]:format(spellName))
		activeProximityAbilities[3] = true
		updateProximity()
	end
	function mod:SummonBallLightning(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			activeProximityAbilities[3] = nil
			if self:Heroic() then
				activeProximityAbilities[4] = true
				updateProximity()
			end
			self:ScheduleTimer(warnBallsSoon, 41, args.spellId, args.spellName)-- reopen it when new balls are about to come
			self:Bar(args.spellId, 46)
			self:Message(args.spellId, "Attention")
		end
	end
end

function mod:FusionSlash(args)
	self:CDBar(args.spellId, 42)
	self:Message(args.spellId, "Important", "Warning")
end

----------------------------------------
-- Intermissions
--

local function warnDiffusionChainSoon()
	mod:Message(135991, "Important", "Warning", CL["soon"]:format(mod:SpellName(135991)))
	activeProximityAbilities[2] = true
	updateProximity()
end

function mod:IntermissionEnd(msg)
	self:CancelAllTimers()
	self:StopBar(139011) -- Helm of Command -- heroic
	self:StopBar(136295) -- Overcharged
	self:StopBar(135695) -- Static Shock
	self:StopBar(136366) -- Bouncing Bolt
	self:StopBar(135991) -- Diffusion Chain
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1") -- just to be efficient

	-- stage 2
	activeProximityAbilities[2] = true
	updateProximity()
	if phase == 2 then
		self:CDBar(136478, 46) -- Fusion Slash
		self:Bar(136850, 29) -- Lightning Whip
		if self:Heroic() then -- XXX these are probably not time based either and need to add abilities for all conduits
			if msg:find("135681") then -- Diffusion Adds
				self:CDBar(135991, 14)
			elseif msg:find("135682") then -- Overcharged
				self:CDBar(136295, 14)
			elseif msg:find("135683") then -- Bouncing Bolt
				self:CDBar(136366, 14)
			elseif msg:find("135680") then -- Static Shock
				self:CDBar(135695, 14)
			end
		end
	elseif phase == 3 then -- XXX should start bars for already disabled conduits too
		self:CDBar(135095, 36, ("%s (%d)"):format(self:SpellName(135095), thunderstruckCounter)) -- Thunderstruck
		self:Bar(136850, 22, ("%s (%d)"):format(self:SpellName(136850), whipCounter)) -- Lightning Whip
		self:CDBar(136889, 20) -- Violent Gale Winds
		if self:Heroic() then
			if msg:find("135681") then -- Diffusion Adds
				self:CDBar(135991, 28)
			elseif msg:find("135682") then -- Overcharged
				self:CDBar(136295, 28)
			elseif msg:find("135683") then -- Bouncing Bolt
				self:CDBar(136366, 30)
			elseif msg:find("135680") then -- Static Shock
				self:CDBar(135695, 28)
			end
		end
	end
	self:Bar(136543, (phase == 2) and 14 or 41) -- Summon Ball Lightning

	self:Message("stages", "Neutral", "Info", CL["phase"]:format(phase), false)
end

function mod:IntermissionStart(args)
	stopConduitAbilityBars()
	self:CancelAllTimers()
	self:StopBar(135150) -- Crashing Thunder
	self:StopBar(134912) -- Decapitate
	self:StopBar(135095) -- Thunderstruck
	self:StopBar(136850) -- Lightning Whip
	self:StopBar(136543) -- Summon Ball Lightning
	self:StopBar(136478) -- Furious Slash
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1") -- just to be efficient
	activeProximityAbilities[4] = nil
	local diff = self:Difficulty()
	if diff == 3 or diff == 5 or diff == 7 then -- 10 mans and assume LFR too
		if isConduitAlive(68398) then self:CDBar(135695, 18) end -- Static Shock
		if isConduitAlive(68697) then self:CDBar(136295, 7) end -- Overcharged
		if isConduitAlive(68698) then self:CDBar(136366, 20) end -- Bouncing Bolt
		if isConduitAlive(68696) then
			self:CDBar(135991, 7)
			self:ScheduleTimer(warnDiffusionChainSoon, 2)
		end
	else -- 25 man
		if isConduitAlive(68398) then self:CDBar(135695, 19) end -- Static Shock
		if isConduitAlive(68697) then self:CDBar(136295, 7) end -- Overcharged
		if isConduitAlive(68698) then self:CDBar(136366, 14) end -- Bouncing Bolt
		if isConduitAlive(68696) then
			self:CDBar(135991, 6)
			self:ScheduleTimer(warnDiffusionChainSoon, 1)
		end
	end
	if self:Heroic() then
		self:Bar(139011, 14) -- Helm of Command
	end
	self:Bar("stages", 45, L["intermission"], args.spellId)
	self:Message("stages", "Neutral", "Info", L["intermission"], false)
	self:DelayedMessage("stages", 40, "Positive", L["last_inermission_ability"])
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if phase == 1 and hp < 68 then
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(L["intermission"]), false)
		phase = 2
	elseif phase == 2 and hp < 33 then
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(L["intermission"]), false)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		phase = 3
	end
end

----------------------------------------
-- Stage 1
--

do
	local prev = 0
	function mod:CrashingThunder(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:Thunderstruck(args)
	if phase == 3 then
		self:Message(args.spellId, "Attention", "Alert", ("%s (%d)"):format(args.spellName, thunderstruckCounter))
		thunderstruckCounter = thunderstruckCounter + 1
		self:Bar(args.spellId, 30, ("%s (%d)"):format(args.spellName, thunderstruckCounter))
	else
		self:CDBar(args.spellId, 46)
		self:Message(args.spellId, "Attention", "Alert")
	end
end

function mod:Decapitate(args)
	self:CDBar(args.spellId, 50)
	self:TargetMessage(args.spellId, args.destName, "Personal", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 5, args.destName) -- usually another ~2s before damage due to travel time
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

----------------------------------------
-- Conduits
--

function mod:Boss1Succeeded(unitId, spellName, _, _, spellId)
	if spellId == 136395 then -- Bouncing Bolt
		if not UnitExists("boss1") then -- poor mans intermission check
			self:Bar(136366, 24)
		else
			if phase == 1 or not self:Heroic() then stopConduitAbilityBars() end
			self:Bar(136366, 40)
		end
		self:Message(136366, "Important", "Long")
	elseif spellId == 136869 then -- Violent Gale Winds
		self:Message(136889, "Important", "Long")
		self:Bar(136889, 30)
	elseif spellId == 135143 then -- Crashung Thunder
		self:Message(135150, "Attention")
		self:Bar(135150, 30)
	elseif spellId == 139006 or spellId == 139007 or spellId == 139008 or spellId == 139009 then -- active quadrant
		if phase ~= 3 then return end
		self:Message("stages", "Attention", nil, spellName, 136913) -- probably shouldn't be linked to stages, but dunno anything better -- overwhelming power icon
	end
end

do
	local overchargedList, scheduled = mod:NewTargetList(), nil
	local function warnOvercharged(spellId)
		if not UnitExists("boss1") then -- poor mans intermission check
			mod:Bar(spellId, 23)
		else
			if phase == 1 or not mod:Heroic() then stopConduitAbilityBars() end
			mod:Bar(spellId, 40)
		end
		mod:TargetMessage(spellId, overchargedList, "Urgent", "Alarm", nil, nil, true)
		scheduled = nil
		if not tooCloseForOvercharged then
			mod:Message(spellId, "Positive", nil, L["safe_from_stun"])
		end
		tooCloseForOvercharged = nil
	end
	function mod:Overcharged(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		if self:Range(args.destName) < 50 then -- XXX verify range ( should be more than 40 )
			tooCloseForOvercharged = true
		end
		overchargedList[#overchargedList+1] = args.destName
		self:Bar(args.spellId, 6, ("%s: %s"):format(args.spellName, overchargedList[#overchargedList]))
		if not scheduled then
			scheduled = self:ScheduleTimer(warnOvercharged, 0.1, args.spellId)
		end
	end
end

do
	local diffusionList, timer = mod:NewTargetList(), nil
	function mod:DiffusionChainDamage(args) -- XXX consider syncing, or figure out why sometimes the list is empty
		for i, player in next, diffusionList do -- can hit the same person multiple times apparently
			if player:find(args.destName, nil, true) then
				return
			end
		end
		diffusionList[#diffusionList+1] = args.destName
	end
	local function warnDiffusionAdds()
		if #diffusionList > 0 then
			mod:TargetMessage(135991, diffusionList, "Important", "Warning", L["diffusion_add"], nil, true)
		else -- no one in range
			mod:Message(135991, "Important", "Warning")
		end
		if not UnitExists("boss1") then -- poor mans intermission check
			mod:Bar(135991, 25)
			mod:ScheduleTimer(warnDiffusionChainSoon, 20)
		else
			if phase == 1 or not mod:Heroic() then stopConduitAbilityBars() end
			mod:Bar(135991, 40)
			timer = mod:ScheduleTimer(warnDiffusionChainSoon, 30)
		end
		activeProximityAbilities[2] = nil
		updateProximity()
	end
	function mod:DiffusionChain(args)
		wipe(diffusionList)
		self:ScheduleTimer(warnDiffusionAdds, 0.2)
		if self.db.profile.custom_off_diffused_marker and not markerTimer then
			markerTimer = self:ScheduleRepeatingTimer("MarkCheck", 0.2)
			self:ScheduleTimer("StopMarkCheck", 15) -- scan for 15 sec
		end
	end
	function mod:DiffusionChainRemoved() -- on conduit/lei shen
		self:CancelTimer(timer)
		timer = nil
		activeProximityAbilities[2] = nil
		updateProximity()
	end
end

function mod:DiffusionChainApplied(args)
	local mobId = self:MobId(args.destGUID)
	if mobId == 68696 then -- Diffusion Chain Conduit
		warnDiffusionChainSoon()
	end
end

function mod:StaticShockRemoved(args)
	if proximityOpen == "Diffusion Chain" or proximityOpen == "Ball Lightning" then return end
	self:CloseProximity(args.spellId)
	activeProximityAbilities[1] = nil -- static shock
	updateProximity()
end

do
	local staticShockList, scheduled, coloredNames = {}, nil, mod:NewTargetList()
	local function warnStaticShock(spellId)
		local intermission
		if not UnitExists("boss1") then -- poor mans intermission check
			mod:Bar(spellId, 20, spellId)
			intermission = true
		else
			if phase == 1 or not mod:Heroic() then stopConduitAbilityBars() end
			mod:Bar(135695, 40)
		end

		local closest, distance = nil, 200
		for i, player in next, staticShockList do
			local playerDistance = mod:Range(player)
			if playerDistance < distance then
				distance = playerDistance
				closest = player
			end
		end
		mod:TargetMessage(spellId, coloredNames, "Positive", "Info", nil, nil, true) -- green because everyone should be friendly and hug the person with it
		scheduled = nil
		wipe(staticShockList)
		if intermission and distance < 40 then -- ignore other quadrants during the intermission
			mod:CloseProximity("proximity")
			activeProximityAbilities[1] = true -- static shock
			if UnitIsUnit("player", closest) then
				mod:OpenProximity(spellId, 8) -- XXX not exactly the best choice, but this way at least you see people around you
			else
				mod:OpenProximity(spellId, 8, closest, true) -- open to closest static shock target
			end
		end
	end
	local timeLeft, timer = 8, nil
	local function staticShockSayCountdown()
		timeLeft = timeLeft - 1
		if timeLeft < 6 then
			mod:Say(135695, timeLeft, true)
			mod:PlaySound(135695, ("BigWigs: %d"):format(timeLeft)) -- XXX sort this
			if timeLeft < 2 then
				mod:CancelTimer(timer)
			end
		end
	end
	function mod:StaticShockApplied(args)
		if self:Me(args.destGUID) then
			timeLeft = 8
			self:Flash(args.spellId)
			self:Say(args.spellId)
			timer = self:ScheduleRepeatingTimer(staticShockSayCountdown, 1)
		end
		staticShockList[#staticShockList+1] = args.destName
		coloredNames[#coloredNames+1] = args.destName
		self:Bar(args.spellId, 8, ("%s: %s"):format(args.spellName, coloredNames[#coloredNames]))
		if not scheduled then
			scheduled = self:ScheduleTimer(warnStaticShock, 0.1, args.spellId)
		end
	end
end


