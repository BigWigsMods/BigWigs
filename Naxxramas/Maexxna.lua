------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Maexxna"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local times = {}
local prior = nil
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maexxna",

	spray_cmd = "spray",
	spray_name = "Web Spray Alert",
	spray_desc = "Warn for webspray and spiders",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for enrage",

	cocoon_cmd = "cocoon",
	cocoon_name = "Cocoon Alert",
	cocoon_desc = "Warn for Cocooned players",

	cocoontrigger = "(.*) (.*) afflicted by Web Wrap.",
	webspraytrigger = "is afflicted by Web Spray.",

	cocoonwarn = "%s Cocooned!",

	enragetrigger = "%s becomes enraged!",

	webspraywarn30sec = "Wall Cocoons in 10 seconds",
	webspraywarn20sec = "Wall Cocoons! 10 seconds until Spiders spawn!",
	webspraywarn10sec = "Spiders Spawn. 10 seconds until Web Spray!",
	webspraywarn5sec = "WEB SPRAY 5 seconds!",
	webspraywarn = "Web Spray! 40 seconds until next!",
	enragewarn = "Enrage - SQUISH SQUISH SQUISH!",
	enragesoonwarn = "Enrage Soon - Bugsquatters out!",

	webspraybar = "Web Spray",
	cocoonbar = "Cocoons",
	spiderbar = "Spiders",

	you = "You",
	are = "are",
} end )

L:RegisterTranslations("deDE", function() return {
	spray_name = "Gespinstschauer",
	spray_desc = "Warnung vor Gespinstschauer und Spinnen.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung wenn Maexxna w\195\188tend wird.",

	cocoon_name = "Fangnetz",
	cocoon_desc = "Warnung, wenn Spieler von Fangnetz betroffen sind.",

	cocoontrigger = "(.*) (.*) von Fangnetz betroffen.",
	webspraytrigger = "von Gespinstschauer betroffen.",

	cocoonwarn = "%s im Fangnetz!",

	enragetrigger = "%s wird w\195\188tend!",

	webspraywarn30sec = "Fangnetze in 10 Sekunden!",
	webspraywarn20sec = "Fangnetze! Spinnen in 10 Sekunden!",
	webspraywarn10sec = "Spinnen! Gespinstschauer in 10 Sekunden!",
	webspraywarn5sec = "Gespinstschauer in 5 Sekunden!",
	webspraywarn = "Gespinstschauer! N\195\164chster in 40 Sekunden!",
	enragewarn = "Wutanfall!",
	enragesoonwarn = "Wutanfall in K\195\188rze!",

	webspraybar = "Gespinstschauer",
	cocoonbar = "Fangnetze",
	spiderbar = "Spinnen",

	you = "Ihr",
	are = "seid",
} end )

L:RegisterTranslations("koKR", function() return {
	spray_name = "거미줄 뿌리기 경고",
	spray_desc = "거미줄 뿌리기와 거미 소환에 대한 경고",

	enrage_name = "분노 경고",
	enrage_desc = "분노에 대한 경고",

	cocoon_name = "거미줄 감싸기 경고",
	cocoon_desc = "거미줄 감싸기에 걸린 플레이어에 대한 경고",

	cocoontrigger = "^([^|;%s]*)(.*)거미줄 감싸기에 걸렸습니다%.$",
	webspraytrigger = "거미줄 뿌리기에 걸렸습니다.",

	cocoonwarn = "<<%s>> 거미줄 감싸기에 걸렸습니다!",

	enragetrigger = "%s|1이;가; 분노에 휩싸입니다!",

	webspraywarn30sec = "10초 이내 거미줄 감싸기",
	webspraywarn20sec = "거미줄 감싸기. 10초 후 거미 소환!",
	webspraywarn10sec = "거미 소환. 10초 후 거미줄 뿌리기!",
	webspraywarn5sec = "5초 후 거미줄 뿌리기!",
	webspraywarn = "거미줄 뿌리기! 다음은 40초 후!",
	enragewarn = "분노 - 무한 공격!",
	enragesoonwarn = "분노 예고 - 준비!",

	webspraybar = "거미줄 뿌리기",
	cocoonbar = "거미줄 감싸기", -- CHECK
	spiderbar = "거미 소환", -- CHECK

	you = "",
	are = "",
} end )

L:RegisterTranslations("zhCN", function() return {
	spray_name = "蛛网喷射警报",
	spray_desc = "蛛网喷射警报",

	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	cocoon_name = "蛛网裹体警报",
	cocoon_desc = "对被蛛网裹体的玩家发出警报",

	cocoontrigger = "^(.+)受(.+)了蛛网裹体",
	webspraytrigger = "蛛网喷射",

	cocoonwarn = "%s被蛛网裹体了！",

	enragetrigger = "变得愤怒了！",

	webspraywarn30sec = "10秒后发动墙茧",
	webspraywarn20sec = "墙茧 - 10秒后蜘蛛出现！",
	webspraywarn10sec = "蜘蛛出现 - 10秒后蛛网喷射！",
	webspraywarn5sec = "蛛网裹体5秒！",
	webspraywarn = "蛛网裹体 -  40秒后再次发动",
	enragewarn = "激怒 - 全力攻击！",
	enragesoonwarn = "即将激怒 - 做好准备！",

	webspraybar = "蛛网喷射",
	cocoonbar = "墙茧",
	spiderbar = "小蜘蛛出现",

	you = "你",
	are = "到",
} end )

L:RegisterTranslations("zhTW", function() return {
	spray_name = "撒網警報",
	spray_desc = "當梅克絲娜撒網及小蜘蛛出現時發出警報",

	enrage_name = "狂怒警報",
	enrage_desc = "狂怒警報",

	cocoon_name = "纏繞的蜘蛛網警報",
	cocoon_desc = "玩家受到蜘蛛網纏繞發出警報",

	cocoontrigger = "^(.+)受到(.*)纏繞的蜘蛛網",
	webspraytrigger = "梅克絲娜的撒網",

	cocoonwarn = "%s 被蛛網纏繞了！",

	enragetrigger = "變得憤怒了！",

	webspraywarn30sec = "10 秒後發動纏繞的蜘蛛網",
	webspraywarn20sec = "纏繞的蜘蛛網！ 10 秒後小蜘蛛出現！",
	webspraywarn10sec = "小蜘蛛出現！ 10 秒後撒網！",
	webspraywarn5sec = "5 秒後撒網！",
	webspraywarn = "撒網！ 40 秒後再次發動",
	enragewarn = "狂怒！全力攻擊！",
	enragesoonwarn = "即將狂怒！",

	webspraybar = "撒網",
	cocoonbar = "纏繞的蜘蛛網",
	spiderbar = "小蜘蛛",

	you = "你",
	are = "了",
} end )

L:RegisterTranslations("frFR", function() return {
	cocoontrigger = "(.*) (.*) les effets de Entoilage.",
	webspraytrigger = "les effets de Jet de rets.",

	enragetrigger = "%s devient folle furieuse !",

	you = "Vous",
	are = "subissez",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMaexxna = BigWigs:NewModule(boss)
BigWigsMaexxna.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsMaexxna.enabletrigger = boss
BigWigsMaexxna.toggleoptions = {"spray", "cocoon", "enrage", "bosskill"}
BigWigsMaexxna.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMaexxna:OnEnable()
	self.enrageannounced = nil
	prior = nil
	times = {}
	started = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "SprayEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "SprayEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "SprayEvent")
	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MaexxnaWebspray", 8)
	self:TriggerEvent("BigWigs_ThrottleSync", "MaexxnaEnrage", 6)
	self:TriggerEvent("BigWigs_ThrottleSync", "MaexxnaCocoon", 0)
	-- the MaexxnaCocoon sync is left unthrottled, it's throttled inside the module itself
	-- because the web wrap happens to a lot of players at once.
end

function BigWigsMaexxna:SprayEvent( msg )
	if msg:find(L["webspraytrigger"]) and not prior then
		self:TriggerEvent("BigWigs_SendSync", "MaexxnaWebspray")
	elseif msg:find(L["cocoontrigger"]) then
		local wplayer,wtype = select(3, msg:find(L["cocoontrigger"]))
		if wplayer and wtype then
			if wplayer == L["you"] and wtype == L["are"] then
				wplayer = UnitName("player")
			end
			local t = GetTime()
			if ( not times[wplayer] ) or ( times[wplayer] and ( times[wplayer] + 10 ) < t) then
				self:TriggerEvent("BigWigs_SendSync", "MaexxnaCocoon "..wplayer)
			end
		end
	end
end

function BigWigsMaexxna:BigWigs_RecvSync( sync, rest )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		self:BigWigs_RecvSync("MaexxnaWebspray", nil, nil)
	elseif sync == "MaexxnaWebspray" then
		if prior then return end
		prior = true

		self:CancelScheduledEvent("bwmaexxna30")
		self:CancelScheduledEvent("bwmaexxna20")
		self:CancelScheduledEvent("bwmaexxna10")
		self:CancelScheduledEvent("bwmaexxna5")

		self:TriggerEvent("BigWigs_Message", L["webspraywarn"], "Important")
		self:ScheduleEvent("bwmaexxna30", "BigWigs_Message", 10, L["webspraywarn30sec"], "Attention")
		self:ScheduleEvent("bwmaexxna20", "BigWigs_Message", 20, L["webspraywarn20sec"], "Attention")
		self:ScheduleEvent("bwmaexxna10", "BigWigs_Message", 30, L["webspraywarn10sec"], "Attention")
		self:ScheduleEvent("bwmaexxna5", "BigWigs_Message", 35, L["webspraywarn5sec"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["cocoonbar"], 20, "Interface\\Icons\\Spell_Nature_Web" )
		self:TriggerEvent("BigWigs_StartBar", self, L["spiderbar"], 30, "Interface\\Icons\\INV_Misc_MonsterSpiderCarapace_01" )
		self:TriggerEvent("BigWigs_StartBar", self, L["webspraybar"], 40, "Interface\\Icons\\Ability_Ensnare" )
	elseif sync == "MaexxnaCocoon" then
		local t = GetTime()
		if ( not times[rest] ) or ( times[rest] and ( times[rest] + 10 ) < t) then
			if self.db.profile.cocoon then self:TriggerEvent("BigWigs_Message", string.format(L["cocoonwarn"], rest), "Urgent" ) end
			times[rest] = t
		end
	elseif sync == "MaexxnaEnrage" then
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important")
		end
	end
end

function BigWigsMaexxna:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["enragetrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "MaexxnaEnrage")
	end
end

function BigWigsMaexxna:UNIT_HEALTH( msg )
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if (health > 30 and health <= 33 and not self.enrageannounced) then
			if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L["enragesoonwarn"], "Important") end
			self.enrageannounced = true
		elseif (health > 40 and self.enrageannounced) then
			self.enrageannounced = nil
		end
	end
end

function BigWigsMaexxna:BigWigs_Message(text)
	if text == L["webspraywarn10sec"] then
		prior = nil
	end
end
