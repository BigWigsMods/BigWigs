if not BigWigsLoader.onTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Council of Dreams", 2549, 2555)
if not mod then return end
mod:RegisterEnableMob(208363, 208365, 208367)
mod:SetEncounterID(2728)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local castingRebirth = false

local blindingRageCount = 1
local barrelingChargeCount = 1
local constrictingThicketCount = 1
local noxiousBlossomCount = 1
local songoftheDragonCount = 1
local polymorphBombCount = 1
local emeraldWindsCount = 1

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

function mod:GetOptions()
	return {
		-- General
		418187, -- Rebirth
		-- Urctos
		420525, -- Blinding Rage
		425114, -- Ursine Rage
		{420948, "SAY", "SAY_COUNTDOWN"}, -- Barreling Charge
		423420, -- Trampled
		{421022, "TANK"}, -- Agonizing Claws
		-- Aerwynn
		421292, -- Constricting Thicket
		420937, -- Relentless Barrage
		420671, -- Noxious Blossom
		426390, -- Corrosive Pollen
		{420858, "SAY"}, -- Poisonous Javelin
		-- Pip
		421029, -- Song of the Dragon
		{421032, "SAY"}, -- Captivating Finale
		{418720, "SAY", "SAY_COUNTDOWN"}, -- Polymorph Bomb
		421024, -- Emerald Winds
		423551, -- Whimsical Gust
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_CAST_START", "Rebirth", 418187)
	self:Log("SPELL_CAST_SUCCESS", "RebirthSuccess", 418187)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 426390, 423551) -- Corrosive Pollen, Whimsical Gust
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 426390, 423551)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 426390, 423551)

	-- Urctos
	self:Log("SPELL_CAST_START", "BlindingRage", 420525)
	self:Log("SPELL_AURA_REMOVED", "WeakenedDefensesRemoved", 418755) -- Might not be the correct event to use, what if you fail within 20s?
	self:Log("SPELL_AURA_APPLIED", "UrsineRageApplied", 425114)
	self:Log("SPELL_CAST_START", "BarrelingCharge", 420947)
	self:Log("SPELL_AURA_APPLIED", "BarrelingChargeApplied", 420948)
	self:Log("SPELL_AURA_REMOVED", "BarrelingChargeRemoved", 420948)
	self:Log("SPELL_AURA_APPLIED", "TrampledApplied", 423420)
	self:Log("SPELL_AURA_REMOVED", "TrampledRemoved", 423420)
	self:Log("SPELL_CAST_START", "AgonizingClaws", 421020)
	self:Log("SPELL_AURA_APPLIED", "AgonizingClawsApplied", 421022)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AgonizingClawsApplied", 421022)

	-- Aerwynn
	self:Log("SPELL_CAST_START", "ConstrictingThicket", 421292)
	self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "ConstrictingThicketInterrupted", "boss1", "boss2", "boss3")
	self:Log("SPELL_AURA_APPLIED", "ConstrictingThicketApplied", 421298)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConstrictingThicketApplied", 421298)
	self:Log("SPELL_CAST_START", "RelentlessBarrage", 420937)
	self:Log("SPELL_CAST_START", "NoxiousBlossom", 420671)
	self:Log("SPELL_AURA_APPLIED", "PoisonousJavelinApplied", 420858)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PoisonousJavelinApplied", 420858)

	-- Pip
	self:Log("SPELL_CAST_START", "SongoftheDragon", 421029)
	self:Log("SPELL_AURA_REMOVED", "SongoftheDragonRemoved", 421031)
	self:Log("SPELL_AURA_APPLIED", "CaptivatingFinaleApplied", 421032)
	self:Log("SPELL_CAST_START", "PolymorphBomb", 418591)
	self:Log("SPELL_AURA_APPLIED", "PolymorphBombApplied", 418720) -- Not pre-debuff, that's private
	self:Log("SPELL_AURA_REMOVED", "PolymorphBombRemoved", 418720)
	self:Log("SPELL_CAST_START", "EmeraldWinds", 421024) -- Emerald Winds
end

function mod:OnEngage()
	castingRebirth = false

	blindingRageCount = 1
	barrelingChargeCount = 1
	constrictingThicketCount = 1
	noxiousBlossomCount = 1
	songoftheDragonCount = 1
	polymorphBombCount = 1
	emeraldWindsCount = 1

	-- Urctos
	-- self:Bar(420525, 30, CL.count:format(self:SpellName(420525), blindingRageCount)) -- Blinding Rage
	-- self:Bar(420948, 30, CL.count:format(self:SpellName(420948), barrelingChargeCount)) -- Barreling Charge
	-- self:Bar(421022, 15) -- Agonizing Claws

	-- self:Bar(421292, 30, CL.count:format(self:SpellName(421292), constrictingThicketCount)) --Constricting Thicket
	-- self:Bar(420671, 30, CL.count:format(self:SpellName(420671), noxiousBlossomCount)) -- Noxious Blossom

	-- self:Bar(421029, 30, CL.count:format(self:SpellName(421029), songoftheDragonCount)) -- Song of the Dragon
	-- self:Bar(418720, 30, CL.count:format(self:SpellName(418720), polymorphBombCount)) -- Polymorph Bomb
	-- self:Bar(421024, 30, CL.count:format(self:SpellName(421024), emeraldWindsCount)) -- Emerald Winds
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- General
function mod:Rebirth(args)
	if not castingRebirth then
		self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "long") -- Kill or heal
		self:Bar(args.spellId, 15)
		castingRebirth = true
	end
end

function mod:RebirthSuccess(args)
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.sourceName))
	self:PlaySound(args.spellId, "warning") -- Failed killing
	castingRebirth = false
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Urctos
function mod:BlindingRage(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, blindingRageCount))
	self:PlaySound(args.spellId, "alert") -- Poly Boss
	blindingRageCount = blindingRageCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, blindingRageCount))
end

function mod:WeakenedDefensesRemoved(args)
	self:Message(420525, "green", CL.interrupted:format(self:SpellName(420525))) -- Blinding Rage
	self:PlaySound(420525, "info")
end

function mod:UrsineRageApplied(args)
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "warning") -- Failed Poly
end

do
	local trampledOnYou = false
	function mod:BarrelingCharge(args)
		barrelingChargeCount = barrelingChargeCount + 1
		--self:Bar(420948, 30, CL.count:format(args.spellName, barrelingChargeCount))
	end

	function mod:BarrelingChargeApplied(args)
		self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, barrelingChargeCount-1))
		if self:Me(args.destGUID) then
			self:Yell(args.spellId)
			self:YellCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning") -- Move
		elseif trampledOnYou then -- Avoid
			self:PlaySound(args.spellId, "warning") -- Avoid
		else
			self:PlaySound(args.spellId, "alert") -- Help?
		end
	end

	function mod:BarrelingChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelYellCountdown(args.spellId)
		end
	end

	function mod:TrampledApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "info")
			trampledOnYou = true
		end
	end

	function mod:TrampledRemoved(args)
		if self:Me(args.destGUID) then
			trampledOnYou = false
		end
	end
end

function mod:AgonizingClaws(args)
	self:Message(421022, "purple", CL.casting:format(args.spellName))
	--self:Bar(421022, 10)
end

function mod:AgonizingClawsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- Watch health
	elseif amount > 1 then
		self:PlaySound(args.spellId, "warning") -- Tank Swap?
	else
		self:PlaySound(args.spellId, "info")
	end
end

-- Aerwynn
function mod:ConstrictingThicket(args)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, constrictingThicketCount)))
	self:PlaySound(args.spellId, "alert") -- Interrupt
	constrictingThicketCount = constrictingThicketCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, constrictingThicketCount))
end

function mod:ConstrictingThicketInterrupted(_, _, _, spellId)
	if spellId == 421292 then -- Constricting Thicket
		self:Message(spellId, "green", CL.interrupted:formaT(self:SpellName(spellId)))
		self:PlaySound(spellId, "info") -- well done
	end
end

function mod:ConstrictingThicketApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 then -- 2, 4...
			self:StackMessage(421292, "blue", args.destName, args.amount, 4)
			self:PlaySound(421292, "alarm") -- watch movement
		end
	end
end

function mod:RelentlessBarrage(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning") -- didn't interrupt
end

function mod:NoxiousBlossom(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, noxiousBlossomCount))
	self:PlaySound(args.spellId, "alert")
	noxiousBlossomCount = noxiousBlossomCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, noxiousBlossomCount))
end

function mod:PoisonousJavelinApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "warning") -- move away
		self:Say(args.spellId)
	end
end

-- Pip
function mod:SongoftheDragon(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, songoftheDragonCount))
	self:PlaySound(args.spellId, "alert")
	songoftheDragonCount = songoftheDragonCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, songoftheDragonCount))
end

function mod:SongoftheDragonRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(421029, "green", CL.removed:format(args.spellName))
		self:PlaySound(421029, "info")
	end
end

function mod:CaptivatingFinaleApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId) -- Maybe get saved
	end
end

function mod:PolymorphBomb(args)
	self:Message(418720, "yellow", CL.count:format(args.spellName, polymorphBombCount))
	self:PlaySound(418720, "alert")
	polymorphBombCount = polymorphBombCount + 1
	--self:Bar(418720, 30, CL.count:format(args.spellName, polymorphBombCount))
end

function mod:PolymorphBombApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 12)
	end
end

function mod:PolymorphBombRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EmeraldWinds(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, emeraldWindsCount))
	self:PlaySound(args.spellId, "alarm") -- move for pushback
	emeraldWindsCount = emeraldWindsCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, emeraldWindsCount))
end
