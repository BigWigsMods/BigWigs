--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Igira the Cruel", 2549, 2554)
if not mod then return end
mod:RegisterEnableMob(200926) -- Igira the Cruel <Zaqali Elder>
mod:SetEncounterID(2709)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local blisteringSpearCount = 1
local twistingBladeCount = 1
local markedForTormentCount = 1
local wrackingSkewerCount = 1
local smashingVisceraCount = 1
local heartStopperCount = 1
local hasLeap = false

--------------------------------------------------------------------------------
-- Timers
--

local bladeTimers = {25.8, 13.6, 25.6, 48.7, 25.6}

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
		{414340, "TANK"}, -- Drenched Blades
		{414888, "SAY"}, -- Blistering Spear
		blisteringSpearMarker,
		{414770, "SAY"}, -- Blistering Torment
		416996, -- Twisting Blade
		422776, -- Marked for Torment
		414367, -- Gathering Torment
		419462, -- Flesh Mortification
		419048, -- Ruinous End
		416048, -- Umbral Destruction
		{424456, "SAY", "SAY_COUNTDOWN"}, -- Smashing Viscera
		{415623, "SAY_COUNTDOWN"}, -- Heart Stopper
		426056, -- Vital Rupture
	},nil,{
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
	self:Log("SPELL_CAST_START", "MarkedforTorment", 422776)
	self:Log("SPELL_AURA_REMOVED", "MarkedForTormentRemoved", 422961)
	self:Log("SPELL_AURA_APPLIED", "GatheringTormentApplied", 414367)
	self:Log("SPELL_AURA_APPLIED", "FleshMortification", 419462)
	self:Log("SPELL_CAST_START", "RuinousEnd", 419048)
	self:Log("SPELL_CAST_START", "UmbralDestruction", 416048)
	self:Log("SPELL_CAST_START", "SmashingViscera", 418531)
	-- self:Log("SPELL_AURA_APPLIED", "SmashingVisceraApplied", 424456)
	-- self:Log("SPELL_AURA_REMOVED", "SmashingVisceraRemoved", 424456)
	self:Log("SPELL_AURA_APPLIED", "HeartStopperApplied", 415623)
	self:Log("SPELL_AURA_REMOVED", "HeartStopperRemoved", 415623)
	self:Log("SPELL_AURA_APPLIED", "VitalRuptureApplied", 426056)
end

function mod:OnEngage()
	self:SetStage(1)
	blisteringSpearCount = 1
	twistingBladeCount = 1
	markedForTormentCount = 1
	hasLeap = false

	self:Bar(414888, self:Mythic() and 4.5 or 11, CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
	self:Bar(416996, self:Mythic() and 15.5 or 4.9, CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
	self:Bar(422776, 46, CL.count:format(L.marked_for_torment, markedForTormentCount)) -- Marked for Torment

	self:RegisterUnitEvent("UNIT_AURA", nil, "player") -- XXX temp Smashing Viscera / 424456, reported and hopefully they add log event
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_AURA(_, unit)
	local leapName = self:UnitDebuff(unit, 424456)
	if leapName and not hasLeap then
		hasLeap = true
		self:PersonalMessage(424456, nil, CL.leap)
		self:PlaySound(424456, "warning")
		self:Say(424456, CL.leap)
		self:SayCountdown(424456, 4)
	elseif not leapName and hasLeap then
		hasLeap = false
		self:CancelSayCountdown(424456)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 415020 then -- Sword Stance
		self:Message("stages", "cyan", CL.soon:format(CL.leap), 424456) -- Smashing Viscera
		self:PlaySound("stages", "info")
		smashingVisceraCount = 1
		self:Bar(424456, self:Easy() and 24 or 19, CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera
	elseif spellId == 415094 then -- Knife Stance
		self:Message("stages", "cyan", CL.soon:format(L.heart_stopper), 415623) -- Heart Stopper
		self:PlaySound("stages", "info")
		heartStopperCount = 1
		self:Bar(415623, self:Easy() and 24 or 19, CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper
	elseif spellId == 415090 then -- Axe Stance
		self:Message("stages", "cyan", CL.soon:format(L.umbral_destruction), 416048) -- Umbral Destruction
		self:PlaySound("stages", "info")
		wrackingSkewerCount = 1
		self:Bar(416048, self:Easy() and 24 or 19, CL.count:format(L.umbral_destruction, wrackingSkewerCount)) -- Umbral Destruction

	-- Mythic
	elseif spellId == 425282 then -- Axe Knife Stance
		self:Message("stages", "cyan", CL.soon:format(L.umbral_destruction), 416048) -- Umbral Destruction
		self:Message("stages", "cyan", CL.soon:format(L.heart_stopper), 415623) -- Heart Stopper
		self:PlaySound("stages", "info")
		wrackingSkewerCount = 1
		heartStopperCount = 1
		self:Bar(416048, 13.5, CL.count:format(L.umbral_destruction, wrackingSkewerCount)) -- Umbral Destruction
		self:Bar(415623, 17.5, CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper
	elseif spellId == 425283 then -- Axe Sword Stance
		self:Message("stages", "cyan", CL.soon:format(CL.leap), 424456) -- Smashing Viscera
		self:Message("stages", "cyan", CL.soon:format(L.umbral_destruction), 416048) -- Umbral Destruction
		self:PlaySound("stages", "info")
		smashingVisceraCount = 1
		wrackingSkewerCount = 1
		self:Bar(424456, 14, CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera
		self:Bar(416048, 8.5, CL.count:format(L.umbral_destruction, wrackingSkewerCount)) -- Umbral Destruction
	elseif spellId == 414357 then -- Sword Knife Stance
		self:Message("stages", "cyan", CL.soon:format(CL.leap), 424456) -- Smashing Viscera
		self:Message("stages", "cyan", CL.soon:format(L.heart_stopper), 415623) -- Heart Stopper
		self:PlaySound("stages", "info")
		smashingVisceraCount = 1
		heartStopperCount = 1
		self:Bar(415623, 8.5, CL.count:format(L.heart_stopper, heartStopperCount)) -- Heart Stopper
		self:Bar(424456, 12.5, CL.count:format(CL.leap, smashingVisceraCount)) -- Smashing Viscera
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
		-- self:Message(args.spellId, "yellow", CL.count:format(L.blistering_spear, blisteringSpearCount))
		-- self:PlaySound(args.spellId, "alert")
		blisteringSpearCount = blisteringSpearCount + 1

		local cd
		if self:Mythic() or markedForTormentCount == 1 then
			if blisteringSpearCount < 3 then
				cd = 20.3
			end
		elseif self:Easy() then
			local timer = { 14.2, 30.5, 30.3, 14.6, 20.7 }
			cd = timer[blisteringSpearCount]
		else
			local timer = { 14.2, 23.2, 23.2, 24.4, 20.7 }
			cd = timer[blisteringSpearCount]
		end
		self:Bar(414888, cd, CL.count:format(L.blistering_spear, blisteringSpearCount))
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
		self:TargetsMessage(args.spellId, "cyan", playerList, self:Mythic() and 6 or 4, CL.count:format(L.blistering_spear, blisteringSpearCount-1))
	end

	function mod:BlisteringSpearRemoved(args)
		self:CustomIcon(blisteringSpearMarker, args.destName)
	end
end

function mod:BlisteringTorment(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.blistering_torment)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, L.blistering_torment) -- Save me
	end
end

function mod:TwistingBlade(args)
	self:StopBar(CL.count:format(L.twisting_blade, twistingBladeCount))
	self:Message(args.spellId, "orange", CL.count:format(L.twisting_blade, twistingBladeCount))
	self:PlaySound(args.spellId, "alarm")
	twistingBladeCount = twistingBladeCount + 1

	local cd
	if self:Mythic() then
		local table = {30.5, 17.1, 20.7, 63.5}
		local mythicCount = twistingBladeCount % 4 + 1
		cd = table[mythicCount]
	elseif twistingBladeCount < 3 then -- otherwise 2 per
		cd = 20.7
	end
	self:Bar(args.spellId, cd, CL.count:format(L.twisting_blade, twistingBladeCount))
end

function mod:MarkedforTorment(args)
	self:StopBar(CL.count:format(L.marked_for_torment, markedForTormentCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.marked_for_torment, markedForTormentCount))
	self:PlaySound(args.spellId, "long")
	markedForTormentCount = markedForTormentCount + 1
end

function mod:MarkedForTormentRemoved(args)
	self:Message(422776, "cyan", CL.over:format(L.marked_for_torment))
	self:PlaySound(422776, "long")

	self:SetStage(markedForTormentCount) -- SetStage to use for external addons/tools
	blisteringSpearCount = 1
	twistingBladeCount = 1

	if markedForTormentCount < 5 then
		if not self:Mythic() then
			self:Bar(416996, self:Easy() and 83.5 or 79, CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
		end
		self:Bar(414888, self:Mythic() and 79 or 14.4, CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
		self:Bar(422776, self:Easy() and 120 or 115.5, CL.count:format(L.marked_for_torment, markedForTormentCount)) -- Marked for Torment
	else
		self:Bar(422776, self:Mythic() and 44.8 or 40, CL.count:format(L.marked_for_torment, markedForTormentCount)) -- Marked for Torment
	end
end

function mod:GatheringTormentApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FleshMortification(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:RuinousEnd(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")

	if self:Mythic() then
		self:Bar(414888, 8.3, CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
		self:Bar(416996, 19.2, CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
	else
		self:Bar(416996, 11.1, CL.count:format(L.twisting_blade, twistingBladeCount)) -- Twisting Blade
		self:Bar(414888, 19.7, CL.count:format(L.blistering_spear, blisteringSpearCount)) -- Blistering Spear
	end
end

function mod:UmbralDestruction(args)
	self:StopBar(CL.count:format(L.umbral_destruction, wrackingSkewerCount))
	self:Message(args.spellId, "red", CL.count:format(L.umbral_destruction, wrackingSkewerCount))
	self:PlaySound(args.spellId, "warning")
	wrackingSkewerCount = wrackingSkewerCount + 1
	if wrackingSkewerCount < 3 then -- 2 only
		self:Bar(args.spellId, self:Heroic() and 25.5 or 30.5, CL.count:format(L.umbral_destruction, wrackingSkewerCount))
	end
end

function mod:SmashingViscera(args)
	self:StopBar(CL.count:format(CL.leap, smashingVisceraCount))
	self:Message(424456, "orange", CL.count:format(CL.leap, smashingVisceraCount))
	self:PlaySound(424456, "alarm")
	smashingVisceraCount = smashingVisceraCount + 1
	if smashingVisceraCount < 3 then -- 2 only
		self:Bar(424456, self:Heroic() and 25.5 or 30.5, CL.count:format(CL.leap, smashingVisceraCount))
	end
end

-- function mod:SmashingVisceraApplied(args)
-- 	if self:Me(args.destGUID) then
-- 		self:PersonalMessage(args.spellId, nil, CL.leap)
-- 		self:PlaySound(args.spellId, "warning")
-- 		self:Say(args.spellId, CL.leap)
-- 		self:SayCountdown(args.spellId, 4)
-- 	end
-- end

-- function mod:SmashingVisceraRemoved(args)
-- 	if self:Me(args.destGUID) then
-- 		self:CancelSayCountdown(args.spellId)
-- 	end
-- end

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
				self:Bar(args.spellId, self:Heroic() and 25.5 or 30.5, CL.count:format(L.heart_stopper, heartStopperCount))
			end
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.heart_stopper_single)
			self:PlaySound(args.spellId, "warning")
			-- self:YellCountdown(args.spellId, 15) -- Heal me!
		end
	end

	function mod:HeartStopperRemoved(args)
		-- if self:Me(args.destGUID) then
		-- 	self:CancelYellCountdown(args.spellId)
		-- end
	end
end

function mod:VitalRuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end
