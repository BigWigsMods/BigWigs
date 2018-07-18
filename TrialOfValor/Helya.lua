
--------------------------------------------------------------------------------
-- TODO List:
-- Fix/Remove untested mythic funcs:
-- MistInfusion
-- (Mythic) Update Lantarn of Darkness initial timer.
-- (Mythic) Update Fetid Rot timers
-- (Mythic) If marking Orb targets, in p3 there is double dps

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Helya-TrialOfValor", 1648, 1829)
if not mod then return end
mod:RegisterEnableMob(114537)
mod.engageId = 2008
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local taintMarkerCount = 4
local tentaclesUp = 9
local phase = 1
local orbCount = 1
local tentacleCount = 1
local tentacleMsgCount = 1
local taintCount = 1
local breathCount = 1

local timers = {
	["Tentacle Strike"] = {35.4, 4.0, 32.0, 0.0, 35.6, 4.0, 31.3, 4.0, 4.0, 27.2, 4.0}, -- furthest data we have
	["Orb of Corrosion"] = {6, 13.0, 13.0, 27.3, 10.7, 13.0, 25.0, 13.0, 13.0, 25.0, 13.0, 18.5, 19.5, 13.0, 13.0, 12.0, 12.0, 16.8, 8.2}, -- furthest data we have
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.nearTrigger = "near" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya!
	L.farTrigger = "far" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges far from Helya!
	L.tentacle_near = "Tentacle NEAR Helya"
	L.tentacle_near_desc = "This option can be used to emphasize or hide the messages when a Striking Tentacle spawns near Helya."
	L.tentacle_near_icon = 228730
	L.tentacle_far = "Tentacle FAR from Helya"
	L.tentacle_far_desc = "This option can be used to emphasize or hide the messages when a Striking Tentacle spawns far from Helya."
	L.tentacle_far_icon = 228730

	L.orb_melee = "Orb: Melee timer"
	L.orb_melee_desc = "Show the timer for the Orbs that spawn on Melee."
	L.orb_melee_icon = 229119
	L.orb_melee_bar = "Melee Orb"

	L.orb_ranged = "Orb: Ranged timer"
	L.orb_ranged_desc = "Show the timer for the Orbs that spawn on Ranged."
	L.orb_ranged_icon = 229119
	L.orb_ranged_bar = "Ranged Orb"

	L.gripping_tentacle = -14309
	L.grimelord = -14263
	L.mariner = -14278

	L.orb_say = "Orb"
	L.taint_say = "Taint"
end

--------------------------------------------------------------------------------
-- Initialization
--

local orbMarker = mod:AddMarkerOption(false, "player", 1, 229119, 1, 2, 3) -- Orb of Corruption
local taintMarker = mod:AddMarkerOption(false, "player", 4, 228054, 4, 5, 6, 7, 8) -- Taint of the Sea
function mod:GetOptions()
	return {
		--[[ Helya ]]--
		"stages",
		"berserk",
		{229119, "SAY", "FLASH"}, -- Orb of Corruption
		"orb_melee",
		"orb_ranged",
		orbMarker,
		227967, -- Bilewater Breath
		227992, -- Bilewater Liquefaction
		{227982, "TANK"}, -- Bilewater Redox
		228730, -- Tentacle Strike
		"tentacle_near",
		"tentacle_far",
		{228054, "SAY"}, -- Taint of the Sea
		taintMarker,
		228872, -- Corrossive Nova
		230197, -- Dark Waters

		--[[ Stage Two: From the Mists ]]--
		228300, -- Fury of the Maw
		167910, -- Kvaldir Longboat

		--[[ Grimelord ]]--
		228390, -- Sludge Nova
		{193367, "SAY", "FLASH", "PROXIMITY"}, -- Fetid Rot
		228519, -- Anchor Slam

		--[[ Night Watch Mariner ]]--
		228619, -- Lantern of Darkness
		228633, -- Give No Quarter
		{228611, "TANK"}, -- Ghostly Rage

		--[[ Decaying Minion ]]--
		228127, -- Decay

		--[[ Helarjer Mistcaller ]]--
		228854, -- Mist Infusion

		--[[ Stage Three: Helheim's Last Stand ]]--
		{230267, "SAY", "FLASH"}, -- Orb of Corrosion
		228565, -- Corrupted Breath
		{232488, "TANK"}, -- Dark Hatred
		{232450, "HEALER"}, -- Corrupted Axiom
	},{
		["stages"] = -14213, -- Helya
		[228300] = -14222, -- Stage Two: From the Mists
		[228390] = -14263, -- Grimelord
		[228619] = -14278, -- Night Watch Mariner
		[228127] = -14223, -- Decaying Minion
		[228854] = -14544, -- Helarjer Mistcaller
		[230267] = -14224, -- Stage Three: Helheim's Last Stand
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("RAID_BOSS_WHISPER")

	--[[ Helya ]]--
	self:Log("SPELL_CAST_START", "OrbOfCorruption", 227903)
	self:Log("SPELL_AURA_APPLIED", "OrbApplied", 229119)
	self:Log("SPELL_AURA_REMOVED", "OrbRemoved", 229119)
	self:Log("SPELL_DAMAGE", "OrbDamage", 227930)
	self:Log("SPELL_MISSED", "OrbDamage", 227930)
	self:Log("SPELL_AURA_APPLIED", "TaintOfTheSea", 228054)
	self:Log("SPELL_AURA_REMOVED", "TaintOfTheSeaRemoved", 228054)
	self:Log("SPELL_CAST_START", "BilewaterBreath", 227967)
	self:Log("SPELL_AURA_APPLIED", "BilewaterRedox", 227982)
	self:Log("SPELL_CAST_START", "TentacleStrike", 228730)
	self:Log("SPELL_CAST_START", "CorrossiveNova", 228872)

	self:Log("SPELL_AURA_APPLIED", "DarkWatersDamage", 230197)
	self:Log("SPELL_PERIODIC_DAMAGE", "DarkWatersDamage", 230197)
	self:Log("SPELL_PERIODIC_MISSED", "DarkWatersDamage", 230197)

	--[[ Stage Two: From the Mists ]]--
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheMaw", 228300)
	self:Log("SPELL_AURA_REMOVED", "FuryOfTheMawRemoved", 228300)
	self:Log("SPELL_AURA_REMOVED", "KvaldirLongboat", 167910) -- Add Spawn

	--[[ Grimelord ]]--
	self:Log("SPELL_CAST_START", "SludgeNova", 228390)
	self:Log("SPELL_AURA_APPLIED", "FetidRot", 193367)
	self:Log("SPELL_AURA_REMOVED", "FetidRotRemoved", 193367)
	self:Log("SPELL_CAST_START", "AnchorSlam", 228519)
	self:Death("GrimelordDeath", 114709)

	--[[ Night Watch Mariner ]]--
	self:Log("SPELL_CAST_START", "LanternOfDarkness", 228619)
	self:Log("SPELL_CAST_SUCCESS", "GiveNoQuarter", 228633)
	self:Log("SPELL_CAST_SUCCESS", "GhostlyRage", 228611)
	self:Death("MarinerDeath", 114809)

	--[[ Decaying Minion ]]--
	self:Log("SPELL_AURA_APPLIED", "DecayDamage", 228127)
	self:Log("SPELL_PERIODIC_DAMAGE", "DecayDamage", 228127)
	self:Log("SPELL_PERIODIC_MISSED", "DecayDamage", 228127)

	--[[ Helarjer Mistcaller ]]--
	self:Log("SPELL_CAST_START", "MistInfusion", 228854)

	--[[ Stage Three: Helheim's Last Stand ]]--
	self:Log("SPELL_CAST_START", "OrbOfCorrosion", 228056)
	self:Log("SPELL_AURA_APPLIED", "OrbApplied", 230267)
	self:Log("SPELL_AURA_REMOVED", "OrbRemoved", 230267)
	self:Log("SPELL_DAMAGE", "OrbDamage", 228063)
	self:Log("SPELL_MISSED", "OrbDamage", 228063)
	self:Log("SPELL_CAST_START", "CorruptedBreath", 228565)
	self:Log("SPELL_AURA_APPLIED", "DarkHatred", 232488)
	self:Log("SPELL_AURA_APPLIED", "CorruptedAxiom", 232450)
end

function mod:OnEngage()
	taintMarkerCount = 4
	tentaclesUp = self:Mythic() and 8 or 9
	phase = 1
	orbCount = 1
	tentacleCount = 1
	tentacleMsgCount = 1
	taintCount = 1
	breathCount = 1

	self:CDBar(227967, self:Mythic() and 10.5 or self:Heroic() and 12 or 13.3, CL.count:format(self:SpellName(227967), breathCount)) -- Bilewater Breath
	self:CDBar(228054, self:Mythic() and 15.5 or self:Heroic() and 19.5 or self:Normal() and 12 or 21.8, CL.count:format(self:SpellName(228054), taintCount)) -- Taint of the Sea
	self:CDBar("orb_ranged", self:Mythic() and 14 or self:Heroic() and 31 or self:Normal() and 18 or 34, CL.count:format(L.orb_ranged_bar, orbCount), 229119) -- Orb of Corruption
	if not self:LFR() then
		self:CDBar(228730, self:Mythic() and 35.3 or self:Heroic() and 36.7 or 53.3, CL.count:format(self:SpellName(228730), tentacleCount)) -- Tentacle Strike
	end
	if self:Mythic() then
		self:Berserk(660)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 34098 then -- ClearAllDebuffs
		phase = 2
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
		self:StopBar(CL.count:format(L.orb_ranged_bar, orbCount))
		self:StopBar(CL.count:format(L.orb_melee_bar, orbCount))
		self:StopBar(CL.count:format(self:SpellName(228054), taintCount)) -- Taint of the Sea
		self:StopBar(CL.count:format(self:SpellName(227967), breathCount)) -- Bilewater Breath
		if not self:LFR() then
			self:StopBar(CL.count:format(self:SpellName(228730), tentacleCount)) -- Tentacle Strike
		end
		self:Bar(167910, 14, CL.adds) -- Kvaldir Longboat
		self:Bar(228300, self:Mythic() and 11 or 50) -- Fury of the Maw
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	elseif spellId == 228546 then -- Helya
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
		phase = 3
		orbCount = 1
		breathCount = 1
		self:Message("stages", "Neutral", "Long", CL.stage:format(3), false)
		self:StopBar(228300) -- Fury of the Maw
		self:StopBar(CL.cast:format(self:SpellName(228300))) -- Cast: Fury of the Maw
		self:StopBar(CL.adds)
		self:Bar("orb_ranged", self:Mythic() and 6 or 15.5, CL.count:format(L.orb_ranged_bar, orbCount), 230267) -- Orb of Corrosion
		self:Bar(228565, self:Mythic() and 10 or 19.5) -- Corrupted Breath
		if not self:Mythic() then -- Taint comes instant in mythic, no need for timer.
			self:Bar(228054, 24.5) -- Taint of the Sea
		end
		self:Bar(167910, self:Mythic() and 44 or 38, self:SpellName(L.mariner)) -- Kvaldir Longboat
	elseif spellId == 228838 then -- Fetid Rot (Grimelord)
		self:Bar(193367, self:Easy() and 15.8 or 12.2) -- Fetid Rot
	end
end

function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find(L.nearTrigger) then
		self:Message("tentacle_near", "Urgent", "Long", CL.count:format(L.tentacle_near, tentacleMsgCount), 228730)
		tentacleMsgCount = tentacleMsgCount + 1
	elseif msg:find(L.farTrigger) then
		self:Message("tentacle_far", "Urgent", "Long", CL.count:format(L.tentacle_far, tentacleMsgCount), 228730)
		tentacleMsgCount = tentacleMsgCount + 1
	elseif msg:find("inv_misc_monsterhorn_03", nil, true) then -- Fallback for no locale
		msg = msg:gsub("|T[^|]+|t", "")
		self:Message(228730, "Urgent", "Long", CL.count:format(msg:format(npcname), tentacleMsgCount), 228730)
		tentacleMsgCount = tentacleMsgCount + 1
		BigWigs:Print("Missing translation for tentacle strike. Please report it on Discord/Curse/GitHub.") -- XXX temp
		BigWigs:Error(("TELL THE AUTHORS: %s"):format(msg))
	end
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find("227920") then -- P1 Orb of Corruption
		self:Message(229119, "Personal", "Warning", CL.you:format(self:SpellName(229119))) -- Orb of Corruption
		self:Say(229119, L.orb_say)
		self:Flash(229119)
	elseif msg:find("228058") then -- P2 Orb of Corrosion
		self:Message(230267, "Personal", "Warning", CL.you:format(self:SpellName(230267))) -- Orb of Corrosion
		self:Say(230267, L.orb_say)
		self:Flash(230267)
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit)*100
	if phase == 2 then
		local tentaclesLeft = self:Mythic() and floor((hp-45)/2.5) or floor((hp-40)/2.77)
		if tentaclesLeft < tentaclesUp then
			tentaclesUp = tentaclesLeft
			if tentaclesLeft >= 0 then
				self:Message("stages", "Neutral", nil, CL.mob_remaining:format(self:SpellName(L.gripping_tentacle), tentaclesLeft), false)
			else
				self:UnregisterUnitEvent(event, unit)
			end
		end
	else
		self:UnregisterUnitEvent(event, unit)
	end
end

do
	local list, orbMarked, isOnMe, timer = mod:NewTargetList(), false, false, nil

	local function warn(self, spellId, spellName)
		if not isOnMe then
			self:TargetMessage(spellId, list, "Urgent", "Warning", CL.count:format(spellName, orbCount - 1)) -- gets incremented on the cast
		else
			wipe(list)
		end
	end

	function mod:OrbApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			orbMarked, isOnMe = false, false
			timer = self:ScheduleTimer(warn, 0.4, self, args.spellId, args.spellName)
		elseif #list == 3 or (#list == 2 and self:Easy()) then -- Max
			self:CancelTimer(timer)
			timer = nil
			warn(self, args.spellId, args.spellName)
		end

		if self:GetOption(orbMarker) then
			if self:Healer(args.destName) then
				SetRaidTarget(args.destName, 1)
			elseif self:Tank(args.destName) or (phase == 3 and orbMarked) then
				SetRaidTarget(args.destName, 2)
			else -- Damager
				orbMarked = true
				SetRaidTarget(args.destName, 3)
			end
		end

		if self:Me(args.destGUID) then -- Warning and Say are in RAID_BOSS_WHISPER
			isOnMe = true
		end
	end

	function mod:OrbRemoved(args)
		if self:GetOption(orbMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:OrbOfCorruption()
	orbCount = orbCount + 1
	local timer = self:Mythic() and 24.3 or self:Heroic() and 28 or self:Normal() and 31.5 or 32.8
	if orbCount % 2 == 0 then
		self:Bar("orb_melee", timer, CL.count:format(L.orb_melee_bar, orbCount), 229119) -- Orb of Corruption
	else
		self:Bar("orb_ranged", timer, CL.count:format(L.orb_ranged_bar, orbCount), 229119) -- Orb of Corruption
	end
end

do
	local prev = 0
	function mod:OrbDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId == 228063 and 230267 or 229119, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:BilewaterBreath(args)
	self:Message(args.spellId, "Important", "Alarm", CL.count:format(args.spellName, breathCount))
	self:CastBar(args.spellId, 3, CL.count:format(args.spellName, breathCount))
	self:CastBar(227992, self:Easy() and 25.5 or 20.5) -- Bilewater Liquefaction
	breathCount = breathCount + 1
	self:CDBar(args.spellId, self:Mythic() and 42.5 or self:Heroic() and 52 or self:Normal() and 55.9 or 60.8, CL.count:format(args.spellName, breathCount))
end

function mod:BilewaterRedox(args)
	if self:Tank(args.destName) then -- others might get hit, only tank is relevant
		self:TargetMessage(args.spellId, args.destName, "Urgent", not self:Me(args.destGUID) and "Alarm", nil, nil, true)
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

do
	local list, timer = mod:NewTargetList(), nil
	function mod:TaintOfTheSea(args)
		list[#list+1] = args.destName
		if #list == 1 then
			taintMarkerCount = 4
			timer = self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Attention", "Alert", CL.count:format(args.spellName, taintCount), nil, self:Dispeller("magic"))
			taintCount = taintCount + 1
			self:CDBar(args.spellId, phase == 1 and (self:LFR() and 17 or 12.1) or (self:Mythic() and 20 or 28), CL.count:format(args.spellName, taintCount))
		elseif #list == 5 or (#list == 3 and not self:Mythic()) then
			self:CancelTimer(timer)
			timer = nil
			self:TargetMessage(args.spellId, list, "Attention", "Alert", CL.count:format(args.spellName, taintCount-1), nil, self:Dispeller("magic"))
		end

		if self:GetOption(taintMarker) then
			SetRaidTarget(args.destName, taintMarkerCount)
			taintMarkerCount = taintMarkerCount + 1
			if taintMarkerCount > 8 then taintMarkerCount = 4 end
		end
	end

	local prev, wasOnMe, scheduled = 0, nil, nil

	local function warn(self, spellId, spellName)
		self:Message(spellId, "Positive", "Warning", wasOnMe and CL.underyou:format(spellName) or CL.near:format(spellName))
		wasOnMe = nil
		scheduled = nil
	end

	function mod:TaintOfTheSeaRemoved(args)
		local t = GetTime()
		if self:Me(args.destGUID) then -- warn always if it got dispelled from us
			prev = t
			wasOnMe = true
			self:Say(args.spellId, L.taint_say)
			if not scheduled then
				scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId, args.spellName)
			end
		elseif IsItemInRange(33278, args.destName) and t-prev > 2 then -- warn if dispelled in ~8yd range
			prev = t
			if not scheduled then
				scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId, args.spellName)
			end
		end
		if self:GetOption(taintMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:TentacleStrike(args)
	-- Message is in RAID_BOSS_EMOTE
	self:CastBar(args.spellId, 6,CL.count:format(args.spellName, tentacleCount))
	tentacleCount = tentacleCount + 1
	self:Bar(args.spellId, self:Mythic() and timers["Tentacle Strike"][tentacleCount] or 40, CL.count:format(self:SpellName(228730), tentacleCount))
end

do
	local prev = 0
	function mod:CorrossiveNova(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Important", self:Tank() and "Long")
		end
	end
end

do
	local prev = 0
	function mod:DarkWatersDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:FuryOfTheMaw(args)
	self:Message(args.spellId, "Important", "Info")
	self:CastBar(args.spellId, self:Mythic() and 24 or 32)
end

function mod:FuryOfTheMawRemoved(args)
	self:Message(args.spellId, "Important", nil, CL.over:format(args.spellName))
	self:Bar(args.spellId, 44.5)
end

do
	local prev = 0

	function mod:KvaldirLongboat(args)
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Neutral", "Long", phase == 2 and CL.adds or args.destName) -- destName = name of the spawning add
		end

		if phase == 2 then
			self:Bar(args.spellId, 75, CL.adds)
		else
			self:Bar(args.spellId, 71.5, self:SpellName(L.mariner))
		end

		if self:MobId(args.destGUID) == 114809 then -- Mariner
			self:Bar(228633, 7) -- Give No Quarter
			self:Bar(228611, 10) -- Ghostly Rage
			if not self:Easy() then
				self:Bar(228619, phase == 2 and 30 or 35) -- Lantern of Darkness
			end
		elseif self:MobId(args.destGUID) == 114709 then -- Grimelord
			self:Bar(193367, 7) -- Fetid Rot
			if not self:LFR() then
				self:Bar(228519, 12) -- Anchor Slam
			end
			self:Bar(228390, self:Easy() and 17 or 14) -- Sludge Nova
		end
	end
end

--[[ Grimelord ]]--
function mod:SludgeNova(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 3)
	self:Bar(args.spellId, 24.3)
end

do
	local proxList, isOnMe = {}, nil

	function mod:FetidRot(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, expires = self:UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
			self:SayCountdown(args.spellId, t)
			self:OpenProximity(args.spellId, 5)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 5, proxList)
		end
	end

	function mod:FetidRotRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
			self:CancelSayCountdown(args.spellId)
		end

		tDeleteItem(proxList, args.destName)

		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 5, proxList)
			end
		end
	end
end

function mod:AnchorSlam(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, self:Normal() and 14.6 or 12)
end

function mod:GrimelordDeath()
	if not self:LFR() then
		self:StopBar(228519) -- Anchor Slam
	end
	self:StopBar(228390) -- Sludge Nova
	self:StopBar(CL.cast:format(self:SpellName(228390))) -- Sludge Nova
	self:StopBar(193367) -- Fetid Rot
end

--[[ Night Watch Mariner ]]--
function mod:LanternOfDarkness(args)
	self:Message(args.spellId, "Important", "Long")
	self:CastBar(args.spellId, 7)
end

function mod:GiveNoQuarter(args)
	self:Message(args.spellId, "Attention", self:Ranged() and "Alert")
	self:Bar(args.spellId, self:Easy() and 9.3 or 6.1)
end

function mod:GhostlyRage(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if unit and UnitDetailedThreatSituation("player", unit) then
		self:Message(args.spellId, "Urgent", "Long", CL.on:format(args.spellName, args.sourceName))
	end
	self:Bar(args.spellId, 9.7)
end

function mod:MarinerDeath()
	self:StopBar(228633) -- Give No Quarter
	if not self:Easy() then
		self:StopBar(228619) -- Lantern of Darkness
		self:StopBar(CL.cast:format(self:SpellName(228619))) -- Lantern of Darkness
	end
	self:StopBar(228611) -- Ghostly Rage
end

--[[ Decaying Minion ]]--
do
	local prev = 0
	function mod:DecayDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Helarjer Mistcaller ]]--
do
	local prev = 0
	function mod:MistInfusion(args)
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Positive", self:Interrupter(args.sourceGUID) and "Info")
		end
	end
end

--[[ Stage Three: Helheim's Last Stand ]]--

function mod:OrbOfCorrosion()
	orbCount = orbCount + 1
	if orbCount % 2 == 0 then
		self:Bar("orb_melee", self:Mythic() and timers["Orb of Corrosion"][orbCount] or 18, CL.count:format(L.orb_melee_bar, orbCount), 230267) -- Orb of Corruption
	else
		self:Bar("orb_ranged", self:Mythic() and timers["Orb of Corrosion"][orbCount] or 18, CL.count:format(L.orb_ranged_bar, orbCount), 230267) -- Orb of Corruption
	end
end

function mod:CorruptedBreath(args)
	self:Message(args.spellId, "Important", "Alarm", CL.count:format(args.spellName, breathCount))
	self:CastBar(args.spellId, 4.5, CL.count:format(args.spellName, breathCount))
	breathCount = breathCount + 1
	self:Bar(args.spellId, self:Mythic() and 43 or self:Heroic() and 47 or 51, CL.count:format(args.spellName, breathCount))
end

function mod:DarkHatred(args)
	if self:Tank(args.destName) then -- others might get hit, only tank is relevant
		self:TargetMessage(args.spellId, args.destName, "Urgent", not self:Me(args.destGUID) and "Alarm", nil, nil, true)
		self:TargetBar(args.spellId, 12, args.destName)
	end
end

do
	local list, isOnMe = mod:NewTargetList(), nil

	local function warn(self, spellId)
		if not isOnMe then
			if #list < 6 then -- If the pools don't get soaked, everyone gets a debuff
				self:TargetMessage(spellId, list, "Attention", "Long", nil, nil, true)
			else
				self:Message(spellId, "Attention", "Long")
			end
		end
		isOnMe = nil
	end

	function mod:CorruptedAxiom(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer(warn, 0.1, self, args.spellId)
		end

		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Long")
			isOnMe = true
		end
	end
end
