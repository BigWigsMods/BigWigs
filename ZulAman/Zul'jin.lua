------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Zul'jin"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local pName = nil

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
	form_bear_message = "80%% Phase 2 - Bear Form!",
	form_eagle_trigger = "Dere be no hidin' from da eagle!",
	form_eagle_message = "60%% Phase 3 - Eagle Form!",
	form_lynx_trigger = "Let me introduce you to me new bruddas: fang and claw!",
	form_lynx_message = "40%% Phase 4 - Lynx Form!",
	form_dragonhawk_trigger = "Ya don' have to look to da sky to see da dragonhawk!",
	form_dragonhawk_message = "20%% Phase 5 - Dragonhawk Form!",

	throw = "Grievous Throw",
	throw_desc = "Warn who is afflicted by Grievous Throw.",
	throw_message = "%s has Grievous Throw",
	throw_trigger = "^(%S+) (%S+) afflicted by Grievous Throw%.$",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player afflicted by Grievous Throw. (requires promoted or higher)",

	paralyze = "Paralyze",
	paralyze_desc = "Warn for Creeping Paralysis and the impending Paralyze after effect.",
	paralyze_warning = "Creeping Paralysis - Paralyze in 5 sec!",
	paralyze_message = "Paralyzed!",
	paralyze_bar = "Inc Paralyze",
	paralyze_trigger = "afflicted by Creeping Paralysis%.$",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Y'a personne plus balèze que moi !",
	engage_message = "Phase 1 - Forme trolle",

	form = "Changement de forme",
	form_desc = "Préviens quand Zul'jin change de forme.",
	form_bear_trigger = "J'ai des nouveaux tours… comme mon frère ours…",
	form_bear_message = "Phase 2 - Forme d'ours !",
	form_eagle_trigger = "L'aigle, il vous trouvera partout !",
	form_eagle_message = "Phase 3 - Forme d'aigle !",
	form_lynx_trigger = "J'vous présente mes nouveaux frères : griffe et croc !",
	form_lynx_message = "Phase 4 - Forme de lynx !",
	form_dragonhawk_trigger = "Pas besoin d'lever les yeux au ciel pour voir l'faucon-dragon !",
	form_dragonhawk_message = "Phase 5 - Forme de faucon-dragon !",

	--throw = "Grievous Throw",
	--throw_desc = "Warn who is afflicted by Grievous Throw.",
	--throw_message = "%s has Grievous Throw",
	--throw_trigger = "^(%S+) (%S+) afflicted by Grievous Throw%.$",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player afflicted by Grievous Throw. (requires promoted or higher)",

	--paralyze = "Paralyze",
	--paralyze_desc = "Warn for Creeping Paralysis and the impending Paralyze after effect.",
	--paralyze_warning = "Creeping Paralysis - Paralyze in 5 sec!",
	--paralyze_message = "Paralyzed!",
	--paralyze_bar = "Inc Paralyze",
	--paralyze_trigger = "afflicted by Creeping Paralysis%.$",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "누구도 날 넘어설 순 없다!",
	engage_message = "1단계 - 인간형",

	form = "변신 알림",
	form_desc = "줄진이 변신할 때 알립니다.",
	form_bear_trigger = "새로운 기술을 익혔지... 내 형제의 곰처럼...",  -- Check
	form_bear_message = "2단계 - 곰!",
	form_eagle_trigger = "독수리의 눈을 피할수는 없다!",  -- Check
	form_eagle_message = "3단계 - 독수리!",
	form_lynx_trigger = "내 새로운 형제... 송곳니와 발톱을 보아라!",  -- Check
	form_lynx_message = "4단계 - 스라소니!",
	form_dragonhawk_trigger = "용매를 하늘에서만 찾을 필요는 없다!",  -- Check
	form_dragonhawk_message = "5단계 - 용매!",

	--throw = "Grievous Throw",
	--throw_desc = "Warn who is afflicted by Grievous Throw.",
	--throw_message = "%s has Grievous Throw",
	--throw_trigger = "^(%S+) (%S+) afflicted by Grievous Throw%.$",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player afflicted by Grievous Throw. (requires promoted or higher)",

	--paralyze = "Paralyze",
	--paralyze_desc = "Warn for Creeping Paralysis and the impending Paralyze after effect.",
	--paralyze_warning = "Creeping Paralysis - Paralyze in 5 sec!",
	--paralyze_message = "Paralyzed!",
	--paralyze_bar = "Inc Paralyze",
	--paralyze_trigger = "afflicted by Creeping Paralysis%.$",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "Nobody badduh dan me!",
	engage_message = "第一阶段 - 人类阶段",

	form = "形态转变",
	form_desc = "Zul'jin变形警报",
	form_bear_trigger = "Got me some new tricks... like me brudda bear....",
	form_bear_message = "第二阶段 - 熊形态!",
	form_eagle_trigger = "Dere be no hidin' from da eagle!",
	form_eagle_message = "第三阶段 - 鹰形态!",
	form_lynx_trigger = "Let me introduce you to me new bruddas: fang and claw!",
	form_lynx_message = "第四阶段 - 山猫形态!",
	form_dragonhawk_trigger = "Ya don' have to look to da sky to see da dragonhawk!",
	form_dragonhawk_message = "第五阶段 - 龙鹰形态!",

	--throw = "Grievous Throw",
	--throw_desc = "Warn who is afflicted by Grievous Throw.",
	--throw_message = "%s has Grievous Throw",
	--throw_trigger = "^(%S+) (%S+) afflicted by Grievous Throw%.$",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player afflicted by Grievous Throw. (requires promoted or higher)",

	--paralyze = "Paralyze",
	--paralyze_desc = "Warn for Creeping Paralysis and the impending Paralyze after effect.",
	--paralyze_warning = "Creeping Paralysis - Paralyze in 5 sec!",
	--paralyze_message = "Paralyzed!",
	--paralyze_bar = "Inc Paralyze",
	--paralyze_trigger = "afflicted by Creeping Paralysis%.$",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"form", "paralyze", -1, "throw", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ZulBleed", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "ZulPara", 5)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Bleed")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Bleed")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Bleed")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.form then return end

	if msg == L["form_bear_trigger"] then
		self:Message(L["form_bear_message"], "Urgent")
	elseif msg == L["form_eagle_trigger"] then
		self:Message(L["form_eagle_message"], "Important")
	elseif msg == L["form_lynx_trigger"] then
		self:Message(L["form_lynx_message"], "Positive")
	elseif msg == L["form_dragonhawk_trigger"] then
		self:Message(L["form_dragonhawk_message"], "Attention")
	elseif msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Attention")
	end
end

function mod:Bleed(msg)
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
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ZulBleed" and rest and self.db.profile.throw then
		self:Message(L["throw_message"]:format(rest), "Attention")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "ZulPara" and self.db.profile.paralyze then
		self:Message(L["paralyze_warning"], "Urgent")
		self:DelayedMessage(5, L["paralyze_message"], "Positive")
		self:Bar(L["paralyze_bar"], 5, "Spell_Nature_TimeStop")
	end
end
