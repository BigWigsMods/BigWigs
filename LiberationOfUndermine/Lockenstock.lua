
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

local activateInventionsCount = 1
local footBlasterCount = 1
local pyroPartyPackCount = 1
local screwUpCount = 1
local sonicBaBoomCount = 1
local wireTransferCount = 1
local betaLaunchCount = 1
local voidsplosionCount = 1
local polarizationGeneratorCount = 1

local myCharge = nil

local timersNormal = {
	[1218418] = { 2.0, 39.0, 60.0, 0 }, -- Wire Transfer
	[1216509] = { 47.0, 31.0, 31.0, 0 }, -- Screw Up
	[465232] = { 8.0, 28.0, 27.0, 32.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 23.1, 34.0, 30.1, 0 }, -- Pyro Party Pack
}
local timersHeroic = {
	[1217231] = { 12.0, 62.0, 0 }, -- Foot-Blasters
	[1218418] = { 0.0, 41.0, 56.0, 0 }, -- Wire Transfer
	[1216509] = { 47.0, 33.0, 32.0, 0 }, -- Screw Up
	[465232]  = { 6.0, 28.0, 29.0, 30.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 23.0, 34.0, 30.0, 0 }, -- Pyro Party Pack
}
local timersMythic = {
	[1217231] = { 12.0, 33.0, 30.0, 30.0, 0 }, -- Foot-Blasters
	[1218418] = { 0.0, 40.9, 60.0, 0 }, -- Wire Transfer
	[1216509] = { 18.0, 30.0, 32.0, 27.0, 0 }, -- Screw Up
	[465232]  = { 8.9, 25.0, 27.0, 31.9, 18.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 24.6, 33.0, 30.0, 0 }, -- Pyro Party Pack
	[1216802] = { 4.0, 66.9, 46.0 }, -- Polarization Generator
}
local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.foot_blasters = "Mines"
	L.screw_up = "Drills"
	L.sonic_ba_boom = "Raid Damage"
	L.polarization_generator = "Color Swaps"
	L.posi_polarization = _G.BLUE_GEM
	L.nega_polarization = _G.RED_GEM

	L.polarization_soon = "Color Swap Soon: %s"

	L.activate_inventions = "Activate: %s"
	L.blazing_beam = "Beams"
	L.rocket_barrage = "Rockets"
	L.mega_magnetize = "Magnets"
	L.jumbo_void_beam = "Big Beams"
	L.void_barrage = "Balls"
end

local inventions

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",

		-- Mythic
		1216802, -- Polarization Generator
		1216911, -- Posi-Polarization
		1216934, -- Nega-Polarization
		1219047, -- Polarized Catastro-Blast

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
		1216509, -- Screw Up
			-- Screwed!
		465232, -- Sonic Ba-Boom
		1214878, -- Pyro Party Pack
		{465917, "TANK"}, -- Gravi-Gunk

		-- Stage Two: Research and Destruction
		-- 466765, -- Beta Launch
		466860, -- Bleeding Edge
			1218319, -- Voidsplosion
		{468791, "CASTBAR"}, -- Gigadeath
	},{
		[1216802] = "mythic",
		[473276] = -30425, -- Stage 1
		[466860] = -30427, -- Stage 2
	},{
		[1216802] = L.polarization_generator,
		[1217231] = L.foot_blasters,
		[1216509] = L.screw_up,
		[465232] = L.sonic_ba_boom,
		[1214878] = CL.bomb,
		[1216911] = L.posi_polarization,
		[1216934] = L.nega_polarization,
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

	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "PolarizationGenerator", 1217355)
	self:Log("SPELL_AURA_APPLIED", "PolarizationGeneratorPosiApplied", 1217357)
	self:Log("SPELL_AURA_APPLIED", "PolarizationGeneratorNegaApplied", 1217358)
	self:Log("SPELL_AURA_APPLIED", "PosiPolarizationApplied", 1216911)
	self:Log("SPELL_AURA_APPLIED", "NegaPolarizationApplied", 1216934)
	self:Log("SPELL_AURA_APPLIED", "PolarizedCatastroBlastApplied", 1219047)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PolarizedCatastroBlastApplied", 1219047)

	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic
end

function mod:OnRegister()
	inventions = {
		{ L.blazing_beam, L.rocket_barrage, L.mega_magnetize },
		{ L.jumbo_void_beam, CL.plus:format(L.jumbo_void_beam, L.rocket_barrage), CL.plus:format(L.jumbo_void_beam, L.mega_magnetize) },
		{ L.void_barrage, CL.plus:format(L.mega_magnetize, L.void_barrage), CL.plus:format(L.blazing_beam, CL.plus:format(L.mega_magnetize, L.void_barrage)) }
	}
end

function mod:OnEngage()
	self:SetStage(1)
	activateInventionsCount = 1
	footBlasterCount = 1
	pyroPartyPackCount = 1
	screwUpCount = 1
	sonicBaBoomCount = 1
	wireTransferCount = 1
	betaLaunchCount = 1
	polarizationGeneratorCount = 1

	myCharge = nil

	-- self:Bar(1218418, timers[1218418][1], CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer (casted immediately)
	if self:Mythic() then
		self:Bar(1216802, timers[1216802][1], CL.count:format(L.polarization_generator, polarizationGeneratorCount))
	end
	self:Bar(465232, timers[465232][1], CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)) -- Sonic Ba-Boom
	if not self:Easy() then
		self:Bar(1217231, timers[1217231][1], CL.count:format(L.foot_blasters, footBlasterCount)) -- Foot-Blasters
	end
	self:Bar(1214878, timers[1214878][1], CL.count:format(CL.bomb, pyroPartyPackCount)) -- Pyro Party Pack
	self:Bar(1216509, timers[1216509][1], CL.count:format(L.screw_up, screwUpCount)) -- Screw Up
	self:Bar(473276, 30.0, CL.count:format(inventions[1][1], activateInventionsCount)) -- Activate Inventions!
	self:Bar("stages", 121.6, CL.count:format(CL.stage:format(2), betaLaunchCount), 466765) -- Beta Launch
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1

function mod:ActivateInventions(args)
	self:StopBar(CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount))
	self:Message(args.spellId, "cyan", CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount))
	self:PlaySound(args.spellId, "long")
	activateInventionsCount = activateInventionsCount + 1

	if activateInventionsCount < 4 then -- 3 per
		self:Bar(args.spellId, 30, CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount))
	end
end

function mod:FootBlasters(args)
	self:StopBar(CL.count:format(L.foot_blasters, footBlasterCount))
	self:Message(args.spellId, "orange", CL.count:format(L.foot_blasters, footBlasterCount))
	self:PlaySound(args.spellId, "alert")
	footBlasterCount = footBlasterCount + 1
	self:Bar(args.spellId, timers[args.spellId][footBlasterCount], CL.count:format(L.foot_blasters, footBlasterCount))
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

function mod:PyroPartyPack()
	if self:Tank() then
		self:Message(1214878, "purple", CL.casting:format(CL.bomb))
		self:PlaySound(1214878, "info")
	end
end

function mod:PyroPartyPackApplied(args)
	self:StopBar(CL.count:format(CL.bomb, pyroPartyPackCount))
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(CL.bomb, pyroPartyPackCount))
	self:TargetBar(args.spellId, 6, args.destName, CL.bomb)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- not great being the same as taunt?
	end
	pyroPartyPackCount = pyroPartyPackCount + 1
	self:Bar(args.spellId, timers[args.spellId][pyroPartyPackCount], CL.count:format(CL.bomb, pyroPartyPackCount))
end

function mod:PyroPartyPackRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:ScrewUp()
	self:StopBar(CL.count:format(L.screw_up, screwUpCount))
	self:Message(1216509, "yellow", CL.count:format(L.screw_up, screwUpCount))
	screwUpCount = screwUpCount + 1
	self:Bar(1216509, timers[1216509][screwUpCount], CL.count:format(L.screw_up, screwUpCount))
end

function mod:ScrewUpApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.screw_up)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:SonicBaBoom(args)
	self:StopBar(CL.count:format(L.sonic_ba_boom, sonicBaBoomCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)))
	self:PlaySound(args.spellId, "alert") -- healer
	sonicBaBoomCount = sonicBaBoomCount + 1
	self:Bar(args.spellId, timers[args.spellId][sonicBaBoomCount], CL.count:format(L.sonic_ba_boom, sonicBaBoomCount))
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
	self:StopBar(CL.count:format(CL.stage:format(2), betaLaunchCount)) -- Beta Launch
	self:StopBar(CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer
	self:StopBar(CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)) -- Sonic Ba-Boom
	self:StopBar(CL.count:format(L.foot_blasters, footBlasterCount)) -- Foot-Blasters
	self:StopBar(CL.count:format(CL.bomb, pyroPartyPackCount)) -- Pyro Party Pack
	-- self:StopBar(CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount)) -- Activate Inventions!
	self:StopBar(CL.count:format(L.screw_up, screwUpCount)) -- Screw Up
	-- self:StopBar(CL.count:format(L.polarization_generator, polarizationGeneratorCount)) -- Polarization Generator

	self:SetStage(2)
	self:Message("stages", "cyan", CL.count:format(CL.stage:format(2), betaLaunchCount), args.spellId)
	self:PlaySound("stages", "long")
	-- self:CastBar(args.spellId, 4, L.beta_launch_cast)
	betaLaunchCount = betaLaunchCount + 1

	voidsplosionCount = 1

	self:Bar(1218319, self:Mythic() and 4.8 or 6.3, CL.count:format(self:SpellName(1218319), voidsplosionCount)) -- Voidsplosion
end

function mod:BleedingEdge(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	self:Bar("stages", self:Easy() and 10 or 20, CL.stage:format(1), args.spellId)
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
			if voidsplosionCount < (self:Easy() and 3 or 5) then
				self:Bar(args.spellId, 5, CL.count:format(args.spellName, voidsplosionCount)) -- Voidsplosion
			end
		end
	end
end

function mod:UpgradedBloodtechApplied(args)
	self:SetStage(1)
	self:Message("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long")

	activateInventionsCount = 1
	footBlasterCount = 1
	pyroPartyPackCount = 1
	screwUpCount = 1
	sonicBaBoomCount = 1
	wireTransferCount = 1
	-- polarizationGeneratorCount = 1

	-- self:Bar(1218418, timers[1218418][1], CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer (casted immediately)
	-- if self:Mythic() then
	-- 	self:Bar(1216802, timers[1216802][1], CL.count:format(L.polarization_generator, polarizationGeneratorCount)) -- Polarization Generator
	-- end
	self:Bar(465232, timers[465232][1], CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)) -- Sonic Ba-Boom
	if not self:Easy() then
		self:Bar(1217231, timers[1217231][1], CL.count:format(L.foot_blasters, footBlasterCount)) -- Foot-Blasters
	end
	self:Bar(1214878, timers[1214878][1], CL.count:format(CL.bomb, pyroPartyPackCount)) -- Pyro Party Pack
	self:Bar(1216509, timers[1216509][1], CL.count:format(L.screw_up, screwUpCount)) -- Screw Up
	self:Bar(473276, 30.0, CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount)) -- Activate Inventions!
	if betaLaunchCount < 3 then
		self:Bar("stages", 120.3, CL.count:format(CL.stage:format(2), betaLaunchCount), 466765) -- Beta Launch
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

-- Mythic

function mod:PolarizationGenerator(args)
	self:StopBar(CL.count:format(L.polarization_generator, polarizationGeneratorCount))
	polarizationGeneratorCount = polarizationGeneratorCount + 1
	self:Bar(1216802, timers[1216802][polarizationGeneratorCount], CL.count:format(L.polarization_generator, polarizationGeneratorCount))
end

function mod:PolarizationGeneratorPosiApplied(args)
	if self:Me(args.destGUID) then
		self:Message(1216802, "cyan", L.polarization_soon:format(_G.LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(L.posi_polarization)))
		if myCharge ~= "blue" then
			self:PlaySound(1216802, "warning")
		end
	end
end

function mod:PolarizationGeneratorNegaApplied(args)
	if self:Me(args.destGUID) then
		self:Message(1216802, "cyan", L.polarization_soon:format(_G.DULL_RED_FONT_COLOR:WrapTextInColorCode(L.nega_polarization)))
		if myCharge ~= "red" then
			self:PlaySound(1216802, "warning")
		end
	end
end

function mod:PosiPolarizationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, _G.LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(L.posi_polarization))
		self:PlaySound(args.spellId, "info")
		myCharge = "blue"
	end
end

function mod:NegaPolarizationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, _G.DULL_RED_FONT_COLOR:WrapTextInColorCode(L.nega_polarization))
		self:PlaySound(args.spellId, "info")
		myCharge = "red"
	end
end

do
	local stacks = 0
	local scheduled = nil
	function mod:PolarizedCatastroBlastMessage()
		if stacks == 1 then
			self:Message(1219047, "red")
		else
			self:Message(1219047, "red", CL.stackyou:format(stacks, self:SpellName(1219047)))
		end
		self:PlaySound(1219047, "alarm") -- boom
		scheduled = nil
	end

	function mod:PolarizedCatastroBlastApplied(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer("PolarizedCatastroBlastMessage", 1)
			end
		end
	end
end
