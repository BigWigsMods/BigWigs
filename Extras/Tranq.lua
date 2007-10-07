assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTranq")
local pName = nil

L:RegisterTranslations("enUS", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "^You fail to dispel (.+)'s Frenzy%.$",
	CHAT_MSG_SPELL_SELF_DAMAGE = "^You cast Tranquilizing Shot on (.+).$",
	["Tranquilizing Shot"] = true,

	["Tranq - %s"] = true,
	["%s's Tranq failed!"] = true,
	["Tranq"] = true,
	["Options for the tranq module."] = true,
	["Toggle tranq bars on or off."] = true,
	["Bars"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "^당신은 (.+)에게 걸려 있는 광기|1을;를; 무효화하지 못했습니다%.$",
	CHAT_MSG_SPELL_SELF_DAMAGE = "^당신은 (.+)에게 평정의 사격|1을;를; 시전합니다%.$",
	["Tranquilizing Shot"] = "평정의 사격",

	["Tranq - %s"] = "평정 - %s",
	["%s's Tranq failed!"] = "%s의 평정 실패!",
	["Tranq"] = "평정",
	["Options for the tranq module."] = "평정 모듈에 대한 설정입니다.",
	["Toggle tranq bars on or off."] = "평정바를 켜거나 끕니다.",
	["Bars"] = "바",
} end)

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "未能驱散(.+)的狂暴。$",
	CHAT_MSG_SPELL_SELF_DAMAGE = "对(.+)施放了宁神射击。$",
	["Tranquilizing Shot"] = "宁神射击",

	["Tranq - %s"] = "宁神射击 - %s",
	["%s's Tranq failed!"] = "%s的宁神射击失败了！",
	["Tranq"] = "宁神射击",
	["Options for the tranq module."] = "设置宁神射击模块.",
	["Toggle tranq bars on or off."] = "启用或禁用宁神射击计时条.",
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
	["Options for the tranq module."] = "Optionen für das Einlullender Schuss Modul.",
	["Toggle tranq bars on or off."] = "Einlullender Schuss Anzeigebalken anzeigen.",
	["Bars"] = "Anzeigebalken",
} end)

L:RegisterTranslations("frFR", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "^Vous n'avez pas réussi à dissiper le Frénésie de (.+).$";
	CHAT_MSG_SPELL_SELF_DAMAGE = "^Vous lancez Tir tranquillisant sur (.+).$",
	["Tranquilizing Shot"] = "Tir tranquillisant",

	--["Tranq - %s"] = true,
	["%s's Tranq failed!"] = "Le Tir tranq. de %s a échoué !",
	--["Tranq"] = true,
	["Options for the tranq module."] = "Options concernant le module du Tir tranquilisant.",
	["Toggle tranq bars on or off."] = "Affiche ou non les barres des Tirs tranquillisants.",
	["Bars"] = "Barres",
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
mod.consoleCmd = L["Tranq"]
mod.consoleOptions = {
	type = "group",
	name = L["Tranq"],
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
	local class = select(2, UnitClass("player"))
	if class == "HUNTER" then
		self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")

	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("BigWigs_TranqFired", 5)
	self:RegisterEvent("BigWigs_TranqFail", 5)
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:UNIT_SPELLCAST_SUCCEEDED(player, spell, rank)
	if player == "player" and spell == L["Tranquilizing Shot"] then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFired "..pName)
	end
end

function mod:CHAT_MSG_SPELL_SELF_BUFF(msg)
	if not msg then
		BigWigs:Debug("CHAT_MSG_SPELL_SELF_BUFF: msg is nil")
	elseif msg:find(L["CHAT_MSG_SPELL_SELF_BUFF"]) then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFail "..pName)
	end
end

function mod:CHAT_MSG_SPELL_SELF_DAMAGE(msg)
	if not msg then
		BigWigs:Debug("CHAT_MSG_SPELL_SELF_DAMAGE: msg is nil")
	elseif msg:find(L["CHAT_MSG_SPELL_SELF_DAMAGE"]) then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFired "..pName)
	end
end

function mod:BigWigs_RecvSync(sync, details, sender)
	if sync == "TranqShotFired" then
		self:TriggerEvent("BigWigs_TranqFired", details)
	elseif sync == "TranqShotFail" then
		self:TriggerEvent("BigWigs_TranqFail", details)
	end
end

function mod:BigWigs_TranqFired(unitname)
	if self.db.profile.bars then
		self:TriggerEvent("BigWigs_StartBar", self, L["Tranq - %s"]:format(unitname), 20, "Interface\\Icons\\Spell_Nature_Drowsy")
	end
end

function mod:BigWigs_TranqFail(unitname)
	if self.db.profile.bars then
		self:SetCandyBarColor(L["Tranq - %s"]:format(unitname), "Red")
		self:TriggerEvent("BigWigs_Message", L["%s's Tranq failed!"]:format(unitname), "Important", nil, "Alarm")
	end
end

