----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Grobbulus"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15931
mod.toggleOptions = {28169, "icon", 28240, "berserk", "bosskill"}
mod.consoleCmd = "Grobbulus"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	bomb_message = "Injection",
	bomb_message_other = "%s is Injected!",

	icon = "Place Icon",
	icon_desc = "Place a raid icon on an Injected person. (Requires promoted or higher)",
} end )

L:RegisterTranslations("ruRU", function() return {
	bomb_message = "Injection",
	bomb_message_other = "|3-2(%s) сделали укол! Бегите от него!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, которому был сделан укол (необходимо быть лидером группы или рейда).",
} end )

L:RegisterTranslations("deDE", function() return {
	bomb_message = "Injection",
	bomb_message_other = "%s ist verseucht!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Mutagene Injektion gewirkt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("koKR", function() return {
	bomb_message = "Injection",
	bomb_message_other = "돌연변이 유발: %s!",

	icon = "전술 표시",
	icon_desc = "돌연변이 유발 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("zhCN", function() return {
	bomb_message = "Injection",
	bomb_message_other = "变异注射：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了变异注射的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	bomb_message = "Injection",
	bomb_message_other = "突變注射：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了突變注射的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("frFR", function() return {
	bomb_message = "Injection",
	bomb_message_other = "Injection mutante : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Injection mutante (nécessite d'être assistant ou mieux).",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Inject", 28169)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Cloud", 28240)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Inject(player, spellId)
	self:TargetMessage(L["bomb_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["bomb_message"])
	self:Bar(L["bomb_message_other"]:format(player), 10, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:Cloud(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:Enrage(540, true)
		end
	end
end

