--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Patchwerk", "Naxxramas")
if not mod then return end
mod:RegisterEnableMob(16028)
mod.toggleOptions = {28131, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enragewarn = "5% - Frenzied!"
	L.starttrigger1 = "Patchwerk want to play!"
	L.starttrigger2 = "Kel'thuzad make Patchwerk his avatar of war!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 28131)
	self:Death("Win", 16028)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Frenzy(_, spellId)
	self:Message(28131, L["enragewarn"], "Attention", spellId, "Alarm")
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] then
		self:Berserk(360)
	end
end
