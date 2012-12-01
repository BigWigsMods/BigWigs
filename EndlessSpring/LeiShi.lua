
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lei Shi", 886, 729)
if not mod then return end
mod:RegisterEnableMob(62983)

--------------------------------------------------------------------------------
-- Locals
--

local hiding = nil
local nextProtectWarning = 85

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.hp_to_go = "%d%% to go"
	L.end_hide = "Hiding ended"

	L.special = "Next special ability"
	L.special_desc = "Warning for next special ability"
	L.special_icon = 123263 -- I know it is icon for "Afraid", but since we don't warn for that, might as well use it

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		123461, 123250, 123244, 123705, "special", "berserk", "proximity", "bosskill",
	}, {
		[123461] = "general",
	}
end

function mod:VerifyEnable(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp > 8 and UnitCanAttack("player", unit) then
		return true
	end
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GetAwayApplied", 123461)
	self:Log("SPELL_AURA_REMOVED", "GetAwayRemoved", 123461)
	self:Log("SPELL_AURA_APPLIED", "Protect", 123250)
	self:Log("SPELL_CAST_START", "Hide", 123244)
	self:Log("SPELL_AURA_APPLIED", "ScaryFog", 123705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ScaryFog", 123705)
	self:Log("SPELL_AURA_REMOVED", "ScaryFogRemoved", 123705)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck") -- use this to detect him coming out of hide
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

function mod:OnEngage(diff)
	hiding = nil
	nextProtectWarning = 85
	self:Bar("special", "~"..L["special"], 33, 123263)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:Berserk(self:LFR() and 600 or self:Heroic() and 420 or 480)
	if self:Tank() then
		self:OpenProximity(3)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- NOTE: Any timer related to "special" is inaccurate, still need to figure out how they work

function mod:EngageCheck()
	self:CheckBossStatus()
	if hiding then
		hiding = nil
		self:Bar("special", "~"..L["special"], 20, 123263)
		self:Message(123244, L["end_hide"], "Attention", 123244)
	end
end

do
	local scheduled = nil
	local function reportFog(spellName)
		local highestStack, highestStackPlayer = 0
		for i=1, GetNumGroupMembers() do
			local unit = ("raid%d"):format(i)
			local _, _, _, stack = UnitDebuff(unit, spellName)
			if stack and stack > highestStack then
				highestStack = stack
				highestStackPlayer = unit
			end
		end
		mod:TargetMessage(123705, ("%s (%d)"):format(spellName, highestStack), (UnitName(highestStackPlayer)), "Attention", 123705)
		scheduled = nil
	end

	function mod:ScaryFog(player, spellId, _, _, spellName)
		if UnitIsUnit("player", player) then
			self:OpenProximity(4) -- could be less than 4 but still experimenting
		end
		self:Bar(spellId, "~"..spellName, 19, spellId)
		if not scheduled then
			scheduled = self:ScheduleTimer(reportFog, 0.1, spellName)
		end
	end
end

function mod:ScaryFogRemoved(player)
	if UnitIsUnit("player", player) and not self:Tank() then
		self:CloseProximity()
	end
end

function mod:Hide(_, spellId, _, _, spellName)
	hiding = true
	self:Message(spellId, spellName, "Attention", spellId)
end

do
	local getAwayStartHP
	function mod:GetAwayApplied(_, spellId, _, _, spellName)
		if UnitHealthMax("boss1") > 0 then
			getAwayStartHP = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
			self:Message(spellId, spellName, "Important", spellId, "Alarm")
		end
	end
	function mod:GetAwayRemoved()
		getAwayStartHP = nil
		self:Bar("special", "~"..L["special"], 30, 123263)
	end

	local prev = 0
	local lastHpToGo
	function mod:UNIT_HEALTH_FREQUENT(_, unitId)
		if unitId == "boss1" then
			local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
			if hp < nextProtectWarning then
				self:Message(123250, CL["soon"]:format(self:SpellName(123250)), "Positive", 123250) -- Protect
				nextProtectWarning = hp - 20
				if nextProtectWarning < 20 then
					nextProtectWarning = 0
				end
			end
			if getAwayStartHP then
				local t = GetTime()
				if t-prev > 3 then -- warn max once every 3 sec
					prev = t
					local hpToGo = math.ceil(4 - (getAwayStartHP - hp))
					if lastHpToGo ~= hpToGo and hpToGo > 0 then
						lastHpToGo = hpToGo
						self:Message(123461, L["hp_to_go"]:format(hpToGo), "Positive", 123461)
					end
				end
			end
		end
	end
end

function mod:Protect(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alarm")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, _, _, _, spellId)
	if spellId == 127524 and unitId == "boss1" then -- Transform
		self:Win()
	end
end

