------------------------------
--      Are you local?      --
------------------------------

local thane = BB["Thane Korth'azz"]
local mograine = BB["Highlord Mograine"]
local zeliek = BB["Sir Zeliek"]
local blaumeux = BB["Lady Blaumeux"]
local boss = BB["The Four Horsemen"]

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local deaths = 0
local started = nil
local marks = 1

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Horsemen",

	mark = "Mark",
	mark_desc = "Warn for marks.",
	markbar = "Mark %d",
	markwarn1 = "Mark %d!",
	markwarn2 = "Mark %d in 5 sec",

	shieldwall = "Shieldwall",
	shieldwall_desc = "Warn for shieldwall.",
	shieldwallbar = "%s - Shield Wall!",
	shieldwallwarn = "%s - Shield Wall for 20 sec",
	shieldwallwarn2 = "%s - Shield Wall GONE!",

	void = "Void Zone",
	void_desc = "Warn when Lady Blaumeux casts a Void Zone.",
	voidwarn = "Void Zone Incoming",
	voidbar = "Next Void Zone",

	meteor = "Meteor",
	meteor_desc = "Warn when Thane casts a Meteor.",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrath = "Holy Wrath",
	wrath_desc = "Warn when Zeliek casts Holy Wrath.",
	wrathwarn = "Holy Wrath!",
	wrathbar = "Holy Wrath",

	startwarn = "The Four Horsemen Engaged! Mark in ~17 sec",
} end )

L:RegisterTranslations("ruRU", function() return {
	mark = "Знак Бломе",
	mark_desc = "Предупреждать о знаке Бломе.",
	markbar = "Знак %d",
	markwarn1 = "Знак %d!",
	markwarn2 = "Знак %d через 5 секунд",

	shieldwall = "Глухая оборона",
	shieldwall_desc = "Предупреждать о глухой обороне.",
	shieldwallbar = "%s - Глухая оборона!",
	shieldwallwarn = "%s - Глухая оборона через 20 секунд",
	shieldwallwarn2 = "%s - Глухая оборона спадает!",

	void = "Портал Бездны",
	void_desc = "предупреждать когда Леди Бломе создаёт портал Бездны.",
	voidwarn = "Портал Бездны появляется",
	voidbar = "Следующий портал Бездны",

	meteor = "Метеор",
	meteor_desc = "Сообщать когда Тан Кортазз кастует метеор.",
	meteorwarn = "Метеор!",
	meteorbar = "Метеор",

	wrath = "Гнев небес",
	wrath_desc = "Сообщать когда Сэр Зелиек кастует гнев небес.",
	wrathwarn = "Гнев небес!",
	wrathbar = "Гнев небес",

	startwarn = "Четверо всадников вступили в бой! Знак Бломе на ~17 секунд",
} end )

L:RegisterTranslations("koKR", function() return {
	mark = "징표",
	mark_desc = "징표를 알립니다.",
	markbar = "징표 (%d)",
	markwarn1 = "징표(%d)!",
	markwarn2 = "5초 후 징표(%d)",

	shieldwall = "방패의 벽",
	shieldwall_desc = "방패의벽을 알립니다.",
	shieldwallbar = "%s - 방패의 벽",
	shieldwallwarn = "%s - 20초간 방패의 벽",
	shieldwallwarn2 = "%s - 방패의 벽 사라짐!",

	void = "공허의 지대",
	void_desc = "여군주 블라미우스의 공허의 지대 시전을 알립니다.",
	voidwarn = "공허의 지대 생성!",
	voidbar = "다음 공허의 지대",

	meteor = "유성",
	meteor_desc = "영주 코스아즈의 유성 시전을 알립니다.",
	meteorwarn = "유성!",
	meteorbar = "유성",

	wrath = "성스러운 격노",
	wrath_desc = "젤리에크 경의 신성한 격노 시전을 알립니다.",
	wrathwarn = "신의 격노!",
	wrathbar = "신의 격노",

	startwarn = "4인의 기병대 전투 시작! 약 17초 이내 징표",
} end )

L:RegisterTranslations("deDE", function() return {
	mark = "Mal Alarm",
	mark_desc = "Warnt vor den Mal Debuffs",
	markbar = "Mal",
	markwarn1 = "Mal (%d)!",
	markwarn2 = "Mal (%d) - 5 Sekunden",

	shieldwall = "Schildwall",
	shieldwall_desc = "Warnung vor Schildwall.",
	shieldwallbar = "%s - Schildwall",
	shieldwallwarn = "%s - Schildwall f\195\188r 20 Sekunden",
	shieldwallwarn2 = "%s - Schildwall Vorbei!",

	void = "Zone der Leere Warnung",
	void_desc = "Warnt, wenn Lady Blaumeux Zone der Leere zaubert.",
	voidwarn = "Zone der Leere kommt",
	voidbar = "Zone der Leere",

	meteor = "Meteor Alarm",
	meteor_desc = "Warnt, wenn Thane Meteor zaubert.",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrath = "Heiliger Zorn Alarm",
	wrath_desc = "Warnt, wenn Sire Zeliek Heiliger Zorn zaubert.",
	wrathwarn = "Heiliger Zorn!",
	wrathbar = "Heiliger Zorn",

	startwarn = "Die Vier Reiter angegriffen! Mal in ~17 Sekunden",
} end )

L:RegisterTranslations("zhCN", function() return {
	mark = "印记",
	mark_desc = "当施放印记时发出警报。",
	markbar = "<标记:%d>",
	markwarn1 = "印记 %d！",
	markwarn2 = "5秒后，印记 %d！",

	shieldwall = "盾墙",
	shieldwall_desc = "当施放盾墙时发出警报。",
	shieldwallbar = "<盾墙：%s>",
	shieldwallwarn = ">%s< - 20秒盾墙效果！",
	shieldwallwarn2 = "<盾墙消失：%s>",

	void = "虚空领域",
	void_desc = "当施放虚空领域时发出警报。",
	voidwarn = "5秒后，虚空领域！",
	voidbar = "<虚空领域>",

	meteor = "流星",
	meteor_desc = "当施放流星时发出警报。",
	meteorwarn = "流星！",
	meteorbar = "<流星>",

	wrath = "神圣之怒",
	wrath_desc = "当施放神圣之怒时发出警报。",
	wrathwarn = "神圣之怒！",
	wrathbar = "<神圣之怒>",

	startwarn = "四骑士已激活 - 约17秒后印记！",
} end )

L:RegisterTranslations("zhTW", function() return {
	mark = "標記警報",
	mark_desc = "標記警報",
	markbar = "印記 %d",
	markwarn1 = "印記(%d)！",
	markwarn2 = "印記(%d) - 5秒",

	shieldwall = "盾牆警報",
	shieldwall_desc = "盾牆警報",
	shieldwallbar = "%s - 盾牆",
	shieldwallwarn = "%s - 20秒盾牆效果",
	shieldwallwarn2 = "%s - 盾牆消失了！",

	void = "虛空地區警報",
	void_desc = "當布洛莫斯爵士施放虛空地區時警報",
	voidwarn = "5秒後虛空地區",
	voidbar = "虛空地區",

	meteor = "隕石術警報",
	meteor_desc = "寇斯艾茲族長的隕石術警報",
	meteorwarn = "隕石術",
	meteorbar = "隕石術",

	wrath = "神聖憤怒警報",
	wrath_desc = "札里克爵士的神聖憤怒警報",
	wrathwarn = "神聖憤怒",
	wrathbar = "神聖憤怒",

	startwarn = "四騎士已進入戰鬥 - 17秒後印記",
} end )

L:RegisterTranslations("frFR", function() return {
	mark = "Marques",
	mark_desc = "Préviens de l'arrivée des marques.",
	markbar = "Marque %d",
	markwarn1 = "Marque %d !",
	markwarn2 = "Marque %d dans 5 sec.",

	shieldwall = "Mur protecteur",
	shieldwall_desc = "Préviens et affiche la durée des Murs protecteur.",
	shieldwallbar = "%s - Mur protecteur !",
	shieldwallwarn = "%s - Mur protecteur pendant 20 sec.",
	shieldwallwarn2 = "%s - Mur protecteur TERMINÉ !",

	void = "Zone de vide",
	void_desc = "Préviens quand Dame Blaumeux incante une Zone de vide.",
	voidwarn = "Zone de vide imminent",
	voidbar = "Zone de vide",

	meteor = "Météore",
	meteor_desc = "Préviens quand Thane incante un météore.",
	meteorwarn = "Météore !",
	meteorbar = "Météore",

	wrath = "Colère divine",
	wrath_desc = "Préviens quand Zeliek incante sa Colère divine.",
	wrathwarn = "Colère divine !",
	wrathbar = "Colère divine",

	startwarn = "Les 4 cavaliers engagés ! Marque dans ~17 sec.",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {thane, mograine, zeliek, blaumeux, boss}
mod.guid = 16065
mod.toggleoptions = {"mark", "shieldwall", -1, "meteor", "void", "wrath", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "VoidZone", 28863, 57463)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Meteor", 28884, 57467)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Wrath", 28883, 57466)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark", 28832, 28833, 28834, 28835) --Mark of Korth'azz, Mark of Blaumeux, Mark of Mograine, Mark of Zeliek
	self:AddCombatListener("UNIT_DIED", "Deaths")

	marks = 1
	deaths = 0
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:VoidZone(_, spellID)
	if self.db.profile.void then
		self:IfMessage(L["voidwarn"], "Important", spellID)
		self:Bar(L["voidbar"], 12, spellID)
	end
end

function mod:Meteor(_, spellID)
	if self.db.profile.meteor then
		self:IfMessage(L["meteorwarn"], "Important", spellID)
		self:Bar(L["meteorbar"], 12, spellID)
	end
end

function mod:Wrath(_, spellID)
	if self.db.profile.wrath then
		self:IfMessage(L["wrathwarn"], "Important", spellID)
		self:Bar(L["wrathbar"], 12, spellID)
	end
end

function mod:ShieldWall(_, spellID, unit)
	if self.db.profile.shieldwall then
		if UnitIsUnit(unit, thane) or UnitIsUnit(unit, mograine) or UnitIsUnit(unit, zeliek) or UnitIsUnit(unit, blaumeux) then
			self:IfMessage(L["shieldwallwarn"]:format(unit), "Attention", spellID)
			self:DelayedMessage(20, L["shieldwallwarn2"]:format(unit), "Positive")
			self:Bar(L["shieldwallbar"]:format(unit), 20, spellID)
		end
	end
end

local last = 0
function mod:Mark()
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if self.db.profile.mark then
			self:IfMessage(L["markwarn1"]:format(marks), "Important", 28835)
			marks = marks + 1
			self:Bar(L["markbar"]:format(marks), 12, 28835)
			self:DelayedMessage(7, L["markwarn2"]:format(marks), "Urgent")
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest)
	if self:ValidateEngageSync(sync, rest) and not started then
		marks = 1
		deaths = 0
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.mark then
			self:Message(L["startwarn"], "Attention")
			self:Bar(L["markbar"]:format(marks), 17, 28835)
			self:DelayedMessage(12, L["markwarn2"]:format(marks), "Urgent")
		end
	end
end

function mod:Deaths(_, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid or guid == 16062 or guid == 16063 or guid == 16064 then
		deaths = deaths + 1
	end
	if deaths == 4 then
		self:BossDeath(nil, self.guid, true)
	end
end

