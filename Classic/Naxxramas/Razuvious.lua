--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Instructor Razuvious", 533)
if not mod then return end
mod:RegisterEnableMob(16061, 16803) -- Instructor Razuvious, Deathknight Understudy
mod:SetAllowWin(true)
mod.engageId = 1113

--------------------------------------------------------------------------------
-- Locals
--

local activeUnderstudy
local understudyIcons = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Instructor Razuvious"
	L.understudy = "Deathknight Understudy"

	L.taunt_warning = "Taunt ready in 5sec!"
	L.shieldwall_warning = "Barrier gone in 5sec!"

	L.shout = 29107
	L.shout_icon = 6673
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"shout", -- Disrupting Shout
		29060, -- Taunt
		29061, -- Shield Wall
		29051, -- Mind Exhaustion
	}, {
		[29060] = L.understudy,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Shout", 29107)
	self:Log("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:Log("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:Log("SPELL_AURA_APPLIED", "Exhaustion", 29051)

	self:Log("SPELL_AURA_APPLIED", "MindControl", 10912, true) -- player source
	self:Death("Deaths", 16803) -- Deathknight Understudy
end

function mod:OnEngage()
	understudyIcons = {}
	self:CDBar("shout", 25, L.shout, L.shout_icon)
	self:DelayedMessage("shout", 20, "orange", CL.soon:format(self:SpellName(L.shout)), L.shout_icon, "alert")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MindControl(args)
	local icon = CombatLog_String_GetIcon(args.destRaidFlags)
	if icon == "" then icon = nil end
	understudyIcons[args.destGUID] = icon
	activeUnderstudy = args.destGUID
end

function mod:Deaths(args)
	if args.destGUID == activeUnderstudy then
		self:StopBar(29060) -- Taunt
		self:CancelDelayedMessage(L.taunt_warning)
		self:StopBar(29061) -- Shield Wall
		self:CancelDelayedMessage(L.shieldwall_warning)
	end
	local icon = understudyIcons[args.destGUID]
	if icon then
		self:StopBar(icon .. self:SpellName(29051))
	end
end

function mod:Shout(args)
	self:Message("shout", "red", args.spellName, L.shout_icon)
	self:CDBar("shout", 25, args.spellName, L.shout_icon)
	self:DelayedMessage("shout", 20, "orange", CL.soon:format(args.spellName), L.shout_icon, "alert")
end

function mod:Taunt(args)
	self:Message(29060, "green")
	self:Bar(29060, 20)
	self:DelayedMessage(29061, 15, "orange", L.taunt_warning)
end

function mod:ShieldWall(args)
	self:Message(29061, "green")
	self:Bar(29061, 20)
	self:DelayedMessage(29060, 15, "yellow", L.shieldwall_warning)
end

function mod:Exhaustion(args)
	local icon = understudyIcons[args.destGUID]
	if icon then
		-- Not much of a point if they aren't marked
		self:StartBar(29051, 60, icon .. args.spellName)
	end
end
