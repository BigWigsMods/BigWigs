------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Zul'jin"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Zul'jin",

	engage_trigger = "Nobody badduh dan me!",
	engage_message = "Phase 1 - Human Phase",

	form = "Form Shift",
	form_desc = "Warn when Zul'jin changes form.",
	form_bear_trigger = "Got me some new tricks... like me brudda bear....",
	form_bear_message = "80% Phase 2 - Bear Form!",
	form_eagle_trigger = "Dere be no hidin' from da eagle!",
	form_eagle_message = "60% Phase 3 - Eagle Form!",
	form_lynx_trigger = "Let me introduce you to me new bruddas: fang and claw!",
	form_lynx_message = "40% Phase 4 - Lynx Form!",
	form_dragonhawk_trigger = "Ya don' have to look to da sky to see da dragonhawk!",
	form_dragonhawk_message = "20% Phase 5 - Dragonhawk Form!",

	throw = "Grievous Throw",
	throw_desc = "Warn who is afflicted by Grievous Throw.",
	throw_message = "%s has Grievous Throw",
	throw_trigger = "^(%S+) (%S+) afflicted by Grievous Throw%.$",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player afflicted by Grievous Throw or Claw Rage. (requires promoted or higher)",

	paralyze = "Paralyze",
	paralyze_desc = "Warn for Creeping Paralysis and the impending Paralyze after effect.",
	paralyze_warning = "Creeping Paralysis - Paralyze in 5 sec!",
	paralyze_message = "Paralyzed!",
	paralyze_bar = "Inc Paralyze",
	paralyze_trigger = "afflicted by Creeping Paralysis%.$",

	claw = "Claw Rage",
	claw_desc = "Warn for who gets Claw Rage.",
	claw_trigger = "^(%S+) (%S+) afflicted by Claw Rage%.$",
	claw_message = "Claw Rage on %s",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Y'a personne plus balèze que moi !",
	engage_message = "Phase 1 - Forme trolle",

	form = "Changement de forme",
	form_desc = "Préviens quand Zul'jin change de forme.",
	form_bear_trigger = "J'ai des nouveaux tours… comme mon frère ours…",
	form_bear_message = "80% Phase 2 - Forme d'ours !",
	form_eagle_trigger = "L'aigle, il vous trouvera partout !",
	form_eagle_message = "60% Phase 3 - Forme d'aigle !",
	form_lynx_trigger = "J'vous présente mes nouveaux frères : griffe et croc !",
	form_lynx_message = "40% Phase 4 - Forme de lynx !",
	form_dragonhawk_trigger = "Pas besoin d'lever les yeux au ciel pour voir l'faucon-dragon !",
	form_dragonhawk_message = "20% Phase 5 - Forme de faucon-dragon !",

	throw = "Lancer effroyable",
	throw_desc = "Préviens quand un joueur subit les effets du Lancer effroyable.",
	throw_message = "%s a le Lancer effroyable",
	throw_trigger = "^(%S+) (%S+) les effets .* Lancer effroyable%.$",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Lancer effroyable (nécessite d'être promu ou mieux).",

	paralyze = "Paralysie",
	paralyze_desc = "Préviens de l'arrivée de la Paralysie progressive et de la Paralysie qui s'en suit.",
	paralyze_warning = "Paralysie progressive - Paralysie totale dans 5 sec. !",
	paralyze_message = "Paralysés !",
	paralyze_bar = "Paralysie effective",
	paralyze_trigger = "les effets .* Paralysie progressive%.$",

	claw = "Rage de griffes",
	claw_desc = "Préviens quand un joueur subit les effets de la Rage de griffes.",
	claw_trigger = "^(%S+) (%S+) les effets .* Rage de griffes%.$",
	claw_message = "Rage de griffes sur %s",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "누구도 날 넘어설 순 없다!",
	engage_message = "1단계 - 인간형",

	form = "변신 알림",
	form_desc = "줄진이 변신할 때 알립니다.",
	form_bear_trigger = "새로운 기술을 익혔지... 내 형제, 곰처럼...",
	form_bear_message = "80% 2단계 - 곰!",
	form_eagle_trigger = "독수리의 눈을 피할 수는 없다!",
	form_eagle_message = "60% 3단계 - 독수리!",
	form_lynx_trigger = "내 새로운 형제, 송곳니와 발톱을 보아라!",
	form_lynx_message = "40% 4단계 - 스라소니!",
	form_dragonhawk_trigger = "용매를 하늘에서만 찾을 필요는 없다!",
	form_dragonhawk_message = "20% 5단계 - 용매!",

	throw = "치명상",
	throw_desc = "치명상에 걸린 플레이어를 알립니다.",
	throw_message = "%s 치명상",
	throw_trigger = "^([^|;%s]*)(.*)치명상에 걸렸습니다%.$",

	icon = "전술 표시",
	icon_desc = "치명상과 광기의 발톱 대상이된 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	paralyze = "마비",
	paralyze_desc = "마비와 섬뜩한 마비 효과에 대한 경고입니다.",
	paralyze_warning = "섬뜩한 마비 - 마비 5초전!",
	paralyze_message = "마비!",
	paralyze_bar = "잠시후 마비",
	paralyze_trigger = "섬뜩한 마비에 걸렸습니다%.$",

	claw = "광기의 발톱",
	claw_desc = "광기의 발톱에 걸린 플레이어를 알립니다.",
	claw_trigger = "^([^|;%s]*)(.*)광기의 발톱에 걸렸습니다%.$",
	claw_message = "%s 광기의 발톱",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "我最厉害！",
	engage_message = "第一阶段 - 人类阶段",

	form = "形态转变",
	form_desc = "祖尔金变形警报",
	form_bear_trigger = "你看我有许多新招，变个熊……",
	form_bear_message = "80% 第二阶段 - 熊形态!",
	form_eagle_trigger = "变成猎鹰，谁也别想逃出我的眼睛！",
	form_eagle_message = "60% 第三阶段 - 鹰形态!",
	form_lynx_trigger = "现在来让你看看我的尖牙和利爪！",
	form_lynx_message = "40% 第四阶段 - 山猫形态!",
	form_dragonhawk_trigger = "龙鹰，不用抬头就能看见！",
	form_dragonhawk_message = "20% 第五阶段 - 龙鹰形态!",

	throw = "重伤投掷",
	throw_desc = "当受到重伤投掷发出警报",
	throw_message = "重伤投掷: %s",
	throw_trigger = "^(%S+)受(%S+)了重伤投掷效果的影响。$",

	icon = "团队标记",
	icon_desc = "为受到重伤投掷或利爪之怒打上团队标记(需要权限)",

	paralyze = "麻痹蔓延",
	paralyze_desc = "受到麻痹蔓延或中了麻痹发出警报.",
	paralyze_warning = "麻痹蔓延 - 麻痹 5 秒!!",
	paralyze_message = "已麻痹!",
	paralyze_bar = "即将 麻痹",
	paralyze_trigger = "麻痹蔓延效果的影响。$",

	claw = "利爪之怒",
	claw_desc = "受到利爪之怒发出警报",
	claw_trigger = "^(%S+)受(%S+)了利爪之怒效果的影响。$",
	claw_message = "利爪之怒: >%s<",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "沒有人比我更強!",
	engage_message = "階段 1 - 食人妖!",

	form = "型態變換",
	form_desc = "警告祖爾金變換型態",
	form_bear_trigger = "賜給我一些新的力量……讓我像熊一樣……",
	form_bear_message = "80% 階段 2 - 熊型態!",
	form_eagle_trigger = "在雄鷹之下無所遁形!",
	form_eagle_message = "60% 階段 3 - 鷹型態!",
	form_lynx_trigger = "讓我來介紹我的新兄弟:尖牙和利爪!",
	form_lynx_message = "40% 階段 4 - 山貓型態!",
	form_dragonhawk_trigger = "你不需要仰望天空才看得到龍鷹!",
	form_dragonhawk_message = "20% 階段 5 - 龍鷹型態!",

	throw = "嚴重擲傷",
	throw_desc = "警告誰受到了嚴重擲傷.",
	throw_message = "嚴重擲傷：[%s]",
	throw_trigger = "^(.+)受(到[了]*)嚴重擲傷效果的影響。$",

	icon = "標記圖示",
	icon_desc = "為被嚴重擲傷的玩家設置團隊標記（需要權限）",

	paralyze = "慢性麻痹",
	paralyze_desc = "警告慢性麻痹",
	paralyze_warning = "慢性麻痹 - 5 秒後麻痺!",
	paralyze_message = "慢性麻痹!",
	paralyze_bar = "慢性麻痹即將來臨",
	paralyze_trigger = "慢性麻痹效果的影響。$",

	claw = "利爪之怒",
	claw_desc = "警告誰受到利爪之怒",
	claw_trigger = "^(.+)受(到[了]*)利爪之怒效果的影響。$",
	claw_message = "利爪之怒：[%s]",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"form", "paralyze", -1, "throw", "claw", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ZulBleed", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "ZulClaw", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "ZulPara", 5)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	pName = UnitName("player")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not db.form then return end

	if msg == L["form_bear_trigger"] then
		self:Message(L["form_bear_message"], "Urgent")
	elseif msg == L["form_eagle_trigger"] then
		self:Message(L["form_eagle_message"], "Important")
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	elseif msg == L["form_lynx_trigger"] then
		self:Message(L["form_lynx_message"], "Positive")
	elseif msg == L["form_dragonhawk_trigger"] then
		self:Message(L["form_dragonhawk_message"], "Attention")
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	elseif msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Attention")
	end
end

function mod:AfflictEvent(msg)
	if msg:find(L["paralyze_trigger"]) then
		self:Sync("ZulPara")
		return
	end

	local gplayer, gtype = select(3, msg:find(L["throw_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = pName
		end
		self:Sync("ZulBleed", gplayer)
		return
	end

	local cplayer, ctype = select(3, msg:find(L["claw_trigger"]))
	if cplayer and ctype then
		if cplayer == L2["you"] and ctype == L2["are"] then
			cplayer = pName
		end
		self:Sync("ZulClaw", cplayer)
		return
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ZulBleed" and rest and db.throw then
		self:Message(L["throw_message"]:format(rest), "Attention")
		if db.icon then
			self:Icon(rest)
		end
	elseif sync == "ZulClaw" and rest and db.claw then
		self:Message(L["claw_message"]:format(rest), "Urgent")
		if db.icon then
			self:Icon(rest)
		end
	elseif sync == "ZulPara" and db.paralyze then
		self:Message(L["paralyze_warning"], "Urgent")
		self:DelayedMessage(5, L["paralyze_message"], "Positive")
		self:Bar(L["paralyze_bar"], 5, "Spell_Nature_TimeStop")
	end
end
