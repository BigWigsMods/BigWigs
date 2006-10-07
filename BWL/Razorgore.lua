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
	start_message = "Razorgore engaged!",

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
	eggs_name = "Don't count eggs",
	eggs_desc = "Don't count down the remaining eggs - this option does not work for everyone, we need better triggers.",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Alert on phase 1 and 2",
} end)

L:RegisterTranslations("koKR", function() return {

	start_trigger = "????? ????! ?? ??? ???? ?? ??? ????!", -- By turtl
	start_message = "?? ????? ?? ??",

	mindcontrol_trigger = "?! ([^%s]+), ???? ?? ???!",	-- By turtl
	mindcontrol_message = "<<%s>> ?? ?? ?????.",

	egg_trigger = "?? ?????|1?;?; ? ??|1?;?; ?????.", -- By turtl
	egg_message = "%d/30 ?? ???????.",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.", -- CHECK
	phase2_message = "?? ?? ???????, ?????? ?????.", -- CHECK

	mc_name = "?? ??",
	mc_desc = "????? ?? ?? ??? ? ??",

	eggs_name = "? ?? ?? ???",
	eggs_desc = "?? ? ?? ?? ???",

	phase_name = "??",
	phase_desc = "?? 1 ? 2 ??",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Eindringlinge sind in die",
	start_message = "Razorgore angegriffen!",

	mindcontrol_trigger = "^([^%s]+), Ihr Narr, Ihr dient jetzt mir!",
	mindcontrol_message = "%s wurde \195\188bernommen!",

	egg_trigger = "Razorgore der Ungez\195\164hmte wirkt (.*) zerst\195\182ren.",
	egg_message = "%d/30 Eier zerst\195\182rt!",

	phase2_message = "Alle Eier zerst\195\182rt!",

	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnung, wenn Spieler \195\188bernommen werden.",

	phase_name = "Phasen",
	phase_desc = "Warnung beim Eintritt in Phase 1 und 2.",
} end)

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Sonnez l'alarme",
	start_message = "Razorgore engaged!",

	mindcontrol_trigger = "Stupide ([^%s]+), tu es mon esclave maintenant !$",
	mindcontrol_message = "%s est sous controle mental!",

	egg_trigger = "Tranchetripe l'Indompt\195\169 lance D\195\169truire (.+)%.",
	egg_message = "%d/30 oeufs dtruits!",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.", --TO TRANSLATE
	phase2_message = "All eggs destroyed, Razorgore loose!",
} end)

L:RegisterTranslations("zhCN", function() return {

	start_trigger = "入侵者",
	start_message = "狂野的拉佐格尔 战斗开始!",

	mindcontrol_trigger = "愚蠢的([^%s]+).",
	mindcontrol_message = "%s 精神控制",

	egg_trigger = "狂野的拉佐格尔施放了(.+)。",
	egg_message = "%d/30 龙蛋已经摧毁",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.",
	phase2_message = "所有龙蛋摧毁",

	mc_name = "精神控制",
	mc_desc = "当一个玩家使用精神控制时向团队发出警报。",

	eggs_name = "取消龙蛋计数",
	eggs_desc = "取消剩余龙蛋计数 - 该功能还在完善中。。。",

	phase_name = "第二阶段警报",
	phase_desc = "第二阶段警报",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazorgore = BigWigs:NewModule(boss)
BigWigsRazorgore.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsRazorgore.enabletrigger = { boss, controller }
BigWigsRazorgore.toggleoptions = { "mc", "eggs", "phase", "bosskill" }
BigWigsRazorgore.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazorgore:OnEnable()
	eggs = 0

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreEgg", 8)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazorgore:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["start_trigger"]) then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L["start_message"], "Urgent") end
		eggs = 0
	elseif self.db.profile.mc then
		local _, _, player = string.find(msg, L["mindcontrol_trigger"]);
		if player then
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], player), "Important")
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
		if not self.db.profile.eggs then
			self:TriggerEvent("BigWigs_Message", string.format(L["egg_message"], eggs), "Positive")
		end

		if eggs == 30 and self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Important")
		end
	end
end

