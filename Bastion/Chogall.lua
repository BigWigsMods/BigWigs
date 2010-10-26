if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Cho'gall", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(43324)
mod.toggleOptions = {91303, 81628, 82299, 82630, 82414, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local worshipTargets = mod:NewTargetList()
local worshipCooldown = 24

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.worship_cooldown = "~Worship"

	L.phase_one = "Phase One"
	L.phase_two = "Phase Two"
end
L = mod:GetLocale()

mod.optionHeaders = {
	[91303] = L["phase_one"],
	[82630] = L["phase_two"],
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Worship", 91317)
	self:Log("SPELL_CAST_START", "SummonCorruptingAdherent", 81628)
	self:Log("SPELL_CAST_START", "FesterBlood", 82299)
	self:Log("SPELL_CAST_SUCCESS", "LastPhase", 82630)
	self:Log("SPELL_CAST_SUCCESS", "DarkenedCreations", 82414)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 43324)
end


function mod:OnEngage(diff)
	self:Bar(91303, L["worship_cooldown"], 11, 91303)
	self:Bar(81628, (GetSpellInfo(81628)), 58, 81628)
	worshipCooldown = 24 -- its not 40 sec till the 1st add
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SummonCorruptingAdherent(_, spellId, _, _, spellName)
	worshipCooldown = 40
	self:Message(81628, spellName, "Attention", 81628)
	self:Bar(81628, spellName, 91, 81628)
	-- I assume its 40 sec from summon and the timer is not between two casts of Fester Blood
	self:Bar(82299, (GetSpellInfo(82299)), 40, 82299)
end

function mod:FesterBlood(_, spellId, _, _, spellName)
	self:Message(82299, spellName, "Important", spellId, "Alert")
end

function mod:LastPhase(_, spellId, _, _, spellName)
	self:Message(82630, spellName, "Attention", spellId)
	self:Bar(82414, (GetSpellInfo(82414)), 6, 82414)
end

function mod:DarkenedCreations(_, spellId, _, _, spellName)
	self:Message(82414, spellName, "Urgent", spellId)
	self:Bar(82414, spellName, 40, 82414)
end

do
	local scheduled = nil
	local function worshipWarn(spellName)
		mod:TargetMessage(91303, spellName, worshipTargets, "Important", 91303, "Alert")
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

