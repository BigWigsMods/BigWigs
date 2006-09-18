------------------------------
--      Are you local?      --
------------------------------

local thane = AceLibrary("Babble-Boss-2.0")("Thane Korth'azz")
local mograine = AceLibrary("Babble-Boss-2.0")("Highlord Mograine")
local zeliek = AceLibrary("Babble-Boss-2.0")("Sir Zeliek")
local blaumeux = AceLibrary("Babble-Boss-2.0")("Lady Blaumeux")
local boss = AceLibrary("Babble-Boss-2.0")("The Four Horsemen")

local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local times = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Horsemen",

	mark_cmd = "mark",
	mark_name = "Mark Alerts",
	mark_desc = "Warn for marks",

	shieldwall_cmd  = "shieldwall",
	shieldwall_name = "Shieldwall Alerts",
	shieldwall_desc = "Warn for shieldwall",

	void_cmd = "void",
	void_name = "Void Zone Alerts",
	void_desc = "Warn on Lady Blaumeux casting Void Zone.",

	meteor_cmd = "meteor",
	meteor_name = "Meteor Alerts",
	meteor_desc = "Warn on Thane casting Meteor.",

	wrath_cmd = "wrath",
	wrath_name = "Holy Wrath Alerts",
	wrath_desc = "Warn on Zeliek casting Wrath.",

	markbar = "Mark",
	markwarn1 = "Mark (%d)!",
	markwarn2 = "Mark (%d) - 5 sec",
	marktrigger = "is afflicted by Mark of ",

	voidtrigger = "Lady Blaumeux casts Void Zone.",
	voidwarn = "Void Zone Incoming",
	voidbar = "Void Zone",

	meteortrigger = "Thane Korth'azz's Meteor hits ",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrathtrigger = "Sir Zeliek's Holy Wrath hits ",
	wrathwarn = "Holy Wrath!",
	wrathbar = "Holy Wrath",

	startwarn = "The Four Horsemen Engaged! Mark in ~17 sec",

	shieldwallbar = "%s - Shield Wall",
	shieldwalltrigger = "(.*) gains Shield Wall.",
	shieldwallwarn = "%s - Shield Wall for 20 sec",
	shieldwallwarn2 = "%s - Shield Wall GONE!",
} end )

L:RegisterTranslations("koKR", function() return {

	mark_name = "징표 경고",
	mark_desc = "징표에 대한 경고",

	shieldwall_name = "방패의벽 경고",
	shieldwall_desc = "방패의벽에 대한 경고",
	
	void_name = "공허의 구역 경고",
	void_desc = "여군주 블라미우스 공허의 구역 시전 경고.",

	meteor_name = "운석 경고",
	meteor_desc = "영주 코스아즈 운석 시전 경고.",

	wrath_name = "성스러운 격노 경고",
	wrath_desc = "젤리에크 경 신성한 격노 시전 경고",

	markbar = "징표",
	markwarn1 = "(%d) 징표!",
	markwarn2 = "(%d) 징표 - 5 초",
	--marktrigger = "is afflicted by Mark of (Korth'azz|Blaumeux|Mograine|Zeliek)",
	marktrigger = "|1이;가; 징표에 걸렸습니다.",
	
	voidtrigger = "여군주 블라미우스|1이;가; 공허의 구역|1을;를; 시전합니다.",
	voidwarn = "공허의 구역 생성",
	voidbar = "공허의 구역",

	meteortrigger = "영주 코스아즈|1이;가; 운석|1으로;로; ",
	meteorwarn = "운석!",
	meteorbar = "운석",

	wrathtrigger = "젤리에크 경|1이;가; 성스러운 격노|1으로;로; ",
	wrathwarn = "성스러운 격노!",
	wrathbar = "성스러운 격노",

	startwarn = "4인의 기병대 전투 시작! 약 17 초내에 징표",

	shieldwallbar = "%s - 방패의 벽",
	shieldwalltrigger = "(.*)|1이;가; 방패의 벽 효과를 얻었습니다.",
	shieldwallwarn = "%s - 20초간 방배의 벽",
	shieldwallwarn2 = "%s - 방패의 벽 사라짐!",
} end )

L:RegisterTranslations("deDE", function() return {
	mark_name = "Mark Alerts", -- ?
	mark_desc = "Warn for marks", -- ?

	shieldwall_name = "Schildwall",
	shieldwall_desc = "Warnung vor Schildwall.",

	markbar = "Mark", -- ?
	markwarn1 = "Mark (%d)!", -- ?
	markwarn2 = "Mark (%d) - 5 Sekunden", -- ?

	startwarn = "The Four Horsemen angegriffen! Mark in 30 Sekunden", -- ?

	shieldwallbar = "%s - Schildwall",
	shieldwalltrigger = " bekommt 'Schildwall'.",
	shieldwallwarn = "%s - Schildwall f\195\188r 20 Sekunden",
	shieldwallwarn2 = "%s - Schildwall Vorbei!",
} end )

L:RegisterTranslations("zhCN", function() return {
	mark_name = "标记警报",
	mark_desc = "标记警报",

	shieldwall_name = "盾墙警报",
	shieldwall_desc = "盾墙警报",

	markbar = "标记",
	markwarn1 = "标记(%d)！",
	markwarn2 = "标记(%d) - 5秒",

	startwarn = "四骑士已激活 - 30秒后标记",

	shieldwallbar = "%s - 盾墙",
	shieldwalltrigger = "获得了盾墙",
	shieldwallwarn = "%s - 20秒盾墙效果",
	shieldwallwarn2 = "%s - 盾墙消失了！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHorsemen = BigWigs:NewModule(boss)
BigWigsHorsemen.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsHorsemen.enabletrigger = { thane, mograine, zeliek, blaumeux }
BigWigsHorsemen.toggleoptions = {"mark", "shieldwall", "meteor", "void", "wrath", "bosskill"}
BigWigsHorsemen.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHorsemen:OnEnable()
	self.marks = 1
	self.deaths = 0

	times = {}

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MarkEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenShieldWall", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMark", 8)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenVoid", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenWrath", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMeteor", 5)
end

function BigWigsHorsemen:MarkEvent( msg )
	if string.find(msg, L["marktrigger"]) then
		local t = GetTime()
		if not times["mark"] or (times["mark"] and (times["mark"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenMark")
			times["mark"] = t
		end
	end
end

function BigWigsHorsemen:SkillEvent( msg )
	local t = GetTime()
	if string.find(msg, L["meteortrigger"]) then
		if not times["meteor"] or (times["meteor"] and (times["meteor"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenMeteor")
			times["meteor"] = t
		end
	elseif string.find(msg, L["wrathtrigger"]) then
		if not times["wrath"] or (times["wrath"] and (times["wrath"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenWrath")
			times["wrath"] = t
		end
	elseif msg == L["voidtrigger"] then
		if not times["void"] or (times["void"] and (times["void"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenVoid" )
			times["void"] = t
		end
	end
end

function BigWigsHorsemen:BigWigs_RecvSync(sync, rest)
	if sync == "BossEngaged" and rest and rest == boss then
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L["markbar"], 17, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 12, string.format( L["markwarn2"], self.marks ), "Orange")
		end
	elseif sync == "HorsemenMark" then
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", string.format( L["markwarn1"], self.marks ), "Red")
		end
		self.marks = self.marks + 1
		if self.db.profile.mark then 
			self:TriggerEvent("BigWigs_StartBar", self, L["markbar"], 12, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", "Orange", "Red")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 7, string.format( L["markwarn2"], self.marks ), "Orange")
		end
	elseif sync == "HorsemenMeteor" then
		if self.db.profile.meteor then
			self:TriggerEvent("BigWigs_Message", L["meteorwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["meteorbar"], 12, "Interface\\Icons\\Spell_Fire_Fireball02", "Orange", "Red")
		end
	elseif sync == "HorsemenWrath" then
		if self.db.profile.meteor then
			self:TriggerEvent("BigWigs_Message", L["wrathwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["wrathbar"], 12, "Interface\\Icons\\Spell_Holy_Excorcism", "Orange", "Red")
		end
	elseif sync == "HorsemenVoid" then
		if self.db.profile.void then
			self:TriggerEvent("BigWigs_Message", L["voidwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["voidbar"], 12, "Interface\\Icons\\Spell_Frost_IceStorm", "Orange", "Red")
		end
	elseif sync == "HorsemenShieldWall" and self.db.profile.shieldwall and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["shieldwallwarn"], rest), "White")
		self:ScheduleEvent("BigWigs_Message", 20, string.format(L["shieldwallwarn2"], rest), "Green")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["shieldwallbar"], rest), 20, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow", "Orange", "Red")
	end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	local _,_, mob = string.find(msg, L["shieldwalltrigger"])
	if mob then self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall "..mob) end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["voidtrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenVoid" )
	end	
end

function BigWigsHorsemen:CHAT_MSG_COMBAT_HOSTILE_DEATH( msg )
	if msg == string.format(UNITDIESOTHER, thane ) or
		msg == string.format(UNITDIESOTHER, zeliek) or 
		msg == string.format(UNITDIESOTHER, mograine) or
		msg == string.format(UNITDIESOTHER, blaumeux) then
		self.deaths = self.deaths + 1
		if self.deaths == 4 then
			if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")("%s have been defeated"), boss), "Green", nil, "Victory") end
			self.core:ToggleModuleActive(self, false)
		end
	end
end

