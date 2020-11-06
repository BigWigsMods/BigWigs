--------------------------------------------------------------------------------
-- TODO:
-- - Verify bersek on live
-- - Horrific Hemorrahage kill count?
-- - Check stage messages (sadly there are no proper events)
-- - Add / fix initial timers after stages
-- - We might need to add additonal stages because stage 2 consists of 2 stages

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Carapace of N'Zoth", 2217, 2366)
if not mod then return end
mod:RegisterEnableMob(157439) -- Fury of N'Zoth
mod.engageId = 2337
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.player_membrane = "Player Membrane" -- In stage 3
	L.boss_membrane = "Boss Membrane" -- In stage 3
end

--------------------------------------------------------------------------------
-- Locals
--

-- To handle the "half" stages properly we just count up our stage variable:
--   Blizz stage | variable value
--        1      |       1
--        2      |       2
--       2.5     |       3
--   ...
local stage = 1
local lastSynthesisMsg = 0
local adaptiveMembraneCount = 1
local madnessBombCount = 1
local tentacleCount = 1
local gazeofMadnessCount = 1
local eternalDarknessCount = 1
local trashingTentacleCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[  Sanity ]]--
		"altpower",

		--[[  Stage One: Exterior Carapace ]]--
		{306973, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Madness Bomb
		306988, -- Adaptive Membrane
		{315947, "TANK"}, -- Mandible Slam
		{315954, "TANK"}, -- Black Scar
		-20560, -- Growth-Covered Tentacle
		-20565, -- Gaze of Madness
		307011, -- Breed Madness

		--[[  Stage Two: Subcutaneous Tunnel ]]--
		307079, -- Synthesis
		307809, -- Eternal Darkness
		307092, -- Occipital Blast

		--[[  Stage Three: Locus of Infinite Truths ]]--
		{306984, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Insanity Bomb
		-21069, -- Thrashing Tentacle
		313039, -- Infinite Darkness

		--[[  General ]]--
		"stages",
		"berserk",
		307064, -- Cyst Genesis
	}, {
		["altpower"] = -21056, -- Sanity
		[306973] = -20558, -- Stage One: Exterior Carapace
		[307079] = -20566, -- Stage Two: Subcutaneous Tunnel
		[306984] = -20569, -- Stage Three: Locus of Infinite Truths
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[  Stage One: Exterior Carapace ]]--
	self:Log("SPELL_CAST_SUCCESS", "MadnessBomb", 306971)
	self:Log("SPELL_AURA_APPLIED", "MadnessBombApplied", 306973)
	self:Log("SPELL_AURA_REMOVED", "MadnessBombRemoved", 306973)
	self:Log("SPELL_CAST_SUCCESS", "AdaptiveMembrane", 306988)
	self:Log("SPELL_CAST_START", "MandibleSlam", 315947)
	self:Log("SPELL_AURA_APPLIED", "BlackScar", 315954)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlackScar", 315954)
	self:Log("SPELL_AURA_APPLIED", "BreedMadness", 307011)

	--[[  Stage Two: Subcutaneous Tunnel ]]--
	self:Log("SPELL_AURA_APPLIED", "Synthesis", 307079)
	self:Log("SPELL_AURA_REMOVED", "SynthesisRemoved", 307079)
	self:Log("SPELL_AURA_REMOVED_DOSE", "SynthesisRemoved", 307079)
	self:Log("SPELL_CAST_START", "EternalDarkness", 307809)
	self:Log("SPELL_CAST_START", "OccipitalBlast", 307092)

	--[[  Stage Three: Locus of Infinite Truths ]]--
	self:Log("SPELL_CAST_SUCCESS", "InsanityBomb", 306986)
	self:Log("SPELL_AURA_APPLIED", "InsanityBombApplied", 306984)
	self:Log("SPELL_AURA_REMOVED", "InsanityBombRemoved", 306984)
	self:Log("SPELL_CAST_START", "InfiniteDarkness", 313039)

	self:Log("SPELL_CAST_START", "CystGenesis", 307064)
end

function mod:OnEngage()
	self:OpenAltPower("altpower", -21056, "ZA") -- Sanity
	stage = 1
	adaptiveMembraneCount = 1
	madnessBombCount = 1
	tentacleCount = 1
	gazeofMadnessCount = 1
	eternalDarknessCount = 1
	self:Bar(306973, self:Mythic() and 10 or 5, CL.count:format(self:SpellName(306973), madnessBombCount)) -- Madness Bomb
	self:CDBar(-20565, self:Mythic() and 41.5 or 10, CL.count:format(self:SpellName(-20565), gazeofMadnessCount), "INV_EyeofNzothPet") -- Gaze of Madness
	self:Bar(306988, 16, CL.count:format(self:SpellName(306988), adaptiveMembraneCount)) -- Adaptive Membrane
	self:Bar(-20560, 30, CL.count:format(self:SpellName(-20560), tentacleCount), "INV_MISC_MONSTERHORN_04") -- Growth-Covered Tentacle
	--self:Berserk(601) -- Heroic XXX Got changed
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("INV_MISC_MONSTERHORN_04", nil, true) then -- Growth-Covered Tentacle -- xxx event for mythic??
		self:Message(-20560, "red", CL.count:format(self:SpellName(-20560), tentacleCount), "INV_MISC_MONSTERHORN_04")
		self:PlaySound(-20560, "info")
		tentacleCount = tentacleCount + 1
		self:Bar(-20560, 60, CL.count:format(self:SpellName(-20560), tentacleCount), "INV_MISC_MONSTERHORN_04")
	elseif msg:find("INV_EyeofNzothPet", nil, true) then -- Gaze of Madness
		self:Message(-20565, "red", CL.count:format(self:SpellName(-20565), gazeofMadnessCount), "INV_EyeofNzothPet")
		self:PlaySound(-20565, "alert")
		gazeofMadnessCount = gazeofMadnessCount + 1
		self:Bar(-20565, self:Mythic() and 65.12 or 58, CL.count:format(self:SpellName(-20565), gazeofMadnessCount), "INV_EyeofNzothPet")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 45313 then -- Anchor Here
		if stage == 1 then
			stage = 2
			adaptiveMembraneCount = 1
		elseif stage == 2 and not self:Mythic() then
			stage = 3 -- Stage 2.5
			adaptiveMembraneCount = 1
			madnessBombCount = 1
			eternalDarknessCount = 1
			self:CDBar(307092, 5.6) -- Occipital Blast
			self:CDBar(306973, 13.1, CL.count:format(self:SpellName(306973), madnessBombCount)) -- Madness Bomb
			self:CDBar(315947, 15.5) -- Mandible Slam
			self:CDBar(306988, 16.7, CL.count:format(self:SpellName(306988), adaptiveMembraneCount)) -- Adaptive Membrane
			self:CDBar(307809, 22.3, CL.count:format(self:SpellName(307809), eternalDarknessCount)) -- Eternal Darkness
		elseif stage == 3 then
			stage = 4 -- Blizz Stage 3
			self:Message("stages", "cyan", CL.stage:format(3), false)
			self:PlaySound("stages", "long")
			adaptiveMembraneCount = 1
			madnessBombCount = 1 -- Reuse this counter for Insanity Bombs
			eternalDarknessCount = 1 -- Reuse this counter for Infinite Darkness
			trashingTentacleCount = 1

			self:CDBar(315947, 17.1) -- Mandible Slam
			self:Bar(306984, 21.7, CL.count:format(self:SpellName(306984), madnessBombCount)) -- Insanity Bomb
			self:StartThrashingTentacleTimer(32)
			self:Bar(306988, 38.2, CL.count:format(self:SpellName(306988), adaptiveMembraneCount)) -- Adaptive Membrane
			self:Bar(313039, 54, CL.count:format(self:SpellName(313039), eternalDarknessCount)) -- Infinite Darkness
		end
	elseif spellId == 315673 then -- Thrashing Tentacle, Blizz removed this for live servers - maybe it comes back?
		self:Message(-21069, "red", nil, 315673)
		self:PlaySound(-21069, "alert")
		self:Bar(-21069, 20, nil, 315673)
	end
end

--[[  Stage One: Exterior Carapace ]]--
function mod:MadnessBomb(args)
	if stage == 2 then -- on NPCs only in stage 2, so no TargetsMessage needed
		self:Message(306973, "yellow", CL.count:format(args.spellName, madnessBombCount))
	end
	madnessBombCount = madnessBombCount + 1
	local cd = nil
	if stage == 1 then
		cd = self:Mythic() and 25 or 26.6
	elseif stage == 2 then
		cd = self:Mythic() and (madnessBombCount == 2 and 4 or 11) or 33.3
	else
		cd = 22.2
	end
	self:Bar(306973, cd, CL.count:format(args.spellName, madnessBombCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:MadnessBombApplied(args)
		if UnitIsPlayer(args.destName) then
			playerList[#playerList+1] = args.destName
			self:TargetsMessage(args.spellId, "yellow", playerList)
		end
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 12)
			self:OpenProximity(args.spellId, 10)
		end
	end
end

function mod:MadnessBombRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:CloseProximity(args.spellId)
	end
end

function mod:AdaptiveMembrane(args)
	local barText = nil
	if self:Mythic() and stage == 4 then
		barText = adaptiveMembraneCount % 2 == 0 and L.player_membrane or L.boss_membrane
		self:Message(args.spellId, "orange", CL.count:format(barText, adaptiveMembraneCount))
	else
		self:Message(args.spellId, "orange", CL.count:format(args.spellName, adaptiveMembraneCount))
	end
	self:PlaySound(args.spellId, "alarm")
	adaptiveMembraneCount = adaptiveMembraneCount + 1
	local cd = nil
	if stage == 1 then
		if self:Mythic() then
			cd = adaptiveMembraneCount % 2 == 0 and 10 or 21.8 -- 21.7-22.0
		else
			cd = stage == 1 and 28.8 or stage == 2 and 21.2 or stage == 3 and 33.3 or 31.8
		end
	elseif stage == 2 then
		if self:Mythic() then
			cd = 10
		else
			cd = 21.2 or stage == 3 and 33.3 or 31.8
		end
	elseif stage == 3 then -- Stage 2.5
		cd = 33.3
	else -- Stage 3 Blizzard
		cd = self:Mythic() and (adaptiveMembraneCount % 2 == 0 and 10 or 44) or 31.8
	end
	if self:Mythic() and stage == 4 then
		barText = adaptiveMembraneCount % 2 == 0 and L.player_membrane or L.boss_membrane
		self:Bar(args.spellId, cd, CL.count:format(barText, adaptiveMembraneCount))
	else
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, adaptiveMembraneCount))
	end
end

function mod:MandibleSlam(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:Bar(args.spellId, stage == 1 and (self:Mythic() and 16 or 13) or stage == 3 and 22.2 or 11)
end

function mod:BlackScar(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:BreedMadness(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, "blue", args.destName)
		self:PlaySound(args.spellId, "info")
	end
end

--[[  Stage Two: Subcutaneous Tunnel ]]--
function mod:Synthesis(args) -- this is earlier than the Anchor here
		lastSynthesisMsg = 100 -- Random large number
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
		self:StopBar(CL.count:format(self:SpellName(-20565), gazeofMadnessCount)) -- Gaze of Madness
		self:StopBar(CL.count:format(self:SpellName(-20560), tentacleCount)) -- Growth-Covered Tentacle
		self:StopBar(315947) -- Mandible Slam
		eternalDarknessCount = 1
		adaptiveMembraneCount = 1
		madnessBombCount = 1

		self:Bar(307809, self:Mythic() and 36.19 or 23.6, CL.count:format(self:SpellName(307809), eternalDarknessCount)) -- Eternal Darkness
		self:Bar(306988, self:Mythic() and 33.16 or 31.2, CL.count:format(self:SpellName(306988), adaptiveMembraneCount)) -- Adaptive Membrane
		self:Bar(306973, self:Mythic() and 41.17 or 43.3, CL.count:format(self:SpellName(306973), madnessBombCount)) -- Madness Bomb
end

function mod:SynthesisRemoved(args)
	local amount = args.amount or 0
	if amount < 1 then
		self:Message("stages", "green", CL.over:format(args.spellName), args.spellId)
		self:PlaySound("stages", "info")
	elseif amount % 3 == 0 or lastSynthesisMsg-amount > 3 or amount < 4 then
		lastSynthesisMsg = amount -- Events can be skipped, so this is our fallback
		self:StackMessage(args.spellId, args.destName, amount, "green")
	end
end

function mod:EternalDarkness(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, eternalDarknessCount))
	self:PlaySound(args.spellId, "alert")
	eternalDarknessCount = eternalDarknessCount + 1
	self:Bar(args.spellId, self:Mythic() and 20 or 33.3, CL.count:format(args.spellName, eternalDarknessCount))
end

function mod:OccipitalBlast(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 33.3)
end

--[[  Stage Three: Locus of Infinite Truths ]]--
function mod:InsanityBomb(args)
	self:Message(306984, "yellow", CL.count:format(args.spellName, madnessBombCount))
	madnessBombCount = madnessBombCount + 1
	self:Bar(306984, 67, CL.count:format(args.spellName, madnessBombCount))
end

function mod:InsanityBombApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 12)
		self:OpenProximity(args.spellId, 10)
	end
end

function mod:InsanityBombRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:CloseProximity(args.spellId)
	end
end

function mod:InfiniteDarkness(args)
	self:Message(args.spellId, "red", CL.incoming:format(CL.count:format(args.spellName, eternalDarknessCount)))
	self:CastBar(args.spellId, 2.5, CL.count:format(args.spellName, eternalDarknessCount))
	eternalDarknessCount = eternalDarknessCount + 1
	self:Bar(args.spellId, 54, CL.count:format(args.spellName, eternalDarknessCount))
end

function mod:StartThrashingTentacleTimer(t)
	self:CDBar(-21069, t, CL.count:format(self:SpellName(-21069), trashingTentacleCount), 315673)
	self:ScheduleTimer("Message", t, -21069, "red", CL.count:format(CL.incoming:format(self:SpellName(-21069)), trashingTentacleCount), 315673)
	self:ScheduleTimer("CastBar", t, -21069, 6, CL.count:format(self:SpellName(304077), trashingTentacleCount), 272713) -- Tentacle Slam
	self:ScheduleTimer("PlaySound", t, -21069, "alert")
	trashingTentacleCount = trashingTentacleCount + 1
	self:ScheduleTimer("StartThrashingTentacleTimer", t, 20)
end

function mod:CystGenesis(args)
	if stage < 4 then
		self:StopBar(CL.count:format(self:SpellName(307809), eternalDarknessCount)) -- Eternal Darkness
		self:StopBar(CL.count:format(self:SpellName(306988), adaptiveMembraneCount)) -- Adaptive Membrane

		stage = 4 -- Stage 3 Blizzard
		self:Message("stages", "cyan", CL.stage:format(3), false)
		self:PlaySound("stages", "long")
		madnessBombCount = 1 -- Reuse this counter for Insanity Bombs
		eternalDarknessCount = 1 -- Reuse this counter for Infinite Darkness
		trashingTentacleCount = 1
		adaptiveMembraneCount = 1

		self:CDBar(315947, self:Mythic() and 8 or 17.1) -- Mandible Slam
		self:Bar(306984, self:Mythic() and 29.5 or 21.7, CL.count:format(self:SpellName(306984), madnessBombCount)) -- Insanity Bomb
		--self:StartThrashingTentacleTimer(32) -- XXX Fixme
		self:Bar(306988, self:Mythic() and 11.8 or 38.2, CL.count:format(self:SpellName(306988), adaptiveMembraneCount)) -- Adaptive Membrane
		self:Bar(313039, self:Mythic() and 9 or 54, CL.count:format(self:SpellName(313039), eternalDarknessCount)) -- Infinite Darkness
	else
		self:Message(args.spellId, "green")
		self:PlaySound(args.spellId, "long")
	end
	self:Bar(args.spellId, 120)
end
