--------------------------------------------------------------------------------
-- Module Declaration
--
local mod = BigWigs:NewBoss("Faction Champions", "Trial of the Crusader")
if not mod then return end
mod.toggleOptions = {65960, 65801, 65877, 66010, 65947, 67514, 67777, 65983, 65980, "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "enUS", true)
if L then
	L.enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy..."
	L.defeat_trigger = "A shallow and tragic victory."

	L["Shield on %s!"] = true
	L["Bladestorming!"] = true
	L["Hunter pet up!"] = true
	L["Felhunter up!"] = true
	L["Heroism on champions!"] = true
	L["Bloodlust on champions!"] = true
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Faction Champions")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:RegisterEnableMob(
		-- Alliance NPCs
		34460, 34461, 34463, 34465, 34466, 34467, 34468, 34469, 34470, 34471, 34472, 34473, 34474, 34475,
		-- Horde NPCs
		34441, 34444, 34445, 34447, 34448, 34449, 34450, 34451, 34453, 34454, 34455, 34456, 34458, 34459
	)
	self:RegisterEnableYell(L["enable_trigger"])
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Blind", 65960)
	self:Log("SPELL_AURA_APPLIED", "Polymorph", 65801)
	self:Log("SPELL_AURA_APPLIED", "Wyvern", 65877)
	self:Log("SPELL_AURA_APPLIED", "DivineShield", 66010)
	self:Log("SPELL_CAST_SUCCESS", "Bladestorm", 65947)
	self:Log("SPELL_SUMMON", "Felhunter", 67514)
	self:Log("SPELL_SUMMON", "Cat", 67777)
	self:Log("SPELL_CAST_SUCCESS", "Heroism", 65983)
	self:Log("SPELL_CAST_SUCCESS", "Bloodlust", 65980)

	self:Yell("Win", L["defeat_trigger"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Wyvern(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
end

function mod:Blind(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
end

function mod:Polymorph(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
end

function mod:DivineShield(player, spellId)
	self:IfMessage(L["Shield on %s!"]:format(player), "Urgent", spellId)
end

function mod:Bladestorm(player, spellId)
	self:IfMessage(L["Bladestorming!"], "Important", spellId)
end

function mod:Cat(player, spellId)
	self:IfMessage(L["Hunter pet up!"], "Urgent", spellId)
end

function mod:Felhunter(player, spellId)
	self:IfMessage(L["Felhunter up!"], "Urgent", spellId)
end

function mod:Heroism(player, spellId)
	self:IfMessage(L["Heroism on champions!"], "Important", spellId)
end

function mod:Bloodlust(player, spellId)
	self:IfMessage(L["Bloodlust on champions!"], "Important", spellId)
end

