------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")

local boss = BB["Kael'thas Sunstrider"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local capernian = BB["Grand Astromancer Capernian"]
local sanguinar = BB["Lord Sanguinar"]
local telonicus = BB["Master Engineer Telonicus"]
local thaladred = BB["Thaladred the Darkener"]

BB = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kael'thas",

	eyesyou = "Eyes on You",
	eyesyou_desc = ("Warn when %s sets eyes on you"):format(thaladred),

	eyesother = "Eyes on Others",
	eyesother_desc = ("Warn when %s sets eyes on others"):format(thaladred),

	icon = "Icon",
	icon_desc = ("Place a Raid Icon over whoever %s targets"):format(thaladred),

	whisper = "Whisper",
	whisper_desc = ("Whisper the player %s targets"):format(thaladred),

	eyes_trigger = "sets eyes on ([^%s]+)!",
	eyes_other = "Thaladred targets %s",
	eyes_you = "Thaladred targets YOU!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = {boss, capernian, sanguinar, telonicus, thaladred}
mod.toggleoptions = {"eyes", "icon", "whisper", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	local player = select(3, msg:find(L["eye_trigger"]))
	if player then
		if player == UnitName("player") and self.db.profile.eyesyou then
			self:Message(L["eyes_you"], "Personal", true, "Alarm")
			self:Message(L["eyes_other"]:format(player), "Attention", nil, nil, true)
		elseif self.db.profile.eyesother then
			self:Message(L["eyes_other"]:format(player), "Attention")
		end
		if self.db.profile.whisper then
			self:Whisper(player, L["eyes_you"])
		end
		if self.db.profile.icon then
			self:Icon(player)
		end
	end
end
