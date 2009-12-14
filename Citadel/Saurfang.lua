if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Deathbringer Saurfang", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37813)
mod.toggleOptions = {"adds", "bosskill"}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Locale
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds_message = "Adds summoned"
	L.adds = "Adds"
	L.adds_desc = "Warns for spawning adds"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Adds", 72172, 72173, 72356, 72357, 72358)
	--self:Log("SPELL_SUMMON", "Adds", 72173)
	self:Death("Win", 37813)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adds()
	self:Message("adds", L["adds_message"], "Attention")
end