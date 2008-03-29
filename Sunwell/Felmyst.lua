------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Felmyst"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local pName = UnitName("player")
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Felmyst",

	encaps = "Encapsulate",
	encaps_desc = "Warn who has Encapsulate.",
	encaps_message = "Encapsulate: %s",

	gas = "Gas Nova",
	gas_desc = "Warn for Gas Nova being cast.",
	gas_message = "Casting Gas Nova!",
	gas_bar = "~Gas Nova Cooldown",
} end )

L:RegisterTranslations("zhCN", function() return {

	encaps = "压缩",--Encapsulate
	encaps_desc = "当受到压缩时发出警报。",
	encaps_message = "压缩：>%s<！",

	gas = "毒气新星",--Gas Nova
	gas_desc = "当施放毒气新星时发出警报。",
	gas_message = "正在施放毒气新星！",
	gas_bar = "<毒气新星冷却>",
} end )

L:RegisterTranslations("koKR", function() return {
	encaps = "가두기",
	encaps_desc = "가두기에 걸린 플레이어를 알립니다.",
	encaps_message = "가두기: %s",

	gas = "가스 회오리",
	gas_desc = "가스 회오리의 시전에 대해 알립니다..",
	gas_message = "가스 회오리 시전!",
	gas_bar = "~가스 회오리 대기시간",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"encaps", "gas", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:AddCombatListener("SPELL_CAST_START", "Gas", 45855)
	self:AddCombatListener("SPELL_DAMAGE", "Encapsulate", 45662)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Gas(_, spellID)
	if db.gas then
		self:IfMessage(L["gas_message"], "Attention", spellID, "Alert")
		self:Bar(L["gas_bar"], 20, spellID)
	end
end

local seenEncaps = 0
function mod:Encapsulate(player, spellID)
	if db.encaps then
		if GetTime() - seenEncaps >= 10 and self:HasEncaps(player) then
			self:IfMessage(L["encaps_message"]:format(player), "Important", spellID)
			self:Icon(player)
			seenEncaps = GetTime()
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:PhaseOne()
		if db.enrage then
			self:Enrage(600)
		end
	end
end

function mod:PhaseOne()
	self:Bar("Takeoff", 60, 31550)
	self:DelayedMessage(55, "Taking off in 5 Seconds!", "Attention")

	self:Bar(L["encaps"], 30, 45661)
	self:DelayedMessage(25, "Encapsulate in ~5 Seconds!", Attention)

	self:ScheduleEvent("BWFelmystStage", self.PhaseTwo, 60, self)
end

function mod:PhaseTwo()
	self:Bar("Landing", 100, 31550)
	self:DelayedMessage(90, "Landing in 10 Seconds!", Attention)
	self:ScheduleEvent("BWFelmystStage", self.PhaseOne, 100, self)
end

