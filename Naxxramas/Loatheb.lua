--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Loatheb", 533)
if not mod then return end
mod:RegisterEnableMob(16011)
mod:SetAllowWin(true)
mod.engageId = 1115

--------------------------------------------------------------------------------
-- Locals
--

local doomTime = 30
local sporeCount = 1
local doomCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Loatheb"

	L.startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!"

	L.doom_5sec_warn = "Doom (%d) in 5 sec!"
	L.doomtime_bar = "Doom every 15 sec"
	L.doomtime_warn = "Doom timer changes in %s sec!"
	L.doomtime_now = "Doom now happens every 15 sec!"

	L.remove_curse = "Curses removed on Loatheb"

	L.spore_warn = "Spore (%d)"

	L.corrupted_mind = 29185
	L.corrupted_mind_desc = "Show bar for your own Corrupted Mind debuff."
	L.corrupted_mind_icon = 29185
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		29865, -- Poison Aura
		29204, -- Inevitable Doom
		30281, -- Remove Curse
		29234, -- Summon Spore
		"corrupted_mind", -- Corrupted Mind
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PoisonAura", 29865)
	self:Log("SPELL_CAST_SUCCESS", "Doom", 29204)
	self:Log("SPELL_CAST_SUCCESS", "Decurse", 30281)
	self:Log("SPELL_CAST_SUCCESS", "Spore", 29234)
	self:Log("SPELL_AURA_APPLIED", "CorruptedMind", 29185)
	self:Log("SPELL_AURA_REMOVED", "CorruptedMindRemoved", 29185)

	self:Death("Win", 16011)
end

local function swapTime() doomTime = 15 end
function mod:OnEngage()
	doomTime = 30
	sporeCount = 1
	doomCount = 1

	self:Message(29204, "yellow", L.startwarn, false)
	self:Bar(29204, 120, CL.count:format(self:SpellName(29204), doomCount))
	self:DelayedMessage(29204, 115, "orange", L.doom_5sec_warn:format(doomCount))

	-- This is the berserk
	self:Bar(29204, 300, L.doomtime_bar)
	self:ScheduleTimer(swapTime, 300)
	self:DelayedMessage(29204, 240, "yellow", L.doomtime_warn:format(60))
	self:DelayedMessage(29204, 270, "yellow", L.doomtime_warn:format(30))
	self:DelayedMessage(29204, 290, "orange", L.doomtime_warn:format(10))
	self:DelayedMessage(29204, 295, "red", L.doomtime_warn:format(5))
	self:DelayedMessage(29204, 300, "red", L.doomtime_now, "Alarm")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PoisonAura(args)
	self:Message(29865, "yellow")
	self:Bar(29865, 12)
end

function mod:Doom(args)
	self:Message(29204, "orange", CL.count:format(args.spellName, doomCount))
	doomCount = doomCount + 1
	self:Bar(29204, doomTime, CL.count:format(args.spellName, doomCount))
	self:DelayedMessage(29204, doomTime - 5, "red", L.doom_5sec_warn:format(doomCount))
end

function mod:Decurse(args)
	self:Message(30281, "green")
	self:Bar(30281, 30)
end

function mod:Spore(args)
	self:Message(29234, "red", L.spore_warn:format(sporeCount), 3674) -- 3674 = Black Arrow
	sporeCount = sporeCount + 1
	self:Bar(29234, 12, CL.count:format(args.spellName, sporeCount), 3674)
end

function mod:CorruptedMind(args)
	if self:Me(args.destGUID) then
		self:Bar("corrupted_mind", 60, 29185)
	end
end

function mod:CorruptedMindRemoved(args)
	if self:Me(args.destGUID) then
		self:Message("corrupted_mind", "green", CL.removed:format(args.spellName), 29185)
		self:PlaySound("corrupted_mind", "info")
	end
end
