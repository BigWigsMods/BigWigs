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
local canEnable = true
local curPercent = 100

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "You have done NOTHING. I will tear your world APART."

	L.impale = EJ_GetSectionInfo(4114)
	L.impale_desc = "Tank alert only. "..select(2,EJ_GetSectionInfo(4114))
	L.impale_icon = 106400

	L.last_phase = GetSpellInfo(106708)
	L.last_phase_desc = EJ_GetSectionInfo(4046)
	L.last_phase_icon = 109592

	L.bigtentacle, L.bigtentacle_desc = EJ_GetSectionInfo(4112)
	L.bigtentacle_icon = 105563

	L.smalltentacles, L.smalltentacles_desc = EJ_GetSectionInfo(4103)
	L.smalltentacles_icon = 109588

	L.hemorrhage, L.hemorrhage_desc = EJ_GetSectionInfo(4108)
	L.hemorrhage_icon = "SPELL_FIRE_MOLTENBLOOD"

	L.fragment, L.fragment_desc = EJ_GetSectionInfo(4115)
	L.fragment_icon = 105563

	L.terror, L.terror_desc = EJ_GetSectionInfo(4117)
	L.terror_icon = "ability_tetanus"

	L.bolt_explode = "<Bolt Explodes>"
	L.parasite = "Parasite"
	L.blobs_soon = "%d%% - Congealing Blood soon!"
end
L = mod:GetLocale()
L.impale = L.impale.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"bigtentacle", "impale", "smalltentacles", {105651, "FLASHSHAKE"}, "hemorrhage", 110044,
		"last_phase", "fragment", {106794, "FLASHSHAKE"}, "terror",
		{"ej:4347", "FLASHSHAKE", "ICON", "PROXIMITY", "SAY"}, "ej:4351",
		"berserk", "bosskill",
	}, {
		bigtentacle = "ej:4040",
		last_phase = "ej:4046",
		["ej:4347"] = "heroic",
		berserk = "general",
	}
end

function mod:VerifyEnable()
	return canEnable
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_CAST_SUCCESS", "ElementiumBolt", 105651)
	self:Log("SPELL_CAST_SUCCESS", "Impale", 106400)
	self:Log("SPELL_CAST_SUCCESS", "AgonizingPain", 106548)
	self:Log("SPELL_CAST_START", "AssaultAspects", 107018)
	self:Log("SPELL_CAST_START", "Cataclysm", 110044, 106523, 110042, 110043)
	self:Log("SPELL_AURA_APPLIED", "LastPhase", 109592) -- Corrupted Blood
	self:Log("SPELL_AURA_APPLIED", "Shrapnel", 106794, 110141, 110140, 110139) -- 106794 10N, 110141 LFR
	self:Log("SPELL_AURA_APPLIED", "Parasite", 108649)
	self:Log("SPELL_AURA_REMOVED", "ParasiteRemoved", 108649)

	self:Yell("Engage", L["engage_trigger"])
	self:Log("SPELL_CAST_SUCCESS", "Win", 110063) -- Astral Recall
	self:Death("TentacleKilled", 56471)
end

function mod:OnEngage()
	curPercent = 100
	self:Berserk(900)
end

function mod:OnWin()
	canEnable = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Impale(_, spellId, _, _, spellName)
	if self:Tank() then
		self:LocalMessage("impale", spellName, "Urgent", spellId, "Alarm")
		self:Bar("impale", spellName, 35, spellId)
	end
end

function mod:TentacleKilled()
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(106400)))
	self:SendMessage("BigWigs_StopBar", self, L["parasite"])
end

-- XXX maybe too much sound? All of them are for adds tho that you have to kill ASAP.
function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if (unit):find("^boss%d$") then
		if spellName == hemorrhage then
			self:Message("hemorrhage", spellName, "Urgent", L["hemorrhage_icon"], "Alarm")
		elseif spellId == 105551 then
			local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
			self:Message("smalltentacles", ("%d%% - %s"):format(hp > 50 and 70 or 40, L["smalltentacles"]), "Urgent", L["smalltentacles_icon"], "Alarm")
		elseif spellId == 109568 then
			self:Message("fragment", L["fragment"], "Urgent", L["fragment_icon"], "Alarm")
			self:Bar("fragment", L["fragment"], 90, L["fragment_icon"])
		elseif spellId == 106765 then
			self:Message("terror", L["terror"], "Important", L["terror_icon"])
			self:Bar("terror", L["terror"], 90, L["terror_icon"])
		end
	end
end

function mod:LastPhase(_, spellId)
	self:Message("last_phase", EJ_GetSectionInfo(4046), "Attention", spellId) -- Stage 2: The Last Stand
	self:Bar("fragment", L["fragment"], 10.5, L["fragment_icon"])
	self:Bar("terror", L["terror"], 35.5, L["terror_icon"])
	if self:Difficulty() > 2 then
		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

function mod:AssaultAspects()
	if curPercent == 100 then
		curPercent = 20
		if self:Tank() then
			self:Bar("impale", impale, 22, 106400)
		end
		self:Bar(105651, GetSpellInfo(105651), 40.5, 105651) -- Elementium Bolt
		if self:Difficulty() > 2 then
			self:Bar("hemorrhage", hemorrhage, 55.5, 105863)
			self:Bar("ej:4347", L["parasite"], 11, 108649)
		else
			self:Bar("hemorrhage", hemorrhage, 85.5, 105863)
		end
		self:Bar(110044, cataclysm, 175, 110044)
		self:Bar("bigtentacle", L["bigtentacle"], 11.2, L["bigtentacle_icon"])
		self:DelayedMessage("bigtentacle", 11.2, L["bigtentacle"] , "Urgent", L["bigtentacle_icon"], "Alert")
	else
		if self:Tank() then
			self:Bar("impale", impale, 27.5, 106400)
		end
		self:Bar(105651, GetSpellInfo(105651), 55.5, 105651) -- Elementium Bolt
		if self:Difficulty() > 2 then
			self:Bar("hemorrhage", hemorrhage, 70.5, 105863)
			self:Bar("ej:4347", L["parasite"], 22.5, 108649)
		else
			self:Bar("hemorrhage", hemorrhage, 100.5, 105863)
		end
		self:Bar(110044, cataclysm, 190, 110044)
		self:Bar("bigtentacle", L["bigtentacle"], 16.7, L["bigtentacle_icon"])
		self:DelayedMessage("bigtentacle", 16.7, L["bigtentacle"] , "Urgent", L["bigtentacle_icon"], "Alert")
	end
end

function mod:ElementiumBolt(_, spellId, _, _, spellName)
	self:FlashShake(105651)
	self:Message(105651, spellName, "Important", spellId, "Long")
	self:Bar(105651, L["bolt_explode"], UnitBuff("player", (GetSpellInfo(109624))) and 18 or 8, spellId)
end

function mod:Cataclysm(_, spellId, _, _, spellName)
	self:Message(110044, spellName, "Attention", spellId)
	self:SendMessage("BigWigs_StopBar", self, spellName)
	self:Bar(110044, CL["cast"]:format(spellName), 60, spellId)
end

function mod:AgonizingPain()
	self:SendMessage("BigWigs_StopBar", self, CL["cast"]:format(cataclysm))
end

function mod:Shrapnel(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		local you = CL["you"]:format(spellName)
		self:LocalMessage(106794, you, "Important", spellId, "Long")
		self:FlashShake(106794)
		self:Bar(106794, you, 7, spellId)
	end
end

function mod:Parasite(player, spellId)
	self:TargetMessage("ej:4347", L["parasite"], player, "Urgent", spellId)
	self:PrimaryIcon("ej:4347", player)
	self:Bar("ej:4347", L["parasite"], 60, 108649)
	if UnitIsUnit(player, "player") then
		self:FlashShake("ej:4347")
		self:Bar("ej:4347", CL["you"]:format(L["parasite"]), 10, spellId)
		self:OpenProximity(10, "ej:4347")
		self:Say("ej:4347", CL["say"]:format(L["parasite"]))
	else
		self:Bar("ej:4347", CL["other"]:format(L["parasite"], player), 10, spellId)
	end
end

function mod:ParasiteRemoved(player)
	self:PrimaryIcon("ej:4347")
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp > 14.9 and hp < 16 and curPercent == 20 then
			self:Message("ej:4351", L["blobs_soon"]:format(15), "Positive", "ability_deathwing_bloodcorruption_earth", "Info")
			curPercent = 15
		elseif hp > 9.9 and hp < 11 and curPercent == 15 then
			self:Message("ej:4351", L["blobs_soon"]:format(10), "Positive", "ability_deathwing_bloodcorruption_earth", "Info")
			curPercent = 10
		elseif hp > 4.9 and hp < 6 and curPercent == 10 then
			self:Message("ej:4351", L["blobs_soon"]:format(5), "Positive", "ability_deathwing_bloodcorruption_earth", "Info")
			curPercent = 5
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

