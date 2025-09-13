
-- TODO:
-- -- XXX What happens with intermission/ultimates if they die?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Soul Hunters", 2810, 2688)
if not mod then return end
mod:RegisterEnableMob(237661, 237660, 237662) -- Adarus Duskblaze, Velaryn Bloodwrath, Ilyssa Darksorrow
mod:SetEncounterID(3122)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local bossesKilled = 0

-- Adarus Duskblaze
local adarusAlive = true
local devourersIreOnMe = false
local voidstepCount = 1
local voidstepTotalCount = 1
local eradicateTotalCount = 1
local eradicateCount = 1

-- Velaryn Bloodwrath
local velarynAlive = true
local theHuntCount = 1
local theHuntTotalCount = 1
local bladeDanceCount = 1
local bladeDanceTotalCount = 1
local eyeBeamCount = 1
local eyeBeamTotalCount = 1

-- Ilyssa Darksorrow
local ilyssaAlive = true
local fractureCount = 1
local fractureTotalCount = 1
local spiritBombCount = 1
local spiritBombTotalCount = 1
local sigilOfChainsCount = 1
local sigilOfChainsTotalCount = 1
local infernalStrikeCount = 1

local metaCount = 1

local timersEasy = {
	[1227355] = {21.5, 31.7, 28.7, 0}, -- Void Step
	[1227809] = {31.6, 35.7, 0}, -- The Hunt
	[1241306] = {18.4, 35.7, 37.5, 0}, -- Blade Dance
	[1218103] = {8.2, 35.7, 35.7, 0}, -- Eye Beam
	[1241833] = {3.5, 35.7, 35.7, 0}, -- Fracture
	[1242259] = {24.3, 35.7, 35.7, 0}, -- Spirit Bomb
}

local timersHeroic = {
	[1227355] = {21.0, 31.0, 28.1, 0}, -- Void Step
	[1227809] = {30.9, 34.9, 0}, -- The Hunt
	[1241306] = {18.0, 34.8, 36.6, 0}, -- Blade Dance
	[1218103] = {8.1, 34.9, 34.9, 0}, -- Eye Beam
	[1241833] = {3.5, 34.9, 34.9, 0}, -- Fracture
	[1242259] = {23.9, 34.9, 34.9, 0}, -- Spirit Bomb
}

local timersMythic = {
	[1227355] = {15.0, 33.7, 0}, -- Void Step
	[1227809] = {30.3, 34.0, 0}, -- The Hunt
	[1241306] = {17.7, 34.1, 35.8, 0}, -- Blade Dance
	[1218103] = {8, 34.0, 34.0, 0}, -- Eye Beam
	[1241833] = {3.5, 34.0, 34.0, 0}, -- Fracture
	[1242259] = {23.5, 34.1, 34.1, 0}, -- Spirit Bomb
	[1240891] = {30.5, 34.1, 0}, -- Sigil of Chains
	[1245726] = {41.8, 36.6, 0}, -- Eradicate
}

local timers = mod:Mythic() and timersMythic or mod:Easy() and timersEasy or timersHeroic

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1227809, CL.soak) -- The Hunt (Soak)
	self:SetSpellRename(1241306, CL.dodge) -- Blade Dance (Dodge)
	self:SetSpellRename(1240891, CL.pull_in) -- Sigil of Chains (Pull In)
	self:SetSpellRename(1242259, CL.raid_damage) -- Spirit Bomb (Raid Damage)
	self:SetSpellRename(1242284, CL.heal_absorb) -- Soulcrush (Heal Absorb)
	self:SetSpellRename(1233672, CL.leap) -- Infernal Strike (Leap)
end

function mod:GetOptions()
	return {
		{"stages", "CASTBAR"},
		-- Adarus Duskblaze
			1222232, -- Devourer's Ire
				1222310, -- Unending Hunger
			1227355, -- Voidstep
				1227685, -- Hungering Slash
					1235045, -- Encroaching Oblivion
			1245726, -- Eradicate (Mythic)
		-- Intermission: The Ceaseless Hunger
			1233105, -- Dark Residue
			1233968, -- Event Horizon
		-- Velaryn Bloodwrath
			{1227809, "SAY", "SAY_COUNTDOWN"}, -- The Hunt
			1241306, -- Blade Dance
			{1218103, "TANK"}, -- Eye Beam
				1221490, -- Fel-Singed
				{1225130, "TANK"}, -- Felblade
			1240891, -- Sigil of Chains (Mythic)
		-- Ilyssa Darksorrow
			{1241833, "TANK"}, -- Fracture
				1226493, -- Shattered Soul
				1241946, -- Frailty
			1242259, -- Spirit Bomb
				1242284, -- Soulcrush
				1242304, -- Expulsed Soul
		-- Intermission: The Unrelenting Pain
			1233672, -- Infernal Strike
			-- 1227117, -- Fel Devastation
				1233381, -- Withering Flames
	},{
		-- Tabs
		{
			tabName = self:SpellName(-32500), -- Adarus Duskblaze
			{1222232, 1222310, 1227355, 1227685, 1235045, 1233105, 1233968, 1245726},
		},
		{
			tabName = self:SpellName(-31792), -- Velaryn Bloodwrath
			{1227809, 1241306, 1218103, 1221490, 1225130, 1240891},
		},
		{
			tabName = self:SpellName(-31791), -- Ilyssa Darksorrow
			{1241833, 1226493, 1241946, 1242259, 1242284, 1242304, 1233672, 1233381},
		},
		-- Sections
		[1245726] = "mythic", -- Eradicate
		[1233105] = -32566, -- Intermission: The Ceaseless Hunger
		[1240891] = "mythic", -- Sigil of Chains
		[1233672] = -32545, -- Intermission: The Unrelenting Pain
	},{
		[1227809] = CL.soak, -- The Hunt (Soak)
		[1241306] = CL.dodge, -- Blade Dance (Dodge)
		[1240891] = CL.pull_in, -- Sigil of Chains (Pull In)
		[1242259] = CL.raid_damage, -- Spirit Bomb (Raid Damage)
		[1242284] = CL.heal_absorb, -- Soulcrush (Heal Absorb)
		[1233672] = CL.leap, -- Infernal Strike (Leap)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3") -- Intermission end
	self:Log("SPELL_CAST_START", "Metamorphosis", 1231501, 1232568, 1232569) -- Meta Cast to track intermission start

	-- Adarus Duskblaze
	self:Log("SPELL_AURA_APPLIED", "DevourersIreApplied", 1222232)
	self:Log("SPELL_AURA_REMOVED", "DevourersIreRemoved", 1222232)
	self:Log("SPELL_AURA_APPLIED", "UnendingHungerApplied", 1222310)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnendingHungerApplied", 1222310)
	self:Log("SPELL_CAST_START", "Voidstep", 1227355)
	self:Log("SPELL_DAMAGE", "HungeringSlashDamage", 1227685)
	self:Log("SPELL_MISSED", "HungeringSlashDamage", 1227685)
	self:Log("SPELL_AURA_APPLIED", "EncroachingOblivionDamage", 1235045)
	self:Log("SPELL_PERIODIC_DAMAGE", "EncroachingOblivionDamage", 1235045)
	self:Log("SPELL_PERIODIC_MISSED", "EncroachingOblivionDamage", 1235045)
	-- Intermission: The Ceaseless Hunger
	self:Log("SPELL_CAST_SUCCESS", "CollapsingStar", 1233093)
	self:Log("SPELL_AURA_APPLIED", "DarkResidueApplied", 1233105)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkResidueApplied", 1233105)
	self:Log("SPELL_AURA_REMOVED", "DarkResidueRemoved", 1233105)
	self:Log("SPELL_AURA_APPLIED", "EventHorizonDamage", 1233968)
	self:Log("SPELL_PERIODIC_DAMAGE", "EventHorizonDamage", 1233968)
	self:Log("SPELL_PERIODIC_MISSED", "EventHorizonDamage", 1233968)
	self:Death("AdarusDuskblazeDeath", 237661)

	-- Velaryn Bloodwrath
	self:Log("SPELL_AURA_APPLIED", "TheHuntApplied", 1227847)
	self:Log("SPELL_CAST_SUCCESS", "BladeDance", 1241254)
	self:Log("SPELL_CAST_START", "EyeBeam", 1218103)
	self:Log("SPELL_AURA_APPLIED", "FelSingedApplied", 1221490)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelSingedApplied", 1221490)
	self:Log("SPELL_AURA_APPLIED", "FelbladeApplied", 1225130)
	self:Log("SPELL_AURA_APPLIED", "FelRushApplied", 1233863)
	-- Intermission: The Demon Within
	self:Death("VelarynBloodwrathDeath", 237660)

	-- Ilyssa Darksorrow
	self:Log("SPELL_CAST_START", "Fracture", 1241833)
	self:Log("SPELL_AURA_APPLIED", "ShatteredSoulApplied", 1226493)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatteredSoulApplied", 1226493)
	self:Log("SPELL_AURA_REMOVED", "FrailtyTankRemoved", 1241917)
	self:Log("SPELL_AURA_APPLIED", "FrailtySoakApplied", 1241946)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrailtySoakApplied", 1241946)
	self:Log("SPELL_CAST_SUCCESS", "SpiritBomb", 1242259)
	self:Log("SPELL_AURA_REMOVED", "SoulcrushRemoved", 1242284)
	self:Log("SPELL_AURA_APPLIED", "ExpulsedSoulApplied", 1242304)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExpulsedSoulApplied", 1242304)
	-- Intermission: The Unrelenting Pain
	self:Log("SPELL_CAST_SUCCESS", "InfernalStrike", 1233672)
	-- self:Log("SPELL_CAST_START", "FelDevastation", 1227117)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WitheringFlamesApplied", 1233381)
	self:Death("IlyssaDarksorrowDeath", 237662)
	-- Mythic
	self:Log("SPELL_CAST_START", "Eradicate", 1245726)
	self:Log("SPELL_CAST_START", "SigilOfChains", 1240891)

	timers = self:Mythic() and timersMythic or self:Easy() and timersEasy or timersHeroic
end

function mod:OnEngage()
	bossesKilled = 0

	-- Adarus Duskblaze
	adarusAlive = true
	devourersIreOnMe = false
	voidstepCount = 1
	voidstepTotalCount = 1
	eradicateTotalCount = 1
	eradicateCount = 1

	self:Bar(1227355, self:Mythic() and 26.6 or self:Easy() and 33.1 or 32.7, CL.count:format(self:SpellName(1227355), voidstepTotalCount)) -- Voidstep
	if self:Mythic() then
		self:Bar(1245726, 53.5, CL.count:format(self:SpellName(1245726), eradicateTotalCount)) -- Eradicate
	end

	-- Velaryn Bloodwrath
	velarynAlive = true
	theHuntCount = 1
	theHuntTotalCount = 1
	bladeDanceCount = 1
	bladeDanceTotalCount = 1
	eyeBeamCount = 1
	eyeBeamTotalCount = 1
	self:Bar(1227809, self:Mythic() and 41.9 or self:Easy() and 43.1 or 42.5, CL.count:format(CL.soak, theHuntTotalCount)) -- The Hunt
	if self:Melee() then
		self:Bar(1241306, self:Mythic() and 29.3 or 30.0, CL.count:format(CL.dodge, bladeDanceTotalCount)) -- Blade Dance
	end
	self:Bar(1218103, self:Mythic() and 19.6 or self:Easy() and 19.8 or 19.5, CL.count:format(self:SpellName(1218103), eyeBeamTotalCount)) -- Eye Beam

	-- Ilyssa Darksorrow
	ilyssaAlive = true
	fractureCount = 1
	fractureTotalCount = 1
	spiritBombCount = 1
	spiritBombTotalCount = 1
	sigilOfChainsCount = 1
	sigilOfChainsTotalCount = 1

	self:Bar(1241833, 15.0, CL.count:format(self:SpellName(1241833), fractureTotalCount)) -- Fracture
	self:Bar(1242259, self:Mythic() and 35.1 or self:Easy() and 35.9 or 35.5, CL.count:format(CL.raid_damage, spiritBombTotalCount)) -- Spirit Bomb
	if self:Mythic() then
		-- Until sigil activates/pulls
		self:Bar(1240891, 42.0, CL.count:format(CL.pull_in, sigilOfChainsTotalCount)) -- Sigil of Chains
	end

	-- Intermission 1
	metaCount = 1
	self:CDBar("stages", self:Mythic() and 112.4 or self:Easy() and 110.0 or 108.5, CL.count:format(CL.intermission, metaCount), 1233093) -- Collapsing Star
end

--------------------------------------------------------------------------------
-- Event Handlers
--
do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 1233388 or spellId == 1234694 or spellId == 1234724 then -- Meta Land USCS Events
			local time = GetTime()
			if time - prev > 3 then -- end of intermission
				prev = time

				-- reset for timers, totalcount on the bars
				voidstepCount = 1
				theHuntCount = 1
				bladeDanceCount = 1
				eyeBeamCount = 1
				fractureCount = 1
				spiritBombCount = 1
				sigilOfChainsCount = 1
				eradicateCount = 1

				local shortStage = self:Mythic() and metaCount == 4 and true or false

				-- Adarus Duskblaze
				if adarusAlive then
					self:Bar(1227355, shortStage and 9.3 or timers[1227355][1], CL.count:format(self:SpellName(1227355), voidstepTotalCount)) -- Voidstep
					if self:Mythic() and not shortStage then
						self:Bar(1245726, timers[1245726][1], CL.count:format(self:SpellName(1245726), eradicateTotalCount)) -- Eradicate
					end
				end

				-- Velaryn Bloodwrath
				if velarynAlive then
					self:Bar(1227809, shortStage and 7.7 or timers[1227809][1], CL.count:format(CL.soak, theHuntTotalCount)) -- The Hunt
					if self:Melee() and not shortStage then
						self:Bar(1241306, timers[1241306][1], CL.count:format(CL.dodge, bladeDanceTotalCount)) -- Blade Dance
					end
					if not shortStage then
						self:Bar(1218103, timers[1218103][1], CL.count:format(self:SpellName(1218103), eyeBeamTotalCount)) -- Eye Beam
					end
				end

				-- Ilyssa Darksorrow
				if ilyssaAlive then
					self:Bar(1241833, shortStage and 4.7 or timers[1241833][1], CL.count:format(self:SpellName(1241833), fractureTotalCount)) -- Fracture
					self:Bar(1242259, shortStage and 17.9 or timers[1242259][1], CL.count:format(CL.raid_damage, spiritBombTotalCount)) -- Spirit Bomb
					if self:Mythic() and not shortStage then
						self:Bar(1240891, timers[1240891][1], CL.count:format(CL.pull_in, sigilOfChainsTotalCount)) -- Sigil of Chains
					end
				end

				local nextMetaIcon = metaCount == 4 and 1231501 or metaCount == 3 and 1227117 or 1233863 -- All Meta, Fel Rush, Fel Devastation
				local cd = shortStage and 22.5 or 101.7
				if self:Heroic() then
					cd = metaCount == 4 and 62.5 or metaCount == 3 and 99.4 or 96.6
				end
				self:Bar("stages", cd, CL.count:format(CL.intermission, metaCount), nextMetaIcon) -- Intermission

				self:Message("stages", "green", CL.over:format(CL.intermission), false) -- Intermission Over
				self:PlaySound("stages", "long")
			end
		end
	end
end

do
	local prev = 0
	function mod:Metamorphosis(args)
		if args.time - prev > 10 then -- next intermission
			prev = args.time
			infernalStrikeCount = 1
			local msg = CL.count:format(CL.intermission, metaCount)
			metaCount = metaCount + 1
			self:StopBar(msg)
			self:Message("stages", "cyan", msg, false) -- Intermission
			self:PlaySound("stages", "long")
		end
	end
end

function mod:DevourersIreApplied(args)
	if self:Me(args.destGUID) then
		devourersIreOnMe = true
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:DevourersIreRemoved(args)
	if self:Me(args.destGUID) then
		devourersIreOnMe = false
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info", nil, args.destName) -- no more damge incoming from consume
	end
end

function mod:UnendingHungerApplied(args)
	if self:Me(args.destGUID) then
		local highStacks = 3
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, highStacks)
		if amount >= highStacks then -- high stacks
			self:PlaySound(args.spellId, "warning", nil, args.destName) -- high stacks
		end
	end
end

function mod:Voidstep(args)
	local msg = CL.count:format(args.spellName, voidstepTotalCount)
	voidstepTotalCount = voidstepTotalCount + 1
	voidstepCount = voidstepCount + 1
	self:StopBar(msg)
	self:Message(args.spellId, "cyan", msg)
	local totalExpectedCasts = self:Mythic() and 7 or self:Heroic() and 11 or 12
	if voidstepTotalCount <= totalExpectedCasts then
		self:Bar(args.spellId, timers[args.spellId][voidstepCount], CL.count:format(args.spellName, voidstepTotalCount))
	end
	self:PlaySound(args.spellId, "info") -- boss moving
end

do
	local prev = 0
	function mod:HungeringSlashDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
		end
	end
end

do
	local prev = 0
	function mod:EncroachingOblivionDamage(args)
		if not devourersIreOnMe -- You can soak void if you have Devourer's Ire so don't warn.
		    and self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
		end
	end
end

-- Intermission: The Ceaseless Hunger
function mod:CollapsingStar(args)
	if metaCount <= 3 then
		self:CastBar("stages", 25, CL.intermission:format(1), args.spellId)
	end
end

function mod:DarkResidueApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:DarkResidueRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info", nil, args.destName)
	end
end

do
	local prev = 0
	function mod:EventHorizonDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
		end
	end
end

do
	local prev, subCount = 0, 1
	function mod:Eradicate(args)
		if args.time - prev > 20 then -- new set
			prev = args.time
			subCount = 1
			self:StopBar(CL.count:format(args.spellName, eradicateTotalCount))
			self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, subCount, 4))
			eradicateTotalCount = eradicateTotalCount + 1
			eradicateCount = eradicateCount + 1
			self:Bar(args.spellId, timers[args.spellId][eradicateCount], CL.count:format(args.spellName, eradicateTotalCount))
			self:Bar(args.spellId, 5, CL.count_amount:format(args.spellName, subCount + 1, 4))
			self:PlaySound(args.spellId, "info")
		else
			subCount = subCount + 1
			self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, subCount, 4))
			if subCount < 4 then
				self:Bar(args.spellId, 5, CL.count_amount:format(args.spellName, subCount + 1, 4))
			end
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:AdarusDuskblazeDeath(args)
	bossesKilled = bossesKilled + 1
	adarusAlive = false
	self:StopBar(CL.count:format(self:SpellName(1227355), voidstepTotalCount)) -- Voidstep
	if bossesKilled < 3 then
		self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	end
end

-- Velaryn Bloodwrath
do
	local subCount = 1
	function mod:TheHuntApplied(args)
		if self:MobId(args.sourceGUID) == 237660 then -- Velaryn Bloodwrath
			self:StopBar(CL.count:format(CL.soak, theHuntTotalCount))
			subCount = 1
			local messageText = CL.count:format(CL.soak, theHuntTotalCount)
			if self:Mythic() then
				messageText = CL.count_amount:format(CL.soak, subCount, 3)
			end
			self:TargetMessage(1227809, "orange", args.destName, messageText)
			theHuntCount = theHuntCount + 1
			theHuntTotalCount = theHuntTotalCount + 1
			local totalExpectedCasts = self:Easy() and 8 or 7
			if theHuntTotalCount <= totalExpectedCasts then
				self:Bar(1227809, timers[1227809][theHuntCount], CL.count:format(CL.soak, theHuntTotalCount))
			end
			self:PlaySound(1227809, "long") -- watch charge(s)
		else -- Should only happen in Mythic
			subCount = subCount + 1
			self:TargetMessage(1227809, "orange", args.destName, CL.count_amount:format(CL.soak, subCount, 3))
		end
		if self:Me(args.destGUID) then
			self:Yell(1227809, CL.soak, nil, "Soak")
			self:YellCountdown(1227809, 6, CL.soak, nil, "Soak")
			self:PlaySound(1227809, "warning") -- line up / immune
		end
	end
end

function mod:BladeDance()
	if self:Melee() then
		self:StopBar(CL.count:format(CL.dodge, bladeDanceTotalCount))
		self:Message(1241306, "red", CL.count:format(CL.dodge, bladeDanceTotalCount))
		bladeDanceCount = bladeDanceCount + 1
		bladeDanceTotalCount = bladeDanceTotalCount + 1
		local totalExpectedCasts = self:Mythic() and 9 or self:Heroic() and 11 or 12
		if bladeDanceTotalCount <= totalExpectedCasts then
			self:Bar(1241306, timers[1241306][bladeDanceCount], CL.count:format(CL.dodge, bladeDanceTotalCount))
		end
		self:PlaySound(1241306, "alert") -- watch dances
	end
end

function mod:EyeBeam(args)
	self:StopBar(CL.count:format(args.spellName, eyeBeamTotalCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, eyeBeamTotalCount))
	eyeBeamCount = eyeBeamCount + 1
	eyeBeamTotalCount = eyeBeamTotalCount + 1
	local totalExpectedCasts = self:Mythic() and 9 or self:Heroic() and 11 or 12
	if eyeBeamTotalCount <= totalExpectedCasts then
		self:Bar(args.spellId, timers[args.spellId][eyeBeamCount], CL.count:format(args.spellName, eyeBeamTotalCount))
	end
	-- self:PlaySound(args.spellId, "alert") -- Sounds from getting hit is enough.
end

function mod:FelSingedApplied(args)
	if self:Me(args.destGUID) then -- does the offtank need to know?
		local amount = args.amount or 1
		if amount % 2 == 0 then -- 2 / 4 / 6 / 8 (assuming it ends at 8 if you take the full beam)
			self:StackMessage(args.spellId, "blue", args.destName, amount, 6)
			self:PlaySound(args.spellId, "alarm", nil, args.destName)
		end
	end
end

function mod:FelbladeApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- big dot
	end
end

function mod:FelRushApplied(args)
	if metaCount <= 3 then
		self:CastBar("stages", 24, CL.intermission:format(2), args.spellId)
	end
end

function mod:VelarynBloodwrathDeath(args)
	bossesKilled = bossesKilled + 1
	velarynAlive = false
	self:StopBar(CL.count:format(CL.soak, theHuntTotalCount)) -- The Hunt
	self:StopBar(CL.count:format(CL.dodge, bladeDanceTotalCount)) -- Blade Dance
	self:StopBar(CL.count:format(self:SpellName(1218103), eyeBeamTotalCount)) -- Eye Beam
	if bossesKilled < 3 then
		self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	end
end

-- Ilyssa Darksorrow
function mod:Fracture(args)
	self:StopBar(CL.count:format(args.spellName, fractureTotalCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, fractureTotalCount))
	fractureCount = fractureCount + 1
	fractureTotalCount = fractureTotalCount + 1
	local totalExpectedCasts = self:Mythic() and 10 or self:Heroic() and 11 or 12
	if fractureTotalCount <= totalExpectedCasts then
		self:Bar(args.spellId, timers[args.spellId][fractureCount], CL.count:format(args.spellName, fractureTotalCount))
	end
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm", nil, self:UnitName("player")) -- defensive
	end
end

function mod:ShatteredSoulApplied(args)
	if self:Me(args.destGUID) then -- does the offtank need to know?
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "info", nil, args.destName)
	end
end

function mod:FrailtyTankRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(1241946, "green", CL.removed:format(args.spellName))
		self:PlaySound(1241946, "info", nil, args.destName) -- saved
	end
end

function mod:FrailtySoakApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 2)
		if amount >= 2 then
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- watch health
		else
			self:PlaySound(args.spellId, "info", nil, args.destName)
		end
	end
end

function mod:SpiritBomb(args)
	self:StopBar(CL.count:format(CL.raid_damage, spiritBombTotalCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.raid_damage, spiritBombTotalCount))
	spiritBombCount = spiritBombCount + 1
	spiritBombTotalCount = spiritBombTotalCount + 1
	local totalExpectedCasts = self:Mythic() and 10 or self:Heroic() and 11 or 12
	if spiritBombTotalCount <= totalExpectedCasts then
		self:Bar(args.spellId, timers[args.spellId][spiritBombCount], CL.count:format(CL.raid_damage, spiritBombTotalCount))
	end
	self:PlaySound(args.spellId, "alarm") -- raid damage
end

function mod:SoulcrushRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(CL.heal_absorb))
		self:PlaySound(args.spellId, "info", nil, args.destName) -- heal absorb removed
	end
end

do
	local prev = 0
	function mod:ExpulsedSoulApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning") -- failed, big raid damage
		end
	end
end

-- Intermission: The Unrelenting Pain
function mod:InfernalStrike(args)
	local text = metaCount == 5 and CL.count:format(CL.leap, infernalStrikeCount) or CL.count_amount:format(CL.leap, infernalStrikeCount, 3)
	self:Message(args.spellId, "red", text)
	infernalStrikeCount = infernalStrikeCount + 1
	if metaCount > 4 or infernalStrikeCount <= 3 then -- 3 total in first intermission, infinite on last meta
		local nextText = metaCount == 5 and CL.count:format(CL.leap, infernalStrikeCount) or CL.count_amount:format(CL.leap, infernalStrikeCount, 3)
		self:Bar(args.spellId, 9, nextText)
	end
	if metaCount <= 4 and infernalStrikeCount == 1 then
		self:CastBar("stages", 25.5, CL.intermission:format(3), args.spellId)
	end
	self:PlaySound(args.spellId, "warning") -- watch leap location
end

-- function mod:FelDevastation(args) -- overkill? already have the leap warning, always happens after.
-- 	self:Message(args.spellId, "orange", CL.breath)
-- 	self:PlaySound(args.spellId, "alert") -- move out if inside
-- end

function mod:WitheringFlamesApplied(args)
	if self:Me(args.destGUID) then
		if args.amount % 5 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 10)
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- high stacks
		end
	end
end

-- Mythic
function mod:SigilOfChains(args)
	local prevTimer = timers[args.spellId][sigilOfChainsCount]
	if prevTimer then
		prevTimer = prevTimer + 2.5 -- add 2.5 seconds for cast
		self:Bar(args.spellId, {2.5, prevTimer}, CL.count:format(CL.pull_in, sigilOfChainsTotalCount))
	end
	self:Message(args.spellId, "yellow", CL.soon:format(CL.count:format(CL.pull_in, sigilOfChainsTotalCount)))
	sigilOfChainsCount = sigilOfChainsCount + 1
	sigilOfChainsTotalCount = sigilOfChainsTotalCount + 1
	local timer = timers[args.spellId][sigilOfChainsCount]
	if timer > 0 then
		timer = timer + 2.5
	end
	self:Bar(args.spellId, timer, CL.count:format(CL.pull_in, sigilOfChainsTotalCount))
	self:PlaySound(args.spellId, "warning") -- pull in
end

function mod:IlyssaDarksorrowDeath(args)
	bossesKilled = bossesKilled + 1
	ilyssaAlive = false
	self:StopBar(CL.count:format(self:SpellName(1241833), fractureTotalCount)) -- Fracture
	self:StopBar(CL.count:format(CL.raid_damage, spiritBombTotalCount)) -- Spirit Bomb
	self:StopBar(CL.count:format(CL.pull_in, sigilOfChainsTotalCount)) -- Sigil of Chains
	self:StopBar(CL.count:format(CL.leap, infernalStrikeCount)) -- Infernal Strike
	if bossesKilled < 3 then
		self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	end
end
