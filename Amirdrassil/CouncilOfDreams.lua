--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Council of Dreams", 2549, 2555)
if not mod then return end
mod:RegisterEnableMob(208363, 208365, 208956) -- Urctos, Aerwynn, Pip
mod:SetEncounterID(2728)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local castingRebirth = false

local specialCD = 56
local specialChain = { ["urctos"] = "aerwynn", ["aerwynn"] = "pip", ["pip"] = "urctos" }
local activeSpecials = 0
local specialCount = 1
local nextSpecial = 0
local nextSpecialAbility = nil

local blindingRageCount = 1
local barrelingChargeCount = 1
local agonizingClawsCount = 1

local constrictingThicketCount = 1
local noxiousBlossomCount = 1
local poisonousJavelinCount = 1

local songCount = 1
local polymorphBombCount = 1
local emeraldWindsCount = 1
local songOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.agonizing_claws_debuff = "{421022} (Debuff)"
	L.agonizing_claws_debuff_desc = 421022
	L.agonizing_claws_debuff_icon = 421022

	L.ultimate_boss = "Ultimate (%s)"
	L.special_bar = "Ult [%s] (%d)"
	L.special_mythic_bar = "Ult [%s/%s] (%d)"
	L.special_mechanic_bar = "%s [Ult] (%d)"

	L.urctos = mod:SpellName(-27300)
	L.aerwynn = mod:SpellName(-27301)
	L.pip = mod:SpellName(-27302)

	L.barreling_charge = "Charge"
	L.noxious_blossom = CL.pools
	L.poisonous_javelin = "Javelin"
	L.song_of_the_dragon = "Song"
	L.polymorph_bomb = "Ducks"
	L.polymorph_bomb_single = "Duck"
	L.emerald_winds = CL.pushback
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		418187, -- Rebirth
		-- "berserk",
		-- Urctos
		420525, -- Blinding Rage
		425114, -- Ursine Rage
		{420948, "SAY", "SAY_COUNTDOWN"}, -- Barreling Charge
		421022, -- Agonizing Claws
		{"agonizing_claws_debuff", "TANK"},
		-- Aerwynn
		421292, -- Constricting Thicket
		420937, -- Relentless Barrage
		421570, -- Leap
		420671, -- Noxious Blossom
		426390, -- Corrosive Pollen (Damage)
		{420858, "SAY", "SAY_COUNTDOWN"}, -- Poisonous Javelin
		-- Pip
		{421029, "CASTBAR"}, -- Song of the Dragon
		{421032, "SAY"}, -- Captivating Finale
		421501, -- Blink
		{418720, "PRIVATE", "SAY_COUNTDOWN"}, -- Polymorph Bomb
		421024, -- Emerald Winds
		423551, -- Whimsical Gust (Damage)
	},{
		[420525] = -27300, -- Urctos
		[421292] = -27301, -- Aerwynn
		[421029] = -27302, -- Pip
	},{
		[420525] = L.ultimate_boss:format(L.urctos), -- Blinding Rage (Ultimate (Urctos))
		[420948] = L.barreling_charge,
		[421292] = L.ultimate_boss:format(L.aerwynn), -- Constricting Thicket (Ultimate (Aerwynn))
		[420671] = L.noxious_blossom,
		[421029] = L.ultimate_boss:format(L.pip), -- Song of the Dragon (Ultimate (Pip))
		[418720] = L.polymorph_bomb,
		[421024] = L.emerald_winds,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_EncounterEnd", "CancelAllTimers") -- stop skipped cast bars

	-- General
	self:Log("SPELL_CAST_START", "Rebirth", 418187)
	self:Log("SPELL_CAST_SUCCESS", "RebirthSuccess", 418187)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 426390, 423551) -- Corrosive Pollen, Whimsical Gust
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 426390) -- Corrosive Pollen
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 426390)

	-- Urctos
	self:Log("SPELL_CAST_START", "BlindingRage", 420525)
	-- self:Log("SPELL_AURA_REMOVED", "BlindingRageOver", 420525)
	self:Log("SPELL_CAST_SUCCESS", "UrctosPolyBomb", 418757)
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
	self:Log("SPELL_AURA_APPLIED", "AerwynnBarrelingCharge", 420979)
	self:Log("SPELL_AURA_APPLIED", "ConstrictingThicketApplied", 421298)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConstrictingThicketApplied", 421298)
	self:Log("SPELL_CAST_START", "RelentlessBarrage", 420937)
	self:Log("SPELL_CAST_START", "NoxiousBlossom", 420671)
	self:Log("SPELL_CAST_START", "PoisonousJavelin", 420856)
	self:Log("SPELL_AURA_APPLIED", "PoisonousJavelinApplied", 420858)
	self:Log("SPELL_AURA_REMOVED", "PoisonousJavelinRemoved", 420858)
	self:Log("SPELL_CAST_START", "Leap", 421570)

	-- Pip
	self:Log("SPELL_CAST_START", "SongOfTheDragon", 421029)
	self:Log("SPELL_AURA_REMOVED", "SongOfTheDragonOver", 421029)
	self:Log("SPELL_AURA_APPLIED", "SongOfTheDragonApplied", 421031)
	self:Log("SPELL_AURA_REMOVED", "SongOfTheDragonRemoved", 421031)
	self:Log("SPELL_AURA_APPLIED", "CaptivatingFinaleApplied", 421032)
	self:Log("SPELL_AURA_REMOVED", "CaptivatingFinaleRemoved", 421032)
	self:Log("SPELL_CAST_START", "PolymorphBomb", 418591)
	self:Log("SPELL_AURA_APPLIED", "PolymorphBombApplied", 418720)
	self:Log("SPELL_AURA_REMOVED", "PolymorphBombRemoved", 418720)
	self:Log("SPELL_CAST_START", "EmeraldWinds", 421024)
	self:Log("SPELL_CAST_START", "Blink", 421501)
end

function mod:OnEngage()
	castingRebirth = false
	activeSpecials = 0
	specialCount = 1

	blindingRageCount = 1
	barrelingChargeCount = 1
	agonizingClawsCount = 1

	constrictingThicketCount = 1
	noxiousBlossomCount = 1
	poisonousJavelinCount = 1

	songCount = 1
	polymorphBombCount = 1
	emeraldWindsCount = 1
	songOnMe = false

	-- Fury of the Dream (427795)
	-- Heroic testing didn't seem to have an enrage (15m+ pulls without), maybe added afterward
	-- if self:Normal() then
	-- 	self:Berserk(661, true)
	-- elseif self:Mythic() then
	-- 	self:Berserk(480, true)
	-- end

	-- Urctos
	self:Bar(421022, self:Easy() and 8.0 or 5.0, CL.count:format(self:SpellName(421022), agonizingClawsCount)) -- Agonizing Claws
	self:Bar(420948, self:Easy() and 29.0 or 13.0, CL.count:format(L.barreling_charge, barrelingChargeCount)) -- Barreling Charge
	if self:Mythic() then
		self:Bar(420525, specialCD, L.special_mythic_bar:format(L.urctos, L.aerwynn, specialCount)) -- Blinding Rage/Constricting Thicket
	else
		self:Bar(420525, specialCD, L.special_bar:format(L.urctos, blindingRageCount)) -- Blinding Rage
	end
	nextSpecial = GetTime() + specialCD
	nextSpecialAbility = "urctos"

	-- Aerwynn
	-- self:Bar(421570, 0.5) -- Leap
	self:Bar(420671, self:Easy() and 11.0 or 5.0, CL.count:format(L.noxious_blossom, noxiousBlossomCount)) -- Noxious Blossom
	self:Bar(420858, self:Easy() and 20.0 or 21.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin

	-- Pip
	self:Bar(421501, 23.0) -- Blink
	self:Bar(418720, self:Easy() and 35.0 or 36.0, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
	self:Bar(421024, self:Mythic() and 43 or 45.5, CL.count:format(L.emerald_winds, emeraldWindsCount)) -- Emerald Winds

	self:SetPrivateAuraSound(418720, 429123) -- Polymorph Bomb
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SpecialOver()
	activeSpecials = math.max(activeSpecials - 1, 0)
	if activeSpecials == 0 then
		self:StopBar(L.special_mechanic_bar:format(L.barreling_charge, barrelingChargeCount)) -- Barreling Charge
		self:StopBar(L.special_mechanic_bar:format(L.noxious_blossom, noxiousBlossomCount)) -- Noxious Blossom
		self:StopBar(L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb

		specialCount = specialCount + 1
		agonizingClawsCount = 1

		self:Bar(421022, self:Easy() and 8.0 or 5.0, CL.count:format(self:SpellName(421022), agonizingClawsCount)) -- Agonizing Claws
		self:Bar(420948, self:Easy() and 29.0 or 13.0, CL.count:format(L.barreling_charge, barrelingChargeCount)) -- Barreling Charge

		self:Bar(420671, self:Easy() and 11.0 or 5.0, CL.count:format(L.noxious_blossom, noxiousBlossomCount)) -- Noxious Blossom
		self:Bar(420858, self:Easy() and 20.0 or 21.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin
		self:Bar(421570, 49.0) -- Leap (0.5, then 48.5, sometimes skipping the 0.5)

		self:Bar(418720, 16.0, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
		self:Bar(421501, 23.0) -- Blink
		self:Bar(421024, self:Mythic() and 43 or 45.5, CL.count:format(L.emerald_winds, emeraldWindsCount)) -- Emerald Winds

		nextSpecial = GetTime() + specialCD
		if nextSpecialAbility == "urctos" then
			nextSpecialAbility = "aerwynn"
			if self:Mythic() then
				self:Bar(421292, specialCD, L.special_mythic_bar:format(L.aerwynn, L.pip, specialCount)) -- Constricting Thicket/Song of the Dragon
			else
				self:Bar(421292, specialCD, L.special_bar:format(L.aerwynn, constrictingThicketCount)) -- Constricting Thicket
			end
		elseif nextSpecialAbility == "aerwynn" then
			nextSpecialAbility = "pip"
			if self:Mythic() then
				self:Bar(421029, specialCD, L.special_mythic_bar:format(L.pip, L.urctos, specialCount)) -- Song of the Dragon/Blinding Rage
			else
				self:Bar(421029, specialCD, L.special_bar:format(L.pip, constrictingThicketCount))  -- Song of the Dragon
			end
		elseif nextSpecialAbility == "pip" then
			nextSpecialAbility = "urctos"
			if self:Mythic() then
				self:Bar(420525, specialCD, L.special_mythic_bar:format(L.urctos, L.aerwynn, specialCount)) -- Blinding Rage/Constricting Thicket
			else
				self:Bar(420525, specialCD, L.special_bar:format(L.urctos, constrictingThicketCount))   -- Blinding Rage
			end
		end
	end
end

-- General
function mod:Rebirth(args)
	if not castingRebirth then
		self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "long")
		self:Bar(args.spellId, 15)
		castingRebirth = true
	end

	-- handle skipping a cast due to rebirth
	local boss = self:MobId(args.sourceGUID)
	local rebirthTime = 15
	local remainingSpecialCD = nextSpecial - GetTime()
	if remainingSpecialCD > rebirthTime then
		if boss == 208363 then -- Urctos
			local remaining = self:BarTimeLeft(CL.count:format(self:SpellName(421022), agonizingClawsCount)) -- Agonizing Claws
			if remaining > 0 and remaining < rebirthTime then
				self:ScheduleTimer(function()
					agonizingClawsCount = agonizingClawsCount + 1
					local cd
					if self:Easy() then
						local timer = { 8.0, 6.0, 25.0, 6.0, 0 }
						cd = timer[agonizingClawsCount]
					else
						local timer = { 5.0, 4.0, 16.0, 4.0, 0 }
						cd = timer[agonizingClawsCount]
					end
					self:Bar(421022, cd, CL.count:format(self:SpellName(421022), agonizingClawsCount))
				end, remaining)
			end
		elseif boss == 208365 then -- Aerwynn
			local remaining = self:BarTimeLeft(CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin
			if remaining > 0 and remaining < rebirthTime then
				self:ScheduleTimer(function()
					if nextSpecial - GetTime() > 25 then
						self:Bar(420858, 25.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
					end
				end, remaining)
			end
		elseif boss == 208956 then -- Pip
			local remaining = self:BarTimeLeft(CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
			if remaining > 0 and remaining < rebirthTime then
				self:ScheduleTimer(function()
					if nextSpecial - GetTime() > 25 then
						self:Bar(418720, self:Easy() and 19.0 or 20.0, CL.count:format(L.polymorph_bomb, polymorphBombCount))
					end
				end, remaining)
			end
		end
	elseif not self:Mythic() then
		if (boss == 208363 and nextSpecialAbility == "urctos") or (boss == 208365 and nextSpecialAbility == "aerwynn") or (boss == 208956 and nextSpecialAbility == "pip") then
			-- is this how this works?
			self:ScheduleTimer("SpecialOver", remainingSpecialCD)
		end
	end
end

function mod:RebirthSuccess(args)
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.sourceName))
	self:PlaySound(args.spellId, "warning") -- failed
	castingRebirth = false
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 and (args.spellId ~= 426390 or not songOnMe) then -- Don't warn for Noxious Blossom during Song
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

-- Urctos
function mod:BlindingRage(args)
	self:Message(args.spellId, "orange", CL.count:format(L.ultimate_boss:format(self:SpellName(L.urctos)), blindingRageCount))
	self:PlaySound(args.spellId, "alert") -- duck boss
	blindingRageCount = blindingRageCount + 1

	activeSpecials = activeSpecials + 1

	-- if not self:Mythic() or nextSpecialAbility == "pip" then
	-- 	self:Bar(420671, self:Mythic() and 1.0 or self:Easy() and 3.0 or 5.0, L.special_mechanic_bar:format(L.noxious_blossom, noxiousBlossomCount)) -- Noxious Blossom
	-- end
	-- self:Bar(418720, 9.0, L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
end

function mod:BlindingRageOver()
	self:StopBar(L.special_mechanic_bar:format(L.noxious_blossom, noxiousBlossomCount)) -- Noxious Blossom
	self:StopBar(L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
	self:SpecialOver()

	if activeSpecials > 0 and specialChain[nextSpecialAbility] == "aerwynn" then -- Urctos + Aerwynn
		self:StopBar(CL.count:format(L.barreling_charge, barrelingChargeCount)) -- make sure we're not duplicating
		self:Bar(420948, 2.5, L.special_mechanic_bar:format(L.barreling_charge, barrelingChargeCount))
	end
end

function mod:UrctosPolyBomb()
	self:BlindingRageOver() -- you can interrupt the cast with duck, never getting the auras
	self:Message(420525, "green", CL.interrupted:format(self:SpellName(420525))) -- Blinding Rage
	self:PlaySound(420525, "info")
end

function mod:UrsineRageApplied(args)
	self:BlindingRageOver()
	self:Message(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "alarm") -- y u no duck boss
end

do
	local trampledOnYou = false
	function mod:BarrelingCharge(args)
		local spellName = L.barreling_charge
		self:StopBar(L.special_mechanic_bar:format(spellName, barrelingChargeCount))
		self:StopBar(CL.count:format(spellName, barrelingChargeCount))

		barrelingChargeCount = barrelingChargeCount + 1

		-- 1 per special
		if activeSpecials > 0 then -- short recast during specials
			self:Bar(420948, 8.0, L.special_mechanic_bar:format(spellName, barrelingChargeCount))
		elseif not self:Easy() and nextSpecial - GetTime() > 25 then -- 43s
			self:Bar(420948, 20, CL.count:format(spellName, barrelingChargeCount)) -- Barreling Charge
		elseif nextSpecialAbility == "aerwynn" then -- cast 3/4s after Constricting Thicket
			-- replaces bar in :ConstrictingThicket
			local cd = self:Mythic() and 27.0 or self:Easy() and 30.0 or 26.0
			self:Bar(420948, cd, L.special_mechanic_bar:format(spellName, barrelingChargeCount))
		end
	end

	function mod:BarrelingChargeApplied(args)
		self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(L.barreling_charge, barrelingChargeCount - 1))
		if self:Me(args.destGUID) then
			self:Yell(args.spellId)
			self:YellCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning") -- Move
		elseif trampledOnYou then -- Avoid
			self:PlaySound(args.spellId, "warning") -- Avoid
		else
			self:PlaySound(args.spellId, "alert") -- Soak?
		end
	end

	function mod:BarrelingChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelYellCountdown(args.spellId)
		end
	end

	function mod:TrampledApplied(args)
		if self:Me(args.destGUID) then
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
	self:Message(421022, "purple", CL.count:format(args.spellName, agonizingClawsCount))
	if self:Tank() or (not self:Easy() and not self:Melee()) then
		self:PlaySound(421022, "alert") -- frontal (in heroic and mythic)
	end
	agonizingClawsCount = agonizingClawsCount + 1

	local cd
	if self:Easy() then
		local timer = { 8.0, 6.0, 25.0, 6.0, 0 }
		cd = timer[agonizingClawsCount]
	else
		local timer = { 5.0, 4.0, 16.0, 4.0, 0 }
		cd = timer[agonizingClawsCount]
	end
	self:Bar(421022, cd, CL.count:format(args.spellName, agonizingClawsCount))
end

function mod:AgonizingClawsApplied(args)
	self:StackMessage("agonizing_claws_debuff", "purple", args.destName, args.amount, 1, args.spellId, args.spellId)
	if self:Me(args.destGUID) then
		self:PlaySound("agonizing_claws_debuff", "alarm") -- Watch health
	else
		self:PlaySound("agonizing_claws_debuff", "warning") -- Tank Swap?
	end
end

-- Aerwynn
function mod:ConstrictingThicket(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.ultimate_boss:format(L.aerwynn)), constrictingThicketCount))
	self:PlaySound(args.spellId, "alert") -- Interrupt
	constrictingThicketCount = constrictingThicketCount + 1

	activeSpecials = activeSpecials + 1

	-- self:Bar(420948, self:Mythic() and 4.0 or 3.0, L.special_mechanic_bar:format(L.barreling_charge, barrelingChargeCount)) -- Barreling Charge
end

function mod:ConstrictingThicketOver()
	self:StopBar(L.special_mechanic_bar:format(L.barreling_charge, barrelingChargeCount)) -- Barreling Charge
	self:SpecialOver()

	if activeSpecials > 0 and specialChain[nextSpecialAbility] == "pip" then -- Aerwynn + Pip
		self:StopBar(CL.count:format(L.noxious_blossom, noxiousBlossomCount)) -- make sure we're not duplicating
		self:Bar(420671, 5.0, L.special_mechanic_bar:format(L.noxious_blossom, noxiousBlossomCount))
	end
end

function mod:AerwynnBarrelingCharge()
	self:Message(421292, "green", CL.interrupted:format(L.ultimate_boss:format(L.aerwynn))) -- Constricting Thicket
	self:PlaySound(421292, "info")
end

function mod:RelentlessBarrage(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- didn't interrupt
	-- XXX does Aerwynn still cast her regular abilities?
end

function mod:ConstrictingThicketApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 4 == 0 then
			self:StackMessage(421292, "blue", args.destName, args.amount, 4)
			self:PlaySound(421292, "alarm") -- watch movement
		end
	end
end

function mod:NoxiousBlossom(args)
	local spellName = L.noxious_blossom
	self:StopBar(L.special_mechanic_bar:format(spellName, noxiousBlossomCount))
	self:StopBar(CL.count:format(spellName, noxiousBlossomCount))

	self:Message(args.spellId, "yellow", CL.count:format(spellName, noxiousBlossomCount))
	noxiousBlossomCount = noxiousBlossomCount + 1

	if activeSpecials == 0 then -- only initial cast during specials?
		-- normal 11.0, 22.0, 21.0 / heroic 5.0, 20.0, 29.0
		local remainingSpecialCD = nextSpecial - GetTime()
		if remainingSpecialCD > 40 then -- 45 / 51s (non easy)
			self:Bar(args.spellId, self:Easy() and 22.0 or 20.0, CL.count:format(spellName, noxiousBlossomCount)) -- normal cast 2
		elseif remainingSpecialCD > 20 and nextSpecialAbility == "urctos" then -- 23s / 31s (non easy)
			self:Bar(args.spellId, self:Mythic() and 27 or self:Easy() and 21.0 or 29.0, CL.count:format(spellName, noxiousBlossomCount)) -- normal cast 3
		elseif nextSpecialAbility == "urctos" and not self:Mythic() then -- 2s
			-- replaces bar in :BlindingRage
			self:Bar(args.spellId, 7.0, L.special_mechanic_bar:format(spellName, noxiousBlossomCount))
		elseif nextSpecialAbility == "pip" and not self:Mythic() then
			-- replaces bar in :SongOfTheDragon
			self:Bar(args.spellId, self:Easy() and 26.0 or 29.1, L.special_mechanic_bar:format(spellName, noxiousBlossomCount))
		end
	end
end

function mod:PoisonousJavelin(args)
	self:StopBar(CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	self:Message(420858, "yellow", CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	poisonousJavelinCount = poisonousJavelinCount + 1
	if nextSpecial - GetTime() > 25 then
		self:Bar(420858, 25.0, CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
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

function mod:Leap(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "cyan")
	-- self:PlaySound(args.spellId, "info")
	local cd = 48.5
	if nextSpecial - GetTime() > cd then
		self:Bar(args.spellId, { cd, 49.0 })
	end
end

-- Pip
function mod:SongOfTheDragon(args)
	self:Message(args.spellId, "orange", CL.count:format(L.ultimate_boss:format(self:SpellName(L.pip)), songCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, self:Mythic() and 14 or 24, L.song_of_the_dragon)
	songCount = songCount + 1

	activeSpecials = activeSpecials + 1

	-- self:Bar(420671, self:Mythic() and 1.0 or 3.0, L.special_mechanic_bar:format(args.spellName, noxiousBlossomCount)) -- Noxious Blossom
end

function mod:SongOfTheDragonOver()
	self:StopBar(CL.cast:format(L.song_of_the_dragon))

	self:Message(421292, "green", CL.over:format(L.ultimate_boss:format(L.pip)))
	self:PlaySound(421292, "info")

	self:SpecialOver()

	if activeSpecials > 0 and specialChain[nextSpecialAbility] == "urctos" then -- Pip + Urctos
		self:StopBar(CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- make sure we're not duplicating
		self:Bar(420948, 2.5, L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount))
	end
end

function mod:SongOfTheDragonApplied(args)
	if self:Me(args.destGUID) then
		songOnMe = true
	end
end

do
	local captivatingFinaleOnMe = false
	function mod:SongOfTheDragonRemoved(args)
		if self:Me(args.destGUID) then
			songOnMe = false
			self:SimpleTimer(function() -- don't announce if you got stunned
				if not captivatingFinaleOnMe then
					self:Message(421029, "green", CL.removed:format(self:SpellName(421029)))
					self:PlaySound(421029, "info")
				end
			end, 0.5)
		end
	end

	function mod:CaptivatingFinaleApplied(args)
		if self:Me(args.destGUID) then
			captivatingFinaleOnMe = true
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Yell(args.spellId) -- Maybe get saved
		end
	end

	function mod:CaptivatingFinaleRemoved(args)
		if self:Me(args.destGUID) then
			captivatingFinaleOnMe = false
			self:Message(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:PolymorphBomb()
	local spellName = L.polymorph_bomb
	self:StopBar(L.special_mechanic_bar:format(spellName, polymorphBombCount))
	self:StopBar(CL.count:format(spellName, polymorphBombCount))

	self:Message(418720, "cyan", CL.count:format(spellName, polymorphBombCount))
	polymorphBombCount = polymorphBombCount + 1
	self:PlaySound(418720, "alert")

	if activeSpecials > 0 then -- short recast during specials (you only get one extra cast?)
		self:Bar(418720, self:Easy() and 9.0 or 11, L.special_mechanic_bar:format(spellName, polymorphBombCount))
	elseif nextSpecial - GetTime() > 25 then -- 40s
		self:Bar(418720, self:Easy() and 19.0 or 20.0, CL.count:format(spellName, polymorphBombCount)) -- normal cast 2
	elseif nextSpecialAbility == "urctos" then
		local remainingBlindingRageCD = nextSpecial - GetTime()
		if remainingBlindingRageCD < 25 and remainingBlindingRageCD > 3 then -- 20s
			if self:Mythic() then
				-- cast 0.5s before Blinding Rage
				self:Bar(418720, 18.5, CL.count:format(spellName, polymorphBombCount))
			else
				-- cast when Blinding Rage starts
				self:Bar(418720, remainingBlindingRageCD - 0.01, CL.count:format(spellName, polymorphBombCount))
			end
		end
	end
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
	self:StopBar(CL.count:format(L.emerald_winds, emeraldWindsCount))
	self:Message(args.spellId, "orange", CL.count:format(L.emerald_winds, emeraldWindsCount))
	self:PlaySound(args.spellId, "alarm") -- move for pushback
	emeraldWindsCount = emeraldWindsCount + 1
	-- 1 per special
	-- self:Bar(args.spellId, 45.5, CL.count:format(L.emerald_winds, emeraldWindsCount))
end

function mod:Blink(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "cyan")
	-- self:PlaySound(args.spellId, "info")
	local cd = 30
	if self:Mythic() then
		cd = nextSpecialAbility == "pip" and 28 or 27
	end
	if nextSpecial - GetTime() > cd then
		self:Bar(args.spellId, cd)
	end
end
