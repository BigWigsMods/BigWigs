------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Razorgore the Untamed")
local controller = AceLibrary("Babble-Boss-2.0")("Grethok the Controller")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)
local eggs

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorgore",

	start_trigger = "Intruders have breached",
	start_message = "Razorgore engaged, 30 eggs to go!",

	mindcontrol_trigger = "Foolish ([^%s]+).",
	mindcontrol_message = "%s has been mind controlled!",

	egg_trigger = "casts Destroy Egg",
	egg_message = "%d/30 eggs destroyed!",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.",
	phase2_message = "All eggs destroyed, Razorgore loose!",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Warn when players are mind controlled",

	eggs_cmd = "eggs",
	eggs_name = "Egg countdown",
	eggs_desc = "Count down the remaining eggs",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Alert on phase 1 and 2",
} end)

L:RegisterTranslations("koKR", function() return {

	start_trigger = "침입자들이 들어왔다! 어떤 희생이 있더라도 알을 반드시 수호하라!", -- By turtl
	start_message = "폭군 서슬송곳니 전투 시작, 알 30 개!",

	mindcontrol_trigger = "자! ([^%s]+), 이제부터 나를 섬겨라!",	-- By turtl
	mindcontrol_message = "<<%s>> 정신 지배 되었습니다.",

	egg_trigger = "폭군 서슬송곳니|1이;가; 알 파괴|1을;를; 시전합니다.", -- By turtl
	egg_message = "%d/30 알을 파괴하였습니다.",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.", -- CHECK
	phase2_message = "모든 알이 파괴되었습니다, 서슬송곳니가 풀려납니다.", -- CHECK

	mc_name = "정신 지배",
	mc_desc = "플레이어가 정신 지배 되었을 때 경고",

	eggs_name = "알 개수",
	eggs_desc = "남은 알 개수 알림",

	phase_name = "단계",
	phase_desc = "단계 1 과 2 알림",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Eindringlinge sind in die",
	start_message = "Razorgore angegriffen! 30 Eier noch zu zerst\195\182ren!",

	mindcontrol_trigger = "^([^%s]+), Ihr Narr, Ihr dient jetzt mir!",
	mindcontrol_message = "%s wurde \195\188bernommen!",

	egg_trigger = "Razorgore der Ungez\195\164hmte wirkt (.*) zerst\195\182ren.",
	egg_message = "%d/30 Eier zerst\195\182rt!",

	phase2_message = "Alle Eier zerst\195\182rt!",

	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnung, wenn Spieler \195\188bernommen werden.",

	eggs_name = "Eier",
	eggs_desc = "Countdown f\195\188r die noch zu zerst\195\182renden Eier.",

	phase_name = "Phasen",
	phase_desc = "Warnung beim Eintritt in Phase 1 und 2.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazorgore = BigWigs:NewModule(boss)
BigWigsRazorgore.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsRazorgore.enabletrigger = { boss, controller }
BigWigsRazorgore.toggleoptions = { "mc", --[["eggs",]] "phase", "bosskill"}
BigWigsRazorgore.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazorgore:OnEnable()
	eggs = 0

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	-- self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
	-- self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreEgg", 8)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazorgore:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["start_trigger"]) then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L["start_message"], "Orange") end
		eggs = 0
	elseif self.db.profile.mc then
		local _, _, player = string.find(msg, L["mindcontrol_trigger"]);
		if player then
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], player), "Red")
		end
	end
end

function BigWigsRazorgore:CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF(msg)
	if string.find(msg, L["egg_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(eggs + 1))
	end
end

function BigWigsRazorgore:BigWigs_RecvSync(sync, rest)
	if sync ~= "RazorgoreEgg" or not rest then return end
	rest = tonumber(rest)

	if rest == (eggs + 1) then
		eggs = eggs + 1
		if self.db.profile.eggs then
			self:TriggerEvent("BigWigs_Message", string.format(L["egg_message"], eggs), "Orange")
		end

		if eggs == 30 and self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Red")
		end
	end
end

