if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sun King's Salvation", 2296, 2422)
if not mod then return end
mod:RegisterEnableMob(165805, 165652, 168973) -- Shade of Kael'thas, Kael'thas, High Torturer Darithos
mod.engageId = 2402
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		323402, -- Reflection of Guilt
		{326455, "TANK"}, -- Fiery Strike
		326456, -- Burning Remnants
		325877, -- Ember Blast
		329518, -- Blazing Surge
		328579, -- Smoldering Remnants
		{328889, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Greater Castigation
		{325440, "TANK"}, -- Vanquishing Strike
		{325442, "TANK"}, -- Vanquished
		325506, -- Concussive Smash
		326586, -- Crimson Torment
		333145, -- Return to Stone
		333002, -- Vulgar Brand
		325665, -- Soul Infusion
		{326078, "HEALER"}, -- Infuser's Boon
	},{
		[323402] = -21966, -- Shade of Kael'thas
		[328889] = -22089, -- High Torturer Darithos
		[325440] = -21951, -- Ministers of Vice
		[326078] = -22231, -- Infusing Essences
	}
end

function mod:OnBossEnable()
	-- Shade of Kael'thas
	self:Log("SPELL_AURA_APPLIED", "ReflectionofGuiltApplied", 323402)
	self:Log("SPELL_CAST_START", "FieryStrike", 326455)
	self:Log("SPELL_AURA_APPLIED", "BurningRemnantsApplied", 332295)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningRemnantsApplied", 332295)
	self:Log("SPELL_CAST_START", "EmberBlast", 325877)
	self:Log("SPELL_CAST_START", "BlazingSurge", 329518, 329509) -- XXX Check which is used

	-- High Torturer Darithos
	self:Log("SPELL_AURA_APPLIED", "GreaterCastigationApplied", 328889)
	self:Log("SPELL_AURA_REMOVED", "GreaterCastigationRemoved", 328889)

	-- Ministers of Vice
	self:Log("SPELL_CAST_START", "VanquishingStrike", 326455)
	self:Log("SPELL_AURA_APPLIED", "VanquishedApplied", 332295)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VanquishedApplied", 332295)
	self:Log("SPELL_CAST_START", "ConcussiveSmash", 325506)
	self:Log("SPELL_AURA_APPLIED", "CrimsonTormentApplied", 326586)
	self:Log("SPELL_CAST_START", "ReturntoStone", 333145)
	self:Log("SPELL_CAST_START", "VulgarBrand", 333002)
	self:Log("SPELL_CAST_SUCCESS", "SoulInfusion", 325665)

	self:Log("SPELL_AURA_APPLIED", "InfusersBoonApplied", 326078)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 328579) -- Smoldering Remnants
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 328579)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 328579)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Shade of Kael'thas
function mod:ReflectionofGuiltApplied(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:FieryStrike(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

function mod:BurningRemnantsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then -- 2+
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:EmberBlast(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 5)
	--self:Bar(args.spellId, 20)
end

function mod:BlazingSurge(args)
	self:Message2(329518, "yellow")
	self:PlaySound(329518, "alert")
	--self:Bar(args.spellId, 20)
end

-- High Torturer Darithos
do
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:GreaterCastigationApplied(args)
		proxList[#proxList+1] = args.destName
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 3)
			self:OpenProximity(args.spellId, 6)
		end
		if #playerList == 1 then
				self:PlaySound(args.spellId, "alarm")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)

		if not isOnMe then
			self:OpenProximity(args.spellId, 6, proxList)
		end
	end

	function mod:GreaterCastigationRemoved(args)
		tDeleteItem(proxList, args.destName)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:CancelSayCountdown(args.spellId)
			self:CloseProximity(args.spellId)
		end

		if not isOnMe then
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 6, proxList)
			end
		end
	end
end

-- Ministers of Vice
function mod:VanquishingStrike(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

function mod:VanquishedApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then -- 2+
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ConcussiveSmash(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 20)
end

function mod:CrimsonTormentApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ReturntoStone(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CastBar(args.spellId, 7) -- 1s cast, 6s debuff
end

function mod:VulgarBrand(args)
	local _, ready = self:Interrupter(args.sourceGUID)
	self:Message2(args.spellId, "red")
	if ready then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:SoulInfusion(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:InfusersBoonApplied(args)
	self:TargetMessage2(args.spellId, "green", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "long")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
