
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Will of the Emperor", 896, 677)
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

local gasCounter = 0
local strengthCounter = 0
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

	L.target_only = "|cFFFF0000This warning only shows for the boss you're targeting.|r "

	L.combo, L.combo_desc = EJ_GetSectionInfo(5672)
	L.combo_message = "%s: Combo soon!"

	L.arc, L.arc_desc = EJ_GetSectionInfo(5673)
	L.arc_icon = 116835

	L.gas, L.gas_desc = EJ_GetSectionInfo(5670)
	L.gas_icon = 118327

	L.rage, L.rage_desc = EJ_GetSectionInfo(5678)
	L.rage_icon = 38771 -- rage like icon

	L.strength, L.strength_desc = EJ_GetSectionInfo(5677)
	L.strength_icon = 80471 -- strength like icon

	L.courage, L.courage_desc = EJ_GetSectionInfo(5676)
	L.courage_icon = 126030 -- shield like icon

	L.bosses, L.bosses_desc = EJ_GetSectionInfo(5726)
	L.bosses_icon = "achievement_moguraid_06"
end
L = mod:GetLocale()
L.combo_desc = L.target_only .. L.combo_desc
L.arc_desc = L.target_only .. L.arc_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"rage", {116525, "FLASHSHAKE"},
		"strength",
		"courage",
		"bosses", "combo", "arc",
		{116829, "FLASHSHAKE", "SAY"},
		"gas", "berserk", "bosskill",
	}, {
		rage = L["rage"],
		strength = L["strength"],
		courage = L["courage"],
		bosses = L["bosses"],
		[116829] = "heroic",
		gas = "general",
	}
end

function mod:OnRegister()
	-- Kel'Thuzad v2
	local f = CreateFrame("Frame")
	local func = function()
		if not mod:IsEnabled() and GetSubZoneText() == L["enable_zone"] then
			mod:Enable()
		end
	end
	f:SetScript("OnEvent", func)
	f:RegisterEvent("ZONE_CHANGED_INDOORS")
	func()
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
	self:Message("rage", CL["custom_sec"]:format(L["rage"], 13), "Attention", L.rage_icon)
	self:Bar("rage", L["rage"], 13, L.rage_icon)
	self:DelayedMessage("rage", 13, L["rage"], "Attention", L.rage_icon)
end

function mod:FocusedAssault(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(spellId)
		self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId, "Info")
	end
end

function mod:FocusedEnergy(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(spellId)
		self:Say(spellId, CL["say"]:format(spellName))
	end
	self:TargetMessage(spellId, spellName, player, "Attention", spellId, "Info")
end

function mod:Strength()
	strengthCounter = strengthCounter + 1
	self:Message("strength", CL["custom_sec"]:format(L["strength"], 8), "Attention", L.strength_icon)
	self:Bar("strength", ("%s (%d)"):format(L["strength"], strengthCounter), 8, L.strength_icon)
	self:DelayedMessage("strength", 8, ("%s (%d)"):format(L["strength"], strengthCounter), "Attention", L.strength_icon)
end

function mod:Courage()
	self:Message("courage", CL["custom_sec"]:format(L["courage"], 11), "Attention", L.courage_icon)
	self:Bar("courage", L["courage"], 11, L.courage_icon) -- shield like icon
	self:DelayedMessage("courage", 11, L["courage"], "Attention", L.courage_icon)
end

function mod:Bosses()
	self:Message("bosses", CL["custom_sec"]:format(L["bosses"], 13), "Attention", L.bosses_icon)
	self:Bar("bosses", L["bosses"], 13, L.bosses_icon)
	self:DelayedMessage("bosses", 13, L["bosses"], "Attention", L.bosses_icon)
	if not self:Heroic() then
		self:Bar("gas", "~"..L["gas"], 120, L.gas_icon)
	end
end

do
	local function fireNext()
		mod:Bar("gas", "~"..L["gas"], 120, L.gas_icon)
	end
	function mod:TitanGas()
		gasCounter = gasCounter + 1
		self:ScheduleTimer(fireNext, 30)
		self:Bar("gas", L["gas"], 30, L.gas_icon)
		self:Message("gas", ("%s (%d)"):format(L["gas"], gasCounter), "Attention", L.gas_icon)
	end
end

function mod:TitanGasOverdrive()
	self:Message("gas", ("%s (%s)"):format(L["gas"], self:SpellName(26662)), "Important", L.gas_icon, "Alarm") --Berserk
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

		-- Don't check for target until later so our counter is always correct for each boss, covers target swapping
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
					self:Bar("combo", CL["other"]:format(boss, L["combo"]), 20, spellId)
					self:DelayedMessage("combo", 17, L["combo_message"]:format(boss), "Personal", L.arc_icon, "Long", true) -- Local only
				end
			end
		end
	end
end

