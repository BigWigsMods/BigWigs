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
mod.stage = stage
local cannonCount = 1
local blastCount = 1
local chargeCount = 1
local wormholeCount = 1
local sparkBotCount = 1
local enlargerCount = 1
local sheepCount = 1
local botMarkCount = 0
local shrunkCount = 0
local tamperCount = 0
local shrunkList, tamperingList = {}, {}
local mobCollector = {}

local lfrTimers = { -- XXX add me
}

local normalTimers = { -- XXX add me
}

local heroicTimers = {
	-- "SPELL_CAST_START", "BusterCannon", 282153
	[282153] = {
		[1] = {13, 33, 64.5, 40, 26.5, 65, 28},
		[2] = {},
		[3] = {17.7, 29, 64.5, 40, 26.5, 65, 28}
	},

	-- "SPELL_CAST_START", "BlastOff", 282205
	[282205] = {
		[1] = {41.1, 26.9, 37.5, 34.3, 50.2, 75.6,},
		[2] = {},
		[3] = {41.7, 29, 35.5, 34.3, 50.2, 75, 30.5},
	},

	-- "SPELL_CAST_SUCCESS", "GigavoltCharge", 287757, 286597
	[286646] = {
		[1] = {21.5, 40, 40, 33, 42, 40, 44.5},
		[2] = {17.4, 34.1},
		[3] = {22.2, 40, 40, 35, 40, 40, 47.6, 27.4},
	},

	-- "SPELL_CAST_START", "WormholeGenerator", 287952
	[287952] = {
		[1] = {38, 98.7, 125.8},
		[2] = {46.9},
		[3] = {38.6, 98.8, 122.7}
	},

	-- "SPELL_CAST_SUCCESS", "DeploySparkBot", 288410, 287691
	[288410] = {
		[1] = {6.5, 22.5, 27.5, 42.5, 22.5, 25, 42.5, 22.5, 22.5},
		[2] = {21.5},
		[3] = {17.2, 40, 42.5, 47.4, 42.5, 45, 55}
	},

	-- "SPELL_CAST_START", "WorldEnlarger", 286693, 288041, 289537
	[286693] = {
		[1] = {75, 90, 90},
		[2] = {8, 31},
		[3] = {75.7, 90, 90}
	},

	-- "SPELL_CAST_START", "SignalExplodingSheep", 287929
	[287929] = {
		[1] = {},
		[2] = {12.8, 30, 12},
		[3] = {28.2, 100.5, 82},
	},
}

local mythicTimers = {
	-- "SPELL_CAST_START", "BusterCannon", 282153
	[282153] = {
		[1] = {13.1, 33.0, 33.5, 31.0, 40.0, 26.5, 65.0, 28.0, 30.5},
		[2] = {},
		[3] = {17.8, 29.0, 33.5, 31.0, 40.0, 26.5},
	},

	-- "SPELL_CAST_START", "BlastOff", 282205
	[282205] = {
		[1] = {41.5, 28.5, 35.5, 34.5, 49.9, 75.5, 30.0},
		[2] = {},
		[3] = {42.2, 28.5, 35.5, 34.6},
	},

	-- "SPELL_CAST_SUCCESS", "GigavoltCharge", 287757, 286597
	[286646] = {
		[1] = {20, 41.5, 38.5, 34.5, 82, 43, 30.5},
		[2] = {},
		[3] = {20.5, 40, 40, 35, 40},
	},

	-- "SPELL_CAST_START", "WormholeGenerator", 287952
	[287952] = {
		[1] = {38.0, 98.7, 125.8},
		[2] = {50.3},
		[3] = {38.7, 98.7},
	},

	-- "SPELL_CAST_SUCCESS", "DeploySparkBot", 288410, 287691
	[288410] = {
		[1] = {6.6, 22.5, 27.5, 42.5, 22.5, 25.0, 42.5, 22.5, 22.5, 55.0, 22.5},
		[2] = {21.3},
		[3] = {17.2, 40.0, 42.5, 48.5, 41.5},
	},

	-- "SPELL_CAST_START", "WorldEnlarger", 286693, 288041, 289537
	[286693] = {
		[1] = {75.0, 90.0, 90.0},
		[2] = {7.8, 31.0},
		[3] = {75.8, 90.0, 90.0},
	},

	-- "SPELL_CAST_START", "SignalExplodingSheep", 287929
	[287929] = {
		[1] = {},
		[2] = {12.8, 30.0, 12.0},
		[3] = {29.8, 92.5},
	},
}

-- local timers = mod:Mythic() and mythicTimers or mod:Heroic() and heroicTimers or mod:Normal() and normalTimers or lfrTimers
local timers = mod:Mythic() and mythicTimers or heroicTimers

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.gigavolt_alt_text = "Bomb"

	L.custom_off_sparkbot_marker = "Spark Bot Marker"
	L.custom_off_sparkbot_marker_desc = "Mark Spark Bots with {rt4}{rt5}{rt6}{rt7}{rt8}."

	L.custom_on_repeating_shrunk_say = "Repeating Shrunk Say"
	L.custom_on_repeating_shrunk_say_desc = "Spam the word 'Shrunk' in say chat while you're |cff71d5ff[Shrunk]|r. Maybe they'll stop running you over if they see the chat bubble."
	L.custom_on_repeating_shrunk_say_icon = 284168

	L.custom_off_repeating_tampering_say = "Repeating Tampering Say"
	L.custom_off_repeating_tampering_say_desc = "Spam your name in say chat while you're controlling a robot."
	L.custom_off_repeating_tampering_say_icon = 286105
end

--------------------------------------------------------------------------------
-- Initialization
--

local gigavoltChargeMarker = mod:AddMarkerOption(false, "player", 1, 286646, 1, 2, 3) -- Gigavolt Charge
function mod:GetOptions()
	return {
		-- General
		"stages",
		{282153, "EMPHASIZE"}, -- Buster Cannon
		282205, -- Blast Off
		{286646, "SAY", "SAY_COUNTDOWN"}, -- Gigavolt Charge
		gigavoltChargeMarker,
		287952, -- Wormhole Generator
		288410, -- Deploy Spark Bot
		"custom_off_sparkbot_marker",
		286693, -- World Enlarger
		{284168, "INFOBOX"}, -- Shrunk
		"custom_on_repeating_shrunk_say",
		"custom_off_repeating_tampering_say",
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
	self:Log("SPELL_AURA_APPLIED", "ShrunkApplied", 284168)
	self:Log("SPELL_AURA_REMOVED", "ShrunkRemoved", 284168)
	self:Log("SPELL_AURA_APPLIED", "TamperingApplied", 286105)
	self:Log("SPELL_AURA_REMOVED", "TamperingRemoved", 286105)

	self:Log("SPELL_CAST_START", "EvasiveManeuvers", 287751)
	self:Log("SPELL_CAST_START", "CrashDown", 287797)

	self:Log("SPELL_CAST_START", "SignalExplodingSheep", 287929)
end

function mod:OnEngage()
	stage = 1
	self.stage = stage
	cannonCount = 1
	blastCount = 1
	chargeCount = 1
	wormholeCount = 1
	sparkBotCount = 1
	enlargerCount = 1
	sheepCount = 1
	botMarkCount = 0
	shrunkCount = 0
	tamperCount = 0
	shrunkList, tamperingList = {}, {}
	mobCollector = {}

	-- local timers = self:Mythic() and mythicTimers or self:Heroic() and heroicTimers or self:Normal() and normalTimers or lfrTimers
	timers = self:Mythic() and mythicTimers or heroicTimers

	self:Bar(288410, timers[288410][stage][sparkBotCount], CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:Bar(282153, timers[282153][stage][cannonCount], CL.count:format(self:SpellName(282153), cannonCount)) -- Buster Cannon
	self:Bar(286646, timers[286646][stage][chargeCount], CL.count:format(L.gigavolt_alt_text, chargeCount)) -- Bombs // Gigavolt Charge
	self:Bar(287952, timers[287952][stage][wormholeCount], CL.count:format(self:SpellName(287952), wormholeCount)) -- Wormhole Generator
	self:Bar(282205, timers[282205][stage][blastCount], CL.count:format(self:SpellName(282205), blastCount)) -- Blast Off
	self:Bar(286693, timers[286693][stage][enlargerCount], CL.count:format(self:SpellName(286693), enlargerCount)) -- World Enlarger

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
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, cannonCount))
	self:PlaySound(args.spellId, "warning")
	cannonCount = cannonCount + 1
	self:Bar(args.spellId, timers[args.spellId][stage][cannonCount], CL.count:format(args.spellName, cannonCount))
end

function mod:BlastOff(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, blastCount))
	self:PlaySound(args.spellId, "alarm")
	blastCount = blastCount + 1
	self:Bar(args.spellId, timers[args.spellId][stage][blastCount], CL.count:format(args.spellName, blastCount))
end

function mod:GigavoltCharge(args)
	chargeCount = chargeCount + 1
	self:Bar(286646, timers[286646][stage][chargeCount], CL.count:format(L.gigavolt_alt_text, chargeCount))
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:GigavoltChargeApplied(args)
		local playerListCount = #playerList+1
		playerList[playerListCount] = args.destName
		playerIcons[playerListCount] = playerListCount
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(L.gigavolt_alt_text, playerListCount, playerListCount))
			self:SayCountdown(args.spellId, 15)
			self:TargetBar(args.spellId, 15, args.destName, L.gigavolt_alt_text)
		end
		if self:GetOption(gigavoltChargeMarker) then
			SetRaidTarget(args.destName, playerListCount)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, L.gigavolt_alt_text, nil, nil, playerIcons)
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
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, wormholeCount))
	self:PlaySound(args.spellId, "alert")
	wormholeCount = wormholeCount + 1
	self:Bar(args.spellId, timers[args.spellId][stage][wormholeCount], CL.count:format(args.spellName, wormholeCount))
end

function mod:DeploySparkBot(args)
	self:Message2(288410, "cyan", CL.count:format(args.spellName, sparkBotCount))
	self:PlaySound(288410, "info")
	sparkBotCount = sparkBotCount + 1
	self:Bar(288410, timers[288410][stage][sparkBotCount], CL.count:format(args.spellName, sparkBotCount))
end

function mod:sparkBotMark(event, unit, guid)
	if self:MobId(guid) == 144942 and not mobCollector[guid] then
		botMarkCount = botMarkCount + 1
		SetRaidTarget(unit, (botMarkCount % 5)+4)
		mobCollector[guid] = true
	end
end

function mod:WorldEnlarger(args)
	self:Message2(286693, "yellow", CL.count:format(args.spellName, enlargerCount))
	self:PlaySound(286693, "long")
	enlargerCount = enlargerCount + 1
	self:Bar(286693, timers[286693][stage][enlargerCount], CL.count:format(args.spellName, enlargerCount))
end

do
	local shrunkTimer, tamperTimer = nil, nil
	local function UpdateShrunkBox()
		if shrunkCount == 0 and tamperCount == 0 then
			mod:CloseInfo(284168)
		else
			mod:SimpleTimer(UpdateShrunkBox, 0.1)
			local lines = 0
			for name, expires in pairs(tamperingList) do
				lines = lines + 1
				if lines < 6 then -- room for 5 in infobox
					local timeLeft = math.max(expires - GetTime(), 0)
					local timeLeftPercentage = timeLeft / (mod:Mythic() and 30 or 45)
					mod:SetInfo(284168, (lines*2) - 1, "|T134520:15:15:0:0:64:64:4:60:4:60|t "..mod:ColorName(name)) -- 134520 = inv_misc_wrench_01
					mod:SetInfo(284168, (lines*2), CL.seconds:format(timeLeft))
					mod:SetInfoBar(284168, (lines*2), timeLeftPercentage, .3, 1, .3, .67)
				end
			end

			for name, expires in pairs(shrunkList) do
				lines = lines + 1
				if lines < 6 then -- room for 5 in infobox
					local timeLeft = math.max(expires - GetTime(), 0)
					local timeLeftPercentage = timeLeft / 30
					mod:SetInfo(284168, (lines*2) - 1, "|T236446:15:15:0:0:64:64:4:60:4:60|t "..mod:ColorName(name)) -- 236446 = achievement_character_gnome_male
					mod:SetInfo(284168, (lines*2), CL.seconds:format(timeLeft))
					mod:SetInfoBar(284168, (lines*2), timeLeftPercentage, .48, .48, .48, .67)
				end
			end
		end
	end

	function mod:ShrunkApplied(args)
		if self:Me(args.destGUID) then
			self:TargetMessage2(args.spellId, "blue", args.destName)
			self:PlaySound(args.spellId, "alert")
			if not shrunkTimer and self:GetOption("custom_on_repeating_shrunk_say") and not self:LFR() then
				SendChatMessage(args.spellName, "SAY")
				shrunkTimer = self:ScheduleRepeatingTimer(SendChatMessage, 1.5, args.spellName, "SAY")
			end
		end

		shrunkCount = shrunkCount + 1
		shrunkList[args.destName] = GetTime() + 30
		if shrunkCount == 1 and tamperCount == 0 then -- First application
			self:OpenInfo(284168, self:SpellName(284168))
			UpdateShrunkBox()
		else
	end

	function mod:ShrunkRemoved(args)
		if self:Me(args.destGUID) and shrunkTimer then
			self:CancelTimer(shrunkTimer)
			shrunkTimer = nil
		end

		shrunkCount = shrunkCount - 1
		shrunkList[args.destName] = nil
	end

	function mod:TamperingApplied(args)
		if self:Me(args.destGUID) then
			if not tamperTimer and self:GetOption("custom_off_repeating_tampering_say") then
				SendChatMessage(args.destName, "SAY")
				tamperTimer = self:ScheduleRepeatingTimer(SendChatMessage, 1.5, args.destName, "SAY")
			end
		end
		tamperCount = tamperCount + 1
		tamperingList[args.destName] = GetTime() + (self:Mythic() and 30 or 45)
		if shrunkCount == 0 and tamperCount == 1 then -- First application
			self:OpenInfo(284168, self:SpellName(284168))
			UpdateShrunkBox()
		else
	end

	function mod:TamperingRemoved(args)
		if self:Me(args.destGUID) and tamperTimer then
			self:CancelTimer(tamperTimer)
			tamperTimer = nil
		end
		tamperCount = tamperCount - 1
		tamperingList[args.destName] = nil
	end
end

function mod:EvasiveManeuvers(args)
	stage = 2
	self.stage = stage
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	self:StopBar(CL.count:format(self:SpellName(282153), cannonCount)) -- Buster Cannon
	self:StopBar(CL.count:format(self:SpellName(282205), blastCount)) -- Blast Off
	self:StopBar(CL.count:format(L.gigavolt_alt_text, chargeCount)) -- Bombs
	self:StopBar(CL.count:format(self:SpellName(287952), wormholeCount)) -- Wormhole Generator
	self:StopBar(CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:StopBar(CL.count:format(self:SpellName(286693), enlargerCount)) -- World Enlarger

	cannonCount = 1
	blastCount = 1
	chargeCount = 1
	wormholeCount = 1
	sparkBotCount = 1
	enlargerCount = 1
	sheepCount = 1

	if not self:Mythic() then
		self:Bar(286646, timers[286646][stage][chargeCount], CL.count:format(L.gigavolt_alt_text, chargeCount)) -- Bombs // Gigavolt Charge
	end
	self:Bar(287952, timers[287952][stage][wormholeCount], CL.count:format(self:SpellName(287952), wormholeCount)) -- Wormhole Generator
	self:Bar(288410, timers[288410][stage][sparkBotCount], CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:Bar(286693, timers[286693][stage][enlargerCount], CL.count:format(self:SpellName(286693), enlargerCount)) -- World Enlarger
	self:Bar(287929, timers[287929][stage][sheepCount], CL.count:format(self:SpellName(287929), sheepCount)) -- Signal Exploding Sheep
	self:CDBar("stages", 65, 287797) -- Crash Down
end

function mod:CrashDown(args)
	stage = 3
	self.stage = stage
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	self:StopBar(CL.count:format(self:SpellName(282153), cannonCount)) -- Buster Cannon
	self:StopBar(CL.count:format(self:SpellName(282205), blastCount)) -- Blast Off
	self:StopBar(CL.count:format(L.gigavolt_alt_text, chargeCount)) -- Bombs
	self:StopBar(CL.count:format(self:SpellName(287952), wormholeCount)) -- Wormhole Generator
	self:StopBar(CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:StopBar(CL.count:format(self:SpellName(286693), enlargerCount)) -- World Enlarger
	self:StopBar(CL.count:format(self:SpellName(287929), sheepCount)) -- Signal Exploding Sheep

	cannonCount = 1
	blastCount = 1
	chargeCount = 1
	wormholeCount = 1
	sparkBotCount = 1
	enlargerCount = 1
	sheepCount = 1

	self:Bar(282153, timers[282153][stage][cannonCount], CL.count:format(self:SpellName(282153), cannonCount)) -- Buster Cannon
	self:Bar(282205, timers[282205][stage][blastCount], CL.count:format(self:SpellName(282205), blastCount)) -- Blast Off
	self:Bar(286646, timers[286646][stage][chargeCount], CL.count:format(L.gigavolt_alt_text, chargeCount)) -- Bombs // Gigavolt Charge
	self:Bar(287952, timers[287952][stage][wormholeCount], CL.count:format(self:SpellName(287952), wormholeCount)) -- Wormhole Generator
	self:Bar(288410, timers[288410][stage][sparkBotCount], CL.count:format(self:SpellName(288410), sparkBotCount)) -- Deploy Spark Bot
	self:Bar(286693, timers[286693][stage][enlargerCount], CL.count:format(self:SpellName(286693), enlargerCount)) -- World Enlarger
	self:Bar(287929, timers[287929][stage][sheepCount], CL.count:format(self:SpellName(287929), sheepCount)) -- Signal Exploding Sheep
end

function mod:SignalExplodingSheep(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, sheepCount))
	self:PlaySound(args.spellId, "long")
	sheepCount = sheepCount + 1
	self:Bar(args.spellId, timers[args.spellId][stage][sheepCount], CL.count:format(args.spellName, sheepCount))
end
