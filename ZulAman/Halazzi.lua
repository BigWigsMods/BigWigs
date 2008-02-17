------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Halazzi"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local UnitName = UnitName
local UnitHealth = UnitHealth
local one = nil
local two = nil
local three = nil
local count = 1
local db = nil
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Halazzi",

	engage_trigger = "Get on ya knees and bow.... to da fang and claw!",

	totem = "Totem",
	totem_desc = "Warn when Halazzi casts a Lightning Totem.",
	totem_trigger = "Halazzi  begins to cast Lightning Totem.",
	totem_message = "Incoming Lightning Totem!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase_spirit = "I fight wit' untamed spirit....",
	phase_normal = "Spirit, come back to me!",
	normal_message = "Normal Phase!",
	spirit_message = "%d%% HP! - Spirit Phase!",
	spirit_soon = "Spirit Phase soon!",
	spirit_bar = "~Possible Normal Phase",

	frenzy = "Frenzy",
	frenzy_desc = "Frenzy alert.",
	frenzy_trigger = "%s goes into a killing frenzy!",
	frenzy_message = "Frenzy!",

	flame = "Flame Shock",
	flame_desc = "Warn for players with Flame Shock.",
	flame_trigger = "^(%S+) (%S+) afflicted by Flame Shock%.$",
	flame_fade = "^Flame Shock fades from (%S+)%.$",
	flame_message = "Flame Shock: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Flame Shock. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "무릎 꿇고 경배하라... 송곳니와 발톱에!",

	totem = "토템",
	totem_desc = "할라지가 번개 토템을 소환시 알립니다.",
	totem_trigger = "할라지|1이;가; 번개 토템 시전을 시작합니다.",
	totem_message = "토템 소환!",

	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	phase_spirit = "야생의 혼이 내 편이다...",
	phase_normal = "혼이여, 이리 돌아오라!",
	normal_message = "보통 단계!",
	spirit_message = "%d%% HP! - 영혼 단계!",
	spirit_soon = "곧 영혼 단계!",
	spirit_bar = "~보통 단계",

	frenzy = "광기",
	frenzy_desc = "광기 경고.",
	frenzy_trigger = "%s|1이;가; 죽일 듯한 기세로 격분합니다!",
	frenzy_message = "광기!",

	flame = "화염 충격",
	flame_desc = "화염 충격에 걸린 플레이어를 알립니다.",
	flame_trigger = "^([^|;%s]*)(.*)화염 충격에 걸렸습니다%.$",
	flame_fade = "^([^%s]+)의 몸에서 화염 충격 효과가 사라졌습니다%.$",
	flame_message = "화염 충격: %s",

	icon = "전술 표시",
	icon_desc = "화염 충격의 대상이된 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "À genoux, les idiots… devant la griffe et le croc !",

	totem = "Totem",
	totem_desc = "Préviens quand Halazzi incante un Totem de foudre.",
	totem_trigger = "Halazzi commence à lancer Totem de foudre.",
	totem_message = "Arrivée d'un Totem de foudre !",

	phase = "Phase",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase_spirit = "L'esprit en moi, il est indompté…",
	phase_normal = "Esprit, reviens à moi !",
	normal_message = "Phase normale !",
	spirit_message = "%d%% PV ! - Phase esprit !",
	spirit_soon = "Phase esprit imminente !",
	spirit_bar = "~Phase normale probable",

	frenzy = "Frénésie",
	frenzy_desc = "Préviens quand Halazzi entre en frénésie.",
	frenzy_trigger = "%s part dans une frénésie meurtrière !",
	frenzy_message = "Frénésie !",

	flame = "Horion de flammes",
	flame_desc = "Préviens quand un joueur subit les effets de l'Horion de flammes.",
	flame_trigger = "^(%S+) (%S+) les effets .* Horion de flammes%.$",
	flame_fade = "^Horion de flammes sur (%S+) vient de se dissiper%.$",
	flame_message = "Horion de flammes : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Horion de flammes (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "在利爪与尖牙面前，下跪吧，祈祷吧，颤栗吧！",

	totem = "图腾",
	totem_desc = "当哈尔拉兹施放一闪电图腾时发出警报。",
	totem_trigger = "哈尔拉兹开始施放闪电图腾。",
	totem_message = "即将 闪电图腾！",

	phase = "阶段",
	phase_desc = "阶段变化警报。",
	phase_spirit = "狂野的灵魂与我同在……",
	phase_normal = "灵魂，到我这里来！",
	normal_message = "正常阶段！",
	spirit_message = "%d%% 生命值！ - 灵魂阶段！",
	spirit_soon = "即将灵魂阶段！",
	spirit_bar = "<可能 正常阶段>",

	frenzy = "狂乱",
	frenzy_desc = "狂乱警报。",
	frenzy_trigger = "%s获得了狂乱的效果。",
	frenzy_message = "哈尔拉玆 狂乱！",

	flame = "烈焰震击",
	flame_desc = "当玩家受到烈焰震击发出警报。",
	flame_trigger = "^(.+)受(.+)了烈焰震击效果的影响。$",
	flame_fade = "^烈焰震击效果从(.+)身上消失。$",
	flame_message = "烈焰震击：>%s<！",

	icon = "团队标记",
	icon_desc = "使用团队标记标出受烈焰震击的玩家。(需要权限)",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "在利爪與尖牙面前下跪吧，祈禱吧，顫慄吧!",

	totem = "圖騰",
	totem_desc = "警告哈拉齊施放閃電圖騰",
	totem_trigger = "哈拉齊開始施放閃電圖騰。",
	totem_message = "閃電圖騰即將來臨!",

	phase = "階段",
	phase_desc = "警告階段變換",
	phase_spirit = "狂野的靈魂與我同在......",
	phase_normal = "靈魂，回到我這裡來!",
	normal_message = "普通階段!",
	spirit_message = "%d%% HP! - 靈魂階段!",
	spirit_soon = "靈魂階段即將來臨!",
	spirit_bar = "~可能普通階段",

	frenzy = "狂亂",
	frenzy_desc = "狂亂警報",
	frenzy_trigger = "%s變得極為狂暴!",
	frenzy_message = "狂亂!",

	flame = "烈焰震擊",
	flame_desc = "警報玩家受到烈焰震擊",
	flame_trigger = "^(.+)受(到[了]*)烈焰震擊效果的影響。$",
	flame_fade = "^烈焰震擊效果從(.+)身上消失。$",
	flame_message = "烈焰震擊: [%s]",

	icon = "團隊標記",
	icon_desc = "為被烈焰震擊的玩家設置團隊標記（需要權限）",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "\194\161Arrodillaos... ante la garra y el colmillo!",

	totem = "T\195\179tem",
	totem_desc = "Avisa cuando Halazzi lanza un T\195\179tem de rel\195\161mpagos.",
	totem_trigger = "Halazzi comienza a lanzar T\195\179tem de rel\195\161mpagos.",
	totem_message = "\194\161T\195\179tem de rel\195\161mpagos!",

	phase = "Fases",
	phase_desc = "Avis los cambios de fase.",
	phase_spirit = "Lucho con libertad de esp\195\173ritu...",
	phase_normal = "\194\161Esp\195\173ritu, vuelve a m\195\173!",
	normal_message = "\194\161Fase Normal!",
	spirit_message = "\194\161%d%% PV! - Fase Espirit\195\186!",
	spirit_soon = "\194\161Fase Espirit\195\186 pronto!",
	spirit_bar = "~Posible Fase Normal",

	--frenzy = "Frenzy",
	--frenzy_desc = "Frenzy alert.",
	--frenzy_trigger = "Halazzi gains Frenzy.",
	--frenzy_message = "Frenzy!",

	--flame = "Flame Shock",
	--flame_desc = "Warn for players with Flame Shock.",
	--flame_trigger = "^(%S+) (%S+) afflicted by Flame Shock%.$",
	--flame_fade = "^Flame Shock fades from (%S+)%.$",
	--flame_message = "Flame Shock: %s",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player with Flame Shock. (requires promoted or higher)",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Auf die Knie und verneigt Euch... vor den Reißzähnen und der Klaue!",

	totem = "Blitzschlagtotem",
	totem_desc = "Warnt wenn Halazzi ein Verderbtes Blitzschlagtotem herbeizaubert.",
	totem_trigger = "Halazzi beginnt Blitzschlagtotem zu wirken.",
	totem_message = "Blitzschlagtotem gleich!",

	phase = "Phasen",
	phase_desc = "Warnung bei Phasenänderrungen.",
	phase_spirit = "Ich kämpfe mit wildem Geist...",
	phase_normal = "Geist, zurück zu mir!",
	normal_message = "Normale Phase!",
	spirit_message = "%d%% HP! - Geist Phase!",
	spirit_soon = "Geist Phase bald!",
	spirit_bar = "~Mögliche Normale Phase",

	frenzy = "Blutrausch",
	frenzy_desc = "Blutrausch Alarm.",
	frenzy_trigger = "%s gerät in einen Blutrausch!",
	frenzy_message = "Blutrausch!",

	flame = "Flammenschock",
	flame_desc = "Warnen wenn ein Spieler von Flammenschock betroffen ist.",
	flame_trigger = "^(%S+) (%S+) ist von Flammenschock betroffen%.$",
	flame_fade = "^Flammenschock' schwindet von (%S+)%.$",
	flame_message = "Flammenschock: %s",

	icon = "Schlachtzug Symbol",
	icon_desc = "Platziere ein Schlachtzugsymbol auf dem Spieler, der von Flammenschock betroffen ist (benötigt Assistent oder höher).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"totem", "phase", "frenzy", -1, "flame", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "FlameEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "FlameEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "FlameEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "FlameFade")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FlameFade")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if db.totem and msg == L["totem_trigger"] then
		self:Message(L["totem_message"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["frenzy_trigger"] and db.frenzy then
		self:Message(L["frenzy_message"], "Important")
		self:Bar(L["frenzy_message"], 6, "Ability_GhoulFrenzy")
	end
end

function mod:FlameEvent(msg)
	if not db.flame then return end

	local fplayer, ftype = select(3, msg:find(L["flame_trigger"]))
	if fplayer and ftype then
		if fplayer == L2["you"] and ftype == L2["are"] then
			fplayer = pName
		end
		local warn = L["flame_message"]:format(fplayer)
		self:Message(warn, "Attention")
		self:Bar(warn, 12, "Spell_Fire_FlameShock")
		if db.icon then
			self:Icon(fplayer)
		end
	end
end

function mod:FlameFade(msg)
	local splayer = select(3, msg:find(L["flame_fade"]))
	if splayer then
		self:TriggerEvent("BigWigs_StopBar", self, L["flame_message"]:format(splayer))
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if msg:find(L["flame_fade"]) then
		self:TriggerEvent("BigWigs_StopBar", self, L["flame_message"]:format(pName))
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not db.phase then return end

	if msg == L["phase_spirit"] then
		if count == 1 then
			self:Message(L["spirit_message"]:format(75), "Urgent")
			count = count + 1
		elseif count == 2 then
			self:Message(L["spirit_message"]:format(50), "Urgent")
			count = count + 1
		elseif count == 3 then
			self:Message(L["spirit_message"]:format(25), "Urgent")
		end
		self:Bar(L["spirit_bar"], 50, "Spell_Nature_Regenerate")
	elseif msg == L["phase_normal"] then
		self:Message(L["normal_message"], "Attention")
	elseif msg == L["engage_trigger"] then
		count = 1
		one = nil
		two = nil
		three = nil
		if db.enrage then
			self:Enrage(600)
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.phase then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if not one and health > 77 and health <= 80 then
			one = true
			self:Message(L["spirit_soon"], "Positive")
		elseif not two and health > 52 and health <= 55 then
			two = true
			self:Message(L["spirit_soon"], "Positive")
		elseif not three and health > 27 and health <= 30 then
			three = true
			self:Message(L["spirit_soon"], "Positive")
		end
	end
end

