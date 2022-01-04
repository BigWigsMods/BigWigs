if not IsTestBuild() then return end

-- Gloom Bolt: Targetscan and warn targets of incoming damage?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Prototype Pantheon", 2481, 2460)
if not mod then return end
mod:RegisterEnableMob(181549, 181548, 181546, 181551) -- Prototype of War, Prototype of Absolution, Prototype of Renewal, Prototype of Duty
mod:SetEncounterID(2544)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local necroticRitualCount = 1
local runecarversDeathtouchCount = 1
local windsCount = 1
local stampedeCount = 1
local seedsCount = 1
local stormCount = 1
local projectionCount = 1
local handCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local runecarversDeathtouchMarker = mod:AddMarkerOption(false, "player", 1, 360687, 1, 2, 3, 4) -- Runecarver's Deathtouch
function mod:GetOptions()
	return {
		360259, -- Gloom Bolt
		360295, -- Necrotic Ritual
		360687, -- Runecarver's Deathtouch
		runecarversDeathtouchMarker,
		{365269, "TANK_HEALER"}, -- Humbling Strikes
		361067, -- Bastion's Ward
		364941, -- Pinning Volley
		364241, -- Anima Bolt
		361304, -- Wild Stampede
		361568, -- Withering Seeds
		366234, -- Animastorm
		361608, -- Burden of Sin
		364839, -- Sinful Projection
		{361689, "TANK"}, -- Wracking Pain
		361789, -- Hand of Destruction
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")

	self:Log("SPELL_CAST_START", "GloomBolt", 364240)
	self:Log("SPELL_AURA_APPLIED", "GloomBoltApplied", 360259)
	self:Log("SPELL_CAST_START", "NecroticRitual", 360295)
	self:Log("SPELL_CAST_START", "RunecarversDeathtouch", 360636)
	self:Log("SPELL_AURA_APPLIED", "RunecarversDeathtouchApplied", 360687)
	self:Log("SPELL_AURA_REMOVED", "RunecarversDeathtouchRemoved", 360687)
	self:Log("SPELL_CAST_START", "HumblingStrikes", 365272)
	self:Log("SPELL_AURA_APPLIED", "HumblingStrikesApplied", 365269)
	self:Log("SPELL_AURA_REMOVED", "HumblingStrikesApplied", 365269)
	self:Log("SPELL_AURA_APPLIED", "BastionsWardApplied", 361067)
	self:Log("SPELL_AURA_REMOVED", "BastionsWardRemoved", 361067)
	self:Log("SPELL_CAST_SUCCESS", "WindsweptWings", 364941)
	self:Log("SPELL_CAST_START", "AnimaBolt", 364241)
	self:Log("SPELL_CAST_START", "WildStampede", 361304)
	self:Log("SPELL_CAST_START", "WitheringSeeds", 361568)
	--self:Log("SPELL_CAST_START", "Animastorm", 364868)
	self:Log("SPELL_AURA_APPLIED", "BurdenOfSinApplied", 361608)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurdenOfSinApplied", 361608)
	self:Log("SPELL_CAST_START", "SinfulProjection", 364865)
	self:Log("SPELL_AURA_APPLIED", "SinfulProjectionApplied", 364839)
	self:Log("SPELL_AURA_REMOVED", "SinfulProjectionRemoved", 364839)
	self:Log("SPELL_CAST_SUCCESS", "WrackingPain", 361689)
	self:Log("SPELL_AURA_APPLIED", "WrackingPainApplied", 361689)
	self:Log("SPELL_CAST_SUCCESS", "HandOfDestruction", 361789)
end

function mod:OnEngage()
	self:SetStage(1)
	necroticRitualCount = 1
	runecarversDeathtouchCount = 1
	windsCount = 1
	stampedeCount = 1
	seedsCount = 1
	stormCount = 1
	projectionCount = 1
	handCount = 1

	self:Bar(365269, 13.7)
	self:Bar(360295, 15, CL.count:format(self:SpellName(360295), necroticRitualCount))
	self:Bar(360687, 49.5, CL.count:format(self:SpellName(360687), runecarversDeathtouchCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 34098 then -- ClearAllDebuffs
		local guid = self:UnitGUID(unit)
		local unitId = self:MobId(guid)
		local stage = self:GetStage()
		if stage == 1 and (unitId == 181549 or unitId == 181549) then -- Stage 1 over
			self:StopBar(365269)
			self:StopBar(CL.count:format(self:SpellName(364941), windsCount))
			self:StopBar(CL.count:format(self:SpellName(360295), necroticRitualCount))
			self:StopBar(CL.count:format(self:SpellName(360687), runecarversDeathtouchCount))
			self:SetStage(2)
		elseif unitId == 181548 or unitId == 181546 then -- Stage 2 over
			self:StopBar(CL.count:format(self:SpellName(361789), handCount))

			self:SetStage(3)
			-- self:Bar(365269, 13.7)
			-- self:Bar(360295, 15, CL.count:format(self:SpellName(360295), necroticRitualCount))
			-- self:Bar(360687, 49.5, CL.count:format(self:SpellName(360687), runecarversDeathtouchCount))
		end
	elseif spellId == 366234 then -- Animastorm
		self:StopBar(CL.count:format(self:SpellName(spellId), stormCount))
		self:Message(spellId, "purple", CL.count:format(self:SpellName(spellId), stormCount))
		self:PlaySound(spellId, "alert")
		stormCount = stormCount + 1
		self:Bar(spellId, self:GetStage() == 3 and 84 or 68, CL.count:format(self:SpellName(spellId), stormCount))
	end
end

function mod:GloomBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(360259, "yellow")
		if ready then
			self:PlaySound(360259, "alert")
		end
	end
end

function mod:GloomBoltApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "blue")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:NecroticRitual(args)
	self:StopBar(CL.count:format(args.spellName, necroticRitualCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, necroticRitualCount))
	self:PlaySound(args.spellId, "alert")
	necroticRitualCount = necroticRitualCount + 1
	self:Bar(args.spellId, 71.5, CL.count:format(args.spellName, necroticRitualCount))
end

do
	local playerList = {}
	function mod:RunecarversDeathtouch(args)
		playerList = {}
		runecarversDeathtouchCount = runecarversDeathtouchCount + 1
		self:Bar(360687, 58, CL.count:format(args.spellName, runecarversDeathtouchCount))
	end

	function mod:RunecarversDeathtouchApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, runecarversDeathtouchCount-1))
		self:CustomIcon(runecarversDeathtouchMarker, args.destName, count)
	end

	function mod:RunecarversDeathtouchRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
		self:CustomIcon(runecarversDeathtouchMarker, args.destName, 0)
	end
end


function mod:HumblingStrikes(args)
	self:Message(365269, "purple", CL.casting:format(args.spellName))
	self:Bar(365269, self:GetStage() == 3 and 50 or 35.9)
end

function mod:HumblingStrikesApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 2)
	self:PlaySound(args.spellId, "alarm")
end


function mod:BastionsWardApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(CL.shield))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:BastionsWardRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red", CL.removed:format(CL.shield))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:WindsweptWings(args)
	self:StopBar(CL.count:format(args.spellName, windsCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, windsCount))
	self:PlaySound(args.spellId, "alert")
	windsCount = windsCount + 1
	self:Bar(args.spellId, self:GetStage() == 3 and 83.5 or 64.5, CL.count:format(args.spellName, windsCount))
end

function mod:AnimaBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:WildStampede(args)
	self:StopBar(CL.count:format(args.spellName, stampedeCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, stampedeCount))
	self:PlaySound(args.spellId, "alert")
	stampedeCount = stampedeCount + 1
	self:Bar(args.spellId, self:GetStage() == 3 and 75 or (stampedeCount == 2 and 37.5 or 25), CL.count:format(args.spellName, stampedeCount))
end

function mod:WitheringSeeds(args)
	self:StopBar(CL.count:format(args.spellName, seedsCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, seedsCount))
	self:PlaySound(args.spellId, "alert")
	seedsCount = seedsCount + 1
	self:Bar(args.spellId, self:GetStage() == 3 and 75 or 96, CL.count:format(args.spellName, seedsCount))
end

-- function mod:Animastorm(args)
-- 	self:StopBar(CL.count:format(args.spellName, stormCount))
-- 	self:Message(args.spellId, "purple", CL.count:format(args.spellName, stormCount))
-- 	self:PlaySound(args.spellId, "alert")
-- 	stormCount = stormCount + 1
-- 	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, stormCount))
-- end

function mod:BurdenOfSinApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SinfulProjection(args)
	self:StopBar(CL.count:format(args.spellName, projectionCount))
	self:Message(364839, "purple", CL.count:format(args.spellName, projectionCount))
	self:PlaySound(364839, "alert")
	projectionCount = projectionCount + 1
	--self:Bar(364839, 30, CL.count:format(args.spellName, projectionCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:SinfulProjectionApplied(args)
		local t = args.time
		if t-prev > 5 then
			playerList = {}
			prev = t
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			-- self:Say(args.spellId)
			-- self:SayCountdown(args.spellId, 4)
		end
		self:TargetMessage(args.spellId, "orange", args.destName)
	end

	function mod:SinfulProjectionRemoved(args)
		if self:Me(args.destGUID) then
			-- self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:WrackingPain(args)
	--self:Bar(args.spellId, 6)
end

function mod:WrackingPainApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 2)
	self:PlaySound(args.spellId, "alarm")
end

function mod:HandOfDestruction(args)
	self:StopBar(CL.count:format(args.spellName, handCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, handCount))
	self:PlaySound(args.spellId, "alert")
	handCount = handCount + 1
	self:Bar(args.spellId, self:GetStage() == 3 and 75 or 75, CL.count:format(args.spellName, handCount))
end
