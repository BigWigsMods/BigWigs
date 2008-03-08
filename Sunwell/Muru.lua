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

