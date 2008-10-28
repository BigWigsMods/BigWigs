------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Sapphiron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local cachedUnitId
local lastTarget
local started
local UnitExists = UnitExists
local UnitName = UnitName
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sapphiron",

	deepbreath = "Ice Bomb",
	deepbreath_desc = "Warn when Sapphiron begins to cast Ice Bomb.",
	deepbreath_incoming_message = "Ice Bomb casting in ~23sec!",
	deepbreath_incoming_soon_message = "Ice Bomb casting in ~5sec!",
	deepbreath_incoming_bar = "Ice Bomb Cast",
	deepbreath_trigger = "%s takes in a deep breath...",
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
	icebolt_yell = "I'm a Block! -%s-",
	
	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	ping_message = "Block - Pinging your location!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	deepbreath = "얼음 폭탄",
	deepbreath_desc = "사피론 의 얼음 폭탄 시전을 알립니다.",
	deepbreath_incoming_message = "약 23초 이내 얼음 폭탄 시전!",
	deepbreath_incoming_soon_message = "약 5초 이내 얼음 폭탄 시전!",
	deepbreath_incoming_bar = "얼음 폭탄 시전",
	deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다.",
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
	icebolt_yell = "-%s- 저 방패에요!",
	
	ping = "미니맵 표시",
	ping_desc = "자신이 얼음 화살에 걸렸을 때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "방패 - 현재 위치 미니맵에 표시 중!",

	icon = "전술 표시",
	icon_desc = "얼음 화살 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("deDE", function() return {
	deepbreath = "Frostatem Warnung",
	deepbreath_desc = "Warnt, wenn Saphiron Frostatem zaubert.",

	lifedrain = "Lebenssauger",
	lifedrain_desc = "Warnt vor dem Lebenssauger Fluch.",

	lifedrain_message = "Lebenssauger! N\195\164chster in ~24sek!",
	lifedrain_warn1 = "Lebenssauger in 5sek!",
	lifedrain_bar = "Lebenssauger",

	deepbreath_incoming_message = "Frostatem in ~23sek!",
	deepbreath_incoming_soon_message = "Frostatem in ~5sek!",
	deepbreath_incoming_bar = "Frostatem",
	deepbreath_trigger = "%s atmet tief ein...",
	deepbreath_warning = "Frostatem kommt!",
	deepbreath_bar = "Frostatem!",
	
	--icebolt = "Icebolt",
	--icebolt_desc = "Yell when you are an Icebolt.",
	--icebolt_other = "Block: %s",
	--icebolt_yell = "I'm a Block! -%s-",
	
	--ping = "Ping",
	--ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	--ping_message = "Block - Pinging your location!",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
} end )

L:RegisterTranslations("zhCN", function() return {
	deepbreath = "寒冰炸弹",
	deepbreath_desc = "当施放寒冰炸弹时发出警报。",
	deepbreath_incoming_message = "约23秒后，寒冰炸弹！",
	deepbreath_incoming_soon_message = "约5秒后，寒冰炸弹！",
	deepbreath_incoming_bar = "<寒冰炸弹>",
	deepbreath_trigger = "%s深深地吸了一口气……", 
	deepbreath_warning = "即将 寒冰炸弹！",
	deepbreath_bar = "<寒冰炸弹>",

	lifedrain = "生命吸取",
	lifedrain_desc = "当施放生命吸取时候发出警报。",
	lifedrain_message = "约24秒后，生命吸取！",
	lifedrain_warn1 = "5秒后，生命吸取！",
	lifedrain_bar = "<生命吸取>",

	icebolt = "寒冰箭",
	icebolt_desc = "当玩家受到寒冰屏障效果后大喊。",
	--icebolt_other = "Block: %s",
	icebolt_yell = "我是寒冰屏障！快躲到我后面！>%s<"
	
	--ping = "Ping",
	--ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	--ping_message = "Block - Pinging your location!",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
	
} end )

L:RegisterTranslations("zhTW", function() return {
	deepbreath = "深呼吸警報",
	deepbreath_desc = "薩菲隆開始施放深呼吸時發出警報",

	lifedrain = "生命吸取警報",
	lifedrain_desc = "生命吸取詛咒時候發出警報",

	lifedrain_message = "生命吸取 24 秒後再次施放！",
	lifedrain_warn1 = "5 秒後生命吸取！",
	lifedrain_bar = "生命吸取",

	deepbreath_incoming_message = "寒冰炸彈23 秒後施放！",
	deepbreath_incoming_soon_message = "寒冰炸彈 5 秒後施放！",
	deepbreath_incoming_bar = "寒冰炸彈",
	deepbreath_trigger = "%s深深地吸了一口氣……",
	deepbreath_warning = "寒冰炸彈即將著地！",
	deepbreath_bar = "寒冰炸彈",
	
	--icebolt = "Icebolt",
	--icebolt_desc = "Yell when you are an Icebolt.",
	--icebolt_other = "Block: %s",
	--icebolt_yell = "I'm a Block! -%s-",
	
	--ping = "Ping",
	--ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	--ping_message = "Block - Pinging your location!",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
} end )

L:RegisterTranslations("frFR", function() return {
	deepbreath = "Bombe de glace",
	deepbreath_desc = "Préviens quand Saphiron commence à lancer sa Bombe de glace.",
	deepbreath_incoming_message = "Bombe de glace incantée dans ~23 sec. !",
	deepbreath_incoming_soon_message = "Bombe de glace incantée dans ~5 sec. !",
	deepbreath_incoming_bar = "Incantation : Bombe de glace",
	deepbreath_trigger = "%s prend une grande inspiration…",
	deepbreath_warning = "Bombe de glace imminente !",
	deepbreath_bar = "Impact Bombe de glace",

	lifedrain = "Drain de vie",
	lifedrain_desc = "Préviens quand le raid est affecté par le Drain de vie.",
	lifedrain_message = "Drain de vie ! Suivant possible dans ~24 sec. !",
	lifedrain_warn1 = "Drain de vie dans 5 sec. !",
	lifedrain_bar = "Drain de vie",

	icebolt = "Crier - Eclair de glace",
	icebolt_desc = "Fais crier votre personnage qu'il est un bloc de glace quand c'est le cas.",
	--icebolt_other = "Block: %s",
	icebolt_yell = "Je suis un bloc ! -%s-"
		
	--ping = "Ping",
	--ping_desc = "Ping your current location if you are afflicted by Icebolt.",
	--ping_message = "Block - Pinging your location!",

	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15989
mod.toggleoptions = {"enrage", "lifedrain", "deepbreath", -1, "icebolt", "ping", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Drain", 28542)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Icebolt", 28522)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveIcon", 28522)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	cachedUnitId = nil
	lastTarget = nil
	started = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Drain(_, spellID)
	if self.db.profile.lifedrain then
		self:TriggerEvent("BigWigs_StopBar", self, L["lifedrain_bar"])
		self:IfMessage(L["lifedrain_message"], "Urgent", spellID)
		self:Bar(L["lifedrain_bar"], 24, spellID)
		self:ScheduleEvent("Lifedrain", "BigWigs_Message", 19, L["lifedrain_warn1"], "Important")
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
	elseif self.db.profile.orbother then
		self:IfMessage(format(L["icebolt_other"], player), "Attention", spellID)
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
		self:CancelScheduledEvent("bwsapphtargetscanner")
		self:CancelScheduledEvent("bwsapphdelayed")
		if self.db.profile.enrage then
			self:Enrage(900)
		end
		if self.db.profile.deepbreath then
			self:ScheduleEvent("besapphdelayed", self.StartTargetScanner, 5, self) --5sec raid security delay
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["deepbreath_trigger"] then
		if self.db.profile.deepbreath then
			self:Message(L["deepbreath_warning"], "Important")
			self:Bar(L["deepbreath_bar"], 7, "Spell_Frost_FrostShock")
		end
		if self.db.profile.lifedrain then
			self:Bar(L["lifedrain_bar"], 14, "Spell_Shadow_LifeDrain02")
		end
	end
end

------------------------------
--      Target Scanning     --
------------------------------

function mod:StartTargetScanner()
	if self:IsEventScheduled("bwsapphtargetscanner") or not started then return end

	-- Start a repeating event that scans the raid for targets every 1 second.
	self:ScheduleRepeatingEvent("bwsapphtargetscanner", self.RepeatedTargetScanner, 1, self)
end

function mod:RepeatedTargetScanner()
	if not started then return end
	local found = nil

	-- If we have a cached unit (which we will if we found someone with the boss
	-- as target), then check if he still has the same target
	if cachedUnitId and UnitExists(cachedUnitId) and UnitName(cachedUnitId) == boss then
		found = true
	end

	-- Check the players target
	if not found and UnitExists("target") and UnitName("target") == boss then
		cachedUnitId = "target"
		found = true
	end

	if not found and UnitExists("focus") and UnitName("focus") == boss then
		cachedUnitId = "focus"
		found = true
	end

	-- Loop the raid roster
	if not found then
		local num = GetNumRaidMembers()
		for i = 1, num do
			local unit = "raid" .. i .. "target"
			if UnitExists(unit) and UnitName(unit) == boss then
				cachedUnitId = unit
				found = true
				break
			end
		end
	end

	-- We've checked everything. If nothing was found, just return home.
	-- We basically shouldn't return here, because someone should always have
	-- him targetted.
	if not found then return end

	local inFlight = nil

	-- Alright, we've got a valid unitId with the boss as target, now check if
	-- the boss had a target on the last iteration or not - if he didn't, and
	-- still doesn't, then we fire the "in air" warning.
	if not UnitExists(cachedUnitId.."target") then
		-- Okay, the boss doesn't have a target.
		if not lastTarget then
			-- He didn't have a target last time either
			inFlight = true
		end
		lastTarget = nil
	else
		-- This should always be set before we hit the time when he actually
		-- loses his target, hence we can check |if not lastTarget| above.
		lastTarget = true
	end

	-- He's not flying, so we're just going to continue scanning.
	if not inFlight then return end

	-- He's in flight! (I hope)
	self:CancelScheduledEvent("bwsapphtargetscanner")
	self:CancelScheduledEvent("Lifedrain")
	self:TriggerEvent("BigWigs_StopBar", self, L["lifedrain_bar"])

	if self.db.profile.deepbreath then
		self:CancelScheduledEvent("bwsapphtargetscanner")
		self:CancelScheduledEvent("bwsapphdelayed")
		self:Message(L["deepbreath_incoming_message"], "Urgent")
		self:DelayedMessage(18, L["deepbreath_incoming_soon_message"], "Attention")
		self:Bar(L["deepbreath_incoming_bar"], 23, "Spell_Arcane_PortalIronForge")
		lastTarget = nil
		cachedUnitId = nil
		self:ScheduleEvent("besapphdelayed", self.StartTargetScanner, 50, self)
	end
end

