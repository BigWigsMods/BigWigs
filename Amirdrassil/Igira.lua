if not BigWigsLoader.onTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Igira the Cruel", 2549, 2554)
if not mod then return end
mod:RegisterEnableMob(206689) -- Igira the Cruel <Zaqali Elder>
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

local heartStopperMarker = mod:AddMarkerOption(true, "player", 1, 415624, 1, 2, 3, 4, 5) -- Controlled Burn
function mod:GetOptions()
	return {
		{414340, "TANK"}, -- Drenched Blades
		414425, -- Blistering Spear
		{414770, "SAY"}, -- Piercing Torment
		416996, -- Twisting Blade
		422776, -- Marked for Torment
		414367, -- Gathering Torment
		419462, -- Flesh Mortification
		419048, -- Ruinous End
		416048, -- Wracking Skewer
		418531, -- Smashing Viscera
		{415624, "SAY_COUNTDOWN"}, -- Heart Stopper
		heartStopperMarker,
		426056, -- Vital Rupture
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "DrenchedBlades", 414340)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrenchedBlades", 414340)
	self:Log("SPELL_CAST_START", "BlisteringSpear", 414425)
	self:Log("SPELL_AURA_APPLIED", "PiercingTorment", 414770)
	self:Log("SPELL_CAST_START", "TwistingBlade", 416996)
	self:Log("SPELL_CAST_START", "MarkedforTorment", 422776)
	self:Log("SPELL_AURA_APPLIED", "GatheringTorment", 414367)
	self:Log("SPELL_AURA_APPLIED", "FleshMortification", 419462)
	self:Log("SPELL_CAST_START", "RuinousEnd", 419048)
	self:Log("SPELL_CAST_START", "WrackingSkewer", 416048)
	self:Log("SPELL_CAST_START", "SmashingViscera", 418531)
	self:Log("SPELL_CAST_SUCCESS", "HeartStopper", 415624)
	self:Log("SPELL_AURA_APPLIED", "HeartStopperApplied", 415623)
	self:Log("SPELL_AURA_REMOVED", "HeartStopperRemoved", 415623)
	self:Log("SPELL_AURA_APPLIED", "VitalRuptureApplied", 426056)
end

function mod:OnEngage()
	self:SetStage(1)
	blisteringSpearCount = 1
	twistingBladeCount = 1
	markedForTormentCount = 1

	--self:Bar(414425, 30, CL.count:format(self:SpellName(414425), blisteringSpearCount)) -- Blistering Spear
	--self:Bar(416996, 30, CL.count:format(self:SpellName(416996), twistingBladeCount)) -- Twisting Blade
	--self:Bar(422776, 100, CL.count:format(self:SpellName(422776), markedForTormentCount)) -- Marked for Torment
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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

function mod:BlisteringSpear(args)
	self:StopBar(CL.count:format(args.spellName, blisteringSpearCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, blisteringSpearCount))
	self:PlaySound(args.spellId, "alert")
	blisteringSpearCount = blisteringSpearCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, blisteringSpearCount))
end

function mod:PiercingTorment(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId)
	end
end

function mod:TwistingBlade(args)
	self:StopBar(CL.count:format(args.spellName, twistingBladeCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, twistingBladeCount))
	self:PlaySound(args.spellId, "alarm")
	twistingBladeCount = twistingBladeCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, twistingBladeCount))
end

function mod:MarkedforTorment(args)
	self:SetStage(markedForTormentCount) -- SetStage to use for external addons/tools
	self:StopBar(CL.count:format(args.spellName, markedForTormentCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, markedForTormentCount))
	self:PlaySound(args.spellId, "long")
	markedForTormentCount = markedForTormentCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, markedForTormentCount))

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
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, wrackingSkewerCount))
end

function mod:SmashingViscera(args)
	self:StopBar(CL.count:format(args.spellName, smashingVisceraCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, smashingVisceraCount))
	self:PlaySound(args.spellId, "alarm")
	smashingVisceraCount = smashingVisceraCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, smashingVisceraCount))
end

do
	local playerList = {}
	function mod:HeartStopper(args)
		playerList = {}
		self:StopBar(CL.count:format(args.spellName, heartStopperCount))
		heartStopperCount = heartStopperCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, heartStopperCount))
	end

	function mod:HeartStopperApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(415624, "warning")
			self:SayCountdown(415624, 15, count)
		end
		self:CustomIcon(heartStopperMarker, args.destName, count)
		self:TargetsMessage(415624, "cyan", playerList, 5, CL.count:format(args.spellName, heartStopperCount-1))
	end

	function mod:HeartStopperRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(415624)
		end
		self:CustomIcon(heartStopperMarker, args.destName)
	end
end

function mod:VitalRuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end
