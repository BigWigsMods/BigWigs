--------------------------------------------------------------------------------
-- TODO:
-- - Assistant on robots?
-- - Intermission soon warnings
-- - Initial timers
-- - Improve timers generally

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High Tinker Mekkatorque", 2070, 2334)
if not mod then return end
mod:RegisterEnableMob(144796)
mod.engageId = 2276
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local sparkBotCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.gigavolt_alt_text = "Bomb"
end

--------------------------------------------------------------------------------
-- Initialization
--

local gigavoltChargeMarker = mod:AddMarkerOption(false, "player", 1, 286646, 1, 2, 3) -- Gigavolt Charge
function mod:GetOptions()
	return {
		-- General
		282153, -- Buster Cannon
		282205, -- Blast Off
		{286646, "SAY", "SAY_COUNTDOWN"}, -- Gigavolt Charge
		gigavoltChargeMarker,
		287952, -- Dimensional Ripper XL
		284042, -- Deploy Spark Bot
		288049, -- Shrink Ray
		286051, -- Hyperdrive
		-- Intermission
		287929, -- Signal Exploding Sheep
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "BusterCannon", 282153)
	self:Log("SPELL_CAST_START", "BlastOff", 282205)
	self:Log("SPELL_CAST_SUCCESS", "GigavoltCharge", 286597)
	self:Log("SPELL_AURA_APPLIED", "GigavoltChargeApplied", 286646)
	self:Log("SPELL_AURA_REMOVED", "GigavoltChargeRemoved", 286646)
	self:Log("SPELL_CAST_START", "DimensionalRipperXL", 287952)
	self:Log("SPELL_CAST_SUCCESS", "DeploySparkBot", 284042)
	self:Log("SPELL_CAST_START", "ShrinkRay", 288049)
	self:Log("SPELL_AURA_APPLIED", "Hyperdrive", 286051)
	self:Log("SPELL_CAST_START", "SignalExplodingSheep", 287929)
end

function mod:OnEngage()
	sparkBotCount = sparkBotCount + 1
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
	self:Message2(args.spellId, "cyan", CL.count:format(args.spellName, sparkBotCount))
	self:PlaySound(args.spellId, "info")
	sparkBotCount = sparkBotCount + 1
end

function mod:ShrinkRay(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

function mod:Hyperdrive(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:SignalExplodingSheep(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end
