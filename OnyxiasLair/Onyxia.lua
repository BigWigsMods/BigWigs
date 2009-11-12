--------------------------------------------------------------------------------
-- Locals
--

local mod = BigWigs:NewBoss("Onyxia", "Onyxia's Lair")
if not mod then return end
mod:RegisterEnableMob(10184)
mod.toggleOptions = {"phase", {17086, "FLASHSHAKE"}, 18431, "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_message = "Phase 2 incoming!"
	L.phase3_message = "Phase 3 incoming!"

	L.phase1_trigger = "How fortuitous"
	L.phase2_trigger = "from above"
	L.phase3_trigger = "It seems you'll need another lesson"

	L.deepbreath_message = "Deep Breath incoming!"
	L.fear_message = "Fear incoming!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fear", 18431)
	self:Log("SPELL_CAST_START", "Breath", 17086, 18351, 18564, 18576, 18584, 18596, 18609, 18617)
	self:Yell("Phase2", L["phase2_trigger"])
	self:Yell("Phase3", L["phase3_trigger"])
	self:Death("Win", 10184)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(_, spellId)
	self:Message(18431, L["fear_message"], "Attention", spellId)
end

function mod:Breath(_, spellId)
	self:Message(17086, L["deepbreath_message"], "Important", spellId, "Alarm")
	self:FlashShake(17086)
end

function mod:Phase2()
	self:Message("phase", L["phase2_message"], "Positive")
end

function mod:Phase3()
	self:Message("phase", L["phase3_message"], "Positive")
end

