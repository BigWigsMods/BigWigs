
--------------------------------------------------------------------------------
-- TODO List:
-- - We can be a lot smarter with warnings - check which dragon is in range?
-- - Dragon engage / disengage messages (204720 = Aerial) - stop and start timers
-- - Lethon
-- - Mythic

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dragons of Nightmare", 1094, 1704)
if not mod then return end
mod:RegisterEnableMob(
	102679, -- Ysondre
	102681, -- Taerar
	102682, -- Lethon < TODO check this
	102683  -- Emeriss
)
mod.engageId = 1854
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
		--[[ General ]]--
		203028, -- Corrupted Breath
		-12809, -- Marks
		"berserk",

		--[[ Ysondre ]]--
		207573, -- Call Defiled Spirit
		{203770, "SAY"}, -- Defiled Vines
		203147, -- Nightmare Blast

		--[[ Emeriss ]]--
		{203787, "PROXIMITY", "SAY"}, -- Volatile Infection
		205298, -- Essence of Corruption
		205300, -- Corruption
		205528, -- Corruption of the Dream

		--[[ Lethon ]]--
		--???, -- Spihon Spirit
		--???, -- Gloom
		--???, -- Shadow Burst

		--[[ Taerar ]]--
		204100, -- Shades of Taerar
		204767, -- Corrupted Breath (Shades)
		205331, -- Seeping Fog
		204078, -- Bellowing Roar
	},{
		[203028] = "general",
		[207573] = -12768, -- Ysondre
		[203787] = -12770, -- Emeriss
		--[0] = -12772, -- Lethon TODO
		[204100] = -12774, -- Taerar
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "MarkApplied", 203102, 203125, 203124, 203121) -- Ysondre, Emeriss, Lethon, Taerar
	self:Log("SPELL_AURA_APPLIED_DOSE", "MarkApplied", 203102, 203125, 203124, 203121) -- Ysondre, Emeriss, Lethon, Taerar
	self:Log("SPELL_AURA_REMOVED", "MarkRemoved", 203102, 203125, 203124, 203121) -- Ysondre, Emeriss, Lethon, Taerar
	self:Log("SPELL_CAST_START", "CorruptedBreath", 203028)

	--[[ Ysondre ]]--
	self:Log("SPELL_CAST_START", "CallDefiledSpiritCast", 207573)
	self:Log("SPELL_AURA_APPLIED", "DefiledVines", 203770)

	--[[ Emeriss ]]--
	self:Log("SPELL_AURA_APPLIED", "VolatileInfection", 203787)
	self:Log("SPELL_AURA_REMOVED", "VolatileInfectionRemoved", 203787)
	self:Log("SPELL_CAST_SUCCESS", "EssenceOfCorruption", 205298)
	self:Log("SPELL_CAST_START", "Corruption", 205300)

	--[[ Lethon ]]--


	--[[ Taerar ]]--
	self:Log("SPELL_CAST_START", "ShadesOfTaerar", 204100)
	self:Log("SPELL_CAST_START", "ShadeCorruptedBreath", 204767)
	self:Log("SPELL_CAST_START", "BellowingRoar", 204078)
end

function mod:OnEngage()
	self:Bar(203028, 17) -- Corrupted Breath
	self:Bar(207573, 30) -- Call Defiled Spirit
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 203147 then -- Ysondre: Nightmare Blast
		self:Message(spellId, "Important", "Alert")
	elseif spellId == 205331 then -- Taerar: Seeping Fog
		self:Message(spellId, "Urgent", "Alarm")
	elseif spellId == 205528 then -- Emeriss: Corruption of the Dream
		self:Message(spellId, "Attention", "Alarm")
	end
end

--[[ General ]]--
function mod:MarkApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount == 1 or amount > 6 then -- could need fine tuning
			self:StackMessage(-12809, args.destName, amount, "Important", "Warning", args.spellId, args.spellId)
		end

		if amount > 1 then
			self:StopBar(CL.count:format(args.spellName, args.amount-1), args.destName)
		end

		local _, _, _, _, _, duration = UnitDebuff("player", args.spellName)
		self:TargetBar(-12809, duration or 35, args.destName, CL.count:format(args.spellName, amount), args.spellId)
	end
end

function mod:MarkRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(-12809, "Positive", "Info", CL.removed:format(args.spellName), args.spellId)
	end
end

do
	local prev = 0
	function mod:CorruptedBreath(args)
		local t = GetTime()
		self:Message(args.spellId, "Urgent", t-prev > 0.5 and "Info", CL.other:format(args.sourceName, args.spellName))
		self:CDBar(args.spellId, 30, CL.other:format(args.sourceName, args.spellName))
		prev = t
	end
end

--[[ Ysondre ]]--
function mod:CallDefiledSpiritCast(args)
	self:Message(args.spellId, "Important")
	self:Bar(args.spellId, 33)
end

do
	local scheduled, isOnMe = nil, nil

	local function warn(self, spellId)
		if not isOnMe then
			self:Message(spellId, "Attention", self:Dispeller("magic") and "Alert")
		end
		scheduled = nil
		isOnMe = nil
	end

	function mod:DefiledVines(args)
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId)
		end

		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
			self:Say(args.spellId)
			isOnMe = true
		end
	end
end

--[[ Emeriss ]]--
do
	local list = mod:NewTargetList()
	function mod:VolatileInfection(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Alert", nil, nil, self:Dispeller("magic"))
			self:Bar(args.spellId, 45)
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10)
			self:TargetBar(args.spellId, 90, args.destName)
		end
	end
end

function mod:VolatileInfectionRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:EssenceOfCorruption(args)
	self:Message(args.spellId, "Attention", "Long")
	self:Bar(args.spellId, 30)
end

do
	local prev = 0
	function mod:Corruption(args)
		local t = GetTime()
		if t-prev > 1.5 then
			self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
			self:Bar(args.spellId, 15)
			prev = t
		end
	end
end

--[[ Lethon ]]--


--[[ Taerar ]]--
function mod:ShadesOfTaerar(args)
	self:Message(args.spellId, "Urgent", "Long", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 49)
end

do
	local prev = 0
	function mod:ShadeCorruptedBreath(args)
		local t = GetTime()
		if t-prev > 1.5 then
			self:Message(args.spellId, "Attention", t-prev > 0.5 and "Long", CL.other:format(args.sourceName, args.spellName)) -- "Shade" instead of "Shade of Taerar"
			self:CDBar(args.spellId, 17, CL.other:format(self:SpellName(24313), args.spellName))
			prev = t
		end
	end
end

function mod:BellowingRoar(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
end
