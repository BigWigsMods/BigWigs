------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Anubisath Defender")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Defender",
	plagueyou_cmd = "plagueyou",
	plagueyou_name = "Plague on you alert",
	plagueyou_desc = "Warn if you got the Plague",

	plagueother_cmd = "plagueother",
	plagueother_name = "Plague on others alert",
	plagueother_desc = "Warn if others got the Plague",

	thunderclap_cmd = "thunderclap",
	thunderclap_name = "Thunderclap Alert",
	thunderclap_desc = "Warn for Thunderclap",

	explode_cmd = "explode",
	explode_name = "Explode Alert",
	explode_desc = "Warn for Explode",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	summon_cmd = "summon",
	summon_name = "Summon Alert",
	summon_desc = "Warn for add summons",

	explodetrigger = "Anubisath Defender gains Explode.",
	explodewarn = "Exploding!!",
	enragetrigger = "Anubisath Defender gains Enrage.",
	enragewarn = "Enraged!",
	summonguardtrigger = "Anubisath Defender casts Summon Anubisath Swarmguard.",
	summonguardwarn = "Swarmguard Summoned",
	summonwarriortrigger = "Anubisath Defender casts Summon Anubisath Warrior.",
	summonwarriorwarn = "Warrior Summoned",
	plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	plaguewarn = " has the Plague!",
	plagueyouwarn = "You got the plague!",
	plagueyou = "You",
	plagueare = "are",
	thunderclaptrigger = "^Anubisath Defender's Thunderclap hits ([^%s]+) for %d+%.",
	thunderclapwarn = "Thunderclap!",
} end )

L:RegisterTranslations("zhCN", function() return {
	explodetrigger = "阿努比萨斯防御者获得了爆炸的效果。",
	explodewarn = "即将爆炸！近战躲开！",
	enragetrigger = "阿努比萨斯防御者获得了狂怒的效果。",
	enragewarn = "进入狂怒状态！",
	summonguardtrigger = "阿努比萨斯防御者施放了召唤阿努比萨斯虫群卫士。",
	summonguardwarn = "虫群卫士已被召唤出来",
	summonwarriortrigger = "阿努比萨斯防御者施放了召唤阿努比萨斯战士。",
	summonwarriorwarn = "阿努比萨斯战士已被召唤出来",
	plaguetrigger = "^(.+)受(.+)了瘟疫效果的影响。$",
	plaguewarn = "受到瘟疫的影响！快躲开！",
	plagueyouwarn = "你受到瘟疫的影响！快跑开！",
	plagueyou = "你",
	plagueare = "到",
	thunderclaptrigger = "^阿努比萨斯防御者的雷霆一击击中(.+)造成%d+点伤害。",
	thunderclapwarn = "雷霆一击发动！",
} end )

L:RegisterTranslations("koKR", function() return {
	explodetrigger = "아누비사스 문지기|1이;가; 폭파 효과를 얻었습니다.",
	explodewarn = "폭파! 떨어지세요!",
	enragetrigger = "아누비사스 문지기|1이;가; 분노 효과를 얻었습니다.",
	enragewarn = "분노 돌입!",
	summonguardtrigger = "아누비사스 문지기|1이;가; 아누비사스 감시병 소환|1을;를; 시전합니다.",
	summonguardwarn = "감시병 소환",
	summonwarriortrigger = "아누비사스 문지기|1이;가; 아누비사스 전사 소환|1을;를; 시전합니다.",
	summonwarriorwarn = "전사 소환",

	plaguetrigger = "(.*)역병에 걸렸습니다.",
	plaguewarn = "님은 역병에 걸렸습니다. 피하세요",
	plagueyouwarn = "당신은 역병에 걸렸습니다! 떨어지세요!",

	plagueyou = "",
	plagueare = "are",
	whopattern = "(.+)|1이;가; ",

	thunderclaptrigger = "아누비사스 문지기|1이;가; 천둥벼락|1으로;로; (.+)에게 (%d+)의",
	thunderclapwarn = "천둥벼락! - 멀리 떨어지세요",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsDefenders = BigWigs:NewModule(boss)
BigWigsDefenders.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsDefenders.enabletrigger = boss
BigWigsDefenders.toggleoptions = {"plagueyou", "plagueother", "thunderclap", "explode", "enrage", "bosskill"}
BigWigsDefenders.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsDefenders:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsDefenders:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if self.db.profile.explode and msg == L"explodetrigger" then
		self:TriggerEvent("BigWigs_Message", L"explodewarn", "Red")
	elseif self.db.profile.enrage and msg == L"enragetrigger" then
		self:TriggerEvent("BigWigs_Message", L"enragewarn", "Red")
	end
end

function BigWigsDefenders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if self.db.profile.summon and msg == L"summonguardtrigger" then
		self:TriggerEvent("BigWigs_Message", L"summonguardwarn", "Yellow")
	elseif self.db.profile.summon and msg == L"summonwarriortrigger" then
		self:TriggerEvent("BigWigs_Message", L"summonwarriorwarn", "Yellow")
	end
end

if (GetLocale() == "koKR") then
	function BigWigsDefenders:checkPlague(msg)
		local _,_, Player = string.find(msg, L"plaguetrigger")
		if (Player) then
			if (Player == L"plagueyou") then
				if self.db.profile.plagueyou then self:TriggerEvent("BigWigs_Message", L"plagueyouwarn", "Red", true) end
			else
				local _,_, Who = string.find(Player, L"whopattern")
				if self.db.profile.plagueother then
					self:TriggerEvent("BigWigs_Message", Who .. L"plaguewarn", "Yellow")
					self:TriggerEvent("BigWigs_SendTell", Who, L"plagueyouwarn")
				end
			end
		end
	end
else
	function BigWigsDefenders:checkPlague(msg)
		local _,_, Player, Type = string.find(msg, L"plaguetrigger")
		if (Player and Type) then
			if (Player == L"plagueyou" and Type == L"plagueare") then
				if self.db.profile.plagueyou then self:TriggerEvent("BigWigs_Message", L"plagueyouwarn", "Red", true) end
			else
				if self.db.profile.plagueother then
					self:TriggerEvent("BigWigs_Message", Player .. L"plaguewarn", "Yellow")
					self:TriggerEvent("BigWigs_SendTell", Player, L"plagueyouwarn")
				end
			end
		end
	end
end

function BigWigsDefenders:Thunderclap(msg)
	if self.db.profile.thunderclap and string.find(msg, L"thunderclaptrigger") then
		self:TriggerEvent("BigWigs_Message", L"thunderclapwarn", "Yellow")
	end
end