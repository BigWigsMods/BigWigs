
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Castle Nathria Trash", 2296)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Pre Shriekwing ]]--
	168337, -- Moldovaak
	173444, -- Caramain
	173445, -- Sindrel
	173446, -- Hargitas

	--[[ Shriekwing -> Huntsman Altimor ]]--
	174069, -- Hulking Gargon
	173189, 174092, 173973, -- Nathrian Hawkeye, Nathrian Gargon Rider, Nathrian Tracker
	174070, 174336, -- Kennel Overseer x2

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	173798, -- Rat of Unusual Size
	173142, -- Dread Feaster

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	173464, -- Deplina
	173448, -- Dragost
	173469 -- Kullan
)

--------------------------------------------------------------------------------
-- Locals
--

local castCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Hulking Gargon"
	L.hawkeye = "Nathrian Hawkeye"
	L.overseer = "Kennel Overseer"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Dread Feaster"
	L.rat = "Rat of Unusual Size"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Pre Shriekwing ]]--
		343322, -- Curse of Moldovaak
		343320, -- Curse of Caramain
		343325, -- Curse of Sindrel
		343316, -- Curse of Hargitas
		343155, -- Stoneskin
		343302, -- Granite Wings

		--[[ Shriekwing -> Huntsman Altimor ]]--
		{329989, "DISPEL"}, -- Enrage
		341441, -- Ground Smash
		341352, -- Mastercrafted Gamesman's Snare
		341735, -- Restore Stone

		--[[ Huntsman Altimor -> Hungering Destroyer ]]--
		340630, -- Rotting
		{329298, "SAY"}, -- Gluttonous Miasma

		--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
		339553, -- Lingering Anima
		339557, -- Bottled Anima
		{339528, "TANK"}, -- Warped Desires
		{339525, "SAY", "SAY_COUNTDOWN"}, -- Concentrate Anima
	},{
		[343322] = L.moldovaak,
		[343320] = L.caramain,
		[343325] = L.sindrel,
		[343316] = L.hargitas,
		[343155] = L.moldovaak .."/".. L.caramain .."/".. L.sindrel .."/".. L.hargitas,
		[329989] = L.gargon,
		[341352] = L.hawkeye,
		[341735] = L.overseer,
		[340630] = L.rat,
		[329298] = L.feaster,
		[339553] = L.deplina,
		[339528] = L.dragost,
		[339525] = L.kullan,
	},{
		[343302] = CL.knockback, -- Granite Wings (Knockback)
		[341352] = CL.traps, -- Mastercrafted Gamesman's Snare (Traps)
		[329298] = L.miasma, -- Gluttonous Miasma (Miasma)
	}
end

function mod:OnBossEnable()
	castCollector = {}

	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Pre Shriekwing ]]--
	self:Log("SPELL_CAST_SUCCESS", "Curse", 343322, 343320, 343325, 343316)
	self:Log("SPELL_CAST_START", "Stoneskin", 343155)
	self:Log("SPELL_AURA_APPLIED", "StoneskinApplied", 343155)
	self:Log("SPELL_CAST_START", "GraniteWings", 343302)

	--[[ Shriekwing -> Huntsman Altimor ]]--
	self:Log("SPELL_AURA_APPLIED", "Enrage", 329989)
	self:Log("SPELL_CAST_START", "GroundSmash", 341441)
	self:Log("SPELL_CAST_SUCCESS", "MastercraftedGamesmansSnare", 341352, 341520)
	self:Log("SPELL_CAST_START", "RestoreStone", 341735)

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	self:Log("SPELL_AURA_APPLIED_DOSE", "Rotting", 340630)
	self:Log("SPELL_AURA_APPLIED", "GluttonousMiasma", 329298)

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 339553) -- Lingering Anima
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 339553)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 339553)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_AURA_APPLIED", "WarpedDesiresApplied", 339528)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WarpedDesiresApplied", 339528)
	self:Log("SPELL_AURA_APPLIED", "ConcentrateAnimaApplied", 339525)
	self:Log("SPELL_AURA_REMOVED", "ConcentrateAnimaRemoved", 339525)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Pre Shriekwing ]]--
function mod:Curse(args)
	self:Message(args.spellId, "yellow", CL.on_group:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
end

function mod:Stoneskin(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	local _, ready = self:Interrupter()
	if ready then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:StoneskinApplied(args)
	self:Message(args.spellId, "orange", CL.buff_other:format(args.destName, args.spellName))
	self:PlaySound(args.spellId, "warning")
end

function mod:GraniteWings(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.knockback))
	self:PlaySound(args.spellId, "long")
end

--[[ Shriekwing -> Huntsman Altimor ]]--
function mod:Enrage(args)
	if self:Dispeller("enrage", true, args.spellId) then
		self:Message(args.spellId, "orange", CL.buff_other:format(L.gargon, args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

do
	local prev = 0
	function mod:GroundSmash(args)
		local t = args.time
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "red", CL.casting:format(args.spellName))
			self:PlaySound(args.spellId, "long")
		end
	end
end

function mod:MastercraftedGamesmansSnare(args)
	self:Message(341352, "yellow", CL.incoming:format(CL.traps))
	self:PlaySound(341352, "warning")
end

function mod:RestoreStone(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
end

--[[ Huntsman Altimor -> Hungering Destroyer ]]--
function mod:Rotting(args)
	local amount = args.amount or 1
	if amount % 4 == 0 then
		if self:Me(args.destGUID) then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			if amount > 11 then
				self:PlaySound(args.spellId, "info")
			end
		elseif (self:Tank() or self:Healer()) and self:Tank(args.destName) then
			self:StackMessage(args.spellId, args.destName, amount, "purple")
			if amount > 11 then
				self:PlaySound(args.spellId, "info")
			end
		end
	end
end

function mod:GluttonousMiasma(args)
	if self:MobId(args.sourceGUID) == 173142 then -- Dread Feaster
		if self:Me(args.destGUID) then
			self:Yell(args.spellId, L.miasma)
		end
		self:TargetMessage(args.spellId, "yellow", args.destName, L.miasma)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
	if castCollector[castGUID] then return end -- Throttle the same cast from multiple unitIds (target/focus/nameplate)

	if spellId == 339557 then -- Bottled Anima
		castCollector[castGUID] = true
		self:Message(spellId, "yellow", CL.incoming:format(self:SpellName(spellId)))
		self:Bar(spellId, 9.7)
		self:PlaySound(spellId, "info")
	end
end

function mod:WarpedDesiresApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	if args.amount then -- 2+
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:ConcentrateAnimaApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "orange", playerList)
		self:TargetBar(args.spellId, 10, args.destName)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end
	end
end

function mod:ConcentrateAnimaRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
