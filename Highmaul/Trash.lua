
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Highmaul Trash", 994)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	86072, -- Oro
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
	L.ritualist = "Breaker Ritualist"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{172066, "FLASH", "PROXIMITY", "SAY"}, -- Radiating Poison
		{173827, "FLASH"}, -- Wild Flames
	}, {
		[172066] = L.oro,
		[173827] = L.ritualist,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "RadiatingPoison", 172066)
	self:Log("SPELL_AURA_REMOVED", "RadiatingPoisonRemoved", 172066)

	self:Log("SPELL_AURA_APPLIED", "WildFlames", 173827)
	self:Log("SPELL_PERIODIC_DAMAGE", "WildFlames", 173827)
	self:Log("SPELL_PERIODIC_MISSED", "WildFlames", 173827)

	self:Death("DisableOnCombatExit", 86072, 86329) -- Oro, Breaker Ritualist
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
	function mod:WildFlames(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

