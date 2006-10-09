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

	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on the last plagued person (requires promoted or higher)",

	explodetrigger = "Anubisath Defender gains Explode.",
	explodewarn = "Exploding!",
	enragetrigger = "Anubisath Defender gains Enrage.",
	enragewarn = "Enraged!",
	summonguardtrigger = "Anubisath Defender casts Summon Anubisath Swarmguard.",
	summonguardwarn = "Swarmguard Summoned",
	summonwarriortrigger = "Anubisath Defender casts Summon Anubisath Warrior.",
	summonwarriorwarn = "Warrior Summoned",
	plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	plaguewarn = " has the Plague!",
	plagueyouwarn = "You have the plague!",
	plagueyou = "You",
	plagueare = "are",
	thunderclaptrigger = "^Anubisath Defender's Thunderclap hits ([^%s]+) for %d+%.",
	thunderclapwarn = "Thunderclap!",
} end )

L:RegisterTranslations("deDE", function() return {
	plagueyou_name = "Du hast die Seuche",
	plagueyou_desc = "Warnung, wenn Du die Seuche hast.",

	plagueother_name = "X hat die Seuche",
	plagueother_desc = "Warnung, wenn andere Spieler die Seuche haben.",

	thunderclap_name = "Donnerknall",
	thunderclap_desc = "Warnung vor Donnerknall.",

	explode_name = "Explosion",
	explode_desc = "Warnung vor Explosion.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung vor Wutanfall.",

	summon_name = "Beschw\195\182rung",
	summon_desc = "Warnung, wenn Verteidiger des Anubisath Schwarmwachen oder Krieger beschw\195\182rt.",

	explodetrigger = "Verteidiger des Anubisath bekommt 'Explodieren'.",
	explodewarn = "Explosion!",
	enragetrigger = "Verteidiger des Anubisath bekommt 'Wutanfall'.",
	enragewarn = "Wutanfall!",
	summonguardtrigger = "Verteidiger des Anubisath wirkt Schwarmwache des Anubisath beschw\195\182ren.",
	summonguardwarn = "Schwarmwache beschworen",
	summonwarriortrigger = "Verteidiger des Anubisath wirkt Krieger des Anubisath beschw\195\182ren.",
	summonwarriorwarn = "Krieger beschworen",
	plaguetrigger = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
	plaguewarn = " hat die Seuche!",
	plagueyouwarn = "Du hast die Seuche!",
	plagueyou = "Ihr",
	plagueare = "seid",
	thunderclaptrigger = "^Verteidiger des Anubisath's Donnerknall trifft ([^%s]+) f\195\188r %d+%.",
	thunderclapwarn = "Donnerknall!",
} end )

L:RegisterTranslations("zhCN", function() return {
	plagueyou_name = "玩家瘟疫警报",
	plagueyou_desc = "你中了瘟疫时发出警报",

	plagueother_name = "队友瘟疫警报",
	plagueother_desc = "队友中了瘟疫时发出警报",

	thunderclap_name = "雷霆一击警报",
	thunderclap_desc = "阿努比萨斯防御者发动雷霆一击时发出警报",

	explode_name = "爆炸警报",
	explode_desc = "阿努比萨斯防御者即将爆炸时发出警报",

	enrage_name = "狂怒警报",
	enrage_desc = "阿努比萨斯防御者进入狂怒状态时发出警报",

	summon_name = "召唤警报",
	summon_desc = "阿努比萨斯防御者召唤增援时发出警报",
	
	icon_name = "标记瘟疫",
	icon_desc = "团队标记中瘟疫的玩家 (需要助理或更高权限)",
	
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
	plagueyou_name = "자신의 역병 경고",
	plagueyou_desc = "자신의 역병에 대한 경고",

	plagueother_name = "타인의 역병 경고",
	plagueother_desc = "타인의 역병에 대한 경고",

	thunderclap_name = "천둥벼락 경고",
	thunderclap_desc = "천둥벼락에 대한 경고",

	explode_name = "폭발 경고",
	explode_desc = "폭발에 대한 경고",

	enrage_name = "분노 경고",
	enrage_desc = "분노에 대한 경고",

	summon_name = "소환 경고",
	summon_desc = "추가 소환에 대한 경고",

	icon_name = "아이콘 지정",
	icon_desc = "마지막 역병에 걸린 사람에게 공격대 아이콘 지정(승급자 이상 필요)",

	explodetrigger = "아누비사스 문지기|1이;가; 폭파 효과를 얻었습니다.",
	explodewarn = "폭파! 떨어지세요!",
	enragetrigger = "아누비사스 문지기|1이;가; 분노 효과를 얻었습니다.",
	enragewarn = "분노 돌입!",
	summonguardtrigger = "아누비사스 문지기|1이;가; 아누비사스 감시병 소환|1을;를; 시전합니다.",
	summonguardwarn = "감시병 소환",
	summonwarriortrigger = "아누비사스 문지기|1이;가; 아누비사스 전사 소환|1을;를; 시전합니다.",
	summonwarriorwarn = "전사 소환",
	plaguetrigger = "^([^|;%s]*)(.*)역병에 걸렸습니다%.$", -- "(.*) 역병에 걸렸습니다.",
	plaguewarn = "님은 역병에 걸렸습니다. 피하세요",
	plagueyouwarn = "당신은 역병에 걸렸습니다! 떨어지세요!",
	plagueyou = "", -- "you"
	plagueare = "", -- "are"
	thunderclaptrigger = "아누비사스 문지기|1이;가; 천둥벼락|1으로;로; (.+)에게 (%d+)의",
	thunderclapwarn = "천둥벼락! - 멀리 떨어지세요",
} end )

L:RegisterTranslations("frFR", function() return {
	explodetrigger = "D\195\169fenseur Anubisath gagne Exploser.",
	enragetrigger = "D\195\169fenseur Anubisath gagne Enrager.",
	summonguardtrigger = "D\195\169fenseur Anubisath lance Invocation d'un Garde-essaim Anubisath.",
	summonwarriortrigger = "D\195\169fenseur Anubisath lance Invocation d'un Guerrier Anubisath.",
	plaguetrigger = "^([^%s]+) ([^%s]+) les effets de Peste%.$",
	plagueyou = "Vous",
	plagueare = "subissez",
	thunderclaptrigger = "^D\195\169fenseur Anubisath lance Coup de tonnerre",--not sure
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsDefenders = BigWigs:NewModule(boss)
BigWigsDefenders.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsDefenders.enabletrigger = boss
BigWigsDefenders.toggleoptions = { "plagueyou", "plagueother", "icon", -1, "thunderclap", "explode", "enrage", "bosskill"}
BigWigsDefenders.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsDefenders:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "DefenderEnrage", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "DefenderExplode", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsDefenders:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsDefenders:BigWigs_RecvSync(sync, rest, nick)
	if sync == "DefenderExplode" and self.db.profile.explode then
		self:TriggerEvent("BigWigs_Message", L["explodewarn"], "Important")
	elseif sync == "DefenderEnrage" and self.db.profile.enrage then
		self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important")
	end
end

function BigWigsDefenders:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["explodetrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "DefenderExplode")
	elseif msg == L["enragetrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "DefenderEnrage")
	end
end

function BigWigsDefenders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if not self.db.profile.summon then return end
	if msg == L["summonguardtrigger"] then
		self:TriggerEvent("BigWigs_Message", L["summonguardwarn"], "Attention")
	elseif msg == L["summonwarriortrigger"] then
		self:TriggerEvent("BigWigs_Message", L["summonwarriorwarn"], "Attention")
	end
end

function BigWigsDefenders:CheckPlague(msg)
	local _,_, pplayer, ptype = string.find(msg, L["plaguetrigger"])
	if pplayer then
		if self.db.profile.plagueyou and pplayer == L["plagueyou"] then
			self:TriggerEvent("BigWigs_Message", L["plagueyouwarn"], "Personal", true)
			self:TriggerEvent("BigWigs_Message", UnitName("player") .. L["plaguewarn"], "Attention", nil, nil, true)
		elseif self.db.profile.plagueother then
			self:TriggerEvent("BigWigs_Message", pplayer .. L["plaguewarn"], "Attention")
			self:TriggerEvent("BigWigs_SendTell", pplayer, L["plagueyouwarn"])
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", pplayer)
		end
	end
end

function BigWigsDefenders:Thunderclap(msg)
	if self.db.profile.thunderclap and string.find(msg, L["thunderclaptrigger"]) then
		self:TriggerEvent("BigWigs_Message", L["thunderclapwarn"], "Attention")
	end
end

