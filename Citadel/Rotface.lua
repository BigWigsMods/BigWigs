if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Rotface", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36627)
mod.toggleOptions = {{71224, "ICON", "WHISPER"}, 71588, 69508, "bosskill"}

local boss = "Rotface"

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Rotface", "enUS", true)
if L then
	L.infection = "Mutated Infection"
	L.infection_desc = "Warn for Mutated Infection"
	L.infection_message = "Mutated Infection on %s!"

	L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"

end
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Rotface")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	boss = BigWigs:Translate(boss)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Infection", 69674, 71224)
	self:Log("SPELL_CAST_START", "SlimeSpray", 69508) --Needed?

	-- Common
	self:Yell("Flood", L["flood_trigger1"],  L["flood_trigger2"]) 

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 36627)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Infection(player, spellId)
    self:TargetMessage(71224, L["infection_message"], player, "Personal", spellId)
    self:Whisper(71224, player, L["infection"])
    self:Bar(71224, L["infection"]:format(player), 12, spellId)
    self:PrimaryIcon(71224, player, "icon")
end


function mod:Flood()
	self:Bar(71588, (GetSpellInfo(71588)), 20, 71588)
	self:Message(71588, L["flood_warning"], "Attention")
end

function mod:SlimeSpray(_, _, _, _, _, _, _, spellName)
	self:Message(69508, spellName, "Attention", 69508)
end
