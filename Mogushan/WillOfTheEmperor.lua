
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Will of the Emperor", 896, 677)
if not mod then return end
mod:RegisterEnableMob(60396)

--------------------------------------------------------------------------------
-- Locales
--

local rage, strength, courage, bosses = (EJ_GetSectionInfo(5678)), (EJ_GetSectionInfo(5677)), (EJ_GetSectionInfo(5676)), (EJ_GetSectionInfo(5726))

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.rage_trigger = "The Emperor's Rage echoes through the hills."
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!"
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!"
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!"

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
		"ej:5726", 116835,
		"berserk", "bosskill",
	}, {
		["ej:5678"] = rage,
		["ej:5677"] = strength,
		["ej:5676"] = courage,
		["ej:5726"] = bosses,
		berserk = "general",
	}
end

function mod:OnBossEnable()
	-- Rage
	self:Yell("Rage", L["rage_trigger"])
	self:Log("SPELL_AURA_APPLIED", "FocusedAssault", 116525)

	-- Strength
	self:Emote("Strength", L["strength_trigger"])

	-- Courage
	self:Emote("Courage", L["courage_trigger"])

	-- Bosses
	self:Emote("Bosses", L["bosses_trigger"])
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60399) -- Qin-xi they share hp
end

function mod:OnEngage(diff)

	self:Berserk(360) -- assume

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
		self:LocalMessage(116525, spellName, player, "Personal", 116525, "Info")
	end
end

function mod:Strength()
	self:Message("ej:5677", CL["custom_sec"]:format(strength, 8), "Attention", 80471)
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
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
	if (spellId == 116968 or spellId == 116971 or spellId == 116972) and unitId:match("boss") then -- arc attacks
		self:Message(116835, ("%s %s"):format((UnitName(unitId)), spellName), "Urgent", 116835)
	end
end

