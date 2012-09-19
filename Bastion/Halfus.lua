--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Halfus Wyrmbreaker", 758, 156)
if not mod then return end
mod:RegisterEnableMob(44600)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.strikes_message = "%2$dx Strikes on %1$s"

	L.breath_message = "Breath incoming!"
	L.breath_bar = "~Breath"

	L.engage_yell = "Cho'gall will have your heads"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions() return {83908, 83603, 83707, 83710, "berserk", "bosskill"} end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FuriousRoar", 83710)
	self:Log("SPELL_AURA_APPLIED", "Paralysis", 84030) -- used with Slate Dragon active
	self:Log("SPELL_AURA_APPLIED_DOSE", "MalevolentStrikes", 83908) -- used with Slate Dragon ready
	self:Log("SPELL_CAST_START", "Breath", 83707) -- used by Proto-Behemoth with whelps ready

	--No CheckBossStatus() here as event does not fire, GM confirms "known" issue.
	--It's more likely to be because there isn't enough frames for all bosses on heroic.
	self:Yell("Engage", L["engage_yell"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 44600)
end

function mod:OnEngage()
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FuriousRoar(_, spellId, _, _, spellName)
	self:Message(83710, spellName, "Important", spellId)
	self:Bar(83710, spellName, 25, spellId)
end

-- Slate Dragon: Stone Touch (83603), 35 sec internal cd, resulting in Paralysis, 12 sec stun
-- Next Stone Touch after 23 sec, hence delaying Furious Roar if less then 12 sec left
function mod:Paralysis(_, spellId, _, _, spellName)
	self:Message(83603, spellName, "Attention", spellId)
	self:Bar(83603, CL["cast"]:format(spellName), 12, spellId)
	self:Bar(83603, spellName, 35, spellId)
end

function mod:MalevolentStrikes(player, spellId, _, _, spellName, stack)
	local stackWarn = self:Heroic() and 5 or 10 -- 8% in heroic, 6% in normal, announce around 50-60% reduced healing
	if stack > stackWarn then
		self:TargetMessage(83908, L["strikes_message"], player, "Urgent", spellId, "Info", stack)
	end
end

function mod:Breath(_, spellId)
	self:Message(83707, L["breath_message"], "Attention", spellId)
	self:Bar(83707, L["breath_bar"], 20, spellId)
end

