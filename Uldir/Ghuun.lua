--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("G'huun", 1861, 2147)
if not mod then return end
mod:RegisterEnableMob(132998)
mod.engageId = 2122
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

local stage = 1
local waveCounter = 0
local waveOfCorruptionCount = 1
local burstingBoilCount = 1
local orbsCounter = 0
local burstingBoilIconCount = 0
local burstingOnMe = false
local orbDunkTime = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.orb_icon = "ability_titankeeper_cleansingorb"
	L.orbs_deposited = "Orbs Deposited (%d/3) - %.1f sec"
	L.orb_spawning = "Orb Spawning"
	L.orb_spawning_side = "Orb Spawning (%s)"
	L.left = "Left"
	L.right = "Right"

	L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = 268074
end

--------------------------------------------------------------------------------
-- Initialization
--

local burstingMarker = mod:AddMarkerOption(false, "player", 1, 277007, 1, 2, 3, 4, 5, 6) -- Bursting Boil
function mod:GetOptions()
	return {
		"stages",
		-18109, -- Power Matrix
		263482, -- Reorigination Blast
		-- Stage 1
		{272506, "SAY", "SAY_COUNTDOWN"}, -- Explosive Corruption
		270287, -- Blighted Ground
		267509, -- Thousand Maws
		267427, -- Torment
		{267412, "TANK"}, -- Massive Smash
		267409, -- Dark Bargain
		267462, -- Decaying Eruption
		-- Stage 2
		{270447, "TANK"}, -- Growing Corruption
		{270373, "PROXIMITY"}, -- Wave of Corruption
		{263235, "SAY", "SAY_COUNTDOWN"}, -- Blood Feast
		263307, -- Mind-Numbing Chatter
		-- Stage 3
		274582, -- Malignant Growth
		{275160, "EMPHASIZE"}, -- Gaze of G'huun
		263321, -- Undulating Mass
		-- Mythic
		277007, -- Bursting Boil
		burstingMarker,
		{268074, "FLASH"}, -- Fixate
		"custom_on_fixate_plates",
	}, {
		["stages"] = "general",
		[272506] = CL.stage:format(1),
		[270447] = CL.stage:format(2),
		[274582] = CL.stage:format(3),
		[277007] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveCorruptionSuccess", 275756, 272505) -- Stage 1 + 2, Stage 3
	self:Log("SPELL_AURA_APPLIED", "ExplosiveCorruptionApplied", 274262, 272506) -- Stage 1 + 2, Stage 3 + Orb Hit
	self:Log("SPELL_MISSED", "ExplosiveCorruptionRemoved", 274262, 272506) -- Incase it's immuned
	self:Log("SPELL_AURA_REMOVED", "ExplosiveCorruptionRemoved", 274262, 272506)
	self:Log("SPELL_CAST_START", "ThousandMaws", 267509)
	self:Log("SPELL_CAST_START", "Torment", 267427)
	self:Log("SPELL_CAST_START", "MassiveSmash", 267412)
	self:Log("SPELL_CAST_START", "DarkBargain", 267409)
	self:Log("SPELL_CAST_START", "DecayingEruption", 267462)
	self:Log("SPELL_CAST_START", "ReoriginationBlast", 263482)
	self:Log("SPELL_AURA_REMOVED", "ReoriginationBlastRemoved", 263504)

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "CorruptingBiteApplied", 270443) -- Stage 2 start
	self:Log("SPELL_AURA_APPLIED", "GrowingCorruption", 270447)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingCorruption", 270447)
	self:Log("SPELL_CAST_SUCCESS", "WaveofCorruption", 270373)
	self:Log("SPELL_CAST_SUCCESS", "BloodFeastSuccess", 263235)
	self:Log("SPELL_AURA_REMOVED", "BloodFeastRemoved", 263235)
	self:Log("SPELL_CAST_START", "MindNumbingChatter", 263307)
	self:Death("HorrorDeath", 134010)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "Collapse", 276839)
	self:Log("SPELL_CAST_SUCCESS", "MalignantGrowth", 274582)
	self:Log("SPELL_CAST_START", "GazeofGhuun", 275160)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 270287, 263321) -- Blighted Ground, Undulating Mass
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 270287, 263321)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 270287, 263321)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "BurstingBloodApplied", 277007)
	self:Log("SPELL_AURA_REMOVED", "BurstingBloodRemoved", 277007)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 268074)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 268074)

	if self:GetOption("custom_on_fixate_plates") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	stage = 1
	waveCounter = 1
	burstingBoilCount = 1
	orbsCounter = 0
	burstingBoilIconCount = 0
	burstingOnMe = false

	self:Bar(-18109, 6, self:Mythic() and L.orb_spawning or L.orb_spawning_side:format(L.left), L.orb_icon) -- Power Matrix
	self:CDBar(272506, 8) -- Explosive Corruption
	self:Bar(267509, 25.5, CL.count:format(self:SpellName(267509), waveCounter)) -- Thousand Maws (x)
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss2")
	orbDunkTime = GetTime() + 6 -- Adjust for spawn
end

function mod:OnBossDisable()
	if self:GetOption("custom_on_fixate_plates") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(event, unit)
	if self:MobId(UnitGUID(unit)) == 134118 then
		local power = UnitPower(unit)
		local seconds = math.floor((GetTime() - orbDunkTime) * 100)/100
		if power == 100 and orbsCounter < 3 then
			orbsCounter = orbsCounter+1
			self:Message(-18109, "green", nil, L.orbs_deposited:format(orbsCounter, seconds), L.orb_icon) -- Power Matrix
			self:PlaySound(-18109, "long")
			orbDunkTime = GetTime() + 26 -- Adjust for Reorigination Blast timer
		elseif power > 60 and orbsCounter < 2 then
			orbsCounter = orbsCounter+1
			self:Message(-18109, "green", nil, L.orbs_deposited:format(orbsCounter, seconds), L.orb_icon) -- Power Matrix
			self:PlaySound(-18109, "long")
			self:Bar(-18109, 12.5, self:Mythic() and L.orb_spawning or L.orb_spawning_side:format(L.left), L.orb_icon) -- Power Matrix
			orbDunkTime = GetTime() + 12.5 -- Adjust for Spawn timer
		elseif power > 30 and orbsCounter < 1 then
			orbsCounter = orbsCounter+1
			self:Message(-18109, "green", nil, L.orbs_deposited:format(orbsCounter, seconds), L.orb_icon) -- Power Matrix
			self:PlaySound(-18109, "long")
			self:Bar(-18109, 12.5, self:Mythic() and L.orb_spawning or L.orb_spawning_side:format(L.right), L.orb_icon) -- Power Matrix
			orbDunkTime = GetTime() + 12.5 -- Adjust for Spawn timer
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 277057 then -- Summon Bursting Boil
		local spellName = self:SpellName(277007)
		self:StopBar(CL.count:format(spellName, burstingBoilCount))
		self:Message(277007, "red", nil, CL.count:format(spellName, burstingBoilCount))
		if not burstingOnMe then
			self:PlaySound(277007, "warning")
		else
			self:PlaySound(277007, "info")
		end
		self:CastBar(277007, 8, CL.count:format(spellName, burstingBoilCount))
		burstingBoilCount = burstingBoilCount + 1
		self:CDBar(277007, 22, CL.count:format(spellName, burstingBoilCount))
	end
end

-- Stage 1
function mod:CorruptingBiteApplied()
	stage = 2
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	waveOfCorruptionCount = 1
	burstingBoilCount = 1
	if self:Mythic() then
		self:Bar(277007, 14.3, CL.count:format(self:SpellName(277007), burstingBoilCount)) -- Bursting Boil
	else
		self:Bar(272506, 9) -- Explosive Corruption
	end
	self:Bar(270373, 15.5, CL.count:format(self:SpellName(270373), waveOfCorruptionCount)) -- Wave of Corruption
	self:OpenProximity(270373, 5)
	self:Bar(263235, self:Mythic() and 32 or 47) -- Blood Feast
end

do
	local castOnMe = nil
	function mod:ExplosiveCorruptionSuccess(args)
		if self:Mythic() then
			self:Message2(272506, "orange")
		elseif args.spellId == 272505 then -- Initial application in stage 3 on heroic
			if self:Me(args.destGUID) then
				castOnMe = true
			end
			self:TargetMessage2(272506, "orange", args.destName)
		end
		self:CDBar(272506, self:Mythic() and (stage == 3 and 27 or 44) or stage == 1 and 26 or stage == 2 and 15.9 or 13.4)
	end

	local playerList = mod:NewTargetList()
	function mod:ExplosiveCorruptionApplied(args)
		if args.spellId == 274262 then -- Initial debuff
			if self:Me(args.destGUID) then
				if self:Mythic() then
					self:PersonalMessage(272506)
				end
				self:PlaySound(272506, "alarm")
				self:Say(272506)
				self:SayCountdown(272506, 4)
			end
			if not self:Mythic() then
				playerList[#playerList+1] = args.destName
				self:TargetsMessage(272506, "orange", playerList, 3, nil, nil, 2) -- Travel time
			end
		elseif self:Me(args.destGUID) then -- Secondary Target or Stage 3 initial application
			if castOnMe == true then
				castOnMe = false
			else
				self:PersonalMessage(272506)
			end
			self:Say(272506)
			self:SayCountdown(272506, 4)
		end
	end

	function mod:ExplosiveCorruptionRemoved(args)
		if self:Me(args.destGUID) then
			castOnMe = false
			self:CancelSayCountdown(272506)
		end
	end
end

function mod:ThousandMaws(args)
	self:Message2(args.spellId, "cyan", CL.count:format(args.spellName, waveCounter))
	self:PlaySound(args.spellId, "info")
	waveCounter = waveCounter + 1
	self:Bar(args.spellId, 25.5, CL.count:format(args.spellName, waveCounter))
end

function mod:Torment(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:MassiveSmash(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 9.7)
end

function mod:DarkBargain(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 23)
end

function mod:DecayingEruption(args)
	self:Message2(args.spellId, "orange")
	if self:Interrupter() then
		self:PlaySound(args.spellId, "warning")
	end
	self:CDBar(args.spellId, 8.5)
end

function mod:ReoriginationBlast(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 28)
	if stage == 1 then -- Stage 1 ending
		self:StopBar(CL.count:format(self:SpellName(267509), waveCounter)) -- Thousand Maws (x)
		self:StopBar(267412) -- Massive Smash
		self:StopBar(267409) -- Dark Bargain
		self:StopBar(272506) -- Explosive Corruption
		self:StopBar(267462) -- Decaying Eruption
	else
		self:PauseBar(272506) -- Explosive Corruption
		self:PauseBar(270373, CL.count:format(self:SpellName(270373), waveOfCorruptionCount)) -- Wave of Corruption
		self:CloseProximity(270373)
		self:PauseBar(263235) -- Blood Feast
		self:PauseBar(277007, CL.count:format(self:SpellName(277007), burstingBoilCount)) -- Bursting Boil
	end
end

function mod:ReoriginationBlastRemoved(args)
	orbsCounter = 0
	if stage == 2 then -- These bars don't exist in stage 1, no stun happens in stage 3
		self:ResumeBar(272506) -- Explosive Corruption
		self:ResumeBar(270373, CL.count:format(self:SpellName(270373), waveOfCorruptionCount)) -- Wave of Corruption
		self:OpenProximity(270373, 5)
		self:ResumeBar(263235) -- Blood Feast
		self:ResumeBar(277007, CL.count:format(self:SpellName(277007), burstingBoilCount)) -- Bursting Boil
	end
end

-- Stage 2
function mod:GrowingCorruption(args)
	local amount = args.amount or 1
	if amount % 2 == 1 and amount > 2 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:WaveofCorruption(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, waveOfCorruptionCount))
	self:PlaySound(args.spellId, "alarm")
	self:StopBar(CL.count:format(args.spellName, waveOfCorruptionCount))
	waveOfCorruptionCount = waveOfCorruptionCount + 1
	self:Bar(args.spellId, stage == 3 and (self:Mythic() and 15.9 or 25.5) or waveOfCorruptionCount % 2 == 0 and 15 or 31, CL.count:format(args.spellName, waveOfCorruptionCount))
	if stage == 2 and waveOfCorruptionCount % 2 == 1 then -- Update Blood feast timer
		self:Bar(263235, 15) -- Blood Feast
	end
end

function mod:BloodFeastSuccess(args)
	self:PlaySound(args.spellId, "alert")
	self:TargetMessage2(args.spellId, "red", args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, self:Mythic() and 6 or 10)
	end
	self:CDBar(args.spellId, 46.3)
	self:Bar(270373, 15.5, CL.count:format(self:SpellName(270373), waveOfCorruptionCount)) -- Update Wave of corruption timer
	self:CDBar(263307, self:Mythic() and 12.9 or 20) -- Mind-Numbing Chatter
end

function mod:BloodFeastRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:MindNumbingChatter(args)
	self:Message2(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 13.5)
end

function mod:HorrorDeath()
	self:StopBar(263307) -- Mind-Numbing Chatter
end


-- Stage 3
function mod:Collapse(args)
	stage = 3
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	self:StopBar(272506) -- Explosive Corruption
	self:StopBar(CL.count:format(self:SpellName(270373), waveOfCorruptionCount)) -- Wave of Corruption
	self:StopBar(263235) -- Blood Feast
	self:StopBar(263482) -- Reorigination Blast
	self:StopBar(CL.count:format(self:SpellName(277007), burstingBoilCount)) -- Bursting Boil

	waveOfCorruptionCount = 1
	burstingBoilCount = 1

	self:CastBar("stages", 20, args.spellName, args.spellId) -- Collapse
	self:Bar(272506, self:Mythic() and 48.3 or 30) -- Explosive Corruption
	self:Bar(274582, self:Mythic() and 35 or 34) -- Malignant Growth
	self:Bar(275160, self:Mythic() and 43.8 or self:Heroic() and 47.2 or 52.3) -- Gaze of G'huun
	self:Bar(270373, self:Mythic() and 39 or 50.5, CL.count:format(self:SpellName(270373), waveOfCorruptionCount)) -- Wave of Corruption
	if self:Mythic() then
		self:CDBar(277007, 28, CL.count:format(self:SpellName(277007), burstingBoilCount)) -- Bursting Boil
	end
end

function mod:MalignantGrowth(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 25.5)
end

function mod:GazeofGhuun(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, self:Mythic() and 23 or self:Heroic() and 25.9 or 31.6)
end

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

-- Mythic
function mod:BurstingBloodApplied(args)
	if self:Me(args.destGUID) then
		burstingOnMe = true
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
	if self:GetOption(burstingMarker) then
		local icon = (burstingBoilIconCount % 6) + 1
		SetRaidTarget(args.destName, icon)
		burstingBoilIconCount = burstingBoilIconCount + 1
	end
end

function mod:BurstingBloodRemoved(args)
	if self:Me(args.destGUID) then
		burstingOnMe = false
	end
	if self:GetOption(burstingMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		if self:GetOption("custom_on_fixate_plates") then
			self:AddPlateIcon(args.spellId, args.sourceGUID)
		end
	end
end

function mod:FixateRemoved(args)
	if self:GetOption("custom_on_fixate_plates") and self:Me(args.destGUID) then
		self:RemovePlateIcon(args.spellId, args.sourceGUID)
	end
end
