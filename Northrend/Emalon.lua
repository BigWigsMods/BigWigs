--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Emalon the Storm Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(33993)
mod.toggleOptions = {64216, {64218, "ICON"}, "proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.nova_next = "~Nova Cooldown"

	L.overcharge_message = "A minion is overcharged!"
	L.overcharge_bar = "Explosion"
	L.overcharge_next = "~Overcharge Cooldown"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Nova", 64216, 65279)
	self:Log("SPELL_CAST_SUCCESS", "Overcharge", 64218)
	self:Log("SPELL_HEAL", "OverchargeIcon", 64218)
	self:Death("Win", 33993)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:OpenProximity(5)
	self:Bar(64218, L["overcharge_next"], 45, 64218)
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Nova(_, spellId, _, _, spellName)
	self:Message(64216, spellName, "Attention", spellId)
	self:Bar(64216, spellName, 5, spellId)
	self:Bar(64216, L["nova_next"], 25, spellId)
end

function mod:Overcharge(_, spellId, _, _, spellName)
	self:Message(64218, L["overcharge_message"], "Positive", spellId)
	self:Bar(64218, L["overcharge_bar"], 20, spellId)
	self:Bar(64218, L["overcharge_next"], 45, spellId)
end

do
	local overchargerepeater = nil
	local function scanTarget(dGuid)
		local unitId = mod:GetUnitIdByGUID(dGuid)
		if not unitId then return end
		SetRaidTarget(unitId, 8)
		mod:CancelTimer(overchargerepeater)
		overchargerepeater = nil
	end

	function mod:OverchargeIcon(...)
		if overchargerepeater or (not IsRaidLeader() and not IsRaidOfficer()) then return end
		if bit.band(self.db.profile[(GetSpellInfo(64218))], BigWigs.C.ICON) ~= BigWigs.C.ICON then return end
		local dGuid = select(10, ...)
		overchargerepeater = self:ScheduleRepeatingTimer(scanTarget, 0.2, dGuid)
	end
end

