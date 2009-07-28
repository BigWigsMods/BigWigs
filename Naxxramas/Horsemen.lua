----------------------------------
--      Module Declaration      --
----------------------------------

local thane = BB["Thane Korth'azz"]
local rivendare = BB["Baron Rivendare"]
local zeliek = BB["Sir Zeliek"]
local blaumeux = BB["Lady Blaumeux"]
local boss = BB["The Four Horsemen"]

local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {thane, rivendare, zeliek, blaumeux, boss}
mod.guid = 16065
mod.toggleoptions = {"mark", -1, "meteor", "void", "wrath", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local deaths = 0
local started = nil
local marks = 1

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Horsemen",

	mark = "Mark",
	mark_desc = "Warn for marks.",
	markbar = "Mark %d",
	markwarn1 = "Mark %d!",
	markwarn2 = "Mark %d in 5 sec",

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

	dies = "#%d Killed",

	startwarn = "The Four Horsemen Engaged! Mark in ~17 sec",
} end )

L:RegisterTranslations("ruRU", function() return {
	mark = "Знак",
	mark_desc = "Предупреждать о знаках.",
	markbar = "Знак %d",
	markwarn1 = "Знак %d!",
	markwarn2 = "Знак %d через 5 секунд",

	void = "Портал Бездны",
	void_desc = "Предупреждать когда Леди Бломе создаёт портал Бездны.",
	voidwarn = "Появление портал Бездны!",
	voidbar = "Следующий портал",

	meteor = "Метеор",
	meteor_desc = "Сообщать когда Тан Кортазз применяет метеор.",
	meteorwarn = "Метеор!",
	meteorbar = "Метеор",

	wrath = "Гнев небес",
	wrath_desc = "Сообщать когда Сэр Зелиек применяет гнев небес.",
	wrathwarn = "Гнев небес!",
	wrathbar = "Гнев небес",

	dies = "#%d убит",

	startwarn = "Четверо всадников вступили в бой! Знак через ~17 секунд",
} end )

L:RegisterTranslations("koKR", function() return {
	mark = "징표",
	mark_desc = "징표를 알립니다.",
	markbar = "징표 (%d)",
	markwarn1 = "징표(%d)!",
	markwarn2 = "5초 후 징표(%d)",

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

	dies = "기사 #%d 처치",

	startwarn = "4인의 기병대 전투 시작! 약 17초 이내 징표",
} end )

L:RegisterTranslations("deDE", function() return {
	mark = "Male",
	mark_desc = "Warnungen und Timer für die Male.",
	markbar = "Mal (%d)",
	markwarn1 = "Mal (%d)!",
	markwarn2 = "Mal (%d) in 5 sek!",

	void = "Zone der Leere",
	void_desc = "Warnungen und Timer für Zone der Leere von Lady Blaumeux.",
	voidwarn = "Zone der Leere!",
	voidbar = "Zone der Leere",

	meteor = "Meteor",
	meteor_desc = "Warnungen und Timer für Meteor von Than Korth'azz.",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrath = "Heiliger Zorn",
	wrath_desc = "Warnungen und Timer für Heiliger Zorn von Sir Zeliek.",
	wrathwarn = "Heiliger Zorn!",
	wrathbar = "Heiliger Zorn",

	dies = "#%d getötet",

	startwarn = "Die Vier Reiter angegriffen! Male in ~17 sek.",
} end )

L:RegisterTranslations("zhCN", function() return {
	mark = "印记",
	mark_desc = "当施放印记时发出警报。",
	markbar = "<标记：%d>",
	markwarn1 = "印记%d！",
	markwarn2 = "5秒后，印记%d！",

	void = "虚空领域",
	void_desc = "当女公爵布劳缪克丝施放虚空领域时发出警报。",
	voidwarn = "5秒后，虚空领域！",
	voidbar = "<虚空领域>",

	meteor = "流星",
	meteor_desc = "当库尔塔兹领主施放流星时发出警报。",
	meteorwarn = "流星！",
	meteorbar = "<流星>",

	wrath = "神圣愤怒",
	wrath_desc = "当瑟里耶克爵士施放神圣愤怒时发出警报。",
	wrathwarn = "神圣愤怒！",
	wrathbar = "<神圣愤怒>",

	dies = "#%d死亡！",

	startwarn = "四骑士已激活 - 约17秒后，印记！",
} end )

L:RegisterTranslations("zhTW", function() return {
	mark = "印記",
	mark_desc = "當施放印記時發出警報。",
	markbar = "<印記：%d>",
	markwarn1 = "印記%d！",
	markwarn2 = "5秒後，印記%d！",

	void = "虛無區域",
	void_desc = "當布洛莫斯女士施放虛無區域時警報。",
	voidwarn = "5秒後，虛無區域！",
	voidbar = "<虛無區域>",

	meteor = "隕石術",
	meteor_desc = "當寇斯艾茲族長施放隕石術時發出警報。",
	meteorwarn = "隕石術！",
	meteorbar = "<隕石術>",

	wrath = "神聖憤怒",
	wrath_desc = "當札里克爵士施放神聖憤怒時發出警報。",
	wrathwarn = "神聖憤怒",
	wrathbar = "神聖憤怒",

	dies = "#%d死亡！",

	startwarn = "四騎士已進入戰鬥 - 約17秒後，印記！",
} end )

L:RegisterTranslations("frFR", function() return {
	mark = "Marque",
	mark_desc = "Prévient de l'arrivée des marques.",
	markbar = "Marque %d",
	markwarn1 = "Marque %d !",
	markwarn2 = "Marque %d dans 5 sec.",

	void = "Zone de vide",
	void_desc = "Prévient quand Dame Blaumeux incante une Zone de vide.",
	voidwarn = "Arrivée d'une Zone de vide",
	voidbar = "Prochaine Zone de vide",

	meteor = "Météore",
	meteor_desc = "Prévient quand le Thane Korth'azz incante un Météore.",
	meteorwarn = "Météore !",
	meteorbar = "Recharge Météore",

	wrath = "Colère divine",
	wrath_desc = "Prévient quand Sire Zeliek incante une Colère divine.",
	wrathwarn = "Colère divine !",
	wrathbar = "Recharge Colère divine",

	dies = "#%d éliminé(e)",

	startwarn = "Les 4 cavaliers engagés ! Marque dans ~17 sec. !",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "VoidZone", 28863, 57463)
	self:AddCombatListener("SPELL_CAST_START", "Meteor", 28884, 57467)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Wrath", 28883, 57466)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark", 28832, 28833, 28834, 28835) --Mark of Korth'azz, Mark of Blaumeux, Mark of Rivendare, Mark of Zeliek
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
	if guid == self.guid or guid == 30549 or guid == 16063 or guid == 16064 then
		deaths = deaths + 1
		if deaths < 4 then
			self:IfMessage(L["dies"]:format(deaths), "Positive")
		end
	end
	if deaths == 4 then
		self:BossDeath(nil, self.guid, true)
	end
end

