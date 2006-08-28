------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Nefarian")
local victor = AceLibrary("Babble-Boss-2.0")("Lord Victor Nefarius")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local warnpairs

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "Well done, my minions",
	trigger2 = "BURN! You wretches",
	trigger3 = "Impossible! Rise my",
	trigger4 = "Nefarian begins to cast Bellowing Roar",
	trigger5 = "Nefarian begins to cast Shadow Flame",
	triggershamans	= "Shamans, show me",
	triggerdruid	= "Druids and your silly",
	triggerwarlock	= "Warlocks, you shouldn't be playing",
	triggerpriest	= "Priests! If you're going to keep",
	triggerhunter	= "Hunters and your annoying",
	triggerwarrior	= "Warriors, I know you can hit harder",
	triggerrogue	= "Rogues%? Stop hiding",
	triggerpaladin	= "Paladins",
	triggermage		= "Mages too%?",

	warn1 = "Nefarian landing in 10 seconds!",
	warn2 = "Nefarian is landing!",
	warn3 = "Zerg incoming!",
	warn4 = "Fear in 2 seconds!",
	warn5 = "Shadow Flame incoming!",
	warn6 = "Class call incoming!",
	warnshaman	= "Shamans - Totems spawned!",
	warndruid	= "Druids - Stuck in cat form!",
	warnwarlock	= "Warlocks - Incoming Infernals!",
	warnpriest	= "Priests - Stop Healing!",
	warnhunter	= "Hunters - Bows/Guns broken!",
	warnwarrior	= "Warriors - Stuck in berserking stance!",
	warnrogue	= "Rogues - Ported and rooted!",
	warnpaladin	= "Paladins - Blessing of Protection!",
	warnmage	= "Mages - Incoming polymorphs!",
	bosskill = "Nefarian has been defeated!",

	bar1text = "Class call",

	cmd = "Nefarian",
	
	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",
	
	fear_cmd = "fear",
	fear_name = "Warn for Fear",
	fear_desc = "Warn when Nefarian casts AoE Fear",
	
	classcall_cmd = "classcall",
	classcall_name = "Class Call alert",
	classcall_desc = "Warn for Class Calls",
	
	otherwarn_cmd = "otherwarn",
	otherwarn_name = "Other alerts",
	otherwarn_desc = "Landing and Zerg warnings",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "干得好，我的手下。",
	trigger2 = "燃烧吧！你这个",
	trigger3 = "^不可能",
	trigger4 = "奈法利安开始施放低沉咆哮。",
	trigger5 = "奈法利安开始施放暗影烈焰。",
	triggershamans	= "^萨满",
	triggerdruid	= "^德鲁伊",
	triggerwarlock	= "^术士",
	triggerpriest	= "^牧师",
	triggerhunter	= "^猎人",
	triggerwarrior	= "^战士们，我知道你",
	triggerrogue	= "^盗贼",
	triggerpaladin	= "^圣骑士",
	triggermage		= "^你们也是法师",

	warn1 = "奈法利安将在10秒后降落！",
	warn2 = "奈法利安已降落！",
	warn3 = "骨龙群出现！",
	warn4 = "2秒后发动群体恐惧！",
	warn5 = "暗影烈焰发动！",
	warn6 = "5秒后开始点名！",
	warnshaman	= "萨满祭司 - 图腾涌现！",
	warndruid	= "德鲁伊 - 强制猫形态，无法治疗和解诅咒！",
	warnwarlock	= "术士 - 地狱火出现，DPS职业尽快将其消灭！",
	warnpriest	= "牧师 - 停止治疗，静等25秒！",
	warnhunter	= "猎人 - 远程武器损坏！",
	warnwarrior	= "战士 - 强制狂暴姿态，加大对MT的治疗量！",
	warnrogue	= "盗贼 - 被传送和麻痹！",
	warnpaladin	= "圣骑士 - BOSS受到保护祝福，物理攻击无效！",
	warnmage	= "法师 - 变形术发动，注意解除！",
	bosskill = "奈法利安被击败了！",

	bar1text = "职业点名",
	
	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",
	
	fear_name = "恐惧警报",
	fear_desc = "恐惧警报",
	
	classcall_name = "职业点名警报",
	classcall_desc = "职业点名警报",
	
	otherwarn_name = "其他警报",
	otherwarn_desc = "降落与杂兵出现时发出警报",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "적들의 사기가 떨어지고 있다",
	trigger2 = "불타라! 활활!",
	trigger3 = "말도 안 돼! 일어나라!",
	trigger4 = "네파리안|1이;가; 우레와같은 울부짖음|1을;를; 시전합니다.",
	trigger5 = "네파리안|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	triggershamans	= "주술사",
	triggerdruid	= "드루이드 녀석, 그 바보",
	triggerwarlock	= "흑마법사여, 네가 이해하지도 못하는",
	triggerpriest	= "사제야, 그렇게 치유를",
	triggerhunter	= "그 장난감",
	triggerwarrior	= "전사들이로군, 네가 그보다 더 강하게 내려 칠 수",
	triggerrogue	= "도적들인가?",
	triggerpaladin	= "성기사여",
	triggermage		= "네가 마법사냐?",

	warn1 = "네파리안이 10초 후 착지합니다!",
	warn2 = "네파리안이 착지했습니다!",
	warn3 = "해골 등장!",
	warn4 = "2초 후 공포!",
	warn5 = "암흑의 불길 주의!",
	warn6 = "곧 직업이 지목됩니다!",
	warnshaman	= "주술사 - 토템 파괴!",
	warndruid	= "드루이드 - 강제 표범 변신!",
	warnwarlock	= "흑마법사 - 지옥불정령 등장!",
	warnpriest	= "사제 - 치유 주문 금지!",
	warnhunter	= "사냥꾼 - 원거리 무기 파손!",
	warnwarrior	= "전사 - 광태 강제 전환!",
	warnrogue	= "도적 - 강제 소환!",
	warnpaladin	= "성기사 - 강제 보축 사용!",
	warnmage	= "마법사 - 변이!",
	bosskill = "네파리안을 물리쳤습니다!",

	bar1text = "직업 지목",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Sehr gut, meine Diener",
	trigger2 = "BRENNT! Ihr Elenden!",
	trigger3 = "Unm\195\182glich! Erhebt euch",
	trigger4 = "Nefarian beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",
	trigger5 = "Nefarian beginnt Schattenflamme zu wirken.",
	triggershamans	= "Schamane, zeigt mir was",
	triggerdruid	= "Druiden und ihre l\195\164cherliche",
	triggerwarlock	= "Hexenmeister, Ihr solltet nicht mit Magie",
	triggerpriest	= "Priester! Wenn Ihr weiterhin",
	triggerhunter	= "J\195\164ger und ihre l\195\164stigen",
	triggerwarrior	= "Krieger, Ich bin mir sicher",
	triggerrogue	= "Schurken%? Kommt aus den Schatten",
	triggerpaladin	= "Paladine",
	triggermage		= "Auch Magier%? Ihr solltet vorsichtiger",

	warn1 = "Nefarian landet in 10 Sekunden!",
	warn2 = "Nefarian landet!",
	warn3 = "Diener herbeigerufen!",
	warn4 = "AoE Furcht in 2 Sekunden!",
	warn5 = "Schattenflamme in K\195\188rze!",
	warn6 = "Klassenruf in K\195\188rze!",
	warnshaman	= "Schamanen - Totems schnell entfernen!",
	warndruid	= "Druiden - Gefangen in Katzenform!",
	warnwarlock	= "Hexenmeister - H\195\182llenbestien!",
	warnpriest	= "Priester - Heilung stoppen!",
	warnhunter	= "J\195\164ger - Angelegte Fernkampfwaffen defekt!",
	warnwarrior	= "Krieger - Gefangen in Berserkerhaltung!",
	warnrogue	= "Schurken - Teleportiert und festgewurzelt!",
	warnpaladin	= "Paladine - Segen des Schutzes!",
	warnmage	= "Magier - Verwandlung!",
	bosskill = "Nefarian wurde besiegt!",

	bar1text = "Klassenruf",

	cmd = "Nefarian",
	
	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Nefarian Schattenflamme wirkt.",
	
	fear_cmd = "fear",
	fear_name = "Furcht",
	fear_desc = "Warnung, wenn Nefarian AoE Furcht wirkt.",
	
	classcall_cmd = "classcall",
	classcall_name = "Klassenruf",
	classcall_desc = "Warnung vor Klassenrufen.",
	
	otherwarn_cmd = "otherwarn",
	otherwarn_name = "Anderes",
	otherwarn_desc = "Warnung, wenn Nefarian landet und seine Diener ruft.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "Beau travail",
	trigger2 = "BR\195\155LEZ, mis\195\169rables",
	trigger3 = "C'est impossible ! Relevez%-vous, serviteurs !",
	trigger4 = "Nefarian commence \195\160 lancer Rugissement puissant",
	trigger5 = "Nefarian commence \195\160 lancer Flamme d'ombre.",
	triggershamans	= "Chamans, montrez moi",
	triggerdruid	= "Les druides et leur stupides",
	triggerwarlock	= "D\195\169monistes, vous ne devriez pas jouer",
	triggerpriest	= "Pr\195\170tres ! Si vous continuez",
	triggerhunter	= "Ah, les chasseurs et les stupides",
	triggerwarrior	= "Guerriers, je sais que vous pouvez frapper plus fort",
	triggerrogue	= "Voleurs, arr\195\170tez de vous cacher",
	triggerpaladin	= "Les paladins",
	triggermage		= "Les mages aussi",
	
	warn1 = "Nefarian att\195\169rit dans 10 sec!",
	warn2 = "Nefarian att\195\169rit!",
	warn3 = "Zerg imminent!",
	warn4 = "Fear dans 2 sec!",
	warn5 = "Flamme d'ombre imminente!",
	warn6 = "Appel de classe imminent! STOP Grosheal  ranger arc/fusil",
	warnshaman	= "CHAMANS - Apparition des totems!",
	warndruid	= "DRUIDES - En forme f\195\169line!",
	warnwarlock	= "DEMONISTES - Arriv\195\169e des Infernaux!",
	warnpriest	= "PRETRES - Arr\195\170tez de soigner!",
	warnhunter	= "CHASSEURS - Arcs/Fusils cass\195\169s!",
	warnwarrior	= "GUERRIERS - En position berseker!",
	warnrogue	= "VOLEURS - T\195\169l\195\169port\195\169s et root\195\169s!",
	warnpaladin	= "PALADINS - B\195\169n\195\169diction de protection!",
	warnmage	= "MAGES - Arriv\195\169e des m\195\169tamorphoses!",
	bosskill = "Nefarian a ete vaincu!",

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNefarian = BigWigs:NewModule(boss)
BigWigsNefarian.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsNefarian.enabletrigger = { boss, victor }
BigWigsNefarian.toggleoptions = {"shadowflame", "fear", "classcall", "otherwarn", "bosskill"}
BigWigsNefarian.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNefarian:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianShadowflame", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianFear", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsNefarian:CHAT_MSG_MONSTER_YELL(msg)
	if not warnpairs then warnpairs = {
		[L["triggershamans"]] = {L["warnshaman"], true},
		[L["triggerdruid"]] = {L["warndruid"], true},
		[L["triggerwarlock"]] = {L["warnwarlock"], true},
		[L["triggerpriest"]] = {L["warnpriest"], true},
		[L["triggerhunter"]] = {L["warnhunter"], true},
		[L["triggerwarrior"]] = {L["warnwarrior"], true},
		[L["triggerrogue"]] = {L["warnrogue"], true},
		[L["triggerpaladin"]] = {L["warnpaladin"], true},
		[L["triggermage"]] = {L["warnmage"], true},
		[L["trigger1"]] = {L["warn1"]},
		[L["trigger2"]] = {L["warn2"]},
		[L["trigger3"]] = {L["warn3"]},
	} end

	for i,v in pairs(warnpairs) do
		if string.find(msg, i) then
			if v[2] then
				if self.db.profile.classcall then self:TriggerEvent("BigWigs_Message", v[1], "Red") end
				self:ClassCallBar()
			else
				if self.db.profile.otherwarn then self:TriggerEvent("BigWigs_Message", v[1], "Red") end
			end
			return
		end
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L["trigger4"])) then
		self:TriggerEvent("BigWigs_SendSync", "NefarianFear") 
	elseif (string.find(msg, L["trigger5"])) then
		self:TriggerEvent("BigWigs_SendSync", "NefarianShadowflame")
	end
end

function BigWigsNefarian:BigWigs_RecvSync( sync )
	if sync == "NefarianShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["warn5"], "Red")
	elseif sync == "NefarianFear" and self.db.profile.fear then
		self:TriggerEvent("BigWigs_Message", L["warn4"], "Red")
	end
end

function BigWigsNefarian:ClassCallBar()
	self:ScheduleEvent("BigWigs_Message", 27, L["warn6"], "Red")
	self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 30, "Interface\\Icons\\Spell_Shadow_Charm", "Yellow", "Orange", "Red")
end
