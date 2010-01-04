--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Festergut", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36626)
mod.toggleOptions = {69279, "proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local sporeTargets = mod:NewTargetList()
local doprint = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.spore_bar = "~Next Gas Spores"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Death("Win", 36626)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Log("SPELL_AURA_APPLIED", "Spores", 69279)

	if doprint < 2 then
		doprint = doprint + 1
		print("|cFF33FF99BigWigs_Festergut|r: Mod is alpha, timers may be wrong.")
	end
end

function mod:OnEngage()
	self:Berserk(300, true)
	self:Bar(69279, L["spore_bar"], 20, 69279)
	self:OpenProximity(9)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function sporeWarn(spellName)
		mod:TargetMessage(69279, spellName, sporeTargets, "Urgent", 69279, "Alert")
		scheduled = nil
	end
	local function sporeNext(spellName)
		mod:Bar(69279, L["spore_bar"], 16, 69279)
	end
	function mod:Spores(player, spellId, _, _, spellName)
		sporeTargets[#sporeTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(sporeWarn, 0.2, spellName)
			self:ScheduleTimer(sporeNext, 12, spellName)
			self:Bar(69279, spellName, 12, spellId)
		end
	end
end

