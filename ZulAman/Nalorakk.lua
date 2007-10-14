------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Nalorakk"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Nalorakk",

	engage_trigger = "You be dead soon enough!",
	engage_message = "%s Engaged - Bear Form in 45sec!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase_bear = "You call on da beast, you gonna get more dan you bargain for!",
	phase_normal = "Make way for Nalorakk!",
	normal_message = "Normal Phase!",
	normal_bar = "Next Bear Phase",
	normal_soon = "Normal Phase in 10sec",
	normal_warning = "Normal Phase in 5sec",
	bear_message = "Bear Phase!",
	bear_bar = "Next Normal Phase",
	bear_soon = "Bear Phase in 10sec",
	bear_warning = "Bear Phase in 5sec",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous s'rez mort bien vite !",
	engage_message = "%s engagé - Forme d'ours dans 45 sec. !",

	phase = "Phase",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase_bear = "Vous d'mandez la bête, j'vais vous donner la bête !",
	phase_normal = "Place, voilà le Nalorakk !",
	normal_message = "Phase normale !",
	--normal_bar = "Next Bear Phase",
	--normal_soon = "Normal Phase in 10sec",
	--normal_warning = "Normal Phase in 5sec",
	bear_message = "Phase ours !",
	--bear_bar = "Next Normal Phase",
	--bear_soon = "Bear Phase in 10sec",
	--bear_warning = "Bear Phase in 5sec",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "황천으로 곧 보내주마!",
	engage_message = "%s 전투 시작 - 45초후 곰 변신!",

	phase = "상태",
	phase_desc = "상태 변환에 대해 경고합니다.",
	phase_bear = "네놈이 저 야수 녀석을 불렀구나, 기대했던 것보다 더한 걸 느끼게 될 것이다!",
	phase_normal = "날로라크님을 위해 길을 열어라!",
	normal_message = "보통 상태!",
	normal_bar = "다음 곰 변신",
	normal_soon = "보통 상태 10초 전",
	normal_warning = "보통 상태 5초 전",
	bear_message = "곰 변신!",
	bear_bar = "다음 보통 상태",
	bear_soon = "곰 변신 10초 전",
	bear_warning = "곰 변신 5초 전",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.phase then return end

	if msg == L["phase_bear"] then
		self:Message(L["bear_message"], "Attention")
		self:DelayedMessage(25, L["normal_warning"], "Attention")
		self:DelayedMessage(20, L["normal_soon"], "Urgent")
		self:Bar(L["bear_bar"], 30, "Ability_Racial_BearForm")
	elseif msg == L["phase_normal"] then
		self:Message(L["normal_message"], "Positive")
		self:DelayedMessage(40, L["bear_warning"], "Attention")
		self:DelayedMessage(35, L["bear_soon"], "Urgent")
		self:Bar(L["normal_bar"], 45, "INV_Misc_Head_Troll_01")
	elseif msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Positive")
		self:DelayedMessage(40, L["bear_warning"], "Attention")
		self:DelayedMessage(35, L["bear_soon"], "Urgent")
		self:Bar(L["normal_bar"], 45, "INV_Misc_Head_Troll_01")
	end
end
