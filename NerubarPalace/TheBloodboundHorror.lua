if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Bloodbound Horror", 2657, 2611)
if not mod then return end
mod:RegisterEnableMob(214502) -- The Bloodbound Horror
mod:SetEncounterID(2917)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local gruesomeDisgorgeCount = 1
local spewingHemorrhageCount = 1
local goresplatterCount = 1
local crimsonRainCount = 1
local graspFromBeyondCount = 1
local bloodcurdleCount = 1

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
		443203, -- Crimson Rain
		{443042, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Grasp From Beyond
		445518, -- Black Blood
		438696, -- Black Sepsis
		-- Phase Two: The Unseeming
		451288, -- Black Bulwark
		-- {445016, "TANK"}, -- Spectral Slam
		-- 445174, -- Manifest Horror
		-- Mythic
		452237, -- Bloodcurdle
	},{
		[444363] = -29061, -- Phase One: The Black Blood
		[451288] = -29068, -- Phase Two: The Unseeming
		[452237] = "mythic",
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
	self:Log("SPELL_CAST_SUCCESS", "CrimsonRain", 443203)
	-- self:Log("SPELL_CAST_SUCCESS", "GraspFromBeyond", 443042)
	self:Log("SPELL_AURA_APPLIED", "GraspFromBeyondApplied", 443042)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 445518) -- Black Blood
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 445518)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 445518)
	self:Log("SPELL_CAST_SUCCESS", "BlackSepsis", 438696)

	-- Phase Two: The Unseeming
	self:Log("SPELL_CAST_START", "BlackBulwark", 451288)
	-- self:Log("SPELL_CAST_START", "SpectralSlam", 445016)
	-- self:Log("SPELL_CAST_START", "ManifestHorror", 445174) -- multiple? spammy?

	-- Mythic
	self:Log("SPELL_CAST_START", "Bloodcurdle", 452237)
	self:Log("SPELL_AURA_APPLIED", "BloodcurdleApplied", 452245)
	self:Log("SPELL_AURA_REMOVED", "BloodcurdleRemoved", 452245)
end

function mod:OnEngage()
	gruesomeDisgorgeCount = 1
	spewingHemorrhageCount = 1
	goresplatterCount = 1
	crimsonRainCount = 1
	graspFromBeyondCount = 1

	self:Bar(443203, 11, CL.count:format(self:SpellName(443203), crimsonRainCount)) -- Crimson Rain
	self:Bar(444363, 16, CL.count:format(self:SpellName(444363), gruesomeDisgorgeCount)) -- Gruesome Disgorge
	self:Bar(443042, 22, CL.count:format(self:SpellName(443042), graspFromBeyondCount)) -- Grasp From Beyond
	self:Bar(445936, 32, CL.count:format(self:SpellName(445936), spewingHemorrhageCount)) -- Spewing Hemorrhage
	self:Bar(442530, 120, CL.count:format(self:SpellName(442530), goresplatterCount)) -- Goresplatter
	-- if self:Mythic() then
	-- 	self:Bar(452237, 60, CL.count:format(self:SpellName(452237), bloodcurdleCount)) -- Bloodcurdle
	-- end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Phase One: The Black Blood
function mod:GruesomeDisgorge(args)
	self:StopBar(CL.count:format(args.spellName, gruesomeDisgorgeCount))
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	gruesomeDisgorgeCount = gruesomeDisgorgeCount + 1
	self:Bar(args.spellId, gruesomeDisgorgeCount % 2 == 1 and 77 or 51, CL.count:format(args.spellName, gruesomeDisgorgeCount))
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
	self:StopBar(CL.count:format(args.spellName, spewingHemorrhageCount))
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	spewingHemorrhageCount = spewingHemorrhageCount + 1
	self:Bar(args.spellId, spewingHemorrhageCount % 2 == 1 and 79 or 49, CL.count:format(args.spellName, spewingHemorrhageCount))
end

function mod:InternalHemorrhageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:Goresplatter(args)
	self:StopBar(CL.count:format(args.spellName, goresplatterCount))
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	goresplatterCount = goresplatterCount + 1
	self:Bar(args.spellId, 120, CL.count:format(args.spellName, goresplatterCount))
end

function mod:CrimsonRain(args)
	self:StopBar(CL.count:format(args.spellName, crimsonRainCount))
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	crimsonRainCount = crimsonRainCount + 1
	self:Bar(args.spellId, 128, CL.count:format(args.spellName, crimsonRainCount))
end

do
	local prev = 0
	function mod:GraspFromBeyondApplied(args)
		if args.time-prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, graspFromBeyondCount))
			self:Message(args.spellId, "yellow")
			graspFromBeyondCount = graspFromBeyondCount + 1
			self:Bar(args.spellId, graspFromBeyondCount % 4 == 1 and 44 or 28, CL.count:format(args.spellName, graspFromBeyondCount))
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.grasp_from_beyond_say, nil, "Tentacles")
			self:SayCountdown(args.spellId, 12)
			self:PlaySound(args.spellId, "warning")
		end
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

-- function mod:SpectralSlam(args)
-- 	self:Message(args.spellId, "purple")
-- 	self:PlaySound(args.spellId, "alert")
-- 	--self:Bar(args.spellId, 42)
-- end

-- function mod:ManifestHorror(args)
-- 	self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
-- 	self:PlaySound(args.spellId, "alert")
-- 	--self:Bar(args.spellId, 42)
-- end

-- Mythic

function mod:Bloodcurdle(args)
	self:StopBar(CL.count:format(args.spellName, bloodcurdleCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, bloodcurdleCount)))
	bloodcurdleCount = bloodcurdleCount + 1
	-- self:Bar(args.spellId, bloodcurdleCount % 2 == 0 and 49 or 79, CL.count:format(args.spellName, bloodcurdleCount))
end

function mod:BloodcurdleApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(452237)
		self:PlaySound(452237, "alarm") -- spread
		self:TargetBar(452237, 5, args.destName)
	end
end

function mod:BloodcurdleRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(452237, args.destName)
	end
end
