
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Empress Shek'zeer", 897, 743)
if not mod then return end
mod:RegisterEnableMob(62837)

-----------------------------------------------------------------------------------------
-- Locals
--

local field = (GetSpellInfo(123627))
local visionsList = mod:NewTargetList()
local phase

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes."
	L.phases_icon = "achievement_raid_mantidraid07"

	L.eyes = "Eyes of the Empress"
	L.eyes_desc = "Count the stacks of eyes of the empress and show a duration bar."
	L.eyes_icon = 30307
	L.eyes_message = "%2$dx eyes on %1$s"
end
L = mod:GetLocale()
L.eyes = L.eyes.." "..INLINE_TANK_ICON
L.eyes_desc = CL.tank..L.eyes_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:6325", "eyes", {123788, "FLASHSHAKE"}, "proximity",
		{125390, "FLASHSHAKE"}, 124097,
		{124862, "FLASHSHAKE", "SAY"},
		"phases", "berserk", "bosskill",
	}, {
		["ej:6325"] = "ej:6336",
		[125390] = "ej:6340",
		[124862] = "ej:6341",
		phases = "general",
	}
end

function mod:OnBossEnable()

	self:RegisterEvent("UNIT_POWER", "CheapMansTimers")
	self:Log("SPELL_AURA_APPLIED_DOSE", "Eyes", 123707)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 125390)
	self:Log("SPELL_AURA_APPLIED", "Resin", 124097)
	self:Log("SPELL_AURA_APPLIED", "Visions", 124862)
	self:Log("SPELL_AURA_APPLIED", "CryOfTerror", 123788)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck")

	self:Death("Win", 62837)
end

function mod:OnEngage(diff)
	phase = 1
	self:OpenProximity(5)
	self:Berserk(480) -- assume
	self:Bar("ej:6325", field, 20, 123627)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EngageCheck()
	if phase ~= 2 then
		self:CheckBossStatus()
	end
end

function mod:CryOfTerror(player, _, _, _, spellName)
	self:TargetMessage(123788,spellName, player, "Attention", 123788, "Long")
	if UnitIsUnit("player", player) then
		self:FlashShake(123788)
	end
end

do
	local scheduled = nil
	local function warnVisions(spellName)
		mod:TargetMessage(124862, spellName, visionsList, "Important", 124862, "Alarm")
		scheduled = nil
	end
	function mod:Visions(player, _, _, _, spellName) -- if this is dispellable then we can remove the say and flashshake
		visionsList[#visionsList + 1] = player
		if UnitIsUnit("player", player) then
			-- EJ talks about 8 yard damage, but it is useless to have proximity meter because you are feared
			self:Say(124862, CL["say"]:format(spellName))
			self:FlashShake(124862)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(warnVisions, 0.1, spellName)
		end
	end
end

function mod:Fixate(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(125390)
		self:LocalMessage(125390, CL["you"]:format(spellName), "Personal", 125390, "Info")
		self:Bar(125390, spellName, 30, 125390) -- EJ sais 30, in game tooltip sais 20
	end
end

function mod:Resin(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(124097, CL["you"]:format(spellName), "Personal", 124097, "Info")
	end
end

function mod:CheapMansTimers(_, unit)
	if UnitIsUnit(unit, "boss1") then
		local power = UnitPower("boss1")
		if power == 149 then
			phase = 1
			self:OpenProximity(5)
			self:Bar("ej:6325", field, 19, 123627)
			self:Bar("phases", CL["phase"]:format(2), 149, L["phases_icon"])
		elseif power == 130 then
			self:Bar("ej:6325", field, 65, 123627)
			self:Message("ej:6325", field, "Attention", 123627)
		elseif power == 65 then
			self:Message("ej:6325", field, "Attention", 123627)
		elseif power == 2 then
			phase = 2
			self:CloseProximity()
			self:Bar("phases", CL["phase"]:format(1), 158, L["phases_icon"])
		end
	end
end

function mod:Eyes(player, spellId, _, _, _, buffStack)
	if self:Tank() then
		self:StopBar(L["eyes_message"]:format(player, buffStack - 1))
		self:Bar("eyes", L["eyes_message"]:format(player, buffStack), 30, spellId)
		self:LocalMessage("eyes", L["eyes_message"], "Urgent", spellId, buffStack > 2 and "Info" or nil, player, buffStack)
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 35 then -- phase starts at 30
			phase = 3
			self:Message("phases", CL["soon"]:format(CL["phase"]:format(phase)), "Positive", L["phases_icon"], "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end


