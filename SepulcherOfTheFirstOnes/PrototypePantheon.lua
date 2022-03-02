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
local deathtouchOnMe = false
local mobCollector = {}
local seedCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.necrotic_ritual = "Ritual"
	L.runecarvers_deathtouch = "Deathtouch"
	L.windswept_wings = "Winds"
	L.wild_stampede = "Stampede"
	L.withering_seeds = "Seeds"
	L.hand_of_destruction = "Hand"
end

--------------------------------------------------------------------------------
-- Initialization
--

local runecarversDeathtouchMarker = mod:AddMarkerOption(false, "player", 1, 360687, 1, 2) -- Runecarver's Deathtouch
local witheringSeedMarker = mod:AddMarkerOption(true, "npc", 1, 361568, 1, 2, 3, 4) -- Withering Seeds
local nightHunterMarker = mod:AddMarkerOption(false, "player", 8, 361745, 8, 7, 6, 5) -- Night Hunter
function mod:GetOptions()
	return {
		360295, -- Necrotic Ritual
		360687, -- Runecarver's Deathtouch
		360259, -- Gloom Bolt
		runecarversDeathtouchMarker,
		364941, -- Windswept Wings
		361067, -- Bastion's Ward
		{365269, "TANK_HEALER"}, -- Humbling Strikes
		361304, -- Wild Stampede
		361568, -- Withering Seeds
		witheringSeedMarker,
		366234, -- Animastorm
		--364241, -- Anima Bolt
		361789, -- Hand of Destruction
		364839, -- Sinful Projection
		{361689, "TANK"}, -- Wracking Pain
		361608, -- Burden of Sin
		{361745, "SAY", "SAY_COUNTDOWN"}, -- Night Hunter
		nightHunterMarker,
	},{
		[360295] = -24125, -- Prototype of War
		[364941] = -24130, -- Prototype of Duty
		[361304] = -24135, -- Prototype of Renewal
		[361789] = -24139, -- Prototype of Absolution
		[361745] = "mythic",
	},{
		[360295] = L.necrotic_ritual,
		[360687] = L.runecarvers_deathtouch,
		[364941] = L.windswept_wings,
		[361304] = L.wild_stampede,
		[361568] = L.withering_seeds,
		[361789] = L.hand_of_destruction,
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE") -- Used for Wild Stampede
	self:Log("SPELL_CAST_START", "Reconstruction", 361300) -- Stage Changes
	--self:Log("SPELL_CAST_START", "GloomBolt", 364240)
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
	--self:Log("SPELL_CAST_START", "AnimaBolt", 364241)
	--self:Log("SPELL_CAST_START", "WildStampede", 361304)
	self:Log("SPELL_CAST_START", "WitheringSeeds", 361568)
	self:Log("SPELL_SUMMON", "WitheringSeedsSummon", 361566)
	self:Log("SPELL_AURA_APPLIED", "Animastorm", 366234)
	self:Log("SPELL_AURA_APPLIED", "BurdenOfSinApplied", 361608)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurdenOfSinApplied", 361608)
	self:Log("SPELL_CAST_START", "SinfulProjection", 364865)
	self:Log("SPELL_AURA_APPLIED", "SinfulProjectionApplied", 364839)
	self:Log("SPELL_CAST_SUCCESS", "WrackingPain", 361689)
	self:Log("SPELL_AURA_APPLIED", "WrackingPainApplied", 361689)
	self:Log("SPELL_CAST_START", "HandOfDestruction", 361789)
	self:Log("SPELL_AURA_APPLIED", "NightHunterApplied", 361745)
	self:Log("SPELL_AURA_REMOVED", "NightHunterRemoved", 361745)
end

function mod:OnEngage()
	self:SetStage(1)
	necroticRitualCount = 1
	runecarversDeathtouchCount = 1
	windsCount = 1
	stampedeCount = 1
	seedsCount = 1
	stormCount = 1
	deathtouchOnMe = false
	projectionCount = 1
	handCount = 1
	mobCollector = {}
	seedCollector = {}

	self:Bar(365269, 10) -- Humbling Strikes
	self:Bar(360295, 10, CL.count:format(L.necrotic_ritual, necroticRitualCount)) -- Necrotic Ritual
	self:Bar(360687, 47.5, CL.count:format(L.runecarvers_deathtouch, runecarversDeathtouchCount)) -- Runecarvers Deathtouch
	self:Bar(364941, 59, CL.count:format(L.windswept_wings, windsCount)) -- Windswept Wings

	if self:GetOption(witheringSeedMarker) then
		self:RegisterTargetEvents("MarkAdds")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MarkAdds(event, unit, guid)
	if not mobCollector[guid] then
		if seedCollector[guid] then
			self:CustomIcon(witheringSeedMarker, unit, seedCollector[guid])
			mobCollector[guid] = true
		end
	end
end

function mod:RAID_BOSS_EMOTE(_, msg)
	if msg:find("361304", nil, true) then -- Wild Stampede
		self:StopBar(CL.count:format(L.wild_stampede, stampedeCount))
		self:Message(361304, "yellow", CL.count:format(L.wild_stampede, stampedeCount))
		self:PlaySound(361304, "alert")
		stampedeCount = stampedeCount + 1
		local cd = self:GetStage() == 3 and 74.7 or 25
		if self:Mythic() then
			cd = self:GetStage() == 3 and 33 or 35
		end
		self:Bar(361304, cd, CL.count:format(L.wild_stampede, stampedeCount))
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:Reconstruction(args)
		local t = args.time
		if t-prev > 2 then
			prev = t

			self:StopBar(365269)
			self:StopBar(CL.count:format(L.windswept_wings, windsCount))
			self:StopBar(CL.count:format(L.necrotic_ritual, necroticRitualCount))
			self:StopBar(CL.count:format(L.runecarvers_deathtouch, runecarversDeathtouchCount))
			self:StopBar(CL.count:format(L.hand_of_destruction, handCount))
			self:StopBar(CL.count:format(L.wild_stampede, stampedeCount))
			self:StopBar(CL.count:format(L.withering_seeds, seedsCount))
			self:StopBar(CL.count:format(self:SpellName(366234), stormCount))

			local stage = self:GetStage()
			stage = stage + 1
			self:SetStage(stage)
			necroticRitualCount = 1
			runecarversDeathtouchCount = 1
			windsCount = 1
			stampedeCount = 1
			seedsCount = 1
			stormCount = 1
			projectionCount = 1
			handCount = 1
			if stage == 2 then
				self:Bar(361304, 8.9, CL.count:format(L.wild_stampede, stampedeCount)) -- Wild Stampede
				self:Bar(361568, 18.5, CL.count:format(L.withering_seeds, seedsCount)) -- Withering Seeds
				self:Bar(366234, 38.5, CL.count:format(self:SpellName(366234), stormCount)) -- Anima Storm
				self:Bar(361789, 79.9, CL.count:format(L.hand_of_destruction, handCount)) -- Hand of Destruction
			elseif stage == 3 then
				self:Bar(365269, 41) -- Humbling Strikes
				self:Bar(360295, 134, CL.count:format(L.necrotic_ritual, necroticRitualCount)) -- Necrotic Ritual
				self:Bar(360687, 129, CL.count:format(L.runecarvers_deathtouch, runecarversDeathtouchCount)) -- Runecarvers Deathtouch
				self:Bar(364941, 53.1, CL.count:format(L.windswept_wings, windsCount)) -- Windswept Wings
				self:Bar(361304, 24.5, CL.count:format(L.wild_stampede, stampedeCount)) -- Wild Stampede
				self:Bar(361568, 21.3, CL.count:format(L.withering_seeds, seedsCount)) -- Withering Seeds
				self:Bar(366234, 51, CL.count:format(self:SpellName(366234), stormCount)) -- Anima Storm
				self:Bar(361789, 104.1, CL.count:format(L.hand_of_destruction, handCount)) -- Hand of Destruction
			end
		end
	end
end

-- function mod:GloomBolt(args)
-- 	local canDo, ready = self:Interrupter(args.sourceGUID)
-- 	if canDo then
-- 		self:Message(360259, "yellow")
-- 		if ready then
-- 			self:PlaySound(360259, "alert")
-- 		end
-- 	end
-- end

function mod:GloomBoltApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "blue")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:NecroticRitual(args)
	self:StopBar(CL.count:format(L.necrotic_ritual, necroticRitualCount))
	self:Message(args.spellId, "purple", CL.count:format(L.necrotic_ritual, necroticRitualCount))
	self:PlaySound(args.spellId, "alert")
	necroticRitualCount = necroticRitualCount + 1
	self:Bar(args.spellId, 72.3, CL.count:format(L.necrotic_ritual, necroticRitualCount))
end

do
	local playerList = {}
	function mod:RunecarversDeathtouch(args)
		playerList = {}
		runecarversDeathtouchCount = runecarversDeathtouchCount + 1
		self:Bar(360687, 57, CL.count:format(L.runecarvers_deathtouch, runecarversDeathtouchCount))
	end

	function mod:RunecarversDeathtouchApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			deathtouchOnMe = true
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(L.runecarvers_deathtouch, runecarversDeathtouchCount-1))
		self:CustomIcon(runecarversDeathtouchMarker, args.destName, count)
	end

	function mod:RunecarversDeathtouchRemoved(args)
		if self:Me(args.destGUID) then
			deathtouchOnMe = false
			self:Message(args.spellId, "green", CL.removed:format(L.runecarvers_deathtouch))
			self:PlaySound(args.spellId, "info")
		end
		self:CustomIcon(runecarversDeathtouchMarker, args.destName, 0)
	end
end


function mod:HumblingStrikes(args)
	self:Message(365269, "purple", CL.casting:format(args.spellName))
	self:Bar(365269, self:GetStage() == 3 and 49.8 or 35.5)
end

function mod:HumblingStrikesApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 2)
	self:PlaySound(args.spellId, "alarm")
end


function mod:BastionsWardApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, deathtouchOnMe and "green" or "red", CL.you:format(CL.shield))
		self:PlaySound(args.spellId, deathtouchOnMe and "info" or "underyou")
	end
end

function mod:BastionsWardRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, deathtouchOnMe and "red" or "green", CL.removed:format(CL.shield))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:WindsweptWings(args)
	self:StopBar(CL.count:format(L.windswept_wings, windsCount))
	self:Message(args.spellId, "purple", CL.count:format(L.windswept_wings, windsCount))
	self:PlaySound(args.spellId, "alert")
	windsCount = windsCount + 1
	self:Bar(args.spellId, self:GetStage() == 3 and 82.9 or 64.5, CL.count:format(L.windswept_wings, windsCount))
end

-- function mod:AnimaBolt(args)
-- 	local canDo, ready = self:Interrupter(args.sourceGUID)
-- 	if canDo then
-- 		self:Message(args.spellId, "yellow")
-- 		if ready then
-- 			self:PlaySound(args.spellId, "alert")
-- 		end
-- 	end
-- end

-- function mod:WildStampede(args)
-- 	self:StopBar(CL.count:format(L.wild_stampede, stampedeCount))
-- 	self:Message(args.spellId, "purple", CL.count:format(L.wild_stampede, stampedeCount))
-- 	self:PlaySound(args.spellId, "alert")
-- 	stampedeCount = stampedeCount + 1
-- 	local cd = self:GetStage() == 3 and 48.5 or (stampedeCount == 2 and 50 or 33)
-- 	if self:Mythic() then
-- 		cd = self:GetStage() == 3 and 33 or 35
-- 	end
-- 	self:Bar(args.spellId, cd, CL.count:format(L.wild_stampede, stampedeCount))
-- end

do
	local witheringSeedMarks = {}
	function mod:WitheringSeeds(args)
		self:StopBar(CL.count:format(L.withering_seeds, seedsCount))
		self:Message(args.spellId, "cyan", CL.count:format(L.withering_seeds, seedsCount))
		self:PlaySound(args.spellId, "alert")
		seedsCount = seedsCount + 1
		self:Bar(args.spellId, self:GetStage() == 3 and 74.2 or 96.2, CL.count:format(L.withering_seeds, seedsCount))
		seedCollector = {}
		witheringSeedMarks = {}
	end

	function mod:WitheringSeedsSummon(args)
		if self:GetOption(witheringSeedMarker) then
			for i = 1, 4, 1 do -- 1, 2, 3, 4
				if not seedCollector[args.destGUID] and not witheringSeedMarks[i] then
					witheringSeedMarks[i] = args.destGUID
					seedCollector[args.destGUID] = i
					return
				end
			end
		end
	end
end

function mod:Animastorm(args)
	self:StopBar(CL.count:format(args.spellName, stormCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, stormCount))
	self:PlaySound(args.spellId, "alert")
	stormCount = stormCount + 1
	self:Bar(args.spellId, self:GetStage() == 3 and 84 or 67.5, CL.count:format(args.spellName, stormCount))
end

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
end

do
	local prev = 0
	local playerList = {}
	function mod:SinfulProjectionApplied(args)
		local t = args.time
		if t-prev > 5 then
			playerList = {}
			prev = t
			self:Message(args.spellId, "orange")
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:WrackingPain(args)
	self:Bar(args.spellId, self:GetStage() == 3 and 49.8 or 45)
end

function mod:WrackingPainApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 2)
	self:PlaySound(args.spellId, "alarm")
end

function mod:HandOfDestruction(args)
	self:StopBar(CL.count:format(L.hand_of_destruction, handCount))
	self:Message(args.spellId, "purple", CL.count:format(L.hand_of_destruction, handCount))
	self:PlaySound(args.spellId, "alert")
	handCount = handCount + 1
	self:Bar(args.spellId, 74, CL.count:format(L.hand_of_destruction, handCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:NightHunterApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			self:CastBar(args.spellId, 8)
		end
		local count = #playerList+1
		local icon = 9-count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID)then
			self:Yell(args.spellId, CL.count_rticon:format(args.spellName, icon, icon))
			self:YellCountdown(args.spellId, 8, icon)
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
		self:CustomIcon(nightHunterMarker, args.destName, icon)
	end

	function mod:NightHunterRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelYellCountdown(args.spellId)
		end
		self:CustomIcon(nightHunterMarker, args.destName)
	end
end
