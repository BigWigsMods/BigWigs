--[[
TODO:

]]--
if select(4, GetBuildInfo()) < 50400 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Thok the Bloodthirsty", 953, 851)
if not mod then return end
mod:RegisterEnableMob(71529)

--------------------------------------------------------------------------------
-- Locals
--

local frozenSolid = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.tank_debuffs = "Tank debuffs"
	L.tank_debuffs_desc = "Warnings for the different types of tank debuffs associated with Fearsome Roar"
	L.tank_debuffs_icon = 143766
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"tank_debuffs", "TANK"}, -7963, 143428, 143777, 143783, -- stage 1
		-7981, {-7980, "ICON", "FLASH", "SAY"}, -- stage 2
		"proximity", "bosskill",
	}, {
		["tank_debuffs"] = -7960, -- stage 1
		[-7981] = -7961, -- stage 2
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- stage 2
	self:Log("SPELL_AURA_REMOVED", "BloodFrenzyOver", 143440)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 146540)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 146540)
	self:Emoty("BloodFrenzy", "143440")
	-- stage 1
	self:Log("SPELL_PERIODIC_DAMAGE", "BurningBlood", 143783)
	self:Log("SPELL_DAMAGE", "BurningBlood", 143783)
	self:Log("SPELL_AURA_APPLIED", "FrozenSolid", 143777)
	self:Log("SPELL_CAST_SUCCESS", "TailLash", 143428)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Acceleration", 143411)
	self:Log("SPELL_CAST_SUCCESS", "FearsomeRoar", 143426, 143780, 143773, 143767) -- Fearsome Roar, Acid Breath, Freezing Breath, Scorching Breath
	self:Log("SPELL_AURA_APPLIED", "TankDebuff", 71529, 143780, 143773, 143767) -- Panic, Acid Breath, Freezing Breath, Scorching Breath
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankDebuff", 71529, 143780)

	self:Death("Win", 71529)
end

function mod:OnEngage()
	self:OpenProximity("proximity", 10) -- it is so you know if you are too close to another group
	self:Bar(-7963, 25) -- Acceleration, not much point for more timers than the initial one since then it is too frequent
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- stage 2

function mod:BloodFrenzyOver(args)
	self:OpenProximity("proximity", 10)
	self:Message(-7981, "Neutral", "Long", CL["over"]:format(args.spellName))
	self:Bar(-7963, 25) -- Acceleration, not much point for more timers than the initial one since then it is too frequent
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
	self:TargetMessage(-7980, "Urgent", "Alarm")
	self:PrimaryIcon(-7980, args.destName)
end

function mod:BloodFrenzy()
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
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then -- don't spam
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:FrozenSolid(args)
	frozenSolid[#frozenSolid+1] = args.destName
	self:ScheduleTimer("TargetMessage", 0.1, 143777, frozenSolid, "Attention")
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
	local amount = args.amount or 1
	self:StackMessage("tank_debuffs", args.destName, amount, "Attention", self:Me(args.destGUID) and nil or "Warning", args.spellName, args.spellId)
end

