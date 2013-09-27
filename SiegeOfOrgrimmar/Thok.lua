--[[
TODO:

]]--
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Thok the Bloodthirsty", 953, 851)
if not mod then return end
mod:RegisterEnableMob(71529)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.tank_debuffs = "Tank debuffs"
	L.tank_debuffs_desc = "Warnings for the different types of tank debuffs associated with Fearsome Roar"
	L.tank_debuffs_icon = 143766

	L.cage_opened = "Cage opened"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"tank_debuffs", "TANK"}, -7963, 143428, 143777, 143783, -- stage 1
		-7981, {-7980, "ICON", "FLASH", "SAY"}, {146589, "FLASH"}, {145974, "DISPEL"},-- stage 2
		"proximity", "berserk", "bosskill",
	}, {
		["tank_debuffs"] = -7960, -- stage 1
		[-7981] = -7961, -- stage 2
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- stage 2
	self:Log("SPELL_AURA_APPLIED_DOSE", "BloodFrenzy", 143442)
	self:Log("SPELL_AURA_REMOVED", "SkeletonKeyRemoved", 146589)
	self:Log("SPELL_AURA_APPLIED", "SkeletonKey", 146589)
	self:Log("SPELL_AURA_REMOVED", "BloodFrenzyOver", 143440)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 143445)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 143445)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 145974)
	self:Emote("BloodFrenzyPhase", "143440")
	-- stage 1
	self:Log("SPELL_PERIODIC_DAMAGE", "BurningBlood", 143783)
	self:Log("SPELL_DAMAGE", "BurningBlood", 143783)
	self:Log("SPELL_MISSED", "BurningBlood", 143783)
	self:Log("SPELL_AURA_APPLIED", "FrozenSolid", 143777)
	self:Log("SPELL_CAST_SUCCESS", "TailLash", 143428)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Acceleration", 143411)
	self:Log("SPELL_CAST_SUCCESS", "FearsomeRoar", 143426, 143780, 143773, 143767) -- Fearsome Roar, Acid Breath, Freezing Breath, Scorching Breath
	self:Log("SPELL_AURA_APPLIED", "TankDebuff", 143766, 143780, 143773, 143767) -- Panic, Acid Breath, Freezing Breath, Scorching Breath
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankDebuff", 143766, 143780, 143773, 143767)

	self:Death("Win", 71529)
end

function mod:OnEngage()
	self:Berserk(600) -- confirmed 25N PTR
	self:OpenProximity("proximity", 10) -- it is so you know if you are too close to another group -- XXX this is maybe tactic dependant
	self:Bar(-7963, 25) -- Deafening Screech
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- stage 2

function mod:BloodFrenzy(args)
	self:Message(-7981, "Attention", nil, CL["count"]:format(args.spellName, args.amount))
end

function mod:Enrage(args)
	if self:Dispeller("enrage", true, args.spellId) then
		self:Message(args.spellId, "Urgent", "Alert")
	end
end

function mod:SkeletonKeyRemoved(args)
	self:Message(args.spellId, "Positive", "Alert", L["cage_opened"])
	self:StopBar(args.spellId)
	self:Bar(-7981, 13, CL["over"]:format(self:SpellName(-7981))) -- Blood Frenzy
end

function mod:SkeletonKey(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Bar(args.spellId, 60)
	end
end

function mod:BloodFrenzyOver(args)
	self:OpenProximity("proximity", 10)
	self:Message(-7981, "Neutral", "Long", CL["over"]:format(args.spellName))
	self:Bar(-7963, 25) -- Deafening Screech, not much point for more timers than the initial one since then it is too frequent
end

function mod:FixateRemoved(args)
	self:PrimaryIcon(-7980)
	if self:Me(args.destGUID) then
		self:Message(-7980, "Positive", nil, CL["over"]:format(args.spellName))
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:Say(-7980)
		self:Flash(-7980)
	end
	self:TargetMessage(-7980, args.destName, "Urgent", "Alarm")
	self:TargetBar(-7980, 12, args.destName)
	self:PrimaryIcon(-7980, args.destName)
end

function mod:BloodFrenzyPhase()
	self:StopBar(143428) -- Tail Lash
	self:StopBar(143426) -- Fearsome Roar
	self:StopBar(143780) -- Acid Breath
	self:StopBar(143773) -- Freezing Breath
	self:StopBar(143767) -- Scorching Breath
	self:CloseProximity("proximity")
	self:Message(-7981, "Neutral", "Long")
end

-- stage 1

do
	local prev = 0
	function mod:BurningBlood(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			end
		end
	end
end

do
	local frozenSolid, scheduled = mod:NewTargetList(), nil
	local function warnFrozenSolid(spellId)
		scheduled = nil
		mod:TargetMessage(spellId, frozenSolid, "Attention")
	end
	function mod:FrozenSolid(args)
		frozenSolid[#frozenSolid+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnFrozenSolid, 0.1, args.spellId)
		end
	end
end

function mod:TailLash(args)
	self:CDBar(args.spellId, 10) -- don't think this needs a message
end

function mod:Acceleration(args)
	if args.amount > 5 and args.amount % 3 == 0 then
		self:Message(-7963, "Attention", nil, CL["count"]:format(args.spellName, args.amount))
	end
end

function mod:FearsomeRoar(args)
	self:Bar("tank_debuffs", 11, args.spellName, args.spellId)
end

function mod:TankDebuff(args)
	self:StackMessage("tank_debuffs", args.destName, args.amount, "Attention", not self:Me(args.destGUID) and "Warning", args.spellName, args.spellId)
end

