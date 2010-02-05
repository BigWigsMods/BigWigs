--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Sindragosa", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36853)
mod.toggleOptions = {71047, {70126, "FLASHSHAKE"}, 71056, "airphase", "phase2", {69762, "FLASHSHAKE"}, {70106, "FLASHSHAKE"}, "bosskill"}
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

	L.airphase = "Airphase"
	L.airphase_desc = "Warns about Sindragosas lift-off"
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase_message = "Airphase inc!"
	L.airphase_bar = "Next Airphase"

	L.boom_message = "Explosion inc!"
	L.boom_bar = "Explosion!"

	L.unchained_message = "Unchained magic on YOU!"

	L.chilled_message = "Chilled to the Bone x%d!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Unchained", 69762)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Chilled", 70106)
	self:Log("SPELL_AURA_APPLIED", "FrostBeacon", 70126)
	self:Log("SPELL_CAST_SUCCESS", "BlisteringCold", 70117) -- (70123, 71047, 71048, 71049) are the Spell itself
	self:Log("SPELL_CAST_START", "Breath", 69649, 71056, 71057, 71058)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("AirPhase", L["airphase_trigger"])
	self:Yell("Phase2", L["phase2_trigger"])
	self:Death("Win", 36853)
end

function mod:OnEngage()
	self:Bar("airphase", L["airphase_bar"], 50, 23684)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function BeaconWarn(spellName)
		mod:TargetMessage(70126, spellName, beacon, "Urgent", 70126)
		mod:Bar(70126, spellName, 7, 70126)
		scheduled = nil
	end
	function mod:FrostBeacon(player, spellId, _, _, spellName)
		beacon[#beacon + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(70126)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(BeaconWarn, 0.3, spellName)
		end
	end
end

function mod:BlisteringCold()
	self:Message(71047, L["boom_message"], "Attention", 71047)
	self:Bar(71047, L["boom_bar"], 5, 71047)
end

function mod:AirPhase()
	self:SendMessage("BigWigs_StopBar", self, L["airphase_bar"]) -- Is this necessary?
	self:Message("airphase", L["airphase_message"], "Attention")
	self:Bar("airphase", L["airphase_bar"], 110, 23684)

	local bossId = self:GetUnitIdByGUID(36853)
	if not bossId then return end
	local min, max = UnitHealth(bossId), UnitHealthMax(bossId)
	local hpPercent = math.floor(min / max * 100 + 0.5) .. "%"
	print("Sindragosa took off at " .. hpPercent .. " hitpoints, please notify the developers in #bigwigs on freenode if possible.")
end

function mod:Phase2()
	self:SendMessage("BigWigs_StopBar", self, L["airphase_bar"])
	self:Message("phase2", L["phase2_message"], "Positive", nil, "Long")
end

function mod:Unchained(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(69762, L["unchained_message"], "Personal", spellId, "Alarm")
		self:FlashShake(69762)
	end
end

function mod:Chilled(player, spellId, _, _, _, stack)
	if UnitIsUnit(player, "player") then
		if stack and stack > 3 then
			self:LocalMessage(70106, L["chilled_message"]:format(stack), "Personal", spellId, "Alarm")
			self:FlashShake(70106)
		end
	end
end

function mod:Breath(_, spellId, _, _, spellName)
	self:Message(71056, spellName, "Important", spellId)
end
