if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sludgefist", 2296, 2394)
if not mod then return end
mod:RegisterEnableMob(164407)
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
local stoneQuakeCount = 1

local timers = {
	[332318] = {22.5, 23, 45, 22.5, 45, 22.5, 45, 22.5, 45.0, 23.1, 41.4}, -- Destructive Stomp
	[332687] = {0, 30.5, 37, 30.5, 37.0, 30.5, 37, 31, 36.5, 30.5, 33.1, 30.1}, -- Colossal Roar
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.skipped = "%s skipped"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{331209, "SAY" ,"SAY_COUNTDOWN"}, -- Hateful Gaze
		331314, -- Stunned Impact
		{335293, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Chain Link
		332318, -- Destructive Stomp
		332362, -- Falling Debris
		332687, -- Colossal Roar
		{335470, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Chain Slam
		335361, -- Stonequake
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_AURA_APPLIED", "HatefulGazeApplied", 331209)
	self:Log("SPELL_AURA_REMOVED", "HatefulGazeRemoved", 331209)
	self:Log("SPELL_AURA_APPLIED", "StunnedImpactApplied", 331314)
	self:Log("SPELL_AURA_REMOVED", "StunnedImpactRemoved", 331314)
	self:Log("SPELL_AURA_APPLIED", "ChainThisOneApplied", 335270) -- Pre chain debuff
	self:Log("SPELL_AURA_REMOVED", "ChainThisOneRemoved", 335270) -- Pre chain debuff
	self:Log("SPELL_AURA_APPLIED", "ChainLinkApplied", 335293)
	self:Log("SPELL_CAST_START", "DestructiveStomp", 332318)
	self:Log("SPELL_CAST_SUCCESS", "ColossalRoar", 332687)
	self:Log("SPELL_AURA_APPLIED", "ChainSlamApplied", 335470)
	self:Log("SPELL_AURA_REMOVED", "ChainSlamRemoved", 335470)

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
	stoneQuakeCount = 1

	self:Bar(335293, 6, CL.count:format(self:SpellName(335293), chainLinkCount)) -- Chain Link
	self:CDBar(332362, 11) -- Falling Debris
	self:Bar(335361, 14.5, CL.count:format(self:SpellName(335361), stoneQuakeCount)) -- Stonequake
	self:Bar(332318, timers[332318][destructiveStompCount], CL.count:format(self:SpellName(332318), destructiveStompCount)) -- Destructive Stomp
	self:Bar(335470, 37, CL.count:format(self:SpellName(335470), chainSlamCount)) -- Chain Slam
	self:Bar(331209, 52.5, CL.count:format(self:SpellName(331209), hatefullGazeCount)) -- Hateful Gaze
end

--------------------------------------------------------------------------------
-- Event Handlers
--
local function checkIfSkipped(self, t)
	if self:CheckOption(335361, "BAR") and self:BarTimeLeft(CL.count:format(self:SpellName(335361), stoneQuakeCount)) == 0 then
		self:Message2(335361, "cyan", L.skipped:format(CL.count:format(self:SpellName(335361), stoneQuakeCount)))
		stoneQuakeCount = stoneQuakeCount + 1
		self:CDBar(335361, t, CL.count:format(self:SpellName(335361), stoneQuakeCount))
	end
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 335433 then -- Stonequake
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message2(335361, "cyan", CL.count:format(self:SpellName(335361), stoneQuakeCount))
				self:PlaySound(335361, "long")
				stoneQuakeCount = stoneQuakeCount + 1
				self:CDBar(335361, 35, CL.count:format(self:SpellName(335361), stoneQuakeCount))
				self:ScheduleTimer(checkIfSkipped, 38, self, 26) -- if skipped CD is ~ 64 from last one
			end
		elseif spellId == 332362 then -- Falling Debris
			self:Message2(332362, "yellow")
			self:PlaySound(332362, "alarm")
			self:CDBar(332362, 11) -- XXX Delayed sometimes due to other casts/charge/stun
		end
	end
end

function mod:HatefulGazeApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, hatefullGazeCount))
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

function mod:StunnedImpactApplied(args)
	self:Message2(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 8)
end

function mod:StunnedImpactRemoved(args)
	self:Bar(331209, 52.5, CL.count:format(self:SpellName(331209), hatefullGazeCount)) -- Hateful Gaze
end

do
	local mainTarget, onMe = nil, nil
	function mod:ChainThisOneApplied(args)
		onMe = nil
		mainTarget = args.destName
		self:TargetMessage2(335293, "yellow", args.destName, CL.count:format(self:SpellName(335293), chainLinkCount)) -- Chain Link
		self:PrimaryIcon(335293, args.destName)
		if self:Me(args.destGUID) then
			onMe = true
			self:PlaySound(335293, "warning") -- Chain Link
			self:Say(335293) -- Chain Link
			self:SayCountdown(335293, 5) -- Chain Link
		end
		chainLinkCount = chainLinkCount + 1
		self:Bar(335293, 22.5, CL.count:format(self:SpellName(335293), chainLinkCount)) -- Chain Link
	end

	function mod:ChainThisOneRemoved(args)
		self:PrimaryIcon(335293)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(335293) -- Chain Link
		end
	end

	function mod:ChainLinkApplied(args)
		if onMe and not self:Me(args.destGUID) then
			self:Message2(args.spellId, "blue", CL.link:format(self:ColorName(args.destName)))
			self:PlaySound(args.spellId, "info") -- Already gave a warning sound for the pre-debuff
		elseif not onMe and self:Me(args.destGUID) then
			self:Message2(args.spellId, "blue", CL.link:format(self:ColorName(mainTarget)))
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:DestructiveStomp(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, destructiveStompCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, destructiveStompCount))
	destructiveStompCount = destructiveStompCount + 1
	self:Bar(args.spellId, timers[args.spellId][destructiveStompCount], CL.count:format(args.spellName, destructiveStompCount))
end

function mod:ColossalRoar(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, colossalRoarCount))
	self:PlaySound(args.spellId, "info")
	colossalRoarCount = colossalRoarCount + 1
	self:Bar(args.spellId, timers[args.spellId][colossalRoarCount], CL.count:format(args.spellName, colossalRoarCount))
end

function mod:ChainSlamApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, chainSlamCount))
	self:SecondaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 4)
		self:PlaySound(args.spellId, "warning")
	end
	chainSlamCount = chainSlamCount + 1
	--self:Bar(args.spellId, 34, CL.count:format(args.spellName, chainSlamCount))
end

function mod:ChainSlamRemoved(args)
	self:SecondaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
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
