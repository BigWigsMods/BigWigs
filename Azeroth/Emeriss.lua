------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Emeriss"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local BZ = AceLibrary("Babble-Zone-2.2")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Emeriss",

	engage = "Engage Alert",
	engage_desc = ("Warn when %s is engaged"):format(boss),

	corruption = "Corruption",
	corruption_desc = "Warn for incoming Corruption of the Earth",

	noxious = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	volatileyou = "Voltile infection on you alert",
	volatileyou_desc = "Warn for volatile infection on you",

	volatileother = "Volatile infection on others alert",
	volatileother_desc = "Warn for volatile infection on others",

	icon = "Place Icon",
	icon_desc = "Place your selected raid icon on the afflicted person (requires promoted or higher)",

	volatile_trigger = "^([^%s]+) ([^%s]+) afflicted by Volatile Infection",

	volatile_you = "You are afflicted by Volatile Infection!",
	volatile_other = " is afflicted by Volatile Infection!",

	engage_message = "%s Engaged! - Noxious Breath in ~10seconds",
	engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!",

	corruption_trigger = "Taste your world's corruption!",
	corruption_message = "Incoming Corruption of the Earth!",

	noxious_hit = "afflicted by Noxious Breath",
	noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 seconds until Noxious Breath!",
	noxious_message = "Noxious Breath - 30 seconds till next!",
	noxious_bar = "Noxious Breath",
} end )

L:RegisterTranslations("frFR", function() return {
	noxious = "Alerte Souffle naus\195\169abond",
	noxious_desc = "Pr\195\169viens quand Emeriss fait son Souffle naus\195\169abond.",

	volatileyou = "Alerte Infection volatile sur vous",
	volatileyou_desc = "Pr\195\169viens quand vous \195\170tes touch\195\169 par l'Infection volatile.",

	volatileother = "Alerte Infection volatile sur les autres",
	volatileother_desc = "Pr\195\169viens quand les autres sont touch\195\169s par l'Infection volatile.",

	volatile_trigger = "^([^%s]+) ([^%s]+) les effets de Infection volatile.",

	volatile_you = "Tu es infect\195\169 !",
	volatile_other = " est infect\195\169 !",

	noxious_hit = "les effets de Souffle naus\195\169abond.",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 secondes avant le Souffle naus\195\169abond !",
	noxious_message = "Souffle naus\195\169abond - 30 secondes avant le suivant !",
	noxious_bar = "Souffle naus\195\169abond",
} end )

L:RegisterTranslations("deDE", function() return {
	noxious = "Giftiger Atem",
	noxious_desc = "Warnung vor Giftiger Atem.",

	volatileyou = "Fl\195\188chtige Infektion",
	volatileyou_desc = "Warnung, wenn Fl\195\188chtige Infektion auf Dir.",

	volatileother = "Fl\195\188chtige Infektion auf Anderen",
	volatileother_desc = "Warnung, wenn Fl\195\188chtige Infektion auf anderen Spielern.",

	volatile_trigger = "^([^%s]+) ([^%s]+) von Fl\195\188chtige Infektion betroffen",

	volatile_you = "Du bist von Fl\195\188chtige Infektion betroffen!",
	volatile_other = " ist von Fl\195\188chtiger Infektion betroffen!",

	noxious_hit = "von Giftiger Atem betroffen",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5 Sekunden bis Giftiger Atem!",
	noxious_message = "Giftiger Atem! - N\195\164chster in 30 Sekunden!",
	noxious_bar = "Giftiger Atem",
} end )

L:RegisterTranslations("zhCN", function() return {
	noxious = "毒性吐息警报",
	noxious_desc = "毒性吐息警报",

	volatileyou = "玩家快速传染警报",
	volatileyou_desc = "你中了快速传染时发出警报",

	volatileother = "队友快速传染警报",
	volatileother_desc = "队友中了快速传染时发出警报",

	volatile_trigger = "^(.+)受(.+)了快速传染效果",

	volatile_you = "你中了快速传染！",
	volatile_other = "中了快速传染！",

	noxious_hit = "受到了毒性吐息效果的影响。",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5秒后发动毒性吐息！",
	noxious_message = "毒性吐息 - 30秒后再次发动",
	noxious_bar = "毒性吐息",
} end )

L:RegisterTranslations("zhTW", function() return {
	noxious = "毒性吐息警報",
	noxious_desc = "毒性吐息警報",

	volatileyou = "玩家快速傳染警報",
	volatileyou_desc = "你中了快速傳染時發出警報",

	volatileother = "隊友快速傳染警報",
	volatileother_desc = "隊友中了快速傳染時發出警報",

	volatile_trigger = "^(.+)受到(.*)快速傳染效果的影響。",

	volatile_you = "你中了快速傳染！",
	volatile_other = "中了快速傳染！",

	noxious_hit = "受到了毒性吐息效果的影響。",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5秒後發動毒性吐息！",
	noxious_message = "毒性吐息 - 30秒後再次發動",
	noxious_bar = "毒性吐息",
} end )

L:RegisterTranslations("koKR", function() return {
	engage = "광폭화 경고",
	engage_desc = ("%s가 광폭화 되었을 때 경고"):format(boss),

	noxious = "산성 숨결 경고",
	noxious_desc = "산성 숨결에 대한 경고",

	volatileyou = "자신의 대지의 오염 경고",
	volatileyou_desc = "자신의 대지의 오염에 대한 경고",

	volatileother = "타인의 대지의 오염 경고",
	volatileother_desc = "타인의 대지의 오염에 대한 경고",

	icon = "아이콘 지정",
	icon_desc = "효과에 걸린 사람에게 선택된 공격대 아이콘을 지정합니다.(승급자 이상 요구)",

	volatile_trigger = "^([^|;%s]*)(.*)대지의 오염에 걸렸습니다%.$",

	volatile_you = "당신은 대지의 오염에 걸렸습니다!",
	volatile_other = "님이 대지의 오염에 걸렸습니다!",

	engage_message = "%s 광폭화! - 약 10초 후 산성 숨결",
	engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!", -- check

	noxious_hit = "에메리스의 산성 숨결에 의해",
	--noxious_resist = "Noxious Breath was resisted",
	noxious_warn = "5초후 산성 숨결!",
	noxious_message = "산성 숨결 - 30초후 재시전!",
	noxious_bar = "산성 숨결",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = {BZ["Ashenvale"], BZ["Duskwood"], BZ["The Hinterlands"], BZ["Feralas"]}
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "corruption", -1, "noxious", -1, "volatileyou", "volatileother", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "EmeNox", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "EmeVola", 2)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Event(msg)
	if msg:find(L["noxious_hit"]) or msg:find(L["noxious_resist"]) then
		self:Sync("EmeNox")
	end
	local vplayer, vtype = select(3, msg:find(L["volatile_trigger"]))
	if vplayer and vtype then
		if vplayer == L2["you"] and vtype == L2["are"] then
			vplayer = UnitName("player")
		end
		self:Sync("EmeVola "..vplayer)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:Bar(L["noxious_bar"], 10, "Spell_Shadow_LifeDrain02")
	elseif self.db.profile.corruption and msg == L["corruption_trigger"] then
		self:Message(L["corruption_message"], "Urgent")
		self:Bar(L["corruption"], 10, "Ability_Creature_Cursed_03")
	end
end

function mod:BigWigs_Message(text)
	if text == L["noxious_warn"] then
		self.prior = nil
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "EmeVola" and rest then
		if self.db.profile.volatileyou and rest == UnitName("player") then
			self:Message(L["volatile_you"], "Important", true)
		elseif self.db.profile.volatileother then
			self:Message(rest .. L["volatile_other"], "Attention")
			self:Whisper(rest, L["volatile_you"])
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "EmeNox" and not self.prior and self.db.profile.noxious then
		self:Message(L["noxious_message"], "Important")
		self:DelayedMessage(25, L["noxious_warn"], "Urgent")
		self:Bar(L["noxious_bar"], 30, "Spell_Shadow_LifeDrain02")
		self.prior = true
	end
end
