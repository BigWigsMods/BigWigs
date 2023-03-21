if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zaqali Invasion", 2569, 2524)
if not mod then return end
mod:RegisterEnableMob(199659, 202791) -- Warlord Kagni, Ignara
mod:SetEncounterID(2682)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local devastatingSunderCount = 1
local flaringFirestormCount = 1
local zaqaliAideCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage 1
		{401241, "TANK"}, -- Molten Swing
		{401258, "TANK"}, -- Heavy Cudgel
		397515, -- Devastating Sunder
		407024, -- Flaring Firestorm
		-- Stage 2
		404382, -- Zaqali Aide
		{401867, "SAY", "SAY_COUNTDOWN"}, -- Volcanic Shield
		{401108, "SAY", "SAY_COUNTDOWN"}, -- Phoenix Rush
		401401, -- Blazing Spear
		397383, -- Molten Gateway
		397403, -- Lava Flow
		397505, -- Volcanic Ground
		407017, -- Vigorous Gale
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "MoltenSwing", 401241)
	self:Log("SPELL_AURA_APPLIED", "MoltenSwingApplied", 401241)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenSwingApplied", 401241)
	self:Log("SPELL_CAST_START", "HeavyCudgel", 401258)
	self:Log("SPELL_CAST_SUCCESS", "DevastatingSunder", 397515)
	self:Log("SPELL_CAST_SUCCESS", "FlaringFirestorm", 407024)

	-- Stage 2
	self:Log("SPELL_CAST_START", "ZaqaliAide", 404382)
	self:Log("SPELL_AURA_APPLIED", "VolcanicShieldApplied", 401867)
	self:Log("SPELL_AURA_REMOVED", "VolcanicShieldRemoved", 401867)
	self:Log("SPELL_CAST_START", "PhoenixRush", 401108)
	self:Log("SPELL_AURA_APPLIED", "PhoenixRushApplied", 401108)
	self:Log("SPELL_AURA_REMOVED", "PhoenixRushRemoved", 401108)
	self:Log("SPELL_CAST_SUCCESS", "BlazingSpear", 401401)
	self:Log("SPELL_CAST_START", "MoltenGateway", 397383)
	self:Log("SPELL_CAST_START", "LavaFlow", 397403)
	self:Log("SPELL_CAST_SUCCESS", "VigorousGale", 407017)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 397505) -- Volcanic Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 397505)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 397505)
end

function mod:OnEngage()
	devastatingSunderCount = 1
	flaringFirestormCount = 1

	--self:Bar(397515, 30, CL.count:format(self:SpellName(397515), devastatingSunderCount)) -- Devastating Sunder
	--self:Bar(407024, 30, CL.count:format(self:SpellName(407024), flaringFirestormCount)) -- Flaring Firestorm

	-- Stage 2
	zaqaliAideCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MoltenSwing(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	self:Message(args.spellId, "purple")
	if self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "alert")
	end
	--self:CDBar(args.spellId, 17)
end

function mod:MoltenSwingApplied(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 2)
	if amount > 2 and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:HeavyCudgel(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 30)
end

function mod:DevastatingSunder(args)
	self:StopBar(CL.count:format(args.spellName, devastatingSunderCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, devastatingSunderCount))
	self:PlaySound(args.spellId, "alert")
	devastatingSunderCount = devastatingSunderCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, devastatingSunderCount))
end

function mod:FlaringFirestorm(args)
	self:StopBar(CL.count:format(args.spellName, flaringFirestormCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flaringFirestormCount))
	self:PlaySound(args.spellId, "alert")
	flaringFirestormCount = flaringFirestormCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, flaringFirestormCount))
end

function mod:ZaqaliAide(args)
	self:StopBar(CL.count:format(args.spellName, zaqaliAideCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, zaqaliAideCount))
	self:PlaySound(args.spellId, "alert")
	zaqaliAideCount = zaqaliAideCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, zaqaliAideCount))
end

function mod:VolcanicShieldApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId)
		self:YellCountdown(args.spellId, 6)
	end
end

function mod:VolcanicShieldRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
end

function mod:PhoenixRush(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 30)
end

function mod:PhoenixRushApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:PhoenixRushRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:BlazingSpear(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 30)
end

function mod:MoltenGateway(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 30)
end

function mod:LavaFlow(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 30)
end

function mod:VigorousGale(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 30)
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
