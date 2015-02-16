
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackrock Foundry Trash", 988)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	78978, -- Darkshard Gnasher
	87366 -- Blast Furnace Exhaust, this isn't going to work
)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.gnasher = "Darkshard Gnasher"
	L.furnace = "Blast Furnace Exhaust"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Darkshard Gnasher ]]--
		{159632, "FLASH"}, -- Insatiable Hunger
		--[[ Blast Furnace Exhaust ]]--
		{174773, "FLASH"}, -- Exhaust Fumes
	}, {
		[159632] = L.gnasher,
		[174773] = L.furnace,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_AURA_APPLIED", "InsatiableHunger", 159632)
	self:Log("SPELL_AURA_REMOVED", "InsatiableHungerRemoved", 159632)

	self:Log("SPELL_AURA_APPLIED", "ExhaustFumes", 174773)
	self:Log("SPELL_PERIODIC_DAMAGE", "ExhaustFumes", 174773)
	self:Log("SPELL_PERIODIC_MISSED", "ExhaustFumes", 174773)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Darkshard Gnasher ]]--

function mod:InsatiableHunger(args)
	self:TargetBar(args.spellId, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:InsatiableHungerRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", nil, CL.over:format(args.spellName))
	end
end

--[[ Blast Furnace Exhaust ]]--

do
	local prev = 0
	function mod:ExhaustFumes(args) -- Dem trolls yo
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

