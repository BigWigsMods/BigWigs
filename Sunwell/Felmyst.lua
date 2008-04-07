------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Felmyst"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local pName = UnitName("player")
local GetNumRaidMembers = GetNumRaidMembers
local IsItemInRange = IsItemInRange
local UnitName = UnitName
local fmt = string.format
local db = nil
local bandages = {
	[21991] = true, -- Heavy Netherweave Bandage
	[21990] = true, -- Netherweave Bandage
	[14530] = true, -- Heavy Runecloth Bandage
	[14529] = true, -- Runecloth Bandage
	[8545] = true, -- Heavy Mageweave Bandage
	[8544] = true, -- Mageweave Bandage
	[6451] = true, -- Heavy Silk Bandage
	[6450] = true, -- Silk Bandage
	[3531] = true, -- Heavy Wool Bandage
	[3530] = true, -- Wool Bandage
	[2581] = true, -- Heavy Linen Bandage
	[1251] = true, -- Linen Bandage
}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Felmyst",

	encaps = "Encapsulate",
	encaps_desc = "Warn who has Encapsulate.",
	encaps_warning = "Encapsulate in ~5 Seconds!",
	encaps_message = "Encapsulate: %s",

	gas = "Gas Nova",
	gas_desc = "Warn for Gas Nova being cast.",
	gas_message = "Casting Gas Nova!",
	gas_bar = "~Gas Nova Cooldown",
	
	takeoff = "Takeoff",
	takeoff_message = "Taking off in 5 Seconds!",
	
	landing = "Landing",
	landing_message = "Landing in 10 Seconds!",
} end )

L:RegisterTranslations("zhCN", function() return {

	encaps = "压缩",--Encapsulate
	encaps_desc = "当玩家受到压缩时发出警报。",
	encaps_warning = "约5秒后，压缩！",
	encaps_message = "压缩：>%s<！",

	gas = "毒气新星",--Gas Nova
	gas_desc = "当施放毒气新星时发出警报。",
	gas_message = "正在施放毒气新星！",
	gas_bar = "<毒气新星 冷却>",
	
	takeoff = "升空",
	takeoff_message = "5秒后，升空！",
	
	landing = "降落",
	landing_message = "10秒后，降落！",
} end )

L:RegisterTranslations("koKR", function() return {
	encaps = "가두기",
	encaps_desc = "가두기에 걸린 플레이어를 알립니다.",
	encaps_warning = "약 5초 이내 가두기!",
	encaps_message = "가두기: %s",

	gas = "가스 회오리",
	gas_desc = "가스 회오리의 시전에 대해 알립니다..",
	gas_message = "가스 회오리 시전!",
	gas_bar = "~가스 회오리 대기시간",
	
	takeoff = "이륙",
	takeoff_message = "5초 이내 이륙!",
	
	landing = "착지",
	landing_message = "10초 이내 착지!",
} end )

L:RegisterTranslations("frFR", function() return {
	encaps = "Enfermer",
	encaps_desc = "Préviens quand un joueur subit les effets d'Enfermer.",
	encaps_warning = "Enfermer dans ~5 sec. !",
	encaps_message = "Enfermer : %s",

	gas = "Nova de gaz",
	gas_desc = "Préviens quand la Nova de gaz est incanté.",
	gas_message = "Nova de gaz en incantation !",
	gas_bar = "~Cooldown Nova de gaz",

	takeoff = "Décollage",
	takeoff_message = "Décollage dans 5 sec. !",

	landing = "Atterrissage",
	landing_message = "Atterrissage dans 10 sec. !",
} end )

L:RegisterTranslations("zhTW", function() return {
	encaps = "封印",
	encaps_desc = "警示誰受到封印效果。",
	--encaps_warning = "Encapsulate in ~5 Seconds!",
	encaps_message = "封印：[%s]",

	gas = "毒氣新星",
	gas_desc = "當毒氣新星準備施放時警示。",
	gas_message = "毒氣新星施放中！",
	gas_bar = "毒氣新星冷卻計時",
	
	--takeoff = "Takeoff",
	--takeoff_message = "Taking off in 5 Seconds!",
	
	--landing = "Landing",
	--landing_message = "Landing in 10 Seconds!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"encaps", "gas", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) 
	for k, v in pairs( bandages ) do
		if IsItemInRange( k, unit) == 1 then
			return true
		end
	end
	return false
end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:AddCombatListener("SPELL_CAST_START", "Gas", 45855)
	--self:AddCombatListener("SPELL_DAMAGE", "Encapsulate", 45662)
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

local active = nil
local function killTime()
	active = nil
end

local encaps = GetSpellInfo(45665)
function mod:Encapsulate()
	if active then return end

	if db.encaps then
		for i = 1, GetNumRaidMembers() do
			local id = fmt("%s%d", "raid", i)
			local c = 1
			while UnitDebuff(id, c) do
				if UnitDebuff(id, c) == encaps then
					local player = UnitName(id)
					local msg = fmt(L["encaps_message"], player)
					self:IfMessage(msg, "Important", spellID)
					self:Bar(msg, 6, 45665)
					self:Icon(player)
					active = true
					self:ScheduleEvent("BWFelmystAllowScan", killTime, 8)
				end
				c = c + 1
			end
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
		self:ScheduleRepeatingEvent("BWEncapsScan", self.Encapsulate, 1, self)
		self:TriggerEvent("BigWigs_ShowProximity", self)
		if db.enrage then
			self:Enrage(600)
		end
	end
end

function mod:PhaseOne()
	self:Bar(L["takeoff"], 60, 31550)
	self:DelayedMessage(55, L["takeoff_message"], "Attention")

	self:Bar(L["encaps"], 30, 45661)
	self:DelayedMessage(25, L["encaps_warning"], Attention)

	self:ScheduleEvent("BWFelmystStage", self.PhaseTwo, 60, self)
end

function mod:PhaseTwo()
	self:Bar(L["landing"], 100, 31550)
	self:DelayedMessage(90, L["landing_message"], Attention)
	self:ScheduleEvent("BWFelmystStage", self.PhaseOne, 100, self)
end

