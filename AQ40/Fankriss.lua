------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Fankriss the Unyielding"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local worms

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Fankriss",
	worm_cmd = "worm",
	worm_name = "Worm Alert",
	worm_desc = "Warn for Incoming Worms",

	wormtrigger = "Fankriss the Unyielding casts Summon Worm.",
	wormwarn = "Incoming Worm! (%d)",
	wormbar = "Sandworm Enrage (%d)",
} end )

L:RegisterTranslations("deDE", function() return {
	worm_name = "Wurm beschw\195\182ren",
	worm_desc = "Warnung, wenn Fankriss einen Wurm beschw\195\182rt.",

	wormtrigger = "Fankriss der Unnachgiebige wirkt Wurm beschw\195\182ren.",
	wormwarn = "Wurm wurde beschworen! (%d)",
	wormbar = "Wurm ist w\195\188tend (%d)",
} end )

L:RegisterTranslations("zhCN", function() return {
	worm_name = "虫子警报",
	worm_desc = "召唤虫子出现时发出警报",

	wormtrigger = "顽强的范克瑞斯施放了召唤虫子。",
	wormwarn = "虫子出现 - 赶快杀掉！ (%d)",
	wormbar = "沙虫激怒 (%d)",
} end )

L:RegisterTranslations("zhTW", function() return {
	worm_name = "蟲子警報",
	worm_desc = "范克里斯召喚蟲子時發出警報",

	wormtrigger = "頑強的范克里斯施放了召喚蟲子。",
	wormwarn = "召喚蟲子出現！注意！",
	wormbar = "王蟲激怒(%d)",
} end )

L:RegisterTranslations("koKR", function() return {
	worm_name = "벌레 경고",
	worm_desc = "벌레에 대한 경고",

	wormtrigger = "불굴의 판크리스|1이;가; 벌레 소환|1을;를; 시전합니다.",
	wormwarn = "벌레 소환 - 제거! (%d)",
	wormbar = "소환! (%d)",
} end )

L:RegisterTranslations("frFR", function() return {
	wormtrigger = "Fankriss l'Inflexible lance Invocation d'un ver.",
	wormwarn = "Invocation d'un ver ! (%d)",
	wormbar = "Ver (%d) enrag\195\169 !",

	worm_name = "Alerte Ver",
	worm_desc = "Pr\195\169viens de l'arriv\195\169e des vers.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFankriss = BigWigs:NewModule(boss)
BigWigsFankriss.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsFankriss.enabletrigger = boss
BigWigsFankriss.toggleoptions = {"worm", "bosskill"}
BigWigsFankriss.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFankriss:OnEnable()
	worms = 0
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FankrissWormSpawn", .1)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFankriss:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["wormtrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FankrissWormSpawn "..tostring(worms + 1) )
	end
end

function BigWigsFankriss:BigWigs_RecvSync(sync, rest)
	if sync ~= "FankrissWormSpawn" then return end
	if not rest then return end
	rest = tonumber(rest)
	if rest == (worms + 1) then
		-- we accept this worm
		-- Yes, this could go completely wrong when you don't reset your module and the whole raid does after a wipe
		-- or you reset your module and the rest doesn't. Anyway. it'll work a lot better than anything else.
		worms = worms + 1
		if self.db.profile.worm then
			self:TriggerEvent("BigWigs_Message", string.format(L["wormwarn"], worms), "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["wormbar"], worms), 20, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		end	
	end
end
