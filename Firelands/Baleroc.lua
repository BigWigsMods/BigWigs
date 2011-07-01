--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Baleroc", 800, 196)
if not mod then return end
mod:RegisterEnableMob(53494)

local countdownTargets = mod:NewTargetList()
local countdownCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.torment_message = "%2$dx torment on %1$s"
	L.blade = "~Blade"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99259, 100230, 99352, "berserk", "bosskill",
		{99516, "FLASHSHAKE", "ICON"}
	}, {
		[99259] = "general",
		[99516] = "heroic"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Countdown", 99516)
	self:Log("SPELL_CAST_START", "TormentTimer", 99259)
	self:Log("SPELL_CAST_START", "Blades", 99405, 99350)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Torment", 100230, 100231, 100232)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53494)
end

function mod:OnEngage(diff)
	self:Berserk(360)
	self:Bar(99259, (GetSpellInfo(99259)), 5, 99259) -- Shard of Torment
	self:Bar(99352, L["blade"], 30, 99352)
	if diff > 2 then
		self:Bar(99516, (GetSpellInfo(99516)), 25, 99516) -- Countdown
		countdownCounter = 1
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Blades(_, spellId, _, _, spellName)
	self:Message(99352, spellName, "Attention", spellId)
	self:Bar(99352, L["blade"], 47, spellId)
end

do
	local scheduled = nil
	local function countdownWarn(spellName)
		mod:TargetMessage(99516, spellName, countdownTargets, "Important", 99516)
		scheduled = nil
	end
	function mod:Countdown(player, spellId, _, _, spellName)
		self:Bar(99516, spellName, 47.6, spellId)
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
			self:ScheduleTimer(countdownWarn, 0.1, spellName)
		end
	end
end

function mod:TormentTimer(_, spellId, _, _, spellName)
	self:Message(99259, spellName, "Important", spellId, "Alert")
	self:Bar(99259, spellName, 34, spellId)
end

function mod:Torment(player, spellId, _, _, _, stack)
	local diff = self:Difficulty()
	if (stack == 5 and (diff == 2 or diff == 4)) or (stack == 6 and (diff == 1 or diff == 3)) then
		self:TargetMessage(100230, L["torment_message"], player, "Important", 100230, nil, stack)
	end
end

