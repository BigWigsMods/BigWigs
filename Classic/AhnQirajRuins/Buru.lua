
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Buru the Gorger", 509)
if not mod then return end
mod:RegisterEnableMob(15370)
mod:SetAllowWin(true)
mod:SetEncounterID(721)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Buru the Gorger"

	L.fixate = "Fixate"
	L.fixate_desc = "Fixate on a target, ignoring threat from other attackers."
	L.fixate_icon = "ability_hunter_snipershot"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"fixate", "ICON"},
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_EMOTE(_, _, sender, _, _, player)
	if sender == mod.displayName then
		self:TargetMessage("fixate", "yellow", player, L.fixate, L.fixate_icon)
		if UnitIsUnit("player", player) then
			self:PlaySound("fixate", "alarm")
		end
		self:PrimaryIcon("fixate", player)
	end
end
