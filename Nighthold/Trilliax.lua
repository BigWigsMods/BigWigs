
--------------------------------------------------------------------------------
-- TODO List:
-- - ArcingBonds Message is experimental

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Trilliax", 1088, 1731)
if not mod then return end
mod:RegisterEnableMob(104288)
mod.engageId = 1867
mod.respawnTime = 30 -- might be wrong

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1 -- 1 = Cleaner, 2 = Maniac, 3 = Caretaker
local bondTable = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.yourLink = "You are linked with %s"
	L.yourLinkShort = "Linked with %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		"stages",
		206488, -- Arcane Seepage
		{206641, "TANK"}, -- Arcane Slash

		-- Cleaner
		206788, -- Toxic Slice
		{211615, "SAY", "PROXIMITY"}, -- Sterilize
		206820, -- Cleansing Rage

		-- Maniac
		208910, -- Searing Bonds
		207630, -- Annihilation

		-- Caretaker
		207502, -- Succulent Feast
	}, {
		["stages"] = "general",
		[206788] = -13285, -- Cleaner
		[208910] = -13281, -- Maniac
		[207502] = -13282, -- Caretaker
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "Phase", 206557, 206559, 206560)
	self:Log("SPELL_AURA_APPLIED", "ArcaneSeepageDamage", 206488)
	self:Log("SPELL_PERIODIC_DAMAGE", "ArcaneSeepageDamage", 206488)
	self:Log("SPELL_PERIODIC_MISSED", "ArcaneSeepageDamage", 206488)
	self:Log("SPELL_AURA_APPLIED", "ArcaneSlash", 206641)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneSlash", 206641)
	self:Log("SPELL_CAST_START", "ToxicSlice", 206788)
	self:Log("SPELL_AURA_APPLIED", "Sterilize", 211615)
	self:Log("SPELL_AURA_REMOVED", "SterilizeRemoved", 211615)
	self:Log("SPELL_CAST_START", "CleansingRage", 206820)
	self:Log("SPELL_CAST_START", "ArcingBondsCast", 208924)
	self:Log("SPELL_AURA_APPLIED", "ArcingBonds", 208910, 208915)
	self:Log("SPELL_CAST_START", "SucculentFeastCast", 207502)
	self:Log("SPELL_AURA_APPLIED", "SucculentFeastApplied", 206838)
	self:Log("SPELL_AURA_REMOVED", "SucculentFeastRemoved", 206838)
end

function mod:OnEngage()
	phase = 1
	wipe(bondTable)
	self:Bar(206641, 7.5) -- Arcane Slash
	self:Bar(206788, 11) -- Toxic Slice
	self:Bar("stages", 45, 206557, 206557) -- The Maniac
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function timeToNextPhase(self)
	return phase == 1 and mod:BarTimeLeft(206557) or phase == 2 and mod:BarTimeLeft(206559) or mod:BarTimeLeft(206560)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 207620 then -- Annihilation
		self:Message(207630, "Important", "Long")
	end
end

function mod:Phase(args)
	self:Message("stages", "Neutral", "Long", args.spellName, args.spellId)
	if args.spellId == 206560 then -- Cleaner
		phase = 1
		self:Bar("stages", 45, 206557, 206557) -- The Maniac
		self:CDBar(206820, 10.5) -- Cleansing Rage
		self:CDBar(206788, 13) -- Toxic Slice
		self:CDBar(206641, 19) -- Arcane Slash
	elseif args.spellId == 206557 then -- Maniac
		phase = 2
		self:Bar("stages", 40, 206559, 206559) -- The Caretaker
		self:StopBar(self:SpellName(206788)) -- Toxic Slice
		self:CDBar(206641, 6) -- Arcane Slash
	elseif args.spellId == 206559 then -- Caretaker
		phase = 3
		self:Bar("stages", 13, 206560, 206560) -- The Cleaner
		self:StopBar(self:SpellName(206641)) -- Arcane Slash
	end
end

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

function mod:ArcaneSlash(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 2 and "Warning")
	if timeToNextPhase() > (phase == 2 and 7.3 or 11) then
		self:Bar(args.spellId, phase == 2 and 7.3 or 11)
	end
end

function mod:ToxicSlice(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
	if timeToNextPhase() > 26 then
		self:CDBar(args.spellId, 26)
	end
end

do
	local list = mod:NewTargetList()
	function mod:Sterilize(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning")
		end

		if self:Me(args.destGUID) then
			self:OpenProximity(args.spellId, 7)
			self:TargetBar(args.spellId, 45, args.destName)
			self:Say(args.spellId)
		end
	end
end

function mod:SterilizeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:CleansingRage(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:ArcingBondsCast(args)
	wipe(bondTable)
end

do
	local myPartnerIsNext = nil
	function mod:ArcingBonds(args)
		bondTable[#bondTable+1] = args.destName
		local myPartner = nil
		if self:Me(args.destGUID) then
			if #bondTable % 2 == 0 then
				myPartner = bondTable[#bondTable-1]
			else
				myPartnerIsNext = true
			end
		elseif myPartnerIsNext then
			myPartnerIsNext = nil
			myPartner = args.destName
		end

		if myPartner then
			self:Message(208910, "Personal", "Warning", L.yourLink:format(self:ColorName(myPartner)))
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local remaining = expires-GetTime()
			self:Bar(208910, remaining, L.yourLinkShort:format(self:ColorName(myPartner)))
			myPartner = nil
			myPartnerIsNext = nil
		end
	end
end

function mod:SucculentFeastCast(args)
	self:Message(args.spellId, "Attention", "Info", CL.incoming:format(args.spellName))
end

function mod:SucculentFeastApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(207502, args.destName, "Personal", "Info")
	end
end

function mod:SucculentFeastRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(207502, "Personal", "Info", CL.removed:format(args.spellName))
	end
end
