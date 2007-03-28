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
	splittrigger = "casts Summon Images",
	aewarn = "Casting Arcane Explosion!",
	mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.$",
	mcplayerwarn = "%s is mindcontrolled!",
	mcbar = "MC: %s",
	mcyou = "You",
	mcare = "are",

	splitwarn = "Splitting!",

	cmd = "Skeram",
	mc = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",

	ae = "Arcane Explosion Alert",
	ae_desc = "Warn for Arcane Explosion",

	split_cmd = "split", 
	split = "Split Alert",
	split_desc = "Warn before Create Image",

	icon = "Place Icon",
	icon_desc = "Place a skull icon on the mind controlled person (requires promoted or higher)",
} end )

L:RegisterTranslations("frFR", function() return {
	aetrigger = "Le Proph\195\168te Skeram commence \195\160 lancer Explosion des arcanes.",
	splittrigger = "lance Invocation des Images",
	aewarn = "Incantation d'Explosion des arcanes !",
	mcplayer = "([^%s]+) ([^%s]+) les effets de Accomplissement v\195\169ritable%.",
	mcplayerwarn = "%s est sous controle mental !",
	mcbar = "CM: %s",
	mcyou = "Vous",
	mcare = "subissez",

	splitwarn = "D\195\169multiplication !",

	mc = "Alerte Contr\195\180le mental",
	mc_desc = "Pr\195\169viens en cas de contr\195\180le mental.",

	ae = "Alerte Explosion des arcanes",
	ae_desc = "Pr\195\169viens lorsque Skeram lance Explosion des arcanes.",

	icon = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur la personne sous contr\195\180le mental (n\195\169cessite d'\195\170tre promu ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	aetrigger = "Der Prophet Skeram beginnt Arkane Explosion zu wirken.",
	splittrigger = "wirkt Abbilder beschw\195\182ren",
	aewarn = "Arkane Explosion!",
	mcplayer = "^([^%s]+) ([^%s]+) von Wahre Erf\195\188llung betroffen.$",
	mcplayerwarn = "%s steht unter Gedankenkontrolle!",
	mcyou = "Ihr",
	mcare = "seid",

	splitwarn = "Abbilder!",

	mc = "Gedankenkontrolle",
	mc_desc = "Warnung, wenn jemand unter Gedankenkontrolle steht.",

	ae = "Arkane Explosion",
	ae_desc = "Warnung vor Arkaner Explosion.",

	split = "Abbilder",
	split_desc = "Warnung, wenn die Abbilder von Prophet Skeram erscheinen.",

	icon = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der unter Gedankenkontrolle steht. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",
} end )

L:RegisterTranslations("zhCN", function() return {
	aetrigger = "预言者斯克拉姆开始施放魔爆术。",
	splittrigger = "预言者斯克拉姆施放了召唤幻象。",
	aewarn = "正在施放魔爆术 - 迅速打断！",
	mcplayer = "^(.+)受(.+)了充实效果的影响。",
	mcplayerwarn = "%s 被控制了！变羊！恐惧！",
	mcbar = "控制：%s",
	mcyou = "你",
	mcare = "到",

	splitwarn = "即将分裂！",

	mc = "精神控制警报",
	mc_desc = "精神控制警报",

	ae = "魔爆术警报",
	ae_desc = "魔爆术警报",

	split = "分裂警报",
	split_desc = "预言者斯克拉姆即将复制镜像时发出警报",

	icon = "标记精神控制",
	icon_desc = "团队标记被精神控制者 (需要助力或更高权限)",
} end )

L:RegisterTranslations("zhTW", function() return {
	aetrigger = "預言者斯克拉姆開始施放魔爆術。",
--	mctrigger = "預言者斯克拉姆開始施放充實。",
	splittrigger = "預言者斯克拉姆施放了召喚幻象。",
	aewarn = "施放魔爆術 - 迅速打斷！",
	mcplayer = "^(.+)受到(.*)充實",
	mcplayerwarn = "%s 被心靈控制，法師快變羊！",
	mcbar = "MC: %s",
	mcyou = "你",
	mcare = "了",

	splitwarn = "即將分裂！",

	mc = "精神控制警報",
	mc_desc = "預言者斯克拉姆進行精神控制時發出警報",

	ae = "魔爆術警報",
	ae_desc = "預言者斯克拉姆施放魔爆術時發出警報",

	split = "幻影分身警報",
	split_desc = "預言者斯克拉姆施放幻影分身時發出警報",

	icon = "標記被精神控制的隊友",
	icon_desc = "在被精神控制的隊友頭上設置標記 (需要助手或領隊權限)",
} end )

L:RegisterTranslations("koKR", function() return {
	aetrigger = "예언자 스케람|1이;가; 신비한 폭발|1을;를; 시전합니다.",
	splittrigger = "예언자 스케람|1이;가; 환영 소환|1을;를; 시전합니다.",
	aewarn = "신비한 폭발 시전 - 시전 방해!",
	mcplayer = "^([^|;%s]*)(.*)예언 실현에 걸렸습니다%.$",
	mcplayerwarn = "%s 님이 정신지배되었습니다. 양변! 공포!",
	mcbar = "예언: %s",
	mcyou = "당신은",
	mcare = "",

	splitwarn = "곧 분리 됩니다.!! 경고!!",

	mc = "정신 지배 경고",
	mc_desc = "정신 지배에 대한 경고",

	ae = "신비한 폭발 경고",
	ae_desc = "신비한 폭발에 대한 경고",

	split = "분리 경고",
	split_desc = "이미지 생성 전 경고",

	icon = "아이콘 지정",
	icon_desc = "정신 지배된 사람에게 해골 아이콘 지정 (승급자 이상 필요)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
mod.enabletrigger = boss
mod.toggleoptions = {"ae", "split", -1, "mc", "icon", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

-- Note that we do not sync the MC at the moment, since you really only care
-- about people that are MC'ed close to you anyway.
function mod:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(msg)
	local player, type = select(3, msg:find(L["mcplayer"]))
	if player and type then
		if player == L["mcyou"] and type == L["mcare"] then
			player = UnitName("player")
		end
		if self.db.profile.mc then
			self:TriggerEvent("BigWigs_Message", string.format(L["mcplayerwarn"], player), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mcbar"], player), 20, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate")
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player)
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["aetrigger"] and self.db.profile.ae then
		self:TriggerEvent("BigWigs_Message", L["aewarn"], "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["splittrigger"]) and self.db.profile.split then
		self:TriggerEvent("BigWigs_Message", L["splitwarn"], "Important")
	end
end
