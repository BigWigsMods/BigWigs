if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Blood-Queen Lana'thel", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37955)
mod.toggleOptions = {71340, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local pName = UnitName("player")
local pact = mod:NewTargetList()
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Locale
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()

	self:Log("SPELL_AURA_APPLIED", "PactApplied", 71340)
	self:Death("Win", 37955)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(360, true)
end
--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local handle = nil
	local warned = nil
	local id, name = nil, nil
	local function PactWarn()
		if not warned then
			mod:TargetMessage(71340, name, pact, "Urgent", id)
		else
			warned = nil
			wipe(pact)
		end
		handle = nil
	end
	function mod:PactApplied(player, spellId, _, _, spellName)
		pact[#pact + 1] = player
		if handle then self:CancelTimer(handle) end
		id, name = spellId, spellName
		handle = self:ScheduleTimer(PactWarn, 0.1)
		if player == pName then
			warned = true
			self:TargetMessage(71340, spellName, player, "Important", spellId, "Info")
		end
	end
end