
--------------------------------------------------------------------------------
-- TODO:
-- -- Chain Link linked with message
-- -- Timers after Destructive Impact reset?
-- -- Mythic Fractured Boulder + Impact cast/land bars
-- -- Gruesome rage message
-- -- Vengeful Rage (mythic) message

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sludgefist", 2296, 2394)
if not mod then return end
mod:RegisterEnableMob(164407) -- Sludgefist
mod.engageId = 2399
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--
local destructiveStompCount = 1
local colossalRoarCount = 1
local chainLinkCount = 1
local hatefullGazeCount = 1
local chainSlamCount = 1
local seismicShiftCount = 1

local timers = {
	[332318] = {22.5, 23, 45, 22.5, 45, 22.5, 45, 22.5, 45.0, 23.1, 41.4}, -- Destructive Stomp
	[332687] = {0, 30.5, 37, 30.5, 37.0, 30.5, 37, 31, 36.5, 30.5, 33.1, 30.1}, -- Colossal Roar
	[340817] = {18.5, 25.5, 30, 13.5, 25, 30} -- Seismic Shift
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.yourLink = "You are linked with %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{331209, "SAY" ,"SAY_COUNTDOWN"}, -- Hateful Gaze
		331314, -- Destructive Impact
		335293, -- Chain Link
		332318, -- Destructive Stomp
		335361, -- Stonequake
		332687, -- Colossal Roar
		{335470, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Chain Slam
		340817, -- Seismic Shift
	},{
		[331209] = "general",
		[340817] = "mythic",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "HatefulGazeApplied", 331209)
	self:Log("SPELL_AURA_REMOVED", "HatefulGazeRemoved", 331209)
	self:Log("SPELL_AURA_APPLIED", "DestructiveImpactApplied", 331314)
	self:Log("SPELL_AURA_REMOVED", "DestructiveImpactRemoved", 331314)
	self:Log("SPELL_AURA_APPLIED", "ChainThemApplied", 342420, 342419) -- Pre chain debuff
	self:Log("SPELL_CAST_START", "DestructiveStomp", 332318)
	self:Log("SPELL_CAST_SUCCESS", "ColossalRoar", 332687)
	self:Log("SPELL_AURA_APPLIED", "ChainSlamApplied", 335470)
	self:Log("SPELL_AURA_REMOVED", "ChainSlamRemoved", 335470)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "SeismicShiftApplied", 340817)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 335361) -- Stonequake
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 335361)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 335361)
end

function mod:OnEngage()
	destructiveStompCount = 1
	colossalRoarCount = 1
	chainLinkCount = 1
	hatefullGazeCount = 1
	chainSlamCount = 1
	seismicShiftCount = 1

	self:Bar(335293, 5, CL.count:format(self:SpellName(335293), chainLinkCount)) -- Chain Link
	self:Bar(332318, timers[332318][destructiveStompCount], CL.count:format(self:SpellName(332318), destructiveStompCount)) -- Destructive Stomp
	self:Bar(335470, 37, CL.count:format(self:SpellName(335470), chainSlamCount)) -- Chain Slam
	self:Bar(331209, 52.5, CL.count:format(self:SpellName(331209), hatefullGazeCount)) -- Hateful Gaze
	if self:Mythic() then
		self:CDBar(340817, timers[340817][seismicShiftCount], CL.count:format(self:SpellName(340817), seismicShiftCount)) -- Seismic Shift
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HatefulGazeApplied(args)
	self:StopBar(CL.count:format(args.spellName, hatefullGazeCount))
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, hatefullGazeCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
	self:TargetBar(args.spellId, 6, args.destName, CL.count:format(args.spellName, hatefullGazeCount))
	hatefullGazeCount = hatefullGazeCount + 1
end

function mod:HatefulGazeRemoved(args)
	self:StopBar(CL.count:format(args.spellName, hatefullGazeCount-1), args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:DestructiveImpactApplied(args)
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 12)
end

function mod:DestructiveImpactRemoved(args)
	self:Bar(331209, 52.5, CL.count:format(self:SpellName(331209), hatefullGazeCount)) -- Hateful Gaze
end

do
	local scheduled, mainChainSet, secondChainSet, myLink, myPartner = nil, {}, {}, nil, nil
	function mod:ChainLinkMessage()
		if myLink then
			self:Message(335293, "blue", L.yourLink:format(self:ColorName(myPartner) or self:ColorName(secondChainSet[myLink])))
		end
		scheduled = nil
		mainChainSet = {}
		secondChainSet = {}
		myLink = nil
		myPartner = nil
	end

	function mod:ChainThemApplied(args)
		if self:Me(args.destGUID) then
			self:PlaySound(335293, "warning")
		end
		if args.spellId == 342420 then -- mainChainSet
			mainChainSet[#mainChainSet+1] = args.destName
			if self:Me(args.destGUID) then
				myLink = #mainChainSet
			end
		elseif args.spellId == 342419 then -- secondChainSet
			secondChainSet[#secondChainSet+1] = args.destName
			if self:Me(args.destGUID) then
				myLink = #secondChainSet
				myPartner = mainChainSet[#secondChainSet]
			end
		end
		if not scheduled then
			scheduled = self:ScheduleTimer("ChainLinkMessage", 0.1)
		end
		if #mainChainSet == 1 then
			self:StopBar(CL.count:format(CL.count:format(self:SpellName(335293), chainLinkCount)))
			self:Message(335293, "yellow", CL.count:format(self:SpellName(335293), chainLinkCount))
			chainLinkCount = chainLinkCount + 1
			self:CDBar(335293, 69, CL.count:format(self:SpellName(335293), chainLinkCount))
		end
	end
end

function mod:DestructiveStomp(args)
	self:StopBar(CL.count:format(args.spellName, destructiveStompCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, destructiveStompCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, destructiveStompCount))
	destructiveStompCount = destructiveStompCount + 1
	self:Bar(args.spellId, timers[args.spellId][destructiveStompCount], CL.count:format(args.spellName, destructiveStompCount))
end

function mod:ColossalRoar(args)
	self:StopBar(CL.count:format(args.spellName, colossalRoarCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, colossalRoarCount))
	self:PlaySound(args.spellId, "info")
	colossalRoarCount = colossalRoarCount + 1
	self:Bar(args.spellId, timers[args.spellId][colossalRoarCount], CL.count:format(args.spellName, colossalRoarCount))
end

function mod:ChainSlamApplied(args)
	self:StopBar(CL.count:format(args.spellName, chainSlamCount))
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, chainSlamCount))
	self:SecondaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 4)
		self:PlaySound(args.spellId, "warning")
	end
	chainSlamCount = chainSlamCount + 1
	self:Bar(args.spellId, 69, CL.count:format(args.spellName, chainSlamCount))
end

function mod:ChainSlamRemoved(args)
	self:SecondaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

do
	local prev = 0
	function mod:SeismicShiftApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(args.spellName, seismicShiftCount))
			self:Message(args.spellId, "yellow", CL.count:format(args.spellName, seismicShiftCount))
			seismicShiftCount = seismicShiftCount + 1
			self:CDBar(args.spellId, timers[args.spellId][seismicShiftCount], CL.count:format(args.spellName, seismicShiftCount))
			self:PlaySound(args.spellId, "long")
		end
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
