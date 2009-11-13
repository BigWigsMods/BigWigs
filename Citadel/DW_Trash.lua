if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Lady Deathwhisper's Trash", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36805, 36807, 36808, 36811, 36829)
mod.toggleOptions = {{69483, "WHISPER", "ICON", "FLASHSHAKE"}, "proximity"}


--------------------------------------------------------------------------------
-- Locals
--

local pName = UnitName("player")

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.reckoning = "Dark Reckoning"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Reckoning", 69483)

	self:Death("Deaths", 36829)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:CloseProximity()

end

--------------------------------------------------------------------------------
-- Event handlers
--
function mod:Reckoning(player, spellId)
	self:TargetMessage(69483, L["reckoning"], player, "Personal", spellId, "Alert")
	self:Bar(69483, L["reckoning"], 8, spellId)
	if player == pName then self:FlashShake(69483)
	self:OpenProximity(15)	end
	self:Whisper(69483, player, L["reckoning"])
	self:PrimaryIcon(69483, player, "icon")
end

function mod:Deaths()
	deaths = deaths + 1
	if deaths == 2 then 
		self:Disable()
	end
end
