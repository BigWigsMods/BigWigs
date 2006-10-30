------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Prophet Skeram"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

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
	mcplayerwarn = "%s is mindcontrolled!",
	mcbar = "MC: %s",
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
	
--	split_cmd = "split",
--	split_name = "Split Alert",
--	split_desc = "Warn before Create Image",
} end )

L:RegisterTranslations("frFR", function() return {
	aetrigger = boss.." commence \195\160 lancer Explosion des arcanes",
	mctrigger = boss.." lance Invocation des Images",
	aewarn = "Explosion des arcanes - Interrompez-le !",
	mcwarn = "Controle mental en cours",
	mcplayer = "^([^%s]+) ([^%s]+) les effets de Accomplissement v\195\169ritables",
	mcplayerwarn = "%s est sous controle mental !",
	mcyou = "Tu",
	mcare = "es",
	
	splitwarn = "Dédoublement !",
} end )

L:RegisterTranslations("deDE", function() return {
	aetrigger = "Der Prophet Skeram beginnt Arkane Explosion zu wirken.",
	mctrigger = "Der Prophet Skeram beginnt Wahre Erf\195\188llung zu wirken.",
	splittrigger = "Der Prophet Skeram wirkt Abbilder beschw\195\182ren.",
	aewarn = "Arkane Explosion!",
	mcwarn = "Gedankenkontrolle!",
	mcplayer = "^([^%s]+) ([^%s]+) von Wahre Erf\195\188llung betroffen.$",
	mcplayerwarn = "%s steht unter Gedankenkontrolle!",
	mcyou = "Ihr",
	mcare = "seid",
	
	splitwarn = "Abbilder!",

	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnung, wenn jemand unter Gedankenkontrolle steht.",

	ae_name = "Arkane Explosion",
	ae_desc = "Warnung vor Arkaner Explosion.",
	
--	split_name = "Abbilder",
--	split_desc = "Warnung, wenn die Abbilder von Prophet Skeram erscheinen.",
} end )

L:RegisterTranslations("zhCN", function() return {
	aetrigger = "预言者斯克拉姆开始施放魔爆术。",
	mctrigger = "预言者斯克拉姆开始施放充实。",
	splittrigger = "预言者斯克拉姆施放了召唤幻象。",
	aewarn = "正在施放魔爆术 - 迅速打断！",
	mcwarn = "正在施放充实 - 准备变羊！",
	mcplayer = "^(.+)受(.+)了充实效果的影响。",
	mcplayerwarn = "%s 被控制了！变羊！恐惧！",
	mcyou = "你",
	mcare = "到",
	
	splitwarn = "即将分裂！",
	
	mc_name = "精神控制警报",
	mc_desc = "精神控制警报",
	
	ae_name = "魔爆术警报",
	ae_desc = "魔爆术警报",
	
--	split_name = "分裂警报",
--	split_desc = "预言者斯克拉姆即将复制镜像时发出警报",
} end )


L:RegisterTranslations("zhTW", function() return {
	-- The Prophet Skeram 預言者斯克拉姆
	aetrigger = "預言者斯克拉姆開始施放魔爆術。",
	mctrigger = "預言者斯克拉姆開始施放充實。",
	splittrigger = "預言者斯克拉姆施放了召喚幻象。",
	aewarn = "施放魔爆術 - 迅速打斷！",
	mcwarn = "施放充實 - 準備變羊！",
	mcplayer = "^(.+)受到(.+)充實",
	mcplayerwarn = "%s 被心靈控制，法師快變羊！",
	mcbar = "MC: %s",
	mcyou = "你",
	mcare = "了",
	
	splitwarn = "即將分裂！",
	
	mc_name = "精神控制警報",
	mc_desc = "預言者斯克拉姆進行精神控制時發出警報",
	
	ae_name = "魔爆術警報",
	ae_desc = "預言者斯克拉姆施放魔爆術時發出警報",
	
--	split_name = "幻影分身警報",
--	split_desc = "預言者斯克拉姆施放幻影分身時發出警報",
} end )

L:RegisterTranslations("koKR", function() return {
	aetrigger = "예언자 스케람|1이;가; 신비한 폭발|1을;를; 시전합니다.",
	mctrigger = "예언자 스케람|1이;가; 예언 실현|1을;를; 시전합니다.",
	splittrigger = "예언자 스케람|1이;가; 환영 소환|1을;를; 시전합니다.", -- By turtl
	aewarn = "신비한 폭발 시전 - 시전 방해!",
	mcwarn = "예언 실현 시전 - 양변 준비!",
	mcplayer = "^([^|;%s]*)(.*)예언 실현에 걸렸습니다%.$", --"(.*)예언 실현에 걸렸습니다.",
	mcplayerwarn = "%s 님이 정신지배되었습니다. 양변! 공포!",
	mcyou = "",
	mcare = "",

	splitwarn = "곧 분리 됩니다.!! 경고!!",

	mc_name = "정신 지배 경고",
	mc_desc = "정신 지배에 대한 경고",

	ae_name = "신비한 폭발 경고",
	ae_desc = "신비한 폭발에 대한 경고",
	
--	split_name = "분리 경고",
--	split_desc = "이미지 생성 전 경고",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSkeram = BigWigs:NewModule(boss)
BigWigsSkeram.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
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

-- Note that we do not sync the MC at the moment, since you really only care
-- about people that are MC'ed close to you anyway.
function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(msg)
	local _,_, player, type = string.find(msg, L["mcplayer"])
	if player and type then
		if player == L["mcyou"] and type == L["mcare"] then
			player = UnitName("player")
		end
		if self.db.profile.mc then
			self:TriggerEvent("BigWigs_Message", string.format(L["mcplayerwarn"], player), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mcbar"], player), 20, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate")
		end
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["aetrigger"] and self.db.profile.ae then
		self:TriggerEvent("BigWigs_Message", L["aewarn"], "Urgent")
	elseif msg == L["mctrigger"] and self.db.profile.mc then
		self:TriggerEvent("BigWigs_Message", L["mcwarn"], "Urgent")
	elseif msg == L["splittrigger"] and self.db.profile.split then
		self:TriggerEvent("BigWigs_Message", L["splitwarn"], "Important")
	end
end

