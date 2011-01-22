--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ascendant Council", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(43686, 43687, 43688, 43689, 43735) --Ignacious, Feludius, Arion, Terrastra, Elementium Monstrosity

--------------------------------------------------------------------------------
-- Locals
--

local lrTargets, gcTargets = mod:NewTargetList(), mod:NewTargetList()
local glaciate = GetSpellInfo(82746)
local quake, thundershock, hardenSkin = GetSpellInfo(83565), GetSpellInfo(83067), GetSpellInfo(83067)
local gravityCrush = GetSpellInfo(92488)
local hardenInterrupted = nil
local hardenTimer, thunderTimer = nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.static_overload_say = "Overload on ME!"
	L.gravity_core_say = "Gravity on ME!"
	L.health_report = "%s at %d%%, phase change soon!"
	L.switch = "Switch"
	L.switch_desc = "Warning for boss switches."

	L.shield_up_message = "Shield is up!"
	L.shield_bar = "Next shield"

	L.lightning_rod_say = "Lightning Rod on ME!"

	L.switch_trigger = "We will handle them!"

	L.thundershock_quake_soon = "%s in 10sec!"

	L.quake_trigger = "The ground beneath you rumbles ominously...."
	L.thundershock_trigger = "The surrounding air crackles with energy...."

	L.searing_winds_message = "Lightning incoming!"
	L.grounded_message = "Earthquake incoming!"

	L.last_phase_trigger = "An impressive display..."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Ignacious
		82631, 82660, 82663,
		-- Feludius
		82746, 82665, 82666, 82762,
		-- Arion
		83067, {83099, "SAY", "FLASHSHAKE"},
		-- Terrastra
		83565, 92541,
		-- Monstrosity
		92488,
		-- Heroic
		{92067, "FLASHSHAKE", "SAY", "ICON"},
		{92075, "FLASHSHAKE", "SAY", "ICON"},
		{92307, "FLASHSHAKE", "ICON", "WHISPER"},
		-- General
		"proximity", "switch", "bosskill"
	}, {
		[82631] = "Ignacious",
		[82746] = "Feludius",
		[83067] = "Arion",
		[83565] = "Terrastra",
		[92488] = "Elementium Monstrosity",
		[92067] = "heroic",
		proximity = "general",
	}
end

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_AURA_APPLIED", "StaticOverload", 92067)
	self:Log("SPELL_AURA_APPLIED", "GravityCore", 92075)
	self:Log("SPELL_AURA_APPLIED", "FrostBeacon", 92307)

	--normal
	self:Log("SPELL_AURA_APPLIED", "LightningRodApplied",83099)
	self:Log("SPELL_AURA_REMOVED", "LightningRodRemoved",83099)

	self:Log("SPELL_CAST_START", "AegisofFlame", 82631, 92513, 92512, 92514)
	self:Log("SPELL_CAST_START", "HardenSkinStart", 92541, 92542, 92543)
	self:Log("SPELL_INTERRUPT", "Interrupt", "*")
	self:Log("SPELL_CAST_START", "Glaciate", 82746, 92507, 92506, 92508)
	self:Log("SPELL_AURA_APPLIED", "Waterlogged", 82762)
	self:Log("SPELL_CAST_SUCCESS", "HeartofIce", 82665)
	self:Log("SPELL_CAST_SUCCESS", "BurningBlood", 82660)
	self:Log("SPELL_AURA_APPLIED", "FrostImbued", 82666)
	self:Log("SPELL_AURA_APPLIED", "FlameImbued", 82663)
	self:Log("SPELL_AURA_APPLIED", "GravityCrush", 84948, 92486, 92487, 92488)

	self:Yell("Switch", L["switch_trigger"])

	self:Log("SPELL_CAST_START", "Quake", 83565, 92544, 92545, 92546)
	self:Log("SPELL_CAST_START", "Thundershock", 83067, 92469, 92470, 92471)

	self:Emote("QuakeTrigger", L["quake_trigger"])
	self:Emote("ThundershockTrigger", L["thundershock_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterEvent("UNIT_HEALTH")

	self:Yell("LastPhase", L["last_phase_trigger"])

	self:Death("Win", 43735) -- Elementium Monstrosity
end

function mod:OnEngage(diff)
	if diff > 2 then
		self:OpenProximity(8)
	end

	self:Bar(82631, L["shield_bar"], 28, 82631)
	self:Bar(82746, glaciate, 15, 82746)

	hardenInterrupted = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function lrWarn(spellName)
		mod:TargetMessage(83099, spellName, lrTargets, "Important", 83099, "Alert")
		scheduled = nil
	end
	function mod:LightningRodApplied(player, _, _, _, spellName)
		lrTargets[#lrTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(lrWarn, 0.3, spellName)
		end
		if UnitIsUnit(player, "player") then
			self:Say(83099, L["lightning_rod_say"])
			self:FlashShake(83099)
			self:OpenProximity(8)
		end
	end
end

do
	local scheduled = nil
	local function gcWarn(spellName)
		mod:TargetMessage(92488, spellName, gcTargets, "Important", 92488, "Alarm")
		scheduled = nil
	end
	function mod:GravityCrush(player, spellId, _, _, spellName)
		gcTargets[#gcTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(gcWarn, 0.02, spellName)
		end
		self:Bar(92488, spellName, 25, spellId)
	end
end

function mod:LightningRodRemoved(player, spellId)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
end

function mod:GravityCore(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:Say(92075, L["gravity_core_say"])
		self:FlashShake(92075)
	end
	self:TargetMessage(92075, spellName, player, "Personal", spellId, "Alarm")
	self:SecondaryIcon(92075, player)
end

function mod:StaticOverload(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:Say(92067, L["static_overload_say"])
		self:FlashShake(92067)
	end
	self:TargetMessage(92067, spellName, player, "Personal", spellId, "Alarm")
	self:PrimaryIcon(92067, player)
end

function mod:FrostBeacon(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(92307)
	end
	self:TargetMessage(92307, spellName, player, "Personal", spellId, "Alarm")
	self:Whisper(92307, player, spellName)
	self:PrimaryIcon(92307, player)
end

function mod:UNIT_HEALTH(event, unit)
	if unit == "boss1" or unit == "boss2" or unit == "boss3" or unit == "boss4" then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp < 30 then
			self:Message("switch", L["health_report"]:format((UnitName(unit)), hp), "Attention", 26662, "Info")
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

function mod:AegisofFlame(_, spellId)
	self:Bar(82631, L["shield_bar"], 62, spellId)
	self:Message(82631, L["shield_up_message"], "Important", spellId, "Alert")
end

do
	local harden = {
		[83718] = true,
		[92541] = true,
		[92542] = true,
		[92543] = true,
	}
	function mod:Interrupt(_, _, _, secSpellId, _, _, _, _, _, dGUID)
		if not harden[secSpellId] then return end
		local guid = tonumber(dGUID:sub(7, 10), 16)
		if guid ~= 43689 then return end -- Terrastra
		-- Someone interrupted Harden Skin, which means he won't cast Quake
		self:SendMessage("BigWigs_StopBar", self, quake)
		hardenInterrupted = true
	end
end

function mod:HardenSkinStart(_, spellId, _, _, spellName)
	self:Bar(92541, spellName, 45, spellId)
	self:Message(92541, spellName, "Urgent", spellId, "Info")
	hardenInterrupted = nil
end

function mod:Glaciate(_, spellId, _, _, spellName)
	self:Bar(82746, spellName, 33, spellId)
	self:Message(82746, spellName, "Urgent", spellId, "Alert")
end

function mod:Waterlogged(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(82762, spellName, "Important", spellId, "Long")
	end
end

function mod:FrostImbued(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(82666, spellName, "Positive", spellId, "Info")
	end
end

function mod:FlameImbued(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(82663, spellName, "Positive", spellId, "Info")
	end
end

function mod:HeartofIce(player, spellId, _, _, spellName)
	self:TargetMessage(82665, spellName, player, "Positive", spellId)
end

function mod:BurningBlood(player, spellId, _, _, spellName)
	self:TargetMessage(82660, spellName, player, "Positive", spellId)
end

function mod:Switch()
	self:SendMessage("BigWigs_StopBar", self, L["shield_bar"])
	self:SendMessage("BigWigs_StopBar", self, glaciate)
	self:Bar(83565, quake, 33, 83565)
	self:Bar(83067, thundershock, 70, 83067)
	self:Bar(92541, hardenSkin, 27, 92541)
	self:CancelAllTimers()
	-- XXX this needs to be delayed
	self:RegisterEvent("UNIT_HEALTH")
end

do
	local flying = GetSpellInfo(83500)
	local function quakeIncoming()
		if hardenInterrupted then return end
		local name, _, icon = UnitDebuff("player", flying)
		if name then
			mod:CancelTimer(hardenTimer, true)
			return
		end
		mod:LocalMessage(83565, L["grounded_message"], "Personal", icon, "Info")
	end

	-- We get the quake trigger even if Harden Skin was interrupted.
	function mod:QuakeTrigger()
		if hardenInterrupted then
			hardenInterrupted = nil
			return
		end
		self:Bar(83565, quake, 10, 83565)
		self:Message(83565, L["thundershock_quake_soon"]:format(quake), "Important", 83565, "Info")
		hardenTimer = self:ScheduleRepeatingTimer(quakeIncoming, 2)
	end

	function mod:Quake(_, spellId, _, _, spellName)
		self:Bar(83565, spellName, 65, spellId)
		self:Message(83565, spellName, "Important", spellId, "Alarm")
		self:CancelTimer(hardenTimer, true) -- Should really wait 3 more sec.
	end
end

do
	local grounded = GetSpellInfo(83581)
	local function thunderShockIncoming()
		local name, _, icon = UnitDebuff("player", grounded)
		if name then
			mod:CancelTimer(thunderTimer, true)
			return
		end
		mod:LocalMessage(83067, L["searing_winds_message"], "Personal", icon, "Info")
	end

	function mod:ThundershockTrigger()
		self:Message(83067, L["thundershock_quake_soon"]:format(thundershock), "Important", 83067, "Info")
		self:Bar(83067, thundershock, 10, 83067)
		thunderTimer = self:ScheduleRepeatingTimer(thunderShockIncoming, 2)
	end

	function mod:Thundershock(_, spellId, _, _, spellName)
		self:Bar(83067, spellName, 65, spellId)
		self:Message(83067, spellName, "Important", spellId, "Alarm")
		self:CancelTimer(thunderTimer, true) -- Should really wait 3 more sec but meh.
	end
end

function mod:LastPhase()
	self:SendMessage("BigWigs_StopBar", self, quake)
	self:SendMessage("BigWigs_StopBar", self, thundershock)
	self:SendMessage("BigWigs_StopBar", self, hardenSkin)
	self:CancelAllTimers()
	self:Bar(92488, gravityCrush, 43, 92488)
	self:OpenProximity(9)
	self:UnregisterEvent("UNIT_HEALTH")
end

