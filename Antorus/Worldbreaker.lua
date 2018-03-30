
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gorothi Worldbreaker", 1712, 1992)
if not mod then return end
mod:RegisterEnableMob(122450) -- Garothi Worldbreaker
mod.engageId = 2076
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextApocalypseDriveWarning = 0
local annihilatorHaywired = nil
local decimationCasted = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cannon_ability = mod:SpellName(52541) -- Cannon Assault
	L.cannon_ability_desc = "Display Messages and Bars related to the 2 cannons on the Gorothi Worldbreaker's back."
	L.cannon_ability_icon = 57610 -- Cannon icon

	L.missileImpact = "Annihilation Impact"
	L.missileImpact_desc = "Show a timer for the Annihilation missiles landing."
	L.missileImpact_icon = 208426

	L.decimationImpact = "Decimation Impact"
	L.decimationImpact_desc = "Show a timer for the Decimation missiles landing."
	L.decimationImpact_icon = 170318
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{246220, "TANK", "SAY"}, -- Fel Bombardment
		240277, -- Apocalypse Drive
		244969, -- Eradication
		244106, -- Carnage
		"cannon_ability", -- Cannon Assault
		{244410, "SAY"}, -- Decimation
		"decimationImpact",
		244761, -- Annihilation
		"missileImpact",
		247044, -- Shrapnel
	},{
		[246220] = "general",
		[244410] = -15915, -- Decimator
		[244761] = -15917, -- Annihilator
		[247044] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_SUCCESS", "Annihilation", 244294) -- normal and empowered
	self:Log("SPELL_CAST_SUCCESS", "Decimation", 244399, 245294, 246919) -- normal, empowered, haywire (mythic)
	self:Log("SPELL_AURA_APPLIED", "DecimationApplied", 244410, 246919)

	self:Log("SPELL_AURA_APPLIED", "FelBombardment", 246220) -- Fel Bombardment pre-debuff
	self:Log("SPELL_AURA_REMOVED", "FelBombardmentRemoved", 246220) -- Fel Bombardment pre-debuff
	self:Log("SPELL_CAST_START", "ApocalypseDrive", 240277)
	self:Log("SPELL_CAST_SUCCESS", "ApocalypseDriveSuccess", 240277)
	self:Death("WeaponDeath", 122778, 122773) -- Interupts Apocalypse Drive, id: Annihilator, Decimator
	self:Log("SPELL_CAST_START", "Eradication", 244969)
	self:Log("SPELL_CAST_SUCCESS", "Carnage", 244106)

	--[[ Mythic ]] --
	self:Log("SPELL_AURA_APPLIED", "Haywire", 246897, 246965) -- Decimator Hayware, Annihilator Hayware
	self:Log("SPELL_CAST_START", "Shrapnel", 247044)
end

function mod:OnEngage()
	stage = 1
	annihilatorHaywired = nil
	decimationCasted = 0

	self:Bar("cannon_ability", 8, L.cannon_ability, L.cannon_ability_icon)
	self:Bar(246220, 9.4) -- Fel Bombardment

	nextApocalypseDriveWarning = self:Easy() and 62 or 67 -- happens at 60% (65% hc/my)
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextApocalypseDriveWarning then
		self:Message(240277, "cyan", "Info", CL.soon:format(self:SpellName(240277))) -- Apocalypse Drive
		if stage == 1 then
			nextApocalypseDriveWarning = self:Easy() and 22 or 37 -- happens at 20% (35% hc/my)
		else
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

do
	-- Blizzard didn't give us a cast event for the haywire Annihilator.
	-- It sill fires Cannon Chooser in USCS, so we wait for a bit and check if
	-- Decimation got cast and if not it must've been Annihilation!
	local function checkForDecimation(self)
		if GetTime()-decimationCasted > 1 then
			self:Annihilation()
		end
	end

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
		if spellId == 245124 and annihilatorHaywired then -- Cannon Chooser
			self:ScheduleTimer(checkForDecimation, 0.1, self)
		end
	end
end

function mod:Annihilation()
	self:Message(244761, "red", "Alert")
	self:CDBar("missileImpact", 6.2, L.missileImpact, L.missileImpact_icon)
	self:Bar(244761, (self:Mythic() or stage == 1) and 31.6 or 15.8) -- Annihilation
	if stage == 1 or self:Mythic() then
		self:Bar(244410, 15.8) -- Decimation
	end
end

do
	local isOnMe, scheduled = nil, nil

	local function warn(self)
		if not isOnMe then
			self:Message(244410, "yellow")
		end
		scheduled = nil
	end

	function mod:Decimation(args)
		self:Bar(244410, (self:Mythic() or stage == 1) and 31.6 or 15.8) -- Decimation
		self:CDBar("decimationImpact", args.spellId == 246919 and 7 or 10, L.decimationImpact, L.decimationImpact_icon) -- 246919 = haywire (mythic)
		if stage == 1 or self:Mythic() then
			self:Bar(244761, 15.8) -- Annihilation
		end
		decimationCasted = GetTime()
		isOnMe = nil
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.3, self)
		end
	end

	function mod:DecimationApplied(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:PlaySound(244410, "Warning")
			self:TargetMessage2(244410, "blue", args.destName)
			self:Say(244410)
			if args.spellId ~= 246919 then -- Haywire Decimation
				self:SayCountdown(244410, 5)
			end
		end
	end
end

function mod:FelBombardment(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 7)
		self:TargetBar(args.spellId, 7, args.destName)
		self:PlaySound(args.spellId, "Warning")
	else
		self:PlaySound(args.spellId, "Alarm", nil, args.destName) -- Different sound for when tanking/offtanking
	end
	self:TargetMessage2(args.spellId, "orange", args.destName)
	self:Bar(args.spellId, self:Mythic() and 15.8 or 20.7)
end

function mod:FelBombardmentRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:ApocalypseDrive(args)
	self:StopBar(L.cannon_ability)
	self:StopBar(244410) -- Decimation
	self:StopBar(244761) -- Annihilation
	self:StopBar(246220) -- Fel Bombardment

	self:Message(args.spellId, "red", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 20)
end

function mod:ApocalypseDriveSuccess(args)
	self:Message(args.spellId, "orange", "Alarm")
end

function mod:WeaponDeath(args)
	stage = stage + 1
	self:Message(240277, "green", "Info", CL.interrupted:format(self:SpellName(240277)))
	self:StopBar(CL.cast:format(self:SpellName(240277)))

	self:Bar(244969, 10) -- Eradication
	self:Bar(246220, 23.1) -- Fel Bombardment

	if args.mobId == 122778 then -- Annihilator death
		if stage == 2 then
			self:Bar(244410, 21.9) -- Decimation
		end
	elseif args.mobId == 122773 then -- Decimator death
		if stage == 2 then
			self:Bar(244761, 21.9) -- Annihilation
		end
	end
end

function mod:Eradication(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "orange", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 5.5)
end

function mod:Carnage(args)
	self:Message(args.spellId, "orange", "Alarm")
end

--[[ Mythic ]]--
function mod:Haywire(args)
	stage = stage + 1
	self:Message(240277, "green", "Long", CL.interrupted:format(self:SpellName(240277)))
	self:StopBar(CL.cast:format(self:SpellName(240277)))

	self:Bar(244969, 9.5) -- Eradication
	self:Bar("cannon_ability", 22, L.cannon_ability, L.cannon_ability_icon)
	self:Bar(246220, 23.4) -- Fel Bombardment

	if args.spellId == 246965 then
		annihilatorHaywired = true
	end
end

function mod:Shrapnel(args)
	self:CDBar(args.spellId, 4.5)
end
