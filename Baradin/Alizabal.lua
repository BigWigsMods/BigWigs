--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Alizabal", 752, 339)
if not mod then return end
mod:RegisterEnableMob(55869)

local firstAbility = nil
local danceCount = 0
local skewer = GetSpellInfo(104936)
local hate = GetSpellInfo(105067)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.first_ability = "Skewer or Hate"
	L.dance_message = "Blade Dance %d of 3"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {105067, 104936, 105784, "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Hate", 105067)
	self:Log("SPELL_AURA_APPLIED", "Skewer", 104936)
	self:Log("SPELL_AURA_APPLIED", "BladeDance", 105784)
	self:Log("SPELL_AURA_REMOVED", "BladeDanceOver", 105784)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55869)
end

function mod:OnEngage()
	self:Bar(104936, L["first_ability"], 7, 104936)
	self:Bar(105784, GetSpellInfo(105784), 35, 105784) -- Blade Dance
	firstAbility = nil
	danceCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Hate(player, spellId, _, _, spellName)
	if not firstAbility then
		firstAbility = true
		self:Bar(104936, skewer, 8, 104936)
	end
	self:Bar(105067, spellName, 20, spellId)
	self:TargetMessage(105067, spellName, player, "Important", spellId)
end

function mod:Skewer(player, spellId, _, _, spellName)
	if not firstAbility then
		firstAbility = true
		self:Bar(105067, hate, 8, 105067)
	end
	self:Bar(104936, spellName, 20, spellId)
	self:TargetMessage(104936, spellName, player, "Attention", spellId)
end

function mod:BladeDance(_, spellId, _, _, spellName)
	danceCount = danceCount + 1
	self:Message(105784, L["dance_message"]:format(danceCount), "Urgent", spellId, "Info")
	self:Bar(105784, CL["cast"]:format(spellName), 4, spellId)
	if danceCount == 1 then
		firstAbility = nil
		-- XXX Fix this up instead of just cancelling the bars
		self:SendMessage("BigWigs_StopBar", self, skewer)
		self:SendMessage("BigWigs_StopBar", self, hate)
		self:Bar(105784, spellName, 60, spellId)
	end
end

function mod:BladeDanceOver()
	if danceCount == 3 then
		self:Bar(104936, L["first_ability"], 8, 104936)
		danceCount = 0
	end
end

