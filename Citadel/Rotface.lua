if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Rotface", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36627)
mod.toggleOptions = {{"infection", "ICON"}, "flood", "bosskill"}

local boss = "Rotface"

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Rotface", "enUS", true)
if L then
	L.infection = "Mutated Infection"
	L.infection_desc = "Warn for Mutated Infection"
	L.infection_message = "Mutated Infection on %s!"

	L.flood = "Ooze Flood"
	L.flood_desc = "Warn when Putricide floods a new area"
	L.flood_trigger_generic = "news, everyone"
	--trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	--trigger2 = "Great news, everyone! The slime is flowing again!"
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
	self:Log("SPELL_CAST_START", "Slime Spray", 69508) --Needed?

	-- Common
	self:Yell("Flood", L["flood_trigger_generic"])

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 36627)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Infection(player, spellId)
	self:TargetMessage("infection", L["infection_message"], player, "Personal", spellId)
	self:Whisper("infection", player, L["infection"])
	self:Bar("infection", L["infection"]:format(player), 12, spellId)
	self:PrimaryIcon(71224, player, "icon")
end

function mod:Flood()
		self:Bar(71588, L["flood"], 20, 71588)
		self:Message("flood", L["flood_warning"], "Attention")
end
