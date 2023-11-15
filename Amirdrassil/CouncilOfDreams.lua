--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Council of Dreams", 2549, 2555)
if not mod then return end
mod:RegisterEnableMob(208363, 208365, 208367)
mod:SetEncounterID(2728)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local songOnMe = false
local castingRebirth = false
local activeUltimates = 0

local blindingRageCount = 1
local barrelingChargeCount = 1
local constrictingThicketCount = 1
local poisonousJavelinCount = 1
local noxiousBlossomCount = 1
local songoftheDragonCount = 1
local polymorphBombCount = 1
local emeraldWindsCount = 1
local agonizingClawsCount = 1

local specialCD = 56
local nextSpecial = 0
local nextBlindingRage = 0
local nextConstrictingThicket = 0
--local nextSongoftheDragon = 0 -- Unused atm

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.ultimate_boss = "Ultimate (%s)"
	L.charge = "Charge"
	L.poisonous_javelin = "Javelin"
	L.polymorph_bomb = "Ducks"
	L.polymorph_bomb_single = "Duck"
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
		{421570, "OFF"}, -- Leap
		420671, -- Noxious Blossom
		426390, -- Corrosive Pollen
		{420858, "SAY", "SAY_COUNTDOWN"}, -- Poisonous Javelin
		-- Pip
		{421029, "CASTBAR"}, -- Song of the Dragon
		{421032, "SAY"}, -- Captivating Finale
		{421501, "OFF"}, -- Blink
		{418720, "SAY_COUNTDOWN"}, -- Polymorph Bomb
		421024, -- Emerald Winds
		423551, -- Whimsical Gust
	},{
		[418187] = "general",
		[420525] = -27300, -- Urctos
		[421292] = -27301, -- Aerwynn
		[421029] = -27302, -- Pip
	},{
		[420525] = L.ultimate_boss:format(self:SpellName(-27300)), -- Blinding Rage (Ultimate (Urctos))
		[420948] = L.charge, -- Barreling Charge (Charge)
		[421292] = L.ultimate_boss:format(self:SpellName(-27301)), -- Constricting Thicket (Ultimate (Aerwynn))
		[420671] = CL.pools, -- Noxious Blossom (Pools)
		[421029] = L.ultimate_boss:format(self:SpellName(-27302)), -- Song of the Dragon (Ultimate (Pip))
		[418720] = L.polymorph_bomb, -- Polymorph Bomb (Ducks)
		[421024] = CL.pushback, -- Emerald Winds (Pushback)
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
	self:Log("SPELL_CAST_SUCCESS", "BlindingRageOver", 418757) -- Polymorph Bomb on Ursoc
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
	self:Log("SPELL_AURA_REMOVED", "ConstrictingThicketOver", 421292)
	self:Log("SPELL_AURA_APPLIED", "ConstrictingThicketApplied", 421298)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConstrictingThicketApplied", 421298)
	self:Log("SPELL_CAST_START", "RelentlessBarrage", 420937)
	self:Log("SPELL_CAST_START", "NoxiousBlossom", 420671)
	self:Log("SPELL_CAST_START", "PoisonousJavelin", 420856)
	self:Log("SPELL_AURA_APPLIED", "PoisonousJavelinApplied", 420858)
	self:Log("SPELL_AURA_REMOVED", "PoisonousJavelinRemoved", 420858)
	self:Log("SPELL_CAST_START", "Leap", 421570)

	-- Pip
	self:Log("SPELL_CAST_START", "SongoftheDragon", 421029)
	self:Log("SPELL_AURA_REMOVED", "SongoftheDragonOver", 421029)
	self:Log("SPELL_AURA_APPLIED", "SongoftheDragonApplied", 421031)
	self:Log("SPELL_AURA_REMOVED", "SongoftheDragonRemoved", 421031)
	self:Log("SPELL_AURA_APPLIED", "CaptivatingFinaleApplied", 421032)
	self:Log("SPELL_CAST_START", "PolymorphBomb", 418591)
	self:Log("SPELL_AURA_APPLIED", "PolymorphBombApplied", 418720) -- Not pre-debuff, that's private
	self:Log("SPELL_AURA_REMOVED", "PolymorphBombRemoved", 418720)
	self:Log("SPELL_CAST_START", "EmeraldWinds", 421024)
	self:Log("SPELL_CAST_START", "Blink", 421501)
end

function mod:OnEngage()
	songOnMe = false
	castingRebirth = false
	activeUltimates = 0

	blindingRageCount = 1
	barrelingChargeCount = 1
	constrictingThicketCount = 1
	poisonousJavelinCount = 1
	noxiousBlossomCount = 1
	songoftheDragonCount = 1
	polymorphBombCount = 1
	emeraldWindsCount = 1
	agonizingClawsCount = 1

	-- Urctos
	self:Bar(421022, self:Easy() and 8.0 or 5.0) -- Agonizing Claws
	self:Bar(420948, self:Easy() and 29.0 or 13.0, CL.count:format(L.charge, barrelingChargeCount)) -- Barreling Charge
	self:Bar(420525, specialCD, CL.count:format(L.ultimate_boss:format(self:SpellName(-27300)), blindingRageCount)) -- Blinding Rage
	nextBlindingRage = GetTime() + specialCD
	nextSpecial = GetTime() + specialCD

	-- Aerwynn
	-- self:Bar(421570, 0.5) -- Leap
	self:Bar(420671, self:Easy() and 11.0 or 5.0, CL.count:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
	self:Bar(420858, self:Easy() and 20.0 or 21.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin
	nextConstrictingThicket = 0

	-- Pip
	self:Bar(421501, 23.0) -- Blink
	self:Bar(418720, self:Easy() and 35.0 or 36.0, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
	self:Bar(421024, 45.5, CL.count:format(CL.pushback, emeraldWindsCount)) -- Emerald Winds
	--nextSongoftheDragon = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function activeUltimate()
	if activeUltimates > 0 then
		return true
	end
	return false
end

local function specialInterrupted()
	if not activeUltimate() then
		agonizingClawsCount = 1 -- Reset for CD rotation
		mod:Bar(421022, mod:Easy() and 8.0 or 5.0) -- Agonizing Claws
		mod:Bar(420948, mod:Easy() and 29.0 or 13.0, CL.count:format(L.charge, barrelingChargeCount)) -- Barreling Charge

		mod:Bar(420671, mod:Easy() and 11.0 or 5.0, CL.count:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
		mod:Bar(420858, mod:Easy() and 20.0 or 21.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin
		mod:Bar(421570, 49.0) -- Leap (0.5, then 48.5, sometimes skipping the 0.5)

		mod:Bar(418720, 16.0, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
		mod:Bar(421501, 23.0) -- Blink
		mod:Bar(421024, 45.5, CL.count:format(CL.pushback, emeraldWindsCount)) -- Emerald Winds
		nextSpecial = GetTime() + specialCD
	end
end

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
			if args.spellId == 426390 and songOnMe then return end -- Don't warn for pools when you need to clear
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Urctos
function mod:BlindingRage(args)
	self:StopBar(CL.count:format(L.ultimate_boss:format(self:SpellName(-27300)), blindingRageCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.ultimate_boss:format(self:SpellName(-27300)), blindingRageCount))
	self:PlaySound(args.spellId, "alert") -- Poly Boss
	blindingRageCount = blindingRageCount + 1
	activeUltimates = activeUltimates + 1
	-- Starting timers for breaks / pools
	self:Bar(418720, self:Easy() and 3.0 or 5.0, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
	self:Bar(420671, 7, CL.count:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
end

function mod:BlindingRageOver(args)
	self:Message(420525, "green", CL.interrupted:format(L.ultimate_boss:format(self:SpellName(-27300)))) -- Blinding Rage
	self:PlaySound(420525, "info")
	activeUltimates = activeUltimates - 1
	specialInterrupted()
	nextConstrictingThicket = GetTime() + specialCD
	self:Bar(421292, specialCD, CL.count:format(L.ultimate_boss:format(self:SpellName(-27301)), constrictingThicketCount)) -- Constricting Thicket
end

function mod:UrsineRageApplied(args)
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "warning") -- Failed Poly
end

do
	local trampledOnYou = false
	function mod:BarrelingCharge(args)
		self:StopBar(CL.count:format(L.charge, barrelingChargeCount))
		barrelingChargeCount = barrelingChargeCount + 1
		local cd = 0
		if activeUltimate() then -- Repeat during ultimate
			cd = 8.0
		elseif not self:Easy() and nextSpecial - GetTime() > 25 then -- 43s
			cd = 20
		elseif nextConstrictingThicket - GetTime() > 0 then -- second cast if Constricting Thicket is next
			cd = self:Easy() and 30.0 or 26.0
		end
		self:CDBar(420948, cd, CL.count:format(L.charge, barrelingChargeCount))
	end

	function mod:BarrelingChargeApplied(args)
		self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(L.charge, barrelingChargeCount-1))
		if self:Me(args.destGUID) then
			self:Yell(args.spellId, L.charge)
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
	agonizingClawsCount = agonizingClawsCount + 1
	if agonizingClawsCount < 5 then -- 4 between each ultimate
		local cd = self:Easy() and { 8.0, 6.0, 25.0, 6.0 } or { 5.0, 4.0, 16.0, 4.0 }
		self:Bar(421022, cd[agonizingClawsCount])
	end
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
function mod:Leap(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	local cd = 48.5
	if nextSpecial - GetTime() > cd then
		self:Bar(args.spellId, {cd, 49})
	end
end

function mod:ConstrictingThicket(args)
	self:StopBar(CL.count:format(L.ultimate_boss:format(self:SpellName(-27301)), constrictingThicketCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.ultimate_boss:format(self:SpellName(-27301)), constrictingThicketCount)))
	self:PlaySound(args.spellId, "alert") -- Interrupt
	constrictingThicketCount = constrictingThicketCount + 1
	activeUltimates = activeUltimates + 1
end

function mod:ConstrictingThicketOver(args)
	self:Message(421292, "green", CL.interrupted:format(L.ultimate_boss:format(self:SpellName(-27301))))
	self:PlaySound(421292, "info") -- well done
	activeUltimates = activeUltimates - 1
	specialInterrupted()
	--nextSongoftheDragon = GetTime() + specialCD
	self:Bar(421029, specialCD, CL.count:format(L.ultimate_boss:format(self:SpellName(-27302)), songoftheDragonCount)) -- Song of the Dragon
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
	self:StopBar(CL.count:format(CL.pools, noxiousBlossomCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.pools, noxiousBlossomCount))
	self:PlaySound(args.spellId, "alert")
	noxiousBlossomCount = noxiousBlossomCount + 1
	if nextSpecial - GetTime() > 24 then -- Is this enough?
		self:CDBar(args.spellId, 21, CL.count:format(CL.pools, noxiousBlossomCount))
	end

	if not activeUltimate() then -- only initial cast during specials?
		local cd = 0
		-- normal 11.0, 22.0, 21.0 / heroic 5.0, 20.0, 29.0
		local remainingSpecialCD = nextSpecial - GetTime()
		if remainingSpecialCD > 40 then -- 45 / 51s (non easy)
			cd = self:Easy() and 22.0 or 20.0 -- normal cast 2
		elseif remainingSpecialCD > 20 and nextSpecial == nextBlindingRage then -- 23s / 31s (non easy)
			cd = self:Easy() and 21.0 or 29.0 -- normal cast 3
		end
		self:CDBar(args.spellId, 21, CL.count:format(CL.pools, noxiousBlossomCount))
	end
end

function mod:PoisonousJavelin(args)
	self:StopBar(CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	self:Message(420858, "yellow", CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	poisonousJavelinCount = poisonousJavelinCount + 1
	if nextSpecial - GetTime() > 25 then
		self:CDBar(420858, 25.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	end
end

function mod:PoisonousJavelinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.poisonous_javelin)
		self:PlaySound(args.spellId, self:Mythic() and "warning" or "alarm") -- move away in mythic
		if self:Mythic() then
			self:Say(args.spellId, L.poisonous_javelin)
			self:SayCountdown(args.spellId, 10)
		end
	end
end

function mod:PoisonousJavelinRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

-- Pip
function mod:SongoftheDragon(args)
	self:StopBar(CL.count:format(L.ultimate_boss:format(self:SpellName(-27302)), songoftheDragonCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.ultimate_boss:format(self:SpellName(-27302)), songoftheDragonCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, self:Mythic() and 12 or 24, CL.count:format(L.ultimate_boss:format(self:SpellName(-27302)), songoftheDragonCount))
	songoftheDragonCount = songoftheDragonCount + 1
	activeUltimates = activeUltimates + 1
	self:Bar(420671, 3, CL.count:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
end

function mod:SongoftheDragonOver(args)
	self:Message(args.spellId, "green", CL.interrupted:format(L.ultimate_boss:format(self:SpellName(-27302))))
	self:PlaySound(args.spellId, "info") -- well done
	activeUltimates = activeUltimates - 1
	specialInterrupted()
	nextBlindingRage = GetTime() + specialCD
	self:Bar(420525, specialCD, CL.count:format(L.ultimate_boss:format(self:SpellName(-27300)), blindingRageCount)) -- Blinding Rage
end

function mod:SongoftheDragonApplied(args)
	if self:Me(args.destGUID) then
		songOnMe = true
	end
end

function mod:SongoftheDragonRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(421029, "green", CL.removed:format(args.spellName))
		self:PlaySound(421029, "info")
		songOnMe = false
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
	self:StopBar(CL.count:format(L.polymorph_bomb, polymorphBombCount))
	self:Message(418720, "yellow", CL.count:format(L.polymorph_bomb, polymorphBombCount))
	self:PlaySound(418720, "alert")
	polymorphBombCount = polymorphBombCount + 1

	local cd = 0
	if nextSpecial - GetTime() > 25 then -- Normal cooldown
		cd = 19
	elseif activeUltimate() then -- Repeat Cooldown
		cd = self:Easy() and 9 or 11
	else
		local remainingRageTime = nextBlindingRage - GetTime()
		if remainingRageTime < 25 then -- Synced Cooldown
			cd = remainingRageTime - 0.01
		end
	end
	self:CDBar(418720, cd, CL.count:format(L.polymorph_bomb, polymorphBombCount))
end

function mod:PolymorphBombApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.polymorph_bomb_single)
		self:PlaySound(args.spellId, "warning")
		self:SayCountdown(args.spellId, 12)
	end
end

function mod:PolymorphBombRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EmeraldWinds(args)
	self:StopBar(CL.count:format(CL.pushback, emeraldWindsCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.pushback, emeraldWindsCount))
	self:PlaySound(args.spellId, "alarm") -- move for pushback
	emeraldWindsCount = emeraldWindsCount + 1
	-- Timer started after specials end
	--self:CDBar(args.spellId, 30, CL.count:format(CL.pushback, emeraldWindsCount))
end

function mod:Blink(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "cyan")
	-- self:PlaySound(args.spellId, "info")
	local cd = 30 -- nextSpecialAbility == "urctos" and 27.5 or 29.8
	if nextSpecial - GetTime() > cd then
		self:Bar(args.spellId, cd)
	end
end
