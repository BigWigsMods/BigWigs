if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
-- -- Wicked Blade targets

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Stone Legion Generals", 2296, 2425)
if not mod then return end
mod:RegisterEnableMob(
	168112, -- General Kaal
	168113) -- General Grashaal
mod.engageId = 2417
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local wickedBladeCount = 1
local heartRendCount = 1
local serratedSwipeCount = 1
local crystalizeCount = 1
local pulverizingMeteorCount = 1
local reverberatingLeapCount = 1
local seismicUphealvalCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

local wickedBladeMarker = mod:AddMarkerOption(false, "player", 6, 333387, 6, 7) -- Heart Rend
local heartRendMarker = mod:AddMarkerOption(false, "player", 1, 334765, 1, 2, 3, 4) -- Heart Rend
local crystalizeMarker = mod:AddMarkerOption(false, "player", 5, 339690, 5) -- Crystalize
function mod:GetOptions()
	return {
		"stages",
			--[[ Stage One: Kaal's Assault ]]--
		329636, -- Hardened Stone Form
		{333387, "SAY"}, -- Wicked Blade
		wickedBladeMarker,
		334765, -- Heart Rend
		heartRendMarker,
		334929, -- Serrated Swipe
		{339690, "SAY", "SAY_COUNTDOWN"}, -- Crystalize
		crystalizeMarker,
		342544, -- Pulverizing Meteor
		343063, -- Stone Spike

		--[[ Intermission ]]--
		332406, -- Anima Infusion
		339885, -- Anima Infection
		342722, -- Stonewrath Exhaust
		332683, -- Shattering Blast

		--[[ Stage Two: Grashaal's Blitz ]]--
		329808, -- Hardened Stone Form
		342425, -- Stone Fist
		{334009, "SAY"}, -- Reverberating Leap
		334498, -- Seismic Upheaval
		{343086, "SAY"}, -- Ricocheting Shuriken

		--[[ Mythic ]]--
		342256, -- Call Shadow Forces
		342655, -- Volatile Anima Infusion
		340037, -- Volatile Stone Shell
		340043, -- Punishing Blow
		342698, -- Volatile Anima Injection
		342733, -- Ravenous Feast
		342985, -- Stonegale Effigy
	}, {
		["stages"] = "general",
		[329636] = -22681, -- Stage One: Kaal's Assault
		[332406] = "intermission",
		[329808] = -22718, -- Stage Two: Grashaal's Blitz
		[342256] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ Stage One: Kaal's Assault ]]--
	self:Log("SPELL_AURA_APPLIED", "HardenedStoneFormApplied", 329636)
	self:Log("SPELL_AURA_REMOVED", "HardenedStoneFormRemoved", 329636)
	self:Log("SPELL_CAST_START", "WickedBlade", 333387)
	self:Log("SPELL_AURA_APPLIED", "WickedBladeApplied", 333377) -- Wicked Mark
	self:Log("SPELL_AURA_REMOVED", "WickedBladeRemoved", 333377)
	self:Log("SPELL_CAST_SUCCESS", "HeartRend", 334765)
	self:Log("SPELL_AURA_APPLIED", "HeartRendApplied", 334765)
	self:Log("SPELL_AURA_REMOVED", "HeartRendRemoved", 334765)
	self:Log("SPELL_CAST_START", "SerratedSwipe", 334929)
	self:Log("SPELL_CAST_SUCCESS", "Crystalize", 339690)
	self:Log("SPELL_AURA_APPLIED", "CrystalizeApplied", 339690)
	self:Log("SPELL_AURA_REMOVED", "CrystalizeRemoved", 339690)
	self:Log("SPELL_CAST_START", "PulverizingMeteor", 342544)
	self:Log("SPELL_AURA_APPLIED", "StoneSpikeApplied", 343063)
	self:Log("SPELL_AURA_APPLIED", "AnimaApplied", 332406, 339885) -- Anima Infusion, Anima Infection
	self:Log("SPELL_CAST_START", "StonewrathExhaust", 342722)
	self:Log("SPELL_CAST_START", "ShatteringBlast", 332683)

	--[[ Stage Two: Grashaal's Blitz ]]--
	self:Log("SPELL_AURA_APPLIED", "GraniteFormApplied", 329808)
	self:Log("SPELL_AURA_REMOVED", "GraniteFormRemoved", 329808)
	self:Log("SPELL_CAST_START", "StoneFist", 342425)
	self:Log("SPELL_AURA_APPLIED", "StoneFistApplied", 342425)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StoneFistApplied", 342425)
	self:Log("SPELL_CAST_START", "ReverberatingLeap", 334009)
	self:Log("SPELL_CAST_START", "SeismicUpheaval", 334498)
	self:Log("SPELL_CAST_START", "RicochetingShuriken", 343086)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_START", "CallShadowForces", 342256)
	self:Log("SPELL_AURA_APPLIED", "VolatileAnimaApplied", 342655, 342698) -- Volatile Anima Infusion, Volatile Anima Injection
	self:Log("SPELL_AURA_APPLIED", "VolatileStoneShell", 340037)
	self:Log("SPELL_CAST_START", "PunishingBlow", 340043)
	self:Log("SPELL_CAST_SUCCESS", "RavenousFeast", 342733)
	self:Log("SPELL_AURA_APPLIED", "StonegaleEffigy", 342985)
end

function mod:OnEngage()
	stage = 1
	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	crystalizeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1

	--self:Bar(334929, 8.5, CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
	--self:Bar(333387, 18.5, CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	--self:Bar(334765, 33.5, CL.count:format(self:SpellName(334765), heartRendCount)) -- Soul Crusher
	--self:Bar(339690, 65, CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize
	--self:Bar(342544, 70, CL.count:format(self:SpellName(342544), pulverizingMeteorCount)) -- Pulverizing Meteor
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Stage One: Kaal's Assault ]]--
function mod:HardenedStoneFormApplied(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")

	self:StopBar(CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:StopBar(CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:StopBar(CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
end

function mod:HardenedStoneFormRemoved(args)
	self:StopBar(CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize
	self:StopBar(CL.count:format(self:SpellName(342544), pulverizingMeteorCount)) -- Pulverizing Meteor

	stage = 2
	self:Message2(args.spellId, "green", CL.stage:format(stage))
	self:PlaySound(args.spellId, "long")

	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	crystalizeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1

	--self:Bar(339690, 65, CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize
	--self:Bar(342544, 70, CL.count:format(self:SpellName(342544), pulverizingMeteorCount)) -- Pulverizing Meteor
	--self:Bar(342425, 15) -- Stone Fist
	--self:Bar(334009, 20, CL.count:format(self:SpellName(334009), reverberatingLeapCount)) -- Reverberating Leap
	--self:Bar(334498, 20, CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval

	--self:Bar(333387, 18.5, CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	--self:Bar(343086, 15) -- Ricocheting Shuriken
end

function mod:WickedBlade(args)
	self:StopBar(CL.count:format(args.spellName, wickedBladeCount))
	wickedBladeCount = wickedBladeCount + 1
	--self:Bar(args.spellId, 30.5, CL.count:format(args.spellName, wickedBladeCount))
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:WickedBladeApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count+5
		if self:Me(args.destGUID) then
			self:Say(333387, 138737) -- Blades
			self:PlaySound(333387, "warning")
		end
		self:TargetsMessage(333387, "orange", playerList, 2, CL.count:format(self:SpellName(333387), wickedBladeCount-1), nil, nil, playerIcons)

		if self:GetOption(wickedBladeMarker) then
			SetRaidTarget(args.destName, count+5)
		end
	end

	function mod:WickedBladeRemoved(args)
		if self:GetOption(wickedBladeMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:HeartRend(args)
	self:StopBar(CL.count:format(args.spellName, heartRendCount))
	heartRendCount = heartRendCount + 1
	--self:Bar(args.spellId, 44, CL.count:format(args.spellName, heartRendCount))
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:HeartRendApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Dispeller("magic") and count == 1 then
			self:PlaySound(args.spellId, "alarm", nil, playerList)
		elseif self:Me(args.destGUID) and not self:Dispeller("magic") then
			self:PlaySound(args.spellId, "alarm")
		end

		if self:GetOption(heartRendMarker) then
			SetRaidTarget(args.destName, count)
		end

		self:TargetsMessage(args.spellId, "orange", playerList, self:Mythic() and 4 or 3, CL.count:format(args.spellName, heartRendCount-1), nil, nil, playerIcons)
	end

	function mod:HeartRendRemoved(args)
		if self:GetOption(heartRendMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SerratedSwipe(args)
	self:StopBar(CL.count:format(args.spellName, serratedSwipeCount))
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, serratedSwipeCount))
	self:PlaySound(args.spellId, "info")
	serratedSwipeCount = serratedSwipeCount + 1
	--self:CDBar(args.spellId, 16, CL.count:format(args.spellName, serratedSwipeCount))
end

function mod:Crystalize(args)
	self:StopBar(CL.count:format(args.spellName, crystalizeCount))
	crystalizeCount = crystalizeCount + 1
	--self:CDBar(args.spellId, stage == 1 and 65 or 30, CL.count:format(args.spellName, crystalizeCount))
end

function mod:CrystalizeApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, crystalizeCount-1))
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "warning")
	end
	if self:GetOption(crystalizeMarker) then
		SetRaidTarget(args.destName, 5)
	end
end

function mod:CrystalizeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end

	if self:GetOption(crystalizeMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:PulverizingMeteor(args)
	self:StopBar(CL.count:format(args.spellName, pulverizingMeteorCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, pulverizingMeteorCount))
	self:PlaySound(args.spellId, "alert")
	pulverizingMeteorCount = pulverizingMeteorCount + 1
	--self:CDBar(args.spellId, 30, CL.count:format(args.spellName, pulverizingMeteorCount))
end

function mod:StoneSpikeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AnimaApplied(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:StonewrathExhaust(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShatteringBlast(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5)
end

--[[ Stage Two: Grashaal's Blitz ]]--
function mod:GraniteFormApplied(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")

	self:StopBar(CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize
	self:StopBar(CL.count:format(self:SpellName(342544), pulverizingMeteorCount)) -- Pulverizing Meteor
	self:StopBar(342425) -- Stone Fist
	self:StopBar(CL.count:format(self:SpellName(334009), reverberatingLeapCount)) -- Reverberating Leap
	self:StopBar(CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval
end

function mod:GraniteFormRemoved(args)
	self:StopBar(CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:StopBar(343086) -- Ricocheting Shuriken

	stage = 3
	self:Message2(args.spellId, "green", CL.stage:format(stage))
	self:PlaySound(args.spellId, "long")

	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	crystalizeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1

	--self:Bar(339690, 65, CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize
	--self:Bar(342544, 70, CL.count:format(self:SpellName(342544), pulverizingMeteorCount)) -- Pulverizing Meteor
	--self:Bar(342425, 15) -- Stone Fist
	--self:Bar(334009, 20, CL.count:format(self:SpellName(334009), reverberatingLeapCount)) -- Reverberating Leap
	--self:Bar(334498, 20, CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval

	--self:Bar(334929, 8.5, CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
	--self:Bar(333387, 18.5, CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	--self:Bar(334765, 33.5, CL.count:format(self:SpellName(334765), heartRendCount)) -- Soul Crusher
	end

function mod:StoneFist(args)
	--self:Bar(args.spellId, 20)
end

function mod:StoneFistApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(334009, 47482) -- Leap
			self:PlaySound(334009, "warning")
		end
		self:TargetMessage2(334009, "red", player, CL.count:format(self:SpellName(334009), reverberatingLeapCount-1))
	end

	function mod:ReverberatingLeap(args)
		self:StopBar(CL.count:format(args.spellName, reverberatingLeapCount))
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
		reverberatingLeapCount = reverberatingLeapCount + 1
		--self:CDBar(args.spellId, 31, CL.count:format(args.spellName, reverberatingLeapCount))
	end
end

function mod:SeismicUpheaval(args)
	self:StopBar(CL.count:format(args.spellName, seismicUphealvalCount))
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, seismicUphealvalCount))
	self:PlaySound(args.spellId, "long")
	seismicUphealvalCount = seismicUphealvalCount + 1
	--self:CDBar(args.spellId, 30, CL.count:format(args.spellName, seismicUphealvalCount))
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(343086, 159766) -- Throw
			self:PlaySound(343086, "alarm")
		end
		self:TargetMessage2(343086, "yellow", player)
	end

	function mod:RicochetingShuriken(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
		--self:CDBar(args.spellId, 31)
	end
end

--[[ Mythic ]]--
function mod:CallShadowForces(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

function mod:VolatileAnimaApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alert")
	end
end

do
	local prev = 0
	function mod:VolatileStoneShell(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:PunishingBlow(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:RavenousFeast(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local prev = 0
	function mod:StonegaleEffigy(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "cyan")
			self:PlaySound(args.spellId, "alert")
		end
	end
end
