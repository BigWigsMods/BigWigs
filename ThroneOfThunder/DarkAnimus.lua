--[[
TODO:
	Crimson Wake needs to be switched to CLEU ASAP
	could be fun to place 2nd icon for furthest target for Matter Swap, not sure about usefullness, revisit during 25 man testing
	could maybe used UNIT_POWER to warn SOON for abilities that only enable after a certain amount of power
	does not seem possible right now ( 10 H PTR ) but would be nice if we could tell accurately how many active golems are there when boss enters the fight
		then we could try to estimate how soon it'll reach full power
	add bar for interrupting jolt
	check if interrupting jolt spellId changed, or there are just a new for heroic
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dark Animus", 930, 824)
if not mod then return end
mod:RegisterEnableMob(69701, 69700, 69699, 69427) -- Anima Golem, Large Anima Golem, Massive Anima Golem, Dark Animus

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "The orb explodes!"
	L.slam_message = "Slam"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{138485, "FLASH", "SAY"},
		{138609, "FLASH", "ICON"}, {-7770, "TANK"},
		138644, {136954, "TANK"}, 138691, 138780, {138763, "FLASH"}, {138729, "FLASH"},
		"berserk", "bosskill",
	}, {
		[138485] = -7759, -- Large Anima Golem
		[138609] = -7760, -- Massive Anima Golem
		[138644] = -7762, -- Dark Animus
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "BossEngage") -- use it to detect when the actual boss enters the fight
	self:Emote("Engage", L["engage_trigger"])

	-- Dark Animus
	self:Log("SPELL_CAST_START", "FullPower", 138729)
	self:Log("SPELL_CAST_START", "InterruptingJolt", 138763, 139867)
	self:Log("SPELL_CAST_SUCCESS", "Empower", 138780) -- Empower Golem
	self:Log("SPELL_AURA_APPLIED", "AnimaFont", 138691)
	self:Log("SPELL_CAST_START", "AnimaRing", 136954) -- this is 1 sec faster than SUCCESS but has no destName
	self:Log("SPELL_CAST_SUCCESS", "SiphonAnima", 138644)
	-- Massive Anima Golem
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExplosiveSlam", 138569)
	self:Log("SPELL_AURA_APPLIED", "ExplosiveSlam", 138569)
	self:Log("SPELL_AURA_REMOVED", "MatterSwapRemoved", 138609)
	self:Log("SPELL_AURA_APPLIED", "MatterSwapApplied", 138609)
	-- Large Anima Golem
	self:Log("SPELL_DAMAGE", "CrimsonWake", 138485)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- XXX Crimson Wake needs to be switched to CLEU ASAP

	self:Death("Win", 69427)
end

function mod:OnEngage()
	self:Berserk(600) -- assumed
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- Dark Animus
--

function mod:FullPower(args)
	self:Message(args.spellId, "Important", "Long")
	self:Flash(args.spellId)
end

do
	local _, class = UnitClass("player")
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return end
		if mod:Healer() then return true end
		return true
	end

	function mod:InterruptingJolt(args)
		local caster = isCaster()
		local color = caster and "Personal" or "Attention"
		local sound = caster and "Long" or nil
		self:Message(args.spellId, color, sound)
		if caster then self:Flash(args.spellId) end
	end
end

function mod:Empower(args)
	self:Message(138780, "Attention")
	self:CDBar(138780, self:Heroic() and 17 or 30)
end

function mod:AnimaFont(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:Bar(args.spellId, 30, CL["cast"]:format(args.spellName)) -- this is duration, cooldowns seems to be 33-46
end

function mod:AnimaRing(args)
	self:Message(args.spellId, "Important", "Alert")
	self:CDBar(args.spellId, 22)
end

function mod:SiphonAnima(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 30)
end

function mod:BossEngage()
	self:CheckBossStatus()
	if not self.isEngaged then return end -- XXX is this even needed?
	if 69427 == self:MobId(UnitGUID("boss1")) then
		self:Bar(138644, self:Heroic() and 120 or 30) -- Siphon Anima
		if self:Heroic() then
			self:Bar(138780, 7) -- Empower
		end
	end
end

--------------------------------------------------------------------------------
-- Massive Anima Golem
--

function mod:ExplosiveSlam(args)
	args.amount = args.amount or 1
	self:StackMessage(-7770, args.destName, args.amount, "Urgent", "Info", L["slam_message"])
	-- not sure if bars are needed
	self:StopBar(("%s: %s (%d)"):format(L["slam_message"], args.destName, args.amount-1))
	self:Bar(-7770, 25, ("%s: %s (%d)"):format(L["slam_message"], args.destName, args.amount))
end

function mod:MatterSwapRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(CL["other"]:format(args.spellName, args.destName))
end

function mod:MatterSwapApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if UnitIsUnit("player", args.destName) then
		self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
		self:Flash(args.spellId)
	elseif self:Dispeller("magic") then
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true)
		self:Bar(args.spellId, 12, CL["other"]:format(args.spellName, args.destName))
	end
end

--------------------------------------------------------------------------------
-- Large Anima Golem
--

do
	local prev = 0
	function mod:CrimsonWake(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg, sender)
	if sender == mod:SpellName(138485) then -- Crimson Wake
		self:Say(138485)
		self:Bar(138485, 30, CL["you"]:format(sender))
		self:DelayedMessage(138485, 30, "Positive", CL["over"]:format(sender))
		self:Message(138485, "Urgent", "Alarm", CL["you"]:format(sender))
		self:Flash(138485)
	end
end
