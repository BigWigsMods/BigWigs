if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Shannox", 800)
if not mod then return end
mod:RegisterEnableMob(53691)

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.safe = "%s safe"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		100002,
		{100129, "ICON"},
		"bosskill"
	}, {
		bosskill = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "FaceRage", 99945)
	self:Log("SPELL_AURA_REMOVED", "FaceRageRemoved", 99945)
	self:Log("SPELL_CAST_SUCCESS", "HurlSpear", 100031)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53691)
end

function mod:OnEngage(diff)
	self:Bar(100002, (GetSpellInfo(100002)), 23, 100002) -- Hurl Spear
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HurlSpear(_, spellId, _, _, spellName)
	self:Message(100002, spellName, "Attention", 100002)
	self:Bar(100002, spellName, 41, 100002)
end

function mod:FaceRage(player, spellId, _, _, spellName)
	self:TargetMessage(100129, spellName, player, "Important", 100129, "Alert")
	self:PrimaryIcon(100129, player)
end

function mod:FaceRageRemoved(player, spellId)
	self:Message(100129, L["safe"]:format(player), "Important", 100129)
end

