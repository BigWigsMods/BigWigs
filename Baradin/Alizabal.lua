--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Alizabal", 752, 339)
if not mod then return end
mod:RegisterEnableMob(55869)

local firstAbility = nil
local skewer = GetSpellInfo(104936)
local hate = GetSpellInfo(105067)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.first_ability = "Skewer or Hate"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {105067, 104936, 104995, "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Hate", 105067)
	self:Log("SPELL_AURA_APPLIED", "Skewer", 104936)
	self:Log("SPELL_AURA_APPLIED", "BladeDance", 105738)
	self:Log("SPELL_AURA_REMOVED", "BladeDanceOver", 105738)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55869)
end

function mod:OnEngage()
	self:Bar(104936, L["first_ability"], 7, 104936)
	self:Bar(104995, GetSpellInfo(104995), 35, 104995)
	firstAbility = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Hate(_, spellId, _, _, spellName)
	if not firstAbility then
		firstAbility = true
		self:Bar(104936, skewer, 8, 104936)
	end
	self:Bar(105067, spellName, 20, spellId)
	self:Message(105067, spellName, "Important", spellId)
end

function mod:Skewer(_, spellId, _, _, spellName)
	if not firstAbility then
		firstAbility = true
		self:Bar(105067, hate, 8, 105067)
	end
	self:Bar(104936, spellName, 20, spellId)
	self:Message(104936, spellName, "Attention", spellId)
end

function mod:BladeDance(_, spellId, _, _, spellName, ...)
	local dGUID = select(5, ...)
	if self:GetCID(dGUID) ~= 55869 then return end
	firstAbility = nil
	-- XXX Fix this up instead of just cancelling the bars
	self:SendMessage("BigWigs_StopBar", self, skewer)
	self:SendMessage("BigWigs_StopBar", self, hate)
	self:Bar(104995, spellName, 60, spellId)
	self:Message(104995, spellName, "Urgent", spellId, "Info")
end

function mod:BladeDanceOver(...)
	local dGUID = select(10, ...)
	if self:GetCID(dGUID) ~= 55869 then return end
	self:Bar(104936, L["first_ability"], 8, 104936)
end

