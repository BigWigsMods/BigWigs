
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Will of the Emperor", 896, 677)
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

local rage, strength, courage, bosses = (EJ_GetSectionInfo(5678)), (EJ_GetSectionInfo(5677)), (EJ_GetSectionInfo(5676)), (EJ_GetSectionInfo(5726))
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

	L.target_only = "|cFFFF0000This warning will only show for the boss you are targeting.|r"

	L.combo, L.combo_desc = EJ_GetSectionInfo(5672)
	L.combo_message = "%s: Combo soon!"

	L.arc, L.arc_desc = EJ_GetSectionInfo(5673)
	L.arc_icon = 116835

	L.gas, L.gas_desc = EJ_GetSectionInfo(5670)
	L.gas_icon = 118327
end
L = mod:GetLocale()
L.combo_desc = L.target_only.." "..L.combo_desc
L.arc_desc = L.target_only.." "..L.arc_desc

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
		"gas", "berserk", "bosskill",
	}, {
		["ej:5678"] = rage,
		["ej:5677"] = strength,
		["ej:5676"] = courage,
		["ej:5726"] = bosses,
		[116829] = "heroic",
		["gas"] = "general",
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
	self:Message("ej:5678", CL["custom_sec"]:format(rage, 13), "Attention", 38771)
	self:Bar("ej:5678", rage, 13, 38771) -- rage like icon
	self:DelayedMessage("ej:5678", 13, rage, "Attention", 38771)
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
	self:Message("ej:5676", CL["custom_sec"]:format(courage, 11), "Attention", 126030)
	self:Bar("ej:5676", courage, 11, 126030) -- shield like icon
	self:DelayedMessage("ej:5676", 11, courage, "Attention", 126030)
end

function mod:Bosses()
	self:Message("ej:5726", CL["custom_sec"]:format(strength, 13), "Attention", "achievement_moguraid_06")
	self:Bar("ej:5726", bosses, 13, "achievement_moguraid_06")
	self:DelayedMessage("ej:5726", 13, bosses, "Attention", "achievement_moguraid_06")
	if not self:Heroic() then
		self:Bar("gas", "~"..L["gas"], 120, 118327)
	end
end

do
	local function fireNext()
		mod:Bar("gas", "~"..L["gas"], 120, 118327)
	end
	function mod:TitanGas()
		gasCounter = gasCounter + 1
		self:ScheduleTimer(fireNext, 30)
		self:Bar("gas", L["gas"], 30, 118327)
		self:Message("gas", ("%s (%d)"):format(L["gas"], gasCounter), "Attention", 118327)
	end
end

function mod:TitanGasOverdrive()
	self:Message("gas", ("%s (%s)"):format(L["gas"], self:SpellName(26662)), "Important", 118327, "Alarm") --Berserk
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
	local comboCounter = {boss1 = 0, boss2 = 0}
	local energizePrev = {boss1 = 0, boss2 = 0}

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
		if not unitId:find("boss", nil, true) then return end

		--don't check for target until later so our counter is always correct for each boss
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

				if UnitIsUnit("target", unitId) or self:Healer() then
					local boss = UnitName(unitId)
					self:Bar("combo", CL["other"]:format(boss, L["combo"]), 20, 118365)
					self:DelayedMessage("combo", 17, L["combo_message"]:format(boss), "Personal", 116835, "Long")
				end
			end
		end
	end
end
