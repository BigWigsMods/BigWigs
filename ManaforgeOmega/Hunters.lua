
-- TODO:
-- -- XXX What happens with intermission/ultimates if they die?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Soul Hunters", 2810, 2688)
if not mod then return end
mod:RegisterEnableMob(237661, 248404, 237662) -- Adarus Duskblaze, Velaryn Bloodwrath, Ilyssa Darksorrow
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
			{1222232, 1222310, 1227355, 1227685, 1235045, 1233105, 1233968},
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3") -- Blade Dance & Intermission end
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
	self:Log("SPELL_AURA_APPLIED", "EventHorizonDamage", 1233968)
	self:Log("SPELL_PERIODIC_DAMAGE", "EventHorizonDamage", 1233968)
	self:Log("SPELL_PERIODIC_MISSED", "EventHorizonDamage", 1233968)
	self:Death("AdarusDuskblazeDeath", 237661)

	-- Velaryn Bloodwrath
	self:Log("SPELL_CAST_START", "TheHunt", 1227809)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- The Hunt Targets
	self:Log("SPELL_CAST_SUCCESS", "BladeDance", 1241254)
	self:Log("SPELL_CAST_START", "EyeBeam", 1218103)
	self:Log("SPELL_AURA_APPLIED", "FelSingedApplied", 1221490)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelSingedApplied", 1221490)
	self:Log("SPELL_AURA_APPLIED", "FelbladeApplied", 1225130)
	self:Log("SPELL_AURA_APPLIED", "FelRushApplied", 1233863)
	-- Intermission: The Demon Within
	self:Death("VelarynBloodwrathDeath", 248404)

	-- Ilyssa Darksorrow
	self:Log("SPELL_CAST_START", "Fracture", 1241833)
	self:Log("SPELL_AURA_APPLIED", "ShatteredSoulApplied", 1226493)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatteredSoulApplied", 1226493)
	self:Log("SPELL_AURA_REMOVED", "FrailtyTankRemoved", 1241917)
	self:Log("SPELL_AURA_APPLIED", "FrailtySoakApplied", 1241946)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrailtySoakApplied", 1241946)
	self:Log("SPELL_CAST_START", "SpiritBomb", 1242259)
	self:Log("SPELL_AURA_REMOVED", "SoulcrushRemoved", 1242284)
	self:Log("SPELL_AURA_APPLIED", "ExpulsedSoulApplied", 1242304)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExpulsedSoulApplied", 1242304)
	-- Intermission: The Unrelenting Pain
	self:Log("SPELL_CAST_SUCCESS", "InfernalStrike", 1233672)
	-- self:Log("SPELL_CAST_START", "FelDevastation", 1227117)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WitheringFlamesApplied", 1233381)
	self:Death("IlyssaDarksorrowDeath", 237662)
	-- Mythic
	self:Log("SPELL_CAST_START", "SigilOfChains", 1240891)
end

function mod:OnEngage()
	bossesKilled = 0
	-- Adarus Duskblaze
	adarusAlive = true
	devourersIreOnMe = false
	voidstepCount = 1
	voidstepTotalCount = 1

	self:Bar(1227355, self:Easy() and 33.1 or 32.7, CL.count:format(self:SpellName(1227355), voidstepTotalCount)) -- Voidstep

	-- Velaryn Bloodwrath
	velarynAlive = true
	theHuntCount = 1
	theHuntTotalCount = 1
	bladeDanceCount = 1
	bladeDanceTotalCount = 1
	eyeBeamCount = 1
	eyeBeamTotalCount = 1
	self:Bar(1227809, self:Easy() and 43.1 or 42.5, CL.count:format(CL.soak, theHuntTotalCount)) -- The Hunt
	if self:Melee() then
		self:Bar(1241306, 30.0, CL.count:format(CL.dodge, bladeDanceTotalCount)) -- Blade Dance
	end
	self:Bar(1218103, self:Easy() and 19.8 or 19.5, CL.count:format(self:SpellName(1218103), eyeBeamTotalCount)) -- Eye Beam

	-- Ilyssa Darksorrow
	ilyssaAlive = true
	fractureCount = 1
	fractureTotalCount = 1
	spiritBombCount = 1
	spiritBombTotalCount = 1
	sigilOfChainsCount = 1
	sigilOfChainsTotalCount = 1

	self:Bar(1241833, 15.0, CL.count:format(self:SpellName(1241833), fractureTotalCount)) -- Fracture
	self:Bar(1242259, self:Easy() and 32.9 or 32.5, CL.count:format(CL.raid_damage, spiritBombTotalCount)) -- Spirit Bomb
	if self:Mythic() then
		self:Bar(1240891, 38, CL.count:format(CL.pull_in, sigilOfChainsTotalCount)) -- Sigil of Chains
	end

	-- Intermission 1
	metaCount = 1
	self:CDBar("stages", self:Easy() and 110.0 or 108.5, CL.count:format(CL.intermission, metaCount), 1233093) -- Collapsing Star
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
				self:Message("stages", "green", CL.over:format(CL.intermission), false) -- Intermission Over
				self:PlaySound("stages", "long")

				-- reset for timers, totalcount on the bars
				voidstepCount = 1
				theHuntCount = 1
				bladeDanceCount = 1
				eyeBeamCount = 1
				fractureCount = 1
				spiritBombCount = 1
				sigilOfChainsCount = 1

				-- Adarus Duskblaze
				if adarusAlive then
					self:Bar(1227355, self:Easy() and 21.5 or 21.0, CL.count:format(self:SpellName(1227355), voidstepTotalCount)) -- Voidstep
				end

				-- Velaryn Bloodwrath
				if velarynAlive then
					self:Bar(1227809, self:Easy() and 31.6 or 30.9, CL.count:format(CL.soak, theHuntTotalCount)) -- The Hunt
					if self:Melee() then
						self:Bar(1241306, self:Easy() and 18.4 or 18.0, CL.count:format(CL.dodge, bladeDanceTotalCount)) -- Blade Dance
					end
					self:Bar(1218103, 8.1, CL.count:format(self:SpellName(1218103), eyeBeamTotalCount)) -- Eye Beam
				end

				-- Ilyssa Darksorrow
				if ilyssaAlive then
					self:Bar(1241833, 3.5, CL.count:format(self:SpellName(1241833), fractureTotalCount)) -- Fracture
					self:Bar(1242259, self:Easy() and 21.3 or 20.9, CL.count:format(CL.raid_damage, spiritBombTotalCount)) -- Spirit Bomb
					if self:Mythic() then
						self:Bar(1240891, 26.4, CL.count:format(CL.pull_in, sigilOfChainsTotalCount)) -- Sigil of Chains
					end
				end

				local nextMetaIcon = metaCount == 4 and 1231501 or metaCount == 3 and 1227117 or 1233863 -- All Meta, Fel Rush, Fel Devastation
				local cd = metaCount == 3 and 99.4 or 96.6
				if self:Easy() then
					cd = 101.7
				end
				self:Bar("stages", cd, CL.count:format(CL.intermission, metaCount), nextMetaIcon) -- Intermission
			end
		end
	end
end

do
	local prev = 0
	function mod:Metamorphosis(args)
		if args.time - prev > 10 then -- next intermission
			prev = args.time
			self:StopBar(CL.count:format(CL.intermission, metaCount))
			self:Message("stages", "cyan", CL.count:format(CL.intermission, metaCount), false) -- Intermission
			self:PlaySound("stages", "long")
			metaCount = metaCount + 1
			infernalStrikeCount = 1
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
	self:StopBar(CL.count:format(args.spellName, voidstepTotalCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, voidstepTotalCount))
	self:PlaySound(args.spellId, "info") -- boss moving
	voidstepCount = voidstepCount + 1
	voidstepTotalCount = voidstepTotalCount + 1
	local voidstepTimers = {21.0, 31.0, 28.1, 0}
	if self:Easy() then
		voidstepTimers = {21.5, 31.7, 28.7, 0}
	end
	local cd = voidstepTimers[voidstepCount]
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, voidstepTotalCount))
end

do
	local prev = 0
	function mod:HungeringSlashDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

do
	local prev = 0
	function mod:EncroachingOblivionDamage(args)
		if not devourersIreOnMe -- You can soak void if you have Devourer's Ire so don't warn.
		    and self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Intermission: The Ceaseless Hunger
function mod:CollapsingStar(args)
	if metaCount > 3 then return end
	self:CastBar("stages", 25, CL.intermission:format(1), args.spellId)
end

function mod:DarkResidueApplied(args)
	if self:Me(args.destGUID) then
		local highStacks = 3
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "yellow", args.destName, amount, highStacks)
		if amount >= highStacks then
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- high stacks
		else
			self:PlaySound(args.spellId, "info", nil, args.destName) -- low stacks
		end
	end
end

do
	local prev = 0
	function mod:EventHorizonDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:AdarusDuskblazeDeath(args)
	self:StopBar(CL.count:format(self:SpellName(1227355), voidstepTotalCount)) -- Voidstep
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	adarusAlive = false
end

-- Velaryn Bloodwrath
function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	-- -- |TInterface\\\\ICONS\\\\INV_Ability_DemonHunter_TheHunt.BLP:20|t Velaryn targets abc with |cFFFF0000|Hspell:1227809|h[The Hunt]|h|r!#abc-Realm",
	if msg:find("spell:1227809", nil, true) then
		self:Yell(1227809, CL.soak, nil, "Soak")
		self:YellCountdown(1227809, 6, "Soak")
	end
end

do
	local subCount = 1
	function mod:TheHunt(args)
		if self:MobId(args.sourceGUID) == 237660 then -- Velaryn Bloodwrath
			self:StopBar(CL.count:format(CL.soak, theHuntTotalCount))
			subCount = 1
			local messageText = CL.count:format(CL.soak, theHuntTotalCount)
			if self:Mythic() then
				messageText = CL.count_amount:format(CL.soak, subCount, 3)
			end
			self:Message(args.spellId, "orange", messageText)
			self:PlaySound(args.spellId, "long") -- watch charge(s)
			theHuntCount = theHuntCount + 1
			theHuntTotalCount = theHuntTotalCount + 1
			local theHuntTimers = {30.9, 34.9, 0}
			if self:Easy() then
				theHuntTimers = {31.6, 35.7, 0}
			end
			self:Bar(args.spellId, theHuntTimers[theHuntCount], CL.count:format(CL.soak, theHuntTotalCount))
		else -- Should only happen in Mythic
			subCount = subCount + 1
			self:Message(args.spellId, "orange", CL.count_amount:format(CL.soak, subCount, 3))
		end
	end
end

function mod:BladeDance()
	if self:Melee() then
		self:StopBar(CL.count:format(CL.dodge, bladeDanceTotalCount))
		self:Message(1241306, "red", CL.count:format(CL.dodge, bladeDanceTotalCount))
		self:PlaySound(1241306, "alert") -- watch dances
		bladeDanceCount = bladeDanceCount + 1
		bladeDanceTotalCount = bladeDanceTotalCount + 1
		local bladeDanceTimers = {18.0, 34.8, 36.6, 0}
		if self:Easy() then
			bladeDanceTimers = {18.4, 35.7, 37.5, 0}
		end
		self:Bar(1241306, bladeDanceTimers[bladeDanceCount], CL.count:format(CL.dodge, bladeDanceTotalCount))
	end
end

function mod:EyeBeam(args)
	self:StopBar(CL.count:format(args.spellName, eyeBeamTotalCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, eyeBeamTotalCount))
	-- self:PlaySound(args.spellId, "alert") -- Sounds from getting hit is enough.
	eyeBeamCount = eyeBeamCount + 1
	eyeBeamTotalCount = eyeBeamTotalCount + 1
	local eyeBeamTimers = {8.1, 34.9, 34.9, 0}
	if self:Easy() then
		eyeBeamTimers = {8.2, 35.7, 35.7, 0}
	end
	self:Bar(args.spellId, eyeBeamTimers[eyeBeamCount], CL.count:format(args.spellName, eyeBeamTotalCount))
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
	if metaCount > 3 then return end
	self:CastBar("stages", 24, CL.intermission:format(2), args.spellId)
end

function mod:VelarynBloodwrathDeath(args)
	self:StopBar(CL.count:format(CL.soak, theHuntTotalCount)) -- The Hunt
	self:StopBar(CL.count:format(CL.dodge, bladeDanceTotalCount)) -- Blade Dance
	self:StopBar(CL.count:format(self:SpellName(1218103), eyeBeamTotalCount)) -- Eye Beam
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	velarynAlive = false
end

-- Ilyssa Darksorrow
function mod:Fracture(args)
	self:StopBar(CL.count:format(args.spellName, fractureTotalCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, fractureTotalCount))
	fractureCount = fractureCount + 1
	fractureTotalCount = fractureTotalCount + 1
	local fractureTimers = {3.5, 34.9, 34.9, 0}
	if self:Easy() then
		fractureTimers = {3.5, 35.7, 35.7, 0}
	end
	self:Bar(args.spellId, fractureTimers[fractureCount], CL.count:format(args.spellName, fractureTotalCount))
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
	self:PlaySound(args.spellId, "alarm") -- raid damage
	spiritBombCount = spiritBombCount + 1
	spiritBombTotalCount = spiritBombTotalCount + 1
	local spiritBombTimers = {20.9, 34.9, 34.9, 0}
	if self:Easy() then
		spiritBombTimers = {21.3, 35.7, 35.7, 0}
	end
	self:Bar(args.spellId, spiritBombTimers[spiritBombCount], CL.count:format(CL.raid_damage, spiritBombTotalCount))
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
	self:Message(args.spellId, "red", CL.leap)
	self:PlaySound(args.spellId, "warning") -- watch leap location
	infernalStrikeCount = infernalStrikeCount + 1
	if metaCount > 4 or infernalStrikeCount <= 3 then -- 3 total in first intermission, infinite on last meta
		self:Bar(args.spellId, 9, CL.count:format(CL.leap, infernalStrikeCount))
	end
	if metaCount <= 4 and infernalStrikeCount == 1 then
		self:CastBar("stages", 25.5, CL.intermission:format(3), args.spellId)
	end
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
	self:Message(args.spellId, "yellow", CL.count:format(CL.pull_in, sigilOfChainsTotalCount))
	self:PlaySound(args.spellId, "warning") -- pull in
	sigilOfChainsCount = sigilOfChainsCount + 1
	sigilOfChainsTotalCount = sigilOfChainsTotalCount + 1
	local sigilOfChainsTimers = {0, 31.9, 31.9, 0} -- Confirm on Mythic
	self:Bar(args.spellId, sigilOfChainsTimers[sigilOfChainsCount], CL.count:format(CL.pull_in, sigilOfChainsTotalCount))
end

function mod:IlyssaDarksorrowDeath(args)
	self:StopBar(CL.count:format(self:SpellName(1241833), fractureTotalCount)) -- Fracture
	self:StopBar(CL.count:format(CL.raid_damage, spiritBombTotalCount)) -- Spirit Bomb
	self:StopBar(CL.count:format(CL.pull_in, sigilOfChainsTotalCount)) -- Sigil of Chains
	self:StopBar(CL.count:format(CL.leap, infernalStrikeCount)) -- Infernal Strike
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	ilyssaAlive = false
end
