------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Instructor Razuvious"]
local understudy = BB["Deathknight Understudy"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razuvious",

	startwarn = "Instructor Razuvious engaged! ~25sec to shout!",
	starttrigger1 = "The time for practice is over! Show me what you have learned!",
	starttrigger2 = "Sweep the leg... Do you have a problem with that?",
	starttrigger3 = "Show them no mercy!",
	starttrigger4 = "Do as I taught you!",

	shout = "Disrupting Shout",
	shout_desc = "Warn for Disrupting Shout.",
	shoutwarn = "Disrupting Shout in ~5sec!",
	shoutbar = "Next shout",
	
	knife = "Jagged Knife",
	knife_desc = "Warn who has Jagged Knife.",
	knife_message = "%s: Jagged Knife",

	taunt = "Taunt",
	taunt_desc = "Warn for taunt.",
	taunt_message = "%s - taunt",
	
	shieldwall = "Shield Wall",
	shieldwall_desc = "Warn for shieldwall.",
	shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Instruktor Razuvious angegriffen! Unterbrechungsruf in ~25 Sekunden!",
	starttrigger1 = "Die Zeit des \195\156bens ist vorbei! Zeigt mir, was ihr gelernt habt!",
	starttrigger2 = "Streckt sie nieder... oder habt ihr ein Problem damit?",
	starttrigger3 = "Lasst keine Gnade walten!",
	starttrigger4 = "Befolgt meine Befehle!",

	shout = "Unterbrechungsruf",
	shout_desc = "Warnung, wenn Instruktor Razuvious Unterbrechungsruf wirkt.",
	--shoutwarn = "Disrupting Shout in ~5sec!",
	--shoutbar = "Next shout",
	
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",
	
	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",

	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn = "훈련교관 라주비어스 전투 시작! 약 16초 이내 외침!",
	starttrigger1 = "훈련은 끝났다! 배운 걸 보여줘라!",
	starttrigger2 = "다리를 후려 차라! 무슨 문제 있나?",
	starttrigger3 = "절대 봐주지 마라!",
	starttrigger4 = "훈련받은 대로 해!",

	shout = "분열의 외침",
	shout_desc = "분열의 외침을 알립니다.",
	shoutwarn = "약 5초 후 분열의 외침!",
	shoutbar = "다음 분열의 외침",
	
	knife = "뾰족한 나이프",
	knife_desc = "뾰족한 나이프에 걸린 플레이어를 알립니다.",
	knife_message = "뾰족한 나이프: %s",

	taunt = "도발",
	taunt_desc = "도발에 대하여 알립니다.",
	taunt_message = "%s - 도발",
	
	shieldwall = "방패의 벽",
	shieldwall_desc = "방패의 벽에 대하여 알립니다",
	shieldwall_message = "%s - 방패의 벽",
} end )

L:RegisterTranslations("zhCN", function() return {
	startwarn = "教官拉苏维奥斯已激活 - 约25秒后瓦解怒吼！",
	starttrigger1 = "练习时间到此为止！都拿出真本事来！",
	starttrigger2 = "绊腿……有什么问题么？",
	starttrigger3 = "仁慈无用！",
	starttrigger4 = "按我教导的去做！",

	shout = "瓦解怒吼",
	shout_desc = "当施放瓦解怒吼时发出警报。",
	--shoutwarn = "Disrupting Shout in ~5sec!",
	--shoutbar = "Next shout",
	
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",

	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",
	
	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("zhTW", function() return {
	startwarn = "講師拉祖維斯已進入戰鬥 - 25 秒後混亂怒吼",
	starttrigger1 = "練習時間到此為止！都拿出真本事來！",
	starttrigger2 = "絆腿……有什麼問題嗎？",
	starttrigger3 = "仁慈無用！",
	starttrigger4 = "照我教你的做！",

	shout = "怒吼警報",
	shout_desc = "混亂怒吼警報",
	--shoutwarn = "Disrupting Shout in ~5sec!",
	--shoutbar = "Next shout",
	
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",
	
	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",

	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("frFR", function() return {
	startwarn = "Instructor Razuvious engagé ! ~25 sec. avant le Cri !",
	starttrigger1 = "Les cours sont terminés ! Montrez-moi ce que vous avez appris !",
	starttrigger2 = "Frappe-le à la jambe",
	starttrigger3 = "Pas de quartier !",
	starttrigger4 = "Faites ce que vous ai appris !",

	shout = "Cri",
	shout_desc = "Préviens de l'arrivée des Cris perturbant.",
	--shoutwarn = "Disrupting Shout in ~5sec!",
	--shoutbar = "Next shout",
	
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",
	
	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",

	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("ruRU", function() return {
	startwarn = "Инструктор Разувиус разъярён! ~25 секунд до крика!",
	starttrigger1 = "Время тренировки закончено! Покажите чему вы научились!",  --correct this
	starttrigger2 = "Так вы притащили с собой нубо мага... теперь вам точно не сдобровать.",  --correct this
	starttrigger3 = "Я вам покажу кузькину мать!!",  --correct this
	starttrigger4 = "Вы правда смешны для меня!",  --correct this

	shout = "Разрушительный крик",
	shout_desc = "сообщать о разрушительном крике.",
	--shoutwarn = "Disrupting Shout in ~5sec!",
	--shoutbar = "Next shout",
	
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",

	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",
	
	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {boss, understudy}
mod.guid = 16061
mod.toggleoptions = {"shout", "knife", -1, "shieldwall", "taunt", "bosskill",}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shout", 29107, 55543)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Knife", 55550)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shout(_, spellID, _, _, spellName)
	if self.db.profile.shout then
		self:IfMessage(spellName, "Attention", spellID)
		self:Bar(L["shoutbar"], 16, spellID)
		self:DelayedMessage(11, L["shoutwarn"], "Attention")
	end
end

function mod:ShieldWall(unit, spellID)
	if unit == understudy and self.db.profile.shieldwall then
		self:Message(L["shieldwall_message"]:format(unit), "Positive", nil, nil, nil, spellID)
		self:Bar(L["shieldwall_message"]:format(unit), 20, spellID)
	end
end

function mod:Taunt(unit, spellID)
	if unit == understudy and self.db.profile.taunt then
		self:Message(L["taunt_message"]:format(unit), "Positive", nil, nil, nil, spellID)
		self:Bar(L["taunt_message"]:format(unit), 20, spellID)
	end
end

function mod:Knife(unit, spellID)
	if self.db.profile.knife then
		self:Message(L["knife_message"]:format(unit), "Important", nil, nil, nil, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"]) then
		self:IfMessage(L["startwarn"], "Attention")
		if self.db.profile.shout then
			self:Bar(L["shoutbar"], 16, spellID)
			self:DelayedMessage(11, L["shoutwarn"], "Attention")
		end
	end
end
