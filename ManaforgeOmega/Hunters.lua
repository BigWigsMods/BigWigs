if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Soul Hunters", 2810, 2688)
if not mod then return end
mod:RegisterEnableMob(237661, 248404, 237662) -- Adarus Duskblaze, Velaryn Bloodwrath, Ilyssa Darksorrow XXX Confirm
mod:SetEncounterID(3122)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

-- Adarus Duskblaze
local devourersIreOnMe = false
local devourersIreCount = 1
local consumeCount = 1
local voidstepCount = 1

-- Velaryn Bloodwrath
local theHuntCount = 1
local bladeDanceCount = 1
local eyeBeamCount = 1
local felInfernoCount = 1

-- Ilyssa Darksorrow
local fractureCount = 1
local spiritBombCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		-- Adarus Duskblaze
			1222232, -- Devourer's Ire
			1234565, -- Consume
				1222310, -- Unending Hunger
			1227355, -- Voidstep
				1227685, -- Hungering Slash
					1235045, -- Encroaching Oblivion
		-- Intermission: The Ceaseless Hunger
			1233093, -- Collapsing Star
				1233105, -- Dark Residue
				1233968, -- Event Horizon
		-- Velaryn Bloodwrath
			1227809, -- The Hunt
			1241306, -- Blade Dance
			1218103, -- Eye Beam
				1221490, -- Fel-Singed
				{1225130, "TANK"}, -- Felblade
			1245384, -- Fel Inferno
		-- Intermission: The Demon Within
			1233863, -- Fel Rush
		-- Ilyssa Darksorrow
			1241833, -- Fracture
				1226493, -- Shattered Soul
				1241946, -- Frailty
			1242259, -- Spirit Bomb
				1242284, -- Soulcrush
				1242304, -- Expulsed Soul
			-- 1225154, -- Immolation Aura XXX Permanent?
		-- Intermission: The Unrelenting Pain
			1227113, -- Infernal Strike
			1227117, -- Fel Devastation
				1233381, -- Withering Flames
	},{
		-- Tabs
		{
			tabName = self:SpellName(-32500), -- Adarus Duskblaze
			{1222232, 1234565, 1222310, 1227355, 1227685, 1235045, 1233093, 1233105, 1233968},
		},
		{
			tabName = self:SpellName(-31792), -- Velaryn Bloodwrath
			{1227809, 1241306, 1218103, 1221490, 1225130, 1245384, 1233863},
		},
		{
			tabName = self:SpellName(-31791), -- Ilyssa Darksorrow
			{1241833, 1226493, 1241946, 1242259, 1242284, 1242304, 1227113, 1227117, 1233381},
		},
		-- Sections
		[1233093] = -32566, -- Intermission: The Ceaseless Hunger
		[1233863] = -32552, -- Intermission: The Demon Within
		[1227113] = -32545, -- Intermission: The Unrelenting Pain
	}
end

function mod:OnBossEnable()
	-- Adarus Duskblaze
	self:Log("SPELL_CAST_SUCCESS", "DevourersIre", 1222232)
	self:Log("SPELL_AURA_APPLIED", "DevourersIreApplied", 1222232)
	self:Log("SPELL_AURA_REMOVED", "DevourersIreRemoved", 1222232)
	self:Log("SPELL_CAST_START", "Consume", 1234565)
	self:Log("SPELL_AURA_APPLIED", "UnendingHungerApplied", 1222310)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnendingHungerApplied", 1222310)
	self:Log("SPELL_CAST_START", "Voidstep", 1227355)
	self:Log("SPELL_DAMAGE", "HungeringSlashDamage", 1227685)
	self:Log("SPELL_MISSED", "HungeringSlashDamage", 1227685)
	self:Log("SPELL_AURA_APPLIED", "EncroachingOblivionDamage", 1235045)
	self:Log("SPELL_PERIODIC_DAMAGE", "EncroachingOblivionDamage", 1235045)
	self:Log("SPELL_PERIODIC_MISSED", "EncroachingOblivionDamage", 1235045)
	-- Intermission: The Ceaseless Hunger
	self:Log("SPELL_AURA_APPLIED", "CollapsingStarApplied", 1233093) -- Channeled
	self:Log("SPELL_AURA_APPLIED", "DarkResidueApplied", 1233105)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkResidueApplied", 1233105)
	self:Log("SPELL_AURA_APPLIED", "EventHorizonDamage", 1233968)
	self:Log("SPELL_PERIODIC_DAMAGE", "EventHorizonDamage", 1233968)
	self:Log("SPELL_PERIODIC_MISSED", "EventHorizonDamage", 1233968)

	-- Velaryn Bloodwrath
	self:Log("SPELL_CAST_START", "TheHunt", 1227809) -- XXX Targetting debuff?
	self:Log("SPELL_CAST_SUCCESS", "BladeDance", 1241306)
	self:Log("SPELL_CAST_START", "EyeBeam", 1218103)
	self:Log("SPELL_AURA_APPLIED", "FelSingedApplied", 1221490)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelSingedApplied", 1221490)
	self:Log("SPELL_AURA_APPLIED", "FelbladeApplied", 1225130)
	self:Log("SPELL_AURA_APPLIED", "FelInfernoApplied", 1245384)
	-- Intermission: The Demon Within
	self:Log("SPELL_AURA_APPLIED", "FelRushApplied", 1233863) -- Channeled

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
	self:Log("SPELL_CAST_SUCCESS", "InfernalStrike", 1227113)
	self:Log("SPELL_CAST_START", "FelDevastation", 1227117)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WitheringFlamesApplied", 1233381)
end

function mod:OnEngage()
	-- Adarus Duskblaze
	devourersIreOnMe = false
	devourersIreCount = 1
	consumeCount = 1
	voidstepCount = 1
	-- self:Bar(1222232, 8.0, CL.count:format(self:SpellName(1222232), devourersIreCount)) -- Devourer's Ire
	-- self:Bar(1234565, 20.0, CL.count:format(self:SpellName(1234565), consumeCount)) -- Consume
	-- self:Bar(1227355, 10.0, CL.count:format(self:SpellName(1227355), voidstepCount)) -- Voidstep

	-- Velaryn Bloodwrath
	theHuntCount = 1
	bladeDanceCount = 1
	eyeBeamCount = 1
	felInfernoCount = 1
	-- self:Bar(1227355, 10.0, CL.count:format(self:SpellName(1227355), theHuntCount)) -- The Hunt
	-- self:Bar(1241306, 20.0, CL.count:format(self:SpellName(1241306), bladeDanceCount)) -- Blade Dance
	-- self:Bar(1218103, 30.0, CL.count:format(self:SpellName(1218103), eyeBeamCount)) -- Eye Beam
	-- self:Bar(1245384, 10.0, CL.count:format(self:SpellName(1245384), felInfernoCount)) -- Fel Inferno

	-- Ilyssa Darksorrow
	fractureCount = 1
	spiritBombCount = 1

	-- self:Bar(1241833, 10.0, CL.count:format(self:SpellName(1241833), fractureCount)) -- Fracture
	-- self:Bar(1242259, 20.0, CL.count:format(self:SpellName(1242259), spiritBombCount)) -- Spirit Bomb
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DevourersIre(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, devourersIreCount))
	devourersIreCount = devourersIreCount + 1
	-- self:Bar(args.spellId, 30.0, CL.count:format(args.spellName, devourersIreCount))
end

function mod:DevourersIreApplied(args)
	if self:Me(args.destGUID) then
		devourersIreOnMe = true
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- Care for consume
	end
end

function mod:DevourersIreRemoved(args)
	if self:Me(args.destGUID) then
		devourersIreOnMe = false
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info") -- no more damge incoming from consume
	end
end

function mod:Consume(args)
	if devourersIreOnMe then
		self:PersonalMessage(args.spellId) -- Is this the right message? custom text?
		self:PlaySound(args.spellId, "alarm") -- damage / heal absorb inc
	elseif self:Healer() then
		self:Message(args.spellId, "red", CL.count:format(args.spellName, consumeCount))
		self:PlaySound(args.spellId, "alert") -- healing needed
	end
	consumeCount = consumeCount + 1
	-- self:Bar(args.spellId, 10.0, CL.count:format(args.spellName, consumeCount))
end

function mod:UnendingHungerApplied(args)
	if self:Me(args.destGUID) then
		local highStacks = 3
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, highStacks)
		if amount >= highStacks then -- high stacks
			self:PlaySound(args.spellId, "warning") -- high stacks
		end
	end
end

function mod:Voidstep(args)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, voidstepCount))
	self:PlaySound(args.spellId, "info") -- boss moving
	voidstepCount = voidstepCount + 1
	-- self:Bar(args.spellId, 10.0, CL.count:format(args.spellName, voidstepCount))
end

do
	local prev = 0
	function mod:HungeringSlashDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
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
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Intermission: The Ceaseless Hunger
function mod:CollapsingStarApplied(args)
	self:Message(args.spellId, "red", CL.you:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- boss intermission, soak fragments
	-- self:CastBar(args.spellId, 25)
end

function mod:DarkResidueApplied(args)
	if self:Me(args.destGUID) then
		local highStacks = 3
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "yellow", args.destName, amount, highStacks)
		if amount >= highStacks then
			self:PlaySound(args.spellId, "alarm") -- high stacks
		else
			self:PlaySound(args.spellId, "info") -- low stacks
		end
	end
end

do
	local prev = 0
	function mod:EventHorizonDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Velaryn Bloodwrath
function mod:TheHunt(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, theHuntCount))
	self:PlaySound(args.spellId, "alert") -- watch charge
	theHuntCount = theHuntCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, theHuntCount))
end

function mod:BladeDance(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, bladeDanceCount))
	self:PlaySound(args.spellId, "alert") -- watch dances
	bladeDanceCount = bladeDanceCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, bladeDanceCount))
end

function mod:EyeBeam(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, eyeBeamCount))
	self:PlaySound(args.spellId, "alert")
	eyeBeamCount = eyeBeamCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, eyeBeamCount))
end

function mod:FelSingedApplied(args)
	if self:Me(args.destGUID) then -- does the offtank need to know?
		local amount = args.amount or 1
		if amount % 2 == 0 then -- 2 / 4/ 6 / 8 (assuming it ends at 8 if you take the full beam)
			self:StackMessage(args.spellId, "blue", args.destName, amount, 6)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:FelbladeApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- big dot
	-- elseif self:Tank() then XXX Check if this is how tanking will go
		-- self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

function mod:FelInfernoApplied(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, felInfernoCount))
	self:PlaySound(args.spellId, "long") -- raid damage
	felInfernoCount = felInfernoCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, felInfernoCount))
end

function mod:FelRushApplied(args)
	self:Message(args.spellId, "red", CL.you:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- boss intermission, dodge fel rushes
	-- self:CastBar(args.spellId, 24)
end

-- Ilyssa Darksorrow
function mod:Fracture(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, fractureCount))
	fractureCount = fractureCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, fractureCount))

	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
end

function mod:ShatteredSoulApplied(args)
	if self:Me(args.destGUID) then -- does the offtank need to know?
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FrailtyTankRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(1241946, "green", CL.removed:format(args.spellName))
		self:PlaySound(1241946, "long") -- saved
	else
		self:Message(1241946, "green", CL.removed_from:format(args.spellName, args.destName))
	end
end

function mod:FrailtySoakApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 2)
		if amount >= 2 then
			self:PlaySound(args.spellId, "alarm") -- watch health
		else
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:SpiritBomb(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, spiritBombCount))
	self:PlaySound(args.spellId, "alert") -- raid damage
	spiritBombCount = spiritBombCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, spiritBombCount))
end

function mod:SoulcrushRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info") -- saved
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
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- watch leap location
end

function mod:FelDevastation(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- move out if inside
end

function mod:WitheringFlamesApplied(args)
	if self:Me(args.destGUID) then
		if args.amount % 5 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 10)
			self:PlaySound(args.spellId, "alarm") -- high stacks
		end
	end
end
