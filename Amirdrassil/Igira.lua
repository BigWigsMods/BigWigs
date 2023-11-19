--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Igira the Cruel", 2549, 2554)
if not mod then return end
mod:RegisterEnableMob(200926)
mod:SetEncounterID(2709)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local blisteringSpearCount = 1
local twistingBladeCount = 1
local markedForTormentCount = 1

local stance = nil
local umbralDestructionCount = 1
local smashingVisceraCount = 1
local heartStopperCount = 1

--------------------------------------------------------------------------------
-- Timers
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.blistering_spear = "Spears"
	L.blistering_spear_single = "Spear"
	L.blistering_torment = "Chain"
	L.twisting_blade = "Blades"
	L.marked_for_torment = "Torment"
	L.umbral_destruction = "Soak"
	L.heart_stopper = "Heal Absorbs"
	L.heart_stopper_single = "Heal Absorb"
end

--------------------------------------------------------------------------------
-- Initialization
--

local blisteringSpearMarker = mod:AddMarkerOption(false, "player", 1, 414888, 1, 2, 3, 4, 5, 6) -- Blistering Spear
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		{414340, "TANK"}, -- Drenched Blades
		{414888, "SAY"}, -- Blistering Spear
		blisteringSpearMarker,
		414770, -- Blistering Torment
		416996, -- Twisting Blade

		{422776, "CASTBAR"}, -- Marked for Torment
		414367, -- Gathering Torment
		419048, -- Ruinous End

		416048, -- Umbral Destruction
		424456, -- Smashing Viscera
		415623, -- Heart Stopper
		426056, -- Vital Rupture
	}, {
		[422776] = 422776,
	}, {
		[414888] = L.blistering_spear, -- Blistering Spear (Spears)
		[414770] = L.blistering_torment, -- Blistering Torment (Chain)
		[416996] = L.twisting_blade, -- Twisting Blade (Blades)
		[422776] = L.marked_for_torment, -- Marked for Torment (Torment)
		[416048] = L.umbral_destruction, -- Umbral Destruction (Soak)
		[424456] = CL.leap, -- Smashing Viscera (Leap)
		[415623] = L.heart_stopper, -- Heart Stopper (Heal Absorbs)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "DrenchedBlades", 414340)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrenchedBlades", 414340)
	self:Log("SPELL_CAST_START", "BlisteringSpear", 414425)
	self:Log("SPELL_AURA_APPLIED", "BlisteringSpearApplied", 414888)
	self:Log("SPELL_AURA_REMOVED", "BlisteringSpearRemoved", 414888)
	self:Log("SPELL_AURA_APPLIED", "BlisteringTorment", 414770)
	self:Log("SPELL_CAST_START", "TwistingBlade", 416996)

	self:Log("SPELL_CAST_START", "MarkedForTorment", 422776)
	self:Log("SPELL_AURA_APPLIED", "MarkedForTormentApplied", 422961)
	self:Log("SPELL_AURA_REMOVED", "MarkedForTormentRemoved", 422961)
	self:Log("SPELL_AURA_APPLIED", "GatheringTormentApplied", 414367)
	self:Log("SPELL_CAST_START", "RuinousEnd", 419048)
	self:Log("SPELL_CAST_SUCCESS", "BerserkCast", 301495)

	self:Log("SPELL_CAST_START", "UmbralDestruction", 416048)
	self:Log("SPELL_CAST_START", "SmashingViscera", 418531)
	self:Log("SPELL_AURA_APPLIED", "HeartStopperApplied", 415623)
	self:Log("SPELL_AURA_APPLIED", "VitalRuptureApplied", 426056)
end

function mod:OnEngage()
	self:SetStage(1)
	blisteringSpearCount = 1
	twistingBladeCount = 1
	markedForTormentCount = 1

	stance = nil
	umbralDestructionCount = 1
	smashingVisceraCount = 1
	heartStopperCount = 1

	-- Started later after Marked For Torment
	-- if self:Mythic() then
	-- 	self:Berserk(430, 0)
	-- else
	-- 	self:Berserk(600, 0)
	-- end

	self:Bar(414888, self:Mythic() and 4.5 or 11, CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
	self:Bar(416996, self:Mythic() and 15.5 or 4.9, CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
	self:Bar(422776, 46, CL.count:format(L.marked_for_torment, markedForTormentCount)) -- Marked for Torment
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BerserkCast(args)
	self:Message("berserk", "red", CL.custom_end:format(args.sourceName, args.spellName), 301495)
	self:PlaySound("berserk", "alarm")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 415020 then -- Sword Stance
		stance = spellId
		self:Message("stages", "cyan", CL.soon:format(CL.leap), 424456) -- Smashing Viscera
		self:PlaySound("stages", "info")
		self:Bar(424456, self:Easy() and 24 or 19, CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera

	elseif spellId == 415090 then -- Axe Stance
		stance = spellId
		self:Message("stages", "cyan", CL.soon:format(L.umbral_destruction), 416048) -- Umbral Destruction
		self:PlaySound("stages", "info")
		self:Bar(416048, self:Easy() and 24 or 19, CL.count:format(L.umbral_destruction, umbralDestructionCount)) -- Umbral Destruction

	elseif spellId == 415094 then -- Knife Stance
		stance = spellId
		self:Message("stages", "cyan", CL.soon:format(L.heart_stopper), 415623) -- Heart Stopper
		self:PlaySound("stages", "info")
		self:Bar(415623, self:Easy() and 24 or 19, CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper

	-- Mythic
	elseif spellId == 414357 then -- Sword Knife Stance
		stance = spellId
		self:Message("stages", "cyan", CL.soon:format(CL.leap), 424456) -- Smashing Viscera
		self:Message("stages", "cyan", CL.soon:format(L.heart_stopper), 415623) -- Heart Stopper
		self:PlaySound("stages", "info")
		self:Bar(415623, 21.5, CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper
		self:Bar(424456, 23.9, CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera

	elseif spellId == 425282 then -- Axe Knife Stance
		stance = spellId
		self:Message("stages", "cyan", CL.soon:format(L.umbral_destruction), 416048) -- Umbral Destruction
		self:Message("stages", "cyan", CL.soon:format(L.heart_stopper), 415623) -- Heart Stopper
		self:PlaySound("stages", "info")
		self:Bar(415623, 24.3, CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper
		self:Bar(416048, 26.7, CL.count:format(L.umbral_destruction, umbralDestructionCount)) -- Umbral Destruction

	elseif spellId == 425283 then -- Axe Sword Stance
		stance = spellId
		self:Message("stages", "cyan", CL.soon:format(CL.leap), 424456) -- Smashing Viscera
		self:Message("stages", "cyan", CL.soon:format(L.umbral_destruction), 416048) -- Umbral Destruction
		self:PlaySound("stages", "info")
		self:Bar(416048, 19.0, CL.count:format(L.umbral_destruction, umbralDestructionCount)) -- Umbral Destruction
		self:Bar(424456, 25.5, CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera
	end
end

function mod:DrenchedBlades(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 9 then
		self:StackMessage(args.spellId, "purple", args.destName, amount, 9)
		if amount > 9 then -- Taunt?
			self:PlaySound(args.spellId, "warning")
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local playerList = {}
	function mod:BlisteringSpear(args)
		playerList = {}
		self:StopBar(CL.count:format(L.blistering_spear, blisteringSpearCount))
		blisteringSpearCount = blisteringSpearCount + 1

		local cd
		if not stance then
			if blisteringSpearCount < 3 then
				cd = markedForTormentCount == 1 and 20.7 or 30.4
			end
		elseif self:Mythic() then
			local timer = { 14.2, 32.8, 36.5, 20.7, 0 }
			if markedForTormentCount < 5 or blisteringSpearCount < 3 then -- only 2 before berserk at the end
				cd = timer[blisteringSpearCount]
			end
		elseif self:Easy() then
			local timer = { 14.2, 30.5, 30.3, 14.6, 20.7, 0 }
			cd = timer[blisteringSpearCount]
		else
			local timer = { 14.2, 23.2, 23.2, 24.4, 20.7, 0 }
			cd = timer[blisteringSpearCount]
		end
		if cd then
			self:Bar(414888, cd, CL.count:format(L.blistering_spear, blisteringSpearCount))
		end
	end

	function mod:BlisteringSpearApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.blistering_spear_single)
		end
		self:CustomIcon(blisteringSpearMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.blistering_spear, blisteringSpearCount-1))
	end

	function mod:BlisteringSpearRemoved(args)
		self:CustomIcon(blisteringSpearMarker, args.destName)
	end
end

function mod:BlisteringTorment(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.blistering_torment)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:TwistingBlade(args)
	self:StopBar(CL.count:format(L.twisting_blade, twistingBladeCount))
	self:Message(args.spellId, "orange", CL.count:format(L.twisting_blade, twistingBladeCount))
	self:PlaySound(args.spellId, "alarm")
	twistingBladeCount = twistingBladeCount + 1

	local cd
	if stance == 414357 then -- Sword Knife Stance
		local timer = { 32.7, 30.5, 27.0, 20.7, 0 }
		cd = timer[twistingBladeCount]
	elseif stance == 425282 then -- Axe Knife Stance
		local timer = { 13.2, 25.6, 25.6, 25.6, 20.7, 0 }
		cd = timer[twistingBladeCount]
	elseif stance == 425283 then -- Axe Sword Stance
		local timer = { 32.6, 30.4, 26.8, 20.6, 0 }
		cd = timer[twistingBladeCount]
	elseif twistingBladeCount < 3 then -- otherwise 2 per
		cd = 20.7
	end
	if cd then
		self:Bar(args.spellId, cd, CL.count:format(L.twisting_blade, twistingBladeCount))
	end
end

function mod:MarkedForTorment(args)
	self:StopBar(CL.count:format(L.marked_for_torment, markedForTormentCount))
	self:StopBar(CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
	self:StopBar(CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
	self:StopBar(CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera
	self:StopBar(CL.count:format(L.umbral_destruction, umbralDestructionCount)) -- Umbral Destruction
	self:StopBar(CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper

	self:Message(args.spellId, "cyan", CL.count:format(L.marked_for_torment, markedForTormentCount))
	self:PlaySound(args.spellId, "long")
	markedForTormentCount = markedForTormentCount + 1
end

function mod:MarkedForTormentApplied(args)
	-- applied/removed on channel start and end? o.O
	self:StopBar(CL.count:format(L.marked_for_torment, markedForTormentCount))
	self:StopBar(CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
	self:StopBar(CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade

	self:CastBar(422776, 20, L.marked_for_torment)
end

function mod:MarkedForTormentRemoved(args)
	self:StopBar(CL.cast:format(L.marked_for_torment))
	self:Message(422776, "cyan", CL.over:format(L.marked_for_torment))
	self:PlaySound(422776, "long")

	self:SetStage(markedForTormentCount) -- SetStage to use for external addons/tools
	blisteringSpearCount = 1
	twistingBladeCount = 1

	umbralDestructionCount = 1
	smashingVisceraCount = 1
	heartStopperCount = 1

	-- normal: 4 torments, normal phase berserk
	-- heroic: 5 torments, no stance berserk
	-- mythic: 3 torments, normal phase berserk
	local berserkPhase = self:Mythic() and 4 or self:Easy() and 5 or 6
	if markedForTormentCount < berserkPhase then
		self:Bar(416996, self:Mythic() and 94 or self:Easy() and 83.5 or 79, CL.count:format(self:SpellName(416996), twistingBladeCount)) -- Twisting Blade
		self:Bar(414888, 14.4, CL.count:format(self:SpellName(414888), blisteringSpearCount)) -- Blistering Spear
	elseif markedForTormentCount == berserkPhase then -- berserk next
		self:Bar(416996, self:Mythic() and 14.1 or 11.6, CL.count:format(self:SpellName(416996), twistingBladeCount)) -- Twisting Blade
		self:Bar(414888, 18.8, CL.count:format(self:SpellName(414888), blisteringSpearCount)) -- Blistering Spear
		self:Berserk(self:Mythic() and 71.2 and self:Easy() and 111.3 or 31.0, 0)
	end
	self:Bar(422776, self:Mythic() and 120.5 or 115.5, CL.count:format(args.spellName, markedForTormentCount)) -- Marked for Torment
end

function mod:GatheringTormentApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:RuinousEnd(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")

	self:Bar(414888, self:Mythic() and 8.3 or 19.2, CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
	self:Bar(416996, self:Mythic() and 19.2 or 11.2, CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
	self:Bar(422776, self:Mythic() and 40.0 or 54.3, CL.count:format(self:SpellName(422776), markedForTormentCount)) -- Marked for Torment
end

function mod:UmbralDestruction(args)
	self:StopBar(CL.count:format(L.umbral_destruction, umbralDestructionCount))
	self:Message(args.spellId, "red", CL.count:format(L.umbral_destruction, umbralDestructionCount))
	self:PlaySound(args.spellId, "warning")
	umbralDestructionCount = umbralDestructionCount + 1
	if umbralDestructionCount < 3 then -- 2 only
		self:Bar(args.spellId, self:Mythic() and 32.8 or self:Heroic() and 25.5 or 30.5, CL.count:format(L.umbral_destruction, umbralDestructionCount))
	end
end

function mod:SmashingViscera(args)
	self:StopBar(CL.count:format(CL.leap, smashingVisceraCount))
	self:Message(424456, "orange", CL.count:format(CL.leap, smashingVisceraCount))
	self:PlaySound(424456, "alarm")
	smashingVisceraCount = smashingVisceraCount + 1
	if smashingVisceraCount < 3 then -- 2 only
		self:Bar(424456, self:Mythic() and 32.8 or self:Heroic() and 25.5 or 30.5, CL.count:format(CL.leap, smashingVisceraCount))
	end
end

do
	local prev = 0
	function mod:HeartStopperApplied(args)
		local msg = CL.count:format(L.heart_stopper, heartStopperCount)
		if args.time - prev > 10 then -- reset
			prev = args.time
			self:StopBar(msg)
			self:Message(args.spellId, "orange", msg)
			heartStopperCount = heartStopperCount + 1
			if heartStopperCount < 3 then -- 2 only
				self:Bar(args.spellId, self:Mythic() and 32.8 or self:Heroic() and 25.5 or 30.5, CL.count:format(L.heart_stopper, heartStopperCount))
			end
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.heart_stopper_single)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:VitalRuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end
