if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Bloodbound Horror", 2657, 2611)
if not mod then return end
mod:RegisterEnableMob(214502) -- The Bloodbound Horror XXX Confirm on PTR
mod:SetEncounterID(2917)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.grasp_from_beyond_say = "Tentacles"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Phase One: The Black Blood
		444363, -- Gruesome Disgorge
		443612, -- Baneful Shift
		445570, -- Unseeming Blight
		445936, -- Spewing Hemorrhage
		459444, -- Internal Hemorrhage
		442530, -- Goresplatter
		443305, -- Residual Membrane
		{443042, "SAY", "SAY_COUNTDOWN"}, -- Grasp From Beyond
		445518, -- Black Blood
		438696, -- Black Sepsis
		-- Phase Two: The Unseeming
		451288, -- Black Bulwark
		{445016, "TANK"}, -- Spectral Slam
		-- 445174, -- Manifest Horror
	},{
		[444363] = -29061, -- Phase One: The Black Blood
		[451288] = -29068, -- Phase Two: The Unseeming
	}
end

function mod:OnBossEnable()
	-- Phase One: The Black Blood
	self:Log("SPELL_CAST_START", "GruesomeDisgorge", 444363)
	self:Log("SPELL_AURA_APPLIED", "BanefulShiftApplied", 443612)
	self:Log("SPELL_AURA_APPLIED", "UnseemingBlightApplied", 445570)
	self:Log("SPELL_AURA_REMOVED", "UnseemingBlightRemoved", 445570)
	self:Log("SPELL_CAST_START", "SpewingHemorrhage", 445936)
	self:Log("SPELL_AURA_APPLIED", "InternalHemorrhageApplied", 459444) -- Stacks?
	self:Log("SPELL_CAST_START", "Goresplatter", 442530)
	self:Log("SPELL_CAST_SUCCESS", "ResidualMembrane", 443305)
	self:Log("SPELL_CAST_SUCCESS", "GraspFromBeyond", 443042)
	self:Log("SPELL_AURA_APPLIED", "GraspFromBeyondApplied", 443042)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 445518) -- Black Blood
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 445518)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 445518)
	self:Log("SPELL_CAST_SUCCESS", "BlackSepsis", 438696)

	-- Phase Two: The Unseeming
	self:Log("SPELL_CAST_START", "BlackBulwark", 451288)
	self:Log("SPELL_CAST_START", "SpectralSlam", 445016)
	-- self:Log("SPELL_CAST_START", "ManifestHorror", 445174) -- multiple? spammy?
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Phase One: The Black Blood
function mod:GruesomeDisgorge(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:BanefulShiftApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:UnseemingBlightApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:UnseemingBlightRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:SpewingHemorrhage(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:InternalHemorrhageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:Goresplatter(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 42)
end

function mod:ResidualMembrane(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:GraspFromBeyond(args)
	self:Message(args.spellId, "yellow")
	--self:Bar(args.spellId, 42)
end

function mod:GraspFromBeyondApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, L.grasp_from_beyond_say, nil, "Tentacles")
		self:SayCountdown(args.spellId, 12)
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:BlackSepsis(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

-- Phase Two: The Unseeming
function mod:BlackBulwark(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SpectralSlam(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

-- function mod:ManifestHorror(args)
-- 	self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
-- 	self:PlaySound(args.spellId, "alert")
-- 	--self:Bar(args.spellId, 42)
-- end
