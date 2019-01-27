--------------------------------------------------------------------------------
-- TODO:
-- - Assistant on robots?
-- - Intermission soon warnings
-- - Improve timers generally

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
local sparkBotCount = 0
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
		"stages",
		-- General
		282153, -- Buster Cannon
		282205, -- Blast Off
		{286646, "SAY", "SAY_COUNTDOWN"}, -- Gigavolt Charge
		gigavoltChargeMarker,
		287952, -- Dimensional Ripper XL
		288410, -- Deploy Spark Bot
		"custom_off_sparkbot_marker",
		288049, -- Shrink Ray
		286051, -- Hyperdrive
		-- Intermission
		287929, -- Signal Exploding Sheep
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "BusterCannon", 282153)
	self:Log("SPELL_CAST_START", "BlastOff", 282205)
	self:Log("SPELL_CAST_SUCCESS", "GigavoltCharge", 286597, 287757)
	self:Log("SPELL_AURA_APPLIED", "GigavoltChargeApplied", 286646)
	self:Log("SPELL_AURA_REMOVED", "GigavoltChargeRemoved", 286646)
	self:Log("SPELL_CAST_START", "DimensionalRipperXL", 287952)
	self:Log("SPELL_CAST_SUCCESS", "DeploySparkBot", 288410, 287691) -- phase 1 spellid, phase 2+ spellid
	self:Log("SPELL_CAST_START", "ShrinkRay", 288049)
	self:Log("SPELL_CAST_SUCCESS", "EvasiveManeuvers", 287751)
	self:Log("SPELL_CAST_SUCCESS", "CrashDown", 287797) -- Spell that starts phase 3
	self:Log("SPELL_CAST_START", "SignalExplodingSheep", 287929)
end

function mod:OnEngage()
	stage = 1
	botMarkCount = 0
	sparkBotCount = 0
	mobCollector = {}
	if self:GetOption("custom_off_sparkbot_marker") then
		self:RegisterTargetEvents("sparkBotMark")
	end
	self:Bar(282153, 13) -- Buster Cannon
	self:Bar(282205, 41) -- Blast Off
	self:Bar(286597, 21.5) -- Gigavolt Charge
	self:Bar(288410, 6.5) -- Deploy Spark Bot
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BusterCannon(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 25)
end

function mod:BlastOff(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 30)
end

function mod:GigavoltCharge(args)
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

function mod:DimensionalRipperXL(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 44)
end

function mod:DeploySparkBot(args)
	sparkBotCount = sparkBotCount + 1
	self:Message2(288410, "cyan", CL.count:format(args.spellName, sparkBotCount))
	self:PlaySound(288410, "info")
	if args.spellId == 288410 then -- Phase 1
		self:Bar(288410, sparkBotCount % 3 == 0 and 42.5 or 22.5) -- 3 casts spaced a short distance apart, followed by a longer wait
	else -- Phase 2
		self:Bar(288410, 40)
	end
end

function mod:sparkBotMark(event, unit, guid)
	if self:MobId(guid) == 144942 and not mobCollector[guid] then
		botMarkCount = botMarkCount + 1
		SetRaidTarget(unit, (botMarkCount % 5)+4)
		mobCollector[guid] = true
	end
end

function mod:ShrinkRay(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

function mod:EvasiveManeuvers(args)
	stage = 2
	self:Message2("stages", "cyan", CL.stage:format(stage))
	self:PlaySound("stages", "long")
	self:Bar(286646, 14.3, L.gigavolt_alt_text) -- Gigavolt Charge
	self:Bar(288410, 18.3) -- Deploy Spark Bot
	self:StopBar(282205) -- Blast Off
end

function mod:CrashDown(args)
	stage = 3
	self:Message2("stages", "cyan", CL.stage:format(stage))
	self:PlaySound("stages", "info")
	self:Bar(286646, 19.3, L.gigavolt_alt_text) -- Gigavolt Charge
	self:Bar(288410, 14.3) -- Deploy Spark Bot
	self:Bar(282205, 38.9) -- Blast Off
end

function mod:SignalExplodingSheep(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end
