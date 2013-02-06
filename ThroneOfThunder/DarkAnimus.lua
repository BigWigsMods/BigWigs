--[[
TODO:
	Crimson Wake needs to be switched to CLEU ASAP
	could be fun to place 2nd icon for furthest target for Matter Swap, not sure about usefullness, revisit during 25 man testing
	could maybe used UNIT_POWER to warn SOON for abilities that only enable after a certain amount of power
	does not seem possible right now ( 10 N PTR ) but would be nice if we could tell how many active golems are there when boss enters the fight
		then we could try to estimate how soon it'll reach full power
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

local crimsonWake = mod:SpellName(138485)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "The orb explodes!"
	L.slam, L.slam_desc = EJ_GetSectionInfo(7770)
	L.slam_icon = 138569
	L.slam_message = "Slam"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{138485, "FLASH", "SAY"},
		{138609, "FLASH", "ICON"}, {"slam", "TANK"},
		138644, {136954, "TANK"}, 138691, 138780, {138763, "FLASH"}, {138729, "FLASH"},
		"berserk", "bosskill",
	}, {
		[138485] = "ej:7759", -- Large Anima Golem
		[138609] = "ej:7760", -- Massive Anima Golem
		[138644] = "ej:7762", -- Dark Animus
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "BossEngage") -- use it to detect when the actual boss enters the fight
	self:Emote("Engage", L["engage_trigger"])

	-- Dark Animus
	self:Log("SPELL_CAST_START", "FullPower", 138729)
	self:Log("SPELL_CAST_START", "InterruptingJolt", 138763)
	self:Log("SPELL_AURA_APPLIED", "Empower", 139430) -- Empower and Animate
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
	self:RgisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- XXX Crimson Wake needs to be switched to CLEU ASAP

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
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Long")
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
		self:Message(args.spellId, args.spellName, color, args.spellId, sound)
		if caster then self:Flash(args.spellId) end
	end
end

function mod:Empower(args)
	self:Message(138780, args.spellName, "Attention", args.spellId)
	self:Bar(138780, "~"..args.spellName, 30, args.spellId)
end

function mod:AnimaFont(args)
	self:Message(args.spellId, args.spellName, "Urgent", args.spellId, "Alarm")
	self:Bar(args.spellId, CL["cast"]:format(args.spellName), 30, args.spellId) -- this is duration, cooldowns seems to be 33-46
end

function mod:AnimaRing(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Alert")
	self:Bar(args.spellId, "~"..args.spellName, 22, args.spellId)
end

function mod:SiphonAnima(args)
	self:Message(args.spellId, args.spellName, "Attention", args.spellId)
	self:Bar(args.spellId, args.spellName, 30, args.spellId)
end

function mod:BossEngage()
	if not self.isEngaged then return end -- XXX is this even needed?
	if 69427 == self:GetCID(UnitGUID("boss1")) then
		self:Bar(138644, 138644, 30, 138644) -- Siphon Anima
	end
end

--------------------------------------------------------------------------------
-- Massive Anima Golem
--

function mod:ExplosiveSlam(args)
	args.amount = args.amount or 1
	self:LocalMessage("slam", CL["stack"], "Urgent", args.spellId, "Info", args.destName, args.amount, L["slam_message"])
	-- not sure if bars are needed
	self:StopBar(("%s: %s (%d)"):format(L["slam_message"], args.destName, args.amount-1))
	self:Bar("slam", ("%s: %s (%d)"):format(L["slam_message"], args.destName, args.amount), 25, args.spellId)
end

function mod:MatterSwapRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(CL["other"]:format(args.spellName, args.destName))
end

function mod:MatterSwapApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if UnitIsUnit("player", args.destName) then
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
		self:Flash(args.spellId)
	elseif self:Dispeller("magic") then
		self:LocalMessage(args.spellId, args.spellName, "Important", args.spellId, "Alarm", args.destName)
		self:Bar(args.spellId, CL["other"]:format(args.spellName, args.destName), 12, args.spellId)
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
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg, sender)
	if sender == crimsonWake then -- Crimson Wake
		self:Say(138485, CL["say"]:format(crimsonWake))
		self:Bar(138485, CL["you"]:format(crimsonWake), 30, 138485)
		self:DelayedMessage(138485, 30, CL["over"]:format(crimsonWake), "Positive", 138485)
		self:LocalMessage(138485, CL["you"]:format(crimsonWake), "Urgent", 138485, "Alarm")
		self:Flash(138485)
	end
end


