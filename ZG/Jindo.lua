------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Jin'do the Hexxer")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "jindo",

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

L:RegisterTranslations("zhCN", function() return {
	brainwash_name = "洗脑图腾警报",
	brainwash_desc = "洗脑图腾警报",

	healing_name = "治疗图腾警报",
	healing_desc = "治疗图腾警报",

	triggerbrainwash = "金度施放了召唤洗脑图腾。",
	triggerhealing = "金度施放了强效治疗守卫。",

	warnbrainwash = "洗脑图腾！",
	warnhealing = "治疗图腾！",
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
	
	triggerbrainwash = "주술사 진도|1이;가; 세뇌의 토템 소환|1을;를; 시전합니다.", 		
	triggerhealing = "주술사 진도|1이;가; 강력한 치유의 수호물|1을;를; 시전합니다.",
	triggercurse = "^([^|;%s]*)(.*)진도의 망상에 걸렸습니다%.$",
	
	warnbrainwash = "세뇌의 토템 - 제거!",
	warnhealing = "치유의 토템 - 제거!",

	cursewarn_self = "당신은 저주에 걸렸습니다. 망령 처리!!",
	cursewarn_other = "%s|1이;가; 저주에 걸렸습니다. 망령 처리!!",
	
	you = "",
	are = "",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsJindo = BigWigs:NewModule(boss)
BigWigsJindo.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsJindo.enabletrigger = boss
BigWigsJindo.toggleoptions = {"youcurse", "elsecurse", -1, "brainwash", "healing", -1, "bosskill"}
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
		self:TriggerEvent("BigWigs_Message", L["warnbrainwash"], "Orange")
	elseif self.db.profile.healing and msg == L["triggerhealing"] then
		self:TriggerEvent("BigWigs_Message", L["warnhealing"], "Red" )
	end
end

function BigWigsJindo:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "JindoCurse" or not rest then return end
	local player = rest

	if player == playerName and self.db.profile.youcurse then
		self:TriggerEvent("BigWigs_Message", L["cursewarn_you"], "Red", true)
	elseif self.db.profile.elsecurse then
		self:TriggerEvent("BigWigs_Message", string.format(L["cursewarn_other"], player), "Yellow")
		self:TriggerEvent("BigWigs_SendTell", player, L["cursewarn_you"])
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

