--------------------------------------------------------------------------------
-- TODO:
-- -- Stage 1:
-- -- Add timer
-- -- Avalance Say warnings/Countdown/Marked targets
-- -- Stage 2:
-- -- Warmth positive warning
-- -- Kegs killed/exploding timers?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Jaina Proudmoore", 2070, 2343)
if not mod then return end
mod:RegisterEnableMob(146409) -- Lady Jaina Proudmoore
mod.engageId = 2281
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local imageCount = 0
local ringofIceCount = 1
local icefallCount = 1
local stage = 1
local intermission = false
local intermissionTime = 0
local nextStageWarning = 63
local chillingTouchList = {}
local burningExplosionCounter = 1
local broadsideCount = 0
local orbofFrostCount = 1
local crystallineDustCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.starbord_ship_emote = "A Kul Tiran Corsair approaches on the starboard side!"
	L.port_side_ship_emote = "A Kul Tiran Corsair approaches on the port side!"

	L.starbord_txt = "Right Ship" -- starboard
	L.port_side_txt = "Left Ship" -- port

	L.ship_icon = "inv_garrison_cargoship"

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Jaina randomizes which off-cooldown ability she uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	L.frozenblood_player = "%s (%d players)"

	L.intermission_stage2 = "Stage 2 - %.1f sec"
end

--------------------------------------------------------------------------------
-- Initialization
--

local broadsideMarker = mod:AddMarkerOption(false, "player", 1, 288212, 1, 2, 3) -- Broadside
local avalanceMarker = mod:AddMarkerOption(false, "player", 1, 285254, 1, 2, 3) -- Avalance
function mod:GetOptions()
	return {
		-- General
		"stages",
		"berserk",
		"custom_on_stop_timers",
		{287993, "INFOBOX"}, -- Chilling Touch
		287490, -- Frozen Solid
		-- Stage 1
		-19690, -- Kul Tiran Corsair
		{288038, "FLASH"}, -- Marked Target
		285725, -- Set Charge
		287365, -- Searing Pitch
		{285253, "TANK"}, -- Ice Shard
		{285254, "FLASH", "SAY", "ICON"}, -- Avalanche
		avalanceMarker,
		287925, -- Time Warp
		287626, -- Grasp of Frost
		285177, -- Freezing Blast
		285459, -- Ring of Ice
		-- Stage 2
		288297, -- Arctic Ground
		{288212, "SAY", "SAY_COUNTDOWN"}, -- Broadside
		broadsideMarker,
		{288374, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Siegebreaker Blast
		288345, -- Glacial Ray
		288441, -- Icefall
		288221, -- Burning Explosion
		-- Intermission
		289220, -- Heart of Frost
		289219, -- Frost Nova
		290084, -- Water Bolt Volley
		-- Stage 3
		289940, -- Crystalline Dust
		288619, -- Orb of Frost
		288747, -- Prismatic Image
		-- Mythic
		289387, -- Freezing Blood
		289488, -- Frozen Siege
		288169, -- Howling Winds
		-19825, -- Icebound Image
	},{
		["stages"] = "general",
		[-19690] = -19557, -- Stage One: Burning Seas
		[288297] = -19565, -- Stage Two: Frozen Wrath
		[289220] = -19652, -- Intermission: Flash Freeze
		[289940] = -19624, -- Stage Three: Daughter of the Sea
		[289387] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- General
	self:Log("SPELL_AURA_APPLIED", "ChillingTouch", 287993)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChillingTouch", 287993)
	self:Log("SPELL_AURA_REMOVED", "ChillingTouchRemoved", 287993)
	self:Log("SPELL_AURA_APPLIED", "FrozenSolid", 287490)

	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "MarkedTargetApplied", 288038) -- XXX Fixate icon nameplates
	self:Log("SPELL_CAST_SUCCESS", "SetCharge", 285725)
	self:Log("SPELL_AURA_APPLIED", "IceShard", 285253)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IceShard", 285253)
	self:Log("SPELL_CAST_START", "Avalanche", 287565)
	self:Log("SPELL_AURA_APPLIED", "AvalancheApplied", 285254)
	self:Log("SPELL_AURA_REMOVED", "AvalancheRemoved", 285254)
	self:Log("SPELL_CAST_SUCCESS", "TimeWarp", 287925)
	self:Log("SPELL_CAST_START", "GraspofFrostStart", 287626)
	self:Log("SPELL_AURA_APPLIED", "GraspofFrost", 287626)
	self:Log("SPELL_CAST_START", "FreezingBlast", 285177)
	self:Log("SPELL_CAST_START", "RingofIce", 285459)

	-- Intermission
	self:Log("SPELL_CAST_SUCCESS", "HowlingWindsStart", 288099)
	self:Log("SPELL_AURA_REMOVED", "HowlingWindsRemoved", 288199)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "BroadsideSucces", 288211)
	self:Log("SPELL_AURA_APPLIED", "BroadsideApplied", 288212)
	self:Log("SPELL_AURA_REMOVED", "BroadsideRemoved", 288212)
	self:Log("SPELL_CAST_SUCCESS", "SiegebreakerBlastSucces", 288374)
	self:Log("SPELL_AURA_APPLIED", "SiegebreakerBlastApplied", 288374)
	self:Log("SPELL_AURA_REMOVED", "SiegebreakerBlastRemoved", 288374)
	self:Log("SPELL_CAST_START", "GlacialRay", 288345)
	self:Log("SPELL_CAST_SUCCESS", "Icefall", 288441)
	self:Log("SPELL_CAST_START", "BurningExplosion", 288221)

	-- Intermission
	self:Log("SPELL_CAST_START", "FlashFreeze", 288719)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneBarrage", 290001)
	self:Log("SPELL_AURA_REMOVED", "ArcaneBarrageRemoved", 290001)
	self:Log("SPELL_AURA_APPLIED", "HeartofFrost", 289220)
	self:Log("SPELL_CAST_START", "FrostNova", 289219)
	self:Log("SPELL_CAST_START", "WaterBoltVolley", 290084)

	-- Stage 3
	self:Log("SPELL_CAST_START", "CrystallineDust", 289940)
	self:Log("SPELL_CAST_START", "OrbofFrost", 288619)
	self:Log("SPELL_CAST_START", "PrismaticImage", 288747)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 287365, 288297) -- Searing Pitch,  Arctic Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 287365, 288297)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 287365, 288297)

	-- Mythic
	self:Log("SPELL_CAST_START", "FrozenSiege", 289488)
	self:Log("SPELL_AURA_APPLIED", "FreezingBloodApplied", 289387)
	self:Log("SPELL_AURA_REMOVED", "FreezingBloodRemoved", 289387)
	self:Log("SPELL_AURA_APPLIED", "HowlingWindsMythicApplied", 288169)
	self:Death("ImageDeath", 149535) -- Icebound Image

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	ringofIceCount = 1
	icefallCount = 1
	stage = 1
	intermission = false
	nextStageWarning = 63
	chillingTouchList = {}
	burningExplosionCounter = 1
	broadsideCount = 0
	orbofFrostCount = 1
	crystallineDustCount = 1
	imageCount = 0

	self:OpenInfo(287993, self:SpellName(287993)) -- Chilling Touch
	if self:Mythic() then
		self:Bar(289488, 3) -- Frozen Siege
		self:Bar(288169, 67) -- Howling Winds
	end
	self:CDBar(285254, 8) -- Avalanche
	self:CDBar(285177, 17) -- Freezing Blast
	self:CDBar(-19690, 20, -19690, L.ship_icon)
	self:CDBar(287626, 23) -- Grasp of Frost
	self:CDBar(285459, 60, CL.count:format(self:SpellName(285459), ringofIceCount)) -- Ring of Ice

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")

	self:Berserk(self:Mythic() and 720 or 900)
end

function mod:VerifyEnable(unit)
	local hp = UnitHealthMax(unit)
	return hp > 0 and (UnitHealth(unit) / hp) > 0.1 -- 10%
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local abilitysToPause = {
		[285254] = true, -- Avalanche
		[285177] = true, -- Freezing Blast
		[-19690] = true, -- Ships
		[285459] = true, -- Ring of Ice
		[287626] = true, -- Grasp of Frost
		[289488] = true, -- Frozen Siege
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
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) and text ~= L.touch_impact then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Intermission at 60% & 30%
		self:Message2("stages", "green", CL.soon:format(CL.intermission), false)
		nextStageWarning = nextStageWarning - 30
		if nextStageWarning < 30 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 287282 then -- Arctic Armor // Intermission 1 Start
		self:PlaySound("stages", "long")
		self:Message2("stages", "green", CL.intermission, false)
		intermission = true
		imageCount = 0

		self:StopBar(285254) -- Avalanche
		self:StopBar(285177) -- Freezing Blast
		self:StopBar(CL.count:format(self:SpellName(285459), ringofIceCount)) -- Ring of Ice
		self:StopBar(-19690)
		self:StopBar(L.port_side_txt)
		self:StopBar(L.starbord_txt)
		self:StopBar(289488) -- Frozen Siege
		self:StopBar(288169) -- Howling Winds
		self:StopBar(287626) -- Grasp of Frost
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find(L.starbord_ship_emote) then
		self:Message2(-19690, "yellow", L.starbord_txt, L.ship_icon)
		self:PlaySound(-19690, "info")
		self:StopBar(-19690)
		self:StopBar(L.starbord_txt)
		self:CDBar(-19690, 60, L.port_side_txt, L.ship_icon)
	elseif msg:find(L.port_side_ship_emote) then
		self:Message2(-19690, "yellow", L.port_side_txt, L.ship_icon)
		self:PlaySound(-19690, "info")
		self:StopBar(-19690)
		self:StopBar(L.port_side_txt)
		self:CDBar(-19690, 60, L.starbord_txt, L.ship_icon)
	end
end

function mod:ChillingTouch(args)
	if self:Me(args.destGUID) then -- Check if we have to warn for high stacks in Mythic
		local amount = args.amount or 1
		if amount >= 18 or amount % 5 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, "alarm")
		end
	end
	chillingTouchList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, chillingTouchList)
end

function mod:ChillingTouchRemoved(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
	chillingTouchList[args.destName] = 0
	self:SetInfoByTable(args.spellId, chillingTouchList)
end

do
	local playerList = mod:NewTargetList()
	function mod:FrozenSolid(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

-- Stage 1
function mod:MarkedTargetApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Flash(args.spellId)
	end
end

function mod:SetCharge(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:IceShard(args)
	local amount = args.amount or 1
	if amount % 3 == 1 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, amount > 20 and "alarm" or "alert", nil, args.destName)
	end
end

function mod:Avalanche(args)
	self:CDBar(285254, self:Mythic() and (stage == 2 and 80 or 46) or (stage > 1 and 75 or 60)) -- Avalanche
end

do
	local playerList = mod:NewTargetList()
	function mod:AvalancheApplied(args)
		if stage == 1 then -- 3 targets
			local count = #playerList + 1
			playerList[count] = args.destName
			self:TargetsMessage(args.spellId, "yellow", playerList, 3)
			if self:Me(args.destGUID) then
				self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
				self:PlaySound(args.spellId, "warning")
				self:Flash(args.spellId)
			end
			if self:GetOption(avalanceMarker) then
				SetRaidTarget(args.destName, count)
			end
		else -- 1 target (tank)
			self:TargetMessage2(args.spellId, "yellow", args.destName)
			self:PrimaryIcon(args.spellId, args.destName)
			if self:Me(args.destGUID) then
				self:Say(args.spellId)
				self:PlaySound(args.spellId, "warning")
				self:Flash(args.spellId)
			end
		end
	end
end

function mod:AvalancheRemoved(args)
	if stage == 1 then
		if self:GetOption(avalanceMarker) then
			SetRaidTarget(args.destName, 0)
		end
	else
		self:PrimaryIcon(args.spellId, args.destName)
	end
end

function mod:TimeWarp(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:GraspofFrostStart(args)
	self:CDBar(args.spellId, 19.2)
end

do
	local playerList = mod:NewTargetList()
	function mod:GraspofFrost(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList, 2, nil, nil, 0.7)
	end
end

function mod:FreezingBlast(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, self:Mythic() and 13.4 or 10)
end

function mod:RingofIce(args)
	self:StopBar(CL.count:format(args.spellName, ringofIceCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, ringofIceCount))
	self:PlaySound(args.spellId, "long")
	ringofIceCount = ringofIceCount + 1
	self:CDBar(args.spellId, 60, CL.count:format(args.spellName, ringofIceCount))
end

-- Intermission
function mod:HowlingWindsStart()
	intermissionTime = GetTime()
end

function mod:HowlingWindsRemoved(args)
	stage = 2
	intermission = false
	icefallCount = 1
	burningExplosionCounter = 1
	local seconds = math.floor((GetTime() - intermissionTime) * 100)/100
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", L.intermission_stage2:format(seconds), false)

	self:CDBar(288212, 3.5) -- Broadside
	self:CDBar(288345, 7) -- Glacial Ray
	self:CDBar(285254, 16) -- Avalanche
	self:CDBar(288441, 32.5, CL.count:format(self:SpellName(288441), icefallCount)) -- Icefall
	self:CDBar(288374, 41.5) -- Siegebreaker Blast
end

-- Stage 2
function mod:BroadsideSucces(args)
	broadsideCount = 0
	self:CDBar(288212, self:Mythic() and 47.5 or 32) -- Broadside
end

do
	local playerList = mod:NewTargetList()
	function mod:BroadsideApplied(args)
		broadsideCount = broadsideCount + 1
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 3)
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, broadsideCount, broadsideCount))
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "warning")
		end
		if self:GetOption(broadsideMarker) then
			SetRaidTarget(args.destName, broadsideCount)
		end
	end
end

function mod:BroadsideRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(broadsideMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:SiegebreakerBlastSucces(args)
	self:Bar(args.spellId, self:Mythic() and 70 or 61)
end

function mod:SiegebreakerBlastApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:SiegebreakerBlastRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId)
	self:StopBar(args.spellId, args.destName)
end

function mod:GlacialRay(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	if self:MobId(args.sourceGUID) == 146409 then -- Jaina
		self:CDBar(args.spellId, self:Mythic() and 40 or (stage == 3 and 60 or 51.1))
	end
end

function mod:Icefall(args)
	if self:MobId(args.sourceGUID) == 146409 then -- Jaina
		self:Message2(args.spellId, "orange", CL.count:format(args.spellName, icefallCount))
		self:PlaySound(args.spellId, "long")
		icefallCount = icefallCount + 1
		self:CDBar(args.spellId, self:Mythic() and 37 or (stage == 3 and 62 or 42), CL.count:format(args.spellName, icefallCount))
	else -- Prismatic Image
		self:Message2(args.spellId, "orange")
		self:PlaySound(args.spellId, "long")
	end
end

function mod:BurningExplosion(args)
	self:Message2(args.spellId, "green", CL.count:format(CL.casting:format(args.spellName), burningExplosionCounter))
	self:PlaySound(args.spellId, "info")
	self:CastBar(args.spellId, self:Mythic() and 8 or 15, CL.count:format(args.spellName, burningExplosionCounter))
	burningExplosionCounter = burningExplosionCounter + 1
end

-- Intermission: Flash Freeze
function mod:FlashFreeze(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "green", CL.intermission, false)
	self:StopBar(288212) -- Broadside
	self:StopBar(288345) -- Glacial Ray
	self:StopBar(285254) -- Avalanche
	self:StopBar(CL.count:format(self:SpellName(288441), icefallCount)) -- Icefall
	self:StopBar(288374) -- Siegebreaker Blast
end

function mod:ArcaneBarrage(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.interrupted:format(self:SpellName(288719)), false) -- Flash Freeze Interrupted
end

function mod:ArcaneBarrageRemoved(args)
	stage = 3
	orbofFrostCount = 1
	icefallCount = 1
	crystallineDustCount = 1
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)

	self:CDBar(288619, 11.5, CL.count:format(self:SpellName(288619), orbofFrostCount)) -- Orb of Frost
	self:CDBar(288212, 20) -- Broadside
	self:CDBar(288747, 23) -- Prismatic Image
	self:CDBar(289940, 26.5) -- Crystalline Dust
	self:CDBar(288345, self:Mythic() and 49 or 49.5) -- Glacial Ray
	self:CDBar(288374, 60.5) -- Siegebreaker Blast
	self:CDBar(288441, 61.5, CL.count:format(self:SpellName(288441), icefallCount)) -- Icefall
end

do
	local playerList = mod:NewTargetList()
	function mod:HeartofFrost(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
		self:CDBar(args.spellId, 8)
	end
end

function mod:FrostNova(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:WaterBoltVolley(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 8)
end

-- Stage 3
function mod:CrystallineDust(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	crystallineDustCount = crystallineDustCount + 1
	self:CDBar(args.spellId, crystallineDustCount % 3 == 0 and 21.5 or 15.5)
end

function mod:OrbofFrost(args)
	if self:MobId(args.sourceGUID) == 146409 then -- Jaina
		self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, orbofFrostCount))
		self:PlaySound(args.spellId, "alert")
		orbofFrostCount = orbofFrostCount + 1
		self:Bar(args.spellId, 60, CL.count:format(args.spellName, orbofFrostCount))
	else
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:PrismaticImage(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, self:Mythic() and 41 or 51)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
function mod:FrozenSiege(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 31)
end

function mod:FreezingBloodApplied(args)
	if self:Me(args.destGUID) then
		local power = UnitPower("player", 10)
		if power > 74 then -- 5 players
			self:Message2(args.spellId, "blue", L.frozenblood_player:format(args.spellName, 5))
			self:PlaySound(args.spellId, "alarm")
		elseif power > 49 then -- 3 players
			self:Message2(args.spellId, "blue", L.frozenblood_player:format(args.spellName, 3))
			self:PlaySound(args.spellId, "alarm")
		else
			self:Message2(args.spellId, "blue", L.frozenblood_player:format(args.spellName, 1))
		end
		self:TargetBar(args.spellId, 6, args.destName)
	end
end

function mod:FreezingBloodRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

do
	local prev = 0
	function mod:HowlingWindsMythicApplied(args)
		local t = args.time
		if t-prev > 2  and intermission == false and stage == 1 then -- Alternates 80s after the intermission, but need to avoid triggering the first 5 seconds after it.
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "long")
			self:CDBar(args.spellId, 80)
		end
	end
end

function mod:ImageDeath(args)
	imageCount = imageCount + 1
	self:Message2(-19825, "cyan", CL.add_killed:format(imageCount, 5), false)
	self:PlaySound(-19825, imageCount == 5 and "long" or "info")
end
