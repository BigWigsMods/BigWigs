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
mod.toggleOptions = {"mark", -1, 28884, 28863, 28883, "bosskill"}
mod.consoleCmd = "Horsemen"

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
	mark = "Mark",
	mark_desc = "Warn for marks.",
	markbar = "Mark %d",
	markwarn1 = "Mark %d!",
	markwarn2 = "Mark %d in 5 sec",

	dies = "#%d Killed",

	startwarn = "The Four Horsemen Engaged! Mark in ~17 sec",
} end )

L:RegisterTranslations("ruRU", function() return {
	mark = "Знак",
	mark_desc = "Предупреждать о знаках.",
	markbar = "Знак %d",
	markwarn1 = "Знак %d!",
	markwarn2 = "Знак %d через 5 секунд",

	dies = "#%d убит",

	startwarn = "Четверо всадников вступили в бой! Знак через ~17 секунд",
} end )

L:RegisterTranslations("koKR", function() return {
	mark = "징표",
	mark_desc = "징표를 알립니다.",
	markbar = "징표 (%d)",
	markwarn1 = "징표(%d)!",
	markwarn2 = "5초 후 징표(%d)",

	dies = "기사 #%d 처치",

	startwarn = "4인의 기병대 전투 시작! 약 17초 이내 징표",
} end )

L:RegisterTranslations("deDE", function() return {
	mark = "Male",
	mark_desc = "Warnungen und Timer für die Male.",
	markbar = "Mal (%d)",
	markwarn1 = "Mal (%d)!",
	markwarn2 = "Mal (%d) in 5 sek!",

	dies = "#%d getötet",

	startwarn = "Die Vier Reiter angegriffen! Male in ~17 sek.",
} end )

L:RegisterTranslations("zhCN", function() return {
	mark = "印记",
	mark_desc = "当施放印记时发出警报。",
	markbar = "<标记：%d>",
	markwarn1 = "印记%d！",
	markwarn2 = "5秒后，印记%d！",

	dies = "#%d死亡！",

	startwarn = "四骑士已激活 - 约17秒后，印记！",
} end )

L:RegisterTranslations("zhTW", function() return {
	mark = "印記",
	mark_desc = "當施放印記時發出警報。",
	markbar = "<印記：%d>",
	markwarn1 = "印記%d！",
	markwarn2 = "5秒後，印記%d！",

	dies = "#%d死亡！",

	startwarn = "四騎士已進入戰鬥 - 約17秒後，印記！",
} end )

L:RegisterTranslations("frFR", function() return {
	mark = "Marque",
	mark_desc = "Prévient de l'arrivée des marques.",
	markbar = "Marque %d",
	markwarn1 = "Marque %d !",
	markwarn2 = "Marque %d dans 5 sec.",

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

function mod:VoidZone(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 12, spellId)
end

function mod:Meteor(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 12, spellId)
end

function mod:Wrath(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 12, spellId)
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

