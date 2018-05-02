
--------------------------------------------------------------------------------
-- TODO List:
-- - ArcingBonds Message is experimental

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Trilliax", 1530, 1731)
if not mod then return end
mod:RegisterEnableMob(104288)
mod.engageId = 1867
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1 -- 1 = Cleaner, 2 = Maniac, 3 = Caretaker
local imprintCount = 1
local bondTable = {}
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.yourLink = "You are linked with %s"
	L.yourLinkShort = "Linked with %s"
	L.imprint = "Imprint"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		"stages",
		"berserk",
		206488, -- Arcane Seepage
		{206641, "TANK"}, -- Arcane Slash

		-- Cleaner
		206788, -- Toxic Slice
		{211615, "SAY", "PROXIMITY"}, -- Sterilize
		206820, -- Cleansing Rage

		-- Maniac
		208910, -- Arcing Bonds
		207630, -- Annihilation

		-- Caretaker
		207502, -- Succulent Feast

		-- Mythic
		215066, -- Dual Personalities
		214670, -- Energized
		215062, -- Toxic Slice
	}, {
		["stages"] = "general",
		[206788] = -13285, -- Cleaner
		[208910] = -13281, -- Maniac
		[207502] = -13282, -- Caretaker
		[215066] = "mythic",
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
	self:Log("SPELL_CAST_START", "ToxicSlice", 206788) -- normal/heroic
	self:Log("SPELL_AURA_APPLIED", "Sterilize", 211615) -- pre-debuff id
	self:Log("SPELL_AURA_REMOVED", "SterilizeRemoved", 208499)
	self:Log("SPELL_CAST_START", "CleansingRage", 206820)
	self:Log("SPELL_CAST_START", "ArcingBondsCast", 208924)
	self:Log("SPELL_AURA_APPLIED", "ArcingBonds", 208910, 208915)
	self:Log("SPELL_AURA_APPLIED", "Annihilation", 207630)
	self:Log("SPELL_CAST_START", "SucculentFeastCast", 207502)
	self:Log("SPELL_AURA_APPLIED", "SucculentFeastApplied", 206838)
	self:Log("SPELL_AURA_REMOVED", "SucculentFeastRemoved", 206838)
	self:Log("SPELL_AURA_APPLIED", "Energized", 214670)
	self:Log("SPELL_CAST_START", "ToxicSliceImprint", 215062) -- mythic imprint
	self:Death("ImprintDeath", 108303)
end

function mod:OnEngage()
	phase = 1
	imprintCount = 1
	wipe(bondTable)
	wipe(mobCollector)
	self:Berserk(540) -- Heroic
	self:Bar(206641, 7.5) -- Arcane Slash
	self:Bar(206788, 11) -- Toxic Slice
	self:Bar("stages", 45, 206557, 206557) -- The Maniac
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

function mod:OnBossDisable()
	wipe(bondTable)
	wipe(mobCollector)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 207620 then -- Annihilation
		self:Message(207630, "Important", "Long")
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unit = ("boss%d"):format(i)
		local guid = UnitGUID(unit)
		if guid and not mobCollector[guid] then
			mobCollector[guid] = true
			local id = self:MobId(guid)
			if id == 108303 then -- Imprint
				self:Message(215066, "Neutral", "Long", UnitName(unit), false)
				self:Bar(214670, 2.5, CL.other:format(L.imprint, self:SpellName(214670))) -- Energized
				if imprintCount == 1 then
					self:Bar(215062, 15.8, CL.other:format(L.imprint, self:SpellName(215062))) -- Toxic Slice
				end
				imprintCount = imprintCount + 1
			end
		end
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
		self:Bar(207630, 20.5) -- Annihilation
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

do
	local function timeToNextPhase(self)
		return phase == 1 and self:BarTimeLeft(206557) or phase == 2 and self:BarTimeLeft(206559) or self:BarTimeLeft(206560)
	end

	function mod:ArcaneSlash(args)
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 2 and "Warning")
		local t = phase == 2 and 7.3 or 11
		if timeToNextPhase(self) > t then
			self:Bar(args.spellId, t)
		end
	end

	function mod:ToxicSlice(args)
		self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
		if timeToNextPhase(self) > 26 then
			self:CDBar(args.spellId, 26)
		end
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
		self:CloseProximity(211615)
	end
end

function mod:CleansingRage(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:ArcingBondsCast()
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
			local _, _, _, expires = self:UnitDebuff("player", args.spellName)
			local remaining = expires-GetTime()
			self:Bar(208910, remaining, L.yourLinkShort:format(self:ColorName(myPartner)))
			myPartner = nil
			myPartnerIsNext = nil
		end
	end
end

function mod:Annihilation(args)
	self:CastBar(args.spellId, 16)
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

function mod:Energized(args)
	if not UnitIsPlayer(args.destName) then
		self:Message(args.spellId, "Important", self:Dispeller("magic", true) and "Alert", CL.on:format(args.spellName, args.destName))
		self:Bar(args.spellId, 20.5, CL.other:format(L.imprint, self:SpellName(214670))) -- Energized
	end
end

function mod:ToxicSliceImprint(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 17, CL.other:format(L.imprint, args.spellName)) -- Toxic Slice
end

function mod:ImprintDeath()
	self:StopBar(CL.other:format(L.imprint, self:SpellName(214670))) -- Energized
	self:StopBar(CL.other:format(L.imprint, self:SpellName(215062))) -- Toxic Slice
end
