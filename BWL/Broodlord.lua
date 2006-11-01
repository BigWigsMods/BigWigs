------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Broodlord Lashlayer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Broodlord",

	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mortal Strike",

	you = "You",
	are = "are",

	warn1 = "Mortal Strike on you!",
	warn2 = "Mortal Strike on %s!",

	youms_cmd = "youms",
	youms_name = "Mortal strike on you alert",
	youms_desc = "Warn when you get mortal strike",

	elsems_cmd = "elsems",
	elsems_name = "Mortal strike on others alert",
	elsems_desc = "Warn when someone else gets mortal strike",

	msbar_cmd = "msbar",
	msbar_name = "Mortal Strike bar",
	msbar_desc = "Shows a bar with the Mortal Strike duration",
} end )

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^(.+)受(.+)了致死打击",

	you = "你",
	are = "到",

	warn1 = "你中了致死打击！",
	warn2 = "%s中了致死打击！",

	youms_name = "玩家致死打击警报",
	youms_desc = "你中了致死打击时发出警报",

	elsems_name = "队友致死打击警报",
	elsems_desc = "队友中了致死打击时发出警报",

	msbar_name = "致死打击条",
	msbar_desc = "显示一条致死打击的持续时间",
} end )

L:RegisterTranslations("zhTW", function() return {
	-- Broodlord Lashlayer 勒西雷爾
	trigger1 = "^(.+)受到(.*)致死打擊",

	you = "你",
	are = "了",

	warn1 = "你中了致死打擊！",
	warn2 = "%s 中了致死打擊！",

	youms_name = "玩家致死打擊警報",
	youms_desc = "你中了致死打擊時發出警報",

	elsems_name = "隊友致死打擊警報",
	elsems_desc = "隊友中了致死打擊時發出警報",

	msbar_name = "致死打擊條",
	msbar_desc = "顯示一條致死打擊的持續時間",
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) von T\195\182dlicher Sto\195\159 betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "T\195\182dlicher Sto\195\159 auf Dir!",
	warn2 = "T\195\182dlicher Sto\195\159 auf %s!",

	youms_name = "T\195\182dlicher Sto\195\159 auf Dir",
	youms_desc = "Warnung, wenn Du von T\195\182dlicher Sto\195\159 betroffen bist.",

	elsems_name = "T\195\182dlicher Sto\195\159 auf X",
	elsems_desc = "Warnung, wenn andere Spieler von T\195\182dlicher Sto\195\159 betroffen sind.",

	msbar_name = "T\195\182dlicher Sto\195\159",
	msbar_desc = "Zeigt einen Anzeigebalken mit der Dauer des T\195\182dlichen Sto\195\159es.",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "^([^|;%s]*)(.*)죽음의 일격에 걸렸습니다%.$",

	you = "",
	are = "",

	warn1 = "당신은 죽음의 일격!",
	warn2 = "<<%s>> 죽음의 일격!",
	
	youms_name = "자신의 죽음의 일격 경고",
	youms_desc = "당신이 죽음의 일격에 걸렸을 때 경고",
	
	elsems_name = "타인의 죽음의 일격 경고",
	elsems_desc = "타인이 죽음의 일격에 걸렸을 때 경고",

	msbar_name = "죽음의 일격 바",
	msbar_desc = "죽음의 일격 주기 바 표시",
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) les effets de Frappe mortelle.",

	you = "Vous",
	are = "subissez",

	warn1 = "Frappe mortelle sur toi !",
	warn2 = "Frappe mortelle sur %s !",
	
	youms_name = "Alerte Frappe mortelle sur vous",
	youms_desc = "Préviens quand vous êtes touché par la Frappe mortelle.",

	elsems_name = "Alerte Frappe mortelle sur les autres",
	elsems_desc = "Préviens quand quelqu'un d'autre est touché par la Frappe mortelle.",

	msbar_name = "Barre Frappe mortelle",
	msbar_desc = "Affiche une barre indiquant la durée de la Frappe mortelle.",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBroodlord = BigWigs:NewModule(boss)
BigWigsBroodlord.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsBroodlord.enabletrigger = boss
BigWigsBroodlord.toggleoptions = {"youms", "elsems", "msbar", "bosskill"}
BigWigsBroodlord.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBroodlord:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MSEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MSEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MSEvent")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBroodlord:MSEvent(msg)
	local _, _, EPlayer, EType = string.find(msg, L["trigger1"])
	if (EPlayer and EType) then
		if EPlayer == L["you"] and EType == L["are"] and self.db.profile.youms then
			self:TriggerEvent("BigWigs_Message", L["warn1"], "Personal", true)
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["warn2"], UnitName("player")), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow")
		elseif self.db.profile.elsems then
			self:TriggerEvent("BigWigs_Message", string.format(L["warn2"], EPlayer), "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["warn2"], EPlayer), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow")
		end
	end
end

