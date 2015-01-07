
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Highmaul Trash", 994)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	86072, -- Oro
	81272, -- Gorian Runemaster
	86329 -- Breaker Ritualist
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
	L.ritualist = "Breaker Ritualist"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{172066, "FLASH", "PROXIMITY", "SAY"}, -- Radiating Poison
		{175654, "FLASH"}, -- Rune of Disintegration
		{175636, "FLASH", "PROXIMITY", "SAY"}, -- Rune of Destruction
		{173827, "FLASH"}, -- Wild Flames
	}, {
		[172066] = L.oro,
		[175654] = L.runemaster,
		[173827] = L.ritualist,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "RadiatingPoison", 172066)
	self:Log("SPELL_AURA_REMOVED", "RadiatingPoisonRemoved", 172066)

	self:Log("SPELL_AURA_APPLIED", "RuneOfDisintegration", 175654)
	self:Log("SPELL_PERIODIC_DAMAGE", "RuneOfDisintegration", 175654)
	self:Log("SPELL_PERIODIC_MISSED", "RuneOfDisintegration", 175654)

	self:Log("SPELL_AURA_APPLIED", "RuneOfDestruction", 175636)
	self:Log("SPELL_AURA_REMOVED", "RuneOfDestructionRemoved", 175636)

	self:Log("SPELL_AURA_APPLIED", "WildFlames", 173827)
	self:Log("SPELL_PERIODIC_DAMAGE", "WildFlames", 173827)
	self:Log("SPELL_PERIODIC_MISSED", "WildFlames", 173827)

	self:Death("DisableOnCombatExit", 86072, 86329, 81272) -- Oro, Breaker Ritualist, Gorian Runemaster
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DisableOnCombatExit()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "Disable")
end

function mod:RadiatingPoison(args)
	self:TargetBar(args.spellId, 40, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 10)
		self:Say(args.spellId)
	end
end

function mod:RadiatingPoisonRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

do
	local prev = 0
	function mod:RuneOfDisintegration(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:RuneOfDestruction(args)
	self:TargetBar(args.spellId, 15, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 6)
		self:Say(args.spellId)
	end
end

function mod:RuneOfDestructionRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

do
	local prev = 0
	function mod:WildFlames(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

