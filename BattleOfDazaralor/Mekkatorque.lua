--------------------------------------------------------------------------------
-- TODO:
-- - Assistant on robots?
-- - Improve timers generally
-- - Update option menu with sub catagories (stage 1, stage 2, intermission etc)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High Tinker Mekkatorque", 2070, 2334)
if not mod then return end
mod:RegisterEnableMob(144796)
mod.engageId = 2276
mod.respawnTime = 33

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local sparkBotCount = 1
local botMarkCount = 0
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.gigavolt_alt_text = "Bomb"

	L.custom_off_sparkbot_marker = "Spark Bot Marker"
	L.custom_off_sparkbot_marker_desc = "Mark Spark Bots with {rt4}{rt5}{rt6}{rt7}{rt8}."
end

--------------------------------------------------------------------------------
-- Initialization
--

local gigavoltChargeMarker = mod:AddMarkerOption(false, "player", 1, 286646, 1, 2, 3) -- Gigavolt Charge
function mod:GetOptions()
	return {
		-- General
		"stages",
		282153, -- Buster Cannon
		282205, -- Blast Off
		{286646, "SAY", "SAY_COUNTDOWN"}, -- Gigavolt Charge
		gigavoltChargeMarker,
		287952, -- Wormhole Generator
		288410, -- Deploy Spark Bot
		"custom_off_sparkbot_marker",
		286693, -- World Enlarger
		-- Intermission
		287929, -- Signal Exploding Sheep
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "BusterCannon", 282153)
	self:Log("SPELL_CAST_START", "BlastOff", 282205)
	self:Log("SPELL_CAST_SUCCESS", "GigavoltCharge", 287757, 286597) -- XXX With Tank Without Tank?
	self:Log("SPELL_AURA_APPLIED", "GigavoltChargeApplied", 286646)
	self:Log("SPELL_AURA_REMOVED", "GigavoltChargeRemoved", 286646)
	self:Log("SPELL_CAST_START", "WormholeGenerator", 287952)
	self:Log("SPELL_CAST_SUCCESS", "DeploySparkBot", 288410, 287691) -- Stage 1, Stage 2+3
	self:Log("SPELL_CAST_START", "WorldEnlarger", 286693, 288041, 289537)

	self:Log("SPELL_CAST_START", "EvasiveManeuvers", 287751)
	self:Log("SPELL_CAST_START", "CrashDown", 287797)

	self:Log("SPELL_CAST_START", "SignalExplodingSheep", 287929)
end

function mod:OnEngage()
	stage = 1
	botMarkCount = 0
	sparkBotCount = 1
	mobCollector = {}

	self:CDBar(288410, 6.5, CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:CDBar(282153, 13) -- Buster Cannon
	self:CDBar(286646, 20, L.gigavolt_alt_text) -- Bombs // Gigavolt Charge
	self:CDBar(287952, 38) -- Wormhole Generator
	self:CDBar(282205, 41) -- Blast Off
	self:CDBar(286693, 75) -- World Enlarger

	if self:GetOption("custom_off_sparkbot_marker") then
		self:RegisterTargetEvents("sparkBotMark")
	end
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 43 then -- Evasive Maneuvers! at 40%
		self:Message2("stages", "green", CL.soon:format(CL.stage:format(2)), false)
		self:UnregisterUnitEvent(event, unit)
	end
end

function mod:BusterCannon(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	-- XXX Improve Fix Timers
	self:CDBar(args.spellId, 25)
end

function mod:BlastOff(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	-- XXX Improve Fix Timers
	self:CDBar(args.spellId, 30)
end

function mod:GigavoltCharge(args)
	-- XXX Improve Fix Timers
	self:CDBar(286646, 30, L.gigavolt_alt_text)
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(286646, "ME_ONLY")

		if isOnMe then
			mod:TargetBar(286646, 15, mod:UnitName("player"), L.gigavolt_alt_text)
		end

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message2(286646, "blue", CL.you:format(("|T13700%d:0|t%s"):format(isOnMe, L.gigavolt_alt_text)))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message2(286646, "yellow", CL.other:format(L.gigavolt_alt_text, msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:GigavoltChargeApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.1)
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, isOnMe, isOnMe))
			self:SayCountdown(args.spellId, 15)
		end
		if self:GetOption(gigavoltChargeMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end
end

do
	local prev = 0
	function mod:GigavoltChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:StopBar(L.gigavolt_alt_text, args.destName)
		end
		if self:GetOption(gigavoltChargeMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:WormholeGenerator(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	-- XXX Improve Timers
	self:CDBar(args.spellId, 44)
end

function mod:DeploySparkBot(args)
	self:Message2(288410, "cyan", CL.count:format(args.spellName, sparkBotCount))
	self:PlaySound(288410, "info")
	sparkBotCount = sparkBotCount + 1
	-- XXX Improve Timers
	self:CDBar(288410, stage == 1 and (sparkBotCount % 3 == 1 and 42.5 or 22.5) or 40, CL.count:format(args.spellName, sparkBotCount))
end

function mod:sparkBotMark(event, unit, guid)
	if self:MobId(guid) == 144942 and not mobCollector[guid] then
		botMarkCount = botMarkCount + 1
		SetRaidTarget(unit, (botMarkCount % 5)+4)
		mobCollector[guid] = true
	end
end

function mod:WorldEnlarger(args)
	self:Message2(286693, "yellow")
	self:PlaySound(286693, "long")
	-- XXX Improve timers
end

function mod:EvasiveManeuvers(args)
	stage = 2
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	self:StopBar(282153) -- Buster Cannon
	self:StopBar(282205) -- Blast Off
	self:StopBar(L.gigavolt_alt_text) -- Bombs
	self:StopBar(287952) -- Wormhole Generator
	self:StopBar(286693) -- World Enlarger

	self:CDBar(286693, 7.5) -- World Enlarger
	self:CDBar(286646, 17.5, L.gigavolt_alt_text) -- Bombs // Gigavolt Charge
	self:CDBar(288410, 21.3, CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:CDBar(287952, 46.5) -- Wormhole Generator
	self:CDBar("stages", 65, 287797) -- Crash Down
end

function mod:CrashDown(args)
	stage = 3
	self:Message2("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")

	self:CDBar(288410, 17, CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:CDBar(282153, 17.5) -- Buster Cannon
	self:CDBar(286646, 22, L.gigavolt_alt_text) -- Bombs // Gigavolt Charge
	self:CDBar(287952, 38.5) -- Wormhole Generator
	self:CDBar(282205, 41.5) -- Blast Off
	self:CDBar(286693, 75.5) -- World Enlarger
end

function mod:SignalExplodingSheep(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	-- XXX Improve/Add Timers?
end
