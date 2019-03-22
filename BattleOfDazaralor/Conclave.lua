
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Conclave of the Chosen", 2070, 2330)
if not mod then return end
mod:RegisterEnableMob(144747, 144767, 144963, 144941) -- Pa'ku's Aspect, Gonk's Aspect, Kimbul's Aspect, Akunda's Aspect
mod.engageId = 2268
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local kragwasWrathCount = 0
local bossesKilled = 0
local spawnCooldown = 0
local lastBossKillTime = 0
local lastBossKillSpawnCooldown = 0
local lastBossKillNextAspect = 0
local lastWrathBarTime = 0
local lastWrathBar = {}

-- Offset between aspect spawn time and wrath
local wrathOffset = {
	 [282155] = 1,  -- Gonk
	 [282107] = 13,  -- Paku
	 [286811] = 1,  -- Kimbul
	 [282447] = 1,  -- Akunda
 }

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fixate_plates = "Mark of Prey icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = 282209
	L.killed = "%s killed!"
	L.count_of = "%s (%d/%d)"
	L.leap = mod:SpellName(192553) -- Leap, replacement for Kimbul's Wrath
end

--------------------------------------------------------------------------------
-- Initialization
--

local crawlingHexMarker = mod:AddMarkerOption(false, "player", 1, 282135, 1, 2, 3, 4, 5) -- Crawling Hex
local kimbulsWrathMarker = mod:AddMarkerOption(false, "player", 8, 282447, 8, 7, 6, 5) -- Kimbul's Wrath
local mindWipeMarker = mod:AddMarkerOption(false, "player", 1, 285879, 1, 2, 3, 4, 5) -- Mind Wipe
function mod:GetOptions()
	return {
		-- General
		"stages",
		282079, -- Loa's Pact

		-- Pa'ku's Aspect
		282098, -- Gift of Wind
		{285945, "TANK"}, -- Hastening Winds
		282107, -- Pa'ku's Wrath

		-- Gonk's Aspect
		{282135, "SAY", "SAY_COUNTDOWN", "FLASH", "PROXIMITY"}, -- Crawling Hex
		crawlingHexMarker,
		285893, -- Wild Maul
		282155, -- Gonk's Wrath
		{282209, "SAY", "FLASH"}, -- Mark of Prey
		"custom_on_fixate_plates",

		-- Kimbul's Aspect
		{282444, "TANK"}, -- Lacerating Claws
		{282447, "SAY", "FLASH"}, -- Kimbul's Wrath
		kimbulsWrathMarker,

		-- Akunda's Aspect
		282411, -- Thundering Storm
		{285879, "DISPEL"}, -- Mind Wipe
		mindWipeMarker,
		{286811, "SAY", "SAY_COUNTDOWN"}, -- Akunda's Wrath

		-- Krag'wa
		282636, -- Krag'wa's Wrath
	}, {
		["stages"] = CL.general,
		[282098] = -19929, -- Pa'ku's Apsect
		[282135] = -19930, -- Gonk
		[282444] = -19931, -- Kimbul
		[282411] = -19932, -- Akunda
		[282636] = -19193, -- Krag'wa
		--[] = -19195, -- Bwonsamdi
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:Log("SPELL_AURA_APPLIED", "LoasPact", 282079)

	-- Pa'ku's Aspect
	self:Log("SPELL_CAST_START", "GiftofWind", 282098)
	self:Log("SPELL_AURA_APPLIED", "HasteningWinds", 285945)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HasteningWinds", 285945)

	-- Gonk's Aspect
	self:Log("SPELL_AURA_APPLIED", "CrawlingHexApplied", 290573, 282135) -- LFR, others
	self:Log("SPELL_AURA_REMOVED", "CrawlingHexRemoved", 290573, 282135) -- LFR, others
	self:Log("SPELL_CAST_SUCCESS", "WildMaul", 285893)
	self:Log("SPELL_AURA_APPLIED", "MarkofPrey", 282209)
	self:Log("SPELL_AURA_REMOVED", "MarkofPreyRemoved", 282209)

	-- Kimbul's Aspect
	self:Log("SPELL_CAST_START", "LaceratingClaws", 289560)
	self:Log("SPELL_AURA_APPLIED", "LaceratingClawsApplied", 282444)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LaceratingClawsApplied", 282444)
	self:Log("SPELL_AURA_APPLIED", "KimbulsWrathApplied", 282834)
	self:Log("SPELL_AURA_REMOVED", "KimbulsWrathRemoved", 282834)

	-- Akunda's Aspect
	self:Log("SPELL_CAST_START", "ThunderingStorm", 282411)
	self:Log("SPELL_CAST_START", "MindWipe", 285878)
	self:Log("SPELL_AURA_APPLIED", "MindWipeApplied", 285879)
	self:Log("SPELL_AURA_REMOVED", "MindWipeRemoved", 285879)
	self:Log("SPELL_AURA_APPLIED", "AkundasWrathApplied", 286811)
	self:Log("SPELL_AURA_REMOVED", "AkundasWrathRemoved", 286811)

	-- Krag'wa
	self:Log("SPELL_CAST_SUCCESS", "KragwasWrath", 282636)

	if self:GetOption("custom_on_fixate_plates") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	kragwasWrathCount = 0
	bossesKilled = 0
	spawnCooldown = 30
	lastBossKillTime = 0
	lastBossKillSpawnCooldown = 0
	lastBossKillNextAspect = 0
	lastWrathBarTime = 0
	lastWrathBar = { 
		[282155] = GetTime(),  -- Gonk
		[282107] = 0,  -- Paku
		[282447] = 0,  -- Kimbul
		[286811] = 0,  -- Akunda 
	}

	self:Bar(282098, 5) -- Gift of Wind
	self:CDBar(282135, 13) -- Crawling Hex
	self:CDBar(285893, 17) -- Wild Maul
	if not self:Easy() then
		self:CDBar(282636, 29) -- Krag'wa's Wrath
	end
	self:CDBar(282155, spawnCooldown)  -- Gonk always spawns first
end

function mod:OnBossDisable()
	if self:GetOption("custom_on_fixate_plates") then
		self:HidePlates()
	end
end

function mod:NextAspect()
	local aspect = 0
	local last = GetTime()
	if lastWrathBar[282155] < last then -- Gonk
		aspect = 282155
		last = lastWrathBar[282155]
	end
	if lastWrathBar[282107] < last then -- Paku
		aspect = 282107
		last = lastWrathBar[282107]
	end
	if bossesKilled >= 1 then
		if lastWrathBar[282447] < last then -- Kimbul
			aspect = 282447
			last = lastWrathBar[282447]
		end
	end
	if bossesKilled >= 2 then
		if lastWrathBar[286811] < last then -- Akunda 
			aspect = 286811
			last = lastWrathBar[286811]
		end
	end
	return aspect
end

function mod:NextWrathCDBar(spellId)
	local now = GetTime()
	if now < lastWrathBarTime + 1.5 then return end
	lastWrathBarTime = now
	local offset = -wrathOffset[spellId]
	if lastBossKillTime > now + offset then
		-- If the last boss was killed between the aspect spawn and the wrath, 
		-- reconstruct the situation at spawn time.
		offset = offset + wrathOffset[lastBossKillNextAspect]
		self:CDBar(lastBossKillNextAspect, lastBossKillSpawnCooldown + offset) -- SetOption:282107,282155,282447,286811:::
		lastWrathBar[lastBossKillNextAspect] = now
	else
		local nextAspect = self:NextAspect()
		offset = offset + wrathOffset[nextAspect]
		self:CDBar(nextAspect, spawnCooldown + offset) -- SetOption:282107,282155,282447,286811:::
		lastWrathBar[nextAspect] = now
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 130966 then -- Permanent Feign Death
		-- Snapshot state at kill time.
		lastBossKillTime = GetTime()
		lastBossKillSpawnCooldown = spawnCooldown
		lastBossKillNextAspect = self:NextAspect()
		
		bossesKilled = bossesKilled + 1
		self:Message2("stages", "cyan", L.killed:format(self:UnitName(unit)), false)
		self:PlaySound("stages", "info")

		-- Stop bars
		local mobId = self:MobId(UnitGUID(unit))
		if mobId == 144747 then -- Pa'ku's Aspect
			self:StopBar(282098) -- Gift of Wind
		elseif mobId == 144767 then -- Gonk's Aspect
			self:StopBar(282135) -- Crawling Hex
			self:StopBar(285893) -- Wild Maul
		elseif mobId == 144963 then -- Kimbul's Aspect
			-- soon?
		elseif mobId == 144941 then -- Akunda's Aspect
			self:StopBar(285879) -- Mind Wipe
			self:StopBar(282411) -- Thundering Storm
		end

		-- Start bars
		if bossesKilled == 1 then -- Kimbul spawning
			spawnCooldown = 20
			self:Bar(282444, 20.5) -- Lacerating Claws
		elseif bossesKilled == 2 then -- Akunda spawning
			spawnCooldown = 15
			self:Bar(285879, 5) -- Mind Wipe
			self:Bar(282411, 16) -- Thundering Storm
		end
	elseif spellId == 283193 then -- Crawling Hex
		self:CrawlingHexSuccess()
	end
end

function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find("282107", nil, true) then -- Pa'ku's Wrath
		self:Message2(282107, "red")
		self:PlaySound(282107, "warning")
		self:NextWrathCDBar(282107)
	end
end

function mod:LoasPact(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:GiftofWind(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 32)
end

function mod:HasteningWinds(args)
	local amount = args.amount or 1
	if amount % 5 == 0 and amount > 12 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

do
	local playerList, isOnMe, proxList = mod:NewTargetList(), false, {}

	function mod:CrawlingHexSuccess()
		wipe(proxList)
		isOnMe = false
		self:Bar(282135, 25.5)
	end

	local function warn()
		if not isOnMe then
			mod:TargetsMessage(282135, "orange", playerList, #playerList) -- Crawling Hex
			mod:OpenProximity(282135, 8, proxList)
			if mod:Dispeller("curse") then
				mod:PlaySound(282135, "alarm", nil, playerList)
			end
		else
			wipe(playerList)
		end
	end

	function mod:CrawlingHexApplied(args)
		if #playerList >= 8 then return end -- Avoid spam if something goes wrong

		playerList[#playerList+1] = args.destName
		local count = #playerList
		if self:Me(args.destGUID) then
			isOnMe = true
			self:TargetMessage2(282135, "blue", args.destName, CL.count_icon:format(args.spellName, count, count))
			self:PlaySound(282135, "warning")
			self:Say(282135, CL.count_rticon:format(args.spellName, count, count))
			self:Flash(282135, count)
			self:SayCountdown(282135, 5, count)
			self:OpenProximity(282135, 8)
		end

		proxList[#proxList+1] = args.destName

		if count == 1 then
			self:SimpleTimer(warn, 0.3)
		end

		if self:GetOption(crawlingHexMarker) and count < 6 then
			SetRaidTarget(args.destName, count)
		end
	end

	function mod:CrawlingHexRemoved(args)
		if self:Me(args.destGUID) then
			self:Message2(282135, "green", CL.removed:format(args.spellName))
			self:PlaySound(282135, "info")
			isOnMe = false
			self:CancelSayCountdown(282135)
			self:CloseProximity(282135)
		end

		if self:GetOption(crawlingHexMarker) then
			SetRaidTarget(args.destName, 0)
		end

		tDeleteItem(proxList, args.destName)

		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(282135)
			else -- Update proximity
				self:OpenProximity(282135, 8, proxList)
			end
		end
	end
end

function mod:WildMaul(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 16)
end

do
	local prev = 0
	function mod:MarkofPrey(args)
		-- Gonk's Wrath isn't in the combat log
		-- Instead, throttle the debuff that the raptors apply immediately
		local t = args.time
		if t-prev > 58 then
			prev = t
			self:Message2(282155, "cyan") -- Gonk's Wrath
			self:PlaySound(282155, "info") -- Gonk's Wrath
			self:NextWrathCDBar(282155)
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Flash(args.spellId)
			self:Say(args.spellId)
			if self:GetOption("custom_on_fixate_plates") then
				self:AddPlateIcon(args.spellId, args.sourceGUID)
			end
		end
	end
end

function mod:MarkofPreyRemoved(args)
	if self:Me(args.destGUID) and self:GetOption("custom_on_fixate_plates") then
		self:RemovePlateIcon(args.spellId, args.sourceGUID)
	end
end

function mod:LaceratingClaws(args)
	self:CDBar(282444, 20.5) -- Lacerating Claws
end

function mod:LaceratingClawsApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

do
	local scheduled, isOnMe, isNearMe, count = nil, nil, nil, 0

	local function leapWarn(self)
		if not isOnMe and not mod:CheckOption(282447, "ME_ONLY") then
			if isNearMe then
				self:Message2(282447, "orange", CL.near:format(L.leap))
				self:PlaySound(282447, "alert")
			else
				self:Message2(282447, "yellow", L.leap)
			end
		end
		self:NextWrathCDBar(286811)
		scheduled = nil
		isOnMe = nil
		isNearMe = nil
		count = 0
	end

	function mod:KimbulsWrathApplied(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Message2(282447, "blue", CL.you:format(L.leap))
			self:PlaySound(282447, "warning")
			self:Flash(282447)
			self:Say(282447, L.leap)
		end
		count = count + 1
		if self:GetOption(kimbulsWrathMarker) and count < 5 then
			SetRaidTarget(args.destName, 9-count)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(leapWarn, 0.1, self)
		end
		isNearMe = isNearMe or IsItemInRange(37727, args.destName) -- 5yd
	end

	function mod:KimbulsWrathRemoved(args)
		if self:GetOption(kimbulsWrathMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:ThunderingStorm(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 18.5)
end

do
	local playerList = mod:NewTargetList()

	function mod:MindWipe(args)
		self:CDBar(285879, 30.5)
	end

	function mod:MindWipeApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			if not self:Dispeller("magic", nil, args.spellId) then -- Don't play twice if it's on you and you're a dispeller
				self:PlaySound(args.spellId, "alert")
			end
		end

		playerList[#playerList+1] = args.destName

		if self:GetOption(mindWipeMarker) and #playerList < 6 then
			SetRaidTarget(args.destName, #playerList)
		end

		if self:Dispeller("magic", nil, args.spellId) then
			self:TargetsMessage(args.spellId, "yellow", playerList)
			self:PlaySound(args.spellId, "alert", nil, playerList)
		end
	end

	function mod:MindWipeRemoved(args)
		if self:Me(args.destGUID) then
			self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
		if self:GetOption(mindWipeMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:AkundasWrathApplied(args)
	self:NextWrathCDBar(282447)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:AkundasWrathRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "removed")
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:KragwasWrath(args)
	kragwasWrathCount = (kragwasWrathCount + 1) % 4
	self:Bar(args.spellId, kragwasWrathCount == 0 and 40 or 3, L.count_of:format(args.spellName, kragwasWrathCount + 1, 4))
end
