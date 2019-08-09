--------------------------------------------------------------------------------
-- Locals
--

local mod = BigWigs:NewBoss("Onyxia", 249, 1651)
if not mod then return end
mod:RegisterEnableMob(10184)
mod.toggleOptions = {"phase", {17086, "FLASH"}, 18431, 18435}
mod.engageId = 1084

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
	self:Log("SPELL_CAST_START", "DeepBreath", 17086, 18351, 18564, 18576, 18584, 18596, 18609, 18617)
	self:Log("SPELL_CAST_START", "FlameBreath", 18435)
	self:Yell("Phase2", L["phase2_trigger"])
	self:Yell("Phase3", L["phase3_trigger"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(args)
	self:Message(args.spellId, "yellow", nil, L["fear_message"])
end

function mod:DeepBreath()
	self:Message(17086, "orange", "Alarm", L["deepbreath_message"])
	self:Bar(17086, 8)
	self:Flash(17086)
end

function mod:FlameBreath(args)
	self:Message(args.spellId, "red", "Alert")
end

function mod:Phase2()
	self:Message("phase", "green", nil, L["phase2_message"], false)
end

function mod:Phase3()
	self:Message("phase", "green", nil, L["phase3_message"], false)
end

