--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Baleroc", 800, 196)
if not mod then return end
mod:RegisterEnableMob(53494)

local countdownTargets = mod:NewTargetList()
local countdownCounter, count = 1, 0

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.torment = "Torment stacks on Focus"
	L.torment_desc = "Warn when your /focus gains another torment stack."
	L.torment_icon = 99256
	-- L.torment_message = "%2$dx torment on %1$s"

	L.blade_bar = "~Next Blade"
	L.shard_message = "Purple shards (%d)!"
	L.focus_message = "Your focus has %d stacks!"
	L.countdown_bar = "Next link"
	L.link_message = "Linked"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99259, "torment", "ej:2598", --Blades of Baleroc
		"berserk", "bosskill",
		{99516, "FLASHSHAKE", "ICON"}
	}, {
		[99259] = "general",
		[99516] = "heroic"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Countdown", 99516)
	self:Log("SPELL_CAST_START", "Shards", 99259)
	self:Log("SPELL_CAST_START", "Blades", 99405, 99352, 99350)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Torment", 99256, 100230, 100231, 100232)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53494)
end

function mod:OnEngage(diff)
	self:Berserk(360)
	self:Bar(99259, (GetSpellInfo(99259)), 5, 99259) -- Shard of Torment
	self:Bar(99352, L["blade_bar"], 30, 99352)
	if diff > 2 then
		self:Bar(99516, L["countdown_bar"], 25, 99516) -- Countdown
		countdownCounter = 1
	end
	count = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Blades(_, spellId, _, _, spellName)
	self:Message("ej:2598", spellName, "Attention", spellId)
	self:Bar("ej:2598", L["blade_bar"], 47, spellId)
end

do
	local scheduled = nil
	local function countdownWarn()
		mod:TargetMessage(99516, L["link_message"], countdownTargets, "Important", 99516, "Alarm")
		scheduled = nil
	end
	function mod:Countdown(player, spellId)
		self:Bar(99516, L["countdown_bar"], 47.6, spellId)
		if UnitIsUnit(player, "player") then
			self:FlashShake(99516)
		end
		if countdownCounter == 1 then
			self:PrimaryIcon(99516, player)
			countdownCounter = 2
		else
			self:SecondaryIcon(99516, player)
			countdownCounter = 1
		end
		countdownTargets[#countdownTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(countdownWarn, 0.1)
		end
	end
end

function mod:Shards(_, spellId, _, _, spellName)
	count = count + 1
	self:Message(99259, L["shard_message"]:format(count), "Urgent", spellId, "Alert")
	self:Bar(99259, spellName, 34, spellId)
end

function mod:Torment(player, spellId, _, _, _, stack)
	if UnitIsUnit("focus", player) and stack > 5 then
		self:LocalMessage("torment", L["focus_message"]:format(stack), "Personal", spellId, "Info")
	end
end

