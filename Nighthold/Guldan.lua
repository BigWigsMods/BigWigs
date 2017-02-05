
--------------------------------------------------------------------------------
-- TODO List:
-- - Ugliest module in BigWigs so far. Clean me up please!
-- - Soul Siphon CD

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gul'dan", 1088, 1737)
if not mod then return end
mod:RegisterEnableMob(104154)
mod.engageId = 1866
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local liquidHellfireCount = 1
local handOfGuldanCount = 1
local handOfGuldanTimers = {13.5, 48.9, 138.9} -- TODO: Get more data on these
local stormCount = 1
local flamesCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		"berserk",

		--[[ Essence of Aman'Thul ]]--
		210339, -- Time Dilation
		{217830, "SAY"}, -- Scattering Field
		{210296, "TANK"}, -- Resonant Barrier

		--[[ Stage One ]]--
		{206219, "SAY", "FLASH"}, -- Liquid Hellfire
		206515, -- Fel Efflux
		212258, -- Hand of Gul'dan

		--[[ Inquisitor Vethriz ]]--
		207938, -- Shadowblink
		212568, -- Drain
		217770, -- Gaze of Vethriz

		--[[ Fel Lord Kuraz'mal ]]--
		{206675, "TANK"}, -- Shatter Essence
		210273, -- Fel Obelisk

		--[[ D'zorykx the Trapper ]]--
		208545, -- Anguished Spirits
		206883, -- Soul Vortex
		{206896, "TANK"}, -- Torn Soul

		--[[ Stage Two ]]--
		{209011, "SAY", "FLASH"}, -- Bonds of Fel
		209270, -- Eye of Gul'dan
		208672, -- Carrion Wave

		--[[ Stage Three ]]--
		221891, -- Soul Siphon
		167935, -- Storm of the Destroyer
		206744, -- Black Harvest
		{221606, "SAY", "FLASH"}, -- Flames of Sargeras
		211152, -- Empowered Eye of Gul'dan
		221781, -- Desolate Ground
		{227556, "TANK"}, -- Fury of the Fel   XXX untested
	}, {
		["stages"] = "general",
		[210339] = -14886, -- Essence of Aman'Thul
		[206219] = -14885, -- Stage One
		[207938] = -14897, -- Inquisitor Vethriz
		[206675] = -14894, -- Fel Lord Kuraz'mal
		[208545] = -14902, -- D'zorykx the Trapper
		[206339] = -14062, -- Stage Two
		[221891] = -14090, -- Stage Three
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterEvent("RAID_BOSS_EMOTE")

	--[[ Essence of Aman'Thul ]]--
	self:Log("SPELL_AURA_APPLIED", "TimeDilation", 210339)
	self:Log("SPELL_AURA_APPLIED", "ScatteringField", 217830)
	self:Log("SPELL_AURA_APPLIED", "ResonantBarrier", 210296)

	self:Log("SPELL_AURA_APPLIED", "EyeOfAmanThul", 206516)
	self:Log("SPELL_AURA_REMOVED", "EyeOfAmanThulRemoved", 206516)

	--[[ Stage One ]]--
	self:Log("SPELL_CAST_START", "LiquidHellfire", 206219, 206220)
	self:Log("SPELL_CAST_START", "FelEfflux", 206514)
	self:Log("SPELL_CAST_START", "HandOfGuldan", 212258)

	--[[ Inquisitor Vethriz ]]--
	self:Log("SPELL_CAST_SUCCESS", "Shadowblink", 207938)
	self:Log("SPELL_AURA_APPLIED", "Drain", 212568)

	--[[ Fel Lord Kuraz'mal ]]--
	self:Log("SPELL_CAST_START", "ShatterEssence", 206675)
	self:Death("FelLordDeath", 104537)

	--[[ D'zorykx the Trapper ]]--
	self:Log("SPELL_CAST_START", "AnguishedSpirits", 208545)
	self:Log("SPELL_CAST_START", "SoulVortex", 206883)
	self:Log("SPELL_AURA_APPLIED", "TornSoul", 206896)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TornSoul", 206896)
	self:Log("SPELL_AURA_REMOVED", "TornSoulRemoved", 206896)

	--[[ Stage Two ]]--
	self:Log("SPELL_CAST_START", "BondsOfFelCast", 206222, 206221) -- Normal, Empowered
	self:Log("SPELL_AURA_APPLIED", "BondsOfFel", 209011, 206384) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "EyeOfGuldan", 209270, 211152) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "CarrionWave", 208672)

	--[[ Stage Three ]]--
	self:Log("SPELL_AURA_APPLIED", "Phase3Start", 227427) --The Eye of Aman'Thul
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheFel", 227556) -- XXX untested
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryOfTheFel", 227556) -- XXX untested

	self:Log("SPELL_CAST_START", "StormOfTheDestroyer", 167819, 167935, 177380, 152987)
	self:Log("SPELL_AURA_APPLIED", "SoulSiphon", 221891)
	self:Log("SPELL_CAST_START", "BlackHarvest", 206744)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargerasSoon", 221606)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargeras", 221603)

	self:Log("SPELL_AURA_APPLIED", "Damage", 206515, 221781) -- Fel Efflux, Desolate Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "Damage", 206515, 221781)
	self:Log("SPELL_PERIODIC_MISSED", "Damage", 206515, 221781)
	self:Log("SPELL_DAMAGE", "Damage", 217770, 221781) -- Gaze of Vethriz, Desolate Ground
	self:Log("SPELL_MISSED", "Damage", 217770, 221781)
end

function mod:OnEngage()
	phase = 1
	liquidHellfireCount = 1
	handOfGuldanCount = 1
	stormCount = 1
	flamesCount = 1
	self:Bar(212258, 7) -- Hand of Gul'dan
	self:Bar(206515, 11) -- Fel Efflux
	self:Berserk(720)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 210273 then -- Fel Obelisk
		self:Message(spellId, "Attention", "Alarm")
		self:CDBar(spellId, 23)
	end
end
function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find("206221") then -- Gains Empowered Bonds of Fel
		self:Bar(209011, self:BarTimeLeft(209011), self:SpellName(206221))
		self:StopBar(209011) -- Bonds of Fel
	end
end

--[[ Essence of Aman'Thul ]]--
function mod:TimeDilation(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal")
	end
end

do
	local list = mod:NewTargetList()
	function mod:ScatteringField(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "Positive", "Info", nil, nil, true)
		end
		if self:Me(args.sourceGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:ResonantBarrier(args)
	self:TargetMessage(args.spellId, args.destName, "Positive")
	self:TargetBar(args.spellId, 6, args.destName)
end

function mod:EyeOfAmanThul(args)
	self:Message("stages", "Neutral", "Long", args.spellName, args.spellId)
	self:Bar(206219, 6) -- Liquid Hellfire
	self:Bar(206515, 9.8) -- Fel Efflux
end

function mod:EyeOfAmanThulRemoved(args) -- Phase 2 start
	phase = 2
	handOfGuldanCount = 1
	liquidHellfireCount = 1
	self:Message("stages", "Neutral", "Long", CL.stage:format(2), args.spellId)
	self:Bar(206219, 23.5, CL.count:format(self:SpellName(206219), liquidHellfireCount)) -- Liquid Hellfire
	self:Bar(209011, 9.5) -- Bonds of Fel
	if self:Easy() then
		self:StopBar(212258) -- Hand of Gul'dan
	else
		self:Bar(212258, 13.5, CL.count:format(self:SpellName(212258), handOfGuldanCount)) -- Hand of Gul'dan
	end
	self:Bar(209270, 29) -- Eye of Gul'dan
end

function mod:Phase3Start(args) -- Phase 3 start
	phase = 3
	self:Message("stages", "Neutral", "Long", CL.stage:format(3), args.spellId)
	self:StopBar(206221) -- Empowered Bonds of Fel
	self:StopBar(212258) -- Hand of Gul'dan
	self:StopBar(CL.count:format(self:SpellName(206220), liquidHellfireCount)) -- Liquid Hellfire
	self:Bar("stages", 8, args.spellName, args.spellId)
	self:Bar(221606, 27.5) -- Flames of Sargeras
	self:Bar(211152, 39) -- Eye of Gul'dan
	self:Bar(206744, 66) -- Black Harvest
	self:Bar(167935, 84) -- Storm of the Destroyer
end

--[[ Stage One ]]--
function mod:LiquidHellfire(args)
	self:Message(206219, "Urgent", "Alarm", CL.incoming:format(CL.count:format(args.spellName, liquidHellfireCount)))
	liquidHellfireCount = liquidHellfireCount + 1
	if phase == 1 then
		self:Bar(206219, liquidHellfireCount == 1 and 15 or 25, CL.count:format(args.spellName, liquidHellfireCount))
	else
		self:Bar(206219, liquidHellfireCount == 5 and 73.2 or 36.6, CL.count:format(args.spellName, liquidHellfireCount)) -- gets skipped once
	end
end

function mod:FelEfflux(args)
	self:Message(206515, "Important", "Alert")
	self:CDBar(206515, 12)
end

function mod:HandOfGuldan(args)
	self:Message(args.spellId, "Attention", "Info")
	handOfGuldanCount = handOfGuldanCount + 1
	if phase == 1 and handOfGuldanCount < 4 then
		self:Bar(args.spellId, handOfGuldanCount == 2 and 14 or 10, CL.count:format(args.spellName, handOfGuldanCount))
	elseif phase == 2 then
		self:Bar(args.spellId, handOfGuldanTimers[handOfGuldanCount] or 48.9, CL.count:format(args.spellName, handOfGuldanCount))
	end
end

--[[ Inquisitor Vethriz ]]--
function mod:Shadowblink(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:Drain(args)
	if self:Dispeller("magic") or self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	end
end

--[[ Fel Lord Kuraz'mal ]]--
function mod:ShatterEssence(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
	self:Bar(args.spellId, 53.5)
end

function mod:FelLordDeath(args)
	self:StopBar(206675) -- Shatter Essence
	self:StopBar(210273) -- Fel Obelisk
end

--[[ D'zorykx the Trapper ]]--
function mod:AnguishedSpirits(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
end

function mod:SoulVortex(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName)) -- actual cast
	self:ScheduleTimer("Bar", 3, args.spellId, 6, CL.cast:format(args.spellName)) -- pull in
end

function mod:TornSoul(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 1 and "Warning") -- check sound amount
	self:TargetBar(args.spellId, 30, args.destName)
end

function mod:TornSoulRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

--[[ Stage Two ]]--
function mod:BondsOfFelCast(args)
	self:Message(209011, "Attention", "Info", CL.casting:format(args.spellName))
	self:Bar(209011, 44.5, args.spellName)
end

do
	local list = mod:NewTargetList()
	function mod:BondsOfFel(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, 209011, list, "Important", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:Say(209011, CL.count:format(args.spellName, #list))
			self:Flash(209011)
		end
	end
end

function mod:EyeOfGuldan(args)
	self:Message(209270, "Urgent", "Alert")
	self:Bar(209270, phase == 2 and 53.3 or 62.5, args.spellName) -- TODO: P3 timer is 25s at some point
end

function mod:CarrionWave(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Long")
		self:Bar(args.spellId, 6.1)
	end
end

--[[ Stage Three ]]--
do
	local prev = 0
	function mod:FuryOfTheFel(args)
		local t = GetTime()
		if t-prev > 5 then
			local amount = args.amount or 1
			self:Message(args.spellId, "Positive", "Info", CL.count:format(args.spellName, amount))
		end
	end
end

function mod:StormOfTheDestroyer(args)
	self:Message(167935, "Important", "Long")
	if args.spellId == 167819 then -- First Storm
		stormCount = stormCount + 1
		self:Bar(167935, stormCount == 2 and 68 or 61)
	end
end

do
	local list = mod:NewTargetList()
	function mod:SoulSiphon(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Important")
		end
	end
end

function mod:BlackHarvest(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 72)
end

do
	local prev = 0
	function mod:Damage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:FlamesOfSargerasSoon(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Important")
		end
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:TargetBar(args.spellId, 6, args.destName)
		end
		flamesCount = flamesCount + 1
		self:Bar(args.spellId, flamesCount % 3 == 1 and 34.7 or flamesCount % 3 == 0 and 8.8 or 7.8)
	end
end

function mod:FlamesOfSargeras(args)
	--[[if self:Me(args.destGUID) then
		self:TargetMessage(221606, args.destName, "Personal", "Warning")
		self:Flash(221606)
	end]]
end
