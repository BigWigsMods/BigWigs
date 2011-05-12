if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Beth'tilac", 800)
if not mod then return end
mod:RegisterEnableMob(52498)

--------------------------------------------------------------------------------
-- Locals
--

local stackWarn = 5 -- probably needs change

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.phase_one = "Phase 1"
	L.phase_two = "Phase 2"

	L.kiss_message = "%2$dx Kiss on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99052,
		99506, 99497,
		"bosskill"
	}, {
		[99052] = L["phase_one"],
		[99506] = L["phase_two"],
		bosskill = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "Kiss", 99506)
	self:Log("SPELL_CAST_START", "Devastate", 99052)

	--self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus") -- Not yet implemented for the boss
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Win", 52498)
end

function mod:OnEngage(diff)
	self:Bar(99497, L["phase_two"], 270, 99497) -- untested
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Kiss(player, spellId, _, _, _, stack)
	if stack > stackWarn then
		self:TargetMessage(99506, L["kiss_message"], player, "Urgent", spellId, "Info", stack)
	end
end

function mod:Devastate(_, spellId, _, _, spellName)
	self:Message(99052, spellName, "Important", spellId, "Long")
	-- This timer is only accurate if you dont fail with the Drones
	-- Might need to use the bosses power bar or something to adjust this
	self:Bar(99052, spellName, 90, spellId)
end
