------------------------------
--      Are you local?      --
------------------------------

local entropius = BB["Entropius"]
local boss = BB["M'uru"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
local phase = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Muru",

	darkness = "Darkness",
	darkness_desc = "Warn who has Darkness.",
	darkness_message = "Darkness: %s",
	darkness_next = "Next Darkness",
	darkness_soon = "Darkness in 5sec!",

	void = "Void Sentinel",
	void_desc = "Warn when the Void Sentinel spawns.",
	void_next = "Next Void Sentinel",
	void_soon = "Sentinel in 5 sec!",

	humanoid = "Humanoid Adds",
	humanoid_desc = "Warn when the Humanoid Adds spawn.",
	humanoid_next = "Next Humanoids",
	humanoid_soon = "Humanoids in 5sec!",

	fiends = "Dark Fiends",
	fiends_desc = "Warn for Dark Fiends spawning.",
	fiends_message = "Dark Fiends Inc!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_message = "Phase 2",

	gravity = "Gravity Balls",
	gravity_desc = "Warn for Gravity Balls.",
	gravity_next = "Next Gravity Ball Timer",
	gravity_soon = "Gravity Ball soon!",
} end )

L:RegisterTranslations("esES", function() return {
	darkness = "Oscuridad (Darkness)",
	darkness_desc = "Avisar quién tiene Oscuridad.",
	darkness_message = "Oscuridad: %s",
	darkness_next = "~Oscuridad",
	darkness_soon = "Oscuridad en 5 seg",

	void = "Centinela del vacío (Void Sentinel)",
	void_desc = "Avisar cuando aparece un centinela del vacío.",
	void_next = "~Centinela",
	void_soon = "Centinela en 5 seg",

	humanoid = "Añadidos humanoides",
	humanoid_desc = "Avisar cuando aparecen los humanoides.",
	humanoid_next = "~Humanoides",
	humanoid_soon = "Humanoides en 5 seg",

	fiends = "Malignos oscuros (Dark Fiends)",
	fiends_desc = "Avisar cuando aparecen Malignos oscuros.",
	fiends_message = "¡Malignos oscuros!",

	phase = "Fases",
	phase_desc = "Avisar sobre las distintas fases del encuentro.",
	phase2_message = "¡Fase 2!",

	--gravity = "Gravity Balls",
	--gravity_desc = "Warn for Gravity Balls.",
	--gravity_next = "Next Gravity Ball Timer",
	--gravity_soon = "Gravity Ball soon!",
} end )

L:RegisterTranslations("frFR", function() return {
	darkness = "Ténèbres",
	darkness_desc = "Prévient quand quelqu'un subit les effets des Ténèbres.",
	darkness_message = "Ténèbres : %s",
	darkness_next = "Prochaines Ténèbres",
	darkness_soon = "Ténèbres dans 5 sec. !",

	void = "Sentinelles du Vide",
	void_desc = "Prévient quand les Sentinelles du Vide apparaissent.",
	void_next = "Prochaine Sentinelle",
	void_soon = "Sentinelle dans 5 sec. !",

	humanoid = "Renforts humanoïdes",
	humanoid_desc = "Prévient quand les renforts humanoïdes apparaissent.",
	humanoid_next = "Prochains humanoïdes",
	humanoid_soon = "Humanoïdes dans 5 sec. !",

	fiends = "Sombres fiels",
	fiends_desc = "Prévient quand les Sombres fiels apparaissent.",
	fiends_message = "Arrivée des Sombres fiels !",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase2_message = "Phase 2 !",

	gravity = "Trou noir",
	gravity_desc = "Prévient de l'arrivée des Trous noirs.",
	gravity_next = "Prochain Trou noir",
	gravity_soon = "Trou noir imminent !",
} end )

L:RegisterTranslations("koKR", function() return {
	darkness = "어둠",
	darkness_desc = "어둠에 걸린 플레이어를 알립니다.",
	darkness_message = "어둠: %s",
	darkness_next = "다음 어둠",
	darkness_soon = "5초 후 어둠!",

	void = "공허의 파수병",
	void_desc = "공허의 파수병의 소환을 알립니다.",
	void_next = "다음 공허의 파수병",
	void_soon = "5초 이내 파수병!",

	humanoid = "타락한 엘프",
	humanoid_desc = "타락한 엘프 등장을 알립니다.",
	humanoid_next = "다음 타락한 엘프",
	humanoid_soon = "5초 이내 타락한 엘프!",

	fiends = "어둠 마귀",
	fiends_desc = "어둠 마귀 소환을 알립니다.",
	fiends_message = "잠시 후 어둠 마귀!",

	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	phase2_message = "2 단계!",

	gravity = "중력 구체",
	gravity_desc = "중력 구체를 알립니다.",
	gravity_next = "다음 중력 구체",
	gravity_soon = "잠시 후 중력 구체!",
} end )

L:RegisterTranslations("zhCN", function() return {
	darkness = "黑暗",
	darkness_desc = "当玩家受到黑暗时发出警报。",
	darkness_message = "黑暗：>%s<！ ",
	darkness_next = "<下一黑暗>",
	darkness_soon = "5秒后，黑暗！",

	void = "虚空戒卫",
	void_desc = "当虚空戒卫刷新时发出警报。",
	void_next = "<下一虚空戒卫>",
	void_soon = "5秒后，虚空戒卫刷新！",

	humanoid = "暗誓精灵",
	humanoid_desc = "当暗誓精灵刷新时发出警报。",
	humanoid_next = "<下一暗誓精灵>",
	humanoid_soon = "5秒后，暗誓精灵刷新！",

	fiends = "黑暗魔",
	fiends_desc = "当黑暗魔刷新时发出警报。",
	fiends_message = "黑暗魔 出现！",

	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	phase2_message = "第二阶段！",

	gravity = "重力球",
	gravity_desc = "当施放重力球时发出警报。",
	gravity_next = "<下一重力球>",
	gravity_soon = "即将 重力球！",
} end )

L:RegisterTranslations("zhTW", function() return {
	darkness = "黑暗",
	darkness_desc = "警報誰受到黑暗效果",
	darkness_message = "黑暗: [%s]",
	darkness_next = "下一次黑暗",
	darkness_soon = "約 5 秒內施放黑暗!",

	void = "虛無哨兵",
	void_desc = "當虛無哨兵出現時發出警報",
	void_next = "下一波虛無哨兵",
	void_soon = "約 5 秒內虛無哨兵出現!",

	humanoid = "虛無哨兵召喚者",
	humanoid_desc = "當虛無哨兵召喚者出現時發出警報",
	humanoid_next = "下一波召喚者",
	humanoid_soon = "約 5 秒內召喚者出現!",

	--fiends = "Dark Fiends",
	--fiends_desc = "Warn for Dark Fiends spawning.",
	--fiends_message = "Dark Fiends Inc!",

	--phase = "Phases",
	--phase_desc = "Warn for phase changes.",
	--phase2_message = "Phase 2!",

	--gravity = "Gravity Balls",
	--gravity_desc = "Warn for Gravity Balls.",
	--gravity_next = "Next Gravity Ball Timer",
	--gravity_soon = "Gravity Ball soon!",
} end )

L:RegisterTranslations("deDE", function() return {
	darkness = "Dunkelheit",
	darkness_desc = "Warnung wer von Dunkelheit betroffen ist.",
	darkness_message = "Dunkelheit: %s",
	darkness_next = "Nächste Dunkelheit",
	darkness_soon = "Dunkelheit in 5sek!",

	void = "Leerenwache",
	void_desc = "Warnung wenn eine Leerenwache erscheint.",
	void_next = "Nächste Leerenwache",
	void_soon = "Leerenwache in 5 sek!",

	humanoid = "Menschliche Wache",
	humanoid_desc = "Warnung wenn Menschliche Wachen erscheinen.",
	humanoid_next = "Nächste Wachen",
	humanoid_soon = "Wachen in 5sec!",

	fiends = "Finsteres Scheusal",
	fiends_desc = "Warnung wenn Finsteres Scheusale erscheinen.",
	fiends_message = "Finsteres Scheusale Inc!",

	phase = "Phasen",
	phase_desc = "Warnung bei Phasenänderrungen.",
	phase2_message = "Phase 2",

	gravity = "Schwerkraftkugel",
	gravity_desc = "Warnung wann die Schwerkraftkugel erscheint.",
	gravity_next = "Nächste Schwerkraftkugel",
	gravity_soon = "Schwerkraftkugel bald!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.guid = 25840
mod.toggleoptions = {"phase", -1, "darkness", "void", "humanoid", "fiends", "gravity", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Darkness", 45996)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Fiends", 45934)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Portals", 46177)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "GravityBall", 46282)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
	phase = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Darkness(unit, spellID)
	if unit == boss and db.darkness then
		self:Bar(L["darkness"], 20, spellID)
		self:IfMessage(L["darkness_message"]:format(unit), "Positive", spellID)
		self:Bar(L["darkness_next"], 45, spellID)
		self:ScheduleEvent("DarknessWarn", "BigWigs_Message", 40, L["darkness_soon"], "Positive")
	end
end

local last = 0
function mod:Fiends()
	if db.fiends then
		if phase == 1 then
			local time = GetTime()
			if (time - last) > 5 then
				last = time
				self:Message(L["fiends_message"], "Important", true, nil, nil, 45934)
			end
		elseif phase == 2 then
			self:Message(L["fiends_message"], "Important", true, nil, nil, 45934)
		end
	end
end

function mod:Portals()
	phase = 2

	self:CancelScheduledEvent("VoidWarn")
	self:CancelScheduledEvent("HumanoidWarn")
	self:CancelScheduledEvent("Void")
	self:CancelScheduledEvent("Humanoid")
	self:CancelScheduledEvent("DarknessWarn")
	self:TriggerEvent("BigWigs_StopBar", self, L["void_next"])
	self:TriggerEvent("BigWigs_StopBar", self, L["humanoid_next"])
	self:TriggerEvent("BigWigs_StopBar", self, L["darkness_next"])
	if db.phase then
		self:Message(L["phase2_message"], "Attention")
		self:Bar(entropius, 10, 46087)
	end
	if db.gravity then
		self:Bar(L["gravity_next"], 27, 44218)
	end
end

function mod:GravityBall()
	if db.gravity then
		--44218 , looks like a Gravity Balls :p
		self:Bar(L["gravity_next"], 15, 44218)
		self:DelayedMessage(5, L["gravity_soon"], "Urgent")
	end
end

function mod:RepeatVoid()
	self:Bar(L["void_next"], 30, 46087)
	self:ScheduleEvent("VoidWarn", "BigWigs_Message", 25, L["void_soon"], "Attention")
	self:ScheduleEvent("Void", self.RepeatVoid, 30, self)
end

function mod:RepeatHumanoid()
	self:Bar(L["humanoid_next"], 60, 46087)
	self:ScheduleEvent("HumanoidWarn", "BigWigs_Message", 55, L["humanoid_soon"], "Urgent")
	self:ScheduleEvent("Humanoid", self.RepeatHumanoid, 60, self)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.darkness then
			self:Bar(L["darkness_next"], 45, 45996)
			self:DelayedMessage(40, L["darkness_soon"], "Positive")
		end
		if db.void then
			self:Bar(L["void_next"], 30, 46087)
			self:DelayedMessage(25, L["void_soon"], "Attention")
			self:ScheduleEvent("Void", self.RepeatVoid, 30, self)
		end
		if db.humanoid then
			self:Bar(L["humanoid_next"], 10, 46087)
			self:ScheduleEvent("Humanoid", self.RepeatHumanoid, 10, self)
		end
		if db.enrage then
			self:Enrage(600)
		end
	end
end
