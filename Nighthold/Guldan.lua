
--------------------------------------------------------------------------------
-- TODO List:
-- - Add spell names to the option table (ideally before funkey faints)
-- - FelObelisk, Flames of Sargeras will have double says as a fallback for now
-- - Fix everything after hc testing

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gul'dan", 1088, 1737)
if not mod then return end
mod:RegisterEnableMob(105503) -- fix me
mod.engageId = 1866
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		210339, -- Time Dilation
		217830,
		210296,
		{206219, "SAY", "FLASH"},
		206515,
		212258,
		206675,
		{206875, "SAY"},
		206840,
		{212568, "SAY", "FLASH"},
		206883,
		208545,
		206339,
		208672,
		209518,
		{221891, "SAY"},
		167935,
		206744,
		221606,
		221606,
		212686,
		211132,
		221781,
		{227556, "TANK"},
		"berserk",
	}, {
		--[] = -14885, -- Stage One
		--[] = -14062, -- Stage Two
		--[] = -14090, -- Stage Three
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TimeDilation", 210339)
	self:Log("SPELL_AURA_APPLIED", "ScatteringField", 217830)
	self:Log("SPELL_AURA_APPLIED", "ResonantBarrier", 210296)
	self:Log("SPELL_AURA_APPLIED", "LiquidHellfire", 206219, 206220)
	self:Log("SPELL_CAST_START", "HandOfGuldan", 212258)
	self:Log("SPELL_CAST_START", "ShatterEssence", 206675)
	self:Log("SPELL_CAST_START", "FelObelisk", 206875)
	self:Log("SPELL_AURA_APPLIED", "FelObeliskApplied", 206875)
	self:Log("SPELL_CAST_START", "GazeOfVethriz", 206840)
	self:Log("SPELL_AURA_APPLIED", "Drain", 212568)
	self:Log("SPELL_CAST_START", "SoulVortex", 206883)
	self:Log("SPELL_CAST_START", "AnguishedSpirits", 208545)

	self:Log("SPELL_AURA_APPLIED", "FuryOfTheFel", 227556)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryOfTheFel", 227556)

	self:Log("SPELL_AURA_APPLIED", "BondsOfFel", 206339, 206367)

	self:Log("SPELL_CAST_START", "CarrionWave", 208672)

	self:Log("SPELL_CAST_START", "StormOfTheDestroyer", 167935, 177380)
	self:Log("SPELL_AURA_APPLIED", "SoulSiphon", 221891)
	self:Log("SPELL_CAST_START", "BlackHarvest", 206744)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargerasSoon", 221606)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargeras", 212686)

	self:Log("SPELL_AURA_APPLIED", "Damage", 206515, 209518, 211132, 221781) -- Fel Efflux, Eye of Gul'dan, Empowered Eye of Gul'dan, Desolate Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "Damage", 206515, 209518, 211132, 221781)
	self:Log("SPELL_PERIODIC_MISSED", "Damage", 206515, 209518, 211132, 221781)
	self:Log("SPELL_DAMAGE", "Damage", 206515, 209518, 211132, 221781)
	self:Log("SPELL_MISSED", "Damage", 206515, 209518, 211132, 221781)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Gul'dan (PTR) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TimeDilation(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

do
	local prev = 0
	function mod:ScatteringField(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Positive", "Info")
			self:Bar(args.spellId, 6, CL.cast:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:ResonantBarrier(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Positive", "Alert")
			self:Bar(args.spellId, 6, CL.cast:format(args.spellName))
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:LiquidHellfire(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, 206219, list, "Urgent", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(206219)
			self:Flash(206219)
		end
	end
end

do
	local prev = 0
	function mod:HandOfGuldan(args)
		local t = GetTime()
		if t-prev > 5 then
			self:Message(args.spellId, "Attention", "Info", CL.incoming:format(args.spellName))
		end
	end
end

function mod:ShatterEssence(args)
	self:Message(args.spellId, "Important", "Info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(206875)
		end
		self:TargetMessage(206875, player, "Important", "Alarm")
	end

	function mod:FelObelisk(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
	end

	function mod:FelObeliskApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:GazeOfVethriz(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
end

do
	local list = mod:NewTargetList()
	function mod:Drain(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Urgent", "Alarm", nil, nil, self:Dispeller("magic"))
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
	end
end

function mod:SoulVortex(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
end

function mod:AnguishedSpirits(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.SpellName))
end

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

do
	local list = mod:NewTargetList()
	function mod:BondsOfFel(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, 206339, list, "Important", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:Say(206339)
			self:Flash(206339)
		end
	end
end

function mod:CarrionWave(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Long", CL.casting:format(args.spellName))
end

function mod:StormOfTheDestroyer(args)
	self:Message(167935, "Important", "Long")
end

do
	local list = mod:NewTargetList()
	function mod:SoulSiphon(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning", nil, nil, true)
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
