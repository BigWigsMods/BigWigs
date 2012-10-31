
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperial Vizier Zor'lok", 897, 745)
if not mod then return end
mod:RegisterEnableMob(62980)

--------------------------------------------------------------------------------
-- Locals
--

local clearThroat = (GetSpellInfo(122933))
local forceAndVerve = (EJ_GetSectionInfo(6427))
local convertList = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		127834, "ej:6427", 122740,
		"ej:6429",
		"berserk", "bosskill",
	}, {
		[127834] = "ej:6428",
		["ej:6429"] = "ej:6429",
		berserk = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_CAST_START", "Attenuation", 127834)
	self:Log("SPELL_AURA_APPLIED", "ConvertApplied", 127834)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62980)
end

function mod:OnEngage(diff)
	self:Berserk(480) -- assume
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function convert(spellName)
		mod:TargetMessage(122740, spellName, convertList, "Important", 122740)
		scheduled = nil
	end
	function mod:ConvertApplied(player, _, _, _, spellName)
		convertList[#convertList + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(convert, 0.1, spellName) -- might need to adjust it for 25 man
		end
	end
end

function mod:Attenuation(_, _, _, _, spellName)
	self:Message(127834, spellName, "Urgent", 127834, "Alert")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if spellName == clearThroat and unit:match("boss") then -- adds might be casting it too so this might be simpler than CID check on bossIds
		self:Message("ej:6427", CL["soon"]:format(forceAndVerve), "Important", spellId, "Alarm")
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 45 then -- phase starts at 40
			self:Message("ej:6429", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 115181, "Info") -- the corrent icon
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

