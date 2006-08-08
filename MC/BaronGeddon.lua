------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Baron Geddon")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Living Bomb",

	you = "You",
	are = "are",

	warn1 = "You are the bomb!",
	warn2 = " is the bomb!",

	cmd = "Baron",
	youbomb_cmd = "youbomb",
	youbomb_name = "You are the bomb alert",
	youbomb_desc = "Warn when you are the bomb",
	elsebomb_cmd = "elsebomb",
	elsebomb_name = "Someone else is the bomb alert",
	elsebomb_desc = "Warn when others are the bomb",
	icon_cmd = "icon",
	icon_name = "Skull icon on bomb",
	icon_desc = "Put a Skull icon on the person who's the bomb. (Requires promoted or higher)",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^(.+)受(.+)了活化炸弹",

	you = "你",
	are = "到",

	warn1 = "你是炸弹人！向着夕阳奔跑吧！",
	warn2 = "是炸弹人！向着夕阳奔跑吧！",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "^(.*)살아있는 폭탄에 걸렸습니다.",
	whopattern = "(.+)|1이;가; ",

	you = "",
	are = "은",

	warn1 = "당신은 폭탄입니다!",
	warn2 = "님이 폭탄입니다!",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) von Lebende Bombe betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "Du bist die Bombe!",
	warn2 = " ist die Bombe!",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) les effets de Bombe vivante.",

	you = "Vous",
	are = "subissez",

	warn1 = "TU ES LA BOMBE !",
	warn2 = " EST LA BOMBE!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBaronGeddon = BigWigs:NewModule(boss)
BigWigsBaronGeddon.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
BigWigsBaronGeddon.enabletrigger = boss
BigWigsBaronGeddon.toggleoptions = {"youbomb", "elsebomb", "icon", "bosskill"}
BigWigsBaronGeddon.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBaronGeddon:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

if (GetLocale() == "koKR") then
	function BigWigsBaronGeddon:Event(msg)
		local _, _, EPlayer = string.find(msg, L"trigger1")
		if (EPlayer) then
			if (EPlayer == L"you" and self.db.profile.youbomb) then
				self:TriggerEvent("BigWigs_Message", L".warn1", "Red", true)
			elseif (self.db.profile.elsebomb) then
				_, _, EPlayer = string.find(EPlayer, L"whopattern")
				self:TriggerEvent("BigWigs_Message", EPlayer .. L"warn2", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", EPlayer, L"warn1")
			end

			if self.db.profile.icon then
				if EPlayer == L"you" then	EPlayer = UnitName("player") end
				self:TriggerEvent("BigWigs_SetRaidIcon", EPlayer )
			end
		end
	end
else
	function BigWigsBaronGeddon:Event(msg)
		local _, _, EPlayer, EType = string.find(msg, L"trigger1")
		if (EPlayer and EType) then
			if (EPlayer == L"you" and EType == L"are" and self.db.profile.youbomb) then
				self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true)
			elseif (self.db.profile.elsebomb) then
				self:TriggerEvent("BigWigs_Message", EPlayer .. L"warn2", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", EPlayer, L"warn1")
			end

			if self.db.profile.icon then
				if EPlayer == L"you" then	EPlayer = UnitName("player") end
				self:TriggerEvent("BigWigs_SetRaidIcon", EPlayer )
			end
		end
	end
end