--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Madness of Deathwing", 824, 333)
if not mod then return end
-- Thrall, Deathwing, Arm Tentacle, Arm Tentacle, Wing Tentacle, Mutated Corruption
mod:RegisterEnableMob(56103, 56173, 56167, 56846, 56168, 56471)

local hemorrhage = GetSpellInfo(105863)
local cataclysm = GetSpellInfo(110044)
local impale = GetSpellInfo(106400)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.impale = EJ_GetSectionInfo(4114)
	L.impale_desc = "Tank alert only. "..select(2,EJ_GetSectionInfo(4114))
	L.impale_icon = 106400

	L.last_phase, L.last_phase_desc = EJ_GetSectionInfo(4046)
	L.last_phase_icon = 109592

	L.bigtentacle, L.bigtentacle_desc = EJ_GetSectionInfo(4112)
	L.bigtentacle_icon = 105563

	L.smalltentacles, L.smalltentacles_desc = EJ_GetSectionInfo(4103)
	L.smalltentacles_icon = 109588

	L.hemorrhage, L.hemorrhage_desc = EJ_GetSectionInfo(4108)
	L.hemorrhage_icon = "SPELL_FIRE_MOLTENBLOOD"
end
L = mod:GetLocale()
L.impale = L.impale.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"bigtentacle", "impale", "smalltentacles", {105651, "FLASHSHAKE"}, "hemorrhage", 110044,
		{106794, "FLASHSHAKE"}, "last_phase",
		"bosskill",
	}, {
		bigtentacle = "ej:4040",
		last_phase = "ej:4046",
		bosskill = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Hemorrhage")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageUnit")
	self:Log("SPELL_AURA_APPLIED", "BlisteringTentacle", 109588, 109589, 109590, 105444)
	self:Log("SPELL_CAST_SUCCESS", "ElementiumBolt", 105651)
	self:Log("SPELL_CAST_SUCCESS", "Impale", 106400)
	self:Log("SPELL_CAST_SUCCESS", "AgonizingPain", 106548)
	self:Log("SPELL_CAST_START", "AssaultAspects", 107018)
	self:Log("SPELL_CAST_START", "Cataclysm", 110044, 106523, 110042, 110043)
	self:Log("SPELL_AURA_APPLIED", "LastPhase", 109592) -- Corrupted Blood
	self:Log("SPELL_AURA_APPLIED", "Shrapnel", 106794, 110141, 110140, 110139) -- 106794 10N, 110141 LFR

	self:Log("SPELL_CAST_SUCCESS", "Win", 110063) -- Astral Recall
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Impale(_, spellId, _, _, spellName)
	if UnitGroupRolesAssigned("player") == "TANK" then
		self:Message("impale", spellName, "Urgent", spellId, "Alarm")
		self:Bar("impale", spellName, 35, spellId)
	end
end

-- XXX maybe too much sound? All of them are for adds tho that you have to kill ASAP.
function mod:Hemorrhage(_, unit, spellName)
	if (unit):find("^boss%d$") and spellName == hemorrhage then
		self:Message("hemorrhage", spellName, "Urgent", L["hemorrhage_icon"], "Alarm")
	end
end

function mod:LastPhase(_, spellId)
	self:Message("last_phase", L["last_phase"], "Attention", spellId)
end

function mod:AssaultAspects()
	if not self.isEngaged then
		-- The abilities all come earlier for first platform only
		self:Bar("impale", impale, 22, 106400)
		self:Bar(105651, GetSpellInfo(105651), 40.5, 105651) -- Elementium Bolt
		self:Bar("hemorrhage", hemorrhage, 85.5, 105863)
		self:Bar(110044, cataclysm, 115, 110044)
	else
		self:Bar("impale", impale, 27.5, 106400)
		self:Bar(105651, GetSpellInfo(105651), 55.5, 105651) -- Elementium Bolt
		self:Bar("hemorrhage", hemorrhage, 100.5, 105863)
		self:Bar(110044, cataclysm, 130, 110044)
	end
end

function mod:ElementiumBolt(_, spellId, _, _, spellName)
	self:FlashShake(105651)
	self:Message(105651, spellName, "Important", spellId, "Long")
	self:Bar(105651, spellName, UnitBuff("player", (GetSpellInfo(109624))) and 20 or 10, spellId)
end

function mod:Cataclysm(_, spellId, _, _, spellName)
	self:Message(110044, spellName, "Attention", spellId)
	self:SendMessage("BigWigs_StopBar", self, spellName)
	self:Bar(110044, CL["cast"]:format(spellName), 60, spellId)
end

function mod:AgonizingPain()
	self:SendMessage("BigWigs_StopBar", self, CL["cast"]:format(cataclysm))
end

do
	local prev = 0
	function mod:BlisteringTentacle(unit, spellId)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message("smalltentacles", unit, "Urgent", spellId, "Alarm")
		end
	end
end

function mod:Shrapnel(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		local you = CL["you"]:format(spellName)
		self:LocalMessage(106794, you, "Important", spellId, "Long")
		self:FlashShake(106794)
		local duration = select(6, UnitDebuff("player", spellName))
		self:Bar(106794, you, duration, spellId)
	end
end

function mod:EngageUnit()
	if UnitExists("boss2") then
		local guid = UnitGUID("boss1")
		if guid and self:GetCID(guid) == 56471 then
			self:Message("bigtentacle", L["bigtentacle"] , "Urgent", L["bigtentacle_icon"], "Alert")
		end
	end
	self:CheckBossStatus()
end

