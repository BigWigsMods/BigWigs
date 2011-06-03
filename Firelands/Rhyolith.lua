if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Rhyolith", 800)
if not mod then return end
mod:RegisterEnableMob(52577, 53087, 52558) -- Left foot, Right Foot, Lord Rhyolith

--------------------------------------------------------------------------------
-- Locales
--

local moltenArmorWarned = nil
local moltenArmor = GetSpellInfo(98255)

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.phase2_message = "Immolation phase soon! Boss has %dx %s"

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98255, 99846,
		"bosskill"
	}, {
		[98255] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenArmor", 98255, 101157)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52558)
end

function mod:OnEngage(diff)
	moltenArmorWarned = nil
	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function reset()
		moltenArmorWarned = nil
	end

	function mod:MoltenArmor(_, spellId, _, _, spellName, stack)
		if stack > 10 and not moltenArmorWarned then -- might need adjusting
			self:Message(98255, ("%dx %s"):format(moltenArmor, stack), "Attention", spellId)
			moltenArmorWarned = true

			self:ScheduleTimer(reset, 5)
		end
	end
end

function mod:UNIT_HEALTH(unitId)
	-- Boss frames were jumping around, there are 3 up with the buff on, so one of boss1 or boss2 is bound to exsist
	if unitId == "boss1" or "boss2" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 28 then -- phase starts at 25
			local stack = select(4,UnitBuff(unitId, moltenArmor))
			self:Message(99846, L["phase2_message"]:format(stack,moltenArmor), "Positive", 99846, "Info")
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end