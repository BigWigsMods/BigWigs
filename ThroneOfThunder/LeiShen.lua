--[[
TODO:
	keep looking for events during intermission in case blizzaard fixes them
	make sure proximity meters are currently shown
	figure out if it is possible to keep track of how many bounces are left ( currently not according to 10 N ptr logs )
	figure out the most accurate way of displaying conduit cooldowns
]]--

if select(4, GetBuildInfo()) < 50200 then return end
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
local staticShockList = {}
local proximityOpen = false

local function isConduitAlive(mobId)
	local boss = "boss%d"
	for i=1, 5 do
		if mobId == mod:GetCID(boss:format(i)) then
			return boss:format(i)
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.conduit_abilities = "Conduit Abilities"
	L.conduit_abilities_desc = "Approximate cooldown bars for the conduit specific abilities"
	L.conduit_abilities_icon = 139271
	L.conduit_ability_meassage = "Next conduit ability"
	L.intermission = "Intermission"
	L.overchargerd_message = "Stunning AoE pulse"
	L.static_shock_message = "Splitting AoE damege"
	L.diffusion_add_message = "Diffusion adds"
	L.diffusion_chain_message = "Diffusion adds soon - SPREAD!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{134916, "TANK", "FLASH"}, 135095, {135150, "FLASH"},
		{136478, "TANK"}, {136543, "PROXIMITY"}, 136850,
		136889,
		"stages", {135695, "PROXIMITY", "ICON"}, {"ej:7239", "PROXIMITY"}, 136295, "ej:7242", "conduit_abilities",
		"berserk", "bosskill",
	}, {
		[134916] = "ej:7178",
		[136478] = "ej:7192",
		[136889] = "ej:7209",
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- Stage 2
	self:Log("SPELL_CAST_START", "LightningWhip", 136850)
	self:Log("SPELL_CAST_SUCCESS", "SummonBallLightning", 136543)
	self:Log("SPELL_CAST_START", "FusionSlash", 136478)
	-- Intermission
	self:Emote("OverloadedCircuits", "137176")
	self:Log("SPELL_CAST_START", "Intermission", 137045)
	-- Stage 1
	self:Log("SPELL_DAMAGE", "CrashingThunder", 135150)
	self:Log("SPELL_CAST_START", "Thunderstruck", 135095)
	self:Log("SPELL_AURA_APPLIED", "Decapitate", 135000)
	-- Conduits
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Boss1Succeeded", "boss1")
	-- Overcharged -- Diffusion Chain -- Static Shock -- Bouncing Bolt
	self:Log("SPELL_AURA_APPLIED", "Overcharged", 136295)
	self:Log("SPELL_AURA_REMOVED", "DiffusionChainRemoved", 135681)
	self:Log("SPELL_AURA_APPLIED", "DiffusionChainApplied", 135681)
	self:Log("SPELL_AURA_REMOVED", "StaticShockRemoved", 135695)
	self:Log("SPELL_AURA_APPLIED", "StaticShockApplied", 135695)

	self:Death("Win", 68397)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX assumed
	proximityOpen = false
	phase = 1
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	wipe(staticShockList)
	self:Bar(134916, "~"..self:SpellName(134916), 42, 134916) -- Decapitate
	self:Bar(135095, "~"..self:SpellName(135095), 25, 135095) -- Thunderstruck
	if UnitBuff("boss1", self:SpellName(135681)) then self:OpenProximity("ej:7239", 8) end
	self:Bar("conduit_abilities", "~"..L["conduit_ability_meassage"], 15, 139271) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- Stage 2
--

function mod:LightningWhip(args)
	self:Bar(args.spellId, args.spellName, 46, args.spellId)
	self:Message(args.spellId, args.spellName, "Attention", args.spellId, "Alert")
end

do
	local prev = 0
	local function warnBallsSoon(spellId)
		mod:Message(spellId, CL["soon"]:format(mod:SpellName(spellId)), "Attention", spellId) -- should maybe shorten this
		if proximityOpen ~= "Diffusion Chain" then -- Diffusion Chians has 8 yard, so don't make a 6 yard if that is open already
			mod:OpenProximity(spellId, 6)
		end
	end
	function mod:SummonBallLightning(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			if not proximityOpen then -- Only close the proximity display if something else have not made it be open
				self:CloseProximity(args.spellId)
			end
			self:ScheduleTimer(warnBallsSoon, 41, args.spellId)-- reopen it when new balls are about to come
			self:Bar(args.spellId, args.spellName, 46, args.spellId)
			self:Message(args.spellId, args.spellName, "Attention", args.spellId)
		end
	end
end

function mod:FusionSlash(args)
	self:Bar(args.spellId, "~"..args.spellName, 52, args.spellId)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Personal", args.spellId, "Info")
end

--------------------------------------------------------------------------------
-- Intermissions
--

local function warnSmallAdds()
	mod:Message("ej:7239", CL["soon"]:format(L["diffusion_chain_message"]), "Important", 136295)
end

function mod:OverloadedCircuits()
	self:Message("stages", CL["phase"]:format(phase), "Positive", 137176, "Info")
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1") -- just to be efficient
	self:StopBar("~"..self:SpellName(136295)) -- Overcharged
	self:CancelAllTimers()
	-- stage 2
	if phase == 2 then
		self:OpenProximity(136543, 6) -- Summon Ball Lightning
		self:Bar(136478, "~"..self:SpellName(136478), 46, 136478) -- Fusion Slash
	elseif phase == 3 then
		self:Bar(135095, "~"..self:SpellName(135095), 28, 135095) -- Thunderstruck
		self:Bar(136889, "~"..self:SpellName(136889), 20, 136889) -- Violent Gale Winds
	end
	self:Bar(136850, "~"..self:SpellName(136850), (phase == 2) and 30 or 15, 136850) -- Lightning Whip
	self:Bar(136543, "~"..self:SpellName(136543), 19, 136543) -- Summon Ball Lightning
end

function mod:Intermission(args)
	self:CancelAllTimers()
	self:StopBar("~"..self:SpellName(134916))  -- Decapitate
	self:StopBar("~"..self:SpellName(135095))  -- Thunderstruck
	self:StopBar(136850) -- Lightning Whip
	self:StopBar(136543) -- Summon Ball Lightning
	self:StopBar("~"..self:SpellName(136478))  -- Furious Slash
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1") -- just to be efficient
	self:Message("stages", L["intermission"], "Positive", args.spellId, "Info")
	self:Bar("stages", L["intermission"], 45, args.spellId)
	if isConduitAlive(68696) then
		self:ScheduleTimer(warnSmallAdds, 1) -- so we don't instantly overwrite previous message
		self:ScheduleTimer(warnSmallAdds, 35)
	end
	if isConduitAlive(68398) then self:Bar(135695, "~"..self:SpellName(135695), 6, 135695) end -- Static Shock
	if isConduitAlive(68697) then self:Bar(136295, "~"..self:SpellName(136295), 15, 136295) end -- Overcharged
	if isConduitAlive(68698) then self:Bar("ej:7242", "~"..self:SpellName(136361), 30, 136361) end -- Bouncing Bolt
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if phase == 1 and hp < 73 then
		self:Message("stages", CL["soon"]:format(L["intermission"]), "Positive", "ability_vehicle_launchplayer", "Info")
		phase = 2
	elseif phase == 2 and hp < 33 then
		self:Message("stages", CL["soon"]:format(L["intermission"]), "Positive", "ability_vehicle_launchplayer", "Info")
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		phase = 3
	end
end

--------------------------------------------------------------------------------
-- Stage 1
--

do
	local prev = 0
	function mod:CrashingThunder(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:Thunderstruck(args)
	self:Message(args.spellId, args.spellName, "Attention", args.spellId, "Alert")
	self:Bar(args.spellId, "~"..args.spellName, 46, args.spellId)
end

function mod:Decapitate(args)
	self:Bar(134916, "~"..args.spellName, 52, 134916)
	self:TargetMessage(134916, args.spellName, args.destName, "Personal", 134916, "Info")
	if UnitIsUnit(args.destName, "player") then
		self:Flash(134916)
	end
end

--------------------------------------------------------------------------------
-- Conduits
--

function mod:Boss1Succeeded(unit, spellName, _, _, spellId)
	if spellId == 136395 then -- Bouncing Bolt -- should somehow try and count how many more bounces are left
		self:Bar("conduit_abilities", "~"..L["conduit_ability_meassage"], 40, 139271) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		-- XXX add bar here
		self:Message("ej:7242", spellName, "Important", 136361, "Long")
	elseif spellId == 135991 then -- Small Adds
		self:Bar("conduit_abilities", "~"..L["conduit_ability_meassage"], 40, 139271) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		-- XXX add bar here
		self:Message("ej:7239", L["diffusion_add_message"], "Important", 135681, "Long")
	elseif spellId == 136869 then -- Violent Gale Winds
		self:Message(136889, spellName, "Important", 136889, "Long")
		self:Bar(136889, 136889, 30, 136889)
	end
end

do
	local overchargedList, scheduled = mod:NewTargetList(), nil
	local function warnOvercharged(spellId)
		if not UnitExists("boss1") then -- poor mans intermission check
			if isConduitAlive(68696) then
				mod:ScheduleTimer(warnSmallAdds, 2) -- so we don't instantly overwrite previous message
			end
		else
			mod:Bar("conduit_abilities", "~"..L["conduit_ability_meassage"], 40, 139271) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		end
		-- XXX add bar here
		mod:TargetMessage(spellId, L["overchargerd_message"], overchargedList, "Urgent", spellId, "Alarm")
		scheduled = nil
	end
	function mod:Overcharged(args)
		overchargedList[#overchargedList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnOvercharged, 0.1, args.spellId)
		end
	end
end

function mod:DiffusionChainRemoved()
	self:CloseProximity("ej:7239")
	proximityOpen = false
end

function mod:DiffusionChainApplied(args)
	self:Message("ej:7239", L["diffusion_chain_message"], "Important", args.spellId, "Long")
	self:OpenProximity("ej:7239", 8)
	proximityOpen = "Diffusion Chain"
end

function mod:StaticShockRemoved(args)
	self:CloseProximity(args.spellId)
	proximityOpen = false
	self:PrimaryIcon(args.spellId)
end

do
	local scheduled = nil
	local function warnStaticShock(spellId)
		if UnitExists("boss1") then -- poor mans intermission check
			mod:Bar("conduit_abilities", "~"..L["conduit_ability_meassage"], 40, 139271) -- need to rework this once I'm 100% sure how the abilities work, for now assume, they share CD
		end
		-- XXX add bar here
		mod:Message(spellId, L["static_shock_message"], "Urgent", spellId, "Alarm")
		scheduled = nil
		table.sort(staticShockList, function(a,b) return a<b end) -- so targeted proximity opens to the same person for everyone
		mod:OpenProximity(spellId, 8, staticShockList[1], true)
		proximityOpen = "Static Shock"
		mod:PrimaryIcon(spellId, staticShockList[1]) -- not sure how helpful this is
		wipe(staticShockList)
	end
	function mod:StaticShockApplied(args)
		staticShockList[#staticShockList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnStaticShock, 0.1, args.spellId)
		end
	end
end
