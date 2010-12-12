--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Magmaw", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41570)
mod.toggleOptions = {"slump", 78006, "inferno", "bosskill"}
mod.optionHeaders = {
	slump = "normal",
	inferno = "heroic",
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Summons Blazing Bone Construct"

	L.slump = "Slump"
	L.slump_desc = "Slumps forward exposing itself"

	L.slump_trigger = "%s slumps forward, exposing his pincers!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_SUMMON", "BlazingInferno", 92191)

	--normal
	self:Log("SPELL_AURA_APPLIED", "PillarOfFlame", 78006)
	--self:Emote("Slump", L["slump_trigger"])

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 41570)
end


function mod:OnEngage(diff)
	if diff > 2 then
		self:Bar("inferno", (GetSpellInfo(92191)), 20, 92191)
	end
	self:Bar("slump", L["slump"], 100, 94678)
	self:Bar(78006, (GetSpellInfo(78006)), 30, 78006)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BlazingInferno(_, spellId, _, _, spellName)
	self:Message("inferno", spellName, "Urgent", spellId, "Info")
	self:Bar("inferno", spellName, 35, spellId)
end

function mod:PillarOfFlame(_, spellId, _, _, spellName)
	self:Message(78006, spellName, "Urgent", spellId, "Info")
	self:Bar(78006, spellName, 30, spellId)
end

