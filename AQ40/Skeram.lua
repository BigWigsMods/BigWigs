------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("The Prophet Skeram")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	aetrigger = "The Prophet Skeram begins to cast Arcane Explosion.",
	mctrigger = "The Prophet Skeram begins to cast True Fulfillment.",
	aewarn = "Casting Arcane Explosion!",
	mcwarn = "Casting Mind Control!",
	mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.$",
	mcplayerwarn = " is mindcontrolled!",
	mcyou = "You",
	mcare = "are",

	cmd = "Skeram",
	mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",

	ae_cmd = "ae",
	ae_name = "Arcane Explosion Alert",
	ae_desc = "Warn for Arcane Explosion",
} end )

L:RegisterTranslations("deDE", function() return {
	aetrigger = "Der Prophet Skeram beginnt Arkane Explosion zu wirken.",
	mctrigger = "Der Prophet Skeram beginnt True Fulfillment zu wirken.",
	aewarn = "Zaubert Arkane Explosion!",
	mcwarn = "Zaubert True Fulfillment!",
	mcplayer = "^([^%s]+) ([^%s]+) betroffen von True Fulfillment.$",
	mcplayerwarn = " ist \195\188bernommen worden! Sheep! Fear!",
	mcyou = "Du",
	mcare = "bist",
} end )

L:RegisterTranslations("zhCN", function() return {
	aetrigger = "预言者斯克拉姆开始施放魔爆术。",
	mctrigger = "预言者斯克拉姆开始施放充实。",
	aewarn = "正在施放魔爆术 - 迅速打断！",
	mcwarn = "正在施放充实 - 准备变羊！",
	mcplayer = "^(.+)受(.+)了充实效果的影响。",
	mcplayerwarn = "被控制了！变羊！恐惧！",
	mcyou = "你",
	mcare = "到",
} end )

L:RegisterTranslations("koKR", function() return {
	aetrigger = "예언자 스케람|1이;가; 신비한 폭발|1을;를; 시전합니다.",
	mctrigger = "예언자 스케람|1이;가; 예언 실현|1을;를; 시전합니다.",
	aewarn = "신비한 폭발 시전 - 시전 방해!",
	mcwarn = "예언 실현 시전 - 양변 준비!",
	mcplayer = "(.*)예언 실현에 걸렸습니다.",
	mcplayerwarn = "님이 정신지배되었습니다. 양변! 공포!",

	mcyou = "",
	mcare = "are",
	whopattern = "(.+)|1이;가; ",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSkeram = BigWigs:NewModule(boss)
BigWigsSkeram.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsSkeram.enabletrigger = boss
BigWigsSkeram.toggleoptions = {"ae", "mc", "bosskill"}
BigWigsSkeram.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSkeram:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

if (GetLocale() == "koKR") then
	function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(arg1)
		local _,_, player = string.find(arg1, L"mcplayer")
		if player then
			if player == L"mcyou" then
				player = UnitName("player")
			end
			if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", player .. L"mcplayerwarn", "Red") end
		end
	end
else
	function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(arg1)
		local _,_, player, type = string.find(arg1, L"mcplayer")
		if player and type then
			if player == L"mcyou" and type == L"mcare" then
				player = UnitName("player")
			end
			if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", player .. L"mcplayerwarn", "Red") end
		end
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(arg1)
	if (arg1 == L"aetrigger") then
		if self.db.profile.ae then self:TriggerEvent("BigWigs_Message", L"aewarn", "Orange") end
	elseif (arg1 == L"mctrigger") then
		if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", L"mcwarn", "Orange") end
	end
end