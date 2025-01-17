if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sprocketmonger Lockenstock", 2769, 2653)
if not mod then return end
mod:RegisterEnableMob(230583) -- XXX confirm
mod:SetEncounterID(3013)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local betaLaunchCount = 1

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
		-- "stages",
		-- Stage One: Assembly Required
		473276, -- Activate Inventions!
			-- XXX nameplate cds for weaponry? probably just spammed
			-- Goblin Inventions XXX key this for conveyor belt messages?
				-- 1216414, -- Blazing Beam
				-- 1216525, -- Rocket Barrage
				-- 1215858, -- Mega Magnetize
			-- Empowered Inventions
				-- 1216674, -- Void Laser (Fire Turret -> Void Turret)
				-- 1216699, -- Void Hell (Rocket Cannon -> Void Cannon)
		1217083, -- Foot-Blasters
			-- Unstable Explosion -- XXX count mines?
			1218342, -- Unstable Shrapnel
		1218418, -- Wire Transfer
		1216509, -- Screw Up "SAY"
			-- Screwed!
		465232, -- Sonic Ba-Boom
		471308, -- Firecracker Trap
		1214878, -- Pyro Party Pack
		{465917, "TANK"}, -- Gravi-Gunk

		-- Stage Two: Research and Destruction
		466765, -- Beta Launch
		466860, -- Bleeding Edge
			1218319, -- Voidsplosion
	},{
		[473276] = -30425, -- Stage 1
		[466765] = -30427, -- Stage 2
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "ActivateInventions", 473276)
	self:Log("SPELL_CAST_SUCCESS", "FootBlasters", 1217083)
	self:Log("SPELL_AURA_APPLIED", "UnstableShrapnelApplied", 1218342)
	self:Log("SPELL_AURA_APPLIED", "GraviGunkApplied", 465917)
	self:Log("SPELL_CAST_START", "PyroPartyPack", 1214872)
	self:Log("SPELL_AURA_APPLIED", "PyroPartyPackApplied", 1214878)
	self:Log("SPELL_AURA_REMOVED", "PyroPartyPackRemoved", 1214878)
	self:Log("SPELL_CAST_START", "ScrewUp", 1216508)
	self:Log("SPELL_AURA_APPLIED", "ScrewUpApplied", 1216509)
	self:Log("SPELL_CAST_START", "SonicBaBoom", 465232)
	self:Log("SPELL_CAST_SUCCESS", "FirecrackerTrap", 471308)
	self:Log("SPELL_CAST_START", "WireTransfer", 1218418)
	-- Stage 2
	self:Log("SPELL_CAST_START", "BetaLaunch", 466765)
	self:Log("SPELL_AURA_APPLIED", "BleedingEdgeApplied", 466860)
	self:Log("SPELL_AURA_REMOVED", "BleedingEdgeRemoved", 466860)
	self:Log("SPELL_CAST_SUCCESS", "Voidsplosion", 1218319)

	-- self:Log("SPELL_AURA_APPLIED", "GroundDamage", 466235) -- Wire Transfer
end

function mod:OnEngage()
	betaLaunchCount = 1
	self:SetStage(1)

	-- self:Bar(473276, 10) -- Activate Inventions!
	-- self:Bar(1217083, 20) -- Foot-Blasters
	-- self:Bar(1216509, 30) -- Screw Up
	-- self:Bar(465232, 40) -- Sonic Ba-Boom
	-- self:Bar(1218418, 50) -- Wire Transfer
	-- self:Bar(466765, 110, CL.count:format(args.spellName, betaLaunchCount)) -- Beta Launch
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1

function mod:ActivateInventions(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm") -- dodge?
	-- self:Bar(args.spellId, 30)
end

function mod:FootBlasters(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 30)
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
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- not great being the same as taunt?
	end
	-- self:Bar(args.spellId, 30)
end

function mod:PyroPartyPackRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:ScrewUp(args)
	self:Message(1216509, "yellow")
	-- self:Bar(1216509, 30)
end

function mod:ScrewUpApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		-- self:Say(args.spellId, nil, nil, "Screw Up")
	end
end

function mod:SonicBaBoom(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert") -- healer
	-- self:Bar(args.spellId, 30)
end

function mod:FirecrackerTrap(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm") -- dodge
	-- self:Bar(args.spellId, 30)
end

function mod:WireTransfer(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm") -- dodge
	-- self:Bar(args.spellId, 30)
end

-- Stage 2

function mod:BetaLaunch(args)
	-- self:StopBar(CL.count:format(args.spellName, betaLaunchCount)) -- Beta Launch
	-- self:StopBar(473276) -- Activate Inventions!
	-- self:StopBar(1217083) -- Foot-Blasters
	-- self:StopBar(1216509) -- Screw Up
	-- self:StopBar(465232) -- Sonic Ba-Boom
	-- self:StopBar(1218418) -- Wire Transfer

	self:SetStage(2)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, betaLaunchCount))
	self:PlaySound(args.spellId, "long")
	-- self:CastBar(args.spellId, 2, CL.knockback)
	betaLaunchCount = betaLaunchCount + 1

	-- self:Bar(1218319, 7) -- Voidsplosion
end

function mod:BleedingEdgeApplied(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 20, CL.over:format(args.spellName))
end

function mod:Voidsplosion(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- healer
	-- self:Bar(args.spellId, 5) -- Voidsplosion
end

function mod:BleedingEdgeRemoved(args)
	-- self:StopBar(CL.over:format(args.spellName))
	-- self:StopBar(1218319) -- Voidsplosion

	self:SetStage(1)
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long")

	-- self:Bar(473276, 10) -- Activate Inventions!
	-- self:Bar(1217083, 20) -- Foot-Blasters
	-- self:Bar(1216509, 30) -- Screw Up
	-- self:Bar(465232, 40) -- Sonic Ba-Boom
	-- self:Bar(1218418, 50) -- Wire Transfer
	-- self:Bar(466765, 110, CL.count:format(self:SpellName(466765), betaLaunchCount)) -- Beta Launch
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
