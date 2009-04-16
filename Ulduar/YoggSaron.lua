----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Yogg-Saron"]	--need the add name translated, maybe add to BabbleBoss.
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 16777215
mod.toggleoptions = {"bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "YoggSaron",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	
	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 스샷등을 http://cafe.daum.net/SCU15 통해 알려주세요.",
} end )

L:RegisterTranslations("frFR", function() return {
	
	log = "|cffff0000"..boss.."|r?: ce boss a besoin de donnees, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

L:RegisterTranslations("deDE", function() return {
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

