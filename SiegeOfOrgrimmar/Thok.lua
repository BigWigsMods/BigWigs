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
local accCount = 0
local yetiChargeTimer
local heroicAdd
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds = "Heroic adds"
	L.adds_desc = "Warnings for when the heroic only adds enter the fight."

	L.tank_debuffs = "Tank debuffs"
	L.tank_debuffs_desc = "Warnings for the different types of tank debuffs associated with Fearsome Roar."
	L.tank_debuffs_icon = 143766

	L.cage_opened = "Cage opened"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		148145, "adds",
		{"tank_debuffs", "TANK"}, -7963, 143428, 143777, 143783, -- stage 1
		-7981, {-7980, "ICON", "FLASH", "SAY"}, {146589, "FLASH"}, {145974, "DISPEL"},-- stage 2
		"proximity", "berserk", "bosskill",
	}, {
		[148145] = "heroic",
		["tank_debuffs"] = -7960, -- stage 1
		[-7981] = -7961, -- stage 2
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- heroic
	self:Log("SPELL_AURA_APPLIED", "YetCharge", 148145)
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
	self:Log("SPELL_AURA_APPLIED", "Acceleration", 143411)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Acceleration", 143411)
	self:Log("SPELL_CAST_SUCCESS", "FearsomeRoar", 143426, 143780, 143773, 143767) -- Fearsome Roar, Acid Breath, Freezing Breath, Scorching Breath
	self:Log("SPELL_AURA_APPLIED", "TankDebuff", 143766, 143780, 143773, 143767) -- Panic, Acid Breath, Freezing Breath, Scorching Breath
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankDebuff", 143766, 143780, 143773, 143767)

	self:Death("Win", 71529)
	self:Death("Deaths", 71744, 73526, 71749) -- Skumblade Captive, Starved Yeti, Waterspeaker Gorai
end

function mod:OnEngage()
	if self:Heroic() then
		yetiChargeTimer = nil
		heroicAdd = nil
	end
	accCount = 0
	self:Berserk(600)
	self:OpenProximity("proximity", 10) -- it is so you know if you are too close to another group -- XXX this is maybe tactic dependant - needed for heroic
	self:Bar(-7963, 25) -- Deafening Screech
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- heroic

function mod:YetCharge(args)
	self:Bar(args.spellId, 15)
	if not yetiChargeTimer then
		yetiChargeTimer = self:ScheduleTimer("Message", 15, args.spellId, "Important", "Warning", CL["soon"]:format(args.spellName))
	end
end

-- stage 2

function mod:BloodFrenzy(args)
	-- this may feel like double message, but knowing exact stack count on phase change can help plan the rest of the fight
	self:Message(-7981, "Attention", nil, CL["count"]:format(args.spellName, args.amount))
end

function mod:Enrage(args)
	if self:Tank() or self:Dispeller("enrage", true, args.spellId) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert")
	end
end

function mod:SkeletonKeyRemoved(args)
	self:Message(args.spellId, "Positive", "Alert", L["cage_opened"])
	self:StopBar(args.spellId, args.destName)
	self:Bar(-7981, 13, CL["over"]:format(self:SpellName(-7981))) -- Blood Frenzy
end

function mod:SkeletonKey(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	self:TargetBar(args.spellId, 60, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

do
	local function checkPrisonerKilled()
		if heroicAdd then
			-- XXX maybe add scheduled message once we know exact timer (videos)
			-- timer still need verification and still looking for a better event to start bars (don't seem to be any)
			if heroicAdd == "bats" then
				mod:CDBar("adds", 13, mod:SpellName(-8584), 24733) -- bat icon
			elseif heroicAdd == "yeti" then
				mod:CDBar("adds", 10, mod:SpellName(-8582), 26010) -- yeti icon
				heroicAdd = nil
			end
		end
	end
	function mod:BloodFrenzyOver(args)
		self:OpenProximity("proximity", 10)
		self:Message(-7981, "Neutral", "Long", CL["over"]:format(args.spellName))
		self:Bar(-7963, 25) -- Deafening Screech, not much point for more timers than the initial one since then it is too frequent
		if self:Heroic() then
			self:ScheduleTimer(checkPrisonerKilled, 10)
		end
	end
end

function mod:FixateRemoved(args)
	self:PrimaryIcon(-7980)
	self:StopBar(-7980, args.destName)
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
	self:Message(-7963, "Attention", nil, CL["count"]:format(self:SpellName(143411), accCount))
	accCount = 0
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
	accCount = args.amount or 1
	if accCount < 6 or accCount % 3 == 0 then
		self:Message(-7963, "Attention", nil, CL["count"]:format(args.spellName, accCount))
	end
end

function mod:FearsomeRoar(args)
	self:Bar("tank_debuffs", 11, args.spellName, args.spellId)
end

function mod:TankDebuff(args)
	self:StackMessage("tank_debuffs", args.destName, args.amount, "Attention", not self:Me(args.destGUID) and "Warning", args.spellName, args.spellId)
end

function mod:Deaths(args)
	if args.mobId == 71744 then -- Skumblade Captive
		heroicAdd = "bats"
	elseif args.mobId == 71749 then -- Waterspeaker Gorai
		heroicAdd = "yeti"
	elseif args.mobId == 73526 then -- Starved Yeti
		self:CancelTimer(yetiChargeTimer)
		yetiChargeTimer = nil
		heroicAdd = nil
	end
end