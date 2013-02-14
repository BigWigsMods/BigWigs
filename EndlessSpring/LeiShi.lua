
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lei Shi", 886, 729)
if not mod then return end
mod:RegisterEnableMob(62983, 63275) -- Lei Shi, Corrupted Protector

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
		123705,
		123461, 123250, 123244, "special", "berserk", "proximity", "bosskill",
	}, {
		[123705] = "heroic",
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
	self:Log("SPELL_AURA_REMOVED", "ProtectRemoved", 123250)
	self:Log("SPELL_CAST_START", "Hide", 123244)
	self:Log("SPELL_AURA_APPLIED", "ScaryFog", 123705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ScaryFog", 123705)
	self:Log("SPELL_AURA_REMOVED", "ScaryFogRemoved", 123705)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck") -- to detect her coming out of hide
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Kill", "boss1")
end

function mod:OnEngage(diff)
	hiding = nil
	nextProtectWarning = 85
	self:CDBar("special", 32, L["special"], 123263)
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "HealthCheck", "boss1")
	self:Berserk(self:Heroic() and 420 or 600)
	if self:Tank() then
		self:OpenProximity("proximity", 3)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EngageCheck()
	self:CheckBossStatus()
	if hiding then
		hiding = nil
		self:Message(123244, "Attention", nil, CL["over"]:format(self:SpellName(123244)))
		self:CDBar("special", 32, L["special"], 123263)
	end
end

do
	local scheduled = nil
	local function reportFog(spellName)
		local highestStack, highestStackPlayer = 0
		for i=1, GetNumGroupMembers() do
			local unit = ("raid%d"):format(i)
			local _, _, _, stack, _, duration = UnitDebuff(unit, spellName)
			if stack and stack > highestStack and duration > 0 then
				highestStack = stack
				highestStackPlayer = unit
			end
		end
		local player = UnitName(highestStackPlayer)
		mod:StackMessage(123705, player, highestStack, "Attention")
		scheduled = nil
	end

	function mod:ScaryFog(args)
		if UnitIsUnit("player", args.destName) then
			self:OpenProximity("proximity", 4) -- could be less than 4 but still experimenting
		end
		self:CDBar(args.spellId, 19)
		if not scheduled then
			scheduled = self:ScheduleTimer(reportFog, 0.1, args.spellName)
		end
	end
end

function mod:ScaryFogRemoved(args)
	if UnitIsUnit("player", args.destName) and not self:Tank() then
		self:CloseProximity()
	end
end

function mod:Hide(args)
	hiding = true
	self:Message(args.spellId, "Attention")
end

do
	local getAwayStartHP
	function mod:GetAwayApplied(args)
		if UnitHealthMax("boss1") > 0 then
			getAwayStartHP = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
			self:Message(args.spellId, "Important", "Alarm")
		end
	end
	function mod:GetAwayRemoved()
		getAwayStartHP = nil
		self:Bar("special", 32, L["special"], 123263)
	end

	local prev = 0
	local lastHpToGo
	function mod:HealthCheck(unitId)
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < nextProtectWarning then
			self:Message(123250, "Positive", nil, CL["soon"]:format(self:SpellName(123250))) -- Protect
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
					self:Message(123461, "Positive", nil, L["hp_to_go"]:format(hpToGo))
				end
			end
		end
	end
end

function mod:Protect(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:StopBar(L["special"]) --stop the bar since it's pretty likely the cd will expire during protect
end

function mod:ProtectRemoved()
	self:Message("special", "Attention", nil, CL["soon"]:format(L["special"]), 123263)
end

function mod:Kill(_, _, _, _, spellId)
	if spellId == 127524 then -- Transform
		self:Win()
	end
end

