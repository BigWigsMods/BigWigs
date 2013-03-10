--[[
TODO:
	-- consider handling growing fury to adjust stone breath bar
]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tortos", 930, 825)
if not mod then return end
mod:RegisterEnableMob(67977)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.kick = "Kick"
	L.kick_desc = "Keep track of how many turtles can be kicked."
	L.kick_icon = 1766
	L.kick_message = "Kickable turtles: %d"

	L.crystal_shell_removed = "Crystal Shell removed!"
	L.no_crystal_shell = "NO Crystal Shell"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Locals
--

local kickable = 0
local crystalTimer = nil
local crystalShell = mod:SpellName(137633)

local function warnCrystalShell()
	if UnitDebuff("player", crystalShell) or UnitIsDeadOrGhost("player") then
		mod:CancelTimer(crystalTimer)
		crystalTimer = nil
	else
		mod:Message(137633, "Personal", "Info", L["no_crystal_shell"])
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{137633, "FLASH"},
		136294, -7134, 133939, {134539, "FLASH"}, 134920, {135251, "TANK"}, -7140,
		"kick", "berserk", "bosskill",
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
	self:Log("SPELL_CAST_START", "SnappingBite", 135251)
	self:Log("SPELL_CAST_START", "QuakeStomp", 134920)
	self:Log("SPELL_DAMAGE", "Rockfall", 134539)
	self:Log("SPELL_CAST_START", "FuriousStoneBreath", 133939)
	self:Log("SPELL_CAST_SUCCESS", "KickShell", 134031)
	self:Log("SPELL_CAST_SUCCESS", "ShellBlock", 133971)
	self:Log("SPELL_CAST_START", "CallOfTortos", 136294)

	self:RegisterUnitEvent("UNIT_AURA", "ShellConcussion", "boss1")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "SummonBats", "boss1")

	self:Death("Win", 67977)
end

function mod:OnEngage()
	kickable = 0
	self:Berserk(600) -- XXX ASSUMED
	self:Bar(-7140, 46, 136686) -- Summon Bats
	self:Bar(133939, 46) -- Furious Stone Breath
	self:Bar(136294, 21) -- Call of Tortos
	self:Bar(134920, 30) -- Quake Stomp
	if self:Heroic() then
		if not UnitDebuff("player", crystalShell) then -- Here we can warn tanks too
			self:Message(137633, "Personal", "Info", L["no_crystal_shell"])
			crystalTimer = self:ScheduleRepeatingTimer(warnCrystalShell, 3)
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:CrystalShellRemoved(args)
	if not self:Me(args.destGUID) or self:Tank() then return end
	self:Flash(args.spellId)
	self:Message(args.spellId, "Urgent", "Alarm", L["crystal_shell_removed"]) -- I think this should stay Urgent Alarm
	crystalTimer = self:ScheduleRepeatingTimer(warnCrystalShell, 3)
end

function mod:SnappingBite(args)
	-- don't think there is a point to have an 8 sec CD bar for tanks
	self:Message(args.spellId, "Attention")
end

function mod:SummonBats(_, _, _, _, spellId)
	if spellId == 136685 then
		self:Message(-7140, "Urgent", self:Tank() and not UnitIsUnit("boss1target", "player") and "Warning", 136686) -- Summon Bats
		self:Bar(-7140, 46, 136686)
	end
end

function mod:QuakeStomp(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Bar(args.spellId, 47)
end

do
	local prev = 0
	function mod:Rockfall(args)
		if not self:Me(args.destGUID) then return end
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
	local scheduled = nil
	local function announceKickable()
		mod:Message("kick", "Attention", nil, L["kick_message"]:format(kickable), 1766)
		scheduled = nil
	end
	function mod:ShellBlock()
		kickable = kickable + 1
		if not scheduled then
			scheduled = self:ScheduleTimer(announceKickable, 2)
		end
	end
	function mod:KickShell(args)
		kickable = kickable - 1
		if not scheduled then
			scheduled = self:ScheduleTimer(announceKickable, 2)
		end
	end
end

do
	local concussion = mod:SpellName(136431)
	local prev = 0
	local UnitDebuff = UnitDebuff
	function mod:ShellConcussion(unit)
		local _, _, _, _, _, duration, expires = UnitDebuff(unit, concussion)
		if expires and expires ~= prev then
			if expires-prev > 4 then -- don't spam the message
				self:Message(-7134, "Positive", "Info")
			end
			self:Bar(-7134, duration)
			prev = expires
		end
	end
end

function mod:CallOfTortos(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 60)
end

