if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valithria Dreamwalker", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36789)
mod.toggleOptions = {71730, 71733, 71741, "nightmareportal", "bosskill"}
--68168 lay waste (buff)
-- 71733 Acid Burst
--  71741 Manavoid
local boss = "Valithria Dreamwalker"

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Valithria Dreamwalker", "enUS", true)
if L then
 L.nightmareportal = "Nightmareportal"
 L.nightmareportal_desc = "Warns when Valithria opens a Portal"
 L.nightmareportal_message = "Nightmare Portal summoned" 
 L.nightmareportal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
 
end
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Valithria Dreamwalker")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	boss = BigWigs:Translate(boss)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ManaVoid", 71741)
	self:Log("SPELL_CAST_SUCCESS", "LayWaste", 71730)
	self:Log("SPELL_CAST_START", "AcidBurst", 71733)
	
	self:Yell("Nightmareportal", L["nightmareportal_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 36789)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LayWaste( _, _, _, _, _, _, _, spellName)
	self:Message(71730, spellName, "Attention")
	self:Bar(71730, spellName, 12, 71730)
end

function mod:Nightmareportal()
	self:Message(71977, L["nightmareportal_message"], "Attention")
end

function mod:AcidBurst( _, _, _, _, _, _, _, spellName)
	self:Message(71733, spellName, "Attention")
	self:Bar(71733, spellName, 20, 71733)
end
