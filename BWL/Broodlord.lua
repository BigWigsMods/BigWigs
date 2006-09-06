------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Broodlord Lashlayer")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) les effets de Frappe mortelle",

	you = "Vous",
	are = "subissez",

	warn1 = "Frappe mortelle sur toi!",
	warn2 = "Frappe mortelle sur %s!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBroodlord = BigWigs:NewModule(boss)
BigWigsBroodlord.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
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
			self:TriggerEvent("BigWigs_Message", L["warn1"], "Red", true)
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["warn2"], UnitName("player")), 10, "Interface\\Icons\\Ability_Warrior_SavageBlow", "Red")
		elseif self.db.profile.elsems then
			self:TriggerEvent("BigWigs_Message", string.format(L["warn2"], EPlayer), "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["warn2"], EPlayer), 10, "Interface\\Icons\\Ability_Warrior_SavageBlow", "Red")
		end
	end
end

