
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

local isPakusAspectDead = nil
local kragwasWrathCount = 0
local bossesKilled = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
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

		-- Kimbul's Aspect
		{282444, "TANK"}, -- Lacerating Claws
		{282447, "SAY", "FLASH"}, -- Kimbul's Wrath
		kimbulsWrathMarker,

		-- Akunda's Aspect
		282411, -- Thundering Storm
		285879, -- Mind Wipe
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
	self:Log("SPELL_AURA_APPLIED", "CrawlingHexApplied", 282135)
	self:Log("SPELL_AURA_REMOVED", "CrawlingHexRemoved", 282135)
	self:Log("SPELL_CAST_SUCCESS", "WildMaul", 285893)
	self:Log("SPELL_AURA_APPLIED", "MarkofPrey", 282209)

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
end

function mod:OnEngage()
	isPakusAspectDead = nil
	kragwasWrathCount = 0
	bossesKilled = 0
	self:Bar(282098, 5) -- Gift of Wind
	self:CDBar(282135, 13) -- Crawling Hex
	self:CDBar(285893, 17) -- Wild Maul
	self:Bar(282155, 31) -- Gonk's Wrath
	self:Bar(282107, 73) -- Pa'ku's Wrath
	if not self:Easy() then
		self:CDBar(282636, 29) -- Krag'wa's Wrath
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 130966 then -- Permanent Feign Death
		bossesKilled = bossesKilled + 1
		self:Message2("stages", "cyan", L.killed:format(self:UnitName(unit)), false)
		self:PlaySound("stages", "info")

		-- Stop bars
		local mobId = self:MobId(UnitGUID(unit))
		if mobId == 144747 then -- Pa'ku's Aspect
			isPakusAspectDead = true
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
			self:Bar(282444, 20.5) -- Lacerating Claws
			self:CDBar(282447, 45, L.leap) -- Kimbul's Wrath XXX check this
		elseif bossesKilled == 2 then -- Akunda spawning
			self:Bar(285879, 5) -- Mind Wipe
			self:Bar(282411, 16) -- Thundering Storm
			self:CDBar(286811, 20) -- Akunda's Wrath XXX check this
		end
	elseif spellId == 283193 then -- Crawling Hex
		self:CrawlingHexSuccess()
	end
end

function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find("282107", nil, true) then -- Pa'ku's Wrath
		self:Message2(282107, "red")
		self:PlaySound(282107, "warning")
		self:Bar(282107, isPakusAspectDead and 60 or 70)
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
	if amount % 5 == 1 and amount > 12 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

do
	local playerList, isOnMe, proxList = mod:NewTargetList(), false, {}

	function mod:CrawlingHexSuccess()
		wipe(proxList)
		isOnMe = false
		self:Message2(282135, "orange")
		self:PlaySound(282135, "alarm")
		self:Bar(282135, 25.5)
	end

	local function warn()
		if not isOnMe then
			mod:TargetsMessage(282135, "orange", playerList, #playerList) -- Crawling Hex
			mod:OpenProximity(282135, 8, proxList)
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
			self:TargetMessage2(args.spellId, "blue", args.destName, CL.count_icon:format(args.spellName, count, count))
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:Flash(args.spellId, count)
			self:SayCountdown(args.spellId, 6, count)
			self:OpenProximity(args.spellId, 10)
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
			self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
			isOnMe = false
			self:CancelSayCountdown(args.spellId)
			self:CloseProximity(args.spellId)
		end

		if self:GetOption(crawlingHexMarker) then
			SetRaidTarget(args.destName, 0)
		end

		tDeleteItem(proxList, args.destName)

		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else -- Update proximity
				self:OpenProximity(args.spellId, 8, proxList)
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
			self:Bar(282155, 60) -- Gonk's Wrath
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
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
		if not isOnMe then
			if isNearMe then
				self:Message2(282447, "orange", CL.near:format(L.leap))
				self:PlaySound(282447, "alert")
				self:Flash(282447)
			else
				self:Message2(282447, "yellow", L.leap)
			end
		end
		self:Bar(282447, 60, L.leap)
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
			self:PlaySound(args.spellId, "alert")
		end

		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList)

		if self:Dispeller("magic", nil, args.spellId) then
				self:PlaySound(args.spellId, "alert")
		end

		if self:GetOption(mindWipeMarker) and #playerList < 6 then
			SetRaidTarget(args.destName, #playerList)
		end
	end

	function mod:MindWipeRemoved(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, "removed", "green")
			self:PlaySound(args.spellId, "info")
		end
		if self:GetOption(mindWipeMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:AkundasWrathApplied(args)
	self:Bar(args.spellId, 60)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:AkundasWrathRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "removed", "green")
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:KragwasWrath(args)
	kragwasWrathCount = (kragwasWrathCount + 1) % 4
	self:Bar(args.spellId, kragwasWrathCount == 0 and 40 or 3, L.count_of:format(args.spellName, kragwasWrathCount + 1, 4))
end
