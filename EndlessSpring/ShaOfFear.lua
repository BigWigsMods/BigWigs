
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Fear", 886, 709)
if not mod then return end
mod:RegisterEnableMob(60999)

--------------------------------------------------------------------------------
-- Locals
--

local swingCounter, thrashCounter, resetNext = 0, 0, nil
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
		"ej:6699", 119414, 129147,
		{ 119888, "FLASHSHAKE" }, 118977,
		"berserk", "bosskill",
	}, {
		["ej:6699"] = "ej:6086",
		[119888] = "ej:6089",
		berserk = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "BreathOfFear", 119414)
	self:Log("SPELL_CAST_START", "OminousCackle", 119692, 119693, 119593)
	self:Log("SPELL_AURA_APPLIED", "OminousCackleApplied", 129147)
	self:Log("SPELL_AURA_APPLIED", "Thrash", 131996)
	self:Log("SPELL_AURA_APPLIED", "DreadThrash", 132007)
	self:Log("SPELL_AURA_APPLIED", "Fearless", 118977)
	self:Log("SPELL_CAST_START", "DeathBlossom", 119888)

	self:Log("SWING_DAMAGE", "Swing", "*")
	self:Log("SWING_MISSED", "Swing", "*")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60999)
end


function mod:OnEngage(diff)
	self:Bar(119414, 119414, 33, 119414) -- Breath of Fear
	self:Bar(129147, 129147, 41, 129147) -- Ominous Cackle
	self:Bar("ej:6699", 131996, 10, 131996) -- Thrash
	self:Berserk(900)
	swingCounter, thrashCounter, resetNext = 0, 0, nil
	atSha = true
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Thrash(_, spellId, _, _, spellName)
	resetNext = 2
	if atSha then
		--[[ don't really need a counter until Dread Expanse (120289) I'll fancy this up after I get some logs
		if phase2 then
			thrashCounter = thrashCounter + 1
			if thrashCounter == 3 then
				self:DelayedMessage("ej:6699", 4, CL["custom_sec"]:format(self:SpellName(132007), 6), "Attention", 132007, self:Tank() or self:Healer() and "Info" or nil) -- Dread Thrash
				self:Bar("ej:6699", 132007, 10, 132007)
			else
				self:Bar("ej:6699", ("%s (%d)"):format(spellName, thrashCounter + 1), 10, spellId)
			end
			self:Message("ej:6699", ("%s (%d)"):format(spellName, thrashCounter), "Important", spellId)
		else
		end
		--]]
		self:Message("ej:6699", spellName, "Important", spellId)
		self:Bar("ej:6699", spellName, 10, spellId)
	end
end

function mod:DreadThrash(_, spellId, _, _, spellName)
	thrashCounter = 0
	resetNext = 5
	if atSha then
		self:Message("ej:6699", spellName, "Important", spellId, self:Tank() or self:Healer() and "Alarm" or nil)
		--self:Bar("ej:6699", ("%s (%d)"):format(self:SpellName(131996), thrashCounter + 1), 10, 131996) -- Thrash
		self:Bar("ej:6699", 131996, 10, 131996) -- Thrash
	end
end

function mod:Swing(player, damage, _, _, _, _, _, _, _, _, sGUID)
	if self:GetCID(sGUID) == 60999 then
		swingCounter = swingCounter + 1
		if swingCounter > 0 and UnitIsUnit("player", player) then --just the current tank
			self:Message("ej:6699", ("%s (%d){%s}"):format(L["swing"], swingCounter, tonumber(damage) and L["damage"] or L["miss"]), "Positive", 5547)
		end
		if resetNext then
			swingCounter = -resetNext -- ignore the thrash hits
			resetNext = nil
		end
	end
end

function mod:DeathBlossom(_, spellId, _, _, spellName)
	if not atSha then
		self:FlashShake(spellId)
		self:Bar(spellId, CL["cast"]:format(spellName), 2.25, spellId) -- so it can be emphasized for countdown
		self:Message(spellId, spellName, "Important", spellId, "Alert")
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
	--2s cast, then a 10s flight to the shrine
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
			scheduled = self:ScheduleTimer(warnCackle, 0.1, spellId)
		end
	end
end

