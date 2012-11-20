
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Fear", 886, 709)
if not mod then return end
mod:RegisterEnableMob(60999)

--------------------------------------------------------------------------------
-- Locals
--

local swingCounter = 0
local atSha = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fading_soon = "%s fading soon"

	L.swing = "Swing"
	L.swing_desc = "Counts the number of swings before Trash"

	L.damage = "Damage"
	L.miss = "Miss"
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
	self:Log("SPELL_CAST_START", "OminousCackle", 119692, 119693)
	self:Log("SPELL_AURA_APPLIED", "OminousCackleApplied", 129147)
	self:Log("SPELL_AURA_APPLIED", "ThrashApplied", 131996)
	self:Log("SPELL_AURA_REMOVED", "ThrashRemoved", 131996)
	self:Log("SPELL_AURA_APPLIED", "Fearless", 118977)
	self:Log("SPELL_CAST_START", "DeathBlossom", 119888)

	self:Log("SWING_DAMAGE", "Swing", "*")
	self:Log("SWING_MISS", "Swing", "*")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60999)
end


function mod:OnEngage(diff)
	self:Bar(119414, 119414, 33, 119414) -- Breath of Fear
	self:Bar(129147, 129147, 41, 129147) -- Ominous Cackle
	self:Berserk(900)
	swingCounter = 0
	atSha = true
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ThrashApplied(_, spellId, _, _, spellName)
	if atSha then
		self:Message("ej:6699", CL["soon"]:format(spellName), "Important", spellId)
	end
end

function mod:ThrashRemoved()
	swingCounter = 0
end

function mod:DeathBlossom(_, spellId, _, _, spellName)
	if not atSha then
		self:FlashShake(spellId)
		self:Bar(spellId, spellName, 2.25, spellId) -- so it can be emphasized for countdown
		self:Message(spellId, spellName, "Important", spellId, "Alert")
	end
end

function mod:Swing(_, damage, _, _, _, _, _, _, _, _, sGUID)
	if self:GetCID(sGUID) == 60999 then
		swingCounter = swingCounter + 1
		if atSha then
			self:Message("ej:6699", ("%s (%d){%s}"):format(L["swing"], swingCounter, type(damage) == "number" and L["damage"] or L["miss"]), "Positive", 5547)
		end
	end
end

function mod:Fearless(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		atSha = true
		self:Bar(spellId, spellName, 30, spellId)
		self:DelayedMessage(spellId, 22, L["fading_soon"]:format(spellName), "Attention", spellId)
	end
end

function mod:BreathOfFear(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 33.3, spellId)
	if atSha then
		self:DelayedMessage(spellId, 25, CL["soon"]:format(spellName), "Attention", spellId)
	end
end

function mod:OminousCackle(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 90, spellId)
end

do
	local cackleTargets, scheduled = mod:NewTargetList(), nil
	local function warnCackle(spellId)
		mod:TargetMessage(spellId, spellId, cackleTargets, "Urgent", spellId)
		scheduled = nil
	end
	function mod:OminousCackleApplied(player, spellId)
		cackleTargets[#cackleTargets + 1] = player
		if UnitIsUnit("player", player) then
			self:Bar(119888, 119888, 71, 119888) -- Death Blossom
			atSha = false
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnCackle, 2, spellId)
		end
	end
end

