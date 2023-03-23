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

local heavyCudgelCount = 1
local devastatingSunderCount = 1
local flaringFirestormCount = 1
local zaqaliAideCount = 1
local magmaMysticCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.final_assault_soon = "Final Assault soon" -- hopefully there will be some spell/aura to use instead
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Warlord Kagni
		{401241, "TANK_HEALER"}, -- Molten Swing
		401258, -- Heavy Cudgel
		398938, -- Devastating Leap
		-- Ignara
		407024, -- Flaring Firestorm
		407017, -- Vigorous Gale
		-- Magma Mystic
		397383, -- Molten Havoc
		409271, -- Lava Flow
		-- Zaqali Aide
		404382,
		{401867, "SAY", "SAY_COUNTDOWN"}, -- Volcanic Shield
		{401108, "SAY", "SAY_COUNTDOWN"}, -- Phoenix Rush
		401401, -- Blazing Spear
	}, {
		[401241] = -26616, -- Warlord Kagni
		[407024] = -26602, -- Ignara
		[397383] = -26217, -- Magma Mystic
		[404382] = -26274, -- Zaqali Aide
	}
end

function mod:OnBossEnable()
	-- Warlord Kagni
	self:Log("SPELL_CAST_SUCCESS", "MoltenSwing", 401241)
	self:Log("SPELL_AURA_APPLIED", "MoltenSwingApplied", 401241)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenSwingApplied", 401241)
	self:Log("SPELL_CAST_START", "HeavyCudgel", 401258)
	self:Log("SPELL_CAST_SUCCESS", "DevastatingLeap", 398938)
	-- Ignara
	self:Log("SPELL_CAST_SUCCESS", "FlaringFirestorm", 407024)
	self:Log("SPELL_CAST_SUCCESS", "VigorousGale", 407017)
	-- Magma Mystic
	self:Log("SPELL_CAST_START", "MoltenHavoc", 397383)
	self:Log("SPELL_CAST_START", "LavaFlow", 409271)
	-- Zaqali Aide
	self:Log("SPELL_CAST_START", "ZaqaliAide", 404382)
	self:Log("SPELL_AURA_APPLIED", "VolcanicShieldApplied", 401867)
	self:Log("SPELL_AURA_REMOVED", "VolcanicShieldRemoved", 401867)
	self:Log("SPELL_CAST_START", "PhoenixRush", 401108)
	self:Log("SPELL_AURA_APPLIED", "PhoenixRushApplied", 401108)
	self:Log("SPELL_AURA_REMOVED", "PhoenixRushRemoved", 401108)
	self:Log("SPELL_CAST_SUCCESS", "BlazingSpear", 401401)
end

function mod:OnEngage()
	heavyCudgelCount = 1
	devastatingSunderCount = 1
	flaringFirestormCount = 1
	zaqaliAideCount = 1
	magmaMysticCount = 1

	-- self:Bar(401241, 30) -- Molten Swing
	-- self:Bar(401258, 30, CL.count:format(self:SpellName(401258), heavyCudgelCount)) -- Heavy Cudgel
	-- self:Bar(398938, 96, CL.count:format(self:SpellName(398938), devastatingSunderCount)) -- Devastating Leap
	-- self:Bar(407024, 30, CL.count:format(self:SpellName(407024), flaringFirestormCount)) -- Flaring Firestorm
	-- self:Bar(404382, 30, CL.count:format(self:SpellName(404382), zaqaliAideCount)) -- Zaqali Aide
	-- self:Bar(397383, 30, CL.count:format(self:SpellName(397383), magmaMysticCount)) -- Molten Havoc

	-- self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 43 then -- "Final Assault" at 40%
		self:Message("stages", "cyan", L.final_assault_soon, false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Warlord Kagni
function mod:MoltenSwing(args)
	-- self:Bar(args.spellId, 27)
end

function mod:MoltenSwingApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 2)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if amount > 2 and self:Tank() and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(args.spellId, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:HeavyCudgel(args)
	self:StopBar(CL.count:format(args.spellName, heavyCudgelCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, heavyCudgelCount))
	self:PlaySound(args.spellId, "alert")
	heavyCudgelCount = heavyCudgelCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, heavyCudgelCount))
end

function mod:DevastatingLeap(args)
	self:StopBar(CL.count:format(args.spellName, devastatingSunderCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, devastatingSunderCount))
	self:PlaySound(args.spellId, "alert")
	devastatingSunderCount = devastatingSunderCount + 1
	-- self:Bar(args.spellId, 96, CL.count:format(args.spellName, devastatingSunderCount))
end

-- Ignara
function mod:FlaringFirestorm(args)
	self:StopBar(CL.count:format(args.spellName, flaringFirestormCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flaringFirestormCount))
	self:PlaySound(args.spellId, "alert")
	flaringFirestormCount = flaringFirestormCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, flaringFirestormCount))
end

function mod:VigorousGale(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	-- self:Bar(args.spellId, 30)
end

-- Magma Mystic
function mod:MoltenHavoc(args)
	self:StopBar(CL.count:format(args.spellName, magmaMysticCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, magmaMysticCount))
	self:PlaySound(args.spellId, "info")
	magmaMysticCount = magmaMysticCount + 1
	-- self:Bar(args.spellId, 60, CL.count:format(args.spellName, magmaMysticCount))
end

function mod:LavaFlow(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alert") -- interrupt
		end
	end
	-- self:Bar(args.spellId, 30)
end

-- Zaqali Aide
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
