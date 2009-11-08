--------------------------------------------------------------------------------
-- Locals
--

local mod = BigWigs:NewBoss("Onyxia", "Onyxia's Lair")
if not mod then return end
mod:RegisterEnableMob(10184)
mod.toggleOptions = {"phase", {17086, "FLASHSHAKE"}, 18431, "bosskill"}

local boss = "Onyxia"

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase1_message = "Phase 1!"
	L.phase2_message = "65% - Phase 2 Incoming!"
	L.phase3_message = "40% - Phase 3 Incoming!"

	L.phase1_trigger = "How fortuitous"
	L.phase2_trigger = "from above"
	L.phase3_trigger = "It seems you'll need another lesson"

	L.deepbreath_message = "Deep Breath incoming!"

	L.fear_message = "Fear in 1.5 sec!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	boss = BigWigs:Translate(boss)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fear", 18431)
	self:Log("SPELL_CAST_START", "Breath", 17086, 18351, 18564, 18576, 18584, 18596, 18609, 18617)
	self:Yell("Phase", L["phase1_trigger"], L["phase2_trigger"], L["phase3_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 10184)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(_, spellId)
	self:Message(18431, L["fear_message"], "Attention", spellId)
end

function mod:Breath(_, spellId)
	self:Message(17086, L["deepbreath_message"], "Positive", spellId)
	self:FlashShake(17086)
end

function mod:Phase(msg)
	if msg:find(L["phase1_trigger"]) then
		self:Message("phase", L["phase1_message"]:format(boss), "Urgent")
	elseif msg:find(L["phase2_trigger"]) then
		self:Message("phase", L["phase2_message"], "Urgent")
	elseif msg:find(L["phase3_trigger"]) then
		self:Message("phase", L["phase3_message"], "Urgent")
	end
end
