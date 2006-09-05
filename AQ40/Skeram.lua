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
	splittrigger = "The Prophet Skeram casts Summon Images.",
	aewarn = "Casting Arcane Explosion!",
	mcwarn = "Casting Mind Control!",
	mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.$",
	mcplayerwarn = " is mindcontrolled!",
	mcyou = "You",
	mcare = "are",
	
	splitwarn = "Splitting!",

	cmd = "Skeram",
	mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",

	ae_cmd = "ae",
	ae_name = "Arcane Explosion Alert",
	ae_desc = "Warn for Arcane Explosion",
	
	split_cmd = "split",
	split_name = "Split Alert",
	split_desc = "Warn before Create Image",
} end )

L:RegisterTranslations("frFR", function() return {
	aetrigger = boss.." commence \195\160 lancer Explosion des arcanes",
	mctrigger = boss.." lance Invocation des Images",
	aewarn = "Explosion des arcanes - Interrompez-le !",
	mcwarn = "Controle mental en cours",
	mcplayer = "^([^%s]+) ([^%s]+) les effets de Accomplissement v\195\169ritables",
	mcplayerwarn = " est sous controle mental !",
	mcyou = "Tu",
	mcare = "es",
	
	splitwarn = "Dédoublement !",
} end )

L:RegisterTranslations("deDE", function() return {
	aetrigger = "Der Prophet Skeram beginnt Arkane Explosion zu wirken.",
	mctrigger = "Der Prophet Skeram beginnt Wahre Erf\195\188llung zu wirken.",
	aewarn = "Arkane Explosion!",
	mcwarn = "Gedankenkontrolle!",
	mcplayer = "^([^%s]+) ([^%s]+) von Wahre Erf\195\188llung betroffen.$",
	mcplayerwarn = " steht unter Gedankenkontrolle!",
	mcyou = "Ihr",
	mcare = "seid",
	
	splitwarn = "Abbilder in K\195\188rze!",

	cmd = "Skeram",
	mc_cmd = "mc",
	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnung vor Gedankenkontrolle.",

	ae_cmd = "ae",
	ae_name = "Arkane Explosion",
	ae_desc = "Warnung vor Arkaner Explosion.",
	
	split_cmd = "split",
	split_name = "Abbilder",
	split_desc = "Warnung, wenn die Abbilder von Prophet Skeram erscheinen.",
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
	
	splitwarn = "即将分裂！",
	
	mc_name = "精神控制警报",
	mc_desc = "精神控制警报",
	
	ae_name = "魔爆术警报",
	ae_desc = "魔爆术警报",
	
	split_name = "分裂警报",
	split_desc = "预言者斯克拉姆即将复制镜像时发出警报",
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

	L:RegisterTranslations("frFR", function() return {
	aetrigger = "Le Proph\195\168te Skeram commence \195\160 lancer Explosion des arcanes.",
	mctrigger = "Le Proph\195\168te Skeram commence \195\160 lancer Accomplissement v\195\169ritable.",
	splittrigger = "Le Proph\195\168te Skeram lance Invocation des Images.",
	mcplayer = "([^%s]+) ([^%s]+) les effets de Accomplissement v\195\169ritable.",
	mcplayerwarn = " est sous controle mental!",
	mcyou = "Vous",
	mcare = "subissez",
	
	splitwarn = "Separation!",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSkeram = BigWigs:NewModule(boss)
BigWigsSkeram.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsSkeram.enabletrigger = boss
BigWigsSkeram.toggleoptions = {"split", "ae", "mc", "bosskill"}
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
		local _,_, player = string.find(arg1, L["mcplayer"])
		if player then
			if player == L["mcyou"] then
				player = UnitName("player")
			end
			if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", player .. L["mcplayerwarn"], "Red") end
		end
	end
else
	function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(arg1)
		local _,_, player, type = string.find(arg1, L["mcplayer"])
		if player and type then
			if player == L["mcyou"] and type == L["mcare"] then
				player = UnitName("player")
			end
			if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", player .. L["mcplayerwarn"], "Red") end
		end
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(arg1)
	if (arg1 == L["aetrigger"]) then
		if self.db.profile.ae then self:TriggerEvent("BigWigs_Message", L["aewarn"], "Orange") end
	elseif (arg1 == L["mctrigger"]) then
		if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", L["mcwarn"], "Orange") end
	elseif (arg1 == L["splittrigger"]) then
		if self.db.profile.split then self:TriggerEvent("BigWigs_Message", L["splitwarn"], "Red") end
	end
end
