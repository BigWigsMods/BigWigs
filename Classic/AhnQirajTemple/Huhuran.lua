
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Princess Huhuran", 531)
if not mod then return end
mod:RegisterEnableMob(15509)
mod:SetAllowWin(true)
mod:SetEncounterID(714)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Princess Huhuran"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		26180, -- Wyvern Sting
		26051, -- Enrage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "WyvernSting", 26180)
	self:Log("SPELL_AURA_APPLIED", "WyvernStingApplied", 26180)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 26051)
	self:Log("SPELL_AURA_APPLIED", "BerserkApplied", 26068)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

function mod:OnEngage()
	self:Berserk(300)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:WyvernSting(args)
	self:CDBar(26180, 25) -- Can randomly be way higher than 25
	self:DelayedMessage(26180, 23, "green", CL.soon:format(args.spellName))
end

do
	local stingTbl = mod:NewTargetList()
	function mod:WyvernStingApplied(args)
		stingTbl[#stingTbl+1] = args.destName
		self:TargetsMessage(26180, "red", stingTbl, 10, nil, nil, 1) -- Can take a while to apply to everyone if very spread out (travel time)
	end
end

function mod:Enrage(args)
	self:Message(26051, "yellow")
	if self:Dispeller("enrage", true) then
		self:PlaySound(26051, "warning")
	end
	self:CDBar(26051, 14.5)
end

function mod:BerserkApplied(args)
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus")

	-- Cancel Berserk
	local berserk = self:SpellName(26662)
	self:StopBar(berserk)
	self:CancelDelayedMessage(CL.custom_min:format(berserk, 2))
	self:CancelDelayedMessage(CL.custom_min:format(berserk, 1))
	self:CancelDelayedMessage(CL.custom_sec:format(berserk, 30))
	self:CancelDelayedMessage(CL.custom_sec:format(berserk, 10))
	self:CancelDelayedMessage(CL.custom_sec:format(berserk, 5))
	self:CancelDelayedMessage(CL.custom_end:format(self.displayName, berserk))

	self:Message("berserk", "orange", CL.percent:format(30, args.spellName), false)
	self:PlaySound("berserk", "alarm")
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 15509 then
		local hp = self:GetHealth(unit)
		if hp < 36  then
			self:UnregisterUnitEvent(event, "target", "focus")
			self:Message("berserk", "red", CL.soon:format(self:SpellName(26662)), false)
		end
	end
end
