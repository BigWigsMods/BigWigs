------------------------------
--      Are you local?    --
------------------------------

local boss = BB["High Warlord Naj'entus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local CheckInteractDistance = CheckInteractDistance
local fmt = string.format

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Naj'entus",

	start_trigger = "You will die in the name of Lady Vashj!",

	spine = "Impaling Spine",
	spine_desc = "Tells you who gets impaled.",
	spine_message = "Impaling Spine on %s!",

	spinesay = "Spine Say",
	spinesay_desc = "Print in say when you have a Spine, can help nearby members with speech bubbles on.",
	spinesay_message = "Spine on me!",

	shield = "Tidal Shield",
	shield_desc = "Timers for when Naj'entus will gain tidal shield.",
	shield_nextbar = "Next Tidal Shield",
	shield_warn = "Tidal Shield!",
	shield_soon_warn = "Tidal Shield in ~10sec!",
	shield_fade = "Shield Faded!",

	icon = "Icon",
	icon_desc = "Put an icon on players with Impaling Spine.",
} end )

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Im Namen Lady Vashjs werdet Ihr sterben!",

	spine = "Aufspießender Stachel",
	spine_desc = "Sagt euch, wer aufgespießt wird.",
	spine_message = "Aufspießender Stachel auf %s!",

	spinesay = "Stachel Sagen",
	spinesay_desc = "Schreibe in /sagen wenn du das Ziel vom Aufspießender Stachel bist, dies kann angrenzenden Membern mit aktivierten Sprechblasen helfen.",
	spinesay_message = "Stachel auf mir!",

	shield = "Gezeitenschild",
	shield_desc = "Timer für Gezeigenschild von Naj'entus.",
	shield_nextbar = "Nächstes Gezeitenschild",
	shield_warn = "Gezeitenschild!",
	shield_soon_warn = "Gezeitenschild in ~10sek!",
	shield_fade = "Gezeitenschild schwindet!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Icon auf Spielern mit Aufspießendem Stachel (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("koKR", function() return {
	start_trigger = "여군주 바쉬의 이름으로 사형에 처하노라!",

	spine = "꿰뚫는 돌기",
	spine_desc = "꿰뚫는 돌기에 걸린 사람을 알립니다.",
	spine_message = "%s에게 꿰뚫는 돌기!",

	spinesay = "돌기 알림",
	spinesay_desc = "꿰뚫는 돌기에 걸렸을 때, 주변 아군에게 돌기에 걸렸음을 일반 대화로 알립니다.",
	spinesay_message = "저 돌기! 살려주세요!!",

	shield = "해일의 보호막",
	shield_desc = "대장군 나젠투스가 해일의 보호막을 얻을 떄에 대한 타이머 입니다.",
	shield_nextbar = "다음 해일의 보호막",
	shield_warn = "해일의 보호막!",
	shield_soon_warn = "약 10초 이내 해일의 보호막!",
	shield_fade = "보호막 사라짐!",

	icon = "전술 표시",
	icon_desc = "꿰뚫는 돌기에 걸린 플레이어에게 전술 표시를 지정합니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Vous allez mourir, au nom de dame Vashj !",

	spine = "Epine de perforation",
	spine_desc = "Préviens quand un joueur subit les effets de l'Epine de perforation.",
	spine_message = "Epine de perforation sur %s !",

	spinesay = "Dire - Epine de perforation",
	spinesay_desc = "Fais dire à votre personnage qu'il a une épine quand c'est le cas afin d'aider les membres proches.",
	spinesay_message = "Épine sur moi !",

	shield = "Bouclier de flots",
	shield_desc = "Délais concernant le Bouclier de flots de Naj'entus.",
	shield_nextbar = "Prochain Bouclier de flots",
	shield_warn = "Bouclier de flots !",
	shield_soon_warn = "Bouclier de flots dans ~10 sec. !",
	shield_fade = "Bouclier dissipé !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Epine de perforation (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("zhCN", function() return {
	start_trigger = "以瓦丝琪女王的名义，去死吧！",

	spine = "穿刺之脊",
	spine_desc = "当玩家受到穿刺时通知你。",
	spine_message = "穿刺之脊：>%s<！",

	spinesay = "穿刺警报",
	spinesay_desc = "当你受到穿刺时发出喊话，能帮助周围队员避让。",
	spinesay_message = "我中了穿刺！",

	shield = "海潮之盾",
	shield_desc = "当获得海潮之盾后计时。",
	shield_nextbar = "<下一海潮之盾>",
	shield_warn = "海潮之盾！",
	shield_soon_warn = "海潮之盾！约10秒后发动。",
	shield_fade = "海潮之盾 消失！",

	icon = "团队标记",
	icon_desc = "给中了穿刺之脊的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "你會以瓦許女士之名而死!",

	spine = "尖刺脊椎",
	spine_desc = "通知你誰受到尖刺脊椎",
	spine_message = "尖刺脊椎：[%s]",

	spinesay = "尖刺脊椎通報",
	spinesay_desc = "當你中了尖刺脊椎會時自動喊話，讓周圍隊友幫忙。",
	spinesay_message = "我中刺了！麻煩拔一下！",

	shield = "潮汐之盾",
	shield_desc = "潮汐之盾計時",
	shield_nextbar = "下一次潮汐之盾",
	shield_warn = "潮汐之盾!",
	shield_soon_warn = "潮汐之盾在 约10秒內施放!",
	shield_fade = "潮汐之盾消失!",

	icon = "團隊標記",
	icon_desc = "在受到尖刺脊椎的隊友頭上標記。",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "shield", -1, "spine", "spinesay", "icon", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 2 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "ShieldOn", 39872)
	self:AddCombatListener("SPELL_AURA_REMOVED", "ShieldOff", 39872)
	self:AddCombatListener("SPELL_AURA_APPLIED", "ImpalingSpine", 39837)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:ShieldOn(_, spellID)
	if db.shield then
		self:IfMessage(L["shield_warn"], "Important", spellID, "Alert")
		self:DelayedMessage(46, L["shield_soon_warn"], "Positive")
		self:Bar(L["shield_nextbar"], 56, spellID)
	end
end

function mod:ShieldOff()
	if db.shield then
		self:IfMessage(L["shield_fade"], "Positive", 39872)
	end
end

function mod:ImpalingSpine(player, spellID)
	if db.spine then
		if UnitIsUnit(player, "player") and db.spinesay then
			SendChatMessage(L["spinesay_message"], "SAY")
		end
		self:IfMessage(fmt(L["spine_message"], player), "Important", spellID, "Alert")
		self:Icon(player, "icon")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		if db.shield then
			self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
			self:Bar(L["shield_nextbar"], 60, "Spell_Frost_FrostBolt02")
		end
		if db.enrage then
			self:Enrage(480)
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

