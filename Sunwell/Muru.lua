------------------------------
--      Are you local?      --
------------------------------

local boss = BB["M'uru"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
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
} end )

L:RegisterTranslations("frFR", function() return {
	darkness = "Ténèbres",
	darkness_desc = "Préviens quand un joueur subit les effets des Ténèbres.",
	darkness_message = "Ténèbres : %s",
	darkness_next = "Prochaines Ténèbres",
	darkness_soon = "Ténèbres dans 5 sec. !",

	void = "Sentinelles du Vide",
	void_desc = "Préviens quand les Sentinelles du Vide apparaissent.",
	void_next = "Prochaine Sentinelle",
	void_soon = "Sentinelle dans 5 sec. !",

	humanoid = "Renforts humanoïdes",
	humanoid_desc = "Préviens quand les renforts humanoïdes apparaissent.",
	humanoid_next = "Prochains humanoïdes",
	humanoid_soon = "Humanoïdes dans 5 sec. !",
} end )

L:RegisterTranslations("koKR", function() return {
	darkness = "어둠",
	darkness_desc = "어둠에 걸린 플레이어를 알립니다.",
	darkness_message = "어둠: %s",
	darkness_next = "다음 어둠",
	darkness_soon = "5초 이내 어둠!",

	void = "공허의 파수병",
	void_desc = "공허의 파수병의 소환을 알립니다.",
	void_next = "다음 공허의 파수병",
	void_soon = "5초 이내 파수병!",

	humanoid = "타락한 엘프",
	humanoid_desc = "타락한 엘프 소환을 알립니다.",
	humanoid_next = "다음 타락한 엘프",
	humanoid_soon = "5초 이내 타락한 엘프!",
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
} end )

L:RegisterTranslations("zhTW", function() return {
	darkness = "黑暗",
	darkness_desc = "警示誰受到黑暗效果。",
	darkness_message = "黑暗：[%s]",
	darkness_next = "下一次黑暗",
	darkness_soon = "5 秒內黑暗！",

	void = "虛無哨兵",
	void_desc = "當虛無哨兵出現時警示。",
	void_next = "下一波虛無哨兵",
	void_soon = "5 秒內虛無哨兵出現！",

	humanoid = "虛無哨兵召喚者",
	humanoid_desc = "當虛無哨兵召喚者出現時警示。",
	humanoid_next = "下一波召喚者",
	humanoid_soon = "5 秒內召喚者出現！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"darkness", "void", "humanoid", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Darkness", 45996)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Darkness(player, spellID)
	if not db.darkness then return end

	if player == boss then
		self:Bar(L["darkness_message"], 20, spellID)
		self:IfMessage(L["darkness_message"]:format(player), "Urgent", spellID)
		self:Bar(L["darkness_next"], 45, spellID)
		self:DelayedMessage(40, L["darkness_soon"], "Attention")
	else
		inDark[player] = true
		self:ScheduleEvent("BWMuruDark", self.DarkWarn, 0.4, self)
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

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		for k in pairs(inDark) do inDark[k] = nil end
		if db.darkness then
			self:Bar(L["darkness_next"], 45, 45996)
			self:DelayedMessage(40, L["darkness_soon"], "Attention")
		end
		if db.void then
			self:Bar(L["void_next"], 35, 46087)
			self:DelayedMessage(30, L["void_soon"], "Positive")
		end
		if db.humanoid then
			self:Bar(L["humanoid_next"], 70, 46087)
			self:DelayedMessage(65, L["void_soon"], "Positive")
		end
	end
end

