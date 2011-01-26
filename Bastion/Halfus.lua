--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halfus Wyrmbreaker", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(44600)

--------------------------------------------------------------------------------
-- Locals
--

local stackWarn = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.strikes_message = "%2$dx Malevolent Strikes on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions() return {83908, 86169, "berserk", "bosskill"} end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FuriousRoar", 86169, 86170, 86171, 83710)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MalevolentStrikes", 83908, 86158, 86157, 86159)

	--no CheckBossStatus here as event does not fire, GM confirms known issue
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 44600)
end

function mod:OnEngage(diff)
	stackWarn = diff > 2 and 5 or 10 --8% in heroic, 6% in normal, announce around 50-60% reduced healing
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FuriousRoar(_, spellId, _, _, spellName)
	self:Message(86169, spellName, "Urgent", spellId)
	self:Bar(86169, spellName, 25, 86169)
end

function mod:MalevolentStrikes(player, spellId, _, _, spellName, stack)
	if stack > stackWarn then
		self:TargetMessage(83908, L["strikes_message"], player, "Urgent", spellId, "Info", stack)
	end
end

