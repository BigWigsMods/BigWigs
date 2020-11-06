if UnitFactionGroup("player") ~= "Horde" then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grong Horde", 2070, 2325)
if not mod then return end
mod:RegisterEnableMob(144637)
mod.engageId = 2263
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local addCount = 1
local tantrumCount = 1

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
		281936, -- Tantrum
		282082, -- Bestial Combo
		{285671, "TANK"}, -- Crushed
		{285875, "TANK"}, -- Rending Bite
		{289401, "SAY", "FLASH"}, -- Bestial Throw
		282179, -- Reverberating Slam
		285994, -- Ferocious Roar
		--[[ Flying Ape Wranglers  ]]--
		282215, -- Megatomic Seeker Missile
		283069, -- Megatomic Fire
		--[[ Apetaganizer 3000 ]]--
		282247, -- Apetagonizer 3000 Bomb
		282243, -- Apetagonize
		285659, -- Apetagonizer Core
		285660, -- Discharge Apetagonizer Core
	}, {
		[281936] = mod.displayName,
		[282215] = -18953, -- Flying Ape Wranglers
		[282247] = -18955, -- Apetaganizer 3000
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Grong ]]--
	self:Log("SPELL_CAST_START", "Tantrum", 281936)
	self:Log("SPELL_CAST_SUCCESS", "BestialCombo", 282082)
	self:Log("SPELL_AURA_APPLIED", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 285875)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 285875)
	self:Log("SPELL_CAST_SUCCESS", "BestialThrow", 289401)
	self:Log("SPELL_CAST_SUCCESS", "BestialThrowTarget", 289307)
	self:Log("SPELL_CAST_SUCCESS", "ReverberatingSlam", 282179)
	self:Log("SPELL_CAST_START", "FerociousRoar", 290574, 285994) -- Mythic, Others

	--[[ Flying Ape Wranglers  ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 283069) -- Megatomic Fire
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 283069) -- Megatomic Fire
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 283069)
	self:Log("SPELL_DAMAGE", "GroundDamage", 282215) -- Megatomic Seeker Missile
	self:Log("SPELL_MISSED", "GroundDamage", 282215)

	--[[ Apetaganizer 3000 ]]--
	self:Log("SPELL_CAST_SUCCESS", "Apetagonizer3000Bomb", 282247)
	self:Log("SPELL_CAST_START", "Apetagonize", 282243)
	self:Log("SPELL_AURA_APPLIED", "ApetagonizerCore", 285659)
	self:Log("SPELL_AURA_REMOVED", "ApetagonizerCoreRemoved", 285659)
	self:Log("SPELL_CAST_START", "DischargeApetagonizerCore", 285660)
end

function mod:OnEngage()
	addCount = 1
	tantrumCount = 1
	self:Bar(282215, 10.5) -- Megatomic Seeker Missile
	self:Bar(282179, 13.1) -- Reverberating Slam
	self:Bar(282247, 16.8, CL.count:format(self:Mythic() and CL.adds or CL.add, addCount)) -- Apetagonizer 3000 Bomb, Add
	self:Bar(282082, 22)	-- Bestial Combo
	if not self:Easy() then
		self:Bar(285994, 37.5) -- Ferocious Roar
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 282190 then -- Megatomic Seeker Missile
		self:Message(282215, "red")
		self:PlaySound(282215, "warning")
		self:CDBar(282215, 23)
	end
end

function mod:Tantrum(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, tantrumCount))
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, tantrumCount)) -- 1s + 4s Channel
	tantrumCount = tantrumCount + 1
end

function mod:BestialCombo(args)
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
	self:TargetMessage(289401, "purple", args.destName)
	self:PlaySound(289401, "alarm", nil, args.destName)
	if self:Me(args.destGUID) then
		self:Say(289401)
		self:Flash(289401)
	end
end

function mod:ReverberatingSlam(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 29)
end

function mod:FerociousRoar(args)
	self:Message(285994, "red")
	self:PlaySound(285994, "warning")
	self:Bar(285994, 36.5)
end

--function mod:MegatomicSeekerMissile(args)
--	self:TargetMessage(args.spellId, "orange", args.destName)
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

function mod:Apetagonizer3000Bomb(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(self:Mythic() and CL.adds or CL.add, addCount)))
	self:PlaySound(args.spellId, "long")
	addCount = addCount + 1
	self:Bar(args.spellId, self:Mythic() and 120 or 60.5, CL.count:format(self:Mythic() and CL.adds or CL.add, addCount))
end

do
	local prev = 0
	function mod:Apetagonize(args)
		local t = args.time
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ApetagonizerCore(args)
	self:TargetMessage(args.spellId, "green", args.destName, args.spellName)
	if self:Me(args.destGUID) then
		self:TargetBar(args.spellId, 20, args.destName)
	end
end

function mod:ApetagonizerCoreRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
	end
end

function mod:DischargeApetagonizerCore(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
end
