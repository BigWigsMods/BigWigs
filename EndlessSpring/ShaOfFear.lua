
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Fear", 886, 709)
if not mod then return end
mod:RegisterEnableMob(60999)

--------------------------------------------------------------------------------
-- Locales
--

local cackleTargets = mod:NewTargetList()
local breathOfFear, thrash = (GetSpellInfo(119414)), (GetSpellInfo(131996))
local swingCounter
local atSha

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fading_soon = "%s fading soon"

	L.swing = "Swing"
	L.swing_desc = "Counts the number of swings before Trash"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		119414, 129147, "ej:6699",
		118977, { 119888, "FLASHSHAKE" },
		"berserk", "bosskill",
	}, {
		[119414] = "ej:6086",
		[118977] = "ej:6089",
		berserk = "general",

	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "BreathOfFear", 119414)
	self:Log("SPELL_AURA_APPLIED", "OminousCackle", 129147)
	self:Log("SPELL_AURA_APPLIED", "ThrashApplied", 131996)
	self:Log("SPELL_AURA_REMOVED", "ThrashRemoved", 131996)
	self:Log("SPELL_AURA_APPLIED", "Fearless", 118977)
	self:Log("SPELL_AURA_APPLIED", "DeathBlossom", 119888)

	self:Log("SWING_DAMAGE", "Swing", "*")
	self:Log("SWING_MISS", "Swing", "*")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60999)
end


function mod:OnEngage(diff)
	self:Bar(119414, breathOfFear, 33.3, 119414)
	self:Berserk(900) -- needs testing 
	swingCounter = 0
	atSha = true
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ThrashApplied()
	if atSha then
		self:Message("ej:6699", CL["soon"]:format(thrash), "Important", 131996)
	end
end

function mod:ThrashRemoved()
	swingCounter = 0
end

function mod:DeathBlossom(_, _, _, _, spellName)
	if not atSha then
		self:FlashShake(119888)
		self:Bar(119888, spellName, 2.25, 119888) -- so it can be emphasized for countdown
		self:Message(119888, spellName, "Important", 119888, "Alert")
	end
end

function mod:Swing(_, source)
	if source == self.moduleName then
		swingCounter = swingCounter + 1
		if atSha then
			self:Message("ej:6699", ("%s (%d)"):format(L["swing"], swingCounter), "Positive", 5547)
		end
	end
end

function mod:Fearless(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		atSha = true
		self:Bar(118977, spellName, 30, 118977)
		self:DelayedMessage(118977, 22, L["fading_soon"]:format(spellName), "Attention", 118977)
	end
end

function mod:BreathOfFear(_, _, _, _, spellName)
	self:Bar(119414, spellName, 33.3, 119414)
	if atSha then
		self:DelayedMessage(119414, 25, CL["soon"]:format(spellName), "Attention", 119414)
	end
end

do
	local scheduled = nil
	local function warnCackle(spellName)
		if atSha then
			mod:TargetMessage(129147, spellName, cackleTargets, "Urgent", 129147)
		end
		scheduled = nil
	end
	function mod:OminousCackle(player, _, _, _, spellName)
		cackleTargets[#cackleTargets + 1] = player
		if UnitIsUnit("player", player) then
			atSha = false
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(warnCackle, 2, spellName)
		end
	end
end
