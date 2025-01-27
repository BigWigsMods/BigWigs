if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sprocketmonger Lockenstock", 2769, 2653)
if not mod then return end
mod:RegisterEnableMob(230583)
mod:SetEncounterID(3013)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activateInventions = 1
local footBlasterCount = 1
local pyroPartyPackCount = 1
local screwUpCount = 1
local sonicBaBoomCount = 1
local wireTransferCount = 1
local betaLaunchCount = 1
local voidsplosionCount = 1

local timersNormal = {
	[1218418] = { 0.0, 41.0, 30.0, 30.0, 0 }, -- Wire Transfer
	[1216509] = { 16.0, 34.0, 31.0, 0 }, -- Screw Up
	[465232] = { 6.0, 30.0, 30.0, 30.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 26.1, 32.0, 30.0, 23.0, 0 }, -- Pyro Party Pack
}
local timersHeroic = {
	[1217231] = { 12.0, 62.0, 31.0, 0 }, -- Foot-Blasters
	[1218418] = { 0.0, 41.0, 28.0, 28.0, 0 }, -- Wire Transfer
	[1216509] = { 47.0, 33.0, 32.0, 0 }, -- Screw Up
	[465232]  = { 6.0, 28.0, 29.0, 30.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 23.0, 34.0, 30.0, 0}, -- Pyro Party Pack
}
local timers = mod:Easy() and timersNormal or timersHeroic

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
		"stages",
		-- Stage One: Assembly Required
		473276, -- Activate Inventions!
			-- Goblin Inventions XXX key this for conveyor belt messages?
				-- 1216414, -- Blazing Beam
				-- 1216525, -- Rocket Barrage
				-- 1215858, -- Mega Magnetize
			-- Empowered Inventions
				-- 1216674, -- Void Laser (Fire Turret -> Void Turret)
				-- 1216699, -- Void Hell (Rocket Cannon -> Void Cannon)
		1217231, -- Foot-Blasters
			-- Unstable Explosion -- XXX count mines?
			1218342, -- Unstable Shrapnel
		1218418, -- Wire Transfer
		{1216509, "COUNTDOWN"}, -- Screw Up "SAY"
			-- Screwed!
		465232, -- Sonic Ba-Boom
		-- 471308, -- Firecracker Trap
		1214878, -- Pyro Party Pack
		{465917, "TANK"}, -- Gravi-Gunk

		-- Stage Two: Research and Destruction
		466765, -- Beta Launch
		466860, -- Bleeding Edge
			1218319, -- Voidsplosion
		{468791, "CASTBAR"}, -- Gigadeath
	},{
		[473276] = -30425, -- Stage 1
		[466765] = -30427, -- Stage 2
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "ActivateInventions", 473276)
	self:Log("SPELL_CAST_START", "FootBlasters", 1217231)
	self:Log("SPELL_AURA_APPLIED", "UnstableShrapnelApplied", 1218342)
	self:Log("SPELL_AURA_APPLIED", "GraviGunkApplied", 465917)
	self:Log("SPELL_CAST_START", "PyroPartyPack", 1214872)
	self:Log("SPELL_AURA_APPLIED", "PyroPartyPackApplied", 1214878)
	self:Log("SPELL_AURA_REMOVED", "PyroPartyPackRemoved", 1214878)
	self:Log("SPELL_CAST_START", "ScrewUp", 1216508)
	self:Log("SPELL_AURA_APPLIED", "ScrewUpApplied", 1216509)
	self:Log("SPELL_CAST_START", "SonicBaBoom", 465232)
	self:Log("SPELL_CAST_START", "WireTransfer", 1218418)
	-- Stage 2
	self:Log("SPELL_CAST_START", "BetaLaunch", 466765)
	self:Log("SPELL_CAST_SUCCESS", "BleedingEdge", 466860)
	self:Log("SPELL_AURA_APPLIED", "VoidsplosionApplied", 1218319)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidsplosionApplied", 1218319)
	self:Log("SPELL_AURA_APPLIED", "UpgradedBloodtechApplied", 1218344)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UpgradedBloodtechApplied", 1218344)
	self:Log("SPELL_CAST_START", "Gigadeath", 468791)

	-- self:Log("SPELL_AURA_APPLIED", "GroundDamage", 466235) -- Wire Transfer XXX kind of awkward a damage event not having it's own option

	timers = self:Easy() and timersNormal or timersHeroic
end

function mod:OnEngage()
	self:SetStage(1)
	activateInventions = 1
	footBlasterCount = 1
	pyroPartyPackCount = 1
	screwUpCount = 1
	sonicBaBoomCount = 1
	wireTransferCount = 1
	betaLaunchCount = 1

	-- self:Bar(1218418, timers[1218418][1], CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer (casted immediately)
	self:Bar(465232, timers[465232][1], CL.count:format(self:SpellName(465232), sonicBaBoomCount)) -- Sonic Ba-Boom
	if not self:Easy() then
		self:Bar(1217231, timers[1217231][1], CL.count:format(self:SpellName(1217231), footBlasterCount)) -- Foot-Blasters
	end
	self:Bar(1214878, timers[1214878][1], CL.count:format(self:SpellName(1214878), pyroPartyPackCount)) -- Pyro Party Pack
	self:Bar(1216509, timers[1216509][1], CL.count:format(self:SpellName(1216509), screwUpCount)) -- Screw Up
	self:Bar(473276, 30.0, CL.count:format(self:SpellName(473276), activateInventions)) -- Activate Inventions!
	self:Bar(466765, self:Easy() and 121.8 or 127.4, CL.count:format(self:SpellName(466765), betaLaunchCount)) -- Beta Launch
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1

function mod:ActivateInventions(args)
	self:StopBar(CL.count:format(args.spellName, activateInventions))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, activateInventions))
	self:PlaySound(args.spellId, "long")
	activateInventions = activateInventions + 1

	if activateInventions < 4 then -- 3 per
		self:Bar(args.spellId, 30, CL.count:format(args.spellName, activateInventions))
	end
end

function mod:FootBlasters(args)
	self:StopBar(CL.count:format(args.spellName, footBlasterCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, footBlasterCount))
	self:PlaySound(args.spellId, "alert")
	footBlasterCount = footBlasterCount + 1
	self:Bar(args.spellId, timers[args.spellId][footBlasterCount], CL.count:format(args.spellName, footBlasterCount))
end

function mod:UnstableShrapnelApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:GraviGunkApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 1 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 10)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		elseif self:Tank() and amount > 9 then
			self:PlaySound(args.spellId, "warning") -- taunt?
		end
	end
end

function mod:PyroPartyPack(args)
	if self:Tank() then
		self:Message(1214878, "purple", CL.casting:format(args.spellName))
		self:PlaySound(1214878, "info")
	end
end

function mod:PyroPartyPackApplied(args)
	self:StopBar(CL.count:format(args.spellName, pyroPartyPackCount))
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, pyroPartyPackCount))
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- not great being the same as taunt?
	end
	pyroPartyPackCount = pyroPartyPackCount + 1
	self:Bar(args.spellId, timers[args.spellId][pyroPartyPackCount], CL.count:format(args.spellName, pyroPartyPackCount))
end

function mod:PyroPartyPackRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:ScrewUp(args)
	self:StopBar(CL.count:format(args.spellName, screwUpCount))
	self:Message(1216509, "yellow", CL.count:format(args.spellName, screwUpCount))
	screwUpCount = screwUpCount + 1
	self:Bar(1216509, timers[1216509][screwUpCount], CL.count:format(args.spellName, screwUpCount))
end

function mod:ScrewUpApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		-- self:Say(args.spellId, nil, nil, "Screw Up")
	end
end

function mod:SonicBaBoom(args)
	self:StopBar(CL.count:format(args.spellName, sonicBaBoomCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, sonicBaBoomCount)))
	self:PlaySound(args.spellId, "alert") -- healer
	sonicBaBoomCount = sonicBaBoomCount + 1
	self:Bar(args.spellId, timers[args.spellId][sonicBaBoomCount], CL.count:format(args.spellName, sonicBaBoomCount))
end

function mod:WireTransfer(args)
	self:StopBar(CL.count:format(args.spellName, wireTransferCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, wireTransferCount))
	self:PlaySound(args.spellId, "alarm")
	wireTransferCount = wireTransferCount + 1
	self:Bar(args.spellId, timers[args.spellId][wireTransferCount], CL.count:format(args.spellName, wireTransferCount))
end

-- Stage 2

function mod:BetaLaunch(args)
	self:StopBar(CL.count:format(args.spellName, betaLaunchCount)) -- Beta Launch
	self:StopBar(CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer
	self:StopBar(CL.count:format(self:SpellName(465232), sonicBaBoomCount)) -- Sonic Ba-Boom
	self:StopBar(CL.count:format(self:SpellName(1217231), footBlasterCount)) -- Foot-Blasters
	self:StopBar(CL.count:format(self:SpellName(1214878), pyroPartyPackCount)) -- Pyro Party Pack
	self:StopBar(CL.count:format(self:SpellName(473276), activateInventions)) -- Activate Inventions!
	self:StopBar(CL.count:format(self:SpellName(1216509), screwUpCount)) -- Screw Up

	self:SetStage(2)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, betaLaunchCount))
	self:PlaySound(args.spellId, "long")
	-- self:CastBar(args.spellId, 2, CL.knockback)
	betaLaunchCount = betaLaunchCount + 1

	voidsplosionCount = 1

	self:Bar(1218319, 4.8, CL.count:format(self:SpellName(1218319), voidsplosionCount)) -- Voidsplosion
end

function mod:BleedingEdge(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 20, CL.stage:format(1))
end

do
	local prev = 0
	function mod:VoidsplosionApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, voidsplosionCount))
			self:Message(args.spellId, "orange", CL.count:format(args.spellName, voidsplosionCount))
			self:PlaySound(args.spellId, "alert") -- healer
			voidsplosionCount = voidsplosionCount + 1
			if voidsplosionCount < 5 then
				self:Bar(args.spellId, 5, CL.count:format(args.spellName, voidsplosionCount)) -- Voidsplosion
			end
		end
	end
end

function mod:UpgradedBloodtechApplied(args)
	self:SetStage(1)
	self:Message("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long")

	activateInventions = 1
	footBlasterCount = 1
	pyroPartyPackCount = 1
	screwUpCount = 1
	sonicBaBoomCount = 1
	wireTransferCount = 1
	betaLaunchCount = 1

	-- self:Bar(1218418, timers[1218418][1], CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer (casted immediately)
	self:Bar(465232, timers[465232][1], CL.count:format(self:SpellName(465232), sonicBaBoomCount)) -- Sonic Ba-Boom
	if not self:Easy() then
		self:Bar(1217231, timers[1217231][1], CL.count:format(self:SpellName(1217231), footBlasterCount)) -- Foot-Blasters
	end
	self:Bar(1214878, timers[1214878][1], CL.count:format(self:SpellName(1214878), pyroPartyPackCount)) -- Pyro Party Pack
	self:Bar(1216509, timers[1216509][1], CL.count:format(self:SpellName(1216509), screwUpCount)) -- Screw Up
	self:Bar(473276, 30.0, CL.count:format(self:SpellName(473276), activateInventions)) -- Activate Inventions!
	if betaLaunchCount < 3 then
		self:Bar(466765, 120.3, CL.count:format(self:SpellName(466765), betaLaunchCount)) -- Beta Launch
	elseif betaLaunchCount == 3 then
		self:Bar(468791, 120.3) -- Gigadeath
	end
end

function mod:Gigadeath(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- enrage
	self:CastBar(args.spellId, 4)
end

-- do
-- 	local prev = 0
-- 	function mod:GroundDamage(args)
-- 		if self:Me(args.destGUID) and args.time - prev > 2 then
-- 			prev = args.time
-- 			self:PlaySound(args.spellId, "underyou")
-- 			self:PersonalMessage(args.spellId, "underyou")
-- 		end
-- 	end
-- end
