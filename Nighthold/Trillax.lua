
--------------------------------------------------------------------------------
-- TODO List:
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Trillax", 1088, 1731)
if not mod then return end
mod:RegisterEnableMob(104288) -- fix me
mod.engageId = 1867
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
		-- General
		206488, -- Arcane Seepage
		206641, -- Arcane Spear
		"berserk",

		-- Cleaner
		{208506, "SAY", "PROXIMITY"}, -- Sterilize
		206820, -- Cleansing Rage

		-- Maniac
		208910, -- Searing Bonds

		-- Caretaker
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ArcaneSeepageDamage", 206488) -- Pre alpha test spellId
	self:Log("SPELL_PERIODIC_DAMAGE", "ArcaneSeepageDamage", 206488) -- Pre alpha test spellId
	self:Log("SPELL_PERIODIC_MISSED", "ArcaneSeepageDamage", 206488) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "ArcaneSpear", 206641) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneSpear", 206641) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "Sterilize", 208506) -- Pre alpha test spellId
	self:Log("SPELL_AURA_REMOVED", "SterilizeRemoved", 208506) -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "CleansingRage", 206820) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "SearingBonds", 208910) -- Pre alpha test spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Trillax (Alpha) Engaged (Pre Alpha Test Mod)")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:ArcaneSeepageDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:ArcaneSpear(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 5 and "Warning") -- XXX fix sound amount, not even alpha
end

function mod:Sterilize(args)
	self:TargetMessage(args.spellId, args.destName, "Important")
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 12)
		self:TargetBar(args.spellId, 40, args.destName)
		self:Say(args.spellId)
	end
end

function mod:SterilizeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:CleansingRage(args)
	self:Message(args.spellId, "Attention")
end

function mod:SearingBonds(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent")
end
