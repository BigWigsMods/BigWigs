------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Vaelastrasz the Corrupt")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local playerName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Vaelastrasz",

	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Burning Adrenaline",

	you = "You",
	are = "are",

	warn1 = "You are burning!",
	warn2 = " is burning!",	

	youburning_cmd = "youburning",
	youburning_name = "You are burning alert",
	youburning_desc = "Warn when you are burning",

	elseburning_cmd = "elseburning",
	elseburning_name = "Someone else is burning alert",
	elseburning_desc = "Warn when others are burning",

	burningbar_cmd = "burningbar",
	burningbar_name = "Burning Adrenaline bar",
	burningbar_desc = "Shows a timer bar for Burning Adrenaline",

	icon_cmd = "icon",
	icon_name = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's the bomb. (Requires promoted or higher)",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^(.+)受(.+)了燃烧刺激",

	you = "你",
	are = "到",

	warn1 = "你在燃烧！",
	warn2 = "在燃烧！",

	youburning_name = "玩家燃烧警报",
	youburning_desc = "你燃烧时发出警报",

	elseburning_name = "队友燃烧警报",
	elseburning_desc = "队友燃烧时发出警报",

	icon_name = "炸弹图标",
	icon_desc = "在燃烧的队友头上标记骷髅图标（需要助理或领袖权限）",
} end)


L:RegisterTranslations("koKR", function() return {
	trigger1 = "(.*)불타는 아드레날린에 걸렸습니다.",

	whopattern = "(.+)|1이;가; ",
	you = "",

	warn1 = "당신은 불타는 아드레날린에 걸렸습니다!",
	warn2 = "님이 불타는 아드레날린에 걸렸습니다!",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) von Brennendes Adrenalin betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "Du brennst!",
	warn2 = " brennt!",

	youburning_name = "Du brennst",
	youburning_desc = "Warnung, wenn Du brennst.",

	elseburning_name = "X brennt",
	elseburning_desc = "Warnung, wenn andere Spieler brennen.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler der brennt. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) les effets de Mont\195\169e d'adr\195\169naline.",

	you = "Vous",
	are = "subissez",

	warn1 = "tu brule!",
	warn2 = " brule!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsVaelastrasz = BigWigs:NewModule(boss)
BigWigsVaelastrasz.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsVaelastrasz.enabletrigger = boss
BigWigsVaelastrasz.toggleoptions = {"youburning", "elseburning", "burningbar", -1, "icon", "bosskill"}
BigWigsVaelastrasz.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsVaelastrasz:OnEnable()
	playerName = UnitName("player")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelBomb", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsVaelastrasz:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "VaelBomb" or not rest then return end
	local player = rest

	if self.db.profile.youburning and player == playerName then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Red", true)
	elseif self.db.profile.elseburning then
		self:TriggerEvent("BigWigs_Message", player .. L["warn2"], "Yellow")
		self:TriggerEvent("BigWigs_SendTell", player, L["warn1"])
	end

	if self.db.profile.icon then 
		self:TriggerEvent("BigWigs_SetRaidIcon", player)
	end
	if self.db.profile.burningbar then
		self:TriggerEvent("BigWigs_StartBar", self, player .. L["warn2"], 20, "Interface\\Icons\\INV_Gauntlets_03", "Yellow", "Orange", "Red")
	end
end

function BigWigsVaelastrasz:Event(msg)
	local _, _, baPlayer = string.find(msg, L["trigger1"])
	if baPlayer then
		if baPlayer == L["you"] then
			baPlayer = UnitName("player")
		elseif GetLocale() == "koKR" then
			_, _, baPlayer = string.find(baPlayer, L["whopattern"])
		end
		self:TriggerEvent("BigWigs_SendSync", "VaelBomb "..baPlayer)
	end
end

