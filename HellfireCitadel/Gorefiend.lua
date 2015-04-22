
-- Notes --
-- Surging Shadows is a constant "keep spread out"?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Gorefiend", 1026, 1372)
if not mod then return end
mod:RegisterEnableMob(90199, 91809) -- 90199 in beta
mod.engageId = 1783

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

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
		--[[ Gorefiend ]]--
		{179977, "PROXIMITY", "FLASH", "SAY"}, -- Touch of Doom
		179995, -- Doom Well
		{179909, "PROXIMITY", "SAY", "ICON"}, -- Shared Fate
		181973, -- Feast of Souls
		181295, -- Digest
		179864, -- Shadow of Death
		182788, -- Crushing Darkness
		--[[ Enraged Spirit ]]--
		182601, -- Fel Fury
		181582, -- Bellowing Shout
		--[[ Gorebound Construct ]]--
		{180148, "SAY", "FLASH"}, -- Hunger for Life
		--[[ Gorebound Spirit ]]--
		187814, -- Raging Charge
		{185189, "TANK"}, -- Fel Flames
		--[[ General ]]--
		"proximity",
		"berserk",
	}, {
		[179977] = self.displayName, -- Gorefiend
		[182601] = -11378, -- Enraged Spirit
		[180148] = -11018, -- Gorebound Construct
		[187814] = -11020, -- Gorebound Spirit
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TouchOfDoom", 179977)
	self:Log("SPELL_AURA_REMOVED", "TouchOfDoomRemoved", 179977)
	self:Log("SPELL_AURA_APPLIED", "SharedFateRoot", 179909)
	self:Log("SPELL_AURA_REMOVED", "SharedFateRootRemoved", 179909)
	self:Log("SPELL_AURA_APPLIED", "SharedFateRun", 179908)
	self:Log("SPELL_AURA_REMOVED", "SharedFateRunRemoved", 179908)
	self:Log("SPELL_CAST_START", "FeastOfSouls", 181973)
	self:Log("SPELL_AURA_APPLIED", "FeastOfSoulsStart", 181973)
	self:Log("SPELL_AURA_REMOVED", "FeastOfSoulsOver", 181973)
	self:Log("SPELL_AURA_APPLIED", "Digest", 181295)
	self:Log("SPELL_AURA_REMOVED", "DigestRemoved", 181295)
	self:Log("SPELL_AURA_APPLIED", "ShadowOfDeath", 179864)
	self:Log("SPELL_CAST_START", "CrushingDarkness", 182788)
	self:Log("SPELL_CAST_START", "BellowingShout", 181582)
	self:Log("SPELL_AURA_APPLIED", "HungerForLife", 180148)
	self:Log("SPELL_CAST_START", "RagingCharge", 187814)

	self:Log("SPELL_AURA_APPLIED_DOSE", "FelFlames", 185189)

	self:Log("SPELL_AURA_APPLIED", "DoomWellDamage", 179995)
	self:Log("SPELL_PERIODIC_DAMAGE", "DoomWellDamage", 179995)
	self:Log("SPELL_PERIODIC_MISSED", "DoomWellDamage", 179995)
	self:Log("SPELL_AURA_APPLIED", "FelFuryDamage", 182601)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelFuryDamage", 182601)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Gorefiend (beta) engaged", false)
	self:OpenProximity("proximity", 5) -- XXX Tie this to Surging Shadows?
end

function mod:Kill()
	self:Message("berserk", "Neutral", nil, "Gorefiend (beta) killed", false)
	self:Wipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:TouchOfDoom(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Important", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 8, args.destName)
			self:OpenProximity(args.spellId, 20) -- XXX Range is up for debate
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

function mod:TouchOfDoomRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		self:OpenProximity("proximity", 5)
		self:StopBar(args.spellName, args.destName)
	end
end

function mod:SharedFateRoot(args)
	fatePlayer = args.destName
	if self:Me(args.destGUID) then
		self:Say(179909, 135484) -- 135484 = "Rooted"
		self:Message(179909, "Positive", "Alert", ("%s: You are rooted!"):format(args.spellName))
	else
		self:TargetMessage(179909, fatePlayer, "Positive", nil, self:SpellName(135484)) -- 135484 = "Rooted"
	end
	self:PrimaryIcon(179909, fatePlayer)
end

function mod:SharedFateRootRemoved(args)
	fatePlayer = nil
	self:PrimaryIcon(179909)
end

function mod:SharedFateRun(args)
	if self:Me(args.destGUID) then
		self:Message(179909, "Urgent", "Alert", ("%s: Run to %s"):format(args.spellName, fatePlayer and self:ColorName(fatePlayer) or "rooted player"))
		if fatePlayer then
			self:OpenProximity(179909, 6, fatePlayer, true)
		end
	end
end

function mod:SharedFateRunRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(179909)
		self:OpenProximity("proximity", 5)
	end
end

function mod:FeastOfSouls(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

function mod:FeastOfSoulsStart(args)
	self:Message(args.spellId, "Attention", "Long", ("%s - Weakened for ~1 min!"):format(args.spellName))
	self:Bar(args.spellId, 60, self:SpellName(117847)) -- Weakened
end

function mod:FeastOfSoulsOver(args)
	self:Message(args.spellId, "Attention", nil, CL.over:format(self:SpellName(117847))) -- Weakened
	self:StopBar(117847) -- If it finishes early due to failing
end

function mod:Digest(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Attention", "Long", CL.custom_sec:format(args.spellName, 40))
		self:DelayedMessage(args.spellId, 20, "Attention", CL.custom_sec:format(args.spellName, 20))
		self:DelayedMessage(args.spellId, 30, "Attention", CL.custom_sec:format(args.spellName, 10))
		self:DelayedMessage(args.spellId, 35, "Urgent", CL.custom_sec:format(args.spellName, 5))
		self:Bar(args.spellId, 40)
	end
end

function mod:DigestRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelDelayedMessage(CL.custom_sec:format(args.spellName, 20))
		self:CancelDelayedMessage(CL.custom_sec:format(args.spellName, 10))
		self:CancelDelayedMessage(CL.custom_sec:format(args.spellName, 5))
		self:StopBar(args.spellName)
	end
end

do
	local list = mod:NewTargetList()
	function mod:ShadowOfDeath(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Urgent", "Alarm")
		end
		self:TargetBar(args.spellId, 5, args.destName)
	end
end

function mod:CrushingDarkness(args)
	self:Message(args.spellId, "Important", "Info", CL.incoming:format(args.spellName))
end

do
	local prev = 0
	function mod:DoomWellDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:FelFuryDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

function mod:BellowingShout(args)
	if UnitGUID("target") == args.sourceGUID or UnitGUID("focus") == args.sourceGUID then
		self:Message(args.spellId, "Important", not self:Healer() and "Alert", CL.casting:format(args.spellName))
	end
end

function mod:HungerForLife(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(187814, name, "Important", "Alert", nil, nil, self:Tank() or self:Damager())
	end
	function mod:RagingCharge(args)
		self:GetUnitTarget(printTarget, 0.2, args.sourceGUID)
	end
end

function mod:FelFlames(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Positive") -- XXX
	end
end


