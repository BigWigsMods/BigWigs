BigWigsNefarian = AceAddon:new({
	name          = "BigWigsNefarian",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = GetLocale() == "koKR" and 
		{"군주 빅터 네파리우스", "네파리안"} or 
		{"Lord Victor Nefarius", "Nefarian"}, 

	loc = GetLocale() == "deDE" and 
	{ 
		bossname = "Nefarian",
		disabletrigger = "Nefarian stirbt.",

		trigger1 = "Sehr gut, meine Diener.",
		trigger2 = "BRENNT! Ihr Elenden!",
		trigger3 = "Unm\195\182glich!",
		trigger4 = "Nefarian beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",
		trigger5 = "Nefarian beginnt Schattenflamme zu wirken.",
		triggershamans	= "Schamane, zeigt mir was",
		triggerdruid	= "Druiden und ihre l\195\164cherliche",
		triggerwarlock	= "Hexenmeister, Ihr solltet nicht mit Magie",
		triggerpriest	= "Priester! Wenn Ihr weiterhin so heilt,",
		triggerhunter	= "J\195\164ger und ihre l\195\164stigen",
		triggerwarrior	= "Krieger, Ich bin mir sicher",
		triggerrogue	= "Schurken%? Kommt aus den Schatten",
		triggerpaladin	= "Paladine",
		triggermage		= "Auch Magier%? Ihr solltet vorsichtiger",

		warn1 = "Nefarian landet in 10 Sekunden!",
		warn2 = "Nefarian landet!",
		warn3 = "Zerg kommt!",
		warn4 = "Furcht in 2 Sekunden!",
		warn5 = "Schattenflamme kommt!",
		warn6 = "Klassenruf kommt!",
		warnshaman	= "Schamanen - Totems sind gesetzt!",
		warndruid	= "Druiden - Gefangen in Katzenform!",
		warnwarlock	= "Hexenmeister - H\195\182llenbestien kommen!",
		warnpriest	= "Priester - Stoppt Heilung!",
		warnhunter	= "J\195\164ger - B\195\182gen/Schusswaffen defekt!",
		warnwarrior	= "Krieger - Gefangen in Berserkerhaltung!",
		warnrogue	= "Schurken - Teleportiert und festgewurzelt!",
		warnpaladin	= "Paladine - Blessing of Protection!",
		warnmage	= "Magier - Verwandlung kommt!",
		bosskill = "Nefarian wurde besiegt!",

		bar1text = "Klassenruf",
	} 
		or GetLocale() == "koKR" and 
	{	
		bossname = "네파리안",
		disabletrigger = "네파리안|1이;가; 죽었습니다.",

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
	} 
		or 
	{	
		bossname = "Nefarian",
		disabletrigger = "Nefarian dies.",

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
	},
})

--[[

BigWigsNefarian = AceAddon:new({
	name          = "BigWigsNefarian",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = {"Lord Victor Nefarius", "Nefarian"},

	loc = {
		bossname = "Nefarian",
		disabletrigger = "Nefarian dies.",

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
	},
})
]]

function BigWigsNefarian:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsNefarian:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsNefarian:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
end

function BigWigsNefarian:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsNefarian:CHAT_MSG_MONSTER_YELL()
	if not self.warnpairs then self.warnpairs = {
		[self.loc.triggershamans] = {self.loc.warnshaman, true},
		[self.loc.triggerdruid] = {self.loc.warndruid, true},
		[self.loc.triggerwarlock] = {self.loc.warnwarlock, true},
		[self.loc.triggerpriest] = {self.loc.warnpriest, true},
		[self.loc.triggerhunter] = {self.loc.warnhunter, true},
		[self.loc.triggerwarrior] = {self.loc.warnwarrior, true},
		[self.loc.triggerrogue] = {self.loc.warnrogue, true},
		[self.loc.triggerpaladin] = {self.loc.warnpaladin, true},
		[self.loc.triggermage] = {self.loc.warnmage, true},
		[self.loc.trigger1] = {self.loc.warn1},
		[self.loc.trigger2] = {self.loc.warn2},
		[self.loc.trigger3] = {self.loc.warn3},
	} end

	for i,v in pairs(self.warnpairs) do
		if string.find(arg1, i) then
			self:TriggerEvent("BIGWIGS_MESSAGE", v[1], "Red")
			if v[2] then self:ClassCallBar()end
			return
		end
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger4)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	elseif (string.find(arg1, self.loc.trigger5)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red")
	end
end

function BigWigsNefarian:ClassCallBar()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 27, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_Charm")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsNefarian:RegisterForLoad()