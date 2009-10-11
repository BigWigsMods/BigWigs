----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Onyxia", "Onyxia's Lair")
if not mod then return end
mod:RegisterEnableMob(10184)
mod.toggleOptions = {"phase1", "phase2", "phase3", {"deepbreath", "FLASHSHAKE"}, "fear", "bosskill"}

local boss = "Onyxia"

----------------------------
--      Localization      --
----------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Onyxia", "enUS", true)
if L then
	L.phase1 = "Phase 1 alert"
	L.phase1_desc = "Warn for Phase 1"

	L.phase2 = "Phase 2 alert"
	L.phase2_desc = "Warn for Phase 2"

	L.phase3 = "Phase 3 alert"
	L.phase3_desc = "Warn for Phase 3"

	L.deepbreath = "Deep Breath alert"
	L.deepbreath_desc = "Warn when Onyxia begins to cast Deep Breath"
	L.deepbreath_message = "Deep Breath incoming!"

	L.fear = "Fear"
	L.fear_desc = "Warn for Bellowing Roar in phase 3"
	L.fear_message = "Fear in 1.5 sec!"
	
	L.phase1_trigger = "How fortuitous"
	L.phase2_trigger = "from above"
	L.phase3_trigger = "It seems you'll need another lesson"

	L.phase1_message = "%s Engaged - Phase 1!"
	L.phase2_message = "65% - Phase 2 Incoming!"
	L.phase3_message = "40% - Phase 3 Incoming!"
end
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Onyxia")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------
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

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fear()
	self:Message("fear", L["fear_message"], "Attention", 18431)
end

function mod:Breath(_, spellId)
	self:Message("deepbreath", L["deepbreath_message"], "Positive", spellId)
	self:FlashShake("deepbreath")
end

function mod:Phase(msg)
	if msg:find(L["phase1_trigger"]) then
		self:Message("phase1", L["phase1_message"]:format(boss), "Urgent")
	elseif msg:find(L["phase2_trigger"]) then
		self:Message("phase2", L["phase2_message"], "Urgent")
	elseif msg:find(L["phase3_trigger"]) then
		self:Message("phase3", L["phase3_message"], "Urgent")
	end
end
