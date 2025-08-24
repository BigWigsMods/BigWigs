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

local invokeTerrorsCount = 1
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
	L.gruesome_disgorge_debuff = "Phase Shift"
	L.grasp_from_beyond = "Tentacles"
	L.grasp_from_beyond_say = "Tentacles"
	L.bloodcurdle = "Spreads"
	L.bloodcurdle_on_you = "Spread" -- Singular of Spread
	L.goresplatter = "Run Away"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		444497, -- Invoke Terrors
		444363, -- Gruesome Disgorge
		443612, -- Gruesome Disgorge (Debuff)
		445570, -- Unseeming Blight
		{445936, "CASTBAR"}, -- Spewing Hemorrhage
		459444, -- Internal Hemorrhage
		{442530, "CASTBAR"}, -- Goresplatter
		443203, -- Crimson Rain
		{443042, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Grasp From Beyond
		445518, -- Black Blood
		438696, -- Black Sepsis

		-- The Unseeming
		451288, -- Black Bulwark
		-- {445016, "TANK"}, -- Spectral Slam
		-- 445174, -- Manifest Horror

		-- Mythic
		452237, -- Bloodcurdle
	},{
		[451288] = 462306, -- The Unseeming
		[452237] = "mythic",
	},{
		[444497] = CL.adds_spawning, -- Invoke Terrors (Adds Spawning)
		[444363] = CL.frontal_cone, -- Gruesome Disgorge (Frontal Cone)
		[443612] = L.gruesome_disgorge_debuff, -- Gruesome Disgorge (Phase Shift)
		[445936] = CL.beams, -- Spewing Hemorrhage (Beams)
		[442530] = L.goresplatter, -- Goresplatter (Run Away)
		[443042] = L.grasp_from_beyond, -- Grasp From Beyond (Tentacles)
		[452237] = L.bloodcurdle, -- Bloodcurdle (Spreads)
	}
end

function mod:OnRegister()
	self:SetSpellRename(444363, CL.frontal_cone) -- Gruesome Disgorge (Frontal Cone)
	self:SetSpellRename(445936, CL.beams) -- Spewing Hemorrhage (Beams)
	self:SetSpellRename(442530, L.goresplatter) -- Goresplatter (Run Away)
	self:SetSpellRename(452237, L.bloodcurdle) -- Bloodcurdle (Spreads)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "InvokeTerrors", 444497)
	-- Phase One: The Black Blood
	self:Log("SPELL_CAST_START", "GruesomeDisgorge", 444363)
	self:Log("SPELL_AURA_APPLIED", "BanefulShiftApplied", 443612)
	self:Log("SPELL_AURA_APPLIED", "UnseemingBlightApplied", 445570)
	self:Log("SPELL_AURA_REMOVED", "UnseemingBlightRemoved", 445570)
	self:Log("SPELL_CAST_START", "SpewingHemorrhage", 445936)
	self:Log("SPELL_AURA_APPLIED", "InternalHemorrhageApplied", 459444) -- Stacks?
	self:Log("SPELL_CAST_START", "Goresplatter", 442530)
	self:Log("SPELL_AURA_APPLIED", "CrimsonRainApplied", 443305)
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
	invokeTerrorsCount = 1
	gruesomeDisgorgeCount = 1
	spewingHemorrhageCount = 1
	goresplatterCount = 1
	crimsonRainCount = 1
	graspFromBeyondCount = 1

	self:Bar(444497, self:Mythic() and 3 or 5, CL.count:format(CL.adds_spawning, invokeTerrorsCount)) -- Invoke Terrors
	self:Bar(443203, 11, CL.count:format(self:SpellName(443203), crimsonRainCount)) -- Crimson Rain
	self:Bar(444363, self:Mythic() and 14 or 16, CL.count:format(CL.frontal_cone, gruesomeDisgorgeCount)) -- Gruesome Disgorge
	self:Bar(443042, self:Mythic() and 19 or 22, CL.count:format(L.grasp_from_beyond, graspFromBeyondCount)) -- Grasp From Beyond
	if not self:Easy() then
		self:Bar(445936, 32, CL.count:format(CL.beams, spewingHemorrhageCount)) -- Spewing Hemorrhage
	end
	self:Bar(442530, 120, CL.count:format(L.goresplatter, goresplatterCount)) -- Goresplatter
	if self:Mythic() then
		self:Bar(452237, 9, CL.count:format(L.bloodcurdle, bloodcurdleCount)) -- Bloodcurdle
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:InvokeTerrors(args)
	self:StopBar(CL.count:format(CL.adds_spawning, invokeTerrorsCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds_spawning, invokeTerrorsCount))
	self:PlaySound(args.spellId, "info") -- adds
	invokeTerrorsCount = invokeTerrorsCount + 1
	local cd = invokeTerrorsCount % 2 == 0 and 51 or 77
	if self:Mythic() then
		cd = invokeTerrorsCount % 2 == 0 and 59 or 69
	end
	self:Bar(args.spellId, cd, CL.count:format(CL.adds_spawning, invokeTerrorsCount))
end

-- Phase One: The Black Blood
function mod:GruesomeDisgorge(args)
	self:StopBar(CL.count:format(CL.frontal_cone, gruesomeDisgorgeCount))
	self:Message(args.spellId, "purple", CL.count:format(CL.frontal_cone, gruesomeDisgorgeCount))
	self:PlaySound(args.spellId, "alert")
	gruesomeDisgorgeCount = gruesomeDisgorgeCount + 1
	local cd = gruesomeDisgorgeCount % 2 == 0 and 51 or 77
	if self:Mythic() then
		cd = gruesomeDisgorgeCount % 2 == 0 and 59 or 69
	end
	self:Bar(args.spellId, cd, CL.count:format(CL.frontal_cone, gruesomeDisgorgeCount))
end

function mod:BanefulShiftApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:TargetBar(args.spellId, 40, args.destName)
	end
end

function mod:UnseemingBlightApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:UnseemingBlightRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		-- self:PlaySound(args.spellId, "info")
	end
end

function mod:SpewingHemorrhage(args)
	self:StopBar(CL.count:format(CL.beams, spewingHemorrhageCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.beams, spewingHemorrhageCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 26, CL.count:format(CL.beams, spewingHemorrhageCount))
	spewingHemorrhageCount = spewingHemorrhageCount + 1
	local cd = spewingHemorrhageCount % 2 == 9 and 49 or 79
	if self:Mythic() then
		cd = spewingHemorrhageCount % 2 == 0 and 59 or 69
	end
	self:Bar(args.spellId, cd, CL.count:format(CL.beams, spewingHemorrhageCount))
end

function mod:InternalHemorrhageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:Goresplatter(args)
	self:StopBar(CL.count:format(L.goresplatter, goresplatterCount))
	self:Message(args.spellId, "red", CL.casting:format(L.goresplatter))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 8, CL.count:format(L.goresplatter, goresplatterCount))
	goresplatterCount = goresplatterCount + 1
	self:Bar(args.spellId, 128, CL.count:format(L.goresplatter, goresplatterCount))
end

do
	local prev = 0
	function mod:CrimsonRainApplied(args)
		if args.time-prev > 10 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, crimsonRainCount))
			crimsonRainCount = crimsonRainCount + 1
			self:Bar(443203, crimsonRainCount % 4 == 1 and 38 or 30, CL.count:format(args.spellName, crimsonRainCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(443203)
			self:PlaySound(443203, "alert")
		end
	end
end

do
	local prev = 0
	function mod:GraspFromBeyondApplied(args)
		if args.time-prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(L.grasp_from_beyond, graspFromBeyondCount))
			self:Message(args.spellId, "yellow", CL.count:format(L.grasp_from_beyond, graspFromBeyondCount))
			graspFromBeyondCount = graspFromBeyondCount + 1
			local cd = graspFromBeyondCount % 4 == 1 and 44 or 28
			if self:Mythic() then
				cd = graspFromBeyondCount % 4 == 1 and 41 or graspFromBeyondCount % 4 == 3 and 31 or 28
			elseif self:Easy() then
				cd = (graspFromBeyondCount - 1) % 6 == 0 and 47 or graspFromBeyondCount % 3 == 1 and 21 or 15
			end
			self:Bar(args.spellId, cd, CL.count:format(L.grasp_from_beyond, graspFromBeyondCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.grasp_from_beyond)
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
	self:StopBar(CL.count:format(L.bloodcurdle, bloodcurdleCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.bloodcurdle, bloodcurdleCount)))
	bloodcurdleCount = bloodcurdleCount + 1
	local cd = bloodcurdleCount % 4 == 1 and 37 or bloodcurdleCount % 2 == 0 and 32 or 27
	self:Bar(args.spellId, cd, CL.count:format(L.bloodcurdle, bloodcurdleCount))
end

function mod:BloodcurdleApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(452237)
		self:PlaySound(452237, "alarm") -- spread
		self:TargetBar(452237, 5, args.destName, L.bloodcurdle_on_you)
	end
end

function mod:BloodcurdleRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(L.bloodcurdle_on_you, args.destName)
	end
end
