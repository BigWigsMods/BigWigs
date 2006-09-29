------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Grobbulus")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Grobbulus",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	youinjected_cmd = "youinjected",
	youinjected_name = "You're injected Alert",
	youinjected_desc = "Warn when you're injected",

	otherinjected_cmd = "otherinjected",
	otherinjected_name = "Others injected Alert",
	otherinjected_desc = "Warn when others are injected",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on an injected person. (Requires promoted or higher)",

	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",

	you = "You",
	are = "are",

	startwarn = "Grobbulus engaged, 12min to enrage!",
	enragebar = "Enrage",
	enrage10min = "Enrage in 10min",
	enrage5min = "Enrage in 5min",
	enrage1min = "Enrage in 1min",
	enrage30sec = "Enrage in 30sec",
	enrage10sec = "Enrage in 10sec",
	warn1 = "You are injected!",
	warn2 = " is Injected!",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Grobbulus w\195\188tend wird.",

	youinjected_name = "Du bist verseucht",
	youinjected_desc = "Warnung, wenn Du von Mutagene Injektion betroffen bist.",

	otherinjected_name = "X ist verseucht",
	otherinjected_desc = "Warnung, wenn andere Spieler von Mutagene Injektion betroffen sind.",

	icon_cmd = "icon",
	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der von Mutagene Injektion betroffen ist. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	trigger1 = "^([^%s]+) ([^%s]+) von Mutagene Injektion betroffen",

	you = "Ihr",
	are = "seid",

	startwarn = "Grobbulus angegriffen! 12 Minuten bis Wutanfall!",
	enragebar = "Wutanfall",
	enrage10min = "Wutanfall in 10 Minuten!",
	enrage5min = "Wutanfall in 5 Minuten!",
	enrage1min = "Wutanfall in 1 Minute!",
	enrage30sec = "Wutanfall in 30 Sekunden!",
	enrage10sec = "Wutanfall in 10 Sekunden!",

	warn1 = "Du bist verseucht!",
	warn2 = " ist verseucht!",
} end )

L:RegisterTranslations("koKR", function() return {

	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	youinjected_name = "자신의 돌연변이 경고",
	youinjected_desc = "자신이 돌연변이 시 경고",

	otherinjected_name = "타인의 돌연변이 경고",
	otherinjected_desc = "타인이 돌연변이 시 경고",

	icon_name = "아이콘 지정",
	icon_desc = "돌연변이 걸린 사람에게 아이콘 지정 (승급자 이상 요구)",

	trigger1 = "^([^|;%s]*)(.*)돌연변이 유발에 걸렸습니다%.$", --"(.*)돌연변이 유발에 걸렸습니다.",

	you = "",
	are = "",

	startwarn = "그라불루스 전투 시작, 12분 후 격노!",
	enragebar = "격노",
	enrage10min = "10분 후 격노!",
	enrage5min = "5분 후 격노!",
	enrage1min = "1분 후 격노!",
	enrage30sec = "30초 후 격노!",
	enrage10sec = "10초 후 격노",
	warn1 = "당신은 돌연변이 유발에 걸렸습니다.",
	warn2 = " 님이 돌연변이 유발에 걸렸습니다.",
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	youinjected_name = "玩家变异注射警报",
	youinjected_desc = "你中了变异注射时发出警报",

	otherinjected_name = "队友变异注射警报",
	otherinjected_desc = "队友中了变异注射时发出警报",

	icon_name = "标记图标",
	icon_desc = "在中了变异注射的队友头上标记骷髅图标（需要助理或领袖权限）",

	trigger1 = "^(.+)受(.+)了变异注射",

	you = "你",
	are = "到",

	startwarn = "格罗布鲁斯激活，12分钟后进入激怒状态！",
	enragebar = "Enrage",
	enrage10min = "10分钟后激怒",
	enrage5min = "5分钟后激怒",
	enrage1min = "1分钟后激怒",
	enrage30sec = "30秒后激怒",
	enrage10sec = "10秒后激怒",
	warn1 = "你中变异注射了！",
	warn2 = "中变异注射了！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGrobbulus = BigWigs:NewModule(boss)
BigWigsGrobbulus.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsGrobbulus.enabletrigger = boss
BigWigsGrobbulus.toggleoptions = { "youinjected", "otherinjected", "icon", -1, "enrage", "bosskill" }
BigWigsGrobbulus.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGrobbulus:OnEnable()
	started = nil
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGrobbulus:BigWigs_RecvSync( sync, rest, nick )
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebar"], 720, "Interface\\Icons\\INV_Shield_01", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwgrobbulusenragewarn1", "BigWigs_Message", 120, L["enrage10min"], "Yellow")
			self:ScheduleEvent("bwgrobbulusenragewarn2", "BigWigs_Message", 420, L["enrage5min"], "Orange")
			self:ScheduleEvent("bwgrobbulusenragewarn3", "BigWigs_Message", 660, L["enrage1min"], "Red")
			self:ScheduleEvent("bwgrobbulusenragewarn4", "BigWigs_Message", 690, L["enrage30sec"], "Red")
			self:ScheduleEvent("bwgrobbulusenragewarn5", "BigWigs_Message", 710, L["enrage10sec"], "Red")
		end
	end
end

function BigWigsGrobbulus:InjectEvent( msg )
	local _, _, eplayer, etype = string.find(msg, L["trigger1"])
	if eplayer and etype then
		if self.db.profile.youinjected and eplayer == L["you"] and etype == L["are"] then
			self:TriggerEvent("BigWigs_Message", L["warn1"], "Red", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", UnitName("player") .. L["warn2"], "Yellow", nil, nil, true)
		elseif self.db.profile.otherinjected then
			self:TriggerEvent("BigWigs_Message", eplayer .. L["warn2"], "Yellow")
			self:TriggerEvent("BigWigs_SendTell", eplayer, L["warn1"])
		end
		if self.db.profile.icon then
			if eplayer == L"you" then eplayer = UnitName("player") end
			self:TriggerEvent("BigWigs_SetRaidIcon", eplayer )
		end
	end
end

