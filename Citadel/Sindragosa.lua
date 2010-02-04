--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Sindragosa", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36853)
mod.toggleOptions = {69846, 71047, 71056, 70126, "airphase", "phase2", "bosskill"}
-- 69846 = Frost Bomb (Fires a missile towards a random target. When this missile lands, it deals 5655 to 6345 Shadow damage to all enemies within 10 yards of that location.)
-- 70117 = Icy Grip, pulls players to the middle, 1sec after that she starts blistering cold
-- 70126 = Frost Beacon (mark for 70157 frost tomb)
-- 71056 = Frostbreath (Frost damage to enemies in a 60 yard cone in front of the caster. In addition, the targets' attack speed and chance to dodge are decreased by 50% for 6 sec.)
-- 71047 = Blistering Cold/ 5 sec cast /Deals 60.000 Frost damage to enemies within 25 yards.

--------------------------------------------------------------------------------
-- Locals
--

local beacon = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "You are fools to have come to this place."
	
	L.phase2 = "Phases 2"
	L.phase2_desc = "Warn for phase 2 changes."
	L.phase2_trigger = "Now, feel my master's limitless power and despair!"
	L.phase2_message = "Phase 2!"
	
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "Airphase"
	L.airphase_message = "Airphase"
	L.airphase_desc = "Warns about Sindragosas lift-off"
	L.boom = "Explosion!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FrostBeacon", 70126)
	self:Log("SPELL_CAST_SUCCESS", "BlisteringCold", 70117) -- (70123, 71047, 71048, 71049) are the Spell itself
	self:Log("SPELL_SUMMON", "FrostBomb", 69846)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("AirPhase", L["airphase_trigger"])
	self:Yell("Phase2", L["phase2_trigger"])
	self:Death("Win", 36853)
end

function mod:OnEngage()
	self:Bar("airphase", L["airphase_message"], 50)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function BeaconWarn(spellName)
		mod:TargetMessage(70126, spellName, beacon, "Urgent", 70126)
		scheduled = nil
	end
	function mod:FrostBeacon(player, spellId, _, _, spellName)
		beacon[#beacon + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(BeaconWarn, 0.3, spellName)
		end
	end
end

function mod:FrostBomb( _, spellId, _, _, spellName)
	self:Message(69846, spellName, "Attention", spellId)
end

function mod:BlisteringCold(_, spellId, _, _, spellName)
	self:Message(70123, spellName, "Attention", spellId)
	self:Bar(70123, L["boom"], 6, spellId)
end

function mod:AirPhase()
	self:Message("airphase", L["airphase_message"], "Attention")
	self:Bar("airphase", L["airphase_message"], 110)

	local bossId = self:GetUnitIdByGUID(36853)
	if not bossId then return end
	local min, max = UnitHealth(bossId), UnitHealthMax(bossId)
	local hpPercent = math.floor(min / max * 100 + 0.5) .. "%"
	print("Sindragosa took off at " .. hpPercent .. " hitpoints, please notify the developers in #bigwigs on freenode if possible.")
end

function mod:Phase2()
	self:SendMessage("BigWigs_StopBar", self, L["airphase_message"])
	self:Message("phase", L["phase2_message"], "Positive")
end

