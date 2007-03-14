------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ayamiss the Hunter"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ayamiss",
	sacrifice = "Sacrifice Alert",
	sacrifice_desc = "Warn for Sacrifice",

	sacrificetrigger = "^([^%s]+) ([^%s]+) afflicted by Paralyze",
	sacrificewarn = " is being Sacrificed!",
	you = "You",
	are = "are",
} end )

L:RegisterTranslations("frFR", function() return {
	sacrifice = "Alerte Sacrifice",
	sacrifice_desc = "Pr\195\169viens lorsqu'un joueur est sacrifi\195\169.",

	sacrificetrigger = "^([^%s]+) ([^%s]+) les effets de Paralysie%.$",
	sacrificewarn = " est sacrifi\195\169 !",
	you = "Vous",
	are = "subissez",
} end )

L:RegisterTranslations("deDE", function() return {
	sacrifice = "Opferung",
	sacrifice_desc = "Warnung, wenn ein Spieler geopfert wird.",

	sacrificetrigger = "^([^%s]+) ([^%s]+) von Paralisieren betroffen.",
	sacrificewarn = " wird geopfert!",
	you = "Ihr",
	are = "seid",
} end )

L:RegisterTranslations("zhCN", function() return {
	sacrifice = "祭品警报",
	sacrifice_desc = "玩家成为祭品时发出警报",

	sacrificetrigger = "^(.+)受(.+)了麻痹效果的影响。",
	sacrificewarn = "成为祭品了！",
	you = "你",
	are = "到",
} end )

L:RegisterTranslations("zhTW", function() return {
	sacrifice = "祭品警報",
	sacrifice_desc = "玩家成為祭品時發出警報",

	sacrificetrigger = "^(.+)受到(.*)麻痹",
	sacrificewarn = "變成祭品了，快殺 札拉幼蟲！",
	you = "你",
	are = "了",
} end )

L:RegisterTranslations("koKR", function() return {
	sacrifice = "마비 경고",
	sacrifice_desc = "마비에 대한 경고",

	sacrificetrigger = "^([^|;%s]*)(.*)마비에 걸렸습니다%.$",
	sacrificewarn = "님이 마비에 걸렸습니다!",
	you = "",
	are = "",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Ruins of Ahn'Qiraj"]
mod.enabletrigger = boss
mod.toggleoptions = {"sacrifice", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath" )
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSacrifice")
end

function mod:CheckSacrifice( msg )
	local player, type = select(3, msg:find(L["sacrificetrigger"]))
	if player and type then
		if player == L["you"] and type == L["are"] then
			player = UnitName("player")
		end
		if self.db.profile.sacrifice then self:TriggerEvent("BigWigs_Message", player .. L["sacrificewarn"], "Important") end
	end
end
