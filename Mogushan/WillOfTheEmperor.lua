
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Will of the Emperor", 896, 677)
if not mod then return end
--mod:RegisterEnableMob(60396) --Emperor's Rage

--------------------------------------------------------------------------------
-- Locals
--

local rage, strength, courage, bosses, gas = (EJ_GetSectionInfo(5678)), (EJ_GetSectionInfo(5677)), (EJ_GetSectionInfo(5676)), (EJ_GetSectionInfo(5726)), (EJ_GetSectionInfo(5670))
local gasCounter = 0
local strengthCounter = 0
local firstEnable = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.energizing = "%s is energizing!"
	L.combo = "%s: combo in progress"

	L.heroic_start_trigger = "Destroying the pipes" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "The machine hums" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "The Emperor's Rage echoes through the hills."
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!"
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!"
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!"
	L.gas_trigger = "The Ancient Mogu Machine breaks down!"
	L.gas_overdrive_trigger = "The Ancient Mogu Machine goes into overdrive!"

	L.arc = EJ_GetSectionInfo(5673)
	L.arc_desc = "|cFFFF0000This warning will only show for the boss you're targetting.|r " .. (select(2, EJ_GetSectionInfo(5673)))
	L.arc_icon = 116835
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:5678", { 116525, "FLASHSHAKE" },
		"ej:5677",
		"ej:5676",
		"ej:5726", "ej:5672", "arc",
		{116829, "FLASHSHAKE", "SAY"},
		"ej:5670", "berserk", "bosskill",
	}, {
		["ej:5678"] = rage,
		["ej:5677"] = strength,
		["ej:5676"] = courage,
		["ej:5726"] = bosses,
		[116829] = "heroic",
		["ej:5670"] = "general",
	}
end

function mod:OnRegister()
	self:RegisterEnableEmote(L["heroic_start_trigger"], L["normal_start_trigger"])
end

function mod:OnBossEnable()
	if not firstEnable then
		firstEnable = true
		self:Engage()
	end

	-- Heroic
	self:Emote("Engage", L["heroic_start_trigger"], L["normal_start_trigger"])

	-- Rage
	self:Yell("Rage", L["rage_trigger"])
	self:Log("SPELL_AURA_APPLIED", "FocusedAssault", 116525)

	-- Strength
	self:Emote("Strength", L["strength_trigger"])

	-- Courage
	self:Emote("Courage", L["courage_trigger"])

	--Titan Spark
	self:Log("SPELL_AURA_APPLIED", "FocusedEnergy", 116829)

	-- Bosses
	self:Emote("Bosses", L["bosses_trigger"])
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_POWER")

	--Titan Gas
	self:Emote("TitanGas", L["gas_trigger"])
	self:Emote("TitanGasOverdrive", L["gas_overdrive_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60399) -- Qin-xi they share hp
end

function mod:OnEngage()
	-- XXX need normal mode engage trigger and adjusted timer
	self:Berserk(785) -- this is from heroic trigger
	strengthCounter = 0
	gasCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Rage()
	self:Message("ej:5678", CL["custom_sec"]:format(rage, 13), "Attention", 124019)
	self:Bar("ej:5678", rage, 13, 124019) -- rage like icon
	self:DelayedMessage("ej:5678", 13, rage, "Attention", 124019)
end

function mod:FocusedAssault(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(116525)
		self:LocalMessage(116525, CL["you"]:format(spellName), "Personal", 116525, "Info")
	end
end

function mod:FocusedEnergy(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(116829)
		self:Say(116829, CL["say"]:format(spellName))
	end
	self:TargetMessage(116829, spellName, player, "Attention", 116829, "Info")
end

function mod:Strength()
	strengthCounter = strengthCounter + 1
	self:Message("ej:5677", CL["custom_sec"]:format(strength, 8)..((" (%d)"):format(strengthCounter)), "Attention", 80471)
	self:Bar("ej:5677", strength, 8, 80471) -- strength like icon
	self:DelayedMessage("ej:5677", 8, strength, "Attention", 80471)
end

function mod:Courage()
	self:Message("ej:5677", CL["custom_sec"]:format(strength, 8), "Attention", 80471)
	self:Bar("ej:5676", courage, 13, 93435) -- courage like icon
	self:DelayedMessage("ej:5676", 11, courage, "Attention", 93435)
end

function mod:Bosses()
	self:Message("ej:5677", CL["custom_sec"]:format(strength, 8), "Attention", 80471)
	self:Bar("ej:5726", bosses, 13, 118327)
	self:DelayedMessage("ej:5726", 13, bosses, "Attention", 118327)
	self:Bar("ej:5670", "~"..gas, 120, 118327) --XXX varied a bit
end

do
	local function fireNext()
		mod:Bar("ej:5670", "~"..gas, 120, 118327)
	end
	function mod:TitanGas()
		gasCounter = gasCounter + 1
		self:ScheduleTimer(fireNext, 30)
		self:Bar("ej:5670", gas, 30, 118327)
		self:Message("ej:5670", ("%s (%d)"):format(gas, gasCounter), "Attention", 118327)
	end
end

function mod:TitanGasOverdrive()
	self:Message("ej:5670", ("%s (%s)"):format(gas, (GetSpellInfo(26662))), "Important", 118327, "Alarm") --Berserk
end

do
	local combo = EJ_GetSectionInfo(5672)
	local comboCounter = 1
	local arcs = {
		[116968] = "misc_arrowleft", --arc left
		[116971] = "misc_arrowright", --arc right
		[116972] = "misc_arrowlup", --arc center
		--stomp triggers on the actual stomp, not at the start
		[132425] = 132425, --boss1 stomp
		[116969] = 132425, --boss2 stomp
	}

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
		if unitId == "target" then
			local boss = UnitName(unitId)
			if arcs[spellId] then
				comboCounter = comboCounter + 1
				self:LocalMessage("arc", ("%s: %s (%d)"):format(boss, spellName, comboCounter), "Urgent", arcs[spellId])
			elseif spellId == 118365 and unitId:match("boss%d") then -- Energize 1/s
				self:Message("ej:5672", L["energizing"]:format(boss), "Important")
				self:Bar("ej:5672", L["energizing"]:format(boss), 20)
			end
		end
	end

	function mod:UNIT_POWER(_, unitId)
		--they build power until 20, use 4 power (2 on heroic) an action until they're back at 0, then repeat
		if unitId:match("boss%d") and UnitIsUnit("target", unitId) and UnitPower(unitId) == 17 and comboCounter > 0 then
			comboCounter = 0
			local boss = UnitName(unitId)
			self:LocalMessage("arc", CL["soon"]:format(CL["other"]:format(boss, combo)), "Personal", 116835, "Long")
		end
	end
end

