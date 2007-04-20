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

	youms = "Mortal strike on you alert",
	youms_desc = "Warn when you get mortal strike",

	elsems = "Mortal strike on others alert",
	elsems_desc = "Warn when someone else gets mortal strike",

	msbar = "Mortal Strike bar",
	msbar_desc = "Shows a bar with the Mortal Strike duration",
} end )

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^(.+)受(.+)了致死打击",

	you = "你",
	are = "到",

	warn1 = "你中了致死打击！",
	warn2 = "%s中了致死打击！",

	youms = "玩家致死打击警报",
	youms_desc = "你中了致死打击时发出警报",

	elsems = "队友致死打击警报",
	elsems_desc = "队友中了致死打击时发出警报",

	msbar = "致死打击条",
	msbar_desc = "显示一条致死打击的持续时间",
} end )

L:RegisterTranslations("zhTW", function() return {
	trigger1 = "^(.+)受到(.*)致死打擊",

	you = "你",
	are = "了",

	warn1 = "你中了致死打擊！",
	warn2 = "%s 中了致死打擊！",

	youms = "玩家致死打擊警報",
	youms_desc = "你中了致死打擊時發出警報",

	elsems = "隊友致死打擊警報",
	elsems_desc = "隊友中了致死打擊時發出警報",

	msbar = "致死打擊條",
	msbar_desc = "顯示一條致死打擊的持續時間",
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) von T\195\182dlicher Sto\195\159 betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "T\195\182dlicher Sto\195\159 auf Dir!",
	warn2 = "T\195\182dlicher Sto\195\159 auf %s!",

	youms = "T\195\182dlicher Sto\195\159 auf Dir",
	youms_desc = "Warnung, wenn Du von T\195\182dlicher Sto\195\159 betroffen bist.",

	elsems = "T\195\182dlicher Sto\195\159 auf X",
	elsems_desc = "Warnung, wenn andere Spieler von T\195\182dlicher Sto\195\159 betroffen sind.",

	msbar = "T\195\182dlicher Sto\195\159",
	msbar_desc = "Zeigt einen Anzeigebalken mit der Dauer des T\195\182dlichen Sto\195\159es.",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "^([^|;%s]*)(.*)죽음의 일격에 걸렸습니다%.$",

	you = "당신은",
	are = "",

	warn1 = "당신은 죽음의 일격!",
	warn2 = "<<%s>> 죽음의 일격!",

	youms = "자신의 죽음의 일격 경고",
	youms_desc = "당신이 죽음의 일격에 걸렸을 때 경고",

	elsems = "타인의 죽음의 일격 경고",
	elsems_desc = "타인이 죽음의 일격에 걸렸을 때 경고",

	msbar = "죽음의 일격 바",
	msbar_desc = "죽음의 일격 주기 바 표시",
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) les effets de Frappe mortelle.",

	you = "Vous",
	are = "subissez",

	warn1 = "Frappe mortelle sur toi !",
	warn2 = "Frappe mortelle sur %s !",

	youms = "Alerte Frappe mortelle sur vous",
	youms_desc = "Pr\195\169viens quand vous \195\170tes touch\195\169 par la Frappe mortelle.",

	elsems = "Alerte Frappe mortelle sur les autres",
	elsems_desc = "Pr\195\169viens quand quelqu'un d'autre est touch\195\169 par la Frappe mortelle.",

	msbar = "Barre Frappe mortelle",
	msbar_desc = "Affiche une barre indiquant la dur\195\169e de la Frappe mortelle.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
mod.enabletrigger = boss
mod.toggleoptions = {"youms", "elsems", "msbar", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MSEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MSEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MSEvent")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:MSEvent(msg)
	local player, type = select(3, msg:find(L["trigger1"]))
	if player and type then
		if player == L["you"] and type == L["are"] and self.db.profile.youms then
			self:Message(L["warn1"], "Personal", true)
			self:Bar(string.format(L["warn2"], UnitName("player")), 5, "Ability_Warrior_SavageBlow")
		elseif self.db.profile.elsems then
			self:Message(string.format(L["warn2"], player), "Attention")
			self:Bar(string.format(L["warn2"], player), 5, "Ability_Warrior_SavageBlow")
		end
	end
end
