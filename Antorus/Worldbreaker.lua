
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gorothi Worldbreaker", nil, 1992, 1712)
if not mod then return end
mod:RegisterEnableMob(122450) -- Garothi Worldbreaker
mod.engageId = 2076
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextApocalypseDriveWarning = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cannon_ability = mod:SpellName(52541) -- Cannon Assault
	L.cannon_ability_desc = "Display Messages and Bars related to the 2 cannons on the Gorothi Worldbreaker's back."
	L.cannon_ability_icon = 57610 -- Cannon icon

	L.missileImpact = mod:SpellName(94829) -- Missile Impact
	L.missileImpact_desc = "Show a timer for the Annihilation missiles landing."
	L.missileImpact_icon = 208426
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
		244761, -- Annihilation
		"missileImpact",
	},{
		[246220] = "general",
		[244410] = -15915, -- Decimator
		[244761] = -15917, -- Annihilator
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Annihilation", 244294) -- normal and empowered
	self:Log("SPELL_CAST_SUCCESS", "Decimation", 244399, 245294) -- normal, empowered
	self:Log("SPELL_AURA_APPLIED", "DecimationApplied", 244410)

	self:Log("SPELL_AURA_APPLIED", "FelBombardment", 246220) -- Fel Bombardment pre-debuff
	self:Log("SPELL_AURA_REMOVED", "FelBombardmentRemoved", 246220) -- Fel Bombardment pre-debuff
	self:Log("SPELL_CAST_START", "ApocalypseDrive", 240277)
	self:Log("SPELL_CAST_SUCCESS", "ApocalypseDriveSuccess", 240277)
	self:Death("WeaponDeath", 122778, 122773) -- Interupts Apocalypse Drive, id: Annihilator, Decimator
	self:Log("SPELL_CAST_START", "Eradication", 244969)
	self:Log("SPELL_CAST_SUCCESS", "Carnage", 244106)

	--[[ Mythic ]] --
	self:Log("SPELL_AURA_APPLIED", "Haywire", 246897, 246965) -- Decimator Hayware, Annihilator Hayware
end

function mod:OnEngage()
	stage = 1

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
		self:Message(240277, "Neutral", "Info", CL.soon:format(self:SpellName(240277))) -- Apocalypse Drive
		if stage == 1 then
			nextApocalypseDriveWarning = self:Easy() and 22 or 37 -- happens at 20% (35% hc/my)
		else
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

function mod:Annihilation(args)
	self:Message(244761, "Important", "Alert")
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
			self:Message(244410, "Attention")
		end
		scheduled = nil
	end

	function mod:Decimation(args)
		self:Bar(244410, (self:Mythic() or stage == 1) and 31.6 or 15.8) -- Decimation
		if stage == 1 or self:Mythic() then
			self:Bar(244761, 15.8) -- Annihilation
		end
		isOnMe = nil
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.3, self)
		end
	end

	function mod:DecimationApplied(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Message(args.spellId, "Personal", "Warning", CL.you:format(args.spellName))
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
	end
end

function mod:FelBombardment(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", self:Me(args.destGUID) and "Warning" or "Alarm", nil, nil, true) -- Different sound for when tanking/offtanking
	self:Bar(args.spellId, self:Mythic() and 15.8 or 20.7)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 7)
		self:TargetBar(args.spellId, 7, args.destName)
	end
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

	self:Message(args.spellId, "Important", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 20)
end

function mod:ApocalypseDriveSuccess(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:WeaponDeath(args)
	stage = stage + 1
	self:Message(240277, "Positive", "Info", CL.interrupted:format(self:SpellName(240277)))
	self:StopBar(CL.cast:format(self:SpellName(240277)))

	self:Bar(244969, 10.5) -- Eradication
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
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 5.5)
end

function mod:Carnage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

--[[ Mythic ]]--
function mod:Haywire()
	stage = stage + 1
	self:Message(240277, "Positive", "Long", CL.interrupted:format(self:SpellName(240277)))
	self:StopBar(CL.cast:format(self:SpellName(240277)))

	self:Bar(244969, 4.1) -- Eradication
	self:Bar("cannon_ability", 19.8, L.cannon_ability, L.cannon_ability_icon)
	self:Bar(246220, 21.1) -- Fel Bombardment
end
