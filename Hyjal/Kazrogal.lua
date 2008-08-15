------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Kaz'rogal"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local db = nil
local started = nil
local count = 1

local bandages = {
	[21991] = true, -- Heavy Netherweave Bandage
	[21990] = true, -- Netherweave Bandage
	[14530] = true, -- Heavy Runecloth Bandage
	[14529] = true, -- Runecloth Bandage
	[8545] = true, -- Heavy Mageweave Bandage
	[8544] = true, -- Mageweave Bandage
	[6451] = true, -- Heavy Silk Bandage
	[6450] = true, -- Silk Bandage
	[3531] = true, -- Heavy Wool Bandage
	[3530] = true, -- Wool Bandage
	[2581] = true, -- Heavy Linen Bandage
	[1251] = true, -- Linen Bandage
}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazrogal",

	range = "Range Check",
	range_desc = "Show the proximity box when you are low on mana and have the Mark of Kaz'rogal.",

	mark = "Mark of Kaz'rogal",
	mark_desc = "Show a Mark of Kaz'rogal timer bar.",
	mark_bar = "Next Mark (%d)",
	mark_warn = "Mark in 5 sec!",
} end )

L:RegisterTranslations("deDE", function() return {
	range = "Reichweite",
	range_desc = "Aktiviert die Anzeige für nahe Spieler wenn du wenig Mana und das Mal von Kaz'rogal hast.",

	mark = "Mal von Kaz'rogal",
	mark_desc = "Zeigt einen Timer für das Mal von Kaz'rogal.",
	mark_bar = "Nächstes Mal von Kaz'rogal (%d)",
	mark_warn = "Mal von Kaz'rogal in 5sek!",
} end )

L:RegisterTranslations("frFR", function() return {
	range = "Vérification de portée",
	range_desc = "Affiche la fenêtre de proximité quand votre mana est faible et que vous avez la Marque de Kaz'rogal.",

	mark = "Marque de Kaz'rogal",
	mark_desc = "Affiche une barre temporelle pour les Marques de Kaz'rogal.",
	mark_bar = "Prochaine marque (%d)",
	mark_warn = "Marque dans 5 sec. !",
} end )

L:RegisterTranslations("koKR", function() return {
	range = "거리 확인",
	range_desc = "카즈로갈의 징표가 걸렸을 때 마나가 낮은 상태가 되면 접근 경고창을 띄웁니다.",

	mark = "카즈로갈의 징표",
	mark_desc = "카즈로갈의 징표 타이머 바를 표시합니다.",
	mark_bar = "다음 징표 (%d)",
	mark_warn = "5초 이내 징표!",
} end )

L:RegisterTranslations("zhTW", function() return {
	range = "距離檢查",
	range_desc = "當你低量法力且受到卡茲洛加的印記時顯示距離框",

	mark = "卡茲洛加印記",
	mark_desc = "顯示卡茲洛加印記計時條",
	mark_bar = "<下一次印記: %d>",
	mark_warn = "約 5 秒後，施放印記!",
} end )

L:RegisterTranslations("zhCN", function() return {
	range = "距离检查",
	range_desc = "当你低法力以及中了卡兹洛加印记，显示距离你过近的玩家。",

	mark = "卡兹洛加印记",
	mark_desc = "显示卡兹洛加印记计时条。",
	mark_bar = "<下一印记：%d>",
	mark_warn = "5秒后，印记！",
} end )

L:RegisterTranslations("esES", function() return {
	range = "Comprobar rango",
	range_desc = "Mostrar la ventana de proximidad cuando estás bajo de maná y tienes la Marca de Kaz'rogal.",

	mark = "Marca de Kaz'rogal (Mark of Kaz'rogal)",
	mark_desc = "Mostrar una barra de tiempo para Marca de Kaz'rogal.",
	mark_bar = "~Marca (%d)",
	mark_warn = "Marca en 5 seg",
} end )
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	range = "Проверка досягаемости",
	range_desc = "Отображения панели близости когда у вас мало маны и вы с Меткой Каз'рогала.",

	mark = "Метка Каз'рогала ",
	mark_desc = "Отображения таймера Метки Каз'рогала.",
	mark_bar = "След Матка (%d)",
	mark_warn = "Метка за 5 сек!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hyjal Summit"]
mod.enabletrigger = boss
mod.guid = 17888
mod.toggleoptions = {"mark", "range", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit )
	for k, v in pairs( bandages ) do
		if IsItemInRange( k, unit) == 1 then
			return true
		end
	end
	return false
end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "MarkCast", 31447)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	count = 1

	local _, class = UnitClass("player")
	if class ~= "WARRIOR" and class ~= "ROGUE" then
		self:AddCombatListener("SPELL_AURA_APPLIED", "Mark", 31447)
		self:AddCombatListener("SPELL_AURA_REMOVED", "MarkRemoved", 31447)
	end

	self:AddCombatListener("UNIT_DIED", "BossDeath")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:MarkCast(_, spellID, _, _, spellName)
	if db.mark then
		local time = 45 - (count * 5)
		if time < 5 then time = 5 end
		self:IfMessage(("%s (%d)"):format(spellName, count), "Attention")
		count = count + 1
		self:Bar(L["mark_bar"]:format(count), time, spellID)
		self:DelayedMessage(time - 5, L["mark_warn"], "Positive")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.mark then
			count = 1
			self:Bar(L["mark_bar"]:format(count), 45, 31447)
			self:DelayedMessage(40, L["mark_warn"], "Positive")
		end
	end
end

function mod:Mark(player)
	if UnitIsUnit(player, "player") and db.range and UnitMana("player") < 4000 then
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:MarkRemoved(player)
	if UnitIsUnit(player, "player") and db.range then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

