----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Emalon the Storm Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(33993)
mod:Toggle(64216, "MESSAGE", "BAR")
mod:Toggle(64218, "MESSAGE", "BAR", "ICON")
mod:Toggle("proximity")
mod:Toggle("berserk")
mod:Toggle("bosskill")

------------------------------
--      Are you local?      --
------------------------------

local overchargerepeater = nil -- overcharge repeating timer

------------------------------
--      English Locale      --
------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Emalon the Storm Watcher", "enUS", true)
if L then
	L.nova_next = "~Nova Cooldown"

	L.overcharge_message = "A minion is overcharged!"
	L.overcharge_bar = "Explosion"
	L.overcharge_next = "~Overcharge Cooldown"

	L.icon = "Overcharge Icon"
	L.icon_desc = "Place a skull on the mob with Overcharge."
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Emalon the Storm Watcher")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

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

------------------------------
--      Event Handlers      --
------------------------------

function mod:Nova(_, spellId, _, _, spellName)
	self:IfMessage(64216, spellName, "Attention", spellId)
	self:Bar(64216, spellName, 5, spellId)
	self:Bar(64216, L["nova_next"], 25, spellId)
end

function mod:Overcharge(_, spellId, _, _, spellName)
	self:IfMessage(64218, L["overcharge_message"], "Positive", spellId)
	self:Bar(64218, L["overcharge_bar"], 20, spellId)
	self:Bar(64218, L["overcharge_next"], 45, spellId)
end

do
	local id = nil
	local function scanTarget()
		local unitId = mod:GetUnitIdByGUID(id)
		if not unitId then return end
		SetRaidTarget(unitId, 8)
		mod:CancelTimer(overchargerepeater)
		overchargerepeater = nil
	end

	function mod:OverchargeIcon(_, _, _, _, _, _, _, _, dGuid)
		if overchargerepeater or (not IsRaidLeader() and not IsRaidOfficer()) then return end
		if bit.band(self.db.profile[(GetSpellInfo(64218))], BigWigs.C.ICON) ~= C.ICON then return end
		id = dGuid
		overchargerepeater = self:ScheduleRepeatingTimer(scanTarget, 0.2)
	end
end

