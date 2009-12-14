--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Deathbringer Saurfang", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37813)
mod.toggleOptions = {"adds", 72408, 72385, 72378, {72293, "WHISPER", "ICON", "FLASHSHAKE"}, 72737, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local bbTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds = "Blood Beasts"
	L.adds_desc = "Shows a timer and messages for when Blood Beasts spawn."
	L.adds_warning = "Blood Beasts in 5 sec!"
	L.adds_message = "Blood Beasts!"
	L.adds_bar = "Next Blood Beasts"
	
	L.rune_bar = "Next Rune of Blood"
	
	L.nova_bar = "Next Blood Nova"
	
	L.mark = "Mark"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Adds", 72172, 72173, 72356, 72357, 72358)
	self:Log("SPELL_AURA_APPLIED", "RuneofBlood", 72408, 72409, 72410, 72447, 72448, 72449)
	self:Log("SPELL_AURA_APPLIED", "BoilingBlood", 72385, 72441, 72442, 72443)
	self:Log("SPELL_CAST_START", "BloodNova", 72378, 72379, 72380, 72438, 72439, 72440, 73058)
	self:Log("SPELL_AURA_APPLIED", "Mark", 72293)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 72737)
	self:Death("Win", 37813)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(480, true)
	self:DelayedMessage("adds", 35, L["adds_warning"], "Attention")
	self:Bar("adds", L["adds_bar"], 40, 72172)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adds(_, spellId)
	self:Message("adds", L["adds_message"], "Attention", spellId, "Alarm")
	self:DelayedMessage("adds", 35, L["adds_warning"], "Attention")
	self:Bar("adds", L["adds_bar"], 40, spellId)
end

function mod:RuneofBlood(player, spellId, _, _, spellName)
	self:TargetMessage(72408, spellName, player, "Important", spellId, "Info")
	self:Bar(72408, L["rune_bar"], 20, spellId)
end

do
	local handle = nil
	local function boilingWarn(spellId, spellName)
		mod:TargetMessage(72385, spellName, bbTargets, "Urgent", spellId, "Alert")
		handle = nil
	end
	function mod:BoilingBlood(player, spellId, _, _, spellName)
		bbTargets[#bbTargets + 1] = player
		if handle then self:CancelTimer(handle) end
		handle = self:ScheduleTimer(boilingWarn, 0.3, spellId)
	end
end

function mod:BloodNova(_, spellId, _, _, spellName)
	self:Message(72378, spellName, "Attention", spellId, "Info")
	self:Bar(72378, L["nova_bar"], 20, spellId)
end

function mod:Mark(player, spellId, _, _, spellName)
	self:TargetMessage(72293, L["mark"], player, "Urgent", spellId, "Alert")
	self:Whisper(72293, player, spellName)
	self:PrimaryIcon(72293, player)
	if player == pName then self:FlashShake(72293) end
end

function mod:Frenzy(_, spellId, _, _, spellName)
	self:Message(72737, spellName, "Attention", spellId, "Long")
end

