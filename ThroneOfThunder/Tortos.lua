--[[
TODO:
	-- consider handling growing fury to adjust ston breath bar
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
	L.crystal_shell_removed = "Crystal Shell removed!"
	L.no_crystal_shell = "NO Crystal Shell"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{137633, "FLASH"},
		136294, "kick", 133939, {134539, "FLASH"}, 134920, "ej:7140",
		"berserk", "bosskill",
	}, {
		[137633] = "heroic",
		[136294] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Heroic
	self:Log("SPELL_AURA_REMOVED", "CrystalShellRemoved", 137633)
	-- Normal
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "SummonBats", "boss1")
	self:Log("SPELL_CAST_START", "QuakeStomp", 134920)
	self:Log("SPELL_DAMAGE", "Rockfall", 134539)
	self:Log("SPELL_CAST_START", "FuriousStoneBreath", 133939)
	self:Log("SPELL_AURA_APPLIED", "ShellConcussion", 134092)
	self:Log("SPELL_AURA_APPLIED", "ShellBlock", 133971)
	self:Log("SPELL_CAST_START", "CallOfTortos", 136294)

	self:Death("Win", 67977)
end

function mod:OnEngage()
	kickable = 0
	self:Bar("ej:7140", 46, 136685) -- Summon Bats
	self:Bar(133939, 46) -- Furious Stone Breath
	self:Bar(136294, 21) -- Call of Tortos
	self:Bar(134920, 30) -- Quake Stomp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local timer = nil
	local function warnCrystalShell(spellId)
		if UnitDebuff("player", mod:SpellName(spellId)) or UnitIsDeadOrGhost("player") then
			mod:CancelTimer(timer)
			timer = nil
			return
		end
		mod:Message(spellId, "Personal", "Info", L["no_crystal_shell"])
	end
	function mod:CrystalShellRemoved(args)
		if not UnitIsUnit("player", args.destName) or self:Tank() then return end
		self:Flash(args.spellId)
		self:Message(args.spellId, "Urgent", "Alarm", L["crystal_shell_removed"]) -- I think this should stay Urgent Alarm
		if not timer then
			timer = self:ScheduleRepeatingTimer(warnCrystalShell, 3, args.spellId)
		end
	end
end

function mod:SummonBats(_, _, _, _, spellId)
	if spellId == 136685 then
		self:Message("ej:7140", "Urgen", nil, spellId)
		self:Bar("ej:7140", 46, spellId)
	end
end

function mod:QuakeStomp(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Bar(args.spellId, 47)
end

do
	local prev = 0
	function mod:Rockfall(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName)) -- it is probably over you not under you
			self:Flash(args.spellId)
		end
	end
end

function mod:FuriousStoneBreath(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 46)
end

do
	local function announceKickable()
		mod:Message("kick", L["kickable_turtles"]:format(kickable), "Attention", 1766)
	end
	function mod:ShellBlock()
		kickable = kickable + 1
		self:ScheduleTimer(announceKickable, 2)
	end
	function mod:ShellConcussion()
		kickable = kickable - 1
		self:ScheduleTimer(announceKickable, 2)
	end
end

function mod:CallOfTortos(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 60)
end
