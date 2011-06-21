if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Shannox", 800, 195)
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
		100002, 101209,
		{100129, "ICON"},
		"bosskill"
	}, {
		[100002] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ImmolationTrap", 101209)
	self:Log("SPELL_CAST_SUCCESS", "FaceRage", 99945)
	self:Log("SPELL_AURA_REMOVED", "FaceRageRemoved", 99945)
	self:Log("SPELL_CAST_SUCCESS", "HurlSpear", 99978, 100031)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53691)
end

function mod:OnEngage(diff)
	self:Bar(100002, (GetSpellInfo(100002)), 23, 100002) -- Hurl Spear
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ImmolationTrap(player, spellId, _, _, spellName, _, _, _, _, dGUID)
	local unitId = tonumber(dGUID:sub(7, 10), 16)
	if unitId == 53695 or unitId == 53694 then
		self:Message(100129, ("%s - %s"):format(spellName, player), "Attention", spellId)
	end
end

function mod:HurlSpear(_, spellId, _, _, spellName)
	self:Message(100002, spellName, "Attention", spellId)
	self:Bar(100002, spellName, 41, spellId)
end

function mod:FaceRage(player, spellId, _, _, spellName)
	self:TargetMessage(100129, spellName, player, "Important", spellId, "Alert")
	self:PrimaryIcon(100129, player)
end

function mod:FaceRageRemoved(player, spellId)
	self:Message(100129, L["safe"]:format(player), "Important", spellId)
end

