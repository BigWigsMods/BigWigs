--[[
TODO:
	-- need transcriptor log ( mainly to get timers after engage )
	-- vampiric cave bat spawn timer
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tortos", 930, 825)
if not mod then return end
mod:RegisterEnableMob(67977)

--------------------------------------------------------------------------------
-- Locals
--

local kickable = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.kick = "Kick"
	L.kick_desc = "Keep track of how many turtles can be kicked"
	L.kick_icon = 1766
	L.kickable_turtles = "Kickable turtles: %d"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		136294, "kick", 133939, {134539, "FLASH"}, 134920,
		"berserk", "bosskill",
	}, {
		[136294] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "QuakeStomp", 133939)
	self:Log("SPELL_DAMAGE", "Rockfall", 134539)
	self:Log("SPELL_CAST_START", "FuriousStoneBreath", 133939)
	self:Log("SPELL_AURA_APPLIED", "ShellConcussion", 134092)
	self:Log("SPELL_AURA_APPLIED", "ShellBlock", 133971)
	self:Log("SPELL_CAST_START", "CallOfTortos", 136294)

	self:Death("Win", 67977)
end

function mod:OnEngage()
	kickable = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:QuakeStomp(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Alert")
	self:Bar(args.spellId, args.spellName, 47, args.spellId)
end

do
	local prev = 0
	function mod:Rockfall(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info") -- it is probably over you not under you
			self:Flash(args.spellId)
		end
	end
end

function mod:FuriousStoneBreath(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Long")
	self:Bar(args.spellId, args.spellName, 46, args.spellId)
end

do
	local function announceKickable()
		mod:Message("kick", L["kickable_turtles"], "Attention", 1766)
	end
	function mod:ShellBlock()
		kickable = kickable + 1
		self:ScheduleTimer(announceKickable, 2)
	end
	function mod:ShellBlock()
		kickable = kickable - 1
		self:ScheduleTimer(announceKickable, 2)
	end
end

function mod:CallOfTortos(args)
	self:Message(args.spellId, args.spellName, "Urgent", args.spellId)
	self:Bar(args.spellId, args.spellName, 60, args.spellId)
end


