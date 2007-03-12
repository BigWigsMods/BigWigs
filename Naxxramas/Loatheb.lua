------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Loatheb"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Loatheb",

	doom_name = "Inevitable Doom Alert",
	doom_desc = "Warn for Inevitable Doom",

	spore_name = "Spore Spawning Alert",
	spore_desc = "Warn when a spore spawns",

	curse_name = "Remove Curse Alert",
	curse_desc = "Warn when curses are removed from Loatheb",

	doombar = "Inevitable Doom %d",
	doomwarn = "Inevitable Doom %d! %d sec to next!",
	doomwarn5sec = "Inevitable Doom %d in 5 sec!",
	doomtrigger = "afflicted by Inevitable Doom.",

	sporewarn = "Spore %d Spawned",
	sporebar = "Summon Spore %d",
	sporespawntrigger = "Loatheb casts Summon Spore.",

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
	doom_name = "파멸 경고",
	doom_desc = "피할 수 없는 파멸에 대한 경고",

	spore_name = "포자 경고",
	spore_desc = "포자 소환에 대한 경고",

	curse_name = "저주 해제 경고",
	curse_desc = "로데브 저주 해제에 대한 경고",

	doombar = "피할 수 없는 파멸 %d",
	doomwarn = "피할 수 없는 파멸 %d! 다음은 %d초 후.",
	doomwarn5sec = "피할 수 없는 파멸 %d 5초 전",
	doomtrigger = "피할 수 없는 파멸에 걸렸습니다.",

	sporewarn = "포자 %d 소환됨!",
	sporebar = "포자 소환! %d",
	sporespawntrigger = "로데브|1이;가; 포자 소환|1을;를; 시전합니다.",

	removecursewarn = "로데브 저주 헤제 시전!",
	removecursebar = "저주 해제",
	removecursetrigger = "로데브|1이;가; 로데브에게 저주 해제|1을;를; 시전합니다.",

	doomtimerbar = "피할 수 없는 파멸 - 매 15초",
	doomtimerwarn = "%s초 후 피할 수 없는 파멸 시간변경!",
	doomtimerwarnnow = "피할 수 없는 파멸! 지금부터 매 15초마다.",

	startwarn = "로데브 전투시작!, 피할 수 없는 파멸까지 2 분!",

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

	doombar = "Unausweichliches Schicksal %d",
	doomwarn = "Unausweichliches Schicksal %d! %d Sekunden bis zum n\195\164chsten.",
	doomwarn5sec = "Unausweichliches Schicksal %d in 5 Sekunden",
	doomtrigger = "von Unausweichliches Schicksal betroffen.",

	sporewarn = "Spore %d aufgetaucht",
	sporebar = "Spore beschw\195\182ren %d",
	sporespawntrigger = "Loatheb wirkt Spore beschw\195\182ren.",

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

	removecursewarn = "洛欧塞布驱散了一个诅咒效果",
	removecursebar = "驱散诅咒",
	removecursetrigger = "洛欧塞布对洛欧塞布施放了驱散诅咒。",

	doomtimerbar = "每隔15秒发动必然的厄运",
	doomtimerwarn = "必然的厄运计时%s秒后改变！",
	doomtimerwarnnow = "必然的厄运现在每隔15秒发动一次！",

	startwarn = "洛欧塞布已激活 - 2分钟后发动必然的厄运！",

	you = "你",
	are = "到",
} end )

L:RegisterTranslations("zhTW", function() return {
	doom_name = "無可避免的末日警報",
	doom_desc = "無可避免的末日警報",

	spore_name = "孢子警報",
	spore_desc = "孢子警報",

	curse_name = "詛咒驅散警報",
	curse_desc = "洛斯伯驅散了一個詛咒效果時發出警報",

	doombar = "無可避免的末日",
	doomwarn = "無可避免的末日 - %s 秒後再次發動",
	doomwarn5sec = "5 秒後發動無可避免的末日！",
	doomtrigger = "受到了無可避免的末日效果的影響",

	sporewarn = "孢子出現",
	sporebar = "召喚孢子",
	sporespawntrigger = "洛斯伯施放了召喚孢子。",

	removecursewarn = "洛斯伯消除了一個詛咒效果",
	removecursebar = "消除詛咒",
	removecursetrigger = "洛斯伯對洛斯伯施放了消除詛咒。",

	doomtimerbar = "每隔 15 秒發動無可避免的末日",
	doomtimerwarn = "無可避免的末日計時 %s 秒後改變！",
	doomtimerwarnnow = "無可避免的末日現在每隔 15 秒發動一次！",

	startwarn = "洛斯伯已進入戰鬥 - 2 分鐘後發動無可避免的末日！",

	you = "你",
	are = "到",
} end )

L:RegisterTranslations("frFR", function() return {
	doomtrigger = "les effets de Mal\195\169diction in\195\169vitable.",

	sporespawntrigger = "Horreb lance Invocation de spore.",

	removecursetrigger = "Horreb lance D\195\169livrance de la mal\195\169diction sur Horreb.",

	you = "Vous",
	are = "subissez",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
mod.enabletrigger = boss
mod.toggleoptions = {"doom", "spore", "curse", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.doomTime = 30
	self.sporeCount = 1
	self.doomCount = 1
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")

--	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
--	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("BigWigs_RecvSync")

	-- 2: Doom and SporeSpawn versioned up because of the sync including the
	-- doom/spore count now, so we don't hold back the counter.
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebDoom", 600)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebSporeSpawn", 600)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebDoom2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebSporeSpawn2", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebRemoveCurse", 10)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
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

			self:ScheduleEvent("bwloathebdoomtimerreduce", function () mod.doomTime = 15 end, 300)

			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["doombar"], self.doomCount), 120, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
			self:ScheduleEvent("bwloathebdoom", "BigWigs_Message", 115, string.format(L["doomwarn5sec"], self.doomCount), "Urgent")
		end
	elseif sync == "LoathebDoom2" and rest then
		rest = tonumber(rest)
		if not rest then return end

		if rest == (self.doomCount + 1) then
			if self.db.profile.doom then
				self:TriggerEvent("BigWigs_Message", string.format(L["doomwarn"], self.doomCount, self.doomTime), "Important")
			end
			self.doomCount = self.doomCount + 1
			if self.db.profile.doom then
				self:TriggerEvent("BigWigs_StartBar", self, string.format(L["doombar"], self.doomCount), self.doomTime, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
				self:ScheduleEvent("bwloathebdoom", "BigWigs_Message", self.doomTime - 5, string.format(L["doomwarn5sec"], self.doomCount), "Urgent")
			end
		end
	elseif sync == "LoathebSporeSpawn2" and rest then
		rest = tonumber(rest)
		if not rest then return end

		if rest == (self.sporeCount + 1) then
			if self.db.profile.spore then
				self:TriggerEvent("BigWigs_Message", string.format(L["sporewarn"], self.sporeCount), "Important")
			end
			self.sporeCount = self.sporeCount + 1
			if self.db.profile.spore then
				self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sporebar"], self.sporeCount), 12, "Interface\\Icons\\Ability_TheBlackArrow")
			end
		end
	elseif sync == "LoathebRemoveCurse" then
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_Message", L["removecursewarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["removecursebar"], 30, "Interface\\Icons\\Spell_Holy_RemoveCurse")
		end
	end
end

function mod:Event( msg )
	if msg:find(L["doomtrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "LoathebDoom2 "..tostring(self.doomCount + 1))
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if msg == L["sporespawntrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "LoathebSporeSpawn2 "..tostring(self.sporeCount + 1))
	elseif msg == L["removecursetrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "LoathebRemoveCurse")
	end
end
