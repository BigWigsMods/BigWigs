if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("King Rastakhan", 2070, 2335)
if not mod then return end
mod:RegisterEnableMob(145616)
mod.engageId = 2272
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage 1
		284831, -- Scorching Detonation
		284933, -- Plague of Toads
		285172, -- Greater Serpent Totem
		{284662, "SAY", "FLASH"}, -- Seal of Purification
		284686, -- Meteor Leap
		284730, -- Crushing Leap
		284781, -- Grievous Axe
		-- Stage 2
		{285349, "SAY"}, -- Plague of Fire
		285003, -- Zombie Dust Totem
		285402, -- Voodoo Doll
		{285213, "TANK_HEALER"}, -- Caress of Death
		283504, -- Suffering Spirits
		{288449, "SAY", "SAY_COUNTDOWN"}, -- Death's Door
		-- Stage 3
		287333, -- Inevitable End
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "ScorchingDetonationSuccess", 284831)
	self:Log("SPELL_CAST_START", "PlagueofToads", 284933)
	self:Log("SPELL_CAST_SUCCESS", "GreaterSerpentTotem", 285172)
	self:Log("SPELL_AURA_APPLIED", "SealofPurificationApplied", 284662)
	self:Log("SPELL_CAST_START", "MeteorLeap", 284686)
	self:Log("SPELL_CAST_SUCCESS", "CrushingLeap", 284730)
	self:Log("SPELL_CAST_START", "GrievousAxe", 284781)
	self:Log("SPELL_AURA_APPLIED", "GrievousAxeApplied", 284781)
	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "PlagueofFire", 285349)
	self:Log("SPELL_AURA_APPLIED", "PlagueofFireApplied", 285349)
	self:Log("SPELL_CAST_SUCCESS", "ZombieDustTotem", 285003)
	self:Log("SPELL_CAST_SUCCESS", "VoodooDoll", 285402)
	self:Log("SPELL_CAST_START", "CaressofDeath", 285213)
	self:Log("SPELL_CAST_START", "SufferingSpirits", 283504)
	self:Log("SPELL_CAST_START", "DeathsDoor", 288449)
	-- Stage 3
	self:Log("SPELL_CAST_START", "InevitableEnd", 287333)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ScorchingDetonationSuccess(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5)
end

function mod:PlagueofToads(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:GreaterSerpentTotem(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:SealofPurificationApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:MeteorLeap(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5)
end

function mod:CrushingLeap(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local warned = nil
	local function printTarget(self, name, guid)
		if warned ~= true then
			warned = true
			self:TargetMessage2(284781, "yellow", name)
			if self:Me(guid) then
				self:PlaySound(284781, "warning")
			end
		end
	end

	function mod:GrievousAxe(args)
		warned = nil
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
	end

	function mod:GrievousAxeApplied(args) -- Fallback
		if warned ~= true then
			warned = true
			self:TargetMessage2(args.spellId, "yellow", args.destName)
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "warning")
			end
		end
	end
end

function mod:PlagueofFire(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:PlagueofFireApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end

function mod:ZombieDustTotem(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:VoodooDoll(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:CaressofDeath(args)
	self:Message2(args.spellId, "pueple")
	self:PlaySound(args.spellId, "alarm")
end

function mod:SufferingSpirits(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 10) -- 2s cast, 8s channel
end

function mod:DeathsDoor(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:PlagueofFireApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alert")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:InevitableEnd(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 6)
end
