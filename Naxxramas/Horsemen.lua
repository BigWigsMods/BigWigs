------------------------------
--      Are you local?      --
------------------------------

local thane = AceLibrary("Babble-Boss-2.2")["Thane Korth'azz"]
local mograine = AceLibrary("Babble-Boss-2.2")["Highlord Mograine"]
local zeliek = AceLibrary("Babble-Boss-2.2")["Sir Zeliek"]
local blaumeux = AceLibrary("Babble-Boss-2.2")["Lady Blaumeux"]
local boss = AceLibrary("Babble-Boss-2.2")["The Four Horsemen"]

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local times = nil

local started = nil

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

	markbar = "Mark %d",
	markwarn1 = "Mark %d!",
	markwarn2 = "Mark %d in 5 sec",
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

	void_name = "공허의 지대 경고",
	void_desc = "여군주 블라미우스 공허의 지대 시전 경고.",

	meteor_name = "유성 경고",
	meteor_desc = "영주 코스아즈 유성 시전 경고.",

	wrath_name = "성스러운 격노 경고",
	wrath_desc = "젤리에크 경 신성한 격노 시전 경고",

	markbar = "징표 %d",
	markwarn1 = "%d 징표!",
	markwarn2 = "%d 징표 - 5 초",
	--marktrigger = "is afflicted by Mark of (Korth'azz|Blaumeux|Mograine|Zeliek)",
	marktrigger = "의 징표에 걸렸습니다.",
	
	voidtrigger = "여군주 블라미우스|1이;가; 공허의 지대|1을;를; 시전합니다.",
	voidwarn = "블라미우스 공허의 지대 생성!",
	voidbar = "공허의 지대",

	meteortrigger = "영주 코스아즈|1이;가; 유성|1으로;로; ",
	meteorwarn = "코스아즈 유성!",
	meteorbar = "유성",

	wrathtrigger = "젤리에크 경|1이;가; 신의 격노|1으로;로;",
	wrathwarn = "젤리에크 신의 격노!",
	wrathbar = "신의 격노",

	startwarn = "4인의 기병대 전투 시작! 약 17 초내에 징표",

	shieldwallbar = "%s - 방패의 벽",
	shieldwalltrigger = "(.*)|1이;가; 방패의 벽 효과를 얻었습니다.",
	shieldwallwarn = "%s - 20초간 방패의 벽",
	shieldwallwarn2 = "%s - 방패의 벽 사라짐!",
} end )

L:RegisterTranslations("deDE", function() return {
	mark_name = "Mal Alarm",
	mark_desc = "Warnt vor den Mal Debuffs",

	shieldwall_name = "Schildwall",
	shieldwall_desc = "Warnung vor Schildwall.",

	void_name = "Zone der Leere Warnung",
	void_desc = "Warnt, wenn Lady Blaumeux Zone der Leere zaubert.",

	meteor_name = "Meteor Alarm",
	meteor_desc = "Warnt, wenn Thane Meteor zaubert.",

	wrath_name = "Heiliger Zorn Alarm",
	wrath_desc = "Warnt, wenn Sire Zeliek Heiliger Zorn zaubert.",

	markbar = "Mal",
	markwarn1 = "Mal (%d)!",
	markwarn2 = "Mal (%d) - 5 Sekunden",
	marktrigger = "ist von Mal von .+ betroffen",

	voidtrigger = "Lady Blaumeux wirkt Zone der Leere.",
	voidwarn = "Zone der Leere kommt",
	voidbar = "Zone der Leere",

	meteortrigger = "Thane Korth'azzs Meteor trifft ",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrathtrigger = "Sire Zelieks Heiliger Zorn trifft ",
	wrathwarn = "Heiliger Zorn!",
	wrathbar = "Heiliger Zorn",

	startwarn = "Die Vier Reiter angegriffen! Mal in ~17 Sekunden",

	shieldwallbar = "%s - Schildwall",
	shieldwalltrigger = "(.+) bekommt 'Schildwall'.",
	shieldwallwarn = "%s - Schildwall f\195\188r 20 Sekunden",
	shieldwallwarn2 = "%s - Schildwall Vorbei!",
} end )

L:RegisterTranslations("zhCN", function() return {
	mark_name = "标记警报",
	mark_desc = "标记警报",

	shieldwall_name = "盾墙警报",
	shieldwall_desc = "盾墙警报",
	
	void_name = "虚空领域警报",
	void_desc = "当施放虚空领域时警报",

	meteor_name = "流星警报",
	meteor_desc = "库尔塔兹领主的流星警报",

	wrath_name = "神圣之怒警报",
	wrath_desc = "瑟里耶克爵士的神圣之怒警报",
	
	markbar = "标记 %d",
	markwarn1 = "标记(%d)！",
	markwarn2 = "标记(%d) - 5秒",
	
	marktrigger = "受到了库尔塔兹印记效果的影响。",

	voidtrigger = "女公爵布劳缪克丝施放了虚空领域。",
	voidwarn = "5秒后虚空领域",
	voidbar = "虚空领域",

	meteortrigger = "库尔塔兹领主的流星击中 ",
	meteorwarn = "流星",
	meteorbar = "流星",

	wrathtrigger = "瑟里耶克爵士的神圣之怒击中 ",
	wrathwarn = "神圣之怒",
	wrathbar = "神圣之怒",
	
	startwarn = "四骑士已激活 - ~17秒后标记",

	shieldwallbar = "%s - 盾墙",
	shieldwalltrigger = "获得了盾墙",
	shieldwallwarn = "%s - 20秒盾墙效果",
	shieldwallwarn2 = "%s - 盾墙消失了！",
} end )

L:RegisterTranslations("zhTW", function() return {
	mark_name = "標記警報",
	mark_desc = "標記警報",

	shieldwall_name = "盾牆警報",
	shieldwall_desc = "盾牆警報",
	
	void_name = "虛空地區警報",
	void_desc = "當布洛莫斯爵士施放虛空地區時警報",

	meteor_name = "隕石術警報",
	meteor_desc = "寇斯艾茲族長的隕石術警報",

	wrath_name = "神聖憤怒警報",
	wrath_desc = "札里克爵士的神聖憤怒警報",
	
	markbar = "印記 %d",
	markwarn1 = "印記(%d)！",
	markwarn2 = "印記(%d) - 5秒",
	
	marktrigger = "(.+)受到(.*)印記",

	voidtrigger = "布洛莫斯爵士施放了虛空地區。",
	voidwarn = "5秒後虛空地區",
	voidbar = "虛空地區",

	meteortrigger = "寇斯艾茲族長的隕石術擊中",
	meteorwarn = "隕石術",
	meteorbar = "隕石術",

	wrathtrigger = "札里克爵士的神聖憤怒擊中",
	wrathwarn = "神聖憤怒",
	wrathbar = "神聖憤怒",
	
	startwarn = "四騎士已進入戰鬥 - 17秒後印記",

	shieldwallbar = "%s - 盾牆",
	shieldwalltrigger = "獲得了盾牆",
	shieldwallwarn = "%s - 20秒盾牆效果",
	shieldwallwarn2 = "%s - 盾牆消失了！",
} end )

L:RegisterTranslations("frFR", function() return {
	mark_name = "Alertes Marques",
	mark_desc = "Annoncer les marques",

	shieldwall_name = "Alertes Mur Protecteur",
	shieldwall_desc = "Annoncer les Murs Protecteur",

	void_name = "Alertes Zones de Vide",
	void_desc = "Annoncer les nouvelle Zone de Vide de Dame Blaumeux.",

	meteor_name = "Alertes M\195\169t\195\169ores",
	meteor_desc = "Annoncer l'incantation des M\195\169t\195\169ores par Thane.",

	wrath_name = "Alertes Col\195\168re Divine",
	wrath_desc = "Annoncer l'incantation de Col\195\168re par Zeliek.",

	markbar = "Marque %d",
	markwarn1 = "Marque %d!",
	markwarn2 = "Marque %d dans 5 sec",
	marktrigger = "subit les effets de Marque de ",

	voidtrigger = "Dame Blaumeux lance Zone de vide.",
	voidwarn = "Zone de Vide bientot",
	voidbar = "Zone de Vide",

	meteortrigger = "Thane Korth'azz lance M\195\169t\195\169ore sur ",
	meteorwarn = "M\195\169t\195\169or !",
	meteorbar = "M\195\169t\195\169or",

	wrathtrigger = "Sire Zeliek lance Col\195\168re divine sur",
	wrathwarn = "Col\195\168re Divine !",
	wrathbar = "Col\195\168re Divine",

	startwarn = "Engagement de la Cavalerie! Marque dans ~17 sec",

	shieldwallbar = "%s - Mur Protecteur",
	shieldwalltrigger = "(.*) gagne Mur protecteur.",
	shieldwallwarn = "%s - Mur Protecteur pendant 20 sec",
	shieldwallwarn2 = "%s - Mur Protecteur FINI!",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHorsemen = BigWigs:NewModule(boss)
BigWigsHorsemen.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsHorsemen.enabletrigger = { thane, mograine, zeliek, blaumeux }
BigWigsHorsemen.toggleoptions = {"mark", "shieldwall", -1, "meteor", "void", "wrath", "bosskill"}
BigWigsHorsemen.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHorsemen:OnEnable()
	self.marks = 1
	self.deaths = 0
	self.marked = nil

	times = {}
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MarkEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenShieldWall", 3)

	-- bump mark to 3
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMark", 60)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMark2", 60)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMark3", 8)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenVoid", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenWrath", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMeteor", 5)
end

function BigWigsHorsemen:MarkEvent( msg )
	if string.find(msg, L["marktrigger"]) and not self.marked then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenMark3")
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
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, string.format( L["markbar"], self.marks), 17, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 12, string.format( L["markwarn2"], self.marks ), "Urgent")
		end
	elseif sync == "HorsemenMark3" then
		if self.marked then return end
		self.marked = true
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", string.format( L["markwarn1"], self.marks ), "Important")
		end
		self.marks = self.marks + 1
		if self.db.profile.mark then 
			self:TriggerEvent("BigWigs_StartBar", self, string.format( L["markbar"], self.marks ), 12, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 7, string.format( L["markwarn2"], self.marks ), "Urgent")
		end
		-- reset marked in 8 seconds
		self:ScheduleEvent(function() BigWigsHorsemen.marked = nil end, 8)
	elseif sync == "HorsemenMeteor" then
		if self.db.profile.meteor then
			self:TriggerEvent("BigWigs_Message", L["meteorwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["meteorbar"], 12, "Interface\\Icons\\Spell_Fire_Fireball02")
		end
	elseif sync == "HorsemenWrath" then
		if self.db.profile.wrath then
			self:TriggerEvent("BigWigs_Message", L["wrathwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["wrathbar"], 12, "Interface\\Icons\\Spell_Holy_Excorcism")
		end
	elseif sync == "HorsemenVoid" then
		if self.db.profile.void then
			self:TriggerEvent("BigWigs_Message", L["voidwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["voidbar"], 12, "Interface\\Icons\\Spell_Frost_IceStorm")
		end
	elseif sync == "HorsemenShieldWall" and self.db.profile.shieldwall and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["shieldwallwarn"], rest), "Attention")
		self:ScheduleEvent("BigWigs_Message", 20, string.format(L["shieldwallwarn2"], rest), "Positive")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["shieldwallbar"], rest), 20, "Interface\\Icons\\Ability_Warrior_ShieldWall")
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
			if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s have been defeated"], boss), "Bosskill", nil, "Victory") end
			self.core:ToggleModuleActive(self, false)
		end
	end
end

