----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Emalon the Storm Watcher"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Vault of Archavon"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 33993
mod.toggleOptions = {64216, 64218, "icon", "proximity", "berserk", "bosskill"}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true
mod.consoleCmd = "Emalon"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local UnitGUID = _G.UnitGUID
local GetNumRaidMembers = _G.GetNumRaidMembers
local fmt = _G.string.format
local guid = nil

------------------------------
--      English Locale      --
------------------------------

L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "enUS", true)
if L then
	L.nova_next = "~Nova Cooldown"

	L.overcharge_message = "A minion is overcharged!"
	L.overcharge_bar = "Explosion"
	L.overcharge_next = "~Overcharge Cooldown"

	L.icon = "Overcharge Icon"
	L.icon_desc = "Place a skull on the mob with Overcharge."
end

L = LibStub("AceLocale-3.0"):GetLocale("BigWigs"..boss)

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_START", "Nova", 64216, 65279)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Overcharge", 64218)
	self:AddCombatListener("SPELL_HEAL", "OverchargeIcon", 64218)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	guid = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Nova(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 5, spellId)
	self:Bar(L["nova_next"], 25, spellId)
end

function mod:Overcharge(_, spellId, _, _, spellName)
	self:IfMessage(L["overcharge_message"], "Positive", spellId)
	self:Bar(L["overcharge_bar"], 20, spellId)
	self:Bar(L["overcharge_next"], 45, spellId)
end

local function scanTarget()
	local target
	if UnitGUID("target") == guid then
		target = "target"
	elseif UnitGUID("focus") == guid then
		target = "focus"
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			local unitid = fmt("%s%d%s", "raid", i, "target")
			if UnitGUID(unitid) == guid then
				target = unitid
				break
			end
		end
	end
	if target then
		SetRaidTarget(target, 8)
		mod:CancelScheduledEvent("BWGetOverchargeTarget")
	end
end

function mod:OverchargeIcon(...)
	if not IsRaidLeader() and not IsRaidOfficer() then return end
	if not self.db.profile.icon then return end
	guid = select(9, ...)
	self:ScheduleRepeatingEvent("BWGetOverchargeTarget", scanTarget, 0.1)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		self:TriggerEvent("BigWigs_ShowProximity", self)
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self:GetOption(64218) then
			self:Bar(L["overcharge_next"], 45, 64218)
		end
		if self.db.profile.berserk then
			self:Enrage(360, true)
		end
	end
end

