
-- Notes --
-- Remove tainted shadows?
-- Warn for font of corruption?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Tyrant Velhari", 1026, 1394)
if not mod then return end
mod:RegisterEnableMob(90269, 93439) -- 90269 on beta
mod.engageId = 1784

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One: Oppression ]]--
		180004, -- Enforcer's Onslaught
		{180260, "SAY"}, -- Annihilating Strike
		{180300, "FLASH", "PROXIMITY"}, -- Infernal Tempest
		--[[ Stage Two: Contempt ]]--
		180533, -- Tainted Shadows
		180025, -- Harbinger's Mending
		--[[ Stage Three: Malice ]]--
		180608, -- Gavel of the Tyrant
		180040, -- Sovereign's Ward
		--[[ General ]]--
		{180000, "TANK"}, -- Seal of Decay
		180166, -- Touch of Harm
		{182459, "SAY", "PROXIMITY", "ICON"}, -- Edict of Condemnation
		"berserk",
	}, {
		[180004] = -11151, -- Stage One: Oppression
		[180533] = -11158, -- Stage Two: Contempt
		[180608] = -11166, -- Stage Three: Malice
		[180000] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "EnforcersOnslaught", 180004)
	self:Log("SPELL_CAST_START", "AnnihilatingStrike", 180260)
	self:Log("SPELL_CAST_START", "InfernalTempest", 180300)

	self:Log("SPELL_CAST_START", "TaintedShadows", 180533)
	self:Log("SPELL_CAST_START", "HarbingersMending", 180025, 181990)
	self:Log("SPELL_AURA_APPLIED", "HarbingersMendingApplied", 180025, 181990)

	self:Log("SPELL_CAST_START", "GavelOfTheTyrant", 180608)
	self:Log("SPELL_AURA_APPLIED", "SovereignsWard", 180040)

	self:Log("SPELL_AURA_APPLIED", "SealOfDecay", 180000)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SealOfDecay", 180000)
	self:Log("SPELL_AURA_APPLIED", "TouchOfHarm", 180166, 185237)
	self:Log("SPELL_AURA_APPLIED", "EdictOfCondemnation", 182459)
	self:Log("SPELL_AURA_REMOVED", "EdictOfCondemnationRemoved", 182459)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Tyrant Velhari (beta) engaged", false)
	wipe(mobCollector)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local adds = {
		[90270] = -11155,
		[91304] = -11155,
		[91302] = -11163,
		[90271] = -11163,
		[90272] = -11170,
		[91303] = -11170,
	}
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 5 do
			local guid = UnitGUID("boss"..i)
			if guid and not mobCollector[guid] then
				mobCollector[guid] = true
				local id = self:MobId(guid)
				if adds[id] then
					self:Message("berserk", "Neutral", nil, CL.spawning:format(self:SpellName(adds[id])), false)
				end
			end
		end
	end
end

-- Stage 1
function mod:EnforcersOnslaught(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(180260, name, "Attention", "Info", nil, nil, true)
		if self:Me(guid) then
			self:Say(180260)
		end
	end
	function mod:AnnihilatingStrike(args)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
		self:Bar(args.spellId, 3)
	end
end

function mod:InfernalTempest(args)
	self:Message(args.spellId, "Attention", "Warning", ("%s - SPREAD OUT"):format(args.spellName))
	self:Bar(args.spellId, 6.5)
	self:OpenProximity(args.spellId, 5)
	self:ScheduleTimer("CloseProximity", 6.5, args.spellId)
end

-- Stage 2
do
	local function printTarget(self, name, guid)
		self:TargetMessage(180533, name, "Important", "Alert")
	end
	function mod:TaintedShadows(args)
		self:GetUnitTarget(printTarget, 0.2, args.sourceGUID)
	end
end

function mod:HarbingersMending(args)
	self:Message(180025, "Attention", "Info", CL.casting:format(args.spellName))
end

function mod:HarbingersMendingApplied(args)
	self:TargetMessage(180025, args.destName, "Attention", "Info", nil, nil, true)
end

-- Stage 3
function mod:GavelOfTheTyrant(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
end

function mod:SovereignsWard(args)
	self:Message(args.spellId, "Urgent", "Long")
end

-- General
function mod:SealOfDecay(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
end

do
	local list = mod:NewTargetList()
	function mod:TouchOfHarm(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, 180166, list, "Attention", "Alarm")
		end
	end
end

do
	local timer1, timer2 = nil, nil
	function mod:EdictOfCondemnation(args)
		self:TargetBar(args.spellId, 9, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 30)
			timer1 = self:ScheduleTimer("OpenProximity", 3, args.spellId, 20)
			timer2 = self:ScheduleTimer("OpenProximity", 6, args.spellId, 10)
		else
			self:OpenProximity(args.spellId, 30, args.destName, true)
			timer1 = self:ScheduleTimer("OpenProximity", 3, args.spellId, 20, args.destName, true)
			timer2 = self:ScheduleTimer("OpenProximity", 6, args.spellId, 10, args.destName, true)
		end
		self:PrimaryIcon(args.spellId, args.destName)
	end

	function mod:EdictOfCondemnationRemoved(args)
		self:CancelTimer(timer1)
		self:CancelTimer(timer2)
		timer1, timer2 = nil, nil
		self:CloseProximity(args.spellId)
		self:PrimaryIcon(args.spellId)
		self:StopBar(args.spellName, args.destName)
	end
end

