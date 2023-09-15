if not BigWigsLoader.onTestBuild then return end
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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.placeholder = "placeholder"
end

--------------------------------------------------------------------------------
-- Initialization
--

local blisteringSpearMarker = mod:AddMarkerOption(false, "player", 1, 414888, 1, 2, 3, 4, 5, 6) -- Blistering Spear
function mod:GetOptions()
	return {
		"stages",
		{414340, "TANK"}, -- Drenched Blades
		{414888, "SAY", "SAY_COUNTDOWN"}, -- Blistering Spear
		blisteringSpearMarker,
		{414770, "SAY"}, -- Piercing Torment
		416996, -- Twisting Blade
		422776, -- Marked for Torment
		414367, -- Gathering Torment
		419462, -- Flesh Mortification
		419048, -- Ruinous End
		416048, -- Wracking Skewer
		{424456, "SAY", "SAY_COUNTDOWN"}, -- Smashing Viscera
		{415623, "SAY_COUNTDOWN"}, -- Heart Stopper
		426056, -- Vital Rupture
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "DrenchedBlades", 414340)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrenchedBlades", 414340)
	self:Log("SPELL_CAST_START", "BlisteringSpear", 414425)
	self:Log("SPELL_AURA_APPLIED", "BlisteringSpearApplied", 414888)
	self:Log("SPELL_AURA_REMOVED", "BlisteringSpearRemoved", 414888)
	self:Log("SPELL_AURA_APPLIED", "PiercingTorment", 414770)
	self:Log("SPELL_CAST_START", "TwistingBlade", 416996)
	self:Log("SPELL_CAST_START", "MarkedforTorment", 422776)
	self:Log("SPELL_AURA_APPLIED", "GatheringTorment", 414367)
	self:Log("SPELL_AURA_APPLIED", "FleshMortification", 419462)
	self:Log("SPELL_CAST_START", "RuinousEnd", 419048)
	self:Log("SPELL_CAST_START", "WrackingSkewer", 416048)
	self:Log("SPELL_CAST_START", "SmashingViscera", 418531)
	self:Log("SPELL_AURA_APPLIED", "SmashingVisceraApplied", 424456)
	self:Log("SPELL_AURA_REMOVED", "SmashingVisceraRemoved", 424456)
	self:Log("SPELL_AURA_APPLIED", "HeartStopperApplied", 415623)
	self:Log("SPELL_AURA_REMOVED", "HeartStopperRemoved", 415623)
	self:Log("SPELL_AURA_APPLIED", "VitalRuptureApplied", 426056)
end

function mod:OnEngage()
	self:SetStage(1)
	blisteringSpearCount = 1
	twistingBladeCount = 1
	markedForTormentCount = 1

	self:Bar(414888, 15.5, CL.count:format(self:SpellName(414888), blisteringSpearCount)) -- Blistering Spear
	self:Bar(416996, 7.5, CL.count:format(self:SpellName(416996), twistingBladeCount)) -- Twisting Blade
	self:Bar(422776, 40, CL.count:format(self:SpellName(422776), markedForTormentCount)) -- Marked for Torment
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 415020 then -- Sword Stance
		self:Message("stages", "cyan", self:SpellName(spellId), spellId)
		self:PlaySound("stages", "info")
		smashingVisceraCount = 1
		self:Bar(424456, 19, CL.count:format(self:SpellName(424456), smashingVisceraCount)) -- Smashing Viscera
	elseif spellId == 415094 then -- Knife Stance
		self:Message("stages", "cyan", self:SpellName(spellId), spellId)
		self:PlaySound("stages", "info")
		heartStopperCount = 1
		self:Bar(415623, 19, CL.count:format(self:SpellName(415623), smashingVisceraCount)) -- Heart Stopper
	elseif spellId == 415090 then -- Axe Stance
		self:Message("stages", "cyan", self:SpellName(spellId), spellId)
		self:PlaySound("stages", "info")
		wrackingSkewerCount = 1
		self:Bar(416048, 19, CL.count:format(self:SpellName(416048), wrackingSkewerCount)) -- Wracking Skewer
	end
end

function mod:DrenchedBlades(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 6 then
		self:StackMessage(args.spellId, "purple", args.destName, amount, 6)
		if amount > 6 then -- Taunt?
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
		self:StopBar(CL.count:format(args.spellName, blisteringSpearCount))
		-- self:Message(args.spellId, "yellow", CL.count:format(args.spellName, blisteringSpearCount))
		-- self:PlaySound(args.spellId, "alert")
		blisteringSpearCount = blisteringSpearCount + 1
		self:Bar(414888, 140, CL.count:format(args.spellName, blisteringSpearCount))
	end

	function mod:BlisteringSpearApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			--self:SayCountdown(args.spellId, 15, count)
		end
		self:CustomIcon(blisteringSpearMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "cyan", playerList, self:Mythic() and 6 or 4, CL.count:format(args.spellName, blisteringSpearCount-1))
	end

	function mod:BlisteringSpearRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(blisteringSpearMarker, args.destName)
	end
end

function mod:PiercingTorment(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId)
	end
end

local bladeTimers = {25.8, 13.6, 25.6, 48.7, 25.6}
function mod:TwistingBlade(args)
	self:StopBar(CL.count:format(args.spellName, twistingBladeCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, twistingBladeCount))
	self:PlaySound(args.spellId, "alarm")
	twistingBladeCount = twistingBladeCount + 1
	local cdCount = twistingBladeCount % 5 + 1
	self:Bar(args.spellId, bladeTimers[cdCount], CL.count:format(args.spellName, twistingBladeCount))
end

function mod:MarkedforTorment(args)
	self:StopBar(CL.count:format(args.spellName, markedForTormentCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, markedForTormentCount))
	self:PlaySound(args.spellId, "long")
	markedForTormentCount = markedForTormentCount + 1
	self:SetStage(markedForTormentCount) -- SetStage to use for external addons/tools
	self:Bar(args.spellId, markedForTormentCount > 4 and 70 or 140, CL.count:format(args.spellName, markedForTormentCount))

	blisteringSpearCount = 1
	twistingBladeCount = 1
	-- Not resetting Marked for Torment to count up the rotations
	-- markedForTormentCount = 1

	--self:Bar(414425, 30, CL.count:format(self:SpellName(414425), blisteringSpearCount)) -- Blistering Spear
	--self:Bar(416996, 30, CL.count:format(self:SpellName(416996), twistingBladeCount)) -- Twisting Blade
	--self:Bar(422776, 100, CL.count:format(self:SpellName(422776), markedForTormentCount)) -- Marked for Torment

	-- New Bars for activated abilities?
	wrackingSkewerCount = 1
	--self:Bar(416048, 30, CL.count:format(self:SpellName(416048), WrackingSkewerCount)) -- Wracking Skewer

	smashingVisceraCount = 1
	--self:Bar(418531, 30, CL.count:format(self:SpellName(418531), smashingVisceraCount)) -- Smashing Viscera

	heartStopperCount = 1
	--self:Bar(415624, 30, CL.count:format(self:SpellName(415624), smashingVisceraCount)) -- Heart Stopper
end

function mod:GatheringTorment(args)
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
end

function mod:WrackingSkewer(args)
	self:StopBar(CL.count:format(args.spellName, wrackingSkewerCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, wrackingSkewerCount))
	self:PlaySound(args.spellId, "warning")
	wrackingSkewerCount = wrackingSkewerCount + 1
	if wrackingSkewerCount < 3 then -- 2 only
		self:Bar(args.spellId, 30, CL.count:format(args.spellName, wrackingSkewerCount))
	end
end

function mod:SmashingViscera(args)
	self:StopBar(CL.count:format(args.spellName, smashingVisceraCount))
	self:Message(424456, "orange", CL.count:format(args.spellName, smashingVisceraCount))
	-- self:PlaySound(424456, "alarm")
	smashingVisceraCount = smashingVisceraCount + 1
	if smashingVisceraCount < 3 then -- 2 only
		self:Bar(424456, 30, CL.count:format(args.spellName, smashingVisceraCount))
	end
end

function mod:SmashingVisceraApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:SmashingVisceraRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

do
	local prev = 0
	function mod:HeartStopperApplied(args)
		local msg = CL.count:format(args.spellName, heartStopperCount)
		if args.time - prev > 2 then -- reset
			prev = args.time
			self:StopBar(msg)
			self:Message(args.spellId, "orange", msg)
			heartStopperCount = heartStopperCount + 1
			if heartStopperCount < 3 then -- 2 only
				self:Bar(args.spellId, 30, CL.count:format(args.spellName, heartStopperCount))
			end
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:SayCountdown(args.spellId, 15)
		end
	end

	function mod:HeartStopperRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:VitalRuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end
