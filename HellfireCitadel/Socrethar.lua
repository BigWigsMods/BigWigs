
-- Notes --
-- Fel Orb targetting
-- Charge target

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Socrethar the Eternal", 1026, 1427)
if not mod then return end
mod:RegisterEnableMob(90296, 92330) -- Soulbound Construct, Soul of Socrethar
mod.engageId = 1794

--------------------------------------------------------------------------------
-- Locals
--

local dominanceCount = 0
local apocalypseCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		188692, -- Unstoppable Tenacity
		183331, -- Exert Dominance
		183329, -- Apocalypse
		{180221, "SAY"}, -- Volatile Fel Orb
		{182051, "SAY"}, -- Felblaze Charge
		184053, -- Fel Barrier
		{184124, "SAY", "PROXIMITY", "FLASH"}, -- Gift of the Man'ari
		182392, -- Shadow Bolt Volley
		{182769, "SAY", "FLASH"}, -- Ghastly Fixation
		182218, -- Felblaze Residue
		{181288, "SAY"}, -- Fel Prison
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "UnstoppableTenacity", 188692)
	self:Log("SPELL_CAST_START", "ExertDominance", 183331)
	self:Log("SPELL_CAST_START", "Apocalypse", 183329)
	self:Log("SPELL_CAST_START", "VolatileFelOrb", 180221)
	self:Log("SPELL_CAST_START", "FelblazeCharge", 182051)
	self:Log("SPELL_AURA_APPLIED", "FelBarrier", 184053)
	self:Log("SPELL_AURA_APPLIED", "GiftOfTheManari", 184124)
	self:Log("SPELL_AURA_REMOVED", "GiftOfTheManariRemoved", 184124)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 182392)
	self:Log("SPELL_AURA_APPLIED", "GhastlyFixation", 182769)
	self:Log("SPELL_CAST_START", "FelPrison", 181288)

	self:Log("SPELL_AURA_APPLIED", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_PERIODIC_MISSED", "FelblazeResidueDamage", 182218)
end

function mod:OnEngage()
	dominanceCount = 0
	apocalypseCount = 0
	self:Message("berserk", "Neutral", nil, "Socrethar (beta) engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UnstoppableTenacity(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, 20)
end

function mod:ExertDominance(args)
	dominanceCount = dominanceCount + 1
	self:Message(args.spellId, "Attention", nil, CL.count:format(args.spellName, dominanceCount))
end

function mod:Apocalypse(args)
	apocalypseCount = apocalypseCount + 1
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, apocalypseCount))
	self:Bar(args.spellId, 12, CL.count:format(args.spellName, apocalypseCount))
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(180221, name, "Attention", "Alarm")
		if self:Me(guid) then
			self:Say(180221)
		end
	end
	function mod:VolatileFelOrb(args)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
		--self:Bar(args.spellId, 3)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(182051, name, "Urgent", "Alert")
		if self:Me(guid) then
			self:Say(182051)
		end
	end
	function mod:FelblazeCharge(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		--self:Bar(args.spellId, 3)
	end
end

function mod:FelBarrier(args)
	self:TargetMessage(args.spellId, args.destName, "Positive")
end

do
	local list = mod:NewTargetList()
	function mod:GiftOfTheManari(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 10)
		end
	end
end

function mod:GiftOfTheManariRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

function mod:GhastlyFixation(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(181288, name, "Urgent", "Alert")
		if self:Me(guid) then
			self:Say(181288)
		end
	end
	function mod:FelPrison(args)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
		--self:Bar(args.spellId, 3)
	end
end

do
	local prev = 0
	function mod:FelblazeResidueDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

