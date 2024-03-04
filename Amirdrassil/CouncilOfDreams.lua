--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Council of Dreams", 2549, 2555)
if not mod then return end
mod:RegisterEnableMob(208363, 208365, 208367) -- Urctos, Aerwynn, Pip
mod:SetEncounterID(2728)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local castingRebirth = false
local rebirthCount = 1
local rebirthTimers = {}

local specialCD = mod:LFR() and 74.7 or 56
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

	L.custom_off_combined_full_energy = "Combined Full Energy Bars (Mythic only)"
	L.custom_off_combined_full_energy_desc = "Combine the bars of the abilities that the bosses use at full energy into one bar, only if they will be cast at the same time."

	L.special_mechanic_bar = "%s [Ult] (%d)"

	L.constricting_thicket = "Vines"
	L.poisonous_javelin = "Javelin"
	L.song_of_the_dragon = "Song"
	L.polymorph_bomb = "Ducks"
	L.polymorph_bomb_single = "Duck"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		{418187, "CASTBAR"}, -- Rebirth
		-- "berserk",
		"custom_off_combined_full_energy",
		-- Urctos
		420525, -- Blinding Rage
		425114, -- Ursine Rage
		{420948, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Barreling Charge
		421022, -- Agonizing Claws
		{"agonizing_claws_debuff", "TANK"},
		-- Aerwynn
		421292, -- Constricting Thicket
		420937, -- Relentless Barrage
		{421570, "OFF"}, -- Leap
		420671, -- Noxious Blossom
		426390, -- Corrosive Pollen (Damage)
		{420858, "SAY", "SAY_COUNTDOWN"}, -- Poisonous Javelin
		-- Pip
		{421029, "CASTBAR", "ME_ONLY_EMPHASIZE"}, -- Song of the Dragon
		{421032, "SAY"}, -- Captivating Finale
		{421501, "OFF"}, -- Blink
		{418720, "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE", "PRIVATE"}, -- Polymorph Bomb
		421024, -- Emerald Winds
		423551, -- Whimsical Gust (Damage)
	},{
		[418187] = "general",
		[420525] = -27300, -- Urctos
		[421292] = -27301, -- Aerwynn
		[421029] = -27302, -- Pip
	},{
		["custom_off_combined_full_energy"] = CL.plus:format(L.constricting_thicket, L.song_of_the_dragon), -- Vines + Song (Example)
		[420948] = CL.charge, -- Barreling Charge (Charge)
		[421292] = L.constricting_thicket, -- Constricting Thicket (Vines)
		[420671] = CL.pools, -- Noxious Blossom (Pools)
		[421029] = L.song_of_the_dragon, -- Song of the Dragon (Song)
		[418720] = L.polymorph_bomb, -- Polymorph Bomb (Ducks)
		[421024] = CL.pushback, -- Emerald Winds (Pushback)
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_EncounterEnd") -- stop skipped cast bars immediately on wipe

	-- General
	self:Log("SPELL_CAST_START", "Rebirth", 418187)
	self:Log("SPELL_CAST_SUCCESS", "RebirthSuccess", 418187)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 426390, 423551) -- Corrosive Pollen, Whimsical Gust
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 426390) -- Corrosive Pollen
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 426390)

	-- Urctos
	self:Log("SPELL_CAST_START", "BlindingRage", 420525)
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
	rebirthCount = 1
	rebirthTimers = {}

	specialCD = self:LFR() and 74.7 or 56
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
	self:Bar(421022, self:LFR() and 10.7 or self:Normal() and 8 or 5, CL.count:format(self:SpellName(421022), agonizingClawsCount)) -- Agonizing Claws
	self:Bar(420948, self:LFR() and 38.7 or self:Normal() and 29 or 13, CL.count:format(CL.charge, barrelingChargeCount)) -- Barreling Charge
	if self:Mythic() then -- Urctos + Aerwynn
		if self:GetOption("custom_off_combined_full_energy") then
			self:Bar(420525, specialCD, CL.count:format(CL.plus:format(self:SpellName(420525), L.constricting_thicket), specialCount)) -- Blinding Rage + Constricting Thicket
		else
			self:Bar(420525, specialCD, CL.count:format(self:SpellName(420525), blindingRageCount)) -- Blinding Rage
			self:Bar(421292, specialCD, CL.count:format(L.constricting_thicket, constrictingThicketCount)) -- Constricting Thicket
		end
	else
		self:Bar(420525, specialCD, CL.count:format(self:SpellName(420525), blindingRageCount)) -- Blinding Rage
	end
	nextSpecial = GetTime() + specialCD
	nextSpecialAbility = "urctos"

	-- Aerwynn
	-- self:Bar(421570, 0.5) -- Leap
	self:Bar(420671, self:LFR() and 14.7 or self:Normal() and 11 or 5, CL.count:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
	self:Bar(420858, self:LFR() and 26.7 or self:Normal() and 20 or 21, CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin

	-- Pip
	self:Bar(421501, self:LFR() and 30.7 or 23) -- Blink
	self:Bar(418720, self:LFR() and 46.6 or self:Normal() and 35 or 36, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
	self:Bar(421024, self:Mythic() and 43 or self:LFR() and 60.2 or 45.5, CL.count:format(CL.pushback, emeraldWindsCount)) -- Emerald Winds

	self:SetPrivateAuraSound(418720, 418589) -- Polymorph Bomb (Pre-Bomb)
end

function mod:BigWigs_EncounterEnd()
	for id, timer in next, rebirthTimers do
		self:CancelTimer(timer)
		rebirthTimers[id] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SpecialOver()
	activeSpecials = math.max(activeSpecials - 1, 0)
	if activeSpecials == 0 then
		self:StopBar(L.special_mechanic_bar:format(CL.charge, barrelingChargeCount)) -- Barreling Charge
		self:StopBar(L.special_mechanic_bar:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
		self:StopBar(L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb

		specialCount = specialCount + 1

		if agonizingClawsCount == 1 then -- don't start if Urctos is confused about the phase
			self:Bar(421022, self:LFR() and 10.7 or self:Normal() and 8 or 5, CL.count:format(self:SpellName(421022), agonizingClawsCount)) -- Agonizing Claws
			self:Bar(420948, self:LFR() and 38.7 or self:Normal() and 29 or 13, CL.count:format(CL.charge, barrelingChargeCount)) -- Barreling Charge
		end

		self:Bar(420671, self:LFR() and 14.7 or self:Normal() and 11 or 5, CL.count:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
		self:Bar(420858, self:LFR() and 26.7 or self:Normal() and 20 or 21, CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin
		self:Bar(421570, self:LFR() and 65.4 or 49) -- Leap (0.5, then 48.5, sometimes skipping the 0.5)

		self:Bar(418720, self:LFR() and 21.4 or 16, CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
		self:Bar(421501, self:LFR() and 30.7 or 23) -- Blink
		self:Bar(421024, self:Mythic() and 43 or self:LFR() and 60.2 or 45.5, CL.count:format(CL.pushback, emeraldWindsCount)) -- Emerald Winds

		nextSpecial = GetTime() + specialCD
		if nextSpecialAbility == "urctos" then
			nextSpecialAbility = "aerwynn"
			if self:Mythic() then -- Aerwynn + Pip
				if self:GetOption("custom_off_combined_full_energy") then
					self:Bar(421292, specialCD, CL.count:format(CL.plus:format(L.constricting_thicket, L.song_of_the_dragon), specialCount)) -- Constricting Thicket + Song of the Dragon
				else
					self:Bar(421029, specialCD, CL.count:format(L.song_of_the_dragon, songCount))  -- Song of the Dragon
					self:Bar(421292, specialCD, CL.count:format(L.constricting_thicket, constrictingThicketCount)) -- Constricting Thicket
				end
			else
				self:Bar(421292, specialCD, CL.count:format(L.constricting_thicket, constrictingThicketCount)) -- Constricting Thicket
			end
		elseif nextSpecialAbility == "aerwynn" then
			nextSpecialAbility = "pip"
			if self:Mythic() then -- Pip + Urctos
				if self:GetOption("custom_off_combined_full_energy") then
					self:Bar(421029, specialCD, CL.count:format(CL.plus:format(L.song_of_the_dragon, self:SpellName(420525)), specialCount)) -- Song of the Dragon + Blinding Rage
				else
					self:Bar(421029, specialCD, CL.count:format(L.song_of_the_dragon, songCount))  -- Song of the Dragon
					self:Bar(420525, specialCD, CL.count:format(self:SpellName(420525), blindingRageCount)) -- Blinding Rage
				end
			else
				self:Bar(421029, specialCD, CL.count:format(L.song_of_the_dragon, songCount)) -- Song of the Dragon
			end
		elseif nextSpecialAbility == "pip" then
			nextSpecialAbility = "urctos"
			if self:Mythic() then -- Urctos + Aerwynn
				if self:GetOption("custom_off_combined_full_energy") then
					self:Bar(420525, specialCD, CL.count:format(CL.plus:format(self:SpellName(420525), L.constricting_thicket), specialCount)) -- Blinding Rage + Constricting Thicket
				else
					self:Bar(420525, specialCD, CL.count:format(self:SpellName(420525), blindingRageCount)) -- Blinding Rage
					self:Bar(421292, specialCD, CL.count:format(L.constricting_thicket, constrictingThicketCount)) -- Constricting Thicket
				end
			else
				self:Bar(420525, specialCD, CL.count:format(self:SpellName(420525), blindingRageCount)) -- Blinding Rage
			end
		end
	end
end

-- General
function mod:Rebirth(args)
	local rebirthTime = self:Mythic() and 15 or self:Heroic() and 20 or self:Easy() and 30
	self:CastBar(args.spellId, rebirthTime, CL.count:format(args.spellName, rebirthCount))
	rebirthCount = rebirthCount + 1
	if not castingRebirth then
		self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "long")
		castingRebirth = true
	end

	-- handle skipping a cast due to rebirth
	local boss = self:MobId(args.sourceGUID)
	local remainingSpecialCD = nextSpecial - GetTime()
	if remainingSpecialCD > rebirthTime then
		if boss == 208363 then -- Urctos
			local remaining = self:BarTimeLeft(CL.count:format(self:SpellName(421022), agonizingClawsCount)) -- Agonizing Claws
			if remaining > 0 and remaining < rebirthTime then
				-- find the next cast time and set the correct count for it
				local timer = self:Easy() and { 8.0, 6.0, 25.0, 6.0 } or { 5.0, 4.0, 16.0, 4.0 }
				local count = 1
				local totalCD = remaining
				while timer[agonizingClawsCount + count] and (totalCD + timer[agonizingClawsCount + count] < rebirthTime) do
					totalCD = remaining + timer[agonizingClawsCount + count]
					count = count + 1
				end
				if timer[agonizingClawsCount + count] then
					rebirthTimers[421022] = self:ScheduleTimer(function()
						agonizingClawsCount = agonizingClawsCount + count
						self:Bar(421022, totalCD, CL.count:format(self:SpellName(421022), agonizingClawsCount))
					end, remaining)
				end
			end

			if not self:Easy() then
				remaining = self:BarTimeLeft(CL.count:format(CL.charge, barrelingChargeCount)) -- Barreling Charge
				if remaining > 0 and remaining < rebirthTime then
					rebirthTimers[420948] = self:ScheduleTimer(function()
						-- barrelingChargeCount = barrelingChargeCount + 1 -- does count matter? debuff should be off
						if nextSpecial - GetTime() > 25 then
							self:Bar(420948, 20, CL.count:format(CL.charge, barrelingChargeCount)) -- Barreling Charge
						end
					end, remaining)
				end
			end
		elseif boss == 208365 then -- Aerwynn
			local remaining = self:BarTimeLeft(CL.count:format(L.poisonous_javelin, poisonousJavelinCount)) -- Poisonous Javelin
			if remaining > 0 and remaining < rebirthTime then
				rebirthTimers[420858] = self:ScheduleTimer(function()
					if nextSpecial - GetTime() > 25 then
						self:Bar(420858, 25, CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
					end
				end, remaining)
			end
		elseif boss == 208956 then -- Pip
			local remaining = self:BarTimeLeft(CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
			if remaining > 0 and remaining < rebirthTime then
				rebirthTimers[418720] = self:ScheduleTimer(function()
					if nextSpecial - GetTime() > 25 then
						self:Bar(418720, self:Easy() and 19 or 20, CL.count:format(L.polymorph_bomb, polymorphBombCount))
					end
				end, remaining)
			end
			-- Noxious Blossom logic is annoying, so just let the next cast figure things out
		end
	elseif not self:Mythic() then
		-- special should happen while rebirth is casting
		if (boss == 208363 and nextSpecialAbility == "urctos") or (boss == 208365 and nextSpecialAbility == "aerwynn") or (boss == 208956 and nextSpecialAbility == "pip") then
			-- it's not 5s ticks, was the first 10s tick for two heroic logs
			local restartCD = (nextSpecial + 10) - (GetTime() + rebirthTime)
			while restartCD < 0 do
				restartCD = restartCD + 10
			end
			rebirthTimers[boss] = self:ScheduleTimer(function()
				agonizingClawsCount = 1
				self:SpecialOver()
			end, restartCD)
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
	self:StopBar(CL.count:format(CL.plus:format(args.spellName, L.constricting_thicket), specialCount)) -- Blinding Rage + Constricting Thicket
	self:StopBar(CL.count:format(CL.plus:format(L.song_of_the_dragon, self:SpellName(420525)), specialCount)) -- Song of the Dragon + Blinding Rage
	self:StopBar(CL.count:format(args.spellName, blindingRageCount)) -- Blinding Rage

	self:Message(args.spellId, "orange", CL.count:format(args.spellName, blindingRageCount)) -- Urctos ult
	self:PlaySound(args.spellId, "alert") -- duck boss
	blindingRageCount = blindingRageCount + 1

	activeSpecials = activeSpecials + 1
	agonizingClawsCount = 1 -- reset on all specials start because Urctos gets weird if interrupted during the Blinding Rage cast

	-- if not self:Mythic() or nextSpecialAbility == "pip" then
	-- 	self:Bar(420671, self:Mythic() and 1 or self:LFR() and 4 or self:Normal() and 3 or 5, L.special_mechanic_bar:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
	-- end
	-- self:Bar(418720, self:LFR() and 12 or 9, L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
end

function mod:BlindingRageOver()
	self:StopBar(L.special_mechanic_bar:format(CL.pools, noxiousBlossomCount)) -- Noxious Blossom
	self:StopBar(L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount)) -- Polymorph Bomb
	self:SpecialOver()

	if activeSpecials > 0 and specialChain[nextSpecialAbility] == "aerwynn" then -- Urctos + Aerwynn
		self:StopBar(CL.count:format(CL.charge, barrelingChargeCount)) -- make sure we're not duplicating
		self:Bar(420948, 2.5, L.special_mechanic_bar:format(CL.charge, barrelingChargeCount))
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
		self:StopBar(L.special_mechanic_bar:format(CL.charge, barrelingChargeCount))
		self:StopBar(CL.count:format(CL.charge, barrelingChargeCount))
		barrelingChargeCount = barrelingChargeCount + 1

		if activeSpecials > 0 then -- short recast during specials
			self:Bar(420948, self:LFR() and 10 or 8, L.special_mechanic_bar:format(CL.charge, barrelingChargeCount))
		elseif not self:Easy() and nextSpecial - GetTime() > 25 then -- 43s
			self:Bar(420948, 20, CL.count:format(CL.charge, barrelingChargeCount)) -- second cast on heroic/mythic
		elseif nextSpecialAbility == "aerwynn" then -- cast 3/4s after Constricting Thicket
			-- replaces bar in :ConstrictingThicket
			local cd = self:Mythic() and 27 or self:LFR() and 40 or self:Normal() and 30 or 26
			self:Bar(420948, cd, L.special_mechanic_bar:format(CL.charge, barrelingChargeCount))
		end
	end

	function mod:BarrelingChargeApplied(args)
		self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(CL.charge, barrelingChargeCount - 1))
		if self:Me(args.destGUID) then
			self:Yell(args.spellId, CL.charge, nil, "Charge")
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
	if self:LFR() then
		local timer = { 10.6, 8.0, 33.3, 8.0 }
		cd = timer[agonizingClawsCount]
	elseif self:Normal() then
		local timer = { 8.0, 6.0, 25.0, 6.0 }
		cd = timer[agonizingClawsCount]
	else
		local timer = { 5.0, 4.0, 16.0, 4.0 }
		cd = timer[agonizingClawsCount]
	end
	self:Bar(421022, cd or 0, CL.count:format(args.spellName, agonizingClawsCount)) -- shhh, just be wrong until next specal without erroring
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
	self:StopBar(CL.count:format(CL.plus:format(self:SpellName(420525), L.constricting_thicket), specialCount)) -- Blinding Rage + Constricting Thicket
	self:StopBar(CL.count:format(CL.plus:format(L.constricting_thicket, L.song_of_the_dragon), specialCount)) -- Constricting Thicket + Song of the Dragon
	self:StopBar(CL.count:format(L.constricting_thicket, constrictingThicketCount)) -- Constricting Thicket

	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.constricting_thicket, constrictingThicketCount))) -- Aerwynn ult
	self:PlaySound(args.spellId, "alert") -- Interrupt
	constrictingThicketCount = constrictingThicketCount + 1

	activeSpecials = activeSpecials + 1
	agonizingClawsCount = 1 -- reset on all specials start because Urctos gets weird if interrupted during the Blinding Rage cast
end

function mod:ConstrictingThicketOver()
	self:StopBar(L.special_mechanic_bar:format(CL.charge, barrelingChargeCount)) -- Barreling Charge
	self:SpecialOver()

	if activeSpecials > 0 and specialChain[nextSpecialAbility] == "pip" then -- Aerwynn + Pip
		self:StopBar(CL.count:format(CL.pools, noxiousBlossomCount)) -- make sure we're not duplicating
		self:Bar(420671, 5, L.special_mechanic_bar:format(CL.pools, noxiousBlossomCount))
	end
end

function mod:AerwynnBarrelingCharge()
	self:Message(421292, "green", CL.interrupted:format(L.constricting_thicket)) -- Aerwynn interrupted
	self:PlaySound(421292, "info")
end

function mod:ConstrictingThicketApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 4 == 0 then -- 4, 8...
			self:StackMessage(421292, "blue", args.destName, args.amount, 4)
			self:PlaySound(421292, "alarm") -- watch movement
		end
	end
end

function mod:RelentlessBarrage(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- didn't interrupt
	-- XXX does Aerwynn still cast her regular abilities?
end

function mod:NoxiousBlossom(args)
	local spellName = CL.pools
	self:StopBar(L.special_mechanic_bar:format(spellName, noxiousBlossomCount))
	self:StopBar(CL.count:format(spellName, noxiousBlossomCount))

	self:Message(args.spellId, "yellow", CL.count:format(spellName, noxiousBlossomCount))
	noxiousBlossomCount = noxiousBlossomCount + 1

	if self:LFR() and activeSpecials > 0 and nextSpecialAbility == "pip" then -- short recast during specials XXX need to recheck other difficulties
		self:Bar(args.spellId, 10, L.special_mechanic_bar:format(spellName, noxiousBlossomCount)) -- 9.3/10.6 but another var for knowning which modulus to use z.z
	elseif activeSpecials == 0 then -- only initial cast during specials?
		-- normal 11.0, 22.0, 21.0 / heroic 5.0, 20.0, 29.0 / lfr 14.7, 29.3, [34.7]
		local remainingSpecialCD = nextSpecial - GetTime()
		if remainingSpecialCD > 40 then -- 45 / 51s (non easy) / 60s lfr
			self:Bar(args.spellId, self:LFR() and 29.3 or self:Normal() and 22 or 20, CL.count:format(spellName, noxiousBlossomCount)) -- normal cast 2
		elseif nextSpecialAbility == "urctos" and not self:LFR() then
			if remainingSpecialCD > 20 then -- 23s / 31s (non easy) / no lfr
				self:Bar(args.spellId, self:Mythic() and 27 or self:Normal() and 21 or 29, CL.count:format(spellName, noxiousBlossomCount)) -- normal cast 3
			elseif not self:Mythic() then -- 2s
				-- replaces bar in :BlindingRage
				self:Bar(args.spellId, 7, L.special_mechanic_bar:format(spellName, noxiousBlossomCount))
			end
		elseif nextSpecialAbility == "pip" and not self:Mythic() then
			-- replaces bar in :SongOfTheDragon
			self:Bar(args.spellId, self:LFR() and 34.7 or self:Normal() and 26 or 29, L.special_mechanic_bar:format(spellName, noxiousBlossomCount))
		end
	end
end

function mod:PoisonousJavelin(args)
	self:StopBar(CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	self:Message(420858, "yellow", CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	poisonousJavelinCount = poisonousJavelinCount + 1
	if nextSpecial - GetTime() > 25 then
		self:Bar(420858, self:LFR() and 33.3 or 25, CL.count:format(L.poisonous_javelin, poisonousJavelinCount))
	end
end

function mod:PoisonousJavelinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.poisonous_javelin)
		self:PlaySound(args.spellId, self:Mythic() and "warning" or "alarm") -- move away in mythic
		if self:Mythic() then
			self:Say(args.spellId, L.poisonous_javelin, nil, "Javelin")
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
	local cd = self:LFR() and 64.7 or 48.5
	if nextSpecial - GetTime() > cd then
		-- Starting bars with a max set which is the same max as the start of :SpecialOver
		-- This is to avoid the bars from flickering if the boss casts Leap right after a special isntead
		self:Bar(args.spellId, { cd, self:LFR() and 65.4 or 49 })
	end
end

-- Pip
function mod:SongOfTheDragon(args)
	self:StopBar(CL.count:format(CL.plus:format(L.constricting_thicket, L.song_of_the_dragon), specialCount)) -- Constricting Thicket + Song of the Dragon
	self:StopBar(CL.count:format(CL.plus:format(L.song_of_the_dragon, self:SpellName(420525)), specialCount)) -- Song of the Dragon + Blinding Rage
	self:StopBar(CL.count:format(L.song_of_the_dragon, songCount)) -- Song of the Dragon

	self:Message(args.spellId, "orange", CL.count:format(L.song_of_the_dragon, songCount)) -- Pip ult
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, self:Mythic() and 14 or 24, CL.count:format(L.song_of_the_dragon, songCount))
	songCount = songCount + 1

	activeSpecials = activeSpecials + 1
	agonizingClawsCount = 1 -- reset on all specials start because Urctos gets weird if interrupted during the Blinding Rage cast
end

function mod:SongOfTheDragonOver(args)
	self:StopBar(CL.cast:format(CL.count:format(L.song_of_the_dragon, songCount)))

	self:Message(args.spellId, "green", CL.over:format(L.song_of_the_dragon)) -- Pip ult over
	self:PlaySound(args.spellId, "info")

	self:SpecialOver()

	if activeSpecials > 0 and specialChain[nextSpecialAbility] == "urctos" then -- Pip + Urctos
		self:StopBar(CL.count:format(L.polymorph_bomb, polymorphBombCount)) -- make sure we're not duplicating
		self:Bar(418720, 2.5, L.special_mechanic_bar:format(L.polymorph_bomb, polymorphBombCount))
	end
end

function mod:SongOfTheDragonApplied(args)
	if self:Me(args.destGUID) then
		songOnMe = true
		self:PersonalMessage(421029, nil, L.song_of_the_dragon)
		self:PlaySound(421029, "warning", nil, args.destName)
	end
end

function mod:SongOfTheDragonRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(421029, false, CL.removed:format(L.song_of_the_dragon))
		self:PlaySound(421029, "warning", nil, args.destName)
		self:SimpleTimer(function() songOnMe = false end, 1) -- Give some time to get out before showing a damage warning
	end
end

function mod:CaptivatingFinaleApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:Yell(args.spellId, nil, nil, "Captivating Finale") -- Maybe get saved
	end
end

function mod:CaptivatingFinaleRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	end
end

function mod:PolymorphBomb()
	local spellName = L.polymorph_bomb
	self:StopBar(L.special_mechanic_bar:format(spellName, polymorphBombCount))
	self:StopBar(CL.count:format(spellName, polymorphBombCount))

	self:Message(418720, "yellow", CL.count:format(spellName, polymorphBombCount))
	self:PlaySound(418720, "alert")
	polymorphBombCount = polymorphBombCount + 1

	if activeSpecials > 0 then -- short recast during specials (you only get one extra cast?)
		self:Bar(418720, self:LFR() and 12 or self:Normal() and 9 or 11, L.special_mechanic_bar:format(spellName, polymorphBombCount))
	elseif nextSpecial - GetTime() > 30 then -- 40s / 53s lfr
		self:Bar(418720, self:LFR() and 25.3 or self:Normal() and 19 or 20, CL.count:format(spellName, polymorphBombCount)) -- normal cast 2
	elseif nextSpecialAbility == "urctos" then
		local remainingBlindingRageCD = nextSpecial - GetTime()
		if remainingBlindingRageCD < 30 and remainingBlindingRageCD > 3 then -- 20s / 28s lfr
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
	self:StopBar(CL.count:format(CL.pushback, emeraldWindsCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.pushback, emeraldWindsCount))
	self:PlaySound(args.spellId, "alarm") -- move for pushback
	emeraldWindsCount = emeraldWindsCount + 1
	-- 1 per special
end

function mod:Blink(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "cyan")
	-- self:PlaySound(args.spellId, "info")

	local cd
	if self:Mythic() then
		cd = nextSpecialAbility == "pip" and 28 or 27
	else
		cd = self:LFR() and 37.2 or 30
	end
	if nextSpecial - GetTime() > cd then
		self:Bar(args.spellId, cd)
	end
end
