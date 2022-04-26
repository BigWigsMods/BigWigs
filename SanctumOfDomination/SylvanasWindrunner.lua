--------------------------------------------------------------------------------
-- TODO:
-- -- Mark Terror Orb with skull (Mythic)

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

local intermission = false
local windrunnerCount = 1
local dominationChainsCount = 1
local veilofDarknessCount = 1
local wailingArrowCount = 1
local riveCount = 1
local bansheeWailCount = 1
local ruinCount = 1
local hauntingWaveCount = 1
local bansheeScreamCount = 1
local razeCount = 1
local bansheesFuryCount = 1
local rangerHeartSeekerCount = 1
local shadowDaggerCount = 1
local bridgeCount = 1
local bansheeShroudRemovedCount = 1
local baneArrowsCount = 1
local mercilessCount = 1
local isInfoOpen = false
local barbedArrowList = {}

local stageOneTimersHeroic = {
	[347504] = {7.1, 51.1, 49, 49.0, 53, 47.2}, -- Windrunner
	[347670] = {10.6, 47.9, 47.7, 7.7, 42.3, 49.7, 46}, -- Shadow Dagger
	[352650] = {20.5, 19.9, 16.5, 30.0, 4.9, 32.2, 16.1, 12.0, 26.2, 25.1, 13.7, 22.1}, -- Ranger's Heartseeker
	[347704] = {45.0, 50.0, 45.4, 46.8, 49}, -- Veil of Darkness
	[349458] = {23, 53.5, 49, 52, 50}, -- Domination Chains
}
local stageOneTimersMythic = {
	[347504] = {7.1, 57.3, 54.7, 56.1, 62.4}, -- Windrunner
	[347670] = {10.3, 54.4, 54.0, 8.6, 49.0, 59.4}, -- Shadow Dagger
	[352650] = {19.6, 17.4, 8.7, 14.6, 17.0, 23.3, 4.8, 28.3, 20.6, 3.0, 5.9, 44.2, 3.0, 3.0, 9.2, 34.9}, -- Ranger's Heartseeker
	[347704] = {49.5, 43.0, 45.2, 53.9, 35.7}, -- Veil of Darkness
	[349458] = {29.0, 54.9, 62.6, 53.9}, -- Domination Chains
}
local stageOneTimers = mod:Mythic() and stageOneTimersMythic or stageOneTimersHeroic

local stageThreeTimersNormal = {
	[354011] = {31.5, 81.1, 76.5, 80.0}, -- Bane Arrows
	[353969] = {38.8, 24.2, 47.6, 3.5, 29.9, 15.4, 24.9, 31.4, 15.5, 39.5, 23.2, 10.2, 15.1}, -- Banshee's Heartseeker
	[347704] = {44.0, 62.7, 68.4, 60.0, 61.3, 63.6}, -- Veil of Darkness
	[347609] = {77.4, 57.5, 57.8, 60.0}, -- Wailing Arrow
	[354147] = {86.4, 76.0, 76.0, 76.0}, -- Raze
	[353952] = {92.7, 50.0, 54.9, 52.6, 54.6}, -- Banshee Scream
	[347670] = {47.7, 80.0, 84.6}, -- Shadow Dagger (353935 in stage 3)
}

local stageThreeTimersHeroic = {
	[354068] = {16.6, 49.5, 49.3, 53, 47.8, 48.2, 57.9}, -- Banshee's Fury
	[354011] = {28.7, 76.8, 73.2, 76.7, 74.0}, -- Bane Arrows
	[353969] = {34.8, 20.5, 50.5, 3.0, 16.5, 21.3, 32, 12.0, 14.1, 18.9, 31.7, 23.2, 10.2}, -- Banshee's Heartseeker
	[347704] = {39, 61.4, 51, 58.4, 61.3, 63.6}, -- Veil of Darkness
	[347609] = {73, 55.8, 53.6, 55.6}, -- Wailing Arrow
	[354147] = {82.1, 73.6, 72.3, 81.7}, -- Raze
	[353952] = {92.7, 47.4, 54.9, 52.6, 54.6}, -- Banshee Scream
	[347670] = {45.9, 77.4, 79.5, 73.8}, -- Shadow Dagger (353935 in stage 3)
}
local stageThreeTimersMythic = {
	[354068] = {38, 62.5, 62.5, 58.5, 62.5, 65}, -- Banshee's Fury
	[354011] = {15, 93, 100, 92.5}, -- Bane Arrows
	[353969] = {0}, -- Banshee's Heartseeker -- none for now
	[347704] = {23.5, 60, 55, 55, 57, 57, 64}, -- Veil of Darkness
	[347609] = {59.5, 70, 70, 68.5, 68.5}, -- Wailing Arrow
	[354147] = {45, 105, 105, 105}, -- Raze
	[353952] = {71.5, 110, 112}, -- Banshee Scream
}
local stageThreeTimers = mod:Mythic() and stageThreeTimersMythic or mod:Heroic() and stageThreeTimersHeroic or stageThreeTimersNormal

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.chains_active = "Chains Active"
	L.chains_active_desc = "Show a bar for when the Chains of Domination activate"
	L.chains_active_icon = 349458

	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 358711

	L.intermission_chains = "Intermission Chains"
	L.chains = "Chains" -- Short for Domination Chains
	L.chain = "Chain" -- Single Domination Chain
	L.darkness = "Veil" -- Short for Veil of Darkness
	L.arrow = "Arrow" -- Short for Wailing Arrow
	L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Wave" -- Short for Haunting Wave
	L.dread = "Dread" -- Short for Crushing Dread
	L.orbs = "Orbs" -- Dark Communion
	L.curse = "Curse" -- Short for Curse of Lethargy
	L.pool = "Pool" -- Banshee's Bane / Bane Arrows
	L.pools = "Pools" -- Banshee's Bane / Bane Arrows
	L.scream = "Scream" -- Banshee Scream

	L.knife_fling = "Knives out!" -- "Death-touched blades fling out"
	L.bridges = "Bridges"
	L.rive_counter = "%s (%d/%d)"
	L.soaks = "Soaks" -- Merciless
	L.count_x = "%s (x%d)(%d)"
	L.shroud_active = "Shroud (%d) - %.1f%%!"
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
		{347807, "INFOBOX"}, -- Barbed Arrow
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
		350857, -- Banshee Shroud
		355540, -- Ruin
		352271, -- Haunting Wave
		{351180, "TANK"}, -- Lashing Wound
		351117, -- Crushing Dread
		351353, -- Summon Decrepit Orbs
		351939, -- Curse of Lethargy
		{351672, "TANK"}, -- Fury
		-- Stage Three: The Freedom of Choice
		353929, -- Banshee's Bane
		354011, -- Bane Arrows
		{353965, "TANK"}, -- Banshee's Heartseeker
		354068, -- Banshee's Fury
		353952, -- Banshee Scream
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
		[350857] = -23067, -- Stage Two: The Banshee Queen
		[353929] = -22890, -- Stage Three: The Freedom of Choice
		[358704] = "mythic",
	},{
		[349458] = L.chains, -- Domination Chains (Chains)
		[347704] = L.darkness, -- Veil of Darkness (Veil)
		[347609] = L.arrow, -- Wailing Arrow (Arrow)
		[358704] = L.arrow, -- Black Arrow (Arrow)
		[352271] = L.wave, -- Haunting Wave (Wave)
		[351117] = L.dread, -- Crushing Dread (Dread)
		[351353] = L.orbs, -- Summon Decrepit Orbs
		[356021] = L.orbs, -- Dark Communion (Orbs)
		[351939] = L.curse, -- Curse of Lethargy (Curse)
		[353929] = L.pools, -- Banshee's Bane (Pools)
		[354011] = L.pools, -- Bane Arrows (Pools)
		[353952] = L.scream, -- Banshee Scream (Scream)
		[358711] = CL.fixate, -- Rage (Fixate)
	}
end

function mod:OnBossEnable()
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "RageApplied", 358711) -- Dark Sentinel Fixate
	self:Log("SPELL_AURA_REMOVED", "RageRemoved", 358711)
	self:Log("SPELL_CAST_START", "DarkCommunion", 356021)
	self:Log("SPELL_CAST_START", "Filth", 351589)
	self:Log("SPELL_AURA_APPLIED", "FilthApplied", 351591)
	self:Log("SPELL_CAST_START", "ExpulsionStart", 351562)
	self:Log("SPELL_AURA_APPLIED", "ExpulsionApplied", 351562)
	self:Log("SPELL_AURA_REMOVED", "ExpulsionRemoved", 351562)
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
	self:Log("SPELL_AURA_REMOVED", "BarbedArrowRemoved", 347807)
	self:Log("SPELL_DAMAGE", "DesecratingShotDamage", 356377)
	self:Log("SPELL_AURA_APPLIED", "ShadowDaggerApplied", 347670)
	self:Log("SPELL_CAST_START", "DominationChains", 349419)
	self:Log("SPELL_AURA_APPLIED", "DominationChainsApplied", 349458)
	-- self:Log("SPELL_CAST_START", "VeilOfDarkness", 347726, 347741, 354142) -- Stage 1, Stage 2, Stage 3
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Veil of Darkness
	self:Log("SPELL_AURA_APPLIED", "VeilOfDarknessApplied", 347704)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VeilOfDarknessApplied", 347704)
	self:Log("SPELL_CAST_START", "WailingArrow", 347609, 358704) -- Wailing Arrow, Black Arrow (Mythic)
	self:Log("SPELL_AURA_APPLIED", "WailingArrowApplied", 348064, 358705) -- Wailing Arrow, Black Arrow (Mythic)
	self:Log("SPELL_DAMAGE", "WailingArrowHit", 357617)
	self:Log("SPELL_MISSED", "WailingArrowHit", 357617)
	self:Log("SPELL_AURA_REMOVED", "WailingArrowRemoved", 348064, 358705)
	self:Log("SPELL_CAST_START", "RangersHeartseeker", 352663)
	self:Log("SPELL_AURA_APPLIED", "RangersHeartseekerApplied", 352650)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RangersHeartseekerApplied", 352650)
	self:Log("SPELL_AURA_APPLIED", "BansheesMarkApplied", 347607)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesMarkApplied", 347607)

	-- Intermission: A Monument to our Suffering
	self:Log("SPELL_AURA_APPLIED", "BansheeShroudApplied", 350857)
	self:Log("SPELL_CAST_START", "Rive", 353417, 353418) -- Both used in Intermission
	self:Log("SPELL_CAST_START", "BansheeWail", 348109)

	-- Stage Two: The Banshee Queen
	self:Log("SPELL_AURA_APPLIED", "BansheeFormApplied", 348146)
	-- self:Log("SPELL_CAST_SUCCESS", "CreateBridge", 352843, 352842) -- Channel Ice, Call Earth (_CAST not reliable. ideally timers would start in _START)
	self:Log("SPELL_CREATE", "CreateBridge", 351837, 348148, 351838, 348093, 351840, 351841) -- Channel Ice, Call Earth
	self:Log("SPELL_AURA_REMOVED", "BansheeShroudRemoved", 350857)
	self:Log("SPELL_CAST_START", "Ruin", 355540)
	self:Log("SPELL_INTERRUPT", "RuinInterrupted", "*")
	self:Log("SPELL_CAST_START", "HauntingWaveStart", 352271)
	self:Log("SPELL_CAST_SUCCESS", "HauntingWave", 352271)
	--self:Log("SPELL_CAST_START", "LashingStrike", 351179)
	self:Log("SPELL_AURA_APPLIED", "LashingWoundApplied", 351180)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LashingWoundApplied", 351180)
	--self:Log("SPELL_CAST_SUCCESS", "CrushingDread", 351117)
	self:Log("SPELL_AURA_APPLIED", "CrushingDreadApplied", 351117)
	self:Log("SPELL_CAST_START", "SummonDecrepitOrbs", 351353)
	--self:Log("SPELL_CAST_SUCCESS", "CurseOfLethargy", 351939)
	self:Log("SPELL_AURA_APPLIED", "CurseOfLethargyApplied", 351939)
	self:Log("SPELL_AURA_APPLIED", "FuryApplied", 351672)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryApplied", 351672)
	self:Death("CommanderDeath", 177889, 177891, 177892, 177893) -- Souljudge, Summoner, Goliath, Colossus

	-- Stage Three: The Freedom of Choice
	self:Log("SPELL_CAST_START", "RaidPortalOribosStart", 357102)
	self:Log("SPELL_CAST_SUCCESS", "BlasphemySuccess", 357729)
	self:Log("SPELL_CAST_START", "ShadowDaggerP3", 353935) -- weird spell id to use!
	self:Log("SPELL_AURA_APPLIED", "BansheesBaneApplied", 353929)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesBaneApplied", 353929)
	self:Log("SPELL_CAST_START", "BaneArrows", 354011)
	self:Log("SPELL_AURA_APPLIED", "BansheesHeartseekerApplied", 353965)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesHeartseekerApplied", 353965)
	self:Log("SPELL_CAST_START", "BansheesHeartseeker", 353969)
	self:Log("SPELL_CAST_START", "BansheesFury", 354068)
	self:Log("SPELL_CAST_START", "BansheeScream", 353952)
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
	shadowDaggerCount = 1
	bansheeShroudRemovedCount = 1
	intermission = false
	isInfoOpen = false
	barbedArrowList = {}
	stageOneTimers = self:Mythic() and stageOneTimersMythic or stageOneTimersHeroic
	stageThreeTimers = self:Mythic() and stageThreeTimersMythic or stageThreeTimersHeroic

	self:Bar(347504, stageOneTimers[347504][windrunnerCount], CL.count:format(self:SpellName(347504), windrunnerCount)) -- Windrunner
	self:Bar(347670, stageOneTimers[347670][shadowDaggerCount], CL.count:format(self:SpellName(347670), shadowDaggerCount)) -- Shadow Dagger
	self:Bar(352650, stageOneTimers[352650][rangerHeartSeekerCount], CL.count:format(self:SpellName(352650), rangerHeartSeekerCount)) -- Ranger's Heartseeker
	self:Bar(349458, stageOneTimers[349458][dominationChainsCount], CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
	self:Bar(347704, stageOneTimers[347704][veilofDarknessCount], CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	self:Bar(347609, self:Mythic() and 40.5 or 36.5, CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow

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
	if self:GetHealth(unit) < 84.5 then -- Intermission at 84%
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
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if unit then
		if IsItemInRange(116139, unit) then -- 50yd
			self:Message(args.spellId, "orange", L.orbs)
			self:PlaySound(args.spellId, "long")
			self:CDBar(args.spellId, 16.5, L.orbs)
		end
	end
end

function mod:Filth(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if unit then
		if IsItemInRange(116139, unit) then -- 50yd
			self:Message(351591, "purple", CL.casting:format(args.spellName))
			self:PlaySound(351591, "alarm")
			self:CDBar(351591, 13.5)
		end
	end
end

function mod:FilthApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "red", args.destName, args.amount)
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:ExpulsionStart(args)
		playerList = {}
		local unit = self:GetUnitIdByGUID(args.sourceGUID)
		if unit then
			if IsItemInRange(116139, unit) then -- 50yd
				self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
				self:CDBar(args.spellId, 16)
			end
		end
	end

	function mod:ExpulsionApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(args.spellId, 3, count, 2)
			self:PlaySound(args.spellId, "warning")
		end
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
			self:Message(args.spellId, "orange", CL.count:format(args.spellName, shadowDaggerCount))
			self:Bar(args.spellId, 5, L.knife_fling)
			shadowDaggerCount = shadowDaggerCount + 1
			if shadowDaggerCount < 7 then -- Only 6 in the fight
				self:Bar(args.spellId, 54.7, CL.count:format(args.spellName, shadowDaggerCount))
			end
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

do
	local prev = 0
	function mod:Merciless(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			local soaks = 1
			if mercilessCount > 7 then
				soaks = 4
			elseif mercilessCount > 2 then
				soaks = 2
			end
			if mercilessCount == 4 or mercilessCount == 6 or mercilessCount == 8 or mercilessCount == 9 then
				self:Message(args.spellId, "orange", L.count_x:format(L.soaks, soaks, mercilessCount))
				self:PlaySound(args.spellId, "alert")
			end
			mercilessCount = mercilessCount + 1
			local cd = 21
			if mercilessCount > 7 then
				soaks = 4
				cd = 41
			elseif mercilessCount > 2 then
				soaks = 2
			end
			if mercilessCount == 4 or mercilessCount == 6 or mercilessCount == 8 or mercilessCount == 9 then
				self:Bar(args.spellId, cd, L.count_x:format(L.soaks, soaks, mercilessCount))
			end
		end
	end
end

---------------------------------
-- Stage One: A Cycle of Hatred
---------------------------------
do
	local shotTimers = { -- Desecration shot
		[1] = {6, 3.5},
		[2] = {6, 4},
		[3] = {3, 6},
		[4] = {6, 5}
	}
	function mod:Windrunner(args)
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, windrunnerCount))
		self:PlaySound(args.spellId, "alert")
		if self:Mythic() and shotTimers[windrunnerCount] then
			self:Bar(356377, shotTimers[windrunnerCount][1])
			self:ScheduleTimer("Message", shotTimers[windrunnerCount][1], 356377, "yellow")
			self:ScheduleTimer("Bar", shotTimers[windrunnerCount][1], 356377, shotTimers[windrunnerCount][2])
			self:ScheduleTimer("Message", shotTimers[windrunnerCount][1]+shotTimers[windrunnerCount][2], 356377, "yellow")
		end
		windrunnerCount = windrunnerCount + 1
		if not intermission then
			self:Bar(args.spellId, stageOneTimers[args.spellId][windrunnerCount], CL.count:format(args.spellName, windrunnerCount))
		end
	end
end

function mod:BarbedArrowApplied(args)
	if not isInfoOpen then
		isInfoOpen = true
		self:OpenInfo(args.spellId, args.spellName)
	end
	barbedArrowList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, barbedArrowList)

	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BarbedArrowRemoved(args)
	barbedArrowList[args.destName] = nil
	if next(barbedArrowList) then
		self:SetInfoByTable(args.spellId, barbedArrowList)
	elseif isInfoOpen then
		isInfoOpen = false
		self:CloseInfo(args.spellId)
	end
end

function mod:DesecratingShotDamage(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou")
	end
end

do
	local prev = 0
	function mod:ShadowDaggerApplied(args)
		if self:GetStage() < 3 then
			local t = args.time
			if t-prev > 5 then
				prev = t
				self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shadowDaggerCount))
				shadowDaggerCount = shadowDaggerCount + 1
				if self:GetStage() == 1 then
					self:CDBar(args.spellId, stageOneTimers[args.spellId][shadowDaggerCount], CL.count:format(args.spellName, shadowDaggerCount))
				elseif self:GetStage() == 2 and shadowDaggerCount == 2 then
					-- two casts each shroud removed (usually)
					if bansheeShroudRemovedCount == 2 then
						self:CDBar(args.spellId, self:Mythic() and 22.6 or 21, CL.count:format(args.spellName, shadowDaggerCount))
					elseif bansheeShroudRemovedCount == 3 then
						self:CDBar(args.spellId, 41.2, CL.count:format(args.spellName, shadowDaggerCount))
					end
				end
			end
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:DominationChains(args)
	self:Message(349458, "red", CL.count:format(L.chains, dominationChainsCount))
	self:PlaySound(349458, "warning")
	self:Bar("chains_active", 7.2, CL.count:format(L.chains_active, dominationChainsCount), args.spellId) -- Chains Active (x)
	dominationChainsCount = dominationChainsCount + 1
	if not intermission then
		self:CDBar(349458, stageOneTimers[349458][dominationChainsCount], CL.count:format(L.chains, dominationChainsCount))
	end
end

function mod:DominationChainsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.chain)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("347704") then
		self:Message(347704, "orange", CL.count:format(L.darkness, veilofDarknessCount))
		self:PlaySound(347704, "alert")
		self:StopBar(CL.count:format(L.darkness, veilofDarknessCount))
		veilofDarknessCount = veilofDarknessCount + 1
		if self:GetStage() == 1 and not intermission then
			self:CastBar(347704, 6.8, L.darkness)
			self:CDBar(347704, stageOneTimers[347704][veilofDarknessCount], CL.count:format(L.darkness, veilofDarknessCount))
		elseif self:GetStage() == 2 then
			self:CastBar(347704, 4.8, L.darkness)
			-- Started at bridge
			self:StopBar(CL.count:format(L.darkness, veilofDarknessCount-1))
		elseif self:GetStage() == 3 then
			self:CastBar(347704, 4.8, L.darkness)
			self:Bar(347704, stageThreeTimers[347704][veilofDarknessCount], CL.count:format(L.darkness, veilofDarknessCount))
		end
	end
end

do
	local prev = 0
	function mod:VeilOfDarknessApplied(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				-- Checking amout as it starts with 5 in Heroic & Mythic
				local _, amount = self:UnitDebuff(args.destName, args.spellId)
				self:NewStackMessage(args.spellId, "blue", args.destName, amount, nil, L.darkness)
				if amount > 3 then
					-- Don't need to blast warning as the debuff bounces around
					self:PlaySound(args.spellId, "warning")
				end
			end
		end
	end
end

do
	local wailingArrowCastCount = 1
	local playerList = {}
	function mod:WailingArrow(args)
		local count = self:Mythic() and wailingArrowCastCount or self:GetStage() == 1 and wailingArrowCount or wailingArrowCastCount
		local target = table.remove(playerList, 1)
		self:Message(args.spellId, "yellow", CL.other:format(CL.count:format(L.arrow, count), self:ColorName(target)))
		self:PlaySound(args.spellId, "alert")
		wailingArrowCastCount = wailingArrowCastCount + 1
		if not intermission and self:GetStage() == 1 and wailingArrowCastCount == 2 then
			self:StopBar(CL.count:format(L.arrow, wailingArrowCount))
			wailingArrowCount = wailingArrowCount + 1
			self:Bar(args.spellId, self:Mythic() and 63.5 or 34, CL.count:format(L.arrow, wailingArrowCount))
		elseif self:GetStage() == 3 and wailingArrowCastCount == 2 then
			wailingArrowCount = wailingArrowCount + 1
			self:Bar(args.spellId, stageThreeTimers[args.spellId][wailingArrowCount], CL.count:format(L.arrow, wailingArrowCount))
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
			myArrow = 0
			wailingArrowCastCount = 1
			playerList = {}
		end
		wailingArrowPlayerCount = wailingArrowPlayerCount + 1
		playerList[wailingArrowPlayerCount] = args.destName
		if self:GetStage() == 1 and wailingArrowPlayerCount == 1 then -- Update the bar with exact timing
			self:Bar(347609, 9, CL.count:format(L.arrow, wailingArrowCount))
		elseif self:GetStage() == 3 and wailingArrowPlayerCount == 1 then -- Only the first in stage 3
			self:Bar(347609, 9, CL.count:format(L.arrow, wailingArrowCount))
		end
		self:CustomIcon(wailingArrowMarker, args.destName, wailingArrowPlayerCount)
		if self:Me(args.destGUID) then
			myArrow = wailingArrowPlayerCount
			self:PersonalMessage(347609, CL.count:format(L.arrow, wailingArrowPlayerCount))
			self:PlaySound(347609, "alarm")
			self:Say(347609, CL.count_rticon:format(L.arrow, wailingArrowPlayerCount, wailingArrowPlayerCount))
			self:SayCountdown(347609, 9)
			self:TargetBar(347609, 9, args.destName, CL.count:format(L.arrow, wailingArrowPlayerCount))
		end
	end

	function mod:WailingArrowHit(args)
		if self:Me(args.destGUID) then
			self:Say(347609, L.arrow_done, true)
			self:StopBar(CL.you:format(CL.count:format(L.arrow, wailingArrowPlayerCount)))
			self:StopBar(CL.count:format(L.arrow, wailingArrowPlayerCount), args.destName)
		end
	end

	function mod:WailingArrowRemoved(args)
		self:CustomIcon(wailingArrowMarker, args.destName)
	end
end

function mod:RangersHeartseeker(args)
	self:StopBar(CL.count:format(args.spellName, rangerHeartSeekerCount))
	self:Message(352650, "purple", CL.casting:format(CL.count:format(args.spellName, rangerHeartSeekerCount)))
	if self:Tanking("boss1") then
		self:PlaySound(352650, "warning")
	end
	rangerHeartSeekerCount = rangerHeartSeekerCount + 1
	if not intermission then
		self:Bar(352650, stageOneTimers[352650][rangerHeartSeekerCount], CL.count:format(args.spellName, rangerHeartSeekerCount))
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

function mod:BansheeShroudApplied(args)
	if self:GetStage() == 1 and not intermission then
		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")

		self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")
		self:StopBar(352650) -- Ranger's Heartseeker
		self:StopBar(CL.count:format(self:SpellName(347504), windrunnerCount)) -- Windrunner
		self:StopBar(CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
		self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		self:StopBar(CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow
		self:CloseInfo(347807) -- Barbed Arrow Infobox

		intermission = true
		dominationChainsCount = 1
		riveCount = 1
		bansheeWailCount = 1

		if not self:Mythic() then
			self:CDBar(349458, 8.5, L.intermission_chains) -- Domination Chains
		end
		self:CDBar(353417, 21.5) -- Rive
	elseif self:Mythic() and self:GetStage() == 2 then

		if bansheeShroudRemovedCount == 2 or bansheeShroudRemovedCount == 3 then
			local unit = self:GetBossId(args.destGUID)
			local curHp = 100
			if unit then
				curHp = self:GetHealth(unit)
			end
			self:Message("stages", "cyan", L.shroud_active:format(bansheeShroudRemovedCount-1, curHp), false)
		end
	end
end

function mod:Rive(args)
	self:Message(353417, "red", L.rive_counter:format(args.spellName, riveCount, self:Mythic() and 9 or 8))
	self:PlaySound(353417, "alert")
	self:StopBar(CL.count:format(args.spellName, riveCount))
	riveCount = riveCount + 1
	if riveCount == 2 then -- Most reliable way to start intermission timers atm...
		-- Start some timers
		self:Bar(353417, 30, CL.over:format(args.spellName))
		self:CDBar(348109, 39) -- Banshee Wail
	end
end

function mod:BansheeWail(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, bansheeWailCount))
	self:PlaySound(args.spellId, "alarm")
	-- self:CastBar(args.spellId, 5)
	self:StopBar(CL.count:format(args.spellName, bansheeWailCount))
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

		self:StopBar(CL.count:format(self:SpellName(347670), shadowDaggerCount)) -- Shadow Dagger
		self:StopBar(CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
		self:StopBar(CL.count:format(self:SpellName(348145), riveCount)) -- Rive
		self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail

		shadowDaggerCount = 1
		veilofDarknessCount = 1
		bansheeWailCount = 1
		ruinCount = 1
		hauntingWaveCount = 1
		bansheeShroudRemovedCount = 1
		bridgeCount = 1
	end
end

function mod:CreateBridge(args)
	if self:Mythic() then
		if bridgeCount == 2 then -- Both Bridges
			self:Message("stages", "cyan", CL.count:format(L.bridges, 1), 351837)
			self:PlaySound("stages", "info")
			self:CDBar(352271, 36.4, CL.count:format(L.wave, 2)) -- Haunting Wave
			self:CDBar(347704, 19.3, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
			self:CDBar(355540, 47.5, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
		elseif bridgeCount == 4 and bansheeShroudRemovedCount < 1 then -- Both Bridges (2) before Sylvanas down stage
			self:Message("stages", "cyan", CL.count:format(L.bridges, 2), 351837)
			self:PlaySound("stages", "info")
		elseif bridgeCount == 6 then -- Both Bridges (3)
			self:Message("stages", "cyan", CL.count:format(L.bridges, 3), 351837)
			self:PlaySound("stages", "info")
			self:CDBar(347704, 18.8, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
			self:CDBar(352271, 35.4, CL.count:format(L.wave, 6)) -- Haunting Wave
			self:CDBar(355540, 47.5, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
		elseif bridgeCount == 6 and bansheeShroudRemovedCount < 2 then -- Both Bridges (4) before Sylvanas down stage
			self:Message("stages", "cyan", CL.count:format(L.bridges, 4), 351837)
			self:PlaySound("stages", "info")
		end
	else
		self:StopBar(351837) -- Channel Ice
		self:StopBar(352842) -- Call Earth

		self:Message("stages", "cyan", CL.count:format(args.spellName, bridgeCount), args.spellId)
		self:PlaySound("stages", "info")
		if bridgeCount == 1 then -- Ice
			self:CDBar("stages", 32, 352842) -- Call Earth
			self:CDBar(355540, 35.5, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
			self:CDBar(350857, 40.4, CL.removed:format(self:SpellName(350857)))-- Banshee Shroud Removed
		elseif bridgeCount == 2 then -- Earth
			self:CDBar(347704, 31.7, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
			self:CDBar(348109, 49.8, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
			self:CDBar("stages", 61.2, 352842) -- Call Earth
		elseif bridgeCount == 3 then -- Earth
			self:CDBar(352271, 3.2, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
			self:CDBar(347704, 24.6, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		elseif bridgeCount == 4 then -- Ice
			self:CDBar(355540, 11.2, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
			self:CDBar(347704, 28.6, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		elseif bridgeCount == 5 then -- Ice
			self:CDBar(348109, 5.5, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
			self:CDBar(355540, 11.1, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
			self:CDBar(352271, 35.2, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
			self:CDBar(347704, 36.9, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		elseif bridgeCount == 6 then -- Earth
			self:CDBar(355540, 7.1, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
			self:CDBar(350857, 12.5, CL.removed:format(self:SpellName(350857)))-- Banshee Shroud Removed
			self:CDBar(352271, 28.7, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
			self:CDBar(347704, 37.1, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
			self:CDBar(348109, 48.5, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
			self:CDBar("stages", 65.72, CL.stage:format(3), 357102) -- Raid Portal: Oribos
		end
	end
	bridgeCount = bridgeCount + 1
end

function mod:BansheeShroudRemoved(args)
	if self:GetStage() == 3 then return end -- ignore after portal cast starts
	self:StopBar(CL.removed:format(args.spellName))

	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName), args.spellId)
	self:PlaySound(args.spellId, "info")
	if self:Mythic() then
		if bansheeShroudRemovedCount == 1 then
			self:CDBar(347670, 8.5, CL.count:format(self:SpellName(347670), shadowDaggerCount)) -- Shadow Dagger
			self:CDBar(352271, 12.3, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
			self:CDBar(347704, 26.4, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
			self:CDBar(args.spellId, 42) -- Banshee Shroud
			self:CDBar(348109, 43, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
		elseif bansheeShroudRemovedCount == 2 then
			self:CDBar(347670, 1.5, CL.count:format(self:SpellName(347670), shadowDaggerCount)) -- Shadow Dagger
			self:CDBar(352271, 11.5, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
			self:CDBar(347704, 18.5, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
			self:CDBar(args.spellId, 41.5) -- Banshee Shroud
			self:CDBar(348109, 42, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
			self:CDBar("stages", 58, CL.stage:format(3), 357102) -- Raid Portal: Oribos
		end
	else
	if bansheeShroudRemovedCount == 1 then
		self:Bar(args.spellId, 38)
		self:CDBar(347670, 8.3) -- Shadow Dagger
		-- variance is down to <2s by this point, so restart some bars here, second shroud not so much :\
		self:CDBar(347704, 23.3, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		self:CDBar(348109, 46, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
	elseif bansheeShroudRemovedCount == 2 then
		self:Bar(args.spellId, 43)
		self:CDBar(347670, 5) -- Shadow Dagger
	end
end
	bansheeShroudRemovedCount = bansheeShroudRemovedCount + 1
end

function mod:Ruin(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(args.spellName, ruinCount)))
	self:PlaySound(args.spellId, "warning")
	self:StopBar(CL.count:format(args.spellName, ruinCount))
	if self:Mythic() and ruinCount == 1  then
		self:CDBar(350857, 6.5, CL.removed:format(self:SpellName(350857))) -- Banshee Shroud Removed
	end
	ruinCount = ruinCount + 1
end

function mod:RuinInterrupted(args)
	if args.extraSpellId == 355540 then
		self:Message(355540, "green", CL.interrupted:format(args.extraSpellName))
		self:PlaySound(355540, "info")
	end
end

function mod:HauntingWaveStart(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.wave, hauntingWaveCount))
	self:PlaySound(args.spellId, "alert")
	-- correct the bar since it goes to _SUCCESS
	local remaining = self:BarTimeLeft(args.spellId)
	if remaining < 2.5 or remaining > 3.5 then
		self:Bar(args.spellId, 3, CL.count:format(L.wave, hauntingWaveCount))
	end
end

function mod:HauntingWave(args)
	hauntingWaveCount = hauntingWaveCount + 1
	if self:Mythic() then
		if hauntingWaveCount == 4 then
			self:Bar(args.spellId, 23, CL.count:format(L.wave, hauntingWaveCount))
		elseif hauntingWaveCount == 8 then
			self:Bar(args.spellId, 26, CL.count:format(L.wave, hauntingWaveCount))
		end
	else
		if hauntingWaveCount < 5 then
			-- Silly gauntlet at the beginning of the phase
			self:Bar(args.spellId, 5.5, CL.count:format(L.wave, hauntingWaveCount))
		elseif hauntingWaveCount == 7 then
			self:CDBar(352271, 41.4, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
		else
			self:StopBar(args.spellId)
		end
	end
end

function mod:CommanderDeath(args)
	if args.mobId == 177889 then -- Mawforged Souljudge
		--self:StopBar(351180) -- Lashing Wound
		--self:StopBar(351117) -- Crushing Dread
	elseif args.mobId == 177891 then -- Mawforged Summoner
		self:StopBar(L.orbs) -- Summon Decrepit Orbs / Dark Communion
		--self:StopBar(351939) -- Curse of Lethargy
	elseif args.mobId == 177893 then -- Mawforged Colossus
		self:StopBar(351591) -- Filth
		self:StopBar(351562) -- Expulsion
	end

	if UnitExists("boss2") and UnitHealth("boss2") > 1 then return end
	if UnitExists("boss3") and UnitHealth("boss3") > 1 then return end
	if UnitExists("boss4") and UnitHealth("boss4") > 1 then return end
	if UnitExists("boss5") and UnitHealth("boss5") > 1 then return end
	-- After both adds die, Jaina/Thrall will start casting after ~1s?
	-- with a 5s cast, so reset the bar to 6s and cancel timers.
	-- What is the window Sylv will still cast things?

	if self:Mythic() then
		-- Bridges now?
	else
		if bridgeCount == 4 then
			self:CDBar("stages", 6, 351837) -- Channel Ice
		elseif bridgeCount == 5 then
			self:CDBar("stages", 6, 351837) -- Channel Ice
		elseif bridgeCount == 6 then
			self:CDBar("stages", 6, 352842) -- Call Earth
		end
		self:StopBar(CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
		self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
	end
end

-- function mod:LashingStrike(args)
-- 	if self:Mythic() then
-- 		local unit = self:GetUnitIdByGUID(args.sourceGUID)
-- 		if unit then
-- 			if IsItemInRange(116139, unit) then -- 50yd
-- 				self:Bar(351180, 7.5) -- Lashing Wound
-- 			end
-- 		end
-- 	else
-- 		self:Bar(351180, 7.5) -- Lashing Wound
-- 	end
-- end

function mod:LashingWoundApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount)
	if amount > 1 then
		self:PlaySound(args.spellId, "alarm")
	end
end

-- function mod:CrushingDread(args)
-- 	self:Bar(args.spellId, 11)
-- end

function mod:CrushingDreadApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.dread)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SummonDecrepitOrbs(args)
	if self:Mythic() then
		local unit = self:GetUnitIdByGUID(args.sourceGUID)
		if unit then
			if IsItemInRange(116139, unit) then -- 50yd
				self:Message(args.spellId, "orange", L.orbs)
				self:PlaySound(args.spellId, "long")
				self:Bar(args.spellId, 16, L.orbs)
			end
		end
	else
		self:Message(args.spellId, "orange", L.orbs)
		self:PlaySound(args.spellId, "long")
		self:Bar(args.spellId, 16, L.orbs)
	end
end

-- function mod:CurseOfLethargy(args)
-- 	self:Bar(args.spellId, 7.5)
-- end

function mod:CurseOfLethargyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.curse)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FuryApplied(args)
	if self:Mythic() then
		local unit = self:GetUnitIdByGUID(args.sourceGUID)
		if unit then
			if IsItemInRange(116139, unit) then -- 50yd
				local amount = args.amount or 1
				if amount % 3 == 0 or amount > 10 then
					self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
					self:PlaySound(args.spellId, "alert")
				end
			end
		end
	else
		local amount = args.amount or 1
		if amount % 3 == 0 or amount > 10 then
			self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
			self:PlaySound(args.spellId, "alert")
		end
	end
end

---------------------------------------
-- Stage Three: The Freedom of Choice
---------------------------------------

function mod:RaidPortalOribosStart(args)
	self:StopBar(CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
	self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail

	self:Message("stages", "cyan", CL.soon:format(CL.stage:format(3)), false)
	self:PlaySound("stages", "long")
	self:Bar("stages", 10, CL.stage:format(3), args.spellId)
end

function mod:BlasphemySuccess()
	if self:GetStage() < 3 then
		self:SetStage(3)
		shadowDaggerCount = 1
		bansheesFuryCount = 1
		baneArrowsCount = 1
		rangerHeartSeekerCount = 1 -- Reusing this for Banshee's Heartseeker
		veilofDarknessCount = 1
		wailingArrowCount = 1
		razeCount = 1
		bansheeScreamCount = 1
		mercilessCount = 1

		if not self:Mythic() then
			self:CDBar(347670, 45.1, CL.count:format(self:SpellName(347670), shadowDaggerCount)) -- Shadow Dagger 49.6~52
		else
			--self:Bar(358588, 23, L.count_x:format("Far Soaks", 1, mercilessCount))
		 	self:Bar(358434, 65.5, CL.count:format(self:SpellName(358434), shadowDaggerCount)) -- Death Knives
		end
		if not self:Easy() then
			self:Bar(354068, stageThreeTimers[354068][bansheesFuryCount], CL.count:format(self:SpellName(354068), bansheesFuryCount)) -- Banshee's Fury
		end
		self:Bar(354011, stageThreeTimers[354011][baneArrowsCount], CL.count:format(self:SpellName(354011), baneArrowsCount)) -- Bane Arrows
		self:CDBar(353965, stageThreeTimers[353969][rangerHeartSeekerCount], CL.count:format(self:SpellName(353965), rangerHeartSeekerCount)) -- Banshee's Heartseeker
		self:Bar(347704, stageThreeTimers[347704][veilofDarknessCount], CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		self:Bar(347609, stageThreeTimers[347609][wailingArrowCount], CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow // To _SUCCESS of the first arrow
		self:Bar(354147, stageThreeTimers[354147][razeCount], CL.count:format(self:SpellName(354147), razeCount)) -- Raze
		self:Bar(353952, stageThreeTimers[353952][bansheeScreamCount], CL.count:format(L.scream, bansheeScreamCount)) -- Banshee Scream
	end
end

function mod:ShadowDaggerP3(args)
	self:Message(347670, "yellow", CL.count:format(args.spellName, shadowDaggerCount))
	self:PlaySound(347670, "alert")
	shadowDaggerCount = shadowDaggerCount + 1
	self:CDBar(347670, stageThreeTimers[347670][shadowDaggerCount], CL.count:format(args.spellName, shadowDaggerCount))
end

function mod:BansheesBaneApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount, nil, amount > 1 and L.pools or L.pool)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BaneArrows(args)
	self:Message(args.spellId, "yellow", CL.spawning:format(CL.count:format(L.pools, baneArrowsCount)))
	self:PlaySound(args.spellId, "alert")
	baneArrowsCount = baneArrowsCount + 1
	self:Bar(args.spellId, stageThreeTimers[args.spellId][baneArrowsCount], CL.count:format(L.pools, baneArrowsCount))
end

function mod:BansheesHeartseekerApplied(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, amount)) -- Banshee's Heartseeker (1)-(3)
end

function mod:BansheesHeartseeker(args)
	self:StopBar(CL.count:format(args.spellName, rangerHeartSeekerCount))
	if self:Tank() then
		self:Message(353965, "purple", CL.casting:format(CL.count:format(args.spellName, rangerHeartSeekerCount)))
		if self:Tanking("boss1") then
			self:PlaySound(353965, "warning")
		end
	end
	rangerHeartSeekerCount = rangerHeartSeekerCount + 1
	if not self:Mythic() then -- Don't have mythic timers setup, dont spam that we need timers
		self:Bar(353965, stageThreeTimers[353969][rangerHeartSeekerCount], CL.count:format(args.spellName, rangerHeartSeekerCount))
	end
end

function mod:BansheesFury(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, bansheesFuryCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 5) -- 1s precast, 4s before the explosions
	bansheesFuryCount = bansheesFuryCount + 1
	self:Bar(args.spellId, stageThreeTimers[args.spellId][bansheesFuryCount], CL.count:format(args.spellName, bansheesFuryCount))
end

function mod:BansheeScream(args)
	self:Message(args.spellId, "orange", CL.count:format(L.scream, bansheeScreamCount))
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5, CL.count:format(L.scream, bansheeScreamCount))
	bansheeScreamCount = bansheeScreamCount + 1
	self:Bar(args.spellId, stageThreeTimers[args.spellId][bansheeScreamCount], CL.count:format(L.scream, bansheeScreamCount))
end

function mod:Raze(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, razeCount))
	self:PlaySound(args.spellId, "warning") -- Run!
	razeCount = razeCount + 1
	self:Bar(args.spellId, stageThreeTimers[args.spellId][razeCount], CL.count:format(args.spellName, razeCount))
end
