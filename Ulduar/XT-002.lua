----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["XT-002 Deconstructor"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33293
mod.toggleOptions = {63024, "gravitybombicon", 63018, "lighticon", 62776, 64193, 63849, "proximity", "berserk", "bosskill"}
mod.optionHeaders = {
	[63024] = CL.normal,
	[64193] = CL.hard,
	proximity = CL.general,
}
mod.proximityCheck = "bandage"
mod.consoleCmd = "XT"

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")
local db = nil
local phase = nil
local started = nil
local exposed1 = nil
local exposed2 = nil
local exposed3 = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	exposed_warning = "Exposed soon",
	exposed_message = "Heart exposed!",

	gravitybomb_other = "Gravity on %s!",

	gravitybombicon = "Gravity Bomb Icon",
	gravitybombicon_desc = "Place a Blue Square icon on the player effected by Gravity Bomb. (requires promoted or higher)",

	lighticon = "Searing Light Icon",
	lighticon_desc = "Place a Skull icon on the player with Searing Light. (requires promoted or higher)",

	lightbomb_other = "Light on %s!",

	tantrum_bar = "~Tantrum Cooldown",
} end )

L:RegisterTranslations("koKR", function() return {
	exposed_warning = "잠시 후 심장 노출!",
	exposed_message = "심장 노출 - 로봇들 추가!",

	gravitybomb_other = "중력 폭탄: %s!",

	gravitybombicon = "중력 폭탄 아이콘",
	gravitybombicon_desc = "중력 폭탄에 걸린 플레이어를 네모 전술로 지정합니다. (승급자 이상 권한 필요)",

	lightbomb_other = "빛의 폭탄: %s!",

	tantrum_bar = "~땅울림 대기시간",
} end )

L:RegisterTranslations("frFR", function() return {
	exposed_warning = "Cœur exposé imminent",
	exposed_message = "Cœur exposé !",

	gravitybomb_other = "Gravité : %s",

	gravitybombicon = "Bombe à gravité - Icône",
	gravitybombicon_desc = "Place une icône de raid bleue sur le dernier joueur affecté par une Bombe à gravité (nécessite d'être assistant ou mieux).",

	lightbomb_other = "Lumière : %s",

	tantrum_bar = "~Recharge Colère",
} end )

L:RegisterTranslations("deDE", function() return {
	exposed_warning = "Freigelegtes Herz bald!",
	exposed_message = "Herz freigelegt!",

	gravitybomb_other = "Gravitationsbombe: %s",

	gravitybombicon = "Gravitationsbombe: Schlachtzugs-Symbol",
	gravitybombicon_desc = "Platziert ein blaues Quadrat auf Spielern, die von Gravitationsbombe getroffen werden (benötigt Assistent oder höher).",

	lighticon = "Sengendes Licht: Schlachtzugs-Symbol",
	lighticon_desc = "Platziert einen Totenkopf auf Spielern, die von Sengendes Licht betroffen sind (benötigt Assistent oder höher).",
	
	lightbomb_other = "Lichtbombe: %s",

	tantrum_bar = "~Betäubender Koller",
} end )

L:RegisterTranslations("zhCN", function() return {
	exposed_warning = "即将 暴露心脏！",
	exposed_message = "暴露心脏！",

	gravitybomb_other = "重力炸弹：>%s<！",

	gravitybombicon = "重力炸弹标记",
	gravitybombicon_desc = "为中了重力炸弹的玩家打上蓝色方框标记。（需要权限）",

	lightbomb_other = "灼热之光：>%s<！",

	tantrum_bar = "<发脾气 冷却>",
} end )

L:RegisterTranslations("zhTW", function() return {
	exposed_warning = "即將 機心外露！",
	exposed_message = "機心外露！",

	gravitybomb_other = "重力彈：>%s<！",

	gravitybombicon = "重力彈標記",
	gravitybombicon_desc = "為中了重力彈的玩家打上藍色方框標記。（需要權限）",

	lightbomb_other = "灼熱之光：>%s<！",

	tantrum_bar = "<躁怒 冷卻>",
} end )

L:RegisterTranslations("ruRU", function() return {
	exposed_warning = "Скоро сердце станет уязвимо!",
	exposed_message = "Сердце уязвимо!",

	gravitybomb_other = "Бомба на |3-5(%s)!",

	gravitybombicon = "Иконка гравитационной бомбы",
	gravitybombicon_desc = "Помечать рейдовой иконкой (синим квадратом) игрока с бомбой (необходимо обладать промоутом).",

	lightbomb_other = "Взрыв на |3-5(%s)!",

	tantrum_bar = "~Раскаты ярости",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Exposed", 63849)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Heartbreak", 64193, 65737)
	self:AddCombatListener("SPELL_AURA_APPLIED", "GravityBomb", 63024, 64234)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightBomb", 63018, 65121)
	self:AddCombatListener("SPELL_AURA_REMOVED", "GravityRemoved", 63024, 64234)
	self:AddCombatListener("SPELL_AURA_REMOVED", "LightRemoved", 63018, 65121)
	self:AddCombatListener("SPELL_CAST_START", "Tantrum", 62776)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Exposed(_, spellId, _, _, spellName)
	self:IfMessage(L["exposed_message"], "Attention", spellId)
	self:Bar(spellName, 30, spellId)
end

function mod:Heartbreak(_, spellId, _, _, spellName)
	phase = 2
	self:IfMessage(spellName, "Important", spellId)
end

function mod:Tantrum(_, spellId, _, _, spellName)
	if phase == 2 then
		self:IfMessage(spellName, "Attention", spellId)
		self:Bar(L["tantrum_bar"], 65, spellId)
	end
end

function mod:GravityBomb(player, spellId, _, _, spellName)
	if player == pName then
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:Bar(L["gravitybomb_other"]:format(player), 9, spellId)
	self:SecondaryIcon(player, "gravitybombicon")
end

function mod:LightBomb(player, spellId, _, _, spellName)
	if player == pName then
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:Bar(L["lightbomb_other"]:format(player), 9, spellId)
	self:PrimaryIcon(player, "lighticon")
end

function mod:GravityRemoved(player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
	self:SecondaryIcon(false)
end

function mod:BombRemoved(player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
	self:PrimaryIcon(false)
end

function mod:UNIT_HEALTH(msg)
	if phase == 1 and UnitName(msg) == boss and self:GetOption(63849) then
		local health = UnitHealth(msg)
		if not exposed1 and health > 86 and health <= 88 then
			exposed1 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		elseif not exposed2 and health > 56 and health <= 58 then
			exposed2 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		elseif not exposed3 and health > 26 and health <= 28 then
			exposed3 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		exposed1 = nil
		exposed2 = nil
		exposed3 = nil
		if db.berserk then
			self:Enrage(600, true)
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

