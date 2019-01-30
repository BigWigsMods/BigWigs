if UnitFactionGroup("player") ~= "Alliance" then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grong Alliance", 2070, 2340)
if not mod then return end
mod:RegisterEnableMob(144638)
mod.engageId = 2284
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local addCount = 1

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
		--[[ Grong ]]--
		282399, -- Death Knel
		286450, -- Necrotic Combo
		{285671, "TANK"}, -- Crushed
		{285875, "TANK"}, -- Rending Bite
		289401, -- Bestial Throw
		282543, -- Deathly Slam
		285994, -- Ferocious Roar
		--[[ Death Specter ]]--
		282471, -- Voodoo Blast
		286373, -- Chill of Death
		282526, -- Death Specter
		282533, -- Death Empowerment
		286434, -- Shadow Core
		286435, -- Discharge Shadow Core
	}, {
		[282399] = mod.displayName,
		[282471] = -18965, -- Death Specter
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Grong ]]--
	self:Log("SPELL_CAST_START", "DeathKnel", 282399)
	self:Log("SPELL_CAST_SUCCESS", "NecroticCombo", 286450)
	self:Log("SPELL_AURA_APPLIED", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 285875)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 285875)
	self:Log("SPELL_CAST_SUCCESS", "BestialThrow", 289401)
	self:Log("SPELL_CAST_SUCCESS", "BestialThrowTarget", 289307)
	self:Log("SPELL_CAST_SUCCESS", "DeathlySlam", 282543)
	self:Log("SPELL_CAST_START", "FerociousRoar", 285994)

	--[[ Death Specter ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 286373) -- Chill of Death
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 286373) -- Chill of Death
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 286373)
	self:Log("SPELL_DAMAGE", "GroundDamage", 282471) -- Voodoo Blast
	self:Log("SPELL_MISSED", "GroundDamage", 282471)

	self:Log("SPELL_CAST_SUCCESS", "DeathSpecter", 282526)
	self:Log("SPELL_CAST_START", "DeathEmpowerment", 282533)
	self:Log("SPELL_AURA_APPLIED", "ShadowCore", 286434)
	self:Log("SPELL_CAST_START", "DischargeShadowCore", 286435)
end

function mod:OnEngage()
	addCount = 1
	self:Bar(282471, 10.5) -- Voodoo Blast
	self:Bar(282543, 13.1) -- Deathly Slam
	self:Bar(282526, 16.8, CL.count:format(self:Mythic() and CL.adds or CL.add, addCount)) -- DeathSpecter, Add
	self:Bar(286450, 22)	-- Necrotic Combo
	self:Bar(285994, 37.5) -- Ferocious Roar
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 282467 then -- Voodoo Blast
		self:Message2(282471, "red")
		self:PlaySound(282471, "warning")
		self:CDBar(282471, 23)
	end
end

function mod:DeathKnel(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5) -- 1s + 4s Channel
end

function mod:NecroticCombo(args)
	self:Bar(args.spellId, 30.5)
end

function mod:CrushedApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:RendingBiteApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:BestialThrow(args)
	self:Bar(args.spellId, 30.5)
end

function mod:BestialThrowTarget(args)
	self:TargetMessage2(289401, "purple", args.destName)
	self:PlaySound(289401, "alarm", nil, args.destName)
end

function mod:DeathlySlam(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 29)
end

function mod:FerociousRoar(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 36.5)
end

--function mod:VoodooBlast(args)
--	self:TargetMessage2(args.spellId, "orange", args.destName)
--	self:PlaySound(args.spellId, "alarm")
--	if self:Me(args.destGUID) then
--		self:Say(args.spellId)
--	end
--	self:Bar(args.spellId, 23.1)
--end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 1.5 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:DeathSpecter(args)
	self:Message2(args.spellId, "yellow", CL.incoming:format(CL.count:format(CL.add, addCount)))
	self:PlaySound(args.spellId, "long")
	addCount = addCount + 1
	self:Bar(args.spellId, self:Mythic() and 120 or 60.5, CL.count:format(self:Mythic() and CL.adds or CL.add, addCount))
end

do
	local prev = 0
	function mod:DeathEmpowerment(args)
		local t = args.time
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ShadowCore(args)
	self:TargetMessage2(args.spellId, "green", args.destName, args.spellName)
end

function mod:DischargeShadowCore(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
end
