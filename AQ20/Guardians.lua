------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Anubisath Guardian")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "guardian",
	
	summon_cmd = "summon",
	summon_name = "Summon Alert",
	summon_desc = "Warn for summoned adds",
	
	plagueyou_cmd = "plagueyou",
	plagueyou_name = "Plague on you alert",
	plagueyou_desc = "Warn for plague on you",

	plagueother_cmd = "plagueother",
	plagueother_name = "Plague on others alert",
	plagueother_desc = "Warn for plague on others",
	
	explode_cmd = "explode",
	explode_name = "Explode Alert",
	explode_desc = "Warn for incoming explosion",
	
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for enrage",

	explodetrigger = "Anubisath Guardian gains Explode.",
	explodewarn = "Exploding!",
	enragetrigger = "Anubisath Guardian gains Enrage.",
	enragewarn = "Enraged!",
	summonguardtrigger = "Anubisath Guardian casts Summon Anubisath Swarmguard.",
	summonguardwarn = "Swarmguard Summoned",
	summonwarriortrigger = "Anubisath Guardian casts Summon Anubisath Warrior.",
	summonwarriorwarn = "Warrior Summoned",
	plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	plaguewarn = " has the Plague!",
	plaguewarnyou = "You got the Plague!",
	plagueyou = "You",
	plagueare = "are",	
} end )

L:RegisterTranslations("deDE", function() return {
	explodetrigger = "Besch\195\188tzer des Anubisath bekommt 'Explodieren'.",
	explodewarn = "Explodiert!",
	enragetrigger = "Besch\195\188tzer des Anubisath bekommt 'Wutanfall'.",
	enragewarn = "Enraged!",
	summonguardtrigger = "Besch\195\188tzer des Anubisath wirkt Schwarmwache des Anubisath beschw\195\182ren.",
	summonguardwarn = "Schwarmwache beschworen",
	summonwarriortrigger = "Besch\195\188tzer des Anubisath wirkt Krieger des Anubisath beschw\195\182ren.",
	summonwarriorwarn = "Krieger beschworen",
	plaguetrigger = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
	plaguewarn = " hat die Seuche!",
	plaguewarnyou = "Du hast die Seuche!",
	plagueyou = "Du",
	plagueare = "bist",
} end )

L:RegisterTranslations("zhCN", function() return {
	summon_name = "召唤警报",
	summon_desc = "阿努比萨斯守卫者召唤援兵时发出警报",
	
	plagueyou_name = "玩家瘟疫警报",
	plagueyou_desc = "你中了瘟疫时发出警报",

	plagueother_name = "队友瘟疫警报",
	plagueother_desc = "队友中了瘟疫时发出警报",
	
	explode_name = "爆炸警报",
	explode_desc = "阿努比萨斯守卫者即将爆炸时发出警报",
	
	enrage_name = "狂怒警报",
	enrage_desc = "阿努比萨斯守卫者进入狂怒状态时发出警报",
	
	explodetrigger = "阿努比萨斯守卫者获得了爆炸的效果。",
	explodewarn = "即将爆炸！近战躲开！",
	enragetrigger = "阿努比萨斯守卫者获得了狂怒的效果。",
	enragewarn = "进入狂怒状态！",
	summonguardtrigger = "阿努比萨斯守卫者施放了召唤阿努比萨斯虫群卫士。",
	summonguardwarn = "虫群卫士已被召唤出来",
	summonwarriortrigger = "阿努比萨斯守卫者施放了召唤阿努比萨斯战士。",
	summonwarriorwarn = "阿努比萨斯战士已被召唤出来",
	plaguetrigger = "^(.+)受(.+)了瘟疫效果的影响。$",
	plaguewarn = "受到瘟疫的影响！快躲开！",
	plaguewarnyou = "你受到瘟疫的影响！快跑开！",
	plagueyou = "你",
	plagueare = "到",
} end )

L:RegisterTranslations("koKR", function() return {
	explodetrigger = "아누비사스 감시자|1이;가; 폭파 효과를 얻었습니다.",
	explodewarn = "폭파! 피하세요!",
	enragetrigger = "아누비사스 감시자|1이;가; 분노 효과를 얻었습니다.",
	enragewarn = "분노!",
	summonguardtrigger = "아누비사스 감시자|1이;가; 아누비사스 감시병 소환|1을;를; 시전합니다.",
	summonguardwarn = "감시병 소환",
	summonwarriortrigger = "아누비사스 감시자|1이;가; 아누비사스 전사 소환|1을;를; 시전합니다.",
	summonwarriorwarn = "전사 소환",
	plaguetrigger = "(.*)역병에 걸렸습니다.",
	plaguewarn = "님이 역병에 걸렸습니다. 피하세요!",
	plagueyou = "",
	whopattern = "(.+)|1이;가; "
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGuardians = BigWigs:NewModule(boss)
BigWigsGuardians.zonename = AceLibrary("Babble-Zone-2.0")("Ruins of Ahn'Qiraj")
BigWigsGuardians.enabletrigger = boss
BigWigsGuardians.toggleoptions = {"summon", "plagueyou", "plagueother", "explode", "enrage", "bosskill"}
BigWigsGuardians.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGuardians:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkPlague")
end

function BigWigsGuardians:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.explode and msg == L"explodetrigger" then 
		self:TriggerEvent("BigWigs_Message", L"explodewarn", "Red")
	elseif self.db.profile.enrage and msg == L"enragetrigger" then 
		self:TriggerEvent("BigWigs_Message", L"enragewarn", "Red")
	end
end

function BigWigsGuardians:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.summon and msg == L"summonguardtrigger" then 
		self:TriggerEvent("BigWigs_Message", L"summonguardwarn", "Yellow")
	elseif self.db.profile.summon and msg == L"summonwarriortrigger" then 
		self:TriggerEvent("BigWigs_Message", L"summonwarriorwarn", "Yellow")
	end
end

if ( GetLocale() == "koKR" ) then
	function BigWigsGuardians:checkPlague( msg )
		local _,_,player = string.find(msg, L"plaguetrigger")
		if player then
			if player == L"plagueyou" then
				if self.db.profile.plagueyou then self:TriggerEvent("BigWigs_Message", L"plaguewarnyou", "Red", true) end
			else
				_, _, player = string.find(player, L"whopattern")
				if self.db.profile.plagueother then
					self:TriggerEvent("BigWigs_Message", player .. L"plaguewarn", "Yellow")
					self:TriggerEvent("BigWigs_SendTell", player, L"plaguewarnyou")
				end
			end
		end
	end
else
	function BigWigsGuardians:checkPlague( msg )
		local _,_,player, type = string.find(msg, L"plaguetrigger")
		if (player and type) then
			if (player == L"plagueyou" and type == L"plagueare") then
				if self.db.profile.plagueyou then self:TriggerEvent("BigWigs_Message", L"plaguewarnyou", "Red", true) end
			elseif self.db.profile.plagueother then
				self:TriggerEvent("BigWigs_Message", player .. L"plaguewarn", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", player, L"plaguewarnyou")
			end
		end
	end
end
