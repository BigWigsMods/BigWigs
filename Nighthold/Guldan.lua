
--------------------------------------------------------------------------------
-- TODO List:
-- - Mod is untested, probably needs a lot of updates

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gul'dan", 1088, 1737)
if not mod then return end
mod:RegisterEnableMob(104154)
mod.engageId = 1866
mod.respawnTime = 5

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local liquidHellfireCount = 1
local handOfGuldanCount = 1
local handOfGuldanTimers = {48.9, 138.9} -- TO DO: Get more data on these

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

		--[[ Stage Three ]]--  XXX untested
		{221891, "SAY"}, -- Soul Siphon   XXX untested
		167935, -- Storm of the Destroyer   XXX untested
		206744, -- Black Harvest   XXX untested
		221606, -- Flames of Sargeras   XXX untested
		212686, -- Flames of Sargeras   XXX untested
		211132, -- Empowered Eye of Gul'dan   XXX untested
		221781, -- Desolate Ground   XXX untested
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
	self:Log("SPELL_AURA_APPLIED", "BondsOfFel", 209011)
	self:Log("SPELL_CAST_START", "EyeOfGuldan", 209270, 211152)
	self:Log("SPELL_CAST_START", "CarrionWave", 208672)

	--[[ Stage Three ]]--
	self:Log("SPELL_AURA_APPLIED", "Phase3Start", 227427) --The Eye of Aman'Thul
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheFel", 227556) -- XXX untested
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryOfTheFel", 227556) -- XXX untested

	self:Log("SPELL_CAST_START", "StormOfTheDestroyer", 167935, 177380) -- XXX untested
	self:Log("SPELL_AURA_APPLIED", "SoulSiphon", 221891) -- XXX untested
	self:Log("SPELL_CAST_START", "BlackHarvest", 206744) -- XXX untested
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargerasSoon", 221606) -- XXX untested
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargeras", 212686) -- XXX untested

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
	self:Bar(212258, 7) -- Hand of Gul'dan
	self:Bar(206515, 11) -- Fel Efflux
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
	self:Message(args.spellId, "Positive", "Alert")
	self:Bar(args.spellId, 6, CL.cast:format(args.spellName))
end
function mod:Phase3Start(args) -- Phase 3 start
	phase = 3
	self:StopBar(206221) -- Empowered Bonds of Fel
	self:StopBar(212258) -- Hand of Gul'dan
	self:StopBar(206220) -- Empowered Liquid Hellfire
	self:Bar(209270, 40, self:SpellName(211152)) -- Empowered Eye of Gul'dan
end
function mod:EyeOfAmanThul(args)
	--phase = 2
	--self:Message("stages", "Neutral", "Long", args.spellName, args.spellId)
	self:Bar(206219, 9) -- Liquid Hellfire
	self:Bar(206515, 9.5) -- Fel Efflux
end

function mod:EyeOfAmanThulRemoved(args) -- Phase 2 start
	phase = 2
	handOfGuldanCount = 0
	liquidHellfireCount = 0
	self:Message("stages", "Neutral", "Long", CL.removed:format(args.spellName), args.spellId)
	self:Bar(212258, 9.5) -- Bonds of Fel
	self:Bar(212258, 14.5) -- Hand of Gul'dan
	self:Bar(209270, 29) -- Eye of Gul'dan
	self:Bar(206219, 40) -- Liquid Hellfire
end

--[[ Stage One ]]--
function mod:LiquidHellfire(args)
	self:Message(206219, "Urgent", "Alarm", CL.incoming:format(CL.count:format(args.spellName, liquidHellfireCount)))
	liquidHellfireCount = liquidHellfireCount + 1
	if phase == 1 then
		self:Bar(206219, phase == 1 and 15 or 25, CL.count:format(args.spellName, liquidHellfireCount)) -- p3 and after cd missing
	else
		self:Bar(206219, liquidHellfireCount == 4 and 73.4 or 36.6, args.spellName) -- XXX only saw one with long intervall, im sure its becouse of some other ability but CBA to check it now
	end
end

function mod:FelEfflux(args)
	self:Message(206515, "Important", "Alert")
	self:CDBar(206515, phase == 1 and 14 or 12)
end

function mod:HandOfGuldan(args)
	self:Message(args.spellId, "Attention", "Info")
	handOfGuldanCount = handOfGuldanCount + 1
	if phase == 1 and handOfGuldanCount < 4 then
		self:Bar(args.spellId, handOfGuldanCount == 2 and 14 or 10)
	elseif phase == 2 then
		handOfGuldanCount = handOfGuldanCount + 1
		self:Bar(args.spellId, handOfGuldanTimers[handOfGuldanCount] or 138.9) -- XXX
	end
end

--[[ Inquisitor Vethriz ]]--
function mod:Shadowblink(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:Drain(args)
	if self:Dispeller("magic") or self:Me(args.destGUID) then
		self:TargetMessage("TargetMessage", args.destName, "Urgent", "Alarm")
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
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(args.spellName, #list))
			self:Flash(args.spellId)
		end
	end
end

function mod:EyeOfGuldan(args)
	self:Message(209270, "Urgent", "Alert")
	self:Bar(209270, 60)
	if phase < 3 then
		self:Bar(209270, 53.3, args.spellName)
	else
		self:Bar(209270, 62.5, args.spellName) -- XXX take all the other stuff in to account, but this will do for now (at some point there is only 25sec between the eyes)
	end
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
end

do
	local list = mod:NewTargetList()
	function mod:SoulSiphon(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Important", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:BlackHarvest(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(args.spellName))
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

function mod:FlamesOfSargerasSoon(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning", CL.soon:format(args.spellName))
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:TargetBar(args.spellId, 7, args.destName)
	end
end

function mod:FlamesOfSargeras(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:TargetBar(args.spellId, 4, args.destName)
	end
end
