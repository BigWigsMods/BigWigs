------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Jin'do the Hexxer")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Jindo",

	brainwash_cmd = "brainwash",
	brainwash_name = "Brainwash Totem Alert",
	brainwash_desc = "Warn for Brainwash Totems",

	healing_cmd = "healing",
	healing_name = "Healing Totem Alert",
	healing_desc = "Warn for Healing Totems",

	youcurse_cmd = "youcurse",
	youcurse_name = "You're cursed Alert",
	youcurse_desc = "Warn when you get cursed",

	elsecurse_cmd = "elsecurse",
	elsecurse_name = "Others are cursed Alert",
	elsecurse_desc = "Warn when others are cursed",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on the cursed person (requires promoted or higher)",

	triggerbrainwash = "Jin'do the Hexxer casts Summon Brain Wash Totem.",
	triggerhealing = "Jin'do the Hexxer casts Powerful Healing Ward.",
	triggercurse = "^([^%s]+) ([^%s]+) afflicted by Jin'do the Hexxer's Delusion.", -- CHECK

	warnbrainwash = "Brain Wash Totem!",
	warnhealing = "Healing Totem!",

	cursewarn_self = "You are cursed!",
	cursewarn_other = "%s is cursed!",

	you = "You",
	are = "are",
} end )

L:RegisterTranslations("deDE", function() return {
	brainwash_name = "Gehirnw\195\164sche",
	brainwash_desc = "Warnung, wenn Jin'do \195\156bernahmetotem beschw\195\182rt.",

	healing_name = "Heiltotem",
	healing_desc = "Warnung, wenn Jin'do Heiltotem beschw\195\182rt.",

	triggerbrainwash = "Jin'do der Verhexer wirkt Totem der Gehirnw\195\164sche beschw\195\182ren.",
	triggerhealing = "Jin'do der Verhexer wirkt M\195\164chtiger Heilungszauberschutz.",

	warnbrainwash = "\195\156bernahmetotem!",
	warnhealing = "Heiltotem!",
} end )

L:RegisterTranslations("frFR", function() return {
	brainwash_name = "Alerte Totem de Mind Control",
	brainwash_desc = "Alerte Totem de Mind Control",

	healing_name = "Alerte Totem de Soins",
	healing_desc = "Alerte Totem de Soins",

	youcurse_name = "Alerte quand tu es Maudit",
	youcurse_desc = "Alerte quand tu es Maudit",

	elsecurse_name = "Alerte Autre Maudit",
	elsecurse_desc = "Alerte quand un autre joueur est maudit",

	icon_name = "Place une icone",
	icon_desc = "Place une icone sur la personne Maudite (promotion requise)",

	triggerbrainwash = "Jin'do le Mal\195\169ficieur lance Invocation du totem de lavage de cerveau", --TESTED
	triggerhealing = "Jin'do le Mal\195\169ficieur lance Gardien gu\195\169risseur puissant.", --TESTED
	triggercurse = "^([^%s]+) ([^%s]+) les effets de Illusions de Jin'do",

	warnbrainwash = "Totem de Control Mental!",
	warnhealing = "Totem de Soins!",

	cursewarn_self = "Tu es Maudit!",
	cursewarn_other = "%s est Maudit!",

	you = "Vous",
	are = "subissez",
} end )


L:RegisterTranslations("zhCN", function() return {
	brainwash_name = "洗脑图腾警报",
	brainwash_desc = "洗脑图腾警报",

	healing_name = "治疗图腾警报",
	healing_desc = "治疗图腾警报",

	youcurse_name = "你中诅咒警报",
	youcurse_desc = "你中诅咒警报",

	elsecurse_name = "玩家诅咒警报",
	elsecurse_desc = "玩家诅咒警报",

	icon_name = "标记被诅咒玩家",
	icon_desc = "团队标记被诅咒玩家 (需要助力或更高权限)",

	triggerbrainwash = "妖术师金度施放了召唤洗脑图腾。",
	triggerhealing = "妖术师金度施放了强效治疗守卫。",
	triggercurse = "^(.+)受到(.+)金度的欺骗效果的影响",

	warnbrainwash = "洗脑图腾！",
	warnhealing = "治疗图腾！",
	cursewarn_self = "你中了诅咒!",
	cursewarn_other = "%s 中了诅咒",

	you = "你",
	are = "是",
} end )

L:RegisterTranslations("koKR", function() return {
	
	brainwash_name = "세뇌의 토템 경고",
	brainwash_desc = "세뇌의 토템에 대한 경고",
	
	healing_name = "치유의 수호물 경고",
	healing_desc = "치유의 수호물에 대한 경고",
	
	youcurse_name = "자신의 저주 알림",
	youcurse_desc = "자신이 저주에 걸렸을 때 알림",

	elsecurse_name = "타인의 저주 알림",
	elsecurse_desc = "타인이 저주에 걸렸을 때 알림",
	
	icon_name = "아이콘 지정",
	icon_desc = "저주가 걸린 사람에게 해골 아이콘 지정 (승급자 이상 필요)",

	triggerbrainwash = "주술사 진도|1이;가; 세뇌의 토템 소환|1을;를; 시전합니다.", 		
	triggerhealing = "주술사 진도|1이;가; 강력한 치유의 수호물|1을;를; 시전합니다.",
	triggercurse = "^([^|;%s]*)(.*)진도의 망상에 걸렸습니다%.$",
	
	warnbrainwash = "세뇌의 토템 - 제거!",
	warnhealing = "치유의 토템 - 제거!",

	cursewarn_self = "당신은 저주에 걸렸습니다. 망령 처리!!",
	cursewarn_other = "<<%s>> 저주에 걸렸습니다. 망령 처리!!", --"%s%|1이;가; 저주에 걸렸습니다. 망령 처리!!",
	
	you = "",
	are = "",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsJindo = BigWigs:NewModule(boss)
BigWigsJindo.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsJindo.enabletrigger = boss
BigWigsJindo.toggleoptions = {"youcurse", "elsecurse", "icon", -1, "brainwash", "healing", "bosskill"}
BigWigsJindo.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsJindo:OnEnable()
	playerName = UnitName("player")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoCurse", 5)
end

------------------------------
--      Events              --
------------------------------

function BigWigsJindo:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.brainwash and msg == L["triggerbrainwash"] then
		self:TriggerEvent("BigWigs_Message", L["warnbrainwash"], "Urgent")
	elseif self.db.profile.healing and msg == L["triggerhealing"] then
		self:TriggerEvent("BigWigs_Message", L["warnhealing"], "Important" )
	end
end

function BigWigsJindo:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "JindoCurse" or not rest then return end
	local player = rest

	if player == playerName and self.db.profile.youcurse then
		self:TriggerEvent("BigWigs_Message", L["cursewarn_self"], "Personal", true)
		self:TriggerEvent("BigWigs_Message", string.format(L["cursewarn_other"], playerName), "Attention", nil, nil, true)
	elseif self.db.profile.elsecurse then
		self:TriggerEvent("BigWigs_Message", string.format(L["cursewarn_other"], player), "Attention")
		self:TriggerEvent("BigWigs_SendTell", player, L["cursewarn_self"])
	end

	if self.db.profile.icon then 
		self:TriggerEvent("BigWigs_SetRaidIcon", player)
	end
end

function BigWigsJindo:Event(msg)
	local _, _, baPlayer = string.find(msg, L["triggercurse"])
	if baPlayer then
		if baPlayer == L["you"] then
			baPlayer = UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "JindoCurse "..baPlayer)
	end
end

