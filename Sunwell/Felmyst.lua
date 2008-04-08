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
local count = 1
local pass = {}
local fail = {}
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

	phase = "Phases",
	phase_desc = "Warn for takeoff and landing phases.",
	airphase_trigger = "I am stronger than ever before!",
	takeoff_bar = "Takeoff",
	takeoff_message = "Taking off in 5 Seconds!",
	landing_bar = "Landing",
	landing_message = "Landing in 10 Seconds!",

	breath = "Deep Breath",
	breath_desc = "Deep Breath warnings.",
	breath_trigger = "%s takes a deep breath.",
	breath_nextbar = "~Breath Cooldown (%d)",
	breath_warn = "Inc Breath (%d)!",

	dispel = "Mass Dispel Results",
	dispel_desc = "If you're a priest, will print in /say who your mass dispel failed and worked on.",
	dispel_pass = "Dispelled: ",
	dispel_fail = "Failed: ",
	dispel_none = "none",
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

	phase = "阶段警报",
	phase_desc = "当升空或降落阶段时发出警报。",
	airphase_trigger = "",--need combatlog
	takeoff_bar = "升空",
	takeoff_message = "5秒后，升空！",
	landing_bar = "降落",
	landing_message = "10秒后，降落！",

	breath = "深呼吸",
	breath_desc = "当施放深呼吸时发出警报。",
	breath_trigger = "%s深深地吸了一口气。",--need combatlog
	breath_nextbar = "<下一深呼吸：%d>",
	breath_warn = "深呼吸：>%d<！",

	dispel = "群体驱散结果",
	dispel_desc = "如果你是牧师，将在 /say 提示谁处于群体驱散范围内。",
	dispel_pass = "驱散范围内：",
	dispel_fail = "距离过远：",
	dispel_none = "无",
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

	--phase = "Phases",
	--phase_desc = "Warn for takeoff and landing phases.",
	--airphase_trigger = "I am stronger than ever before!",
	takeoff_bar = "이륙",
	takeoff_message = "5초 이내 이륙!",
	landing_bar = "착지",
	landing_message = "10초 이내 착지!",

	--breath = "Deep Breath",
	--breath_desc = "Deep Breath warnings.",
	--breath_trigger = "%s takes a deep breath.",
	--breath_nextbar = "~Breath Cooldown (%d)",
	--breath_warn = "Inc Breath (%d)!",

	--dispel = "Mass Dispel Results",
	--dispel_desc = "If you're a priest, will print in /say who your mass dispel failed and worked on.",
	--dispel_pass = "Dispelled: ",
	--dispel_fail = "Failed: ",
	--dispel_none = "none",
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

	--phase = "Phases",
	--phase_desc = "Warn for takeoff and landing phases.",
	--airphase_trigger = "I am stronger than ever before!",
	takeoff_bar = "Décollage",
	takeoff_message = "Décollage dans 5 sec. !",
	landing_bar = "Atterrissage",
	landing_message = "Atterrissage dans 10 sec. !",

	--breath = "Deep Breath",
	--breath_desc = "Deep Breath warnings.",
	--breath_trigger = "%s takes a deep breath.",
	--breath_nextbar = "~Breath Cooldown (%d)",
	--breath_warn = "Inc Breath (%d)!",

	--dispel = "Mass Dispel Results",
	--dispel_desc = "If you're a priest, will print in /say who your mass dispel failed and worked on.",
	--dispel_pass = "Dispelled: ",
	--dispel_fail = "Failed: ",
	--dispel_none = "none",
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

	--phase = "Phases",
	--phase_desc = "Warn for takeoff and landing phases.",
	--airphase_trigger = "I am stronger than ever before!",
	--takeoff_bar = "Takeoff",
	--takeoff_message = "Taking off in 5 Seconds!",
	--landing_bar = "Landing",
	--landing_message = "Landing in 10 Seconds!",

	--breath = "Deep Breath",
	--breath_desc = "Deep Breath warnings.",
	--breath_trigger = "%s takes a deep breath.",
	--breath_nextbar = "~Breath Cooldown (%d)",
	--breath_warn = "Inc Breath (%d)!",

	--dispel = "Mass Dispel Results",
	--dispel_desc = "If you're a priest, will print in /say who your mass dispel failed and worked on.",
	--dispel_pass = "Dispelled: ",
	--dispel_fail = "Failed: ",
	--dispel_none = "none",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "breath", -1, "encaps", "gas", "dispel", "enrage", "proximity", "bosskill"}
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
	--self:AddCombatListener("SPELL_AURA_APPLIED", "Encapsulate", 45662) --Maybe one day
	local _, class = UnitClass("player")
	if class == "PRIEST" then
		self:AddCombatListener("SPELL_AURA_DISPELLED", "Dispel", 32375) --Mass Dispel catcher
		self:AddCombatListener("SPELL_DISPEL_FAILED", "DispelFail", 32375) --Mass Dispel catcher
	end
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Gas(_, spellID)
	if db.gas then
		self:IfMessage(L["gas_message"], "Attention", spellID, "Alert")
		self:Bar(L["gas_bar"], 22, spellID)
	end
end

function mod:Dispel(player, _, source)
	if UnitIsUnit(source, "player") and db.dispel then
		pass[player] = true
		self:ScheduleEvent("BWFelmystDispelWarn", self.DispelWarn, 0.3, self)
	end
end

function mod:DispelFail(player, _, source)
	if UnitIsUnit(source, "player") and db.dispel then
		fail[player] = true
		self:ScheduleEvent("BWFelmystDispelWarn", self.DispelWarn, 0.3, self)
	end
end

function mod:DispelWarn()
	local one = nil
	for k in pairs(pass) do
		if not one then
			one = k or L["dispel_none"]
		else
			one = one .. ", " .. k
		end
	end
	local two = nil
	for k in pairs(fail) do
		if not two then
			two = k or L["dispel_none"]
		else
			two = two .. ", " .. k
		end
	end
	SendChatMessage(("%s%s %s%s"):format(L["dispel_pass"], one or L["dispel_none"], L["dispel_fail"], two or L["dispel_none"]), "SAY")
	for k in pairs(pass) do pass[k] = nil end
	for k in pairs(fail) do fail[k] = nil end
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
		for k in pairs(pass) do pass[k] = nil end
		for k in pairs(fail) do fail[k] = nil end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:PhaseOne()
		if db.encaps then
			self:ScheduleRepeatingEvent("BWEncapsScan", self.Encapsulate, 0.5, self)
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
		if db.enrage then
			self:Enrage(600)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if db.breath and msg == L["breath_trigger"] then
		--19879 track dragonkin, looks like a dragon breathing 'deep breath' :)
		self:IfMessage(L["breath_warn"]:format(count), "Attention", 19879)
		self:Bar(L["breath_warn"]:format(count), 4, 19879)
		count = count + 1
		if count < 4 then
			self:Bar(L["breath_nextbar"]:format(count), 17, 19879)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["airphase_trigger"] then
		if db.phase then
			self:Bar(L["landing_bar"], 100, 31550)
			self:DelayedMessage(90, L["landing_message"], Attention)
			self:ScheduleEvent("BWFelmystStage", self.PhaseOne, 100, self)
		end
		if db.breath then
			count = 1
			self:Bar(L["breath_nextbar"]:format(count), 40.5, 19879)
		end
	end
end

function mod:PhaseOne()
	if db.phase then
		self:Bar(L["takeoff_bar"], 60, 31550)
		self:DelayedMessage(55, L["takeoff_message"], "Attention")
	end

	if db.encaps then
		self:Bar(L["encaps"], 30, 45661)
		self:DelayedMessage(25, L["encaps_warning"], "Attention")
	end
end

