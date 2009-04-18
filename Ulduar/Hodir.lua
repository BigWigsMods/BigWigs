----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Hodir"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32845
mod.toggleoptions = {"hardmode", -1, "cold", "flash", "frozenblow", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local FF = {}
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Hodir",

	engage_trigger = "You will suffer for this trespass!",

	cold = "Biting Cold(Achievement)",
	cold_desc = "Warn when you have the Biting Cold 2stack",
	cold_message = "Biting Cold(2Stack) - Move!",

	flash = "Flash Freeze",
	flash_desc = "Tells you who has been hit by Flash Freeze and when the Flash Freeze is casting.",
	flash_message = "%s has Flash Freeze!",
	flash_warning = "Casting Flash Freeze!",
	flash_soon = "Flash Freeze in 5sec!",
	flash_bar = "Next Flash",

	frozenblow = "Frozen Blow",
	frozenblow_desc = "Warn when Hodir gains Frozen Blow.",
	frozenblow_message = "Hodir gained Frozen Blow!",
	frozenblow_warning = "Frozen Blow removed in 5sec!",
	frozenblow_bar = "Frozen Blow",

	hardmode = "Hard Mode Timer",
	hardmode_desc = "Show Timer for Hard Mode.",
	hardmode_warning = "Hard Mode ends",

	end_trigger = "I...I am released from his grasp! At...last!",
	end_message = "%s has been defeated!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "침입자는 쓴맛을 보게 될게다!",

	cold = "매서운 추위(업적)",
	cold_desc = "매서운 추위 2중첩시 알립니다.",
	cold_message = "매서운 추위(2중첩) - 이동!",

	flash = "순간 빙결",
	flash_desc = "순간 빙결 시전과 순간 빙결에 걸린 플레이어를 알립니다.",
	flash_message = "순간 빙결: %s!",
	flash_warning = "순간 빙결 시전!",
	flash_soon = "5초 후 순간 빙결",
	flash_bar = "다음 순간 빙결",

	frozenblow = "얼음 일격",
	frozenblow_desc = "호디르의 얼음 일격 획득을 알립니다.",
	frozenblow_message = "호디르 얼음 일격!",
	frozenblow_warning = "얼음 일격 5초 후 사라짐!",
	frozenblow_bar = "얼음 일격",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_warning = "도전 모드 종료",

	end_trigger = "드디어...드디어 그의 손아귀를!... 벗어나는구나!",	--check
	end_message = "%s 물리침!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous allez souffrir pour cette intrusion !", -- à vérifier

	cold = "Ça caille ici",
	cold_desc = "Prévient quand Froid mordant s'est empilé 2 fois sur votre personnage.",
	cold_message = "Froid mordant (2 cumuls) - bougez !",

	flash = "Gel instantané",
	flash_desc = "Prévient quand un joueur subit les effets d'un Gel instantané et quand le Gel instantané est incanté.",
	flash_message = "%s est un bloc de glace !",
	flash_warning = "Gel instantané en incantation !",
	flash_soon = "Gel instantané dans 5 sec. !",
	flash_bar = "Prochain Gel",

	frozenblow = "Coups gelés",
	frozenblow_desc = "Prévient quand Hodir gagne Coups gelés.",
	frozenblow_message = "Hodir gagne Coups gelés !",
	frozenblow_warning = "Fin des Coups gelés dans 5 sec. !",
	frozenblow_bar = "Coups gelés",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 minutes pour le mode difficile (délai avant qu'Hodir ne détruise sa cache).",
	hardmode_warning = "Jouons à casse-cache",

	end_trigger = "Je suis... libéré de son emprise ! Enfin !", -- à vérifier
	end_message = "%s a été vaincu !",
} end )

L:RegisterTranslations("deDE", function() return {
	--engage_trigger = "You will suffer for this trespass!", -- NEED!

	cold = "Beißende Kälte (Erfolg)",
	cold_desc = "Warnt, wenn du zwei Stapel von Beißende Kälte hast.",
	cold_message = "Beißende Kälte x2 - Bewege Dich!",

	flash = "Blitzeis",
	flash_desc = "Warnt, wenn Blitzeis gewirkt wird und wer davon betroffen ist.",
	flash_message = "Blitzeis: %s!",
	flash_warning = "Blitzeis!",
	flash_soon = "Blitzeis in 5 sek!",
	flash_bar = "Nächstes Blitzeis",

	frozenblow = "Gefrorene Schläge",
	frozenblow_desc = "Warnt, wenn Hodir Gefrorene Schläge bekommt.",
	frozenblow_message = "Hodir bekommt Gefrorene Schläge!",
	frozenblow_warning = "Gefrorene Schläge weg in 5 sek!",
	frozenblow_bar = "Gefrorene Schläge",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_warning = "Hard Mode beendet!",

	--end_trigger = "I...I am released from his grasp! At...last!", -- NEED!
	end_message = "%s wurde besiegt!",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	engage_trigger = "You will suffer for this trespass!",

	cold = "Biting Cold（成就）",
	cold_desc = "当你受到2层Biting Cold效果时发出警报。",
	cold_message = "Biting Cold（2层） - 移动！",

	flash = "Flash Freeze",
	flash_desc = "当正在施放Flash Freeze和玩家中了Flash Freeze时发出警报。",
	flash_message = "Flash Freeze：>%s<！",
	flash_warning = "正在施放 Flash Freeze！",
	flash_soon = "5秒后，Flash Freeze！",
	flash_bar = "<下一Flash>",

	frozenblow = "Frozen Blow",
	frozenblow_desc = "当霍迪尔获得Frozen Blow效果时发出警报。",
	frozenblow_message = "霍迪尔 - Frozen Blow！",
	frozenblow_warning = "5秒后，Frozen Blow消失！",
	frozenblow_bar = "<Frozen Blow>",

	end_trigger = "I...I am released from his grasp! At...last!",
	end_message = "%s被击败了！",
]]
} end )

L:RegisterTranslations("zhTW", function() return {
--	engage_trigger = "You will suffer for this trespass!",

	cold = "刺骨之寒（成就）",
	cold_desc = "當你受到2層刺骨之寒效果時發出警報。",
	cold_message = "刺骨之寒（2層） - 移動！",

	flash = "閃霜",
	flash_desc = "當正在施放閃霜和玩家中了閃霜時發出警報。",
	flash_message = "閃霜：>%s<！",
	flash_warning = "正在施放 閃霜！",
	flash_soon = "5秒后，閃霜！",
	flash_bar = "<下一閃霜>",

	frozenblow = "冰凍痛擊",
	frozenblow_desc = "當霍迪爾獲得冰凍痛擊效果時發出警報。",
	frozenblow_message = "霍迪爾 - 冰凍痛擊！",
	frozenblow_warning = "5秒后，冰凍痛擊消失！",
	frozenblow_bar = "<冰凍痛擊>",

--	end_trigger = "I...I am released from his grasp! At...last!",
	end_message = "%s被擊敗了！",
} end )

L:RegisterTranslations("ruRU", function() return {
	--engage_trigger = "You will suffer for this trespass!",

	cold = "Трескучий мороз(Достижение)",
	cold_desc = "Сообщать когда на вас наложено 2 эффекта Трескучего мороза",
	cold_message = "Трескучий мороз(2эффекта) - Бегите!",

	flash = "Мгновенная заморозка",
	flash_desc = "Сообщает кто подвергся мгновенной заморозке и когда она применяется.",
	flash_message = "%s подвергся мгновенной заморозке!",
	flash_warning = "Применение мгновенной заморозки!",
	flash_soon = "Мгновенная заморозка через 5сек!",
	flash_bar = "Следующая замарозка",

	frozenblow = "Ледяные дуновения",
	frozenblow_desc = "Сообщать когда Ходир накладывает на себя Ледяные дуновения.",
	frozenblow_message = "Ходир наложил на себя Ледяные дуновения!",
	frozenblow_warning = "Ледяные дуновения спадёт через 5сек!",
	frozenblow_bar = "Ледяные дуновения",

	hardmode = "Таймер сложного режима", --need review
	hardmode_desc = "Отображать таймер в сложном режиме.",--need review
	hardmode_warning = "Завершение сложного режима",--need review

	--end_trigger = "I...I am released from his grasp! At...last!",
	end_message = "%s побежден!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	db = self.db.profile

	self:AddCombatListener("SPELL_CAST_START", "FlashCast", 61968)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flash", 61969, 61990)
	self:AddCombatListener("SPELL_AURA_APPLIED", "FrozenBlow", 62478, 63512)
	self:AddCombatListener("SPELL_DAMAGE", "Cold", 62188)
	self:AddCombatListener("SPELL_MISSED", "Cold", 62188)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function mod:VerifyEnable(unit)
	return UnitIsEnemy(unit, "player") and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:FlashCast(_, spellID)
	if db.flash then
		self:IfMessage(L["flash_warning"], "Attention", spellID)
		self:Bar(L["flash"], 9, spellID)
		self:Bar(L["flash_bar"], 35, spellID)
		self:DelayedMessage(30, L["flash_soon"], "Attention")
	end
end

function mod:Flash(player)
	if UnitInRaid(player) and db.flash then
		FF[player] = true
		self:ScheduleEvent("BWFFWarn", self.FlashWarn, 0.5, self)
	end
end

function mod:FlashWarn()
	if db.flash then
		local msg = nil
		for k in pairs(FF) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:IfMessage(fmt(L["flash_message"], msg), "Attention", 61969, "Alert")
	end
	for k in pairs(FF) do FF[k] = nil end
end

function mod:FrozenBlow(_, spellID)
	if db.frozenblow then
		self:IfMessage(L["frozenblow_message"], "Attention", spellID)
		self:DelayedMessage(15, L["frozenblow_warning"], "Attention")
		self:Bar(L["frozenblow_bar"], 20, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.flash then
			self:Bar(L["flash_bar"], 35, 61968)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 180, "Ability_warrior_innerrage")
			self:DelayedMessage(180, L["hardmode_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(480, true)
		end
		for k in pairs(FF) do FF[k] = nil end
	elseif msg == L["end_trigger"] then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)
	end
end

function mod:UNIT_AURA(unit)
	if unit and unit ~= "player" then return end
	
	local bitingcold = nil
	for i = 1, 9 do
		local name, _, icon, stack = UnitDebuff("player", i)
		if not name then break end
		if icon == "Interface\\Icons\\Spell_Frost_IceShock" then
			if stack < 2 then return end
			bitingcold = icon
		end
	end
	if bitingcold then
		if db.cold then
			self:LocalMessage(L["cold_message"], "Personal", bitingcold, "Alert")
		end
		self:UnregisterEvent("UNIT_AURA")
	end
end

function mod:Cold()
	self:RegisterEvent("UNIT_AURA")
end
