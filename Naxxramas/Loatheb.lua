------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Loatheb")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Loatheb",

	doom_cmd = "doom",
	doom_name = "Inevitable Doom Alert",
	doom_desc = "Warn for Inevitable Doom",

	spore_cmd = "spore",
	spore_name = "Spore Spawning Alert",
	spore_desc = "Warn when a spore spawns",

	curse_cmd = "curse",
	curse_name = "Remove Curse Alert",
	curse_desc = "Warn when curses are removed from Loatheb",

	doombar = "Inevitable Doom",
	doomwarn = "Inevitable Doom! %s sec to next!",
	doomwarn5sec = "Inevitable Doom in 5 sec!",		
	doomtrigger = "afflicted by Inevitable Doom.",

	sporewarn = "Spore Spawned",
	sporebar = "Summon Spore",
	sporespawntrigger = "Loatheb casts Summon Spore.",
	sporedietrigger = "Spore dies.",

	removecursewarn = "Curses removed on Loatheb",
	removecursebar = "Remove Curse",
	removecursetrigger = "Loatheb casts Remove Curse on Loatheb.",

	doomtimerbar = "Doom every 15sec",
	doomtimerwarn = "Doom timerchange in %s sec!",
	doomtimerwarnnow = "Inevitable Doom now happens every 15sec!",

	startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!",

	you = "You",
	are = "are",
} end )

L:RegisterTranslations("koKR", function() return {

	doom_name = "?? ??",
	doom_desc = "?? ? ?? ??? ?? ??",
	
	spore_name = "?? ??",
	spore_desc = "?? ??? ?? ??",

	curse_name = "?? ?? ??",
	curse_desc = "??? ?? ??? ?? ??",

	doombar = "?? ? ?? ??",
	doomwarn = "?? ? ?? ??! ??? %s? ?.",
	doomwarn5sec = "?? ? ?? ?? 5? ?",		
	doomtrigger = "?? ? ?? ??? ?????.",
	
	sporewarn = "????!",
	sporebar = "?? ??!",
	sporespawntrigger = "???|1?;?; ?? ??|1?;?; ?????.",
	sporedietrigger = "??|1?;?; ?????.",

	removecursewarn = "??? ?? ?? ??!",
	removecursebar = "?? ??",
	removecursetrigger = "???|1?;?; ????? ?? ??|1?;?; ?????.",
	
	doomtimerbar = "?? ? ?? ?? - ? 15?",
	doomtimerwarn = "%s? ? ?? ? ?? ?? ????!",
	doomtimerwarnnow = "?? ? ?? ??! ???? ? 15???.",
	
	startwarn = "??? ????!, ?? ? ?? ???? 2 ?!",

	you = "",
	are = "",
} end )

L:RegisterTranslations("deDE", function() return {
	doom_name = "Unausweichliches Schicksal",
	doom_desc = "Warnung f\195\188r Unausweichliches Schicksal.",

	spore_name = "Warnung bei Sporen",
	spore_desc = "Warnung wenn Sporen auftauchen",

	curse_name = "Fluch-Aufhebungs Warnung",
	curse_desc = "Warnung wenn Fl\195\188che bei Loatheb aufgehoben wurden",

	doombar = "Unausweichliches Schicksal",
	doomwarn = "Unausweichliches Schicksal! %s Sekunden bis zum n\195\164chsten.",
	doomwarn5sec = "Unausweichliches Schicksal in 5 Sekunden",
	doomtrigger = "von Unausweichliches Schicksal betroffen.",

	sporewarn = "Spore aufgetaucht",
	sporebar = "Spore beschw\195\182ren",
	sporespawntrigger = "Loatheb wirkt Spore beschw\195\182ren.",
	sporedietrigger = "Spore stirbt.",

	removecursewarn = "Fl\195\188che bei Loatheb aufgehoben",
	removecursebar = "Fluch aufheben",
	removecursetrigger = "Loatheb wirkt Fluch aufheben auf Loatheb.",

	doomtimerbar = "Unausweichliches Schicksal alle 15 Sekunden",
	doomtimerwarn = "Unausweichliches Schicksal Timer Wechsel in %s Sekunden!",
	doomtimerwarnnow = "Unausweichliches Schicksal nun alle 15s!",

	startwarn = "Loatheb angegriffen! 2 Minuten bis Unausweichliches Schicksal!",

	you = "Ihr",
	are = "seid",
} end )

L:RegisterTranslations("zhCN", function() return {
	doom_name = "必然的厄运警报",
	doom_desc = "必然的厄运警报",

	spore_name = "孢子警报",
	spore_desc = "孢子警报",

	curse_name = "诅咒驱散警报",
	curse_desc = "洛欧塞布驱散了一个诅咒效果时发出警报",

	doombar = "必然的厄运",
	doomwarn = "必然的厄运 - %s秒后再次发动",
	doomwarn5sec = "5秒后发动必然的厄运！",		
	doomtrigger = "受到了必然的厄运效果的影响",

	sporewarn = "孢子出现",
	sporebar = "召唤孢子",
	sporespawntrigger = "洛欧塞布施放了召唤孢子。",
	sporedietrigger = "孢子死亡了。",

	removecursewarn = "洛欧塞布驱散了一个诅咒效果",
	removecursebar = "驱散诅咒",
	removecursetrigger = "洛欧塞布对洛欧塞布施放了驱散诅咒。",

	doomtimerbar = "每隔15秒发动必然的厄运",
	doomtimerwarn = "必然的厄运计时%s秒后改变！",
	doomtimerwarnnow = "必然的厄运现在每隔15秒发动一次！",
	
	startwarn = "洛欧塞布已激活 - 2分钟后发动必然的厄运！",

	you = "你",
	are = "是",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsLoatheb = BigWigs:NewModule(boss)
BigWigsLoatheb.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsLoatheb.enabletrigger = boss
BigWigsLoatheb.toggleoptions = {"doom", "spore", "curse", "bosskill"}
BigWigsLoatheb.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsLoatheb:OnEnable()
	self.doomTime = 30
	started = nil
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebDoom", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebSporeSpawn", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebRemoveCurse", 10)
end

function BigWigsLoatheb:BigWigs_RecvSync(sync, rest, nick)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.doom then
			self:TriggerEvent("BigWigs_StartBar", self, L["doomtimerbar"], 300, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:ScheduleEvent("bwloathebtimerreduce1", "BigWigs_Message", 240, string.format(L["doomtimerwarn"], 60), "Attention")
			self:ScheduleEvent("bwloathebtimerreduce2", "BigWigs_Message", 270, string.format(L["doomtimerwarn"], 30), "Attention")
			self:ScheduleEvent("bwloathebtimerreduce3", "BigWigs_Message", 290, string.format(L["doomtimerwarn"], 10), "Urgent")
			self:ScheduleEvent("bwloathebtimerreduce4", "BigWigs_Message", 295, string.format(L["doomtimerwarn"], 5), "Important")
			self:ScheduleEvent("bwloathebtimerreduce5", "BigWigs_Message", 300, L["doomtimerwarnnow"], "Important")

			self:ScheduleEvent("bwloathebdoomtimerreduce", function () BigWigsLoatheb.doomTime = 15 end, 300)

			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["doombar"], 120, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
			self:ScheduleEvent("bwloathebdoom", "BigWigs_Message", 115, L["doomwarn5sec"], "Urgent")
		end
	elseif sync == "LoathebDoom" then
		if self.db.profile.doom then
			self:TriggerEvent("BigWigs_Message", string.format(L["doomwarn"], self.doomTime), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["doombar"], self.doomTime, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
			self:ScheduleEvent("bwloathebdoom", "BigWigs_Message", self.doomTime - 5, L["doomwarn5sec"], "Urgent")
		end
	elseif sync == "LoathebSporeSpawn" then
		if self.db.profile.spore then
			self:TriggerEvent("BigWigs_Message", L["sporewarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["sporebar"], 12, "Interface\\Icons\\Ability_TheBlackArrow")
		end
	elseif sync == "LoathebRemoveCurse" then
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_Message", L["removecursewarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["removecursebar"], 30, "Interface\\Icons\\Spell_Holy_RemoveCurse")
		end
	end
end

function BigWigsLoatheb:Event( msg )
	if string.find(msg, L["doomtrigger"]) then self:TriggerEvent("BigWigs_SendSync", "LoathebDoom") end
end

function BigWigsLoatheb:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if msg == L["sporespawntrigger"] then 
		self:TriggerEvent("BigWigs_SendSync", "LoathebSporeSpawn")
	elseif msg == L["removecursetrigger"] then 
		self:TriggerEvent("BigWigs_SendSync", "LoathebRemoveCurse")
	end
end

