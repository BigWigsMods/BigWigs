--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("The Four Horsemen", 533)
if not mod then return end
mod:RegisterEnableMob(16062, 16063, 16064, 16065) -- Mograine, Zeliek, Thane, Blaumeux
mod:SetAllowWin(true)
mod.engageId = 1121

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
	L.mark_icon = 28835 -- Mark of Zeliek

	L.markbar = "Mark %d"
	L.markwarn1 = "Mark %d!"
	L.markwarn2 = "Mark %d in 5 sec"

	L.startwarn = "The Four Horsemen Engaged! Mark in ~20 sec"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"mark",
		28884, -- Meteor (Korth'azz)
		28863, -- Void Zone (Blaumeux)
		28883, -- Holy Wrath (Zeliek)
		29061, -- Shield Wall
		"stages",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Mark", 28832, 28833, 28834, 28835) -- Mark of Korth'azz, Mark of Blaumeux, Mark of Mograine, Mark of Zeliek
	self:Log("SPELL_CAST_START", "Meteor", 28884)
	self:Log("SPELL_CAST_SUCCESS", "VoidZone", 28863)
	self:Log("SPELL_CAST_SUCCESS", "Wrath", 28883)
	self:Log("SPELL_AURA_APPLIED", "ShieldWall", 29061)

	self:Death("Deaths", 16063, 16063, 16064, 16065)
end

function mod:OnEngage()
	marks = 1
	deaths = 0
	-- berserk is at 100 marks, so 1297s or ~21.5 min? lol
	self:Message("mark", "yellow", L.startwarn, false)
	self:CDBar("mark", 20, L.markbar:format(marks), L.mark_icon)
	-- self:DelayedMessage("mark", 15, "orange", L.markwarn2:format(marks))
	-- initial spell casts are with the first mark, with Void Zone 3~6s earlier
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	self:CancelDelayedMessage(CL.other:format(args.destName, CL.over:format(self:SpellName(29061))))
	deaths = deaths + 1
	if deaths < 4 then
		self:Message("stages", "green", CL.mob_killed:format(args.destName, deaths, 4), false)
	end
end

function mod:Meteor(args)
	self:Message(28884, "red")
	self:CDBar(28884, 12) -- 11~14
end

function mod:VoidZone(args)
	self:Message(28863, "orange")
	self:CDBar(28863, 12) -- 11~14
end

function mod:Wrath(args)
	self:Message(28883, "yellow")
	self:CDBar(28883, 12) -- 11~14
end

function mod:ShieldWall(args)
	self:Message(29061, "yellow", CL.other:format(args.destName, args.spellName))
	self:DelayedMessage(29061, 20, "green", CL.other:format(args.destName, CL.over:format(args.spellName)))
	self:Bar(29061, 20, args.destName)
end

local prev = 0
function mod:Mark(args)
	local t = GetTime()
	if t-prev > 5 then
		prev = t
		self:Message("mark", "red", L.markwarn1:format(marks), L.mark_icon)
		marks = marks + 1
		self:CDBar("mark", 12.9, L.markbar:format(marks), 28835)
		-- self:DelayedMessage("mark", 7.9, "orange", L.markwarn2:format(marks), L.mark_icon) -- every 8s is a bit much imo
	end
end
