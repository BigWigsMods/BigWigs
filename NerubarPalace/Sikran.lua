if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sikran, Captain of the Sureki", 2657, 2599)
if not mod then return end
mod:RegisterEnableMob(214503) -- Sikran
mod:SetEncounterID(2898)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local phaseBladesCount = 1
local decimateCount = 1
local shatteringSweepCount = 1
local captainsFlourishCount = 1
local rainOfArrowsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then

-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{433517, "SAY", "SAY_COUNTDOWN",  "ME_ONLY_EMPHASIZE"}, -- Phase Blades
			434860, -- Cosmic Wound
		442428, -- Decimate
			459273, -- Cosmic Shards
		456420, -- Shattering Sweep
		{439511, "TANK"}, -- Captain's Flourish
			{438845, "TANK"}, -- Expose
			{432969, "TANK"}, -- Phase Lunge
			{435410, "TANK"}, -- Pierced Defences
		439559, -- Rain of Arrows
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "PhaseBladesApplied", 433517)
	self:Log("SPELL_AURA_REMOVED", "PhaseBladesRemoved", 433517)
	self:Log("SPELL_AURA_APPLIED", "CosmicWoundApplied", 434860)
	self:Log("SPELL_CAST_START", "Decimate", 442428)
	self:Log("SPELL_AURA_APPLIED", "CosmicShardsApplied", 459273)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CosmicShardsApplied", 459273)
	self:Log("SPELL_CAST_START", "ShatteringSweep", 456420)
	self:Log("SPELL_CAST_SUCCESS", "CaptainsFlourish", 439511)
	self:Log("SPELL_AURA_APPLIED", "ExposeApplied", 438845)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExposeApplied", 438845)
	self:Log("SPELL_CAST_START", "PhaseLunge", 435403)
	self:Log("SPELL_AURA_APPLIED", "PiercedDefencesApplied", 435410)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PiercedDefencesApplied", 435410)
	self:Log("SPELL_CAST_START", "RainOfArrows", 439559)
end

function mod:OnEngage()
	phaseBladesCount = 1
	decimateCount = 1
	shatteringSweepCount = 1
	captainsFlourishCount = 1
	rainOfArrowsCount = 1

	-- self:Bar(433517, 5, CL.count:format(self:SpellName(433517), phaseBladesCount)) -- Phase Blades
	-- self:Bar(442428, 5, CL.count:format(self:SpellName(442428), decimateCount)) -- Decimate
	-- self:Bar(439511, 5, CL.count:format(self:SpellName(439511), captainsFlourishCount)) -- Captain's Flourish
	-- self:Bar(432969, 5, CL.count:format(self:SpellName(432969), rainOfArrowsCount)) -- Rain of Arrows
	-- self:Bar(456420, 120, CL.count:format(self:SpellName(456420), shatteringSweepCount)) -- Shattering Sweep
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:PhaseBladesApplied(args)
		if args.time - prev > 10 then
			self:StopBar(CL.count:format(args.spellName, phaseBladesCount))
			self:Message(args.spellId, "cyan", CL.count:format(args.spellName, phaseBladesCount))
			-- self:PlaySound(args.spellId, "alert")
			phaseBladesCount = phaseBladesCount + 1
			-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, phaseBladesCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, nil, nil, "Phase Blades")
			self:SayCountdown(args.spellId, 8)
		end
	end
end

function mod:PhaseBladesRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:CosmicWoundApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:Decimate(args)
	self:StopBar(CL.count:format(args.spellName, decimateCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, decimateCount))
	self:PlaySound(args.spellId, "alert")
	decimateCount = decimateCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, decimateCount))
end

do
	local stacks = 0
	function mod:CosmicShardsMessage()
		self:Message(459273, "blue", CL.stackyou:format(stacks, self:SpellName(459273)))
		self:PlaySound(459273, "alarm")
	end

	function mod:CosmicShardsApplied(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if stacks == 1 then
				self:ScheduleTimer("CosmicShardsMessage", 0.5)
			end
		end
	end
end

function mod:ShatteringSweep(args)
	self:StopBar(CL.count:format(args.spellName, shatteringSweepCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, shatteringSweepCount))
	self:PlaySound(args.spellId, "long")
	shatteringSweepCount = shatteringSweepCount + 1
	-- self:Bar(args.spellId, 120, CL.count:format(args.spellName, shatteringSweepCount))
end

-- Flourish cast (message/current tank sound) -> Expose debuff (message) -> Expose debuff (message) -> Phased Lunge cast (other tank sound) -> Pierced Defence (message)
function mod:CaptainsFlourish(args)
	-- XXX switch to a throttled Expose cast if this isn't... exposed
	self:StopBar(CL.count:format(CL.tank_combo, captainsFlourishCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.tank_combo, captainsFlourishCount))
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then -- boss1
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	-- self:Bar(432969, 3.5) -- Phase Lunge
	captainsFlourishCount = captainsFlourishCount + 1
	-- self:Bar(args.spellId, 20, CL.count:format(CL.tank_combo, captainsFlourishCount))
end

function mod:ExposeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 2)
end

function mod:PhaseLunge(args)
	self:StopBar(432969)
	-- self:Message(432969, "purple", CL.casting:format(args.spellName))
	if self:Tank() and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(432969, "warning") -- tauntswap
	end
end

function mod:PiercedDefencesApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
end

function mod:RainOfArrows(args)
	self:StopBar(CL.count:format(args.spellName, rainOfArrowsCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, rainOfArrowsCount))
	self:PlaySound(args.spellId, "alarm")
	rainOfArrowsCount = rainOfArrowsCount + 1
	-- self:Bar(args.spellId, 60, CL.count:format(args.spellName, rainOfArrowsCount))
end
