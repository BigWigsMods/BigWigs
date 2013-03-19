--[[
TODO:
	make sure proximity meters are currently shown
]]--


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lei Shen", 930, 832)
if not mod then return end
mod:RegisterEnableMob(68397, 68398, 68696, 68697, 68698) -- Lei Shen, Static Shock Conduit, Diffusion Chain Conduit, Overcharge Conduit, Bouncing Bolt Conduit

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local proximityOpen = nil

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
	L.conduit_abilities = "Conduit Abilities"
	L.conduit_abilities_desc = "Approximate cooldown bars for the conduit specific abilities."
	L.conduit_abilities_icon = 139271
	L.conduit_abilities_message = "Next conduit ability"

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
		{134912, "TANK", "FLASH"}, 135095, {135150, "FLASH"},
		{136478, "TANK"}, {136543, "PROXIMITY"}, 136850,
		{136914, "TANK"}, 136889,
		"conduit_abilities", {135695, "PROXIMITY", "SAY"}, {135991, "PROXIMITY"}, {136295, "SAY"}, 136366,
		"stages", "berserk", "bosskill",
	}, {
		[134912] = -7178,
		[136478] = -7192,
		[136914] = -7209,
		["conduit_abilities"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- Stage 3
	self:Log("SPELL_AURA_APPLIED_DOSE", "ElectricalShock", 136914)
	-- Stage 2
	self:Log("SPELL_CAST_START", "LightningWhip", 136850)
	self:Log("SPELL_CAST_SUCCESS", "SummonBallLightning", 136543)
	self:Log("SPELL_CAST_START", "FusionSlash", 136478)
	-- Intermission
	self:Emote("OverloadedCircuits", "137176")
	self:Log("SPELL_CAST_START", "SuperchargeConduits", 137045)
	-- Stage 1
	self:Log("SPELL_DAMAGE", "CrashingThunder", 135150)
	self:Log("SPELL_CAST_START", "Thunderstruck", 135095)
	self:Log("SPELL_AURA_APPLIED", "Decapitate", 134912)
	-- Conduits: Overcharged -- Diffusion Chain -- Static Shock -- Bouncing Bolt
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Boss1Succeeded", "boss1")
	self:Log("SPELL_AURA_APPLIED", "Overcharged", 136295)
	self:Log("SPELL_CAST_SUCCESS", "DiffusionChain", 135991)
	self:Log("SPELL_DAMAGE", "DiffusionChainDamage", 135991) -- damage = add spawn
	self:Log("SPELL_AURA_REMOVED", "DiffusionChainRemoved", 135681)
	self:Log("SPELL_AURA_APPLIED", "DiffusionChainApplied", 135681)
	self:Log("SPELL_AURA_REMOVED", "StaticShockRemoved", 135695)
	self:Log("SPELL_AURA_APPLIED", "StaticShockApplied", 135695)

	self:Death("Win", 68397)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX assumed
	proximityOpen = nil
	phase = 1
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	self:CDBar(134912, 40) -- Decapitate
	self:CDBar(135095, 25) -- Thunderstruck
	self:CDBar("conduit_abilities", 15, L["conduit_abilities_message"], L.conduit_abilities_icon) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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

function mod:LightningWhip(args)
	self:Bar(args.spellId, 46)
	self:Message(args.spellId, "Urgent", "Alert")
end

do
	local prev = 0
	local function warnBallsSoon(spellId, spellName)
		mod:Message(spellId, "Attention", nil, CL["soon"]:format(spellName)) -- should maybe shorten this
		if proximityOpen ~= "Diffusion Chain" then -- Diffusion Chain is 8 yards, so don't change to 6 yards if that is open already
			mod:OpenProximity(spellId, 6)
		end
	end
	function mod:SummonBallLightning(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			if not proximityOpen then -- Only close the proximity display if it wasn't open before
				self:CloseProximity(args.spellId)
			end
			self:ScheduleTimer(warnBallsSoon, 41, args.spellId, args.spellName)-- reopen it when new balls are about to come
			self:Bar(args.spellId, 46)
			self:Message(args.spellId, "Attention")
		end
	end
end

function mod:FusionSlash(args)
	self:CDBar(args.spellId, 52)
	self:Message(args.spellId, "Important", "Warning")
end

----------------------------------------
-- Intermissions
--

local function warnDiffusionChainSoon()
	mod:Message(135991, "Important", "Long", CL["soon"]:format(mod:SpellName(135991)))
	mod:OpenProximity(135991, 8)
	proximityOpen = "Diffusion Chain"
end

function mod:OverloadedCircuits()
	self:CancelAllTimers()
	self:StopBar(136295) -- Overcharged
	self:StopBar(135695) -- Static Shock
	self:StopBar(136366) -- Bouncing Bolt
	self:StopBar(135991) -- Diffusion Chain
	self:CloseProximity(135991)
	proximityOpen = nil
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1") -- just to be efficient

	-- stage 2
	if phase == 2 then
		self:OpenProximity(136543, 6) -- Summon Ball Lightning
		self:CDBar(136478, 46) -- Fusion Slash
	elseif phase == 3 then
		self:CDBar(135095, 28) -- Thunderstruck
		self:CDBar(136889, 20) -- Violent Gale Winds
	end
	self:CDBar(136850, (phase == 2) and 30 or 15) -- Lightning Whip
	self:CDBar(136543, 19) -- Summon Ball Lightning

	self:Message("stages", "Neutral", "Info", CL["phase"]:format(phase), false)
end

function mod:SuperchargeConduits(args)
	self:CancelAllTimers()
	self:StopBar(134912) -- Decapitate
	self:StopBar(135095) -- Thunderstruck
	self:StopBar(136850) -- Lightning Whip
	self:StopBar(136543) -- Summon Ball Lightning
	self:StopBar(136478) -- Furious Slash
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1") -- just to be efficient

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
			self:Message(135991, "Important", nil, CL["soon"]:format(self:SpellName(135991)))
			self:OpenProximity(135991, 8)
			proximityOpen = "Diffusion Chain"
		end
	end

	self:Bar("stages", 45, L["intermission"], args.spellId)
	self:Message("stages", "Neutral", "Info", L["intermission"], false)
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
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:Thunderstruck(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 46)
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
			self:CDBar("conduit_abilities", 40, L["conduit_abilities_message"], L.conduit_abilities_icon) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		end
		self:Message(136366, "Important", "Long")
	elseif spellId == 136869 then -- Violent Gale Winds
		self:Message(136889, "Important", "Long")
		self:Bar(136889, 30)
	end
end

do
	local overchargedList, scheduled = mod:NewTargetList(), nil
	local function warnOvercharged(spellId)
		if not UnitExists("boss1") then -- poor mans intermission check
			mod:Bar(spellId, 23)
		else
			mod:CDBar("conduit_abilities", 40, L["conduit_abilities_message"], L.conduit_abilities_icon) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		end
		mod:TargetMessage(spellId, overchargedList, "Urgent", "Alarm")
		scheduled = nil
	end
	function mod:Overcharged(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		overchargedList[#overchargedList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnOvercharged, 0.1, args.spellId)
		end
	end
end

do
	local diffusionList = mod:NewTargetList()
	function mod:DiffusionChainDamage(args)
		for i, player in next, diffusionList do -- can hit the same person multiple times apparently
			if player:find(args.destName, nil, true) then
				return
			end
		end
		diffusionList[#diffusionList+1] = args.destName
	end

	local function warnDiffusionAdds()
		if #diffusionList > 0 then
			mod:TargetMessage(135991, diffusionList, "Important", mod:Tank() and "Info", L["diffusion_add"], nil, true)
		else -- no one in range
			mod:Message(135991, "Important")
		end
		mod:CloseProximity(135991)
		proximityOpen = nil
	end

	function mod:DiffusionChain(args)
		if not UnitExists("boss1") then -- poor mans intermission check
			self:Bar(135991, 25)
			self:ScheduleTimer(warnDiffusionChainSoon, 20)
		else
			self:CDBar("conduit_abilities", 40, L["conduit_abilities_message"], L.conduit_abilities_icon) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		end

		self:ScheduleTimer(warnDiffusionAdds, 0.2)
	end
end

function mod:DiffusionChainRemoved()
	self:CloseProximity(135991)
	proximityOpen = nil
end

function mod:DiffusionChainApplied(args)
	if self:MobId(args.destGUID) == 68696 then -- Diffusion Chain Conduit
		self:Message(135991, "Important", "Long", CL["incoming"]:format(self:SpellName(135991)))
	end
end

function mod:StaticShockRemoved(args)
	self:CloseProximity(args.spellId)
	proximityOpen = nil
end

do
	local staticShockList, scheduled, coloredNames = {}, nil, mod:NewTargetList()
	local function warnStaticShock(spellId)
		local intermission
		if not UnitExists("boss1") then -- poor mans intermission check
			mod:Bar("conduit_abilities", 20, spellId)
			intermission = true
		else
			mod:CDBar("conduit_abilities", 40, L["conduit_abilities_message"], L.conduit_abilities_icon) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		end

		local closest, distance = nil, 200
		for i, player in next, staticShockList do
			coloredNames[i] = player
			local playerDistance = mod:Range(player)
			if playerDistance < distance then
				distance = playerDistance
				closest = player
			end
		end
		mod:TargetMessage(spellId, coloredNames, "Positive", "Alarm") -- green because everyone should be friendly and hug the person with it
		if not intermission or distance < 25 then -- ignore other quadrants during the intermission
			mod:OpenProximity(spellId, 8, closest, true) -- open to closest static shock target
			proximityOpen = "Static Shock"
		end
		scheduled = nil
		wipe(staticShockList)
	end
	function mod:StaticShockApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		staticShockList[#staticShockList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnStaticShock, 0.1, args.spellId)
		end
	end
end

