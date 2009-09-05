--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Faction Champions"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Trial of the Crusader"]
mod.toggleOptions = {65960, 65801, 65877, 66010, 65947, 67514, 67777, 65983, 65980, "bosskill"}
mod.consoleCmd = "Champions"

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
module.locale = L
mod.enabletrigger = function() return L["enable_trigger"] end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Blind", 65960)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Polymorph", 65801)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Wyvern", 65877)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DivineShield", 66010)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bladestorm", 65947)
	self:AddCombatListener("SPELL_SUMMON", "Felhunter", 67514)
	self:AddCombatListener("SPELL_SUMMON", "Cat", 67777)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Heroism", 65983)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bloodlust", 65980)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
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

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["defeat_trigger"]) then
		self:Sync("MultiDeath " .. self:ToString())
	end
end

