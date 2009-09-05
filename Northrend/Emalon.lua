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

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	nova_next = "~Nova Cooldown",

	overcharge_message = "A minion is overcharged!",
	overcharge_bar = "Explosion",
	overcharge_next = "~Overcharge Cooldown",

	icon = "Overcharge Icon",
	icon_desc = "Place a skull on the mob with Overcharge.",
} end )

L:RegisterTranslations("koKR", function() return {
	nova_next = "~번개 대기시간",

	overcharge_message = "하수인 과충전!",
	overcharge_bar = "폭발",
	overcharge_next = "~과충전 대기시간",

	icon = "과충전 아이콘",
	icon_desc = "과충전에 걸린 하수인에게 해골 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	nova_next = "~Recharge Nova",

	overcharge_message = "Un séide est surchargé !",
	overcharge_bar = "Explosion",
	overcharge_next = "~Prochaine Surcharge",

	icon = "Surcharger - Icône",
	icon_desc = "Place un crâne sur le séide surchargé.",
} end )

L:RegisterTranslations("deDE", function() return {
	nova_next = "~Blitzschlagnova",

	overcharge_message = "Sturmdiener überladen!",
	overcharge_bar = "Explosion",
	overcharge_next = "~Überladen",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol (Totenkopf) auf dem Sturmdiener, der von Überladen betroffen ist (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("ruRU", function() return {
	nova_next = "~Перезарядка Вспышки молнии",

	overcharge_message = "Служитель бури перегружен!",
	overcharge_bar = "Взрыв Служителя бури",
	overcharge_next = "~Следующая Перегрузка",

	icon = "Иконка Перегрузки",
	icon_desc = "Отмечать черепом Служителя бури с эффектом Перегрузки.",
} end )

L:RegisterTranslations("zhCN", function() return {
	nova_next = "<闪电新星 冷却>",

	overcharge_message = "minion - 超载！",
	overcharge_bar = "<爆炸>",
	overcharge_next = "<下一超载>",

	icon = "超载标记",
	icon_desc = "为中了超载的怪物打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	nova_next = "<閃電新星 冷卻>",

	overcharge_message = " 暴雨爪牙 - 超載！",
	overcharge_bar = "<爆炸>",
	overcharge_next = "<下一超載>",

	icon = "超載標記",
	icon_desc = "為中了超載的怪物打上團隊標記。（需要權限）",
} end )

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

