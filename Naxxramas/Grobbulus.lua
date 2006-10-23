------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Grobbulus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

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

	cloud_cmd = "cloud",
	cloud_name = "Poison Cloud",
	cloud_desc = "Warn for Poison Clouds",

	inject_trigger = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",

	you = "You",
	are = "are",

	startwarn = "Grobbulus engaged, 12min to enrage!",
	enragebar = "Enrage",
	enrage10min = "Enrage in 10min",
	enrage5min = "Enrage in 5min",
	enrage1min = "Enrage in 1min",
	enrage30sec = "Enrage in 30sec",
	enrage10sec = "Enrage in 10sec",
	bomb_message_you = "You are injected!",
	bomb_message_other = "%s is injected!",
	bomb_bar = "%s injected",

	cloud_trigger = "Grobbulus casts Poison Cloud.",
	cloud_warn = "Poison Cloud next in ~15 seconds!",
	cloud_bar = "Poison Cloud",

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

	inject_trigger = "^([^%s]+) ([^%s]+) von Mutagene Injektion betroffen",

	you = "Ihr",
	are = "seid",

	startwarn = "Grobbulus angegriffen! 12 Minuten bis Wutanfall!",
	enragebar = "Wutanfall",
	enrage10min = "Wutanfall in 10 Minuten!",
	enrage5min = "Wutanfall in 5 Minuten!",
	enrage1min = "Wutanfall in 1 Minute!",
	enrage30sec = "Wutanfall in 30 Sekunden!",
	enrage10sec = "Wutanfall in 10 Sekunden!",

	bomb_message_you = "Du bist verseucht!",
	bomb_message_other = "%s ist verseucht!",
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

	cloud_name = "독구름",
	cloud_desc = "독구름에 대한 경고",

	inject_trigger = "^([^|;%s]*)(.*)돌연변이 유발에 걸렸습니다%.$", --"(.*)돌연변이 유발에 걸렸습니다.",

	you = "",
	are = "",

	startwarn = "그라불루스 전투 시작, 12분 후 격노!",
	enragebar = "격노",
	enrage10min = "10분 후 격노!",
	enrage5min = "5분 후 격노!",
	enrage1min = "1분 후 격노!",
	enrage30sec = "30초 후 격노!",
	enrage10sec = "10초 후 격노",
	bomb_message_you = "당신은 돌연변이 유발에 걸렸습니다.",
	bomb_message_other = "%s 님이 돌연변이 유발에 걸렸습니다.",
	bomb_bar = "%s 돌연변이",
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

	inject_trigger = "^(.+)受(.+)了变异注射",

	you = "你",
	are = "到",

	startwarn = "格罗布鲁斯激活，12分钟后进入激怒状态！",
	enragebar = "激怒",
	enrage10min = "10分钟后激怒",
	enrage5min = "5分钟后激怒",
	enrage1min = "1分钟后激怒",
	enrage30sec = "30秒后激怒",
	enrage10sec = "10秒后激怒",
	bomb_message_you = "你中变异注射了！",
	bomb_message_other = "%s中变异注射了！",
	bomb_bar = "%s被变异注射",
} end )

L:RegisterTranslations("zhTW", function() return {
	--Grobbulus 葛羅巴斯
	enrage_name = "狂怒警報",
	enrage_desc = "狂怒警報",

	youinjected_name = "突變注射警報",
	youinjected_desc = "你中了突變注射時發出警報",

	otherinjected_name = "隊友突變注射警報",
	otherinjected_desc = "隊友中了突變注射時發出警報",

	icon_name = "標記突變注射",
	icon_desc = "在中了突變注射的隊友頭上標記骷髏標記（需要助理或領隊權限）",

	inject_trigger = "^(.+)受到(.+)突變注射效果的影響。",

	you = "你",
	are = "了",

	startwarn = "*** 格羅布魯斯進入戰鬥 - 12 分鐘後進入狂怒狀態！ ***",
	enragebar = "狂怒",
	enrage10min = "*** 10 分鐘後狂怒 ***",
	enrage5min = "*** 5 分鐘後狂怒 ***",
	enrage1min = "*** 1 分鐘後狂怒 ***",
	enrage30sec = "*** 30 秒後狂怒 ***",
	enrage10sec = "*** 10 秒後狂怒 ***",
	bomb_message_you = "*** 你中突變注射了！ ***",
	bomb_message_other = "*** %s 中突變注射了！ ***",
	bomb_bar = "%s 被突變注射",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage_name = "Alerte Enrager",
	enrage_desc = "Préviens régulièrement quand Grobbulus devient enragé.",

	youinjected_name = "Alerte quand vous êtes injecté",
	youinjected_desc = "Préviens quand vous êtes injecté.",

	otherinjected_name = "Alerte quand les autres sont injectés",
	otherinjected_desc = "Préviens quand les autres sont injectés.",

	icon_name = "Placer une icône",
	icon_desc = "Place une icône sur la personne injectée. (nécessite d'être promu ou mieux)",

	cloud_name = "Nuage de poison",
	cloud_desc = "Préviens quand Globbulus lance ses nuages de poison.",
	
	inject_trigger = "^([^%s]+) ([^%s]+) les effets de Injection mutante.",

	you = "Vous",
	are = "subissez",

	startwarn = "Grobbulus engagé, 12 min. avant Enrager !",
	enragebar = "Enrager",
	enrage10min = "Enrager dans 10 min.",
	enrage5min = "Enrager dans 5 min.",
	enrage1min = "Enrager dans 1 min.",
	enrage30sec = "Enrager dans 30 sec.",
	enrage10sec = "Enrager dans 10 sec.",
	bomb_message_you = "Tu es injecté !",
	bomb_message_other = "%s est injecté !",
	bomb_bar = "%s injecté",

	cloud_trigger = "Grobbulus lance Nuage de poison.",
	cloud_warn = "Prochain nuage de poison dans ~15 sec. !",
	cloud_bar = "Nuage de poison",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGrobbulus = BigWigs:NewModule(boss)
BigWigsGrobbulus.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsGrobbulus.enabletrigger = boss
BigWigsGrobbulus.toggleoptions = { "youinjected", "otherinjected", "icon", "cloud", -1, "enrage", "bosskill" }
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

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GrobbulusInject", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "GrobbulusCloud", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGrobbulus:BigWigs_RecvSync( sync, rest, nick )
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebar"], 720, "Interface\\Icons\\INV_Shield_01")
			self:ScheduleEvent("bwgrobbulusenragewarn1", "BigWigs_Message", 120, L["enrage10min"], "Attention")
			self:ScheduleEvent("bwgrobbulusenragewarn2", "BigWigs_Message", 420, L["enrage5min"], "Urgent")
			self:ScheduleEvent("bwgrobbulusenragewarn3", "BigWigs_Message", 660, L["enrage1min"], "Important")
			self:ScheduleEvent("bwgrobbulusenragewarn4", "BigWigs_Message", 690, L["enrage30sec"], "Important")
			self:ScheduleEvent("bwgrobbulusenragewarn5", "BigWigs_Message", 710, L["enrage10sec"], "Important")
		end
	elseif sync == "GrobbulusInject" and rest then
		local player = rest
		if self.db.profile.youinjected and player == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["bomb_message_you"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_message_other"], player), "Attention", nil, nil, true)
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bomb_bar"], player), 10,"Interface\\Icons\\Spell_Shadow_CallofBone")
		elseif self.db.profile.otherinjected then
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_message_other"], player), "Attention")
			self:TriggerEvent("BigWigs_SendTell", player, L["bomb_message_you"])
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bomb_bar"], player), 10,"Interface\\Icons\\Spell_Shadow_CallofBone")
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player)
		end
	elseif sync == "GrobbulusCloud" then
		if self.db.profile.cloud then
			self:TriggerEvent("BigWigs_Message", L["cloud_warn"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["cloud_bar"], 15, "Interface\\Icons\\Ability_Creature_Disease_02")			
		end
	end
end

function BigWigsGrobbulus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if string.find( msg, L["cloud_trigger"] ) then
		self:TriggerEvent("BigWigs_SendSync", "GrobbulusCloud")
	end
end

function BigWigsGrobbulus:InjectEvent( msg )
	local _, _, eplayer, etype = string.find(msg, L["inject_trigger"])
	if eplayer and etype then
		if eplayer == L["you"] and etype == L["are"] then
			eplayer = UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "GrobbulusInject "..eplayer)
	end
end

