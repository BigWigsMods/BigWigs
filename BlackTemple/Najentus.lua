------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Warlord Naj'entus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Naj'entus",

	start_trigger = "You will die in the name of Lady Vashj!",

	spine = "Impaling Spine",
	spine_desc = "Tells you who gets impaled.",
	spine_trigger = "^(%S+) (%S+) afflicted by Impaling Spine%.$",
	spine_message = "Impaling Spine on %s!",

	spinesay = "Spine Say",
	spinesay_desc = "Print in say when you have a Spine, can help nearby members with speech bubbles on.",
	spinesay_message = "Spine on me!",

	shield = "Tidal Shield",
	shield_desc = "Timers for when Naj'entus will gain tidal shield.",
	shield_trigger = "High Warlord Naj'entus is afflicted by Tidal Shield.",
	shield_nextbar = "Next Tidal Shield",
	shield_warn = "Tidal Shield!",
	shield_soon_warn = "Tidal Shield in ~10sec!",

	icon = "Icon",
	icon_desc = "Put an icon on players with Impaling Spine.",
} end )

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Im Namen Lady Vashjs werdet Ihr sterben!",

	spine = "Aufspießender Stachel",
	spine_desc = "Sagt euch, wer aufgespießt wird.",
	spine_trigger = "^([^%s]+) ([^%s]+) von Aufspießender Stachel betroffen%.$",
	spine_message = "Aufspießender Stachel auf %s!",

	shield = "Gezeitenschild",
	shield_desc = "Timer f\195\188r Gezeigenschild von Naj'entus.",
	shield_trigger = "Oberster Kriegsf\195\188rst Naj'entus ist von Gezeitenschild betroffen.",
	shield_nextbar = "N\195\164chstes Gezeitenschild",
	shield_warn = "Gezeitenschild!",
	shield_soon_warn = "Gezeitenschild in ~10sec!",

	icon = "Icon",
	icon_desc = "Plaziert ein Icon auf Spielern mit Aufspießendem Stachel.",
} end )

L:RegisterTranslations("koKR", function() return {
	start_trigger = "여군주 바쉬의 이름으로 사형에 처하노라!",

	spine = "꿰뚫는 돌기",
	spine_desc = "꿰뚫는 돌기에 걸린 사람을 알립니다.",
	spine_trigger = "^([^|;%s]*)(.*)꿰뚫는 돌기에 걸렸습니다%.$",
	spine_message = "%s에게 꿰뚫는 돌기!",

	spinesay = "돌기 알림",
	spinesay_desc = "꿰뚫는 돌기에 걸렸을 때, 주변 아군에게 돌기에 걸렸음을 일반 대화로 알립니다.",
	spinesay_message = "저 돌기! 살려주세요!!",

	shield = "해일의 보호막",
	shield_desc = "대장군 나젠투스가 해일의 보호막을 얻을 떄에 대한 타이머 입니다.",
	shield_trigger = "대장군 나젠투스|1이;가; 해일의 보호막에 걸렸습니다.",
	shield_nextbar = "다음 해일의 보호막",
	shield_warn = "해일의 보호막!",
	shield_soon_warn = "약 10초 이내 해일의 보호막!",

	icon = "전술 표시",
	icon_desc = "꿰뚫는 돌기에 걸린 플레이어에게 전술 표시를 지정합니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Vous allez mourir, au nom de dame Vashj !",

	spine = "Epine de perforation",
	spine_desc = "Préviens quand un joueur subit les effets de l'Epine de perforation.",
	spine_trigger = "^(%S+) (%S+) les effets .* Epine de perforation%.$",
	spine_message = "Epine de perforation sur %s !",

	spinesay = "Dire - Epine de perforation",
	spinesay_desc = "Fais dire à votre personnage qu'il a une épine quand c'est le cas, afin d'aider les membres proches.",
	spinesay_message = "Epine sur moi !",

	shield = "Bouclier de flots",
	shield_desc = "Délais concernant le Bouclier de flots de Naj'entus.",
	shield_trigger = "Grand seigneur de guerre Naj'entus subit les effets .* Bouclier de flots.",
	shield_nextbar = "Prochain Bouclier de flots",
	shield_warn = "Bouclier de flots !",
	shield_soon_warn = "Bouclier de flots dans ~10 sec. !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Epine de perforation (nécessite d'être promu ou mieux).",
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
--高阶督军纳因图斯
--Lady Vashj 瓦丝琪
L:RegisterTranslations("zhCN", function() return {
	start_trigger = "You will die in the name of Lady Vashj!",

	spine = "穿刺之脊",--Impaling Spine 穿刺之脊
	spine_desc = "谁中了穿刺时告诉你.",
	spine_trigger = "^([^%s]+)受([^%s]+)了穿刺之脊效果的影响。$",
	spine_message = "穿刺之脊 %s!",

	spinesay = "穿刺警报",--Spine Say
	spinesay_desc = "当你中了穿刺会自动喊话,能帮助周围队员避让.",
	spinesay_message = "穿刺 我了 XO!",

	shield = "海潮之盾",--Tidal Shield 海潮之盾
	shield_desc = "当纳因图斯获得海潮之盾后计时.",
	shield_trigger = "高阶督军纳因图斯受到了海潮之盾效果的影响",
	shield_nextbar = "下一次 海潮之盾",
	shield_warn = "海潮之盾!",
	shield_soon_warn = "海潮之盾 ~10秒 后发动!",

	icon = "团队标记",
	icon_desc = "给中了穿刺之脊的玩家打上团队标记.",
} end )

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "你會以瓦許女士之名而死!",

	spine = "尖刺脊椎",
	spine_desc = "告訴你誰獲得尖刺脊椎",
	spine_trigger = "^(.+)受到(了?)尖刺脊椎效果的影響。$",
	spine_message = "Impaling Spine on %s!",

	spinesay = "Spine Say",
	spinesay_desc = "Print in say when you have a Spine, can help nearby members with speech bubbles on.",
	spinesay_message = "Spine on me!",

	shield = "潮汐之盾",
	shield_desc = "Timers for when Naj'entus will gain tidal shield.",
	shield_trigger = "高階督軍納珍塔斯受到潮汐之盾",
	shield_nextbar = "下一次潮汐之盾",
	shield_warn = "潮汐之盾!",
	shield_soon_warn = "潮汐之盾在 ~10秒內施放!",

	icon = "Icon",
	icon_desc = "Put an icon on players with Impaling Spine.",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "shield", "spine", "spinesay", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Spine")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Spine")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Spine")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NajShieldOn", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NajSpine", 2)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		if self.db.profile.shield then
			self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
			self:Bar(L["shield_nextbar"], 60, "Spell_Frost_FrostBolt02")
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 8), "Attention")
			self:DelayedMessage(180, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(300, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(450, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(470, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(475, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(480, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 480, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["shield_trigger"] then
		self:Sync("NajShieldOn")
	end
end

function mod:Spine(msg)
	local splayer, stype = select(3, msg:find(L["spine_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = UnitName("player")
			if self.db.profile.spinesay then
				SendChatMessage(L["spinesay_message"], "SAY")
			end
		end
		self:Sync("NajSpine " .. splayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "NajSpine" and rest and self.db.profile.spine then
		self:Message(L["spine_message"]:format(rest), "Important", nil, "Alert")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "NajShieldOn" and self.db.profile.shield then
		self:Message(L["shield_warn"], "Important", nil, "Alert")
		self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
		self:Bar(L["shield_nextbar"], 60, "Spell_Frost_FrostBolt02")
	end
end
