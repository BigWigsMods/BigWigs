--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Orgozoa", 2164, 2351)
if not mod then return end
mod:RegisterEnableMob(152128) -- Orgozoa
mod.engageId = 2303
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
		{298156, "TANK"}, -- Desensitizing Sting
		298103, -- Dribbling Ichor
		298242, -- Incubation Fluid
		{305048, "SAY"}, -- Arcing Current
		298465, -- Amniotic Splatter
		298548, -- Massive Incubator
		{295779, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Aqua Lance
		295822, -- Conductive Pulse
		296691, -- Powerful Stomp
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_SUCCESS", "DesensitizingSting", 298156)
	self:Log("SPELL_AURA_APPLIED", "DesensitizingStingApplied", 298156)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DesensitizingStingApplied", 298156)
	self:Log("SPELL_CAST_SUCCESS", "IncubationFluid", 298242)
	self:Log("SPELL_AURA_APPLIED", "IncubationFluidApplied", 298306)
	self:Log("SPELL_CAST_START", "ArcingCurrent", 305048)
	self:RegisterEvent("RAID_BOSS_WHISPER") -- Arcing Current

	-- Adds
	self:Log("SPELL_CAST_SUCCESS", "AmnioticSplatter", 298465)

	-- Stage 2
	self:Log("SPELL_CAST_START", "MassiveIncubator", 298548)
	self:Log("SPELL_INTERRUPT", "Interupted", "*")

	self:Log("SPELL_AURA_APPLIED", "AquaLance", 295779)
	self:Log("SPELL_AURA_REMOVED", "AquaLanceRemoved", 295779)
	self:Log("SPELL_CAST_START", "ConductivePulse", 295822)
	self:Log("SPELL_CAST_START", "PowerfulStomp", 296691)
end

function mod:OnEngage()
	stage = 1

	self:CDBar(298156, 3.5) -- Desensitizing Sting
	self:CDBar(298242, 17.5) -- Incubation Fluid
	self:CDBar(298103, 25) -- Dribbling Ichor
	self:CDBar(305048, 36) -- Arcing Current

	intermissionTime = GetTime() + 212
	self:Bar("stages", 212, CL.intermission, "achievement_boss_orgozoa")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 298077 then -- Dribbling Ichor
		self:Message2(298103, "orange")
		self:PlaySound(298103, "long")
		local timeToIntermission = intermissionTime - GetTime()
		if stage == 2 or timeToIntermission > 85 then
			self:CDBar(298103, 85)
		end
	elseif spellId == 298689 then -- Absorb Fluids
		self:PlaySound("stages", "long")
		self:Message2("stages", "green", CL.intermission, false)
	end
end

function mod:DesensitizingSting(args)
	local timeToIntermission = intermissionTime - GetTime()
	if stage == 2 or timeToIntermission > 6 then
		self:CDBar(args.spellId, 6) -- XXX 15.8 if he stars casting Dribbling Ichor
	end
end

function mod:DesensitizingStingApplied(args)
	local amount = args.amount or 1
	if amount % 2 == 0 or amount > 7 then -- 2, 4, 6, 8, 9
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		if self:Me(args.destGUID) or amount > 7 then -- Also play a sound to be ready for tank swap at 8+
			self:PlaySound(args.spellId, amount > 7 and "warning" or "alarm", nil, args.destName)
		end
	end
end

function mod:IncubationFluid(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	local timeToIntermission = intermissionTime - GetTime()
	if stage == 2 or timeToIntermission > 32 then
		self:CDBar(args.spellId, 32)
	end
end

function mod:IncubationFluidApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(298156)
		self:PlaySound(298156, "alarm")
	end
end

function mod:ArcingCurrent(args)
	self:Message2(args.spellId, "red")
	if self:Mythic() then
		-- Sound for everyone on mythic, but only the 1 target on non-Mythic
		self:PlaySound(args.spellId, "warning")
	end
	local timeToIntermission = intermissionTime - GetTime()
	if stage == 2 or timeToIntermission > 30 then
		self:CDBar(args.spellId, 30)
	end
end

function mod:RAID_BOSS_WHISPER(_, msg)
	if msg:find("298413", nil, true) then -- Arcing Current
		self:PersonalMessage(305048)
		if not self:Mythic() then
			self:PlaySound(305048, "warning")
			self:Say(305048)
		end
	end
end

do
	local prev = 0
	function mod:AmnioticSplatter(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "cyan")
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:MassiveIncubator(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 20)
end

function mod:Interupted(args)
	if args.extraSpellId == 298548 then -- Massive Incubator // Stage 2 start
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:StopBar(CL.cast:format(args.extraSpellName))

		self:CDBar(298156, 3.5) -- Desensitizing Sting
		self:CDBar(298242, 17.5) -- Incubation Fluid
		self:CDBar(298103, 25) -- Dribbling Ichor
		self:CDBar(305048, 36) -- Arcing Current
	end
end

function mod:AquaLance(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alert", nil, args.destName)
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:AquaLanceRemoved(args)
	if self:Me(args.spellId) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:ConductivePulse(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "red")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:PowerfulStomp(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 4.5)
end
