--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Loatheb", 533)
if not mod then return end
mod:RegisterEnableMob(16011)
mod:SetAllowWin(true)
mod:SetEncounterID(1115)

--------------------------------------------------------------------------------
-- Locals
--

local doomTime = 30
local sporeCount = 1
local doomCount = 1
local healerList = {}
local healerDebuffTime = {}

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
		{29185, "TANK_HEALER", "INFOBOX"}, -- Corrupted Mind
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PoisonAura", 29865)
	self:Log("SPELL_CAST_SUCCESS", "Doom", 29204)
	self:Log("SPELL_CAST_SUCCESS", "Decurse", 30281)
	self:Log("SPELL_CAST_SUCCESS", "Spore", 29234)
	self:Log("SPELL_AURA_APPLIED", "CorruptedMind", 29185, true)
	self:Log("SPELL_AURA_REMOVED", "CorruptedMindRemoved", 29185, true)

	self:Death("Win", 16011)
end

local function swapTime() doomTime = 15 end
function mod:OnEngage()
	doomTime = 30
	sporeCount = 1
	doomCount = 1
	healerList = {}
	healerDebuffTime = {}

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
	self:DelayedMessage(29204, 300, "red", L.doomtime_now, "alarm")

	-- Corrupted Mind
	self:OpenInfo(29185, self:SpellName(29185), 2)
	self:ScheduleTimer("UpdateHealerList", 0.1)
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
	-- the debuff that prevents healing is self-applied
	if args.sourceGUID ~= args.destGUID then return end

	if self:Me(args.destGUID) then
		self:Bar(29185, 60, args.spellName, 29184) -- 29184 = spell_shadow_auraofdarkness
	end
	tDeleteItem(healerList, args.destName)
	healerList[#healerList + 1] = args.destName
	healerDebuffTime[args.destName] = GetTime() + 60
end

function mod:CorruptedMindRemoved(args)
	if args.sourceGUID ~= args.destGUID then return end

	if self:Me(args.destGUID) then
		self:Message(29185, "green", CL.removed:format(args.spellName), 29184)
		self:PlaySound(29185, "info")
	end
end

function mod:UpdateHealerList()
	if not self:IsEngaged() then return end
	self:ScheduleTimer("UpdateHealerList", 0.1)

	-- Healer rotation lite
	local t = GetTime()
	local line = 1
	for i = 1, 10 do
		local player = healerList[i]
		if player then
			local remaining = healerDebuffTime[player] - t
			self:SetInfo(29185, line, self:ColorName(player))
			if remaining > 0 then
				self:SetInfo(29185, line + 1, CL.seconds:format(remaining))
				self:SetInfoBar(29185, line, remaining / 60)
			else
				self:SetInfo(29185, line + 1, ("|cff20ff20%s|r"):format(_G.READY))
				self:SetInfoBar(29185, line, 0)
			end
		else
			self:SetInfo(29185, line, "")
			self:SetInfo(29185, line + 1, "")
			self:SetInfoBar(29185, line, 0)
		end
		line = line + 2
	end
end
