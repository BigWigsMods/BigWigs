----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Hodir"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32845
mod.toggleoptions = {"hardmode", -1, "cold", 65123, 61968, 62478, "berserk", "icon", "bosskill"}
mod.consoleCmd = "Hodir"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local flashFreezed = mod:NewTargetList()
local fmt = string.format
local lastCold = nil
local cold = GetSpellInfo(62039)
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "You will suffer for this trespass!",

	cold = "Biting Cold",
	cold_desc = "Warn when you have 2 or more stacks of Biting Cold.",
	cold_message = "Biting Cold x%d!",

	flash_message = "Frozen: %s!",
	flash_warning = "Freeze!",
	flash_soon = "Freeze in 5sec!",

	hardmode = "Hard mode",
	hardmode_desc = "Show timer for hard mode.",

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

	flash_message = "순간 빙결: %s!",
	flash_warning = "순간 빙결 시전!",
	flash_soon = "5초 후 순간 빙결",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",

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

	flash_message = "Gelé(s) : %s",
	flash_warning = "Gel instantané en incantation !",
	flash_soon = "Gel instantané dans 5 sec. !",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 min pour le mode difficile (délai avant qu'Hodir ne détruise sa cache rare).",

	cloud_you = "Nuage d'orage sur VOUS !",
	cloud_other = "Nuage : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Nuage d'orage (nécessite d'être assistant ou mieux).",

	end_trigger = "Je suis... libéré de son emprise... enfin.",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Für Euer Eindringen werdet Ihr bezahlen!",

	cold = "Beißende Kälte",
	cold_desc = "Warnt, wenn du zwei Stapel von Beißende Kälte hast.",
	cold_message = "Beißende Kälte x%d!",

	flash_message = "Blitzeis: %s!",
	flash_warning = "Blitzeis!",
	flash_soon = "Blitzeis in 5 sek!",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",

	cloud_you = "Sturmwolke auf DIR!",
	cloud_other = "Sturmwolke: %s!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Sturmwolke betroffen sind (benötigt Assistent oder höher).",

	end_trigger = "Ich... bin von ihm befreit... endlich.",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "You will suffer for this trespass!",

	cold = "刺骨之寒（成就）",
	cold_desc = "当你受到2层刺骨之寒效果时发出警报。",
	cold_message = "刺骨之寒（%d层） - 移动！",

	flash_message = "急速冻结：>%s<！",
	flash_warning = "急速冻结！",
	flash_soon = "5秒后，急速冻结！",

	hardmode = "困难模式计时器",
	hardmode_desc = "显示困难模式计时器。",

	cloud_you = ">你< 风暴雷云！",
	cloud_other = "风暴雷云：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了风暴雷云的队员打上团队标记。（需要权限）",

--	end_trigger = "I...I am released from his grasp! At...last!",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你將為擅闖付出代價!",

	cold = "刺骨之寒（成就）",
	cold_desc = "當你受到2層刺骨之寒效果時發出警報。",
	cold_message = "刺骨之寒（%d層） - 移動！",

	flash_message = "閃霜：>%s<！",
	flash_warning = "閃霜！",
	flash_soon = "5秒後，閃霜！",

	hardmode = "困難模式計時器",
	hardmode_desc = "顯示困難模式計時器。",

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

	flash_message = "Заморожены: %s!",
	flash_warning = "Применение мгновенной заморозки!",
	flash_soon = "Заморозка через 5сек!",

	hardmode = "Сложный режим",
	hardmode_desc = "Отображать таймер сложного режима.",

	cloud_you = "Грозовая туча на ВАС",
	cloud_other = "%s под Грозовой тучей!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого нацелена Грозовая туча.",

	end_trigger = "Наконец-то я... свободен от его оков…",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "FlashCast", 61968)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flash", 61969, 61990)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Frozen", 62478, 63512)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cloud", 65123, 65133)
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Cloud(player, spellId)
	if player == pName then
		self:LocalMessage(L["cloud_you"], "Positive", spellId, "Info")
		self:WideMessage(L["cloud_other"]:format(player))
	else
		self:TargetMessage(L["cloud_other"], player, "Positive", spellId)
		self:Whisper(player, L["cloud_you"])
	end
	self:Bar(L["cloud_other"]:format(player), 30, spellId)
	self:Icon(player, "icon")
end

function mod:FlashCast(_, spellId, _, _, spellName)
	self:IfMessage(L["flash_warning"], "Attention", spellId)
	self:Bar(spellName, 9, spellId)
	self:Bar(spellName, 35, spellId)
	self:DelayedMessage(30, L["flash_soon"], "Attention")
end

local function flashWarn()
	mod:TargetMessage(L["flash_message"], flashFreezed, "Urgent", 61969, "Alert")
end

function mod:Flash(player)
	if UnitInRaid(player) then
		flashFreezed[#flashFreezed + 1] = player
		self:ScheduleEvent("BWFFWarn", flashWarn, 0.5)
	end
end

function mod:Frozen(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 20, spellId)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		lastCold = nil
		if self:GetOption(61968) then
			self:Bar(L["flash_bar"], 35, 61968)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 180, 6673)
		end
		if db.berserk then
			self:Enrage(480, true)
		end
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

