if GetBuildInfo() ~= "4.0.3" then return end -- lets not brake live stuff
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Chimaeron", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(43296, 44418, 44202) -- Chimaeron, Bile-O-Tron 800, Finkle Einhorn
mod.toggleOptions = {"warmup", 88826, 82881, {88853, "FLASHSHAKE"}, 82890, "bosskill"}
mod.optionHeaders = {
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."
	L.engage = "Engage"
	L.next_system_failure = "Next System Failure"
	L.break_message = "%2$dx Break on %1$s"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	BigWigs:Print("This is a alpha module, timers ARE inaccurate. Please provide us with Transcriptor logs! You can contact us at #bigwigs@freenode.net or with the wowace ticket tracker.")

	self:Log("SPELL_AURA_APPLIED", "SystemFailureStart", 88853)
	self:Log("SPELL_AURA_REMOVED", "SystemFailureEnd", 88853)
	self:Log("SPELL_CAST_SUCCESS", "Mortality", 82890)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Break", 82881)
	self:Log("SPELL_AURA_APPLIED", "DoubleAttack", 88826)
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Warmup")

	self:Death("Win", 43296)
end

function mod:Warmup(_, msg)
	if msg == L["bileotron_engage"] then
		self:Bar("warmup", L["warmup"], 30, "achievement_boss_chimaeron")
	end
end

function mod:OnEngage(diff)
	self:Bar(88853, L["next_system_failure"], 85, 88853)
	self:SendMessage("BigWigs_StopBar", self, L["warmup"])	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SystemFailureStart(_, spellId, _, _, spellName)
	self:Bar(88853, spellName, 30, spellId)
	self:Message(88853, spellName, "Urgent", spellId, "Alarm")
end

function mod:SystemFailureEnd(_,spellId)
	self:Bar(88853, L["next_system_failure"], 65, spellId)
end

function mod:Mortality(_, spellId, _, _, spellName)
	self:Message(82890, spellName, "Urgent", spellId, "Info")
	self:SendMessage("BigWigs_StopBar", self, L["next_system_failure"])	
end

function mod:Break(player, spellId, _, _, _, stack)
	self:TargetMessage(82881, L["break_message"], player, "Important", spellId, nil, stack)
end

function mod:DoubleAttack(_, spellId, _, _, spellName)
	elf:Message(88826, spellName, "Attention", spellId)
end
