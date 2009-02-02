------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Sapphiron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local breath = 1
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sapphiron",

	deepbreath = "Ice Bomb",
	deepbreath_desc = "Warn when Sapphiron begins to cast Ice Bomb.",
	airphase_trigger = "Sapphiron lifts off into the air!",
	deepbreath_incoming_message = "Ice Bomb casting in ~14sec!",
	deepbreath_incoming_soon_message = "Ice Bomb casting in ~5sec!",
	deepbreath_incoming_bar = "Ice Bomb Cast",
	deepbreath_trigger = "%s takes a deep breath.",
	deepbreath_warning = "Ice Bomb Incoming!",
	deepbreath_bar = "Ice Bomb Lands!",

	lifedrain = "Life Drain",
	lifedrain_desc = "Warns about the Life Drain curse.",
	lifedrain_message = "Life Drain! Next in ~24sec!",
	lifedrain_warn1 = "Life Drain in ~5sec!",
	lifedrain_bar = "~Possible Life Drain",

	icebolt = "Icebolt",
	icebolt_desc = "Yell when you are an Icebolt.",
	icebolt_other = "Block: %s",
	icebolt_yell = "I'm a Block!",

	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	ping_message = "Block - Pinging your location!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
} end )

L:RegisterTranslations("ruRU", function() return {
	deepbreath = "Ледяная бомба",
	deepbreath_desc = "Предупреждать о ледяной бомбе Сапфирона",
	airphase_trigger = "%s взмывает в воздух!",
	deepbreath_incoming_message = "Ледяная бомба через 23 секунды!",
	deepbreath_incoming_soon_message = "Ледяная бомба через 5 секунд!",
	deepbreath_incoming_bar = "Каст ледяной бомбы",
	deepbreath_trigger = "%s глубоко вздыхает.",  
	deepbreath_warning = "Появляется ледяная бомба!",
	deepbreath_bar = "Приземляется ледяная бомба!",

	lifedrain = "Похищение жизни",
	lifedrain_desc = "Предупреждать о похищении жизни",
	lifedrain_message = "Похищение жизни! Следующее через 24 секунды!",
	lifedrain_warn1 = "Похищение жизни через 5 секунд!",
	lifedrain_bar = "~Возможное похищение жизни",

	icebolt = "Морозная стрела",
	icebolt_desc = "Предупреждать о морозной стреле на Вас.",
	icebolt_other = "Глыба: %s",
	icebolt_yell = "Я в глыбе!",

	ping = "Пинг",
	ping_desc = "Отмечать ваше текущеее положение пингом, если вы находитесь в глыбе после морозной стрелы.",
	ping_message = "Глыба - отмечаю положение!",

	icon = "Отмечать иконкой",
	icon_desc = "Отмечать рейдовой иконой игрока, попавшего в глыбу после морозной стрелы (необходимо быть лидером группы или рейда)",
} end )

L:RegisterTranslations("koKR", function() return {
	deepbreath = "얼음 폭탄",
	deepbreath_desc = "사피론 의 얼음 폭탄 시전을 알립니다.",
	airphase_trigger = "사피론이 공중으로 떠오릅니다!",
	deepbreath_incoming_message = "약 14초 이내 얼음 폭탄 시전!",
	deepbreath_incoming_soon_message = "약 5초 이내 얼음 폭탄 시전!",
	deepbreath_incoming_bar = "얼음 폭탄 시전",
	deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이마십니다.",
	deepbreath_warning = "잠시 후 얼음 폭탄!",
	deepbreath_bar = "얼음 폭탄 떨어짐!",

	lifedrain = "생명력 흡수",
	lifedrain_desc = "생명력 흡수 저주를 알립니다.",
	lifedrain_message = "생명력 흡수! 다음은 약 24초 이내!",
	lifedrain_warn1 = "약 5초 이내 생명력 흡수!",
	lifedrain_bar = "~생명력 흡수 가능",

	icebolt = "얼음 화살",
	icebolt_desc = "얼음 화살에 얼렸을때 외침으로 알립니다.",
	icebolt_other = "방패: %s",
	icebolt_yell = "저 방패에요!",

	ping = "미니맵 표시",
	ping_desc = "자신이 얼음 화살에 걸렸을 때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "방패 - 현재 위치 미니맵에 표시 중!",

	icon = "전술 표시",
	icon_desc = "얼음 화살 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("deDE", function() return {
	deepbreath = "Frostatem",
	deepbreath_desc = "Warnungen und Timer für Frostatem.",
	airphase_trigger = "Saphiron erhebt sich in die Lüfte!", -- No %s in deDE, we need the translated name!
	deepbreath_incoming_message = "Frostatem in ~23 sek!",
	deepbreath_incoming_soon_message = "Frostatem in ~5 sek!",
	deepbreath_incoming_bar = "Wirkt Frostatem...",
	deepbreath_trigger = "%s holt tief Luft.",
	deepbreath_warning = "Frostatem kommt!",
	deepbreath_bar = "Frostatem landet!",

	lifedrain = "Lebensentzug", -- aka "Lebenssauger", Blizzard's inconsistence
	lifedrain_desc = "Warnungen und Timer für den Lebensentzug Fluch.",
	lifedrain_message = "Lebensentzug! Nächster in ~24 sek!",
	lifedrain_warn1 = "Lebensentzug in ~5 sek!",
	lifedrain_bar = "~Lebensentzug",

	icebolt = "Eisblitz",
	icebolt_desc = "Schreit, wenn du von Eisblitz betroffen bist.",
	icebolt_other = "Eisblock: %s",
	icebolt_yell = "Ich bin ein Eisblock!",

	ping = "Ping",
	ping_desc = "Die derzeitige Position pingen, wenn du von Eisblitz betroffen bist.",
	ping_message = "Eisblock - Pinge deine Position!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Eisblitz gewirkt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	deepbreath = "冰霜吐息",
	deepbreath_desc = "当施放冰霜吐息时发出警报。",
	--airphase_trigger = "%s lifts off into the air!",
	deepbreath_incoming_message = "约14秒后，冰霜吐息！",
	deepbreath_incoming_soon_message = "约5秒后，冰霜吐息！",
	deepbreath_incoming_bar = "<施放 冰霜吐息>",
	deepbreath_trigger = "%s深深地吸了一口气……", 
	deepbreath_warning = "即将 冰霜吐息！",
	deepbreath_bar = "<冰霜吐息 落地>",

	lifedrain = "生命吸取",
	lifedrain_desc = "当施放生命吸取时候发出警报。",
	lifedrain_message = "约24秒后，生命吸取！",
	lifedrain_warn1 = "5秒后，生命吸取！",
	lifedrain_bar = "<生命吸取>",

	icebolt = "寒冰屏障",
	icebolt_desc = "当玩家中了寒冰屏障时发出大喊警报。",
	icebolt_other = "寒冰屏障：>%s<！",
	icebolt_yell = "我是寒冰屏障！快躲到我后面！",

	ping = "点击",
	ping_desc = "当你中了寒冰屏障时点击当前所在位置。",
	ping_message = "寒冰屏障 - 点击你的位置！",

	icon = "团队标记",
	icon_desc = "为中了寒冰屏障的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	deepbreath = "冰息術",
	deepbreath_desc = "當施放冰息術時發出警報。",
	--airphase_trigger = "%s lifts off into the air!",
	deepbreath_incoming_message = "約14秒後，冰息術！",
	deepbreath_incoming_soon_message = "約5秒後，冰息術！",
	deepbreath_incoming_bar = "<施放 冰息術>",
	deepbreath_trigger = "%s深深地吸了一口氣……",
	deepbreath_warning = "即將 冰息術！",
	deepbreath_bar = "<冰息術 落地>",

	lifedrain = "生命吸取",
	lifedrain_desc = "當施放生命吸取時發出警報。",
	lifedrain_message = "約24秒後，生命吸取！",
	lifedrain_warn1 = "5秒後，生命吸取！",
	lifedrain_bar = "<生命吸取>",

	icebolt = "寒冰凍體",
	icebolt_desc = "當玩家中了寒冰凍體時發出大喊警報。",
	icebolt_other = "寒冰凍體：>%s<！",
	icebolt_yell = "我是寒冰凍體！快躲到我後面！",

	ping = "點擊",
	ping_desc = "當你中了寒冰凍體時點擊當前所在位置。",
	ping_message = "寒冰凍體 - 點擊你的位置！",

	icon = "團隊標記",
	icon_desc = "為中了寒冰凍體的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("frFR", function() return {
	deepbreath = "Bombe de glace",
	deepbreath_desc = "Prévient quand Saphiron commence à lancer sa Bombe de glace.",
	airphase_trigger = "%s s'envole !",
	deepbreath_incoming_message = "Incantation d'une Bombe de glace dans ~14 sec. !",
	deepbreath_incoming_soon_message = "Incantation d'une Bombe de glace dans ~5 sec. !",
	deepbreath_incoming_bar = "Bombe de glace en incantation",
	deepbreath_trigger = "%s inspire profondément.",
	deepbreath_warning = "Arrivée d'une Bombe de glace !",
	deepbreath_bar = "Impact Bombe de glace ",

	lifedrain = "Drain de vie",
	lifedrain_desc = "Prévient quand le raid est affecté par le Drain de vie.",
	lifedrain_message = "Drain de vie ! Prochain dans ~24 sec. !",
	lifedrain_warn1 = "Drain de vie dans 5 sec. !",
	lifedrain_bar = "Drain de vie",

	icebolt = "Eclair de glace",
	icebolt_desc = "Fait crier à votre personnage qu'il est un bloc de glace quand c'est le cas.",
	icebolt_other = "Bloc : %s",
	icebolt_yell = "Je suis un bloc !",

	ping = "Ping",
	ping_desc = "Pinge votre position actuelle si vous subissez les effets de l'Eclair de glace.",
	ping_message = "Bloc - Pingage de votre position !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la dernière personne affectée par l'Eclair de glace (nécessite d'être promu ou mieux).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15989
mod.toggleoptions = {"lifedrain", "deepbreath", -1, "icebolt", "ping", "icon", "berserk", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Drain", 28542, 55665)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Breath", 28524, 29318)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Icebolt", 28522)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveIcon", 28522)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	breath = 1
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["airphase_trigger"] then
		self:CancelScheduledEvent("Lifedrain")
		self:TriggerEvent("BigWigs_StopBar", self, L["lifedrain_bar"])
		if self.db.profile.deepbreath then
			--43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
			self:IfMessage(L["deepbreath_incoming_message"], "Attention")
			self:Bar(L["deepbreath_incoming_bar"], 14, 43810)
			self:DelayedMessage(9, L["deepbreath_incoming_soon_message"], "Attention")
		end
	elseif msg == L["deepbreath_trigger"] then
		if self.db.profile.deepbreath then
			self:IfMessage(L["deepbreath_warning"], "Attention")
			self:Bar(L["deepbreath_bar"], 10, 29318)
		end
	end
end

function mod:Breath(_, spellId)
	if self.db.profile.deepbreath then
		breath = breath + 1
		if breath == 2 then
			self:IfMessage(L["deepbreath"], "Important", spellId)
		end
	end
end

function mod:Drain(_, spellID)
	if self.db.profile.lifedrain then
		self:IfMessage(L["lifedrain_message"], "Urgent", spellID)
		self:Bar(L["lifedrain_bar"], 23, spellID)
		self:ScheduleEvent("Lifedrain", "BigWigs_Message", 18, L["lifedrain_warn1"], "Important")
	end
end

function mod:Icebolt(player, spellID)
	if player == pName and self.db.profile.icebolt then
		self:WideMessage(format(L["icebolt_other"], player))
		SendChatMessage(L["icebolt_yell"], "YELL")
		if UnitIsUnit(player, "player") and self.db.profile.ping then
			Minimap:PingLocation()
			BigWigs:Print(L["ping_message"])
		end
	elseif self.db.profile.icebolt then
		self:IfMessage(format(L["icebolt_other"], player), "Attention", spellID)
	end
	if self.db.profile.icon then
		self:Icon(player, "icon")
	end
end

function mod:RemoveIcon()
	self:TriggerEvent("BigWigs_RemoveRaidIcon")
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:Enrage(900, true)
		end
	end
end
