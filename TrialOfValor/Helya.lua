
--------------------------------------------------------------------------------
-- TODO List:
-- - Tentacle Strike: Tentacle spawns in the front or in the back. Sadly they
--   aren't using different spellIds, so we have to use RAID_BOSS_EMOTE.
--   Check if it's needed on live.
-- - Fix double warning for Orb of Corruption (RAID_BOSS_WHISPER & _AURA_APPLIED)
--   RBW is a little bit faster.
-- - TentacleDeath doesnt work - they don't die.
--   They cast 163877 (Tentacle Death) instead, but only in USCS not in CLEU.
--   Something is damaging her in the phase - find out what spell it is.

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Helya-TrialOfValor", 1114, 1829)
if not mod then return end
mod:RegisterEnableMob(114537)
mod.engageId = 2008
mod.respawnTime = 5

--------------------------------------------------------------------------------
-- Locals
--

local taintMarkerCount = 4
local tentaclesUp = 9
local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.near = "near" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya!
	L.tentacle_near = "Tentacle NEAR Helya"
	L.tentacle_far = "Tentacle FAR from Helya"

	L.grimelord = -14263
	L.mariner = -14278
end

--------------------------------------------------------------------------------
-- Initialization
--

local orbMarker = mod:AddMarkerOption(false, "player", 1, 229119, 1, 2, 3) -- Orb of Corruption
local taintMarker = mod:AddMarkerOption(false, "player", 4, 228054, 4, 5, 6) -- Taint of the Sea
function mod:GetOptions()
	return {
		--[[ Helya ]]--
		"stages",
		{229119, "SAY"}, -- Orb of Corruption
		orbMarker,
		227967, -- Bilewater Breath
		227992, -- Bilewater Liquefaction
		228730, -- Tentacle Strike
		{228054, "SAY"}, -- Taint of the Sea
		taintMarker,
		228872, -- Corrossive Nova

		--[[ Stage Two: From the Mists ]]--
		228300, -- Fury of the Maw
		167910, -- Kvaldir Longboat

		--[[ Grimelord ]]--
		228390, -- Sludge Nova
		{193367, "SAY", "FLASH"}, -- Fetid Rot
		228519, -- Anchor Slam

		--[[ Night Watch Mariner ]]--
		228619, -- Lantern of Darkness

		--[[ Stage Three: Helheim's Last Stand ]]--
		{230267, "SAY"}, -- Orb of Corrosion
		228565, -- Corrupted Breath
	},{
		["stages"] = -14213, -- Helya
		[228300] = -14222, -- Stage Two: From the Mists
		[228390] = -14263, -- Grimelord
		[228619] = -14278, -- Night Watch Mariner
		-- -14223, -- Decaying Minion
		-- -14544, -- Helarjer Mistcaller
		[230267] = -14224, -- Stage Three: Helheim's Last Stand
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("RAID_BOSS_WHISPER")

	--[[ Helya ]]--
	self:Log("SPELL_CAST_START", "OrbOfCorruption", 227903)
	self:Log("SPELL_AURA_APPLIED", "OrbOfCorruptionApplied", 229119)
	self:Log("SPELL_DAMAGE", "OrbDamage", 227930)
	self:Log("SPELL_MISSED", "OrbDamage", 227930)
	self:Log("SPELL_AURA_APPLIED", "TaintOfTheSea", 228054)
	self:Log("SPELL_CAST_START", "BilewaterBreath", 227967)
	self:Log("SPELL_CAST_START", "TentacleStrike", 228730)
	self:Log("SPELL_CAST_START", "CorrossiveNova", 228872)

	--[[ Stage Two: From the Mists ]]--
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheMaw", 228300)
	self:Log("SPELL_AURA_REMOVED", "FuryOfTheMawRemoved", 228300)
	self:Death("TentacleDeath", 114900)
	self:Log("SPELL_AURA_REMOVED", "KvaldirLongboat", 167910) -- Add Spawn

	--[[ Grimelord ]]--
	self:Log("SPELL_CAST_START", "SludgeNova", 228390)
	self:Log("SPELL_AURA_APPLIED", "FetidRot", 193367)
	self:Log("SPELL_AURA_REMOVED", "FetidRotRemoved", 193367)
	self:Log("SPELL_CAST_START", "AnchorSlam", 228519)

	--[[ Night Watch Mariner ]]--
	self:Log("SPELL_CAST_START", "LanternOfDarkness", 228619)

	--[[ Stage Three: Helheim's Last Stand ]]--
	self:Log("SPELL_AURA_APPLIED", "OrbOfCorrosion", 230267)
	self:Log("SPELL_CAST_START", "CorruptedBreath", 228565)
end

function mod:OnEngage()
	taintMarkerCount = 4
	tentaclesUp = 9
	phase = 1
	self:Bar(227967, 12) -- Bilewater Breath
	self:Bar(228054, 19.5) -- Taint of the Sea
	self:Bar(229119, 31) -- Orb of Corruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 34098 then -- ClearAllDebuffs
		phase = 2
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
		self:StopBar(229119) -- Orb of Corruption
		self:StopBar(228054) -- Taint of the Sea
		self:StopBar(227967) -- Bilewater Breath
		self:Bar(167910, 14, CL.adds) -- Kvaldir Longboat
		self:Bar(228300, 50) -- Fury of the Maw
	elseif spellId == 228546 then -- Helya
		phase = 3
		self:Message("stages", "Neutral", "Long", CL.stage:format(3), false)
		self:StopBar(228300) -- Fury of the Maw
		self:StopBar(CL.adds)
		self:Bar(230267, 11) -- Orb of Corrosion
		self:CDBar(228054, 17) -- Taint of the Sea
		self:Bar(228565, 20) -- Corrupted Breath
		self:CDBar(167910, 38, self:SpellName(L.mariner)) -- Kvaldir Longboat
	end
end

function mod:RAID_BOSS_EMOTE(event, msg)
	if msg:find("inv_misc_monsterhorn_03") then -- texture used in the message
		if msg:find(L.near) then --|TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya!
			self:Message(228730, "Urgent", nil, L.tentacle_near)
		else -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges far from Helya!
			self:Message(228730, "Urgent", nil, L.tentacle_far)
		end
	end
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find("227920") then
		self:Message(229119, "Personal", "Warning", CL.you:format(self:SpellName(229119))) -- Orb of Corruption
	end
end

function mod:OrbOfCorruption(args)
	self:Bar(229119, 28) -- Orb of Corruption
end

do
	local list = mod:NewTargetList()
	function mod:OrbOfCorruptionApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Urgent", "Warning")
		end

		if self:GetOption(orbMarker) then
			if self:Healer(args.destName) then
				SetRaidTarget(args.destName, 1)
			elseif self:Tank(args.destName) then
				SetRaidTarget(args.destName, 2)
			else -- Damager
				SetRaidTarget(args.destName, 3)
			end
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:OrbDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(229119, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

function mod:BilewaterBreath(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
	self:Bar(227992, 20.5, CL.cast:format(self:SpellName(227992))) -- Bilewater Liquefaction
	self:Bar(args.spellId, 52)
end

do
	local list = mod:NewTargetList()
	function mod:TaintOfTheSea(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Alert", nil, nil, self:Dispeller("magic"))
			self:CDBar(args.spellId, phase == 1 and 14.6 or 26)
		end

		if self:GetOption(taintMarker) then
			SetRaidTarget(args.destName, taintMarkerCount)
			taintMarkerCount = taintMarkerCount + 1
			if taintMarkerCount > 6 then taintMarkerCount = 4 end
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:TentacleStrike(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 6, CL.cast:format(args.spellName))
	self:Bar(args.spellId, 42)
end

do
	local prev = 0
	function mod:CorrossiveNova(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Important", "Long")
		end
	end
end

function mod:FuryOfTheMaw(args)
	self:Message(args.spellId, "Important", "Info")
	self:Bar(args.spellId, 32, CL.cast:format(args.spellName))
end

function mod:FuryOfTheMawRemoved(args)
	self:Message(args.spellId, "Important", nil, CL.over:format(args.spellName))
	self:Bar(args.spellId, 44.5)
end

function mod:TentacleDeath(args)
	tentaclesUp = tentaclesUp - 1
	self:Message("stages", "Neutral", nil, CL.mob_remaining:format(args.destName, tentaclesUp), false)
end

function mod:KvaldirLongboat(args)
	self:Message(167910, "Neutral", "Long", args.destName) -- destName = name of the spawning add
	self:Bar(167910, 75, CL.adds)
end

--[[ Grimelord ]]--
function mod:SludgeNova(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 24.3)
end

function mod:FetidRot(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:Flash(args.spellId)
		self:Say(args.spellId)
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
		self:ScheduleTimer("Say", t-3, args.spellId, 3, true)
		self:ScheduleTimer("Say", t-2, args.spellId, 2, true)
		self:ScheduleTimer("Say", t-1, args.spellId, 1, true)
	end
end

function mod:FetidRotRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:AnchorSlam(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 12)
end

--[[ Night Watch Mariner ]]--
function mod:LanternOfDarkness(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 7, CL.cast:format(args.spellName))
end

--[[ Stage Three: Helheim's Last Stand ]]--
do
	local list = mod:NewTargetList()
	function mod:OrbOfCorrosion(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Urgent", "Warning")
			self:Bar(args.spellId, 17)
		end

		if self:GetOption(orbMarker) then
			if self:Healer(args.destName) then
				SetRaidTarget(args.destName, 1)
			elseif self:Tank(args.destName) then
				SetRaidTarget(args.destName, 2)
			else -- Damager
				SetRaidTarget(args.destName, 3)
			end
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:CorruptedBreath(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 4.5, CL.cast:format(args.spellName))
	self:Bar(args.spellId, 47)
end
