----------------------------------
--      Module Declaration      --
----------------------------------

local sara = BB["Sara"]	--need the add name translated, maybe add to BabbleBoss.
local boss = BB["Yogg-Saron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {"sara", "boss"}
mod.guid = 33288
mod.toggleoptions = {"phase", "portal", "weakened", "madness", "bosskill"}

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
	
	phase = "Phase",
	phase_desc = "Warn for phase changes.",
	engage_warning = "Phase 1",
	engage_trigger = "^The time to",
	phase2_warning = "Phase 2",
	phase2_trigger = "^I am the lucid dream",
	phase2_warning = "Phase 3",
	phase3_trigger = "^Look upon the true face",
		
	portal = "Portal",
	portal_desc = "Warn for Portals.",
	portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "Portals open!",
	
	weakened = "Weakened",
	weakened_desc = "Warn for Weakened State.",
	weakened_message = "%s is weakened!",
	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",
	
	madness = "Induce Madness",
	madness_desc = "Show Timer for Induce Madness.",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	engage_warning = "1 단계",
	engage_trigger = "^짐승의",	--check
	phase2_warning = "2 단계",
	phase2_trigger = "^나는 살아있는 꿈이다",	--check
	phase2_warning = "3 단계",
	phase3_trigger = "^죽음의 진정한 얼굴을 보아라",	--check
		
	portal = "차원문",
	portal_desc = "차원문을 알립니다.",
	--portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "차원문 열림!",
	
	weakened = "약화",
	weakened_desc = "약화 상태를 알립니다.",
	weakened_message = "%s 약화!",
	--weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",
	
	madness = "광기 유발",
	madness_desc = "광기 유발의 타이머를 표시합니다.",
	
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
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	
	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["portal_trigger"] and db.portal then
		self:IfMessage(L["portal_message"], "Attention")
		if db.madness then
			self:Bar(L["madness"], 60, 64059)
		end
	elseif msg == L["weakened_trigger"] and db.weakened then
		self:TriggerEvent("BigWigs_StopBar", self, L["madness"])
		self:IfMessage(L["weakened_message"]:format(boss), "Attention")
		self:Bar(L["weakened"], 45, 50661)	--50661, looks like a weakened :)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		phase = 1
		if db.phase then
			self:Message(L["engage_warning"], "Important", nil, "Alarm")
		end
	elseif msg:find(L["phase2_trigger"]) then
		phase = 2
		if db.phase then
			self:IfMessage(L["phase2_warning"], "Important", nil, "Alarm")
		end
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		if db.phase then
			self:IfMessage(L["phase3_warning"], "Important", nil, "Alarm")
		end
	end
end
