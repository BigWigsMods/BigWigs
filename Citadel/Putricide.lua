----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Professor", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36678)
mod.toggleOptions = {{70447, "ICON", "WHISPER"}, {72455, "ICON", "WHISPER"}, "bosskill"}

local boss = "Professor"

----------------------------
--      Localization      --
----------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Professor", "enUS", true)
if L then

    L.blight_message = "Blight on"
    L.violation_message = "Violation on"

end
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Professor")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------
function mod:OnRegister()
    boss = BigWigs:Translate(boss)
end

function mod:OnBossEnable()
    self:Log("SPELL_AURA_APPLIED", "Blight", 72455)
    self:Log("SPELL_AURA_APPLIED", "Violation", 70447)

    
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
    self:Death("Win", 36678)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Blight(player, spellId)
    self:TargetMessage(72455, L["blight_message"], player, "Personal", spellId)
    self:Whisper(72455, player, L["blight_message"])
    self:PrimaryIcon(72455, player, "icon")
end

function mod:Violation(player, spellId)
    self:TargetMessage(70447, L["violation_message"], player, "Personal", spellId)
    self:Whisper(70447, player, L["violation_message"])
    self:PrimaryIcon(70447, player, "icon")
end
