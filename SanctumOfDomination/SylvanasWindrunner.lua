--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sylvanas Windrunner", 2450, 2441)
if not mod then return end
mod:RegisterEnableMob(175732) -- Sylvanas Windrunner
mod:SetEncounterID(2435)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local windrunnerCount = 1
local dominationChainsCount = 1
local veilofDarknessCount = 1
local wailingArrowCount = 1
local riveCount = 1
local bansheeWailCount = 1
local ruinCount = 1
local hauntingWaveCount = 1
local bansheesBaneCount = 1
local bansheeScreamCount = 1
local razeCount = 1
local bansheesFuryCount = 1
local rangerHeartSeekerCount = 1
local rangersHeartSeekerTimers = {18, 22, 15, 19, 11.6, 4.5, 30, 3, 29.5, 3, 20.2, 3}
local intermission = false
local bansheeShroudRemovedCount = 1
local deathKnivesCount = 1
local mercilessCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.chains_active = "Chains Active"
	L.chains_active_desc = "Show a bar for when the Chains of Domination activate"
	L.chains_active_icon = 349458
	L.chains_active_bartext = "%d Active" -- Chains Active

	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 358711

	L.chains = "Chains" -- Short for Domination Chains
	L.chain = "Chain" -- Single Domination Chain
	L.darkness = "Darkness" -- Short for Veil of Darkness
	L.arrow = "Arrow" -- Short for Wailing Arrow
	L.wave = "Wave" -- Short for Haunting Wave
	L.dread = "Dread" -- Short for Crushing Dread
	L.orbs = "Orbs" -- Dark Communion
	L.curse = "Curse" -- Short for Curse of Lethargy
	L.pools = "Pools" -- Banshee's Bane
	L.scream = "Scream" -- Banshee Scream

	L.knife_fling = "Knives out!" -- "Death-touched blades fling out"
end

--------------------------------------------------------------------------------
-- Initialization
--

local wailingArrowMarker = mod:AddMarkerOption(false, "player", 1, 347609, 1, 2, 3) -- Wailing Arrow
local expulsionMarker = mod:AddMarkerOption(false, "player", 1, 351562, 1, 2, 3, 4, 5, 6) -- Expulsion
function mod:GetOptions()
	return {
		-- General
		"stages",
		-- Stage One: A Cycle of Hatred
		347504, -- Windrunner
		347807, -- Barbed Arrow
		356377, -- Desecrating Shot
		347670, -- Shadow Dagger
		{349458, "ME_ONLY_EMPHASIZE"}, -- Domination Chains
		"chains_active",
		347704, -- Veil of Darkness
		{347609, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Wailing Arrow
		wailingArrowMarker,
		{352650, "TANK"}, -- Ranger's Heartseeker
		{347607, "TANK"}, -- Banshee's Mark
		-- Intermission: A Monument to our Suffering
		353417, -- Rive
		348109, -- Banshee Wail
		-- Stage Two: The Banshee Queen
		355540, -- Ruin
		351869, -- Haunting Wave
		{351180, "TANK"}, -- Lashing Wound
		351117, -- Crushing Dread
		351353, -- Summon Decrepit Orbs
		351939, -- Curse of Lethargy
		{351672, "TANK"}, -- Fury
		-- Stage Three: The Freedom of Choice
		353929, -- Banshee's Bane
		353972, -- Bane Arrows
		{353965, "TANK"}, -- Banshee's Heartseeker
		354068, -- Banshee's Fury
		{357720, "SAY"}, -- Banshee Scream
		354147, -- Raze
		-- Mythic
		{358704, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Black Arrow
		358711, -- Rage
		"custom_on_nameplate_fixate",
		356021, -- Dark Communion (Mawforged Summoner)
		351591, -- Filth (Mawforged Colossus)
		{351562, "SAY", "SAY_COUNTDOWN"}, -- Expulsion (Mawforged Colossus)
		expulsionMarker,
		358185, -- Banshee's Weapons
		358181, -- Banshee's Blades
		{358434, "SAY", "SAY_COUNTDOWN"}, -- Death Knives
		358588, -- Merciless
	},{
		["stages"] = "general",
		[347504] = -23057, -- Stage One: A Cycle of Hatred
		[348145] = -22891, -- Intermission: A Monument to our Suffering
		[355540] = -23067, -- Stage Two: The Banshee Queen
		[353929] = -22890, -- Stage Three: The Freedom of Choice
		[358704] = "mythic",
	},{
		[349458] = L.chains, -- Domination Chains (Chains)
		[347704] = L.darkness, -- Veil of Darkness (Darkness)
		[347609] = L.arrow, -- Wailing Arrow (Arrow)
		[358704] = L.arrow, -- Black Arrow (Arrow)
		[351117] = L.dread, -- Crushing Dread (Dread)
		[351353] = L.orbs, -- Summon Decrepit Orbs
		[356021] = L.orbs, -- Dark Communion (Orbs)
		[351939] = L.curse, -- Curse of Lethargy (Curse)
		[353929] = L.pools, -- Banshee's Bane (Pools)
		[357720] = L.scream, -- Banshee Scream
	}
end

function mod:OnBossEnable()
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "RageApplied", 358711) -- Dark Sentinel Fixate
	self:Log("SPELL_AURA_REMOVED", "RageRemoved", 358711)
	self:Log("SPELL_CAST_START", "DarkCommunion", 356021)
	self:Log("SPELL_CAST_SUCCESS", "Filth", 351589)
	self:Log("SPELL_AURA_APPLIED", "FilthApplied", 351591)
	self:Log("SPELL_AURA_APPLIED", "ExpulsionApplied", 351562)
	self:Log("SPELL_AURA_REMOVED", "ExpulsionRemoved", 351562)
	self:Death("ColossusDeath", 177893) -- Mawforged Colossus
	self:Log("SPELL_AURA_APPLIED", "BansheesWeaponsApplied", 358185)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesWeaponsApplied", 358185)
	self:Log("SPELL_CAST_START", "BansheesBlades", 358181)
	self:Log("SPELL_AURA_APPLIED", "DeathKnivesApplied", 358434)
	self:Log("SPELL_AURA_REMOVED", "DeathKnivesRemoved", 358434)
	self:Log("SPELL_CAST_SUCCESS", "Merciless", 358588)

	-- Stage One: A Cycle of Hatred
	self:Log("SPELL_AURA_APPLIED", "Windrunner", 347504)
	self:Log("SPELL_AURA_APPLIED", "BarbedArrowApplied", 347807)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BarbedArrowApplied", 347807)
	self:Log("SPELL_DAMAGE", "DesecratingShotDamage", 356377)
	self:Log("SPELL_AURA_APPLIED", "ShadowDaggerApplied", 347670)
	self:Log("SPELL_CAST_START", "DominationChains", 349458)
	self:Log("SPELL_AURA_APPLIED", "DominationChainsApplied", 349458)
	self:Log("SPELL_CAST_START", "VeilOfDarkness", 347726, 347741, 354142) -- Stage 1, Stage 2, Stage 3
	self:Log("SPELL_AURA_APPLIED", "VeilOfDarknessApplied", 347704)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VeilOfDarknessApplied", 347704)
	self:Log("SPELL_CAST_START", "WailingArrow", 347609, 358704) -- Wailing Arrow, Black Arrow (Mythic)
	self:Log("SPELL_AURA_APPLIED", "WailingArrowApplied", 347609, 358704)
	self:Log("SPELL_AURA_REMOVED", "WailingArrowRemoved", 347609, 358704)
	self:Log("SPELL_AURA_APPLIED", "RangersHeartseeker", 352663)
	self:Log("SPELL_AURA_APPLIED", "RangersHeartseekerApplied", 352650)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RangersHeartseekerApplied", 352650)
	self:Log("SPELL_AURA_APPLIED", "BansheesMarkApplied", 347607)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesMarkApplied", 347607)

	-- Intermission: A Monument to our Suffering
	self:Log("SPELL_AURA_APPLIED", "BansheeShroudApplied", 350857)
	self:Log("SPELL_CAST_SUCCESS", "Rive", 353417, 353418) -- Both used in Intermission
	self:Log("SPELL_CAST_SUCCESS", "BansheeWail", 348109)

	-- Stage Two: The Banshee Queen
	self:Log("SPELL_AURA_APPLIED", "BansheeFormApplied", 348146)
	self:Log("SPELL_AURA_REMOVED", "BansheeShroudRemoved", 350857)
	self:Log("SPELL_CAST_START", "Ruin", 355540)
	self:Log("SPELL_CAST_SUCCESS", "HauntingWave", 351869)
	self:Log("SPELL_CAST_START", "LashingStrike", 351179)
	self:Log("SPELL_AURA_APPLIED", "LashingWoundApplied", 351180)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LashingWoundApplied", 351180)
	self:Log("SPELL_CAST_SUCCESS", "CrushingDread", 351117)
	self:Log("SPELL_AURA_APPLIED", "CrushingDreadApplied", 351117)
	self:Death("SouljudgeDeath", 177889) -- Mawforged Souljudge
	self:Log("SPELL_CAST_START", "SummonDecrepitOrbs", 351353)
	self:Log("SPELL_CAST_SUCCESS", "CurseOfLethargy", 351939)
	self:Log("SPELL_AURA_APPLIED", "CurseOfLethargyApplied", 351939)
	self:Death("SummonerDeath", 177891) -- Mawforged Summoner
	self:Log("SPELL_AURA_APPLIED", "FuryApplied", 351672)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryApplied", 351672)

	-- Stage Three: The Freedom of Choice
	self:Log("SPELL_CAST_START", "RaidPortalOribos", 357102)
	self:Log("SPELL_AURA_APPLIED", "BansheesBaneApplied", 353929)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesBaneApplied", 353929)
	self:Log("SPELL_CAST_SUCCESS", "BaneArrows", 353972)
	self:Log("SPELL_AURA_APPLIED", "BansheesHeartseekerApplied", 353965)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesHeartseekerApplied", 353965)
	self:Log("SPELL_CAST_START", "BansheesFury", 354068)
	self:Log("SPELL_AURA_APPLIED", "BansheeScreamApplied", 357720)
	self:Log("SPELL_CAST_START", "Raze", 354147)

	if self:Mythic() and self:GetOption("custom_on_nameplate_fixate") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	self:SetStage(1)
	windrunnerCount = 1
	dominationChainsCount = 1
	veilofDarknessCount = 1
	wailingArrowCount = 1
	rangerHeartSeekerCount = 1
	intermission = false

	self:Bar(352650, rangersHeartSeekerTimers[rangerHeartSeekerCount]) -- Ranger's Heartseeker
	self:Bar(347504, 7.5, CL.count:format(self:SpellName(347504), windrunnerCount)) -- Windrunner
	self:Bar(349458, 26, CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
	self:Bar(347704, 48.5, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	self:Bar(347609, 36.5, CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

function mod:OnBossDisable()
	if self:Mythic() and self:GetOption("custom_on_nameplate_fixate") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 83 then -- Intermission at 80%
		self:Message("stages", "green", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-----------
-- Mythic
-----------

function mod:RageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		if self:GetOption("custom_on_nameplate_fixate") then
			self:AddPlateIcon(358711, args.sourceGUID) -- 358711 = ability_fixated_state_purple
		end
	end
end

function mod:RageRemoved(args)
	if self:Me(args.destGUID) and self:GetOption("custom_on_nameplate_fixate") then
		self:RemovePlateIcon(358711, args.sourceGUID)
	end
end

function mod:DarkCommunion(args)
	self:Message(args.spellId, "orange", L.orbs)
	self:PlaySound(args.spellId, "long")
	-- self:Bar(args.spellId, 16)
end

function mod:ColossusDeath(args)
	self:StopBar(351591) -- Filth
	self:StopBar(351562) -- Expulsion
end

function mod:Filth(args)
	self:Message(351591, "purple", CL.casting:format(args.spellName))
	-- self:PlaySound(351591, "info")
	-- self:Bar(351591, 20)
end

function mod:FilthApplied(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
		if amount % 2 == 0 then
			self:PlaySound(args.spellId, "warning")
		end
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:ExpulsionApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
			-- self:Bar(args.spellId, 20)
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(args.spellId, 4.5, count) -- EJ says 6, spell says 4.5
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
		self:CustomIcon(expulsionMarker, args.destName, icon)
	end
end

function mod:ExpulsionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:CustomIcon(expulsionMarker, args.destName)
end

function mod:BansheesWeaponsApplied(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, amount)) -- Banshee's Weapons (1)-(4)
	-- XXX Should probably add bars for Heartseeker and Blades
	-- Also kind of noisy for tanks? alarm (stack) 3s warning (shot) 1.5s alarm (bane)
	if amount == 3 then -- Banshee's Heartseeker next shot
		self:PlaySound(args.spellId, "alarm")
	elseif amount == 4 then -- Banshee's Blades next shot
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BansheesBlades(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	if self:Tanking("boss1") then
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local prev = 0
	function mod:DeathKnivesApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "orange", CL.count:format(args.spellName, deathKnivesCount))
			self:Bar(args.spellId, 5, L.knife_fling)
			deathKnivesCount = deathKnivesCount + 1
			--self:Bar(args.spellId, 25, CL.count:format(args.spellName, deathKnivesCount))
		end
		if self:Me(args.destGUID)then
			self:PersonalMessage(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:DeathKnivesRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:Merciless(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, mercilessCount))
	self:PlaySound(args.spellId, "alert")
	mercilessCount = mercilessCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, mercilessCount))
end

---------------------------------
-- Stage One: A Cycle of Hatred
---------------------------------

function mod:Windrunner(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, windrunnerCount))
	self:PlaySound(args.spellId, "alert")
	windrunnerCount = windrunnerCount + 1
	if not intermission then
		self:Bar(args.spellId, windrunnerCount == 2 and 52 or 50.5, CL.count:format(args.spellName, windrunnerCount))
	end
end

function mod:BarbedArrowApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:DesecratingShotDamage(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou")
	end
end

function mod:ShadowDaggerApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:DominationChains(args)
	self:Message(args.spellId, "red", CL.count:format(L.chains, dominationChainsCount))
	self:PlaySound(args.spellId, "warning")
	self:Bar("chains_active", 7.2, L.chains_active_bartext:format(CL.count:format(L.chains, dominationChainsCount)), args.spellId) -- Chains (x) Active
	dominationChainsCount = dominationChainsCount + 1
	if not intermission then
		self:Bar(args.spellId, 52, CL.count:format(L.chains, dominationChainsCount))
	end
end

function mod:DominationChainsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.chain)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VeilOfDarkness(args)
	self:Message(347704, "yellow", CL.count:format(L.darkness, veilofDarknessCount))
	self:PlaySound(347704, "alert")
	veilofDarknessCount = veilofDarknessCount + 1
	if self:GetStage() == 1 and not intermission then
		self:Bar(347704, 49, CL.count:format(L.darkness, veilofDarknessCount))
	-- elseif self:GetStage() == 3 then -- XXX No cast currently
	-- 	self:Bar(347704, 0, CL.count:format(L.darkness, veilofDarknessCount))
	end
end

do
	local prev = 0
	function mod:VeilOfDarknessApplied(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				local _, amount = self:UnitDebuff(args.destName, args.spellId) -- Checking amout as it starts with 5 in Heroic & Mythic
				self:NewStackMessage(args.spellId, "blue", args.destName, amount, nil, L.darkness)
				self:PlaySound(args.spellId, "warning")
			end
		end
	end
end

do
	function mod:WailingArrow(args)
		self:Message(args.spellId, "yellow", CL.count:format(L.arrow, wailingArrowCount))
		self:PlaySound(args.spellId, "alert")
		wailingArrowCount = wailingArrowCount + 1
		if not intermission then
			self:Bar(args.spellId, 34, CL.count:format(L.arrow, wailingArrowCount))
		end
	end

	local wailingArrowPlayerCount = 0
	local myArrow = 0
	local prev = 0
	function mod:WailingArrowApplied(args)
		local t = args.time
		if t-prev > 15 then -- New set
			prev = t
			wailingArrowPlayerCount = 0
		end
		wailingArrowPlayerCount = wailingArrowPlayerCount + 1
		if self:GetStage() == 1 then -- Update the bar with exact timing
			self:Bar(args.spellId, 6, CL.count:format(L.arrow, wailingArrowCount))
		elseif self:GetStage() == 3 and wailingArrowPlayerCount == 1 then -- Only the first in stage 3
			self:Bar(args.spellId, 6, CL.count:format(L.arrow, wailingArrowCount))
		end
		self:CustomIcon(wailingArrowMarker, args.destName, wailingArrowPlayerCount)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, CL.count:format(L.arrow, wailingArrowPlayerCount))
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId, CL.count_rticon:format(L.arrow, wailingArrowPlayerCount, wailingArrowPlayerCount))
			self:SayCountdown(args.spellId, 9)
			self:TargetBar(args.spellId, 9, args.destName, CL.count:format(L.arrow, wailingArrowPlayerCount))
			myArrow = wailingArrowPlayerCount
		end
	end

	function mod:WailingArrowRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:StopBar(CL.count:format(L.arrow, wailingArrowPlayerCount), args.destName)
			self:CustomIcon(wailingArrowMarker, args.destName)
		end
	end
end

function mod:RangersHeartseeker(args)
	self:Message(352650, "purple", CL.casting:format(args.spellName))
	if self:Tanking("boss1") then
		self:PlaySound(352650, "warning")
	end
	rangerHeartSeekerCount = rangerHeartSeekerCount + 1
	if not intermission then
		self:Bar(352650, rangersHeartSeekerTimers[rangerHeartSeekerCount])
	end
end

function mod:RangersHeartseekerApplied(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, amount))
end

function mod:BansheesMarkApplied(args)
	local amount = args.amount or 1
	if amount > 2 then -- 3 stacks per combo
		self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

----------------------------------------------
-- Intermission: A Monument to our Suffering
----------------------------------------------

function mod:BansheeShroudApplied()
	if self:GetStage() == 1 and not intermission then
		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")

		self:StopBar(352650) -- Ranger's Heartseeker
		self:StopBar(CL.count:format(self:SpellName(347504), windrunnerCount)) -- Windrunner
		self:StopBar(CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
		self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		self:StopBar(CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow

		intermission = true
		dominationChainsCount = 1
		riveCount = 1
		bansheeWailCount = 1
	end
end

function mod:Rive(args)
	self:Message(353417, "red", CL.count:format(args.spellName, riveCount))
	self:PlaySound(353417, "alert")
	riveCount = riveCount + 1
	if riveCount == 2 then -- Most reliable way to start intermission timers atm...
		-- Start some timers
	end
end

function mod:BansheeWail(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, bansheeWailCount))
	self:PlaySound(args.spellId, "alarm")
	bansheeWailCount = bansheeWailCount + 1
end

---------------------------------
-- Stage Two: The Banshee Queen
---------------------------------

function mod:BansheeFormApplied()
	if self:GetStage() == 1 then
		self:SetStage(2)
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		self:StopBar(CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
		self:StopBar(CL.count:format(self:SpellName(348145), riveCount)) -- Rive
		self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail

		veilofDarknessCount = 1
		bansheeWailCount = 1
		ruinCount = 1
		hauntingWaveCount = 1
		bansheeShroudRemovedCount = 1
	end
end

function mod:BansheeShroudRemoved(args)
	self:Message("stages", "cyan", CL.removed:format(CL.count:format(args.spellName, bansheeShroudRemovedCount)), args.spellId)
	self:CDBar("stages", 38, args.spellName, args.spellId)
	bansheeShroudRemovedCount = bansheeShroudRemovedCount + 1
end

function mod:Ruin(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(args.spellName, ruinCount)))
	self:PlaySound(args.spellId, "warning")
	ruinCount = ruinCount + 1
end

function mod:HauntingWave(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.wave, hauntingWaveCount))
	self:PlaySound(args.spellId, "alert")
	hauntingWaveCount = hauntingWaveCount + 1
end

function mod:LashingStrike(args)
	self:Bar(351180, 7.5) -- Lashing Wound
end

function mod:LashingWoundApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount)
	if amount > 1 then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CrushingDread(args)
	self:Bar(args.spellId, 11)
end

function mod:CrushingDreadApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.dread)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SouljudgeDeath()
	self:StopBar(351180) -- Lashing Wound
	self:StopBar(351117) -- Crushing Dread
end

function mod:SummonDecrepitOrbs(args)
	self:Message(args.spellId, "orange", L.orbs)
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 16, L.orbs)
end

function mod:CurseOfLethargy(args)
	self:Bar(args.spellId, 7.5)
end

function mod:CurseOfLethargyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.curse)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SummonerDeath()
	self:StopBar(L.orbs) -- Summon Decrepit Orbs / Dark Communion
	self:StopBar(351939) -- Curse of Lethargy
end

function mod:FuryApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 10 then
		self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
		self:PlaySound(args.spellId, "alert")
	end
end

---------------------------------------
-- Stage Three: The Freedom of Choice
---------------------------------------

function mod:RaidPortalOribos()
	self:SetStage(3)
	self:Message("stages", "cyan", CL.soon:format(CL.stage:format(3)), false)
	self:PlaySound("stages", "long")

	self:StopBar(L.orbs) -- Summon Decrepit Orbs / Dark Communion
	self:StopBar(351939) -- Curse of Lethargy
	self:StopBar(351180) -- Lashing Wound
	self:StopBar(351117) -- Crushing Dread
	self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
	self:StopBar(CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
	self:StopBar(CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave

	veilofDarknessCount = 1
	wailingArrowCount = 1
	bansheeScreamCount = 1
	razeCount = 1
	bansheesFuryCount = 1
	deathKnivesCount = 1
	mercilessCount = 1

	--self:Bar("stages", 10, CL.stage:format(3), args.spellId)
	--self:Bar(347704, 25, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	--self:Bar(347609, 25, CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow
	--self:Bar(357720, 25, CL.count:format(L.scream, bansheeScreamCount)) -- Banshee Scream
	--self:Bar(354068, 25, CL.count:format(self:SpellName(354068), bansheesFuryCount)) -- Banshee's Fury
	--self:Bar(354147, 25, CL.count:format(self:SpellName(354147), razeCount)) -- Raze
	-- if self:Mythic() then
	-- 	self:Bar(358434, 25, CL.count:format(self:SpellName(358434), deathKnivesCount)) -- Death's Knives
	-- 	self:Bar(358588, 25, CL.count:format(self:SpellName(358588), mercilessCount)) -- Merciless
	-- end
end

function mod:BansheesBaneApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount, nil, L.pools)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BaneArrows(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:BansheesHeartseekerApplied(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, amount)) -- Banshee's Heartseeker (1)-(3)
	-- XXX Should probably add a bar for Heartseeker
	if amount == 3 then -- Damage inc
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:BansheesFury(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, bansheesFuryCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 5) -- 1s precast, 4s before the explosions
	bansheesFuryCount = bansheesFuryCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, bansheesFuryCount))
end

do
	local prev = 0
	function mod:BansheeScreamApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "orange", CL.count:format(L.scream, bansheeScreamCount))
			bansheeScreamCount = bansheeScreamCount + 1
			--self:Bar(args.spellId, 25, CL.count:format(L.scream, bansheeScreamCount))
		end
		if self:Me(args.destGUID)then
			self:PersonalMessage(args.spellId, L.scream)
			self:Say(args.spellId, L.scream)
			--self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:Raze(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, razeCount))
	self:PlaySound(args.spellId, "warning")
	razeCount = razeCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, razeCount))
end
