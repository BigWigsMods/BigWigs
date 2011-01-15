--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Cho'gall", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(43324)
mod.toggleOptions = {91303, 82524, 81628, 82299, 82630, 82414, "orders", 82235, "proximity", "berserk", "bosskill"}
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
mod.optionHeaders = {
	[91303] = CL.phase:format(1),
	[82630] = CL.phase:format(2),
	orders = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local worshipTargets = mod:NewTargetList()
local worshipCooldown = 24
local sicknessWarned = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.orders = "Stance changes"
	L.orders_desc = "Warning for when Cho'gall changes between Shadow/Flame Orders stances."

	L.worship_cooldown = "~Worship"
	L.adherent_bar = "Next big add"
	L.adherent_message = "Add spawned!"
	L.ooze_bar = "Ooze adds"
	L.ooze_message = "Ooze swarm incoming!"
	L.tentacles_bar = "Tentacles spawn"
	L.tentacles_message = "Tentacle disco party!"
	L.sickness_message = "You feel terrible!"

	L.phase2_message = "Phase 2!"
	L.phase2_soon = "Phase 2 soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_CAST_SUCCESS", "Orders", 81171, 81556)

	--normal
	self:Log("SPELL_AURA_APPLIED", "Worship", 91317, 93365, 93366, 93367)
	self:Log("SPELL_CAST_START", "SummonCorruptingAdherent", 81628)
	self:Log("SPELL_CAST_START", "FuryOfChogall", 82524)
	self:Log("SPELL_CAST_START", "FesterBlood", 82299)
	self:Log("SPELL_CAST_SUCCESS", "LastPhase", 82630)
	self:Log("SPELL_CAST_SUCCESS", "DarkenedCreations", 82414, 93160)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 43324)
end

function mod:OnEngage(diff)
	self:Bar(91303, L["worship_cooldown"], 11, 91303)
	self:Bar(81628, L["adherent_bar"], diff > 2 and 107 or 58, 81628)
	self:Bar(82524, (GetSpellInfo(82524)), 100, 82524)
	self:Berserk(600)
	worshipCooldown = 24 -- its not 40 sec till the 1st add
	sicknessWarned = nil

	self:RegisterEvent("UNIT_POWER")
	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER(event, unit, powerType)
	if sicknessWarned or unit ~= "player" or powerType ~= "ALTERNATE" then return end
	local power = UnitPower("player", ALTERNATE_POWER_INDEX)
	if power > 49 then
		self:LocalMessage(82235, L["sickness_message"], "Important", 81831, "Long")
		self:OpenProximity(5)
		sicknessWarned = true
	end
end

function mod:FuryOfChogall(_, spellId, _, _, spellName)
	self:Message(82524, spellName, "Attention", spellId)
	self:Bar(82524, spellName, 47, spellId)
end

function mod:Orders(_, spellId, _, _, spellName)
	self:Message("orders", spellName, "Urgent", spellId)
end

function mod:SummonCorruptingAdherent(_, spellId, _, _, spellName)
	worshipCooldown = 40
	self:Message(81628, L["adherent_message"], "Important", spellId)
	self:Bar(81628, L["adherent_bar"], 91, spellId)

	-- I assume its 40 sec from summon and the timer is not between two casts of Fester Blood
	self:Bar(82299, L["ooze_bar"], 40, 82299)
end

function mod:FesterBlood(_, spellId, _, _, spellName)
	self:Message(82299, L["ooze_message"], "Attention", spellId, "Alert")
end

function mod:UNIT_HEALTH(event, unit)
	if unit == "boss1" and UnitName(unit) == self.displayName then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp < 30 then
			self:Message(82630, L["phase2_soon"], "Attention", 82630, "Info")
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

function mod:LastPhase(_, spellId)
	self:SendMessage("BigWigs_StopBar", self, L["adherent_bar"])
	self:SendMessage("BigWigs_StopBar", self, L["ooze_bar"])
	self:SendMessage("BigWigs_StopBar", self, L["worship_cooldown"])
	self:Message(82630, L["phase2_message"], "Positive", spellId)
	self:Bar(82414, L["tentacles_bar"], 6, 82414)
end

function mod:DarkenedCreations(_, spellId)
	self:Message(82414, L["tentacles_message"], "Urgent", spellId)
	self:Bar(82414, L["tentacles_bar"], 40, 82414)
end

do
	local scheduled = nil
	local function worshipWarn(spellName)
		mod:TargetMessage(91303, spellName, worshipTargets, "Important", 91303, "Alarm")
		scheduled = nil
	end
	function mod:Worship(player, spellId, _, _, spellName)
		worshipTargets[#worshipTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:Bar(91303, L["worship_cooldown"], worshipCooldown, 91303)
			self:ScheduleTimer(worshipWarn, 0.3, spellName)
		end
	end
end

