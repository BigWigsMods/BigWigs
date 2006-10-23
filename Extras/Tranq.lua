
assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTranq")

L:RegisterTranslations("enUS", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "You fail to dispel (.+)'s Frenzy.",
	CHAT_MSG_SPELL_SELF_DAMAGE = "You cast Tranquilizing Shot on (.+).",

	["Tranq - %s"] = true,
	["%s's Tranq failed!"] = true,
	["Tranq"] = true,
	["Options for the tranq module."] = true,
	["Toggle tranq bars on or off."] = true,
	["Bars"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "(.+)의 광기|1을;를; 무효화하지 못했습니다.", --"You fail to dispel (.+)'s Frenzy.",
	CHAT_MSG_SPELL_SELF_DAMAGE = "(.+)에게 평정의 사격|1을;를; 시전합니다.", --"You cast Tranquilizing Shot on (.+).",

	["Tranq - %s"] = "평정 - %s",
	["%s's Tranq failed!"] = "%s의 평정 실패!",
	["Tranq"] = "평정",
	["Options for the tranq module."] = "평정 모듈에 대한 설정.",
	["Toggle tranq bars on or off."] = "평정바 토글.",
	["Bars"] = "바",
} end)

L:RegisterTranslations("zhCN", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "你未能驱散(.+)的狂暴。",
	CHAT_MSG_SPELL_SELF_DAMAGE = "你对(.+)施放了宁神射击。",

	["Tranq - %s"] = "宁神射击 - %s",
	["%s's Tranq failed!"] = "%s的宁神射击失败了！",
	["Tranq"] = "宁神射击",
	["Options for the tranq module."] = "设置宁神射击模块.",
	["Toggle tranq bars on or off."] = "开启或禁用宁神射击计时条.",
	["Bars"] = "宁神射击计时条",
} end)

L:RegisterTranslations("zhTW", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "你未能驅散(.+)的狂暴。",
	CHAT_MSG_SPELL_SELF_DAMAGE = "你對(.+)施放了寧神射擊。",

	["Tranq - %s"] = "寧神射擊 - %s",
	["%s's Tranq failed!"] = "%s的寧神射擊失敗了！",
	["Tranq"] = "寧神射擊",
	["Options for the tranq module."] = "寧神射擊模組選項.",
	["Toggle tranq bars on or off."] = "開啟或禁用寧神射擊計時條.",
	["Bars"] = "寧神射擊計時條",
} end)

L:RegisterTranslations("deDE", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "(.+) kann dies nicht bannen: Raserei", -- ?
	CHAT_MSG_SPELL_SELF_DAMAGE = "Ihr wirkt Einlullender Schuss auf (.+)",

	["Tranq - %s"] = "Einlullender Schuss - %s",
	["%s's Tranq failed!"] = "%s's Einlullender Schuss verfehlt",
	["Tranq"] = "EinlullenderSchuss",
	["Options for the tranq module."] = "Optionen f\195\188r das Einlullender Schuss Modul.",
	["Toggle tranq bars on or off."] = "Einlullender Schuss Anzeigebalken anzeigen.",
	["Bars"] = "Anzeigebalken",
} end)

L:RegisterTranslations("frFR", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "Vous n'avez pas r\195\169ussi \195\160 dissiper le fr\195\169n\195\169sie de (.+).";
	CHAT_MSG_SPELL_SELF_DAMAGE = "Vous lancez Tir tranquillisant sur (.+).",

	["%s's Tranq failed!"] = "Le Tranq de %s a \195\169chou\195\169 !",
	["Options for the tranq module."] = "Options du module Tranq",
	["Toggle tranq bars on or off."] = "Afficher ou masquer les barres de Tranq",
	["Bars"] = "Barres",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTranq = BigWigs:NewModule(L["Tranq"])
BigWigsTranq.revision = tonumber(string.sub("$Revision: 11446 $", 12, -3))
BigWigsTranq.defaults = {
	bars = true,
}
BigWigsTranq.external = true
BigWigsTranq.consoleCmd = L["Tranq"]
BigWigsTranq.consoleOptions = {
	type = "group",
	name = L["Tranq"],
	desc = L["Options for the tranq module."],
	args = {
		[L["Bars"]] = {
			type = "toggle",
			name = L["Bars"],
			desc = L["Toggle tranq bars on or off."],
			get = function() return BigWigsTranq.db.profile.bars end,
			set = function(v)
				BigWigsTranq.db.profile.bars = v
			end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsTranq:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("BigWigs_TranqFired", 5)
	self:RegisterEvent("BigWigs_TranqFail", 5)
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTranq:CHAT_MSG_SPELL_SELF_BUFF(msg)
	if not msg then
		self:Debug("CHAT_MSG_SPELL_SELF_BUFF: msg is nil")
	elseif string.find(msg, L["CHAT_MSG_SPELL_SELF_BUFF"]) then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFail "..UnitName("player"))
	end
end


function BigWigsTranq:CHAT_MSG_SPELL_SELF_DAMAGE(msg)
	if not msg then
		self:Debug("CHAT_MSG_SPELL_SELF_DAMAGE: msg is nil")
	elseif string.find(msg, L["CHAT_MSG_SPELL_SELF_DAMAGE"]) then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFired "..UnitName("player"))
	end
end


function BigWigsTranq:BigWigs_RecvSync(sync, details, sender)
	if sync == "TranqShotFired" then self:TriggerEvent("BigWigs_TranqFired", details)
	elseif sync == "TranqShotFail" then self:TriggerEvent("BigWigs_TranqFail", details) end
end


function BigWigsTranq:BigWigs_TranqFired(unitname)
	if self.db.profile.bars then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["Tranq - %s"], unitname), 20, "Interface\\Icons\\Spell_Nature_Drowsy")
	end
end


function BigWigsTranq:BigWigs_TranqFail(unitname)
	if self.db.profile.bars then
		self:SetCandyBarColor(string.format(L["Tranq - %s"], unitname), "Red")
		self:TriggerEvent("BigWigs_Message", format(L["%s's Tranq failed!"], unitname), "Important", nil, "Alarm")
	end
end

