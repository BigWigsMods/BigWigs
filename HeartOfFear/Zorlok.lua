
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperial Vizier Zor'lok", 897, 745)
if not mod then return end
mod:RegisterEnableMob(62980)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.force, L.force_desc = EJ_GetSectionInfo(6427)
	L.force_icon = 122713
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		127834, "force", 122740,
		"ej:6429",
		"berserk", "bosskill",
	}, {
		[127834] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") --Force and Verse
	self:Log("SPELL_CAST_START", "Attenuation", 127834)
	self:Log("SPELL_AURA_APPLIED", "ConvertApplied", 127834)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62980)
end

function mod:OnEngage(diff)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local convertList, scheduled = mod:NewTargetList(), nil
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

function mod:Attenuation(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, "Alert")
end

do
	local clearThroat = mod:SpellName(122933)
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
		if spellName == clearThroat and unit:match("boss") then -- adds might be casting it too so this might be simpler than CID check on bossIds
			self:Message("force", CL["soon"]:format(L["force"]), "Important", L["force_icon"], "Alarm")
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 45 then -- phase starts at 40
			self:Message("ej:6429", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 115181, "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

