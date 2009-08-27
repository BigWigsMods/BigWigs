----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Sapphiron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15989
mod.toggleOptions = {28542, 28524, -1, 28522, "ping", "icon", "berserk", "bosskill"}
mod.consoleCmd = "Sapphiron"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local breath = 1
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	airphase_trigger = "Sapphiron lifts off into the air!",
	deepbreath_incoming_message = "Ice Bomb casting in ~14sec!",
	deepbreath_incoming_soon_message = "Ice Bomb casting in ~5sec!",
	deepbreath_incoming_bar = "Ice Bomb Cast",
	deepbreath_trigger = "%s takes a deep breath.",
	deepbreath_warning = "Ice Bomb Incoming!",
	deepbreath_bar = "Ice Bomb Lands!",

	lifedrain_message = "Life Drain! Next in ~24sec!",
	lifedrain_warn1 = "Life Drain in ~5sec!",
	lifedrain_bar = "~Possible Life Drain",

	icebolt_other = "Block: %s",
	icebolt_say = "I'm a Block!",

	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	ping_message = "Block - Pinging your location!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
} end )

L:RegisterTranslations("ruRU", function() return {
	airphase_trigger = "%s взмывает в воздух!",
	deepbreath_incoming_message = "Ледяная бомба через 23 секунды!",
	deepbreath_incoming_soon_message = "Ледяная бомба через 5 секунд!",
	deepbreath_incoming_bar = "Каст ледяной бомбы",
	deepbreath_trigger = "%s глубоко вздыхает.",  
	deepbreath_warning = "Появляется ледяная бомба!",
	deepbreath_bar = "Приземляется ледяная бомба!",

	lifedrain_message = "Похищение жизни! Следующее через 24 секунды!",
	lifedrain_warn1 = "Похищение жизни через 5 секунд!",
	lifedrain_bar = "~Возможное похищение жизни",

	icebolt_other = "%s в Глыбе!",
	icebolt_say = "Я в глыбе!",

	ping = "Мояк по мини-карте",
	ping_desc = "Отмечать ваше текущеее положение маяком по мини-карте, если вы находитесь в глыбе после морозной стрелы.",
	ping_message = "Глыба - отмечаю положение!",

	icon = "Отмечать иконкой",
	icon_desc = "Отмечать рейдовой иконой игрока, попавшего в глыбу после морозной стрелы (необходимо быть лидером группы или рейда)",
} end )

L:RegisterTranslations("koKR", function() return {
	airphase_trigger = "사피론이 공중으로 떠오릅니다!",
	deepbreath_incoming_message = "약 14초 이내 얼음 폭탄 시전!",
	deepbreath_incoming_soon_message = "약 5초 이내 얼음 폭탄 시전!",
	deepbreath_incoming_bar = "얼음 폭탄 시전",
	deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이마십니다.",
	deepbreath_warning = "잠시 후 얼음 폭탄!",
	deepbreath_bar = "얼음 폭탄 떨어짐!",

	lifedrain_message = "생명력 흡수! 다음은 약 24초 이내!",
	lifedrain_warn1 = "약 5초 이내 생명력 흡수!",
	lifedrain_bar = "~생명력 흡수 가능",

	icebolt_other = "방패: %s",
	icebolt_say = "저 방패에요!",

	ping = "미니맵 표시",
	ping_desc = "자신이 얼음 화살에 걸렸을 때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "방패 - 현재 위치 미니맵에 표시 중!",

	icon = "전술 표시",
	icon_desc = "얼음 화살 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("deDE", function() return {
	airphase_trigger = "Saphiron erhebt sich in die Lüfte!", -- No %s in deDE, we need the translated name!
	deepbreath_incoming_message = "Frostatem in ~23 sek!",
	deepbreath_incoming_soon_message = "Frostatem in ~5 sek!",
	deepbreath_incoming_bar = "Wirkt Frostatem...",
	deepbreath_trigger = "%s holt tief Luft.",
	deepbreath_warning = "Frostatem kommt!",
	deepbreath_bar = "Frostatem landet!",

	lifedrain_message = "Lebensentzug! Nächster in ~24 sek!",
	lifedrain_warn1 = "Lebensentzug in ~5 sek!",
	lifedrain_bar = "~Lebensentzug",

	icebolt_other = "Eisblock: %s",
	icebolt_say = "Ich bin ein Eisblock!",

	ping = "Ping",
	ping_desc = "Die derzeitige Position pingen, wenn du von Eisblitz betroffen bist.",
	ping_message = "Eisblock - Pinge deine Position!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Eisblitz gewirkt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	--airphase_trigger = "%s lifts off into the air!",
	deepbreath_incoming_message = "约14秒后，冰霜吐息！",
	deepbreath_incoming_soon_message = "约5秒后，冰霜吐息！",
	deepbreath_incoming_bar = "<施放 冰霜吐息>",
	deepbreath_trigger = "%s深深地吸了一口气……", 
	deepbreath_warning = "即将 冰霜吐息！",
	deepbreath_bar = "<冰霜吐息 落地>",

	lifedrain_message = "约24秒后，生命吸取！",
	lifedrain_warn1 = "5秒后，生命吸取！",
	lifedrain_bar = "<生命吸取>",

	icebolt_other = "寒冰屏障：>%s<！",
	icebolt_say = "我是寒冰屏障！快躲到我后面！",

	ping = "点击",
	ping_desc = "当你中了寒冰屏障时点击当前所在位置。",
	ping_message = "寒冰屏障 - 点击你的位置！",

	icon = "团队标记",
	icon_desc = "为中了寒冰屏障的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	airphase_trigger = "%s離地升空了!",
	deepbreath_incoming_message = "約14秒後，冰息術！",
	deepbreath_incoming_soon_message = "約5秒後，冰息術！",
	deepbreath_incoming_bar = "<施放 冰息術>",
	deepbreath_trigger = "%s深深地吸了一口氣……",
	deepbreath_warning = "即將 冰息術！",
	deepbreath_bar = "<冰息術 落地>",

	lifedrain_message = "約24秒後，生命吸取！",
	lifedrain_warn1 = "5秒後，生命吸取！",
	lifedrain_bar = "<生命吸取>",

	icebolt_other = "寒冰凍體：>%s<！",
	icebolt_say = "我是寒冰凍體！快躲到我後面！",

	ping = "點擊",
	ping_desc = "當你中了寒冰凍體時點擊當前所在位置。",
	ping_message = "寒冰凍體 - 點擊你的位置！",

	icon = "團隊標記",
	icon_desc = "為中了寒冰凍體的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("frFR", function() return {
	airphase_trigger = "Saphiron s'envole !",
	deepbreath_incoming_message = "Incantation d'une Bombe de glace dans ~14 sec. !",
	deepbreath_incoming_soon_message = "Incantation d'une Bombe de glace dans ~5 sec. !",
	deepbreath_incoming_bar = "Incantation Bombe",
	deepbreath_trigger = "%s inspire profondément.",
	deepbreath_warning = "Arrivée d'une Bombe de glace !",
	deepbreath_bar = "Impact Bombe de glace ",

	lifedrain_message = "Drains de vie ! Prochain dans ~24 sec. !",
	lifedrain_warn1 = "Drains de vie dans 5 sec. !",
	lifedrain_bar = "Prochains Drains de vie",

	icebolt_other = "Bloc : %s",
	icebolt_say = "Je suis un bloc !",

	ping = "Ping",
	ping_desc = "Pinge votre position actuelle si vous subissez les effets de l'Eclair de glace.",
	ping_message = "Bloc - Indication de votre position aux autres !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la dernière personne affectée par l'Eclair de glace (nécessite d'être assistant ou mieux).",
} end )

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
		if self:GetOption(28524) then
			--43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
			self:IfMessage(L["deepbreath_incoming_message"], "Attention")
			self:Bar(L["deepbreath_incoming_bar"], 14, 43810)
			self:DelayedMessage(9, L["deepbreath_incoming_soon_message"], "Attention")
		end
	elseif msg == L["deepbreath_trigger"] then
		if self:GetOption(28524) then
			self:IfMessage(L["deepbreath_warning"], "Attention")
			self:Bar(L["deepbreath_bar"], 10, 29318)
		end
	end
end

function mod:Breath(_, spellId, _, _, spellName)
	breath = breath + 1
	if breath == 2 then
		self:IfMessage(spellName, "Important", spellId)
	end
end

function mod:Drain(_, spellId)
	self:IfMessage(L["lifedrain_message"], "Urgent", spellId)
	self:Bar(L["lifedrain_bar"], 23, spellId)
	self:ScheduleEvent("Lifedrain", "BigWigs_Message", 18, L["lifedrain_warn1"], "Important")
end

function mod:Icebolt(player, spellId)
	if player == pName then
		SendChatMessage(L["icebolt_say"], "SAY")
		if UnitIsUnit(player, "player") and self.db.profile.ping then
			Minimap:PingLocation()
			BigWigs:Print(L["ping_message"])
		end
	else
		self:TargetMessage(L["icebolt_other"], player, "Attention", spellId)
	end
	self:Icon(player, "icon")
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

