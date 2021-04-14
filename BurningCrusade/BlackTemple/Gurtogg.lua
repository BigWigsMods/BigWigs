
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gurtogg Bloodboil", 564, 1586)
if not mod then return end
mod:RegisterEnableMob(22948)
mod:SetEncounterID(2477)
--mod:SetRespawnTime(0) -- Resets, doesn't respawn

--------------------------------------------------------------------------------
-- Locals
--

local bloodCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		42005, -- Bloodboil
		{40604, "ICON", "SAY"}, -- Fel Rage
		{40508, "ICON", "SAY"}, -- Fel-Acid Breath
		{40481, "TANK"}, -- Acidic Wound
		40491, -- Bewildering Strike
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Bloodboil", 42005)
	self:Log("SPELL_AURA_APPLIED", "FelRage", 40604)
	self:Log("SPELL_AURA_REMOVED", "FelRageRemoved", 40604)
	self:Log("SPELL_AURA_REMOVED", "FelRageRemovedFromBoss", 40594)
	self:Log("SPELL_CAST_START", "FelAcidBreath", 40508)
	self:Log("SPELL_CAST_SUCCESS", "FelAcidBreathOver", 40508)

	self:Log("SPELL_AURA_APPLIED", "BewilderingStrikeApplied", 40491)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcidicWound", 40481)
	self:Log("SPELL_AURA_REMOVED", "AcidicWoundRemoved", 40481)
end

function mod:OnEngage()
	bloodCount = 1

	self:Berserk(600)
	self:CDBar(42005, 10.5, CL.count:format(self:SpellName(42005), bloodCount)) -- Bloodboil
	self:CDBar(40508, 24.3) -- Fel-Acid Breath
	if not self:Solo() then
		self:CDBar(40604, 58) -- Fel Rage
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Bloodboil(args)
	self:MessageOld(args.spellId, "yellow", "info", CL.count:format(args.spellName, bloodCount))
	if bloodCount == 3 then bloodCount = 0 end
	bloodCount = bloodCount + 1
	self:CDBar(args.spellId, 10, CL.count:format(args.spellName, bloodCount))
end

function mod:FelRage(args)
	self:StopBar(args.spellName) -- Fel Rage
	self:StopBar(CL.count:format(args.spellName, bloodCount)) -- Bloodboil
	self:StopBar(40508) -- Fel-Acid Breath

	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessageOld(args.spellId, args.destName, "orange", "warning", nil, nil, true)
	self:TargetBar(args.spellId, 30, args.destName)
end

function mod:FelRageRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(args.spellName, args.destName)
end

function mod:FelRageRemovedFromBoss(args)
	if self:MobId(args.destGUID) == 22948 then
		bloodCount = 1

		self:Bar(42005, 10, CL.count:format(self:SpellName(42005), bloodCount)) -- Bloodboil
		self:CDBar(40604, 52) -- Fel Rage 52-55
		self:CDBar(40508, 26) -- Fel-Acid Breath
		self:MessageOld(40604, "cyan", "info", CL.over:format(args.spellName)) -- Fel Rage Over
	end
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(40508, 18609) -- 18609 = "Breath"
		end
		self:TargetMessageOld(40508, player, "red", "alert")
		self:PrimaryIcon(40508, player)
	end

	function mod:FelAcidBreath(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
		self:CDBar(args.spellId, 24.3)
	end

	function mod:FelAcidBreathOver(args)
		self:PrimaryIcon(args.spellId)
	end
end

function mod:BewilderingStrikeApplied(args)
	self:TargetMessageOld(args.spellId, args.destName, "green", "alert")
end

function mod:AcidicWound(args)
	if args.amount % 3 == 0 and args.amount > 8 then
		self:StackMessage(args.spellId, args.destName, args.amount, "green", args.amount > 14 and "alarm")
	end
end

function mod:AcidicWoundRemoved(args)
	if self:Me(args.destGUID) and self:Tank() then
		self:MessageOld(args.spellId, "green", "alarm", CL.removed:format(args.spellName))
	end
end
