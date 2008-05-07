------------------------------
--      Are you local?      --
------------------------------

local entropius = BB["Entropius"]
local boss = BB["M'uru"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
local p2 = nil
local pName = UnitName("player")
local inDark = {}

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
	phase2_soon_message = "Phase 2 soon!",
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

	--fiends = "Dark Fiends",
	--fiends_desc = "Warn for Dark Fiends spawning.",
	--fiends_message = "Dark Fiends Inc!",
	
	--phase = "Phases",
	--phase_desc = "Warn for phase changes.",
	--phase2_soon_message = "Phase 2 soon!",
} end )

L:RegisterTranslations("frFR", function() return {
	darkness = "Ténèbres",
	darkness_desc = "Prévient quand un joueur subit les effets des Ténèbres.",
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

	--fiends = "Dark Fiends",
	--fiends_desc = "Warn for Dark Fiends spawning.",
	--fiends_message = "Dark Fiends Inc!",
	
	--phase = "Phases",
	--phase_desc = "Warn for phase changes.",
	--phase2_soon_message = "Phase 2 soon!",
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
	phase2_soon_message = "잠시 후 2단계!",
} end )

L:RegisterTranslations("zhCN", function() return {
	darkness = "黑暗",--Darkness
	darkness_desc = "当玩家受到黑暗时发出警报。",
	darkness_message = "黑暗：>%s<！ ",
	darkness_next = "<下一黑暗>",
	darkness_soon = "5秒后，黑暗！",

	void = "虚空戒卫",--Void Sentinel
	void_desc = "当虚空戒卫刷新时发出警报。",
	void_next = "<下一虚空戒卫>",
	void_soon = "5秒后，虚空戒卫刷新！",

	humanoid = "人型生物",--Humanoids
	humanoid_desc = "人型生物刷新时发出警报。",
	humanoid_next = "<下一人型生物>",
	humanoid_soon = "5秒后，人型生物刷新！",

	--fiends = "Dark Fiends",
	--fiends_desc = "Warn for Dark Fiends spawning.",
	--fiends_message = "Dark Fiends Inc!",
	
	--phase = "Phases",
	--phase_desc = "Warn for phase changes.",
	--phase2_soon_message = "Phase 2 soon!",
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
	--phase2_soon_message = "Phase 2 soon!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", -1, "darkness", "void", "humanoid", "fiends", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Darkness", 45996)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Fiends", 45934)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("UNIT_HEALTH")

	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Darkness(player, spellID)
	if not db.darkness then return end

	if player == boss then
		self:Bar(L["darkness"], 20, spellID)
		self:IfMessage(L["darkness_message"]:format(player), "Urgent", spellID)
		self:Bar(L["darkness_next"], 45, spellID)
		self:ScheduleEvent("DarknessWarn", "BigWigs_Message", 40, L["darkness_soon"], "Attention")
	else
		inDark[player] = true
		self:ScheduleEvent("BWMuruDark", self.DarkWarn, 0.4, self)
	end
end

local last = 0
function mod:Fiends()
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if db.fiends then
			self:Message(L["fiends_message"], "Urgent", true, nil, nil, 45934)
		end
	end
end

function mod:Deaths(unit)
	if unit == entropius then
		self:GenericBossDeath(boss)
	end
end

function mod:DarkWarn()
	local msg = nil
	for k in pairs(inDark) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["darkness_message"]:format(msg), "Urgent", 45996)
end

function mod:RepeatVoid()
	if db.void then
		self:Bar(L["void_next"], 30, 46087)
		self:ScheduleEvent("VoidWarn", "BigWigs_Message", 25, L["void_soon"], "Attention")
	end
	self:ScheduleEvent("Void", self.RepeatVoid, 30, self)
end

function mod:RepeatHumanoid()
	if db.humanoid then
		self:Bar(L["humanoid_next"], 60, 46087)
		self:ScheduleEvent("HumanoidWarn", "BigWigs_Message", 55, L["humanoid_soon"], "Attention")
	end
	self:ScheduleEvent("Humanoid", self.RepeatHumanoid, 60, self)
end

function mod:UNIT_HEALTH(msg)
	if not db.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp < 2 and not p2 then
			self:Message(L["phase2_soon_message"], "Attention")
			p2 = true
			
			self:CancelScheduledEvent("VoidWarn")
			self:CancelScheduledEvent("HumanoidWarn")
			self:CancelScheduledEvent("Void")
			self:CancelScheduledEvent("Humanoid")
			self:CancelScheduledEvent("DarknessWarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["void_next"])
			self:TriggerEvent("BigWigs_StopBar", self, L["humanoid_next"])
			self:TriggerEvent("BigWigs_StopBar", self, L["darkness_next"])
		elseif hp > 4 and p2 then
			p2 = false
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		p2 = nil
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		for k in pairs(inDark) do inDark[k] = nil end
		if db.darkness then
			self:Bar(L["darkness_next"], 45, 45996)
			self:DelayedMessage(40, L["darkness_soon"], "Attention")
		end
		if db.void then
			self:Bar(L["void_next"], 34, 46087)
			self:DelayedMessage(29, L["void_soon"], "Attention")
		end
		if db.humanoid then
			self:Bar(L["humanoid_next"], 7, 46087)
		end
		self:ScheduleEvent("Void", self.RepeatVoid, 34, self)
		self:ScheduleEvent("Humanoid", self.RepeatHumanoid, 7, self)
	end
end
