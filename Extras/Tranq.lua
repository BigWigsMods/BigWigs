assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTranq")

L:RegisterTranslations("enUS", function() return {
	["Tranq - %s"] = true,
	["%s's Tranq failed!"] = true,

	["Options for the tranq module."] = true,
	["Toggle tranq bars on or off."] = true,
	["Bars"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Tranq - %s"] = "평정 - %s",
	["%s's Tranq failed!"] = "%s의 평정 실패!",

	["Options for the tranq module."] = "평정 모듈에 대한 설정입니다.",
	["Toggle tranq bars on or off."] = "평정바를 켜거나 끕니다.",
	["Bars"] = "바",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Tranq - %s"] = "宁神射击 - %s",
	["%s's Tranq failed!"] = "%s的宁神射击失败了！",

	["Options for the tranq module."] = "宁神射击模块选项。",
	["Toggle tranq bars on or off."] = "启用或禁用宁神射击计时条。",
	["Bars"] = "<宁神射击计时条>",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Tranq - %s"] = "寧神射擊 - %s",
	["%s's Tranq failed!"] = "%s 的寧神射擊失敗了!",

	["Options for the tranq module."] = "寧神射擊模組選項",
	["Toggle tranq bars on or off."] = "開啟或關閉寧神射擊計時條",
	["Bars"] = "<寧神射擊計時條>",
} end)

L:RegisterTranslations("deDE", function() return {
	["Tranq - %s"] = "Einlullender Schuss - %s",
	["%s's Tranq failed!"] = "Einlullender Schuss von %s hat verfehlt!",

	["Options for the tranq module."] = "Optionen für das Einlullender Schuss Modul.",
	["Toggle tranq bars on or off."] = "Einlullender Schuss Anzeigebalken anzeigen.",
	["Bars"] = "Anzeigebalken",
} end)

L:RegisterTranslations("frFR", function() return {
	--["Tranq - %s"] = true,
	["%s's Tranq failed!"] = "Le Tir tranq. |2 %s a échoué !",

	["Options for the tranq module."] = "Options concernant le module du Tir tranquilisant.",
	["Toggle tranq bars on or off."] = "Affiche ou non les barres des Tirs tranquillisants.",
	["Bars"] = "Barres",
} end)

L:RegisterTranslations("esES", function() return {
	["Tranq - %s"] = "Disparo tranquilizante - %s",
	["%s's Tranq failed!"] = "¡Disparo tranquilizante de %s fallado!",

	["Options for the tranq module."] = "Opciones para el módulo de Disparo tranquilizante.",
	["Toggle tranq bars on or off."] = "Mostrar barras de Disparo tranquilizante.",
	["Bars"] = "Barras",
} end)
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["Tranq - %s"] = "Спок-твие - %s",
	["%s's Tranq failed!"] = "%s'а спокойствие не подействовало!",

	["Options for the tranq module."] = "Опции модуля Спокойствия",
	["Toggle tranq bars on or off."] = "Вкл/Выкл панели Спокойствия",
	["Bars"] = "Полосы",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule("Tranq")
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.defaultDB = {
	bars = true,
}
mod.external = true
mod.consoleCmd = "Tranq"
mod.consoleOptions = {
	type = "group",
	name = GetSpellInfo(19801),
	desc = L["Options for the tranq module."],
	args = {
		[L["Bars"]] = {
			type = "toggle",
			name = L["Bars"],
			desc = L["Toggle tranq bars on or off."],
			get = function() return mod.db.profile.bars end,
			set = function(v)
				mod.db.profile.bars = v
			end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_DISPEL", "Tranq", 19801)
	self:AddCombatListener("SPELL_DISPEL_FAILED", "TranqFail", 19801)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Tranq(_, spellID, source)
	if self.db.profile.bars then
		self:Bar(L["Tranq - %s"]:format(source), 8, spellID, true, 0, 1, 0)
	end
end

function mod:TranqFail(_, spellID, source)
	if self.db.profile.bars then
		self:Bar(L["Tranq - %s"]:format(source), 8, spellID, true, 0, 0, 1)
		self:IfMessage(L["%s's Tranq failed!"]:format(source), "Attention", spellID, "Alarm")
	end
end

