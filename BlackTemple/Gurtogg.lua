------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Gurtogg Bloodboil"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local UnitName = UnitName
local db = nil
local fmt = string.format
local pName = UnitName("player")
local count = 1

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gurtogg",

	engage_trigger = "Horde will... crush you.",

	phase = "Phase Timers",
	phase_desc = "Timers for switching between normal and Fel Rage phases.",
	phase_rage_warning = "Fel Rage Phase in ~5 sec",
	phase_normal_warning = "Fel Rage over in ~5 sec",
	phase_normal = "Fel Rage Phase Over",
	phase_normal_bar = "~Approximate Rage Phase",
	phase_rage_bar = "Next Normal Phase",

	bloodboil = "Bloodboil",
	bloodboil_desc = "Warnings and counter for Bloodboil.",
	bloodboil_message = "Bloodboil(%d)",

	rage = "Fel Rage",
	rage_desc = "Warn who gets Fel Rage.",
	rage_you = "You have Fel Rage!!",
	rage_other = "%s has Fel Rage!",

	whisper = "Whisper",
	whisper_desc = "Whisper the player with Fel Rage (requires promoted or higher).",

	acid = "Fel-Acid Breath",
	acid_desc = "Warn who Fel-Acid Breath is being cast on.",
	acid_message = "Fel-Acid Casting on: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on who Fel-Acid Breath and Fel Rage is being cast on (requires promoted or higher).",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "La Horda...os aplastará",

	phase = "Contadores de fase",
	phase_desc = "Contadores para cambio entre fase normal y fase de Ira vil (Fel Rage).",
	phase_rage_warning = "Fase Ira vil en ~5 seg",
	phase_normal_warning = "Fase Ira vil acaba en ~5 seg",
	phase_normal = "Fase Ira vil finalizada",
	phase_normal_bar = "~Fase Ira vil",
	phase_rage_bar = "~Fase normal",

	bloodboil = "Sangre Hirviente (Bloodboil)",
	bloodboil_desc = "Avisos y contadores para Sangre Hirviente.",
	bloodboil_message = "Sangre Hirviente(%d)",

	rage = "Ira vil (Fel Rage)",
	rage_desc = "Avisar quién tiene Ira vil.",
	rage_you = "¡¡Tienes Ira vil!!",
	rage_other = "¡%s tiene Ira vil!",

	whisper = "Susurrar",
	whisper_desc = "Susurrar a jugadores con Ira vil (requiere derechos de banda).",

	acid = "Aliento de ácido vil (Fel-Acid Breath)",
	acid_desc = "Avisar sobre quién se va a lanzar Aliento de ácido vil.",
	acid_message = "Lanzando Aliento de ácido vil en: %s",

	icon = "Icono de banda",
	icon_desc = "Poner un icono de banda sobre los que van a recibir Aliento de ácido vil o Ira vil (requiere derechos de banda).",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "호드가... 박살내주마.",

	phase = "단계 타이머",
	phase_desc = "마의 분노 단계와 보통 단계 간의 변경에 대한 타이머입니다.",
	phase_rage_warning = "약 5초 이내 마의 분노 단계",
	phase_normal_warning = "약 5초 이내 마의 분노 종료",
	phase_normal = "마의 분노 단계 종료",
	phase_normal_bar = "다음 분노 형상",
	phase_rage_bar = "다음 보통 형상",

	bloodboil = "끓어오르는 피",
	bloodboil_desc = "끓어오르는 피에 대한 경고와 카운터입니다.",
	bloodboil_message = "끓어오르는 피(%d)",

	rage = "마의 분노",
	rage_desc = "마의 분노에 걸린 사람을 알립니다.",
	rage_you = "당신은 마의 분노!!",
	rage_other = "%s 마의 분노!",

	whisper = "귓속말",
	whisper_desc = "마의 분노에 걸린 플레이어에게 귓속말을 보냅니다 (승급자 이상 권한 요구).",

	acid = "지옥 산성 숨결",
	acid_desc = "지옥 산성 숨결의 시전 대상을 알립니다.",
	acid_message = "지옥 산성 숨결 시전 중 : %s",

	icon = "전술 표시",
	icon_desc = "지옥 산성 숨결의 시전 대상에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Horde... wird Euch zerschmettern.",

	phase = "Phasen Timer",
	phase_desc = "Timer für den Wechsel zwischen normaler und Teufelswut Phase.",
	phase_rage_warning = "Teufelswut Phase in ~5 sec",
	phase_normal_warning = "Teufelswut vorbei in ~5 sec",
	phase_normal = "Teufelswut Phase vorbei",
	phase_normal_bar = "Nächste Teufelswut Phase",
	phase_rage_bar = "Nächste Normale Phase",

	bloodboil = "Siedeblut",
	bloodboil_desc = "Warnungen und Timer für Siedeblut.",
	bloodboil_message = "Siedeblut: (%d)",

	rage = "Teufelswut",
	rage_desc = "Warnt, wer Teufelswut bekommt.",
	rage_you = "Du hast Teufelswut!!",
	rage_other = "%s hat Teufelswut!",

	whisper = "Flüstern",
	whisper_desc = "Flüstert dem Spieler mit Teufelswut (benötigt Assistent oder höher).",

	acid = "Teufelssäureatem",
	acid_desc = "Warnt auf wen Teufelssäureatem gezaubert wird.",
	acid_message = "Teufelssäureatem auf: %s",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf dem Spieler, der Teufelssäureatem abbekommt (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "La Horde va... vous écraser.",

	phase = "Délais entre les phases",
	phase_desc = "Délais entre les phases normales et les phases de Gangrerage.",
	phase_rage_warning = "Phase de Gangrerage dans ~5 sec.",
	phase_normal_warning = "Gangrerage terminée dans ~5 sec.",
	phase_normal = "Fin de la phase de Gangrerage",
	phase_normal_bar = "~Prochaine phase de rage",
	phase_rage_bar = "Prochaine phase normale",

	bloodboil = "Fièvresang",
	bloodboil_desc = "Avertissements et compteur des Fièvresangs.",
	bloodboil_message = "Fièvresang (%d)",

	rage = "Gangrerage",
	rage_desc = "Préviens quand un joueur subit les effets de la Gangrerage.",
	rage_you = "Vous avez la Gangrerage !",
	rage_other = "%s a la Gangrerage !",

	whisper = "Chuchoter",
	whisper_desc = "Chuchote au dernier joueur affecté par la Gangrerage (nécessite d'être promu ou mieux).",

	acid = "Souffle d'acide gangrené",
	acid_desc = "Préviens sur qui le Souffle d'acide gangrené est incanté.",
	acid_message = "Souffle d'acide gangrené incanté sur : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le joueur sur qui le Souffle d'acide gangrené est incanté (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "部落會……毀滅你們。",

	phase = "階段計時器",
	phase_desc = "普通階段與惡魔之怒階段計時",
	phase_rage_warning = "5 秒後惡魔之怒階段",
	phase_normal_warning = "5 秒後結束惡魔之怒",
	phase_normal = "惡魔之怒階段結束",
	phase_normal_bar = "~即將惡魔之怒階段",
	phase_rage_bar = "下一個普通階段",

	bloodboil = "血液沸騰",
	bloodboil_desc = "警告並計算血液沸騰.",
	bloodboil_message = "血液沸騰(%d)",

	rage = "惡魔之怒",
	rage_desc = "提示誰受到惡魔之怒",
	rage_you = "你受到惡魔之怒!!",
	rage_other = "惡魔之怒：[%s]",

	whisper = "發送密語",
	whisper_desc = "發送密語給受到惡魔之怒的玩家 (需要權限)",

	acid = "魔化酸液噴吐",
	acid_desc = "提示誰受到魔化酸液噴吐",
	acid_message = "魔化酸液噴吐：[%s]",

	icon = "團隊標記",
	icon_desc = "放置團隊標記在受到魔化酸液噴吐的隊友頭上 (需要權限)",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "部落会……毁灭你们。",

	phase = "阶段计时器",
	phase_desc = "普通或邪能狂怒状态转换阶段计时。",
	phase_rage_warning = "邪能狂怒！约5秒后发动。",
	phase_normal_warning = "约5秒后，结束邪能狂怒！",
	phase_normal = "邪能狂怒 阶段结束",
	phase_normal_bar = "<下一邪能狂怒>",
	phase_rage_bar = "<下一普通阶段>",

	bloodboil = "血沸",
	bloodboil_desc = "血沸计数及警报。",
	bloodboil_message = "血沸：>%d<！",

	rage = "邪能狂怒",
	rage_desc = "当获得邪能狂怒时发出警报",
	rage_you = ">你< 邪能狂怒！",
	rage_other = "邪能狂怒：>%s<！",

	whisper = "密语",
	whisper_desc = "当完家中了邪能狂怒进行密语提醒。（需要权限）",

	acid = "邪酸吐息",
	acid_desc = "当玩家受到邪酸吐息攻击时发出警报。",
	acid_message = "邪酸吐息：>%s<！",

	icon = "团队标记",
	icon_desc = "给中了邪酸吐息的队员打上团队标记。（需要权限）",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "bloodboil", -1, "rage", "whisper", -1, "acid", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Blood", 42005)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Rage", 40604)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FelRageRemoved", 40594)
	self:AddCombatListener("SPELL_CAST_START", "Acid", 40508)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Blood(_, spellID)
	if db.bloodboil then
		self:IfMessage(fmt(L["bloodboil_message"], count), "Attention", spellID)
		if count == 3 then count = 0 end
		count = count + 1
		self:Bar(fmt(L["bloodboil_message"], count), 10, spellID)
	end
end

function mod:Rage(player, spellID)
	self:TriggerEvent("BigWigs_StopBar", self, fmt(L["bloodboil_message"], count))
	if db.rage then
		self:CancelScheduledEvent("rage1")
		self:TriggerEvent("BigWigs_StopBar", self, L["phase_normal_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["bloodboil_message"], count))

		if player == pName then
			self:LocalMessage(L["rage_you"], "Personal", spellID, "Long")
			self:WideMessage(fmt(L["rage_other"], player))
		else
			self:IfMessage(fmt(L["rage_other"], player), "Attention", spellID)
		end
		self:Whisper(player, L["rage_you"], "whisper")
		if db.phase then
			self:Bar(L["phase_rage_bar"], 28, spellID)
			self:DelayedMessage(23, L["phase_normal_warning"], "Important")
		end
		self:Icon(player, "icon")
	end
end

function mod:FelRageRemoved(unit)
	if unit == boss then
		if db.phase then
			self:Bar(L["phase_normal_bar"], 60, "Spell_Fire_ElementalDevastation")
			self:ScheduleEvent("rage1", "BigWigs_Message", 55, L["phase_rage_warning"], "Important")
			self:Message(L["phase_normal"], "Attention")
		end
		count = 1
		if db.bloodboil then
			self:Bar(fmt(L["bloodboil_message"], count), 10, "Spell_Shadow_BloodBoil")
		end
	end
end

function mod:Acid()
	if db.acid then
		self:Bar(L["acid"], 2, 40508)
		self:ScheduleEvent("BWAcidToTScan", self.AcidCheck, 0.2, self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		count = 1
		if db.phase then
			self:Bar(L["phase_normal_bar"], 49, "Spell_Fire_ElementalDevastation")
			self:ScheduleEvent("rage1", "BigWigs_Message", 44, L["phase_rage_warning"], "Important")
		end
		if db.enrage then
			self:Enrage(600)
		end
		if db.bloodboil then
			self:Bar(fmt(L["bloodboil_message"], count), 11, "Spell_Shadow_BloodBoil")
		end
	end
end

function mod:AcidCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		self:IfMessage(fmt(L["acid_message"], target), "Attention", 40508)
		if db.icon then
			self:Icon(target)
			self:ScheduleEvent("ClearIcon", "BigWigs_RemoveRaidIcon", 5, self)
		end
	end
end

