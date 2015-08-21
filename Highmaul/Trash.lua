
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Highmaul Trash", 994)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	86072, -- Oro
	81272, -- Gorian Runemaster
	82528, -- Gorian Arcanist
	86326, -- Breaker Ritualist <Breaker of Frost>
	86329 -- Breaker Ritualist <Breaker of Fire>
)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.oro = "Oro"
	L.runemaster = "Gorian Runemaster"
	L.arcanist = "Gorian Arcanist"
	L.ritualist = "Breaker Ritualist"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Oro ]]--
		{172066, "FLASH", "PROXIMITY", "SAY"}, -- Radiating Poison
		--[[ Gorian Runemaster ]]--
		{175654, "FLASH"}, -- Rune of Disintegration
		{175636, "FLASH", "PROXIMITY", "SAY"}, -- Rune of Destruction
		--[[ Gorian Arcanist ]]--
		{166200, "FLASH", "PROXIMITY", "SAY"}, -- Arcane Volatility
		--[[ Breaker Ritualist ]]--
		{173827, "FLASH"}, -- Wild Flames
		{174404, "FLASH", "PROXIMITY", "SAY"}, -- Frozen Core
	}, {
		[172066] = L.oro,
		[175654] = L.runemaster,
		[166200] = L.arcanist,
		[173827] = L.ritualist,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_AURA_APPLIED", "BadStuffUnderYou", 175654, 173827) -- Rune of Disintegration, Wild Flames
	self:Log("SPELL_PERIODIC_DAMAGE", "BadStuffUnderYou", 175654, 173827)
	self:Log("SPELL_PERIODIC_MISSED", "BadStuffUnderYou", 175654, 173827)

	self:Log("SPELL_AURA_APPLIED", "RadiatingPoison", 172066)
	self:Log("SPELL_AURA_REMOVED", "RadiatingPoisonRemoved", 172066)

	self:Log("SPELL_AURA_APPLIED", "RuneOfDestruction", 175636)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDestructionRemoved", 175636)

	self:Log("SPELL_AURA_APPLIED", "ArcaneVolatility", 166200)
	self:Log("SPELL_AURA_REMOVED", "ArcaneVolatilityRemoved", 166200)

	self:Log("SPELL_AURA_APPLIED", "FrozenCore", 174404)
	self:Log("SPELL_AURA_REMOVED", "FrozenCoreRemoved", 174404)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:BadStuffUnderYou(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Oro ]]--

function mod:RadiatingPoison(args)
	self:TargetBar(args.spellId, 40, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 10)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		if not self:LFR() then
			self:Say(args.spellId)
		end
	end
end

function mod:RadiatingPoisonRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

--[[ Gorian Runemaster ]]--

function mod:RuneOfDestruction(args)
	self:TargetBar(args.spellId, 15, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 6)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		if not self:LFR() then
			self:Say(args.spellId)
		end
	end
end

function mod:RuneOfDestructionRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

--[[ Gorian Arcanist ]]--

function mod:ArcaneVolatility(args)
	--self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 8)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		if not self:LFR() then
			self:Say(args.spellId)
		end
	end
end

function mod:ArcaneVolatilityRemoved(args)
	--self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

--[[ Breaker Ritualist ]]--

function mod:FrozenCore(args)
	self:TargetBar(args.spellId, 20, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 8)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		if not self:LFR() then
			self:Say(args.spellId)
		end
	end
end

function mod:FrozenCoreRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

