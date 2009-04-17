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
mod.toggleoptions = {"phase", "portal", "weakened", "bosskill"}

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
	elseif msg == L["weakened_trigger"] and db.weakened then
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
