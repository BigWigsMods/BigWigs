
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

	L.rage, L.rage_desc = EJ_GetSectionInfo(5678)
	L.rage_icon = 38771 -- rage like icon

	L.strength, L.strength_desc = EJ_GetSectionInfo(5677)
	L.strength_icon = 80471 -- strength like icon

	L.courage, L.courage_desc = EJ_GetSectionInfo(5676)
	L.courage_icon = 126030 -- shield like icon

	L.titan_spark = EJ_GetSectionInfo(5674)

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
		116829,
		"rage", {116525, "FLASH"},
		"strength",
		"courage",
		"bosses", "combo", "arc",
		-5670, "berserk", "bosskill",
	}, {
		[116829] = ("%s (%s)"):format(L["titan_spark"], CL["heroic"]),
		rage = L["rage"],
		strength = L["strength"],
		courage = L["courage"],
		bosses = L["bosses"],
		[-5670] = "general",
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "ArcCombo", "boss1", "boss2")

	--Titan Gas
	self:Emote("TitanGas", L["gas_trigger"])
	self:Emote("TitanGasOverdrive", L["gas_overdrive_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60399) -- Qin-xi they share hp
end

function mod:OnEngage()
	self:Berserk(785) -- this is from heroic trigger
	strengthCounter = 0
	gasCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Rage()
	self:Message("rage", "Attention", nil, CL["custom_sec"]:format(L["rage"], 13), L.rage_icon)
	self:Bar("rage", 13, L["rage"], L.rage_icon)
	self:DelayedMessage("rage", 13, "Attention", L["rage"], L.rage_icon)
end

function mod:FocusedAssault(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
	end
end

function mod:FocusedEnergy(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
end

function mod:Strength()
	strengthCounter = strengthCounter + 1
	self:Message("strength", "Attention", nil, CL["custom_sec"]:format(L["strength"], 8), L.strength_icon)
	self:Bar("strength", 8, CL["count"]:format(L["strength"], strengthCounter), L.strength_icon)
	self:DelayedMessage("strength", 8, "Attention", CL["count"]:format(L["strength"], strengthCounter), L.strength_icon)
end

function mod:Courage()
	self:Message("courage", "Attention", nil, CL["custom_sec"]:format(L["courage"], 11), L.courage_icon)
	self:Bar("courage", 11, L["courage"], L.courage_icon) -- shield like icon
	self:DelayedMessage("courage", 11, "Attention", L["courage"], L.courage_icon)
end

function mod:Bosses()
	self:Message("bosses", "Attention", nil, CL["custom_sec"]:format(L["bosses"], 13), L.bosses_icon)
	self:Bar("bosses", 13, L["bosses"], L.bosses_icon)
	self:DelayedMessage("bosses", 13, "Attention", L["bosses"], L.bosses_icon)
	if not self:Heroic() then
		self:CDBar(-5670, 123) -- Titan Gas
	end
end

do
	local function fireNext()
		mod:CDBar(-5670, 120)
	end
	function mod:TitanGas()
		gasCounter = gasCounter + 1
		self:ScheduleTimer(fireNext, 30)
		self:Bar(-5670, 30)
		self:Message(-5670, "Attention", nil, CL["count"]:format(self:SpellName(-5670), gasCounter))
	end
end

function mod:TitanGasOverdrive()
	self:Message(-5670, "Important", "Alarm", ("%s (%s)"):format(self:SpellName(-5670), self:SpellName(26662))) --Berserk
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

	function mod:ArcCombo(unitId, spellName, _, _, spellId)
		-- Don't check for target until later so our counter is always correct for each boss, covers target swapping
		if arcs[spellId] then
			comboCounter[unitId] = comboCounter[unitId] + 1

			if UnitIsUnit("target", unitId) then
				local boss = UnitName(unitId)
				self:Message("arc", "Urgent", nil, ("%s: %s (%d)"):format(boss, spellName, comboCounter[unitId]), arcs[spellId])
			end
		elseif spellId == 118365 then -- Energize
			local t = GetTime()
			if t-energizePrev[unitId] > 3 then
				energizePrev[unitId] = t
				comboCounter[unitId] = 0

				if UnitIsUnit("target", unitId) or self:Healer() then
					local boss = UnitName(unitId)
					self:Bar("combo", 20, CL["other"]:format(boss, L["combo"]), spellId)
					self:DelayedMessage("combo", 17, "Personal", L["combo_message"]:format(boss), L.arc_icon, "Long")
				end
			end
		end
	end
end

