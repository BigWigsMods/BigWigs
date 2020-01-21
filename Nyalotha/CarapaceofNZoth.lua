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
-- Locals
--

local stage = 1

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
		307092, -- Occipital Blast

		--[[  Stage Three: Locus of Infinite Truths ]]--
		{306984, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Insanity Bomb
		-21069, -- Thrashing Tentacle

		--[[  General ]]--
		"stages",
		"berserk",
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
	self:Log("SPELL_CAST_SUCCESS", "MadnessBomb", 306973)
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
	self:Log("SPELL_CAST_START", "OccipitalBlast", 307092)

	--[[  Stage Three: Locus of Infinite Truths ]]--
	self:Log("SPELL_CAST_SUCCESS", "InsanityBomb", 306986)
	self:Log("SPELL_AURA_APPLIED", "InsanityBombApplied", 306984)
	self:Log("SPELL_AURA_REMOVED", "InsanityBombRemoved", 306984)
end

function mod:OnEngage()
	stage = 1
	self:Berserk(721) -- To be confirmed, PTR heroic
	self:Bar(306973, 9.5) -- Madness Bomb
	self:CDBar(-20565, 14, nil, "INV_EyeofNzothPet") -- Gaze of Madness
	self:Bar(306988, 24) -- Adaptive Membrane
	self:Bar(-20560, 41.3, nil, "INV_MISC_MONSTERHORN_04") -- Growth-Covered Tentacle
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("INV_MISC_MONSTERHORN_04", nil, true) then -- Growth-Covered Tentacle
		self:Message2(-20560, "red", nil, "INV_MISC_MONSTERHORN_04")
		self:PlaySound(-20560, "info")
		self:Bar(-20560, 61, nil, "INV_MISC_MONSTERHORN_04")
	elseif msg:find("INV_EyeofNzothPet", nil, true) then -- Gaze of Madness
		self:Message2(-20565, "red", nil, "INV_EyeofNzothPet")
		self:PlaySound(-20565, "alert")
		self:Bar(-20565, 61, nil, "INV_EyeofNzothPet")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 45313 and stage == 2 then -- Good old Anchor Here
		stage = 3
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:PlaySound("stages", "long")
		self:Bar(-20565, 22.2, nil, 315673) -- Thrashing Tentacle
	elseif spellId == 315673 then -- Thrashing Tentacle
		self:Message2(-21069, "red", nil, 315673)
		self:PlaySound(-21069, "alert")
		self:Bar(-21069, 27.8, nil, 315673)
	end
end

--[[  Stage One: Exterior Carapace ]]--
function mod:MadnessBomb(args)
	self:Bar(args.spellId, stage == 1 and 26.6 or stage == 2 and 33.3 or 22.2)
end

do
	local playerList = mod:NewTargetList()
	function mod:MadnessBombApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 12)
			self:OpenProximity(args.spellId, 10)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:MadnessBombRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity()
	end
end

function mod:AdaptiveMembrane(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, stage == 1 and 27.7 or stage == 2 and 21.2 or 33.3)
end

function mod:MandibleSlam(args)
	self:Message2(args.spellId, "orange", CL.casting:format(args.spellName))
	self:Bar(args.spellId, stage == 1 and 16.7 or 22.2)
end

function mod:BlackScar(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 and not self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:BreedMadness(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:PlaySound(args.spellId, "info")
	end
end

--[[  Stage Two: Subcutaneous Tunnel ]]--
function mod:Synthesis(args)
	if stage == 1 then
			stage = 2
			self:Message2("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
			self:StopBar(-20565) -- Gaze of Madness
			self:StopBar(-20560) -- Growth-Covered Tentacle
			self:StopBar(315947) -- Mandible Slam
			self:Bar(306988, 31.2) -- Adaptive Membrane
			self:Bar(306973, 43.3) -- Madness Bomb
	end
end

function mod:SynthesisRemoved(args)
	local amount = args.amount or 0
	if amount < 1 then
		self:Message2("stages", "green", CL.over:format(args.spellName), args.spellId)
		self:PlaySound("stages", "info")
		self:CDBar(307092, 4) -- Occipital Blast, mostly a guess
		self:CDBar(315947, 15.5) -- Mandible Slam
	elseif amount % 3 == 0 or amount < 4 then
		self:StackMessage(args.spellId, args.destName, amount, "green")
	end
end

function mod:OccipitalBlast(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 33.3)
end

--[[  Stage Three: Locus of Infinite Truths ]]--
function mod:InsanityBomb(args)
	self:Message2(306984, "yellow")
	self:Bar(306984, 49)
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
		self:CloseProximity()
	end
end
