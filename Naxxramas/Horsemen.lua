--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("The Four Horsemen", 533)
if not mod then return end
mod:RegisterEnableMob(16063, 16064, 16065, 30549) -- Zeliek, Thane, Blaumeux, Baron
mod:SetAllowWin(true)
mod.engageId = 1121
mod.toggleOptions = {"mark", 28884, 28863, 28883, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local deaths = 0
local marks = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "The Four Horsemen"

	L.mark = "Mark"
	L.mark_desc = "Warn for marks."
	L.markbar = "Mark %d"
	L.markwarn1 = "Mark %d!"
	L.markwarn2 = "Mark %d in 5 sec"

	L.dies = "#%d Killed"

	L.startwarn = "The Four Horsemen Engaged! Mark in ~17 sec"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "VoidZone", 28863, 57463)
	self:Log("SPELL_CAST_START", "Meteor", 28884, 57467)
	self:Log("SPELL_CAST_SUCCESS", "Wrath", 28883, 57466)
	self:Log("SPELL_CAST_SUCCESS", "Mark", 28832, 28833, 28834, 28835) --Mark of Korth'azz, Mark of Blaumeux, Mark of Rivendare, Mark of Zeliek
	self:Death("Deaths", 16063, 16064, 16065, 30549)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	marks = 1
	deaths = 0
	self:Message("mark", L["startwarn"], "Attention")
	self:Bar("mark", L["markbar"]:format(marks), 17, 28835)
	self:DelayedMessage("mark", 12, L["markwarn2"]:format(marks), "Urgent")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths()
	deaths = deaths + 1
	if deaths < 4 then
		self:Message("bosskill", L["dies"]:format(deaths), "Positive")
	else
		self:Win()
	end
end

function mod:VoidZone(_, spellId, _, _, spellName)
	self:Message(28863, spellName, "Important", spellId)
	self:Bar(28863, spellName, 12, spellId)
end

function mod:Meteor(_, spellId, _, _, spellName)
	self:Message(28884, spellName, "Important", spellId)
	self:Bar(28884, spellName, 12, spellId)
end

function mod:Wrath(_, spellId, _, _, spellName)
	self:Message(28883, spellName, "Important", spellId)
	self:Bar(28883, spellName, 12, spellId)
end

local last = 0
function mod:Mark()
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		self:Message("mark", L["markwarn1"]:format(marks), "Important", 28835)
		marks = marks + 1
		self:Bar("mark", L["markbar"]:format(marks), 12, 28835)
		self:DelayedMessage("mark", 7, L["markwarn2"]:format(marks), "Urgent")
	end
end

