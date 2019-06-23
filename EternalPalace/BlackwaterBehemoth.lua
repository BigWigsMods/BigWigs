--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackwater Behemoth", 2164, 2347)
if not mod then return end
mod:RegisterEnableMob(155103) -- Blackwater Behemoth
mod.engageId = 2289
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Local
--

local stage = 1
local intermissionTime = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		292127, -- Darkest Depths
		292205, -- Bioluminescent Cloud
		292133, -- Bioluminescence
		292307, -- Gaze from Below
		292138, -- Radiant Biomass
		{298428, "TANK"}, -- Feeding Frenzy
		292159, -- Toxic Spine
		292270, -- Shock Pulse
		{301494, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Piercing Barb
		301180, -- Slipstream
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "DarkestDepthsApplied", 292127)
	self:Death("PufferfishDeath", 150773) -- Shimmerskin Pufferfish
	self:Log("SPELL_AURA_APPLIED", "BioluminescenceApplied", 292133)
	self:Log("SPELL_AURA_APPLIED", "GazefromBelowApplied", 292307)

	self:Log("SPELL_AURA_APPLIED", "RadiantBiomass", 292138)
	self:Log("SPELL_AURA_APPLIED", "FeedingFrenzyApplied", 298428)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FeedingFrenzyApplied", 298428)
	self:Log("SPELL_CAST_START", "ToxicSpine", 292159)
	self:Log("SPELL_AURA_APPLIED", "ToxicSpineApplied", 292167)
	self:Log("SPELL_CAST_START", "ShockPulse", 292270)
	self:Log("SPELL_CAST_SUCCESS", "PiercingBarb", 292159)
	self:Log("SPELL_AURA_APPLIED", "PiercingBarbApplied", 292167)

	self:Log("SPELL_AURA_APPLIED", "SlipstreamApplied", 301180)
	self:Log("SPELL_CAST_START", "Cavitation", 292083)
	self:Log("SPELL_INTERRUPT", "Interupted", "*")
end

function mod:OnEngage()
	stage = 1

	self:Bar(292159, 8) -- Toxic Spine
	self:Bar(301494, 11) -- Piercing Barb
	self:Bar(292270, 23) -- Shock Pulse

	intermissionTime = GetTime() + 100
	self:Bar("stages", 100, CL.intermission, "achievement_boss_wolfeel")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 301428 then -- Slipstream / Intermission
		self:PlaySound("stages", "long")
		self:Message2("stages", "green", CL.intermission, false)

		self:StopBar(292159) -- Toxic Spine
		self:StopBar(301494) -- Piercing Barb
		self:StopBar(292270) -- Shock Pulse
		self:StopBar(CL.intermission) -- Intermission
	end
end

function mod:DarkestDepthsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:PufferfishDeath(args)
	self:Message2(292205, "green") -- Bioluminescent Cloud
	self:PlaySound(292205, "info")
	--self:CastBar(292205, 20) -- XXX Find out how long it lasts
end

function mod:BioluminescenceApplied(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "long")
	end
end

function mod:GazefromBelowApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:RadiantBiomass(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FeedingFrenzyApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 10 then
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:ToxicSpine(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	local timeToIntermission = intermissionTime - GetTime()
	if stage == 3 or timeToIntermission > 20 then
		self:Bar(args.spellId, 20)
	end
end

function mod:ToxicSpineApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(292159)
		self:PlaySound(292159, "alarm")
	end
end

function mod:ShockPulse(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	local timeToIntermission = intermissionTime - GetTime()
	if stage == 3 or timeToIntermission > 30 then
		self:Bar(args.spellId, 30)
	end
	self:CastBar(args.spellId, 5)
end

function mod:PiercingBarb(args)
	local timeToIntermission = intermissionTime - GetTime()
	if stage == 3 or timeToIntermission > 30 then
		self:Bar(args.spellId, 30)
	end
end

function mod:PiercingBarbApplied(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning", nil, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:Cavitation(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 32)
end

function mod:Interupted(args)
	if args.extraSpellId == 292083 then -- Cavitation // Stage 2/3
		stage = stage + 1
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:StopBar(CL.cast:format(args.extraSpellName))

		self:Bar(292159, 8) -- Toxic Spine
		self:Bar(301494, 11) -- Piercing Barb
		self:Bar(292270, 23) -- Shock Pulse

		if stage < 3 then -- Does not move again at stage 3
			intermissionTime = GetTime() + 100
			self:Bar("stages", 100, CL.intermission, "achievement_boss_wolfeel")
		end
	end
end

function mod:SlipstreamApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end
