if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Baleroc", 800)
if not mod then return end
mod:RegisterEnableMob(53494)

local iconCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.torment_message = "%2$dx torment on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99259, {100230, "ICON"},
		"bosskill"
	}, {
		[99259] = "general"
	}
end

function mod:OnBossEnable()

	self:Log("SPELL_CAST_START", "TormentTimer", 99259)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Torment", 100230)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53494)
end

function mod:OnEngage(diff)
	iconCounter = 1
	self:Bar(99259, (GetSpellInfo(99259)), 5, 99259) -- Shard of Torment
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TormentTimer(_, spellId, _, _, spellName)
	self:Message(99259, spellName, "Important", spellId, "Alert")
	self:Bar(99259, spellName, 34, spellId)
end

function mod:Torment(player, spellId, _, _, _, stack)
	if stack == 5 then -- for 25 man
		self:TargetMessage(100230, L["torment_message"], player, "Important", 100230, _, stack)
		if iconCounter == 1 then
			self:PrimaryIcon(100230, player)
			iconCounter = 2
		else
			self:SecondaryIcon(100230, player)
			iconCounter = 1
		end
	end
end
