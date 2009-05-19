----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Hodir"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32845
mod.toggleoptions = {"hardmode", -1, "cold", "cloud", "flash", "frozenblow", "berserk", "icon", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local FF = {}
local fmt = string.format
local lastCold = nil
local cold = GetSpellInfo(62039)

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Hodir",

	engage_trigger = "You will suffer for this trespass!",

	cold = "Biting Cold",
	cold_desc = "Warn when you have 2 or more stacks of Biting Cold.",
	cold_message = "Biting Cold x%d!",

	flash = "Flash Freeze",
	flash_desc = "Tells you who has been hit by Flash Freeze and when the Flash Freeze is casting.",
	flash_message = "Frozen: %s!",
	flash_warning = "Freeze!",
	flash_soon = "Freeze in 5sec!",
	flash_bar = "Flash",

	frozenblow = "Frozen Blows",
	frozenblow_desc = "Warn when Hodir gains Frozen Blows.",
	frozenblow_message = "Frozen Blows!",
	frozenblow_bar = "Frozen Blows",

	hardmode = "Hard Mode",
	hardmode_desc = "Show timer for Hard Mode.",

	cloud = "Storm Cloud",
	cloud_desc = "Shows who gets Storm Cloud.",
	cloud_you = "Cloud on you!",
	cloud_other = "Cloud on %s!",

	icon = "Place icon",
	icon_desc = "Place a raid icon on players who get targetted with the Storm Clouds.",

	end_trigger = "I... I am released from his grasp... at last.",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "침입자는 쓴맛을 보게 될 게다!",

	cold = "매서운 추위(업적)",
	cold_desc = "매서운 추위 2중첩이상을 알립니다.",
	cold_message = "매서운 추위 x%d - 이동!",

	flash = "순간 빙결",
	flash_desc = "순간 빙결 시전과 순간 빙결에 걸린 플레이어를 알립니다.",
	flash_message = "순간 빙결: %s!",
	flash_warning = "순간 빙결 시전!",
	flash_soon = "5초 후 순간 빙결",
	flash_bar = "다음 순간 빙결",

	frozenblow = "얼음 일격",
	frozenblow_desc = "호디르의 얼음 일격 획득을 알립니다.",
	frozenblow_message = "호디르 얼음 일격!",
	frozenblow_bar = "얼음 일격",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	
	cloud = "폭풍 구름",
	cloud_desc = "폭풍 구름을 얻은 플레이어를 알립니다.",
	cloud_you = "당신은 폭풍 구름",
	cloud_other = "%s: 폭풍 구름 획득",

	icon = "전술 표시",
	icon_desc = "폭풍 구름을 획득한 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	end_trigger = "드디어... 드디어 그의 손아귀를... 벗어나는구나.",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous allez souffrir pour cette intrusion !",

	cold = "Ça caille ici",
	cold_desc = "Prévient quand Froid mordant s'est empilé 2 fois sur votre personnage.",
	cold_message = "Froid mordant x%d !",

	flash = "Gel instantané",
	flash_desc = "Prévient quand un joueur subit les effets d'un Gel instantané et quand le Gel instantané est incanté.",
	flash_message = "Gelé(s) : %s",
	flash_warning = "Gel instantané en incantation !",
	flash_soon = "Gel instantané dans 5 sec. !",
	flash_bar = "Prochain Gel instantané",

	frozenblow = "Coups gelés",
	frozenblow_desc = "Prévient quand Hodir gagne Coups gelés.",
	frozenblow_message = "Coups gelés !",
	frozenblow_bar = "Coups gelés",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 min pour le mode difficile (délai avant qu'Hodir ne détruise sa cache rare).",

	cloud = "Nuage d'orage",
	cloud_desc = "Prévient quand un joueur subit les effets d'un Nuage d'orage.",
	cloud_you = "Nuage d'orage sur VOUS !",
	cloud_other = "Nuage d'orage : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Nuage d'orage (nécessite d'être assistant ou mieux).",

	end_trigger = "Je suis... libéré de son emprise... enfin.",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Für Euer Eindringen werdet Ihr bezahlen!",

	cold = "Beißende Kälte",
	cold_desc = "Warnt, wenn du zwei Stapel von Beißende Kälte hast.",
	cold_message = "Beißende Kälte x%d!",

	flash = "Blitzeis",
	flash_desc = "Warnt, wenn Blitzeis gewirkt wird und wer davon betroffen ist.",
	flash_message = "Blitzeis: %s!",
	flash_warning = "Blitzeis!",
	flash_soon = "Blitzeis in 5 sek!",
	flash_bar = "Blitzeis",

	frozenblow = "Gefrorene Schläge",
	frozenblow_desc = "Warnt, wenn Hodir Gefrorene Schläge bekommt.",
	frozenblow_message = "Gefrorene Schläge!",
	frozenblow_bar = "Gefrorene Schläge",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",

	cloud = "Sturmwolke",
	cloud_desc = "Warnt, wer von Sturmwolke betroffen ist.",
	cloud_you = "Sturmwolke auf DIR!",
	cloud_other = "Sturmwolke: %s!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Sturmwolke betroffen sind (benötigt Assistent oder höher).",

	end_trigger = "Ich... bin von ihm befreit... endlich.",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "You will suffer for this trespass!",

	cold = "Biting Cold（成就）",
	cold_desc = "当你受到2层Biting Cold效果时发出警报。",
	cold_message = "Biting Cold（%d层） - 移动！",

	flash = "冰霜速冻",
	flash_desc = "当正在施放冰霜速冻和玩家中了冰霜速冻时发出警报。",
	flash_message = "冰霜速冻：>%s<！",
	flash_warning = "冰霜速冻！",
	flash_soon = "5秒后，冰霜速冻！",
	flash_bar = "<冰霜速冻>",

	frozenblow = "Frozen Blow",
	frozenblow_desc = "当霍迪尔获得Frozen Blow效果时发出警报。",
	frozenblow_message = "Frozen Blow！",
	frozenblow_bar = "<Frozen Blow>",

	hardmode = "困难模式计时器",
	hardmode_desc = "显示困难模式计时器。",

	cloud = "Storm Cloud",
	cloud_desc = "当玩家中了Storm Cloud时发出警报。",
	cloud_you = ">你< Storm Cloud！",
	cloud_other = "Storm Cloud：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了Storm Cloud的队员打上团队标记。（需要权限）",

--	end_trigger = "I...I am released from his grasp! At...last!",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你將為擅闖付出代價!",

	cold = "刺骨之寒（成就）",
	cold_desc = "當你受到2層刺骨之寒效果時發出警報。",
	cold_message = "刺骨之寒（%d層） - 移動！",

	flash = "閃霜",
	flash_desc = "當正在施放閃霜和玩家中了閃霜時發出警報。",
	flash_message = "閃霜：>%s<！",
	flash_warning = "閃霜！",
	flash_soon = "5秒後，閃霜！",
	flash_bar = "<閃霜>",

	frozenblow = "冰凍痛擊",
	frozenblow_desc = "當霍迪爾獲得冰凍痛擊效果時發出警報。",
	frozenblow_message = "冰凍痛擊！",
	frozenblow_bar = "<冰凍痛擊>",

	hardmode = "困難模式計時器",
	hardmode_desc = "顯示困難模式計時器。",

	cloud = "風暴雷雲",
	cloud_desc = "當玩家中了風暴雷雲時發出警報。",
	cloud_you = ">你< 風暴雷雲！",
	cloud_other = "風暴雷雲：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了風暴雷雲的隊員打上團隊標記。（需要權限）",

	end_trigger = "我…我終於從他的掌控中…解脫了。",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Вы будете наказаны за это вторжение!",

	cold = "Трескучий мороз",
	cold_desc = "Сообщать когда на вас наложено 2 эффекта Трескучего мороза",
	cold_message = "Трескучий мороз x%d!",

	flash = "Мгновенная заморозка",
	flash_desc = "Сообщает кто подвергся мгновенной заморозке и когда она применяется.",
	flash_message = "Замарожены: %s!",
	flash_warning = "Применение мгновенной заморозки!",
	flash_soon = "Заморозка через 5сек!",
	flash_bar = "~замарозка",

	frozenblow = "Ледяные дуновения",
	frozenblow_desc = "Сообщать когда Ходир накладывает на себя Ледяные дуновения.",
	frozenblow_message = "Ходир наложил на себя Ледяные дуновения!",
	frozenblow_bar = "Ледяные дуновения",

	hardmode = "Таймер сложного режима", --need review
	hardmode_desc = "Отображать таймер в сложном режиме.",--need review
	
	cloud = "Грозовая туча",
	cloud_desc = "Отображает кто получает эффект Грозовой тучи.",
	cloud_you = "Грозовая туча на ВАС",
	cloud_other = "%s под Грозовой тучей",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого нацелена Грозовая туча.",

	--end_trigger = "I...I am released from his grasp! At...last!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	db = self.db.profile
	lastCold = nil
	wipe(FF)

	self:AddCombatListener("SPELL_CAST_START", "FlashCast", 61968)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flash", 61969, 61990)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Frozen", 62478, 63512)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cloud", 65123, 65133)
	self:RegisterEvent("UNIT_AURA")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function mod:VerifyEnable(unit)
	return UnitIsEnemy(unit, "player") and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Cloud(player, spellID)
	if db.cloud then
		if player == pName then
			self:LocalMessage(L["cloud_you"], "Positive", spellID, "Info")
			self:WideMessage(L["cloud_other"]:format(player))
		else
			self:TargetMessage(L["cloud_other"], player, "Positive", spellID)
			self:Whisper(player, L["cloud_you"])
		end
		self:Bar(L["cloud_other"]:format(player), 30, spellID)
		self:Icon(player, "icon")
	end
end

function mod:FlashCast(_, spellID)
	if db.flash then
		self:IfMessage(L["flash_warning"], "Attention", spellID)
		self:Bar(L["flash"], 9, spellID)
		self:Bar(L["flash_bar"], 35, spellID)
		self:DelayedMessage(30, L["flash_soon"], "Attention")
	end
end

local function flashWarn()
	mod:IfMessage(L["flash_message"]:format(table.concat(FF, ", ")), "Urgent", 61969, "Alert")
	wipe(FF)
end

function mod:Flash(player)
	if UnitInRaid(player) and db.flash then
		table.insert(FF, player)
		self:ScheduleEvent("BWFFWarn", flashWarn, 0.5)
	end
end

function mod:Frozen(_, spellID)
	if db.frozenblow then
		self:IfMessage(L["frozenblow_message"], "Important", spellID)
		self:Bar(L["frozenblow_bar"], 20, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.flash then
			self:Bar(L["flash_bar"], 35, 61968)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 180, 6673)
		end
		if db.berserk then
			self:Enrage(480, true)
		end
		wipe(FF)
	elseif msg == L["end_trigger"] then
		self:BossDeath(nil, self.guid)
	end
end

function mod:UNIT_AURA(unit)
	if unit and unit ~= "player" then return end
	local _, _, icon, stack = UnitDebuff("player", cold)
	if stack and stack ~= lastCold then
		if db.cold and stack > 1 then
			self:LocalMessage(L["cold_message"]:format(stack), "Personal", icon)
		end
		lastCold = stack
	end
end

