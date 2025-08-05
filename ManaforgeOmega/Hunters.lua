if not BigWigsLoader.isNext then return end

-- XXX What happens with intermisoin/ultimates if they die?

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
local devourersIreOnMe = false
local voidstepCount = 1

-- Velaryn Bloodwrath
local theHuntCount = 1
local bladeDanceCount = 1
local eyeBeamCount = 1

-- Ilyssa Darksorrow
local fractureCount = 1
local spiritBombCount = 1
local sigilOfChainsCount = 1
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")
	self:Log("SPELL_CAST_START", "Metamorphosis", 1231501, 1232568, 1232569) -- Meta Cast to track intermissions

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
	self:Log("SPELL_CAST_SUCCESS", "BladeDance", 1241306)
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
	devourersIreOnMe = false
	voidstepCount = 1

	self:Bar(1227355, 31.5, CL.count:format(self:SpellName(1227355), voidstepCount)) -- Voidstep

	-- Velaryn Bloodwrath
	theHuntCount = 1
	bladeDanceCount = 1
	eyeBeamCount = 1
	self:Bar(1227809, 40.5, CL.count:format(CL.soak, theHuntCount)) -- The Hunt
	self:Bar(1241306, 30.0, CL.count:format(CL.dodge, bladeDanceCount)) -- Blade Dance
	self:Bar(1218103, 19.3, CL.count:format(self:SpellName(1218103), eyeBeamCount)) -- Eye Beam

	-- Ilyssa Darksorrow
	fractureCount = 1
	spiritBombCount = 1
	sigilOfChainsCount = 1

	self:Bar(1241833, 15.0, CL.count:format(self:SpellName(1241833), fractureCount)) -- Fracture
	self:Bar(1242259, 31.3, CL.count:format(CL.raid_damage, spiritBombCount)) -- Spirit Bomb
	if self:Mythic() then
		self:Bar(1240891, 38, CL.count:format(CL.pull_in, sigilOfChainsCount)) -- Sigil of Chains
	end

	-- Intermission 1
	metaCount = 1
	self:Bar("stages", 102.0, CL.count:format(CL.intermission, metaCount), 1233093) -- Collapsing Star
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 1241254 then -- Blade Dance
		self:BladeDance()
	end
end

do
	local prev = 0
	function mod:Metamorphosis(args)
		if args.time - prev > 10 then -- next intermission
			prev = args.time
			metaCount = metaCount + 1
			local cd = nil
			local icon = args.spellId
			if metaCount == 2 then
				cd = 122
				icon = 1233863 -- Fel Rush
			elseif metaCount == 3 then
				cd = 122
				icon = 1227117 -- Fel Devastation
			elseif metaCount == 4 then -- All Next
				cd = 52
			end
			self:Message("stages", "cyan", CL.count:format(CL.intermission, metaCount - 1), false) -- Intermission
			self:PlaySound("stages", "long")
			self:Bar("stages", cd, CL.count:format(CL.intermission, metaCount), icon)

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
	self:StopBar(CL.count:format(args.spellName, voidstepCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, voidstepCount))
	self:PlaySound(args.spellId, "info") -- boss moving
	voidstepCount = voidstepCount + 1
	if voidstepCount <= 5 then -- 5 in total, not used during the 2nd part of the encounter. bugged?
		local cd = voidstepCount % 3 == 2 and 29 or voidstepCount % 3 == 0 and 26.2 or 67.3
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, voidstepCount))
	end
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
	self:StopBar(CL.count:format(self:SpellName(1227355), voidstepCount)) -- Voidstep
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled), false)
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
			self:StopBar(CL.count:format(CL.soak, theHuntCount))
			subCount = 1
			local messageText = CL.count:format(CL.soak, theHuntCount)
			if self:Mythic() then
				messageText = CL.count_amount:format(messageText, subCount, 3)
			end
			self:Message(args.spellId, "orange", messageText)
			self:PlaySound(args.spellId, "long") -- watch charge(s)
			theHuntCount = theHuntCount + 1
			if theHuntCount <= 7 then  -- 7 in total
				local cd = theHuntCount == 7 and 69.9 or theHuntCount % 2 == 1 and 89.9 or 32.6
				self:Bar(args.spellId, cd, CL.count:format(CL.soak, theHuntCount))
			end
		else -- Should only happen in Mythic
			subCount = subCount + 1
			self:Message(args.spellId, "orange", CL.count_amount:format(CL.count:format(CL.soak, theHuntCount - 1), subCount, 3))
		end
	end
end

function mod:BladeDance()
	self:StopBar(CL.count:format(CL.dodge, bladeDanceCount))
	self:Message(1241306, "red", CL.count:format(CL.dodge, bladeDanceCount))
	self:PlaySound(1241306, "alert") -- watch dances
	bladeDanceCount = bladeDanceCount + 1
	if bladeDanceCount <= 9 then -- 9 total
		local cd = bladeDanceCount % 3 == 1 and 57.3 or 32.6
		self:Bar(1241306, cd, CL.count:format(CL.dodge, bladeDanceCount))
	end
end

function mod:EyeBeam(args)
	self:StopBar(CL.count:format(args.spellName, eyeBeamCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, eyeBeamCount))
	-- self:PlaySound(args.spellId, "alert") -- Sounds from getting hit is enough.
	eyeBeamCount = eyeBeamCount + 1
	if eyeBeamCount <= 9 then -- 9 total
		local cd = eyeBeamCount % 3 == 1 and 57.3 or 32.6
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, eyeBeamCount))
	end
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
	self:StopBar(CL.count:format(CL.soak, theHuntCount)) -- The Hunt
	self:StopBar(CL.count:format(CL.dodge, bladeDanceCount)) -- Blade Dance
	self:StopBar(CL.count:format(self:SpellName(1218103), eyeBeamCount)) -- Eye Beam
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled), false)
end

-- Ilyssa Darksorrow
function mod:Fracture(args)
	self:StopBar(CL.count:format(args.spellName, fractureCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, fractureCount))
	fractureCount = fractureCount + 1
	if fractureCount <= 10 then -- 10 total
		local cd = fractureCount % 3 == 1 and 57.3 or 32.6
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, fractureCount))
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
	self:StopBar(CL.count:format(CL.raid_damage, spiritBombCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.raid_damage, spiritBombCount))
	self:PlaySound(args.spellId, "alarm") -- raid damage
	spiritBombCount = spiritBombCount + 1
	if spiritBombCount <= 10 then -- 10 total
		local cd = spiritBombCount % 3 == 1 and 57.3 or 32.6
		self:Bar(args.spellId, cd, CL.count:format(CL.raid_damage, spiritBombCount))
	end
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
	self:Message(args.spellId, "yellow", CL.count:format(CL.pull_in, sigilOfChainsCount))
	self:PlaySound(args.spellId, "warning") -- pull in
	sigilOfChainsCount = sigilOfChainsCount + 1
	if sigilOfChainsCount <= 6 then -- 6 total
		local cd = sigilOfChainsCount % 2 == 1 and 90.9 or 32.0
		self:Bar(args.spellId, cd, CL.count:format(CL.pull_in, sigilOfChainsCount))
	end
end

function mod:IlyssaDarksorrowDeath(args)
	self:StopBar(CL.count:format(self:SpellName(1241833), fractureCount)) -- Fracture
	self:StopBar(CL.count:format(CL.raid_damage, spiritBombCount)) -- Spirit Bomb
	self:StopBar(CL.count:format(CL.pull_in, sigilOfChainsCount)) -- Sigil of Chains
	self:StopBar(CL.count:format(CL.leap, infernalStrikeCount)) -- Infernal Strike
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled), false)
end
