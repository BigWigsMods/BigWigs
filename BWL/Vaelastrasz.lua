------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Vaelastrasz the Corrupt"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

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

	youburning = "You are burning alert",
	youburning_desc = "Warn when you are burning",

	elseburning = "Someone else is burning alert",
	elseburning_desc = "Warn when others are burning",

	burningbar = "Burning Adrenaline bar",
	burningbar_desc = "Shows a timer bar for Burning Adrenaline",

	icon = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's the bomb. (Requires promoted or higher)",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^(.+)受(.+)了燃烧刺激",

	you = "你",
	are = "到",

	warn1 = "你在燃烧！",
	warn2 = "在燃烧！",

	youburning = "玩家燃烧警报",
	youburning_desc = "你燃烧时发出警报",

	elseburning = "队友燃烧警报",
	elseburning_desc = "队友燃烧时发出警报",

	burningbar = "燃烧刺激计时条",
	burningbar_desc = "燃烧刺激计时条",
	icon = "炸弹图标",
	icon_desc = "在燃烧的队友头上标记骷髅图标（需要助理或领袖权限）",
} end)

L:RegisterTranslations("zhTW", function() return {
	trigger1 = "^(.+)受到(.*)燃燒刺激",

	you = "你",
	are = "了",

	warn1 = "你正在燃燒！",
	warn2 = " 正在燃燒！",

	youburning = "玩家燃燒警報",
	youburning_desc = "你燃燒時發出警報",

	elseburning = "隊友燃燒警報",
	elseburning_desc = "隊友燃燒時發出警報",
	
	burningbar = "燃燒刺激計時條",
	burningbar_desc = "燃燒刺激計時條",
	icon = "炸彈標記",
	icon_desc = "在被燃燒的隊友頭上標記（需要助理或領隊權限）",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "^([^|;%s]*)(.*)불타는 아드레날린에 걸렸습니다%.$", --"(.*)불타는 아드레날린에 걸렸습니다.",

	you = "당신은",
	are = "",

	warn1 = "당신은 불타는 아드레날린에 걸렸습니다!",
	warn2 = "님이 불타는 아드레날린에 걸렸습니다!",

	youburning = "당신의 아드레날린 경고",
	youburning_desc = "당신이 아드레날린에 대한 경고",

	elseburning = "타인의 아드레날린 경고",
	elseburning_desc = "타인의 아드레날린에 대한 경고",

	icon = "폭탄에 공격대 아이콘 지정",
	icon_desc = "폭탄이 된 사람에 공격대 아이콘 지정. (승급자 이상 요구)",

	burningbar = "아드레날린 바",
	burningbar_desc = "아드레날인에 대한 타이머 바 표시",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) von Brennendes Adrenalin betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "Du brennst!",
	warn2 = " brennt!",

	youburning = "Du brennst",
	youburning_desc = "Warnung, wenn Du brennst.",

	elseburning = "X brennt",
	elseburning_desc = "Warnung, wenn andere Spieler brennen.",

	burningbar = "Brennendes Adrenalin",
	burningbar_desc = "Zeigt einen Anzeigebalken f\195\188r Brennendes Adrenalin.",

	icon = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler der brennt. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) les effets de Mont\195\169e d'adr\195\169naline.",

	you = "Vous",
	are = "subissez",

	warn1 = "Tu br\195\187les !",
	warn2 = " br\195\187le !",

	youburning = "Alerte quand vous br\195\187lez",
	youburning_desc = "Pr\195\169viens quand vous br\195\187lez.",

	elseburning = "Alerte quand les autres br\195\187lent",
	elseburning_desc = "Pr\195\169viens quand les autres br\195\187lent.",

	burningbar = "Barre Mont\195\169e d'adr\195\169naline",
	burningbar_desc = "Affiche une barre temporelle pour la Mont\195\169e d'adr\195\169naline.",

	icon = "Ic\195\180ne de raid sur la bombe",
	icon_desc = "Place une ic\195\180ne de raid sur la personne qui est la bombe (N\195\169cessite d'\195\170tre promu ou mieux).",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
mod.enabletrigger = boss
mod.toggleoptions = {"youburning", "elseburning", "burningbar", -1, "icon", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	playerName = UnitName("player")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelBomb", 1)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "VaelBomb" or not rest then return end
	local player = rest

	if player == playerName and self.db.profile.youburning then
		self:Message(L["warn1"], "Personal", true)
		self:Message(playerName .. L["warn2"], "Attention", nil, nil, true)
	elseif self.db.profile.elseburning then
		self:Message(player .. L["warn2"], "Attention")
		self:Whisper(player, L["warn1"])
	end

	if self.db.profile.icon then 
		self:Icon(player)
	end
	if self.db.profile.burningbar then
		self:Bar(player .. L["warn2"], 20, "INV_Gauntlets_03")
	end
end

function mod:Event(msg)
	local baPlayer = select(3, msg:find(L["trigger1"]))
	if baPlayer then
		if baPlayer == L["you"] then
			baPlayer = playerName
		end
		self:Sync("VaelBomb "..baPlayer)
	end
end
