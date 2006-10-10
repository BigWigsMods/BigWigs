
assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsTranq")

L:RegisterTranslations("enUS", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "You fail to dispel (.+)'s Frenzy.",
	CHAT_MSG_SPELL_SELF_DAMAGE = "You cast Tranquilizing Shot on (.+).",

	["Tranq - "] = true,
	["%s's Tranq failed!"] = true,
	["Tranq"] = true,
	["Options for the tranq module."] = true,
	["Toggle tranq bars on or off."] = true,
	["Bars"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "(.+)의 광기|1을;를; 무효화하지 못했습니다.", --"You fail to dispel (.+)'s Frenzy.",
	CHAT_MSG_SPELL_SELF_DAMAGE = "(.+)에게 평정의 사격|1을;를; 시전합니다.", --"You cast Tranquilizing Shot on (.+).",

	["Tranq - "] = "평정 - ",
	["%s's Tranq failed!"] = "%s의 평정 실패!",
	["Tranq"] = "평정",
	["Options for the tranq module."] = "평정 모듈에 대한 설정.",
	["Toggle tranq bars on or off."] = "평정바 토글.",
	["Bars"] = "바",
} end)

L:RegisterTranslations("zhCN", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "你未能驱散(.+)的狂暴。",
	CHAT_MSG_SPELL_SELF_DAMAGE = "你对(.+)施放了宁神射击。",

	["Tranq - "] = "宁神射击 - ",
	["%s's Tranq failed!"] = "%s的宁神射击失败了！",
	["Tranq"] = "宁神射击",
	["Options for the tranq module."] = "设置宁神射击模块.",
	["Toggle tranq bars on or off."] = "开启或禁用宁神射击计时条.",
	["Bars"] = "宁神射击计时条",
} end)

L:RegisterTranslations("deDE", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "(.+) kann dies nicht bannen: Raserei", -- ?
	CHAT_MSG_SPELL_SELF_DAMAGE = "Ihr wirkt Einlullender Schuss auf (.+)",

	["Tranq - "] = "Einlullender Schuss - ",
	["%s's Tranq failed!"] = "%s's Einlullender Schuss verfehlt",
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
	elseif string.find(msg, L"CHAT_MSG_SPELL_SELF_BUFF") then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFail "..UnitName("player"))
	end
end


function BigWigsTranq:CHAT_MSG_SPELL_SELF_DAMAGE(msg)
	if not msg then
		self:Debug("CHAT_MSG_SPELL_SELF_DAMAGE: msg is nil")
	elseif string.find(msg, L"CHAT_MSG_SPELL_SELF_DAMAGE") then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFired "..UnitName("player"))
	end
end


function BigWigsTranq:BigWigs_RecvSync(sync, details, sender)
	if sync == "TranqShotFired" then self:TriggerEvent("BigWigs_TranqFired", details)
	elseif sync == "TranqShotFail" then self:TriggerEvent("BigWigs_TranqFail", details) end
end


function BigWigsTranq:BigWigs_TranqFired(unitname)
	if self.db.profile.bars then
		self:TriggerEvent("BigWigs_StartBar", self, L["Tranq - "]..unitname, 20, "Interface\\Icons\\Spell_Nature_Drowsy")
	end
end


function BigWigsTranq:BigWigs_TranqFail(unitname)
	if self.db.profile.bars then
		self:SetCandyBarColor(L["Tranq - "]..unitname, "Red")
		self:TriggerEvent("BigWigs_Message", format(L["%s's Tranq failed!"], unitname), "Important", nil, "Alarm")
	end
end
