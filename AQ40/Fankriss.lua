------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Fankriss the Unyielding")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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
	cmd = "Fankriss",
	worm_cmd = "worm",
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

L:RegisterTranslations("koKR", function() return {
	wormtrigger = "불굴의 판크리스|1이;가; 벌레 소환|1을;를; 시전합니다.",
	wormwarn = "벌레 소환 - 제거! (%d)",
} end )

L:RegisterTranslations("frFR", function() return {
	wormtrigger = "Fankriss l'Inflexible lance Invocation d'un ver.",
	wormwarn = "Incoming ver(%d) !",
	wormbar = "ver (%d) Enrage ",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFankriss = BigWigs:NewModule(boss)
BigWigsFankriss.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsFankriss.enabletrigger = boss
BigWigsFankriss.toggleoptions = {"worm", "bosskill"}
BigWigsFankriss.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFankriss:OnEnable()
	self.worms = 0
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
		self:TriggerEvent("BigWigs_SendSync", "FankrissWormSpawn "..tostring(self.worms + 1) )
	end
end

function BigWigsFankriss:BigWigs_RecvSync(sync, rest)
	if sync ~= "FankrissWormSpawn" then return end
	if not rest then return end
	rest = tonumber(rest)
	if rest == (self.worms + 1) then
		-- we accept this worm
		-- Yes, this could go completely wrong when you don't reset your module and the whole raid does after a wipe
		-- or you reset your module and the rest doesn't. Anyway. it'll work a lot better than anything else.
		self.worms = self.worms + 1
		if self.db.profile.worm then
			self:TriggerEvent("BigWigs_Message", string.format( L["wormwarn"], self.worms ), "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, string.format( L["wormbar"], self.worms ), 20, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Yellow", "Orange", "Red")
		end	
	end
end
