------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Zul'jin"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Zul'jin",

	engage_trigger = "Nobody badduh dan me!",
	engage_message = "Phase 1 - Human Phase",

	form = "Form Shift",
	form_desc = "Warn when Zul'jin changes form.",
	form_bear_trigger = "Got me some new tricks... like me brudda bear....",
	form_bear_message = "Phase 2 - Bear Form!",
	form_eagle_trigger = "Dere be no hidin' from da eagle!",
	form_eagle_message = "Phase 3 - Eagle Form!",
	form_lynx_trigger = "Let me introduce you to me new bruddas: fang and claw!",
	form_lynx_message = "Phase 4 - Lynx Form!",
	form_dragonhawk_trigger = "Ya don' have to look to da sky to see da dragonhawk!",
	form_dragonhawk_message = "Phase 5 - Dragonhawk Form!",
} end )

L:RegisterTranslations("frFR", function() return {
	--engage_trigger = "Nobody badduh dan me!",
	engage_message = "Phase 1 - Forme trolle",

	form = "Changement de forme",
	form_desc = "Préviens quand Zul'jin change de forme.",
	--form_bear_trigger = "Got me some new tricks... like me brudda bear....",
	form_bear_message = "Phase 2 - Forme d'ours !",
	--form_eagle_trigger = "Dere be no hidin' from da eagle!",
	form_eagle_message = "Phase 3 - Forme d'aigle !",
	--form_lynx_trigger = "Let me introduce you to me new bruddas: fang and claw!",
	form_lynx_message = "Phase 4 - Forme de lynx !",
	--form_dragonhawk_trigger = "Ya don' have to look to da sky to see da dragonhawk!",
	form_dragonhawk_message = "Phase 5 - Forme de faucon-dragon !",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "누구도 날 넘어설 순 없다!",
	engage_message = "1단계 - 인간형",

	form = "변신 알림",
	form_desc = "줄진이 변신할 때 알립니다.",
	form_bear_trigger = "새로운 기술을 익혔지... 내 형제의 곰처럼...",  -- Check
	form_bear_message = "2단계 - 곰!",
	form_eagle_trigger = "독수리의 눈을 피할수는 없다!",  -- Check
	form_eagle_message = "3단계 - 독수리!",
	form_lynx_trigger = "내 새로운 형제... 송곳니와 발톱을 보아라!",  -- Check
	form_lynx_message = "4단계 - 스라소니!",
	form_dragonhawk_trigger = "용매를 하늘에서만 찾을 필요는 없다!",  -- Check
	form_dragonhawk_message = "5단계 - 용매!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"form", "bosskill"}
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
	if not self.db.profile.form then return end

	if msg == L["form_bear_trigger"] then
		self:Message(L["form_bear_message"], "Urgent")
	elseif msg == L["form_eagle_trigger"] then
		self:Message(L["form_eagle_message"], "Important")
	elseif msg == L["form_lynx_trigger"] then
		self:Message(L["form_lynx_message"], "Positive")
	elseif msg == L["form_dragonhawk_trigger"] then
		self:Message(L["form_dragonhawk_message"], "Attention")
	elseif msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Attention")
	end
end
