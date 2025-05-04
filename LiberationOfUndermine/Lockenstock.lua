
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

local numMinesExploded = 0
local myCharge = nil

local timersLFR = {
	[1218418] = { 2.0, 46.0, 53.0, 0 }, -- Wire Transfer
	[465232] = { 8.0, 33.0, 35.0, 35.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 23.1, 34.0, 30.1, 0 }, -- Pyro Party Pack
}
local timersNormal = {
	[1218418] = { 2.0, 39.0, 60.0, 0 }, -- Wire Transfer
	[1216509] = { 49.0, 31.0, 31.0, 0 }, -- Screw Up
	[465232] = { 8.0, 28.0, 27.0, 32.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 23.1, 34.0, 30.1, 0 }, -- Pyro Party Pack
}
local timersHeroic = {
	[1217231] = { 12.0, 62.0, 0 }, -- Foot-Blasters
	[1218418] = { 0.0, 41.0, 56.0, 0 }, -- Wire Transfer
	[1216509] = { 49.0, 33.0, 32.0, 0 }, -- Screw Up
	[465232]  = { 6.0, 28.0, 29.0, 30.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 23.0, 34.0, 30.0, 0 }, -- Pyro Party Pack
}
local timersMythic = {
	[1217231] = { 12.0, 34.0, 30.0, 0 }, -- Foot-Blasters
	[1218418] = { 0.1, 41.9, 59.0, 0 }, -- Wire Transfer
	[1216509] = { 20.0, 34.0, 33.0, 0 }, -- Screw Up
	[465232]  = { 9.0, 25.0, 27.0, 27.0, 21.0, 0 }, -- Sonic Ba-Boom
	[1214878] = { 22.6, 46.0, 46.0, 0 }, -- Pyro Party Pack
	[1216802] = { 4.0, 67.0, 46.0, 0 }, -- Polarization Generator
}
local timers = mod:Mythic() and timersMythic or mod:Normal() and timersNormal or mod:LFR() and timersLFR or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.foot_blasters = "Mines"
	L.unstable_shrapnel = "Mine Soaked"
	L.screw_up = "Drills"
	L.screw_up_single = "Drill" -- Singular of Drills
	L.sonic_ba_boom = "Raid Damage"
	L.polarization_generator = "Colors"
	L.polarization_soon = "Color Soon: %s"
	L.polarization_soon_change = "Color SWITCH Soon: %s"
	L.posi_polarization = _G.BLUE_GEM
	L.nega_polarization = _G.RED_GEM

	L.activate_inventions = "Activating: %s"
	L.blazing_beam = "Beams"
	L.rocket_barrage = "Rockets"
	L.mega_magnetize = "Magnets"
	L.jumbo_void_beam = "Big Beams"
	L.void_barrage = "Balls"
	L.everything = "Everything"

	L.under_you_comment = "Under You" -- Implies this setting is for the damage from the ground effect under you
end

local inventions

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{468791, "CASTBAR"}, -- Gigadeath

		-- Mythic
		1216802, -- Polarization Generator
		1216911, -- Posi-Polarization
		1216934, -- Nega-Polarization
		1219047, -- Polarized Catastro-Blast
		1216706, -- Void Barrage

		-- Stage One: Assembly Required
		473276, -- Activate Inventions!
		1221320, -- Activate Inventions! (Under You)
		1217231, -- Foot-Blasters
			1216406, -- Unstable Explosion
			1218342, -- Unstable Shrapnel
		1218418, -- Wire Transfer
		466235, -- Wire Transfer (Under You)
		{1216509, "SAY", "ME_ONLY_EMPHASIZE"}, -- Screw Up
		465232, -- Sonic Ba-Boom
		{1214878, "TANK_HEALER"}, -- Pyro Party Pack
		{465917, "TANK"}, -- Gravi-Gunk

		-- Stage Two: Research and Destruction
		{466765, "CASTBAR", "EMPHASIZE"}, -- Beta Launch
		1218319, -- Voidsplosion
	},{
		[1216802] = "mythic",
		[473276] = -30425, -- Stage 1
		[466765] = -30427, -- Stage 2
	},{
		[1216802] = L.polarization_generator,
		[1217231] = L.foot_blasters,
		[1216509] = L.screw_up,
		[1221320] = L.under_you_comment,
		[466235] = L.under_you_comment,
		[465232] = L.sonic_ba_boom,
		[1214878] = CL.bomb.."/"..CL.explosion,
		[1216911] = L.posi_polarization,
		[1216934] = L.nega_polarization,
	}
end

function mod:OnRegister()
	self:SetSpellRename(1217231, L.foot_blasters) -- Foot-Blasters (Mines)
	self:SetSpellRename(1216509, L.screw_up) -- Screw Up (Drills)
	self:SetSpellRename(465232, L.sonic_ba_boom) -- Sonic Ba-Boom (Raid Damage)
	self:SetSpellRename(466765, CL.knockback) -- Beta Launch (Knockback)
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "ActivateInventions", 473276)
	self:Log("SPELL_CAST_START", "FootBlasters", 1217231)
	self:Log("SPELL_AURA_APPLIED", "UnstableExplosionApplied", 1216406)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnstableExplosionApplied", 1216406)
	self:Log("SPELL_AURA_APPLIED", "UnstableShrapnelApplied", 1218342)
	self:Log("SPELL_AURA_APPLIED", "GraviGunkApplied", 465917)
	self:Log("SPELL_CAST_START", "PyroPartyPack", 1214872)
	self:Log("SPELL_AURA_APPLIED", "PyroPartyPackApplied", 1214878)
	self:Log("SPELL_AURA_REMOVED", "PyroPartyPackRemoved", 1214878)
	self:Log("SPELL_CAST_SUCCESS", "ScrewUp", 1216508)
	self:Log("SPELL_AURA_APPLIED", "ScrewUpApplied", 1216509)
	self:Log("SPELL_CAST_START", "SonicBaBoom", 465232)
	self:Log("SPELL_CAST_START", "WireTransfer", 1218418)
	-- Stage 2
	self:Log("SPELL_CAST_START", "BetaLaunch", 466765)
	self:Log("SPELL_CAST_SUCCESS", "BetaLaunchSuccess", 466765)
	self:Log("SPELL_CAST_SUCCESS", "BleedingEdge", 466860)
	self:Log("SPELL_AURA_APPLIED", "VoidsplosionApplied", 1218319)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidsplosionApplied", 1218319)
	self:Log("SPELL_AURA_APPLIED", "UpgradedBloodtechApplied", 1218344)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UpgradedBloodtechApplied", 1218344)
	-- self:Log("SPELL_AURA_REMOVED", "BleedingRemoved", 1218318) -- XXX Alternate stage 1 event
	self:Log("SPELL_CAST_START", "Gigadeath", 468791)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 466235, 1221320) -- Wire Transfer, Activate Inventions

	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "PolarizationGenerator", 1217355)
	self:Log("SPELL_AURA_APPLIED", "PolarizationGeneratorPosiApplied", 1217357)
	self:Log("SPELL_AURA_APPLIED", "PolarizationGeneratorNegaApplied", 1217358)
	self:Log("SPELL_AURA_APPLIED", "PosiPolarizationApplied", 1216911)
	self:Log("SPELL_AURA_APPLIED", "NegaPolarizationApplied", 1216934)
	self:Log("SPELL_DAMAGE", "PolarizedCatastroBlast", 1219047)
	self:Log("SPELL_DAMAGE", "VoidBarrageHit", 1216706)
	self:Log("SPELL_MISSED", "VoidBarrageHit", 1216706)

	timers = self:Mythic() and timersMythic or self:Normal() and timersNormal or self:LFR() and timersLFR or timersHeroic
	if self:Mythic() then
		inventions = {
			{ L.blazing_beam,  CL.plus:format(L.blazing_beam, L.rocket_barrage), L.everything },
			{ L.jumbo_void_beam, CL.plus:format(L.jumbo_void_beam, L.rocket_barrage), L.everything },
			{ L.void_barrage, CL.plus:format(L.void_barrage, L.mega_magnetize), L.everything },
		}
	else
		inventions = {
			{ L.blazing_beam, L.rocket_barrage, L.mega_magnetize },
			{ L.jumbo_void_beam, CL.plus:format(L.jumbo_void_beam, L.rocket_barrage), CL.plus:format(L.jumbo_void_beam, L.mega_magnetize) },
			{ L.void_barrage, CL.plus:format(L.void_barrage, L.mega_magnetize), L.everything },
		}
	end
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

	numMinesExploded = 0
	myCharge = nil

	-- self:Bar(1218418, timers[1218418][1], CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer (casted immediately)
	if self:Mythic() then
		self:Bar(1216802, timers[1216802][1], CL.count:format(L.polarization_generator, polarizationGeneratorCount))
	end
	self:Bar(465232, timers[465232][1], CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)) -- Sonic Ba-Boom
	if not self:Easy() then
		self:Bar(1217231, timers[1217231][1], CL.count:format(L.foot_blasters, footBlasterCount)) -- Foot-Blasters
	end
	if self:Healer() then -- until bomb explodes
		self:Bar(1214878, timers[1214878][1] + 7.5, CL.count:format(CL.explosion, pyroPartyPackCount)) -- Pyro Party Pack
	else
		self:Bar(1214878, timers[1214878][1], CL.count:format(CL.bomb, pyroPartyPackCount)) -- Pyro Party Pack
	end
	if not self:LFR() then
		self:Bar(1216509, timers[1216509][1], CL.count:format(L.screw_up, screwUpCount)) -- Screw Up
	end
	self:Bar(473276, 30.0 + 4.0, CL.count:format(inventions[1][1], activateInventionsCount)) -- Activate Inventions! (bar to when the inventions cast)
	self:Bar(466765, 121.6, CL.count:format(CL.knockback, betaLaunchCount)) -- Beta Launch
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1

function mod:ActivateInventions(args)
	-- self:StopBar(CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.activate_inventions:format(inventions[betaLaunchCount][activateInventionsCount]), activateInventionsCount))
	activateInventionsCount = activateInventionsCount + 1
	if activateInventionsCount < 4 then -- 3 per
		self:ScheduleTimer("Bar", 4.0, args.spellId, 30, CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount))
	end
	self:PlaySound(args.spellId, "long")
end

function mod:FootBlasters(args)
	numMinesExploded = 0
	local msg = CL.count:format(L.foot_blasters, footBlasterCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	footBlasterCount = footBlasterCount + 1
	self:Bar(args.spellId, timers[args.spellId][footBlasterCount], CL.count:format(L.foot_blasters, footBlasterCount))
	self:PlaySound(args.spellId, "alert")
end

do
	local soaker = nil
	local soakTime = 0
	local prev = 0

	function mod:UnstableExplosionApplied(args)
		local t = args.time
		if t - soakTime > 1 and t - prev > 1 then
			prev = t
			self:Message(args.spellId, "red") -- , CL.count:format(args.spellName, 4 - numMinesExploded))
			self:PlaySound(args.spellId, "alarm")
		end
	end

	function mod:UnstableShrapnelApplied(args)
		numMinesExploded = numMinesExploded + 1
		soaker = args.destName
		soakTime = args.time
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "blue", CL.count:format(args.spellName, numMinesExploded))
			self:PlaySound(args.spellId, "warning")
		else
			local targetMsg = CL.other:format(args.spellName, self:ColorName(soaker))
			self:Message(args.spellId, "orange", CL.count:format(targetMsg, numMinesExploded))
		end
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
	local bombDuration = 6
	local msg = CL.count:format(CL.bomb, pyroPartyPackCount)
	self:StopBar(msg)
	self:TargetMessage(args.spellId, "purple", args.destName, msg)
	if self:Healer() then
		self:Bar(args.spellId, {bombDuration, (timers[args.spellId][pyroPartyPackCount] or bombDuration)}, CL.count:format(CL.explosion, pyroPartyPackCount)) -- Pyro Party Pack
	else
		self:TargetBar(args.spellId, bombDuration, args.destName, CL.bomb)
	end
	pyroPartyPackCount = pyroPartyPackCount + 1
	local cd = timers[args.spellId][pyroPartyPackCount]
	if self:Healer() and cd and cd > 0 then -- until bomb explodes
		self:Bar(args.spellId, cd + bombDuration, CL.count:format(CL.explosion, pyroPartyPackCount)) -- Pyro Party Pack
	else
		self:Bar(args.spellId, cd, CL.count:format(CL.bomb, pyroPartyPackCount))
	end
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- not great being the same as taunt?
	end
end

function mod:PyroPartyPackRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

do
	local playerList = {}
	function mod:ScrewUp()
		self:StopBar(CL.count:format(L.screw_up, screwUpCount))
		screwUpCount = screwUpCount + 1
		self:Bar(1216509, timers[1216509][screwUpCount], CL.count:format(L.screw_up, screwUpCount))
		playerList = {}
	end

	function mod:ScrewUpApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, CL.count:format(L.screw_up, screwUpCount-1))
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.screw_up_single, true, "Drill") -- Keep the message short
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:SonicBaBoom(args)
	local msg = CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)
	self:StopBar(msg)
	self:Message(args.spellId, "yellow", CL.casting:format(msg))
	sonicBaBoomCount = sonicBaBoomCount + 1
	self:Bar(args.spellId, timers[args.spellId][sonicBaBoomCount], CL.count:format(L.sonic_ba_boom, sonicBaBoomCount))
	self:PlaySound(args.spellId, "alert") -- healer
end

function mod:WireTransfer(args)
	local msg = CL.count:format(args.spellName, wireTransferCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	wireTransferCount = wireTransferCount + 1
	self:Bar(args.spellId, timers[args.spellId][wireTransferCount], CL.count:format(args.spellName, wireTransferCount))
	self:PlaySound(args.spellId, "alarm")
end

-- Stage 2

function mod:BetaLaunch(args)
	voidsplosionCount = 1

	self:StopBar(CL.count:format(CL.stage:format(2), betaLaunchCount)) -- Beta Launch
	self:StopBar(CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer
	self:StopBar(CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)) -- Sonic Ba-Boom
	self:StopBar(CL.count:format(L.foot_blasters, footBlasterCount)) -- Foot-Blasters
	self:StopBar(CL.count:format(CL.explosion, pyroPartyPackCount)) -- Pyro Party Pack (Healer Explosion)
	self:StopBar(CL.count:format(CL.bomb, pyroPartyPackCount)) -- Pyro Party Pack (Tank Bomb)
	-- self:StopBar(CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount)) -- Activate Inventions!
	self:StopBar(CL.count:format(L.screw_up, screwUpCount)) -- Screw Up
	self:StopBar(CL.count:format(L.polarization_generator, polarizationGeneratorCount)) -- Polarization Generator

	self:Bar(1218319, 6.3, CL.count:format(self:SpellName(1218319), voidsplosionCount)) -- Voidsplosion
	self:CastBar(args.spellId, 4, CL.knockback)
	self:Message(args.spellId, "red", CL.knockback)
	self:PlaySound(args.spellId, "warning")
end

function mod:BetaLaunchSuccess(args)
	self:SetStage(2)
	if betaLaunchCount == 1 then
		self:Message("stages", "cyan", CL.stage:format(2), false)
	else
		self:Message("stages", "cyan", CL.count:format(CL.stage:format(2), betaLaunchCount), false)
	end
	betaLaunchCount = betaLaunchCount + 1
	self:PlaySound("stages", "long")
end

function mod:BleedingEdge(args)
	self:Bar("stages", self:Easy() and 10 or 20, CL.stage:format(1), args.spellId)
	if self:Mythic() then
		self:Bar(1216802, timers[1216802][1] + 20, CL.count:format(L.polarization_generator, 1)) -- Polarization Generator
	end
end

do
	local prev = 0
	function mod:VoidsplosionApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			local msg = CL.count:format(args.spellName, voidsplosionCount)
			self:StopBar(msg)
			self:Message(args.spellId, "orange", msg)
			voidsplosionCount = voidsplosionCount + 1
			if voidsplosionCount < (self:Easy() and 3 or 5) then
				self:Bar(args.spellId, 5, CL.count:format(args.spellName, voidsplosionCount)) -- Voidsplosion
			end
			self:PlaySound(args.spellId, "alert") -- healer
		end
	end
end

function mod:UpgradedBloodtechApplied(args)
	if self:GetStage() == 1 then
		local _, class = UnitClass("player")
		local printString = class ..": "
		for k, v in next, args do
			printString = printString..k..":"..tostring(v)..", "
		end
		local _, _, diff = GetInstanceInfo()
		printString = printString.."diff:"..tostring(diff)
		self:Error("BigWigs Error: "..printString)
		return
	end
	self:SetStage(1)

	activateInventionsCount = 1
	footBlasterCount = 1
	pyroPartyPackCount = 1
	screwUpCount = 1
	sonicBaBoomCount = 1
	wireTransferCount = 1
	polarizationGeneratorCount = 1

	-- self:Bar(1218418, timers[1218418][1], CL.count:format(self:SpellName(1218418), wireTransferCount)) -- Wire Transfer (casted immediately)
	if self:Mythic() then
		self:Bar(1216802, {timers[1216802][1], timers[1216802][1] + 20}, CL.count:format(L.polarization_generator, polarizationGeneratorCount)) -- Polarization Generator
	end
	self:Bar(465232, timers[465232][1], CL.count:format(L.sonic_ba_boom, sonicBaBoomCount)) -- Sonic Ba-Boom
	if not self:Easy() then
		self:Bar(1217231, timers[1217231][1], CL.count:format(L.foot_blasters, footBlasterCount)) -- Foot-Blasters
	end
	if self:Healer() then -- until bomb explodes
		self:Bar(1214878, timers[1214878][1] + 7.5, CL.count:format(CL.explosion, pyroPartyPackCount)) -- Pyro Party Pack
	else
		self:Bar(1214878, timers[1214878][1], CL.count:format(CL.bomb, pyroPartyPackCount)) -- Pyro Party Pack
	end
	if not self:LFR() then
		self:Bar(1216509, timers[1216509][1], CL.count:format(L.screw_up, screwUpCount)) -- Screw Up
	end
	self:Bar(473276, 30.0, CL.count:format(inventions[betaLaunchCount][activateInventionsCount], activateInventionsCount)) -- Activate Inventions!
	if betaLaunchCount < 3 then
		self:Bar(466765, self:Mythic() and 121.7 or 120.3, CL.count:format(CL.knockback, betaLaunchCount)) -- Beta Launch
	elseif betaLaunchCount == 3 then
		self:Bar(468791, self:Mythic() and 121.7 or 120.3) -- Gigadeath
	end

	self:Message("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long")
end

function mod:Gigadeath(args)
	self:Message(args.spellId, "red")
	self:CastBar(args.spellId, 4)
	self:PlaySound(args.spellId, "alarm") -- enrage
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

-- Mythic

function mod:PolarizationGenerator(args)
	self:StopBar(CL.count:format(L.polarization_generator, polarizationGeneratorCount))
	polarizationGeneratorCount = polarizationGeneratorCount + 1
	self:Bar(1216802, timers[1216802][polarizationGeneratorCount], CL.count:format(L.polarization_generator, polarizationGeneratorCount))
end

function mod:PolarizationGeneratorPosiApplied(args)
	if self:Me(args.destGUID) then
		if myCharge == "blue" then
			self:Message(1216802, "cyan", L.polarization_soon:format(_G.LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(L.posi_polarization)))
		else
			self:Message(1216802, "cyan", L.polarization_soon_change:format(_G.LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(L.posi_polarization)))
			self:PlaySound(1216802, "warning")
		end
	end
end

function mod:PolarizationGeneratorNegaApplied(args)
	if self:Me(args.destGUID) then
		if myCharge == "red" then
			self:Message(1216802, "cyan", L.polarization_soon:format(_G.DULL_RED_FONT_COLOR:WrapTextInColorCode(L.nega_polarization)))
		else
			self:Message(1216802, "cyan", L.polarization_soon_change:format(_G.DULL_RED_FONT_COLOR:WrapTextInColorCode(L.nega_polarization)))
			self:PlaySound(1216802, "warning")
		end
	end
end

function mod:PosiPolarizationApplied(args)
	if self:Me(args.destGUID) then
		myCharge = "blue"
		self:PersonalMessage(args.spellId, nil, _G.LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(L.posi_polarization))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:NegaPolarizationApplied(args)
	if self:Me(args.destGUID) then
		myCharge = "red"
		self:PersonalMessage(args.spellId, nil, _G.DULL_RED_FONT_COLOR:WrapTextInColorCode(L.nega_polarization))
		self:PlaySound(args.spellId, "info")
	end
end

do
	local prev = 0
	function mod:PolarizedCatastroBlast(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm") -- boom
		end
	end
end

function mod:VoidBarrageHit(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning")
end
