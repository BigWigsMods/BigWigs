if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vexie and the Geargrinders", 2769, 2639)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(3009)
mod:SetPrivateAuraSounds({
	459669, -- Spew Oil
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.plating_removed = "%d Protective Plating left!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: Fury Road
		466615, -- Protective Plating
		471403, -- Unrelenting CAR-nage
		459943, -- Call Bikers
			-- 459453, -- Blaze of Glory
			-- 460625, -- Burning Shrapnel
			-- 459994, -- Hot Wheels
		459678, -- Spew Oil
			459683, -- Oil Slick
		{468216, "SAY", "SAY_COUNTDOWN"}, -- Incendiary Fire
		459974, -- Bomb Voyage!
		465865, -- Tank Buster
			-- 468147,	-- Exhaust Fumes -- XXX Seperate timer for dps/healers?
		-- Stage Two: Pit Stop
		-- 460603, -- Mechanical Breakdown
		460116, -- Tune-Up
			-- 473636, -- High Maintenance
			-- 460153, -- Repair
	},{ -- Sections
		[466615] = CL.stage:format(1),
		[460116] = CL.stage:format(2),
	},{ -- Renames

	}
end

function mod:OnRegister()
	--self:SetSpellRename(999999, CL.renameMe) -- Spell (Rename)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED_DOSE", "ProtectivePlatingRemoved", 466615)
	self:Log("SPELL_CAST_START", "UnrelentingCARnage", 471403)
	self:Log("SPELL_CAST_START", "CallBikers", 459943)
	self:Log("SPELL_CAST_START", "SpewOil", 459671)
	self:Log("SPELL_AURA_APPLIED", "SpewOilApplied", 459678) -- DOT after getting hit
	self:Log("SPELL_CAST_SUCCESS", "IncendiaryFireSuccess", 468207)
	self:Log("SPELL_AURA_APPLIED", "IncendiaryFireApplied", 468216, 468486) -- Targetting debuff
    self:Log("SPELL_CAST_START", "BombVoyage", 459974)
	self:Log("SPELL_AURA_APPLIED", "BombVoyageApplied", 459978) -- DOT after getting hit
	self:Log("SPELL_CAST_START", "TankBuster", 459627)
	self:Log("SPELL_AURA_APPLIED", "TankBusterApplied", 465865)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankBusterApplied", 465865)
	self:Log("SPELL_AURA_APPLIED", "TuneUpApplied", 460116)
	self:Log("SPELL_AURA_REMOVED", "TuneUpRemoved", 460116)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 459683) -- Oil Slick
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 459683)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 459683)
end

function mod:OnEngage()
	self:SetStage(1)
	-- self:Bar(471403, 120) -- Unrelenting CAR-nage
	-- self:Bar(459943, 5) -- Call Bikers
	-- self:Bar(459678, 10) -- Spew Oil
	-- self:Bar(468216, 15) -- Incendiary Fire
	-- self:Bar(459974, 20) -- Bomb Voyage
	-- self:Bar(459627, 25) -- Tank Buster
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ProtectivePlatingRemoved(args)
	local platingsLeft = args.amount or 0
	if platingsLeft < 4 or platingsLeft % 2 == 0 then
		self:Message(args.spellId, "cyan", L.plating_removed:format(platingsLeft))
		if platingsLeft < 4 then
			self:PlaySound(args.spellId, "info") -- breaking soon
		end
	end
end

function mod:UnrelentingCARnage(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning") -- big damage inc
end

function mod:CallBikers(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- adds incoming
end

function mod:SpewOil(args)
	self:Message(459678, "yellow", CL.incoming:format(args.spellName))
	-- self:PlaySound(459678, "alert") -- Private aura for targeted players
	-- self:Bar(459678, 10)
end

function mod:SpewOilApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:IncendiaryFireSuccess(args)
	-- self:Bar(468216, 10)
end

function mod:IncendiaryFireApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(468216)
		self:Say(468216, nil, nil, "Incendiary Fire")
		local duration = args.spellId == 468216 and 6 or 4 -- XXX Check what's used, there's a second 4s debuff. expecting 6s.
		self:SayCountdown(468216, duration)
	end
end

function mod:BombVoyage(args)
	self:Message(args.spellId, "orange")
	-- self:Bar(args.spellId, 10)
end

function mod:BombVoyageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(459974)
		self:PlaySound(459974, "alarm")
	end
end

function mod:TankBuster()
	self:Message(465865, "purple")
	self:PlaySound(465865, "info")
	-- self:Bar(465865, 25)
end

function mod:TankBusterApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:TuneUpApplied(args)
	self:StopBar(471403) -- Unrelenting CAR-nage
	self:StopBar(459943) -- Call Bikers
	self:StopBar(459678) -- Spew Oil
	self:StopBar(468216) -- Incendiary Fire
	self:StopBar(459974) -- Bomb Voyage
	self:StopBar(459627) -- Tank Buster
	self:SetStage(2)

	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 45)
end

function mod:TuneUpRemoved(args) -- XXX Back to stage 1?
	self:StopBar(args.spellId)

	self:SetStage(1)
	-- self:Bar(471403, 120) -- Unrelenting CAR-nage
	-- self:Bar(459943, 5) -- Call Bikers
	-- self:Bar(459678, 10) -- Spew Oil
	-- self:Bar(468216, 15) -- Incendiary Fire
	-- self:Bar(459974, 20) -- Bomb Voyage
	-- self:Bar(459627, 25) -- Tank Buster
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
