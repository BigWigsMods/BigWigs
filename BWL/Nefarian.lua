------------------------------
--      Are you local?      --
------------------------------
local boss = AceLibrary("Babble-Boss-2.2")["Nefarian"]
local victor = AceLibrary("Babble-Boss-2.2")["Lord Victor Nefarius"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local warnpairs = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	landing_soon_trigger = "Well done, my minions",
	landing_trigger = "BURN! You wretches",
	zerg_trigger = "Impossible! Rise my",
	fear_trigger = "Nefarian begins to cast Bellowing Roar",
	shadowflame_trigger = "Nefarian begins to cast Shadow Flame",

	triggershamans	= "Shamans, show me",
	triggerdruid	= "Druids and your silly",
	triggerwarlock	= "Warlocks, you shouldn't be playing",
	triggerpriest	= "Priests! If you're going to keep",
	triggerhunter	= "Hunters and your annoying",
	triggerwarrior	= "Warriors, I know you can hit harder",
	triggerrogue	= "Rogues%? Stop hiding",
	triggerpaladin	= "Paladins",
	triggermage		= "Mages too%?",

	landing_soon_warning = "Nefarian landing in 10 seconds!",
	landing_warning = "Nefarian is landing!",
	zerg_warning = "Zerg incoming!",
	fear_warning = "Fear in 2 seconds!",
	fear_soon_warning = "Fear in ~5sec",
	shadowflame_warning = "Shadow Flame incoming!",
	classcall_warning = "Class call incoming!",

	warnshaman	= "Shamans - Totems spawned!",
	warndruid	= "Druids - Stuck in cat form!",
	warnwarlock	= "Warlocks - Incoming Infernals!",
	warnpriest	= "Priests - Heals hurt!",
	warnhunter	= "Hunters - Bows/Guns broken!",
	warnwarrior	= "Warriors - Stuck in berserking stance!",
	warnrogue	= "Rogues - Ported and rooted!",
	warnpaladin	= "Paladins - Blessing of Protection!",
	warnmage	= "Mages - Incoming polymorphs!",

	classcall_bar = "Class call",
	fear_bar = "Possible fear",

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
	landing_soon_trigger = "干得好，我的手下。",
	landing_trigger = "燃烧吧！你这个",
	zerg_trigger = "^不可能",
	fear_trigger = "奈法利安开始施放低沉咆哮。",
	shadowflame_trigger = "奈法利安开始施放暗影烈焰。",

	triggershamans	= "^萨满祭司",
	triggerdruid	= "^德鲁伊",
	triggerwarlock	= "^术士",
	triggerpriest	= "^牧师",
	triggerhunter	= "^猎人",
	triggerwarrior	= "^战士",
	triggerrogue	= "^盗贼",
	triggerpaladin	= "^圣骑士",
	triggermage		= "^你们也是法师",

	landing_soon_warning = "奈法利安将在10秒后降落！",
	landing_warning = "奈法利安已降落！",
	zerg_warning = "骨龙群出现！",
	fear_warning = "2秒后发动群体恐惧！",
	fear_soon_warning = "5秒后发动群体恐惧",
	shadowflame_warning = "暗影烈焰发动！",
	classcall_warning = "5秒后开始点名！",

	warnshaman	= "萨满祭司 - 图腾涌现！",
	warndruid	= "德鲁伊 - 强制猫形态，无法治疗和解诅咒！",
	warnwarlock	= "术士 - 地狱火出现，DPS职业尽快将其消灭！",
	warnpriest	= "牧师 - 停止治疗，静等25秒！",
	warnhunter	= "猎人 - 远程武器损坏！",
	warnwarrior	= "战士 - 强制狂暴姿态，加大对MT的治疗量！",
	warnrogue	= "盗贼 - 被传送和麻痹！",
	warnpaladin	= "圣骑士 - BOSS受到保护祝福，物理攻击无效！",
	warnmage	= "法师 - 变形术发动，注意解除！",

	classcall_bar = "职业点名",
	fear_bar = "可能恐惧",
	
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
	landing_soon_trigger = "적들의 사기가 떨어지고 있다",
	landing_trigger = "불타라! 활활!",
	zerg_trigger = "말도 안 돼! 일어나라!",
	fear_trigger = "네파리안|1이;가; 우레와같은 울부짖음|1을;를; 시전합니다.",
	shadowflame_trigger = "네파리안|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	triggershamans	= "주술사",
	triggerdruid	= "드루이드 녀석, 그 바보",
	triggerwarlock	= "흑마법사여, 네가 이해하지도 못하는",
	triggerpriest	= "사제야, 그렇게 치유를",
	triggerhunter	= "그 장난감",
	triggerwarrior	= "전사들이로군, 네가 그보다 더 강하게 내려 칠 수",
	triggerrogue	= "도적들인가?",
	triggerpaladin	= "성기사여",
	triggermage		= "네가 마법사냐?",

	landing_soon_warning = "네파리안이 10초 후 착지합니다!",
	landing_warning = "네파리안이 착지했습니다!",
	zerg_warning = "해골 등장!",
	fear_warning = "2초 후 공포!",
	fear_soon_warning = "약 5초내 공포!",
	shadowflame_warning = "암흑의 불길 주의!",
	classcall_warning = "곧 직업이 지목됩니다!",
	warnshaman	= "주술사 - 토템 파괴!",
	warndruid	= "드루이드 - 강제 표범 변신!",
	warnwarlock	= "흑마법사 - 지옥불정령 등장!",
	warnpriest	= "사제 - 치유 주문 금지!",
	warnhunter	= "사냥꾼 - 원거리 무기 파손!",
	warnwarrior	= "전사 - 광태 강제 전환!",
	warnrogue	= "도적 - 강제 소환!",
	warnpaladin	= "성기사 - 강제 보축 사용!",
	warnmage	= "마법사 - 변이!",

	classcall_bar = "직업 지목",
	fear_bar = "공포 가능",
	
	shadowflame_name = "암흑의 불길 경고",
	shadowflame_desc = "암흑의 불길에 대한 경고",
	
	fear_name = "공포 경고",
	fear_desc = "네파리안이 공포 시전시 경고",
	
	classcall_name = "직업 지목 경고",
	classcall_desc = "직업 지목에 대한 경고",
	
	otherwarn_name = "기타 경고",
	otherwarn_desc = "착지와 소환에 대한 경고",
} end)

L:RegisterTranslations("deDE", function() return {
	landing_soon_trigger = "Sehr gut, meine Diener",
	landing_trigger = "BRENNT! Ihr Elenden!",
	zerg_trigger = "Unm\195\182glich! Erhebt euch",
	fear_trigger = "Nefarian beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",
	shadowflame_trigger = "Nefarian beginnt Schattenflamme zu wirken.",
	triggershamans	= "Schamane, zeigt mir was",
	triggerdruid	= "Druiden und ihre l\195\164cherliche",
	triggerwarlock	= "Hexenmeister, Ihr solltet nicht mit Magie",
	triggerpriest	= "Priester! Wenn Ihr weiterhin",
	triggerhunter	= "J\195\164ger und ihre l\195\164stigen",
	triggerwarrior	= "Krieger, Ich bin mir sicher",
	triggerrogue	= "Schurken%? Kommt aus den Schatten",
	triggerpaladin	= "Paladine",
	triggermage		= "Auch Magier%? Ihr solltet vorsichtiger",

	landing_soon_warning = "Nefarian landet in 10 Sekunden!",
	landing_warning = "Nefarian ist gelandet!",
	zerg_warning = "Diener herbeigerufen!",
	fear_warning = "AoE Furcht in 2 Sekunden!",
	shadowflame_warning = "Schattenflamme in K\195\188rze!",
	classcall_warning = "Klassenruf in K\195\188rze!",
	warnshaman	= "Schamanen - Totems!",
	warndruid	= "Druiden - Gefangen in Katzenform!",
	warnwarlock	= "Hexenmeister - H\195\182llenbestien herbeigerufen!",
	warnpriest	= "Priester - Heilung schadet!",
	warnhunter	= "J\195\164ger - Angelegte Fernkampfwaffen defekt!",
	warnwarrior	= "Krieger - Gefangen in Berserkerhaltung!",
	warnrogue	= "Schurken - Teleportiert und festgewurzelt!",
	warnpaladin	= "Paladine - Segen des Schutzes!",
	warnmage	= "Magier - Verwandlung!",

	classcall_bar = "Klassenruf",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Nefarian Schattenflamme wirkt.",
	
	fear_name = "Furcht",
	fear_desc = "Warnung, wenn Nefarian AoE Furcht wirkt.",
	
	classcall_name = "Klassenruf",
	classcall_desc = "Warnung vor Klassenrufen.",
	
	otherwarn_name = "Anderes",
	otherwarn_desc = "Warnung, wenn Nefarian landet und seine Diener ruft.",
} end)

L:RegisterTranslations("frFR", function() return {
	landing_soon_trigger = "Beau travail",
	landing_trigger = "BR\195\155LEZ, mis\195\169rables",
	zerg_trigger = "C'est impossible ! Relevez%-vous, serviteurs !",
	fear_trigger = "Nefarian commence \195\160 lancer Rugissement puissant",
	shadowflame_trigger = "Nefarian commence \195\160 lancer Flamme d'ombre.",
	triggershamans	= "Chamans, montrez moi",
	triggerdruid	= "Les druides et leur stupides",
	triggerwarlock	= "D\195\169monistes, vous ne devriez pas jouer",
	triggerpriest	= "Pr\195\170tres ! Si vous continuez",
	triggerhunter	= "Ah, les chasseurs et les stupides",
	triggerwarrior	= "Guerriers, je sais que vous pouvez frapper plus fort",
	triggerrogue	= "Voleurs, arr\195\170tez de vous cacher",
	triggerpaladin	= "Les paladins",
	triggermage		= "Les mages aussi",
	
	landing_soon_warning = "Nefarian att\195\169rit dans 10 sec!",
	landing_warning = "Nefarian att\195\169rit!",
	zerg_warning = "Zerg imminent!",
	fear_warning = "Fear dans 2 sec!",
	shadowflame_warning = "Flamme d'ombre imminente!",
	classcall_warning = "Appel de classe imminent! STOP Grosheal  ranger arc/fusil",
	warnshaman	= "CHAMANS - Apparition des totems!",
	warndruid	= "DRUIDES - En forme f\195\169line!",
	warnwarlock	= "DEMONISTES - Arriv\195\169e des Infernaux!",
	warnpriest	= "PRETRES - Arr\195\170tez de soigner!",
	warnhunter	= "CHASSEURS - Arcs/Fusils cass\195\169s!",
	warnwarrior	= "GUERRIERS - En position berseker!",
	warnrogue	= "VOLEURS - T\195\169l\195\169port\195\169s et root\195\169s!",
	warnpaladin	= "PALADINS - B\195\169n\195\169diction de protection!",
	warnmage	= "MAGES - Arriv\195\169e des m\195\169tamorphoses!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNefarian = BigWigs:NewModule(boss)
BigWigsNefarian.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
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
		[L["landing_soon_trigger"]] = {L["landing_soon_warning"]},
		[L["landing_trigger"]] = {L["landing_warning"]},
		[L["zerg_trigger"]] = {L["zerg_warning"]},
	} end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsNefarian:CHAT_MSG_MONSTER_YELL(msg)
	for i,v in pairs(warnpairs) do
		if string.find(msg, i) then
			if v[2] then
				if self.db.profile.classcall then
					self:TriggerEvent("BigWigs_Message", v[1], "Important")
					self:ScheduleEvent("BigWigs_Message", 27, L["classcall_warning"], "Important")
					self:TriggerEvent("BigWigs_StartBar", self, L["classcall_bar"], 30, "Interface\\Icons\\Spell_Shadow_Charm")
				end
			else
				if self.db.profile.otherwarn then self:TriggerEvent("BigWigs_Message", v[1], "Important") end
			end
			return
		end
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "NefarianFear")
	elseif string.find(msg, L["shadowflame_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "NefarianShadowflame")
	end
end

function BigWigsNefarian:BigWigs_RecvSync( sync )
	if sync == "NefarianShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Important")
	elseif sync == "NefarianFear" and self.db.profile.fear then
		self:TriggerEvent("BigWigs_Message", L["fear_warning"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["fear_soon_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["fear_bar"], 32, "Interface\\Icons\\Spell_Shadow_PsychicScream")
	end
end

