
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Will of the Emperor", 896, 677)
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

local rage, strength, courage, bosses, gas = (EJ_GetSectionInfo(5678)), (EJ_GetSectionInfo(5677)), (EJ_GetSectionInfo(5676)), (EJ_GetSectionInfo(5726)), (EJ_GetSectionInfo(5670))
local gasCounter = 0
local strengthCounter = 0
local canEnable = true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enable_zone = "Forge of the Endless"

	L.heroic_start_trigger = "Destroying the pipes" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "The machine hums" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "The Emperor's Rage echoes through the hills."
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!"
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!"
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!"
	L.gas_trigger = "The Ancient Mogu Machine breaks down!"
	L.gas_overdrive_trigger = "The Ancient Mogu Machine goes into overdrive!"

	L.combo, L.combo_desc = EJ_GetSectionInfo(5672)
	L.combo_icon = 116835
	L.combo_message = "%s: Combo soon!"

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
		"ej:5726", "combo", "arc",
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
	-- Kel'Thuzad v2
	local f = CreateFrame("Frame")
	local func = function()
		if not mod:IsEnabled() and canEnable and GetSubZoneText() == L["enable_zone"] then
			mod:Enable()
		end
	end
	f:SetScript("OnEvent", func)
	f:RegisterEvent("ZONE_CHANGED_INDOORS")
	func()
end

function mod:VerifyEnable()
	return canEnable
end

function mod:OnBossEnable()
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

	--Titan Gas
	self:Emote("TitanGas", L["gas_trigger"])
	self:Emote("TitanGasOverdrive", L["gas_overdrive_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60399) -- Qin-xi they share hp
end

function mod:OnWin()
	canEnable = false
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
	self:Message("ej:5677", CL["custom_sec"]:format(strength, 8), "Attention", 80471)
	self:Bar("ej:5677", ("%s (%d)"):format(strength, strengthCounter), 8, 80471) -- strength like icon
	self:DelayedMessage("ej:5677", 8, ("%s (%d)"):format(strength, strengthCounter), "Attention", 80471)
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
	if not self:Heroic() then
		self:Bar("ej:5670", "~"..gas, 120, 118327)
	end
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
	self:Message("ej:5670", ("%s (%s)"):format(gas, self:SpellName(26662)), "Important", 118327, "Alarm") --Berserk
end

do
	local arcs = {
		[116968] = "misc_arrowleft", --arc left
		[116971] = "misc_arrowright", --arc right
		[116972] = "misc_arrowlup", --arc center
		--stomp triggers on the actual stomp, not at the start
		[132425] = 132425, --boss1 stomp
		[116969] = 132425, --boss2 stomp
	}
	local comboCounter = {boss1 = 1, boss2 = 1}
	local energizePrev = {boss1 = 0, boss2 = 0}

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
		if not unitId:find("boss", nil, true) then return end

		if arcs[spellId] then
			comboCounter[unitId] = comboCounter[unitId] + 1
			if UnitIsUnit("target", unitId) then
				local boss = UnitName(unitId)
				self:LocalMessage("arc", ("%s: %s (%d)"):format(boss, spellName, comboCounter[unitId]), "Urgent", arcs[spellId])
			end
		elseif spellId == 118365 then -- Energize
			local t = GetTime()
			if t-energizePrev[unitId] > 3 then
				energizePrev[unitId] = t
				comboCounter[unitId] = 0

				local boss = UnitName(unitId)
				self:Bar("combo", CL["other"]:format(boss, L["combo"]), 20, 118365)
				--should probably schedule a function to check your target for the sound when it fires?
				self:DelayedMessage("combo", 17, L["combo_message"]:format(boss), "Personal", 116835, UnitIsUnit("target", unitId) and "Long")
			end
		end
	end
end
