--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Broodtwister Ovi'nax", 2657, 2612)
if not mod then return end
mod:RegisterEnableMob(214506) -- Broodtwister Ovi'nax
mod:SetEncounterID(2919)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local experimentalDosageCount = 1
local ingestBlackBloodCount = 1
local nextIngest = 0
local unstableInfusionCount = 1
local stickyWebCount = 1
local volatileConcoctionCount = 1
local fixateOnMeList = {}

local mobCollector = {}
local mobMarks = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.sticky_web = "Webs"
	L.sticky_web_say = "Web" -- Singular of Webs
	L.infest_message = "Casting Infest on YOU!"
	L.infest_say = "Parasites"
	L.experimental_dosage = "Egg Breaks"
	L.experimental_dosage_say = "Egg Break"
	L.ingest_black_blood = "Next Container"
	L.unstable_infusion = "Swirls" -- is also the heal absorb on the boss

	L.custom_on_experimental_dosage_marks = "Experimental Dosage assignments"
	L.custom_on_experimental_dosage_marks_desc = "Assign players affected by 'Experimental Dosage' to {rt6}{rt4}{rt3}{rt7} with a melee > ranged > healer priority. Affects Say and Target messages."

	L.volatile_concoction_explosion = mod:SpellName(441362)
	L.volatile_concoction_explosion_desc = "Show a target bar for the Volatile Concoction debuff."
end

--------------------------------------------------------------------------------
-- Initialization
--

local experimentalDosageMarker = mod:AddMarkerOption(false, "player", 8, 442526, 6, 4, 3, 7) -- Experimental Dosage
local voraciousWormMarker = mod:AddMarkerOption(false, "npc", 8, -28999, 8, 7, 6, 5) -- Voracious Worm
function mod:GetOptions()
	return {
		"berserk",
		{442526, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Experimental Dosage
			442660, -- Experimental Dosage (was rupture/healing absorb)
			"custom_on_experimental_dosage_marks",
			experimentalDosageMarker,
		442432, -- Ingest Black Blood
			443274, -- Unstable Infusion
		442799, -- Sanguine Overflow (Damage)
			450661, -- Caustic Reaction
		{446349, "SAY", "ME_ONLY_EMPHASIZE"}, -- Sticky Web
			446351, -- Web Eruption
		{441362, "TANK_HEALER"}, -- Volatile Concoction
			"volatile_concoction_explosion",
		-- Adds
		458212, -- Necrotic Wound
		446700, -- Poison Burst
		voraciousWormMarker,
		442250, -- Fixate
			{442257, "SAY"}, -- Infest
	}, {
		[458212] = "adds",
	}, {
		[442526] = L.experimental_dosage, -- Experimental Dosage (Egg Breaks)
		[442660] = CL.heal_absorb, -- Experimental Dosage (Heal Absorb)
		[442432] = L.ingest_black_blood, -- Ingest Black Blood (Next Container)
		[443274] = L.unstable_infusion, -- Unstable Infusion (Swirls)
		[446349] = L.sticky_web, -- Sticky Web (Webs)
		["volatile_concoction_explosion"] = CL.explosion, -- Volatile Concoction Explosion
	}
end

function mod:OnRegister()
	self:SetSpellRename(442526, L.experimental_dosage) -- Experimental Dosage (Egg Breaks)
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Ingest Black Blood adjustments

	self:Log("SPELL_CAST_START", "ExperimentalDosage", 442526)
	self:Log("SPELL_AURA_APPLIED", "ExperimentalDosageApplied", 440421)
	self:Log("SPELL_AURA_REMOVED", "ExperimentalDosageRemoved", 440421)
	self:Log("SPELL_AURA_APPLIED", "RuptureApplied", 442660)
	self:Log("SPELL_CAST_SUCCESS", "IngestBlackBlood", 442432)
	self:Log("SPELL_AURA_APPLIED", "SanguineOverflowApplied", 442799)
	self:Log("SPELL_CAST_SUCCESS", "CausticReaction", 450661)
	self:Log("SPELL_AURA_APPLIED", "UnstableInfusionApplied", 443274)
	self:Log("SPELL_CAST_SUCCESS", "StickyWeb", 446344)
	self:Log("SPELL_AURA_APPLIED", "StickyWebApplied", 446349)
	self:Log("SPELL_AURA_APPLIED", "WebEruptionApplied", 446351)
	self:Log("SPELL_CAST_START", "VolatileConcoction", 443003)
	self:Log("SPELL_AURA_APPLIED", "VolatileConcoctionApplied", 441362)

	-- Adds
	self:Log("SPELL_AURA_APPLIED", "NecroticWoundApplied", 458212)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NecroticWoundApplied", 458212)
	self:Log("SPELL_CAST_START", "PoisonBurst", 446700)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 442250)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 442250)
	self:Log("SPELL_CAST_START", "Infest", 442257)
	self:Log("SPELL_AURA_APPLIED", "InfestApplied", 442257)
	self:Log("SPELL_AURA_REMOVED", "InfestRemoved", 442257)

	self:Death("AddDeaths", 219046) -- Voracious Worm
end

function mod:OnEngage()
	self:SetStage(1)
	experimentalDosageCount = 1
	ingestBlackBloodCount = 1
	unstableInfusionCount = 1
	stickyWebCount = 1
	volatileConcoctionCount = 1
	fixateOnMeList = {}
	mobCollector = {}
	mobMarks = {}

	self:Bar(441362, 2, CL.count:format(self:SpellName(441362), volatileConcoctionCount)) -- Volatile Concoction
	if not self:Easy() then
		self:Bar(446349, 15, CL.count:format(L.sticky_web, stickyWebCount)) -- Sticky Web
	end

	local ingestCd = 15.7
	nextIngest = GetTime() + ingestCd
	self:CDBar(442432, ingestCd, CL.count:format(L.ingest_black_blood, ingestBlackBloodCount)) -- Ingest Black Blood
	if self:Heroic() or self:Normal() then
		self:Berserk(540) -- Normal + Heroic PTR
	end

	if self:GetOption(voraciousWormMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AddMarking(_, unit, guid)
	if self:MobId(guid) == 219046 and not mobCollector[guid] and self:GetOption(voraciousWormMarker) then
		for i = 8, 5, -1 do
			if not mobMarks[i] then
				mobCollector[guid] = true
				mobMarks[i] = guid
				self:CustomIcon(voraciousWormMarker, unit, i)
				return
			end
		end
	end
end

function mod:AddDeaths(args)
	if self:GetOption(voraciousWormMarker) then
		for i = 8, 5, -1 do
			if mobMarks[i] == args.destGUID then
				mobMarks[i] = nil
				break
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 442430 then -- Ingest Black Blood (100 energy)
		local stage = self:GetStage()
		self:SetStage(stage + 1)

		-- Experimental Dosage
		self:Bar(442526, 16.0, CL.count:format(L.experimental_dosage, experimentalDosageCount))
		self:PauseBar(442526, CL.count:format(L.experimental_dosage, experimentalDosageCount))
		-- Volatile Concoction
		self:Bar(441362, 18.5, CL.count:format(self:SpellName(441362), volatileConcoctionCount))
		self:PauseBar(441362, CL.count:format(self:SpellName(441362), volatileConcoctionCount))
		-- Sticky Web
		if not self:Easy() then
			self:Bar(446349, 30, CL.count:format(L.sticky_web, stickyWebCount))
			self:PauseBar(446349, CL.count:format(L.sticky_web, stickyWebCount))
		end
	end
end

do
	local playerList, iconList = {}, {}
	local prev = 0
	local scheduled = nil
	local markOrder = { 6, 6, 4, 4, 3, 3, 7, 7 } -- blue, green, purple, red (wm 1-4)

	local function sortPriority(first, second)
		if first and second then
			if first.healer ~= second.healer then
				return not first.healer and second.healer
			end
			if first.melee ~= second.melee then
				return first.melee and not second.melee
			end
			return first.index < second.index
		end
	end

	function mod:MarkPlayers()
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for melee > ranged > healer
		for i = 1, #iconList do
			local player = iconList[i].player
			local icon = self:GetOption("custom_on_experimental_dosage_marks") and (self:Mythic() and markOrder[i] or markOrder[(i * 2) - 1]) or nil
			-- 8 names in mythic may be a bit much, maybe infobox (bleh)?
			playerList[#playerList+1] = player
			playerList[player] = icon
			self:TargetsMessage(442526, "yellow", playerList, nil, CL.count:format(self:SpellName(442526), experimentalDosageCount - 1))
			if not self:Mythic() then
				self:CustomIcon(experimentalDosageMarker, player, icon)
			end
			if player == self:UnitName("player") then
				local text = icon and CL.rticon:format(L.experimental_dosage_say, icon) or L.experimental_dosage_say
				self:Message(442526, "blue", text)
				self:Say(442526, text, nil, icon and CL.rticon:format("Break Egg", icon) or "Break Egg")
				self:SayCountdown(442526, self:Easy() and 10 or 8, icon)
				self:PlaySound(442526, "warning")
			end
		end
	end

	function mod:ExperimentalDosage(args)
		playerList, iconList = {}, {}

		self:StopBar(CL.count:format(L.experimental_dosage, experimentalDosageCount))
		self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.experimental_dosage, experimentalDosageCount)))
		local debuffDuration = self:Easy() and 10 or 8
		self:Bar(args.spellId, 1.5 + debuffDuration, CL.count:format(CL.adds, experimentalDosageCount)) -- 1.5s Cast + debuffDuration
		experimentalDosageCount = experimentalDosageCount + 1

		if experimentalDosageCount < 10 and experimentalDosageCount % 3 ~= 1 then -- No more than 9, starting every 3rd on Ingest Black Blood
			self:Bar(args.spellId, 50.0, CL.count:format(L.experimental_dosage, experimentalDosageCount))
		end

		if not scheduled then
			scheduled = self:ScheduleTimer("MarkPlayers", 1.8) -- 1.5s cast
		end
		self:PlaySound(args.spellId, "alert")
	end

	function mod:ExperimentalDosageApplied(args)
		iconList[#iconList+1] = {
			player = args.destName,
			melee = self:Melee(args.destName),
			healer = self:Healer(args.destName),
			index = UnitInRaid(args.destName) or 99, -- 99 for players not in your raid (or if you have no raid)
		}
		if #iconList == (self:Mythic() and 8 or 4) then
			self:MarkPlayers()
		end
	end

	function mod:ExperimentalDosageRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(442526)
		end
		if not self:Mythic() then
			self:CustomIcon(experimentalDosageMarker, args.destName)
		end
	end
end

function mod:RuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.heal_absorb)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:IngestBlackBlood(args)
	self:StopBar(CL.count:format(L.ingest_black_blood, ingestBlackBloodCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.ingest_black_blood, ingestBlackBloodCount))

	ingestBlackBloodCount = ingestBlackBloodCount + 1

	local cd = 165
	nextIngest = GetTime() + cd
	if ingestBlackBloodCount < 4 then -- Only 3 Containers
		self:CDBar(args.spellId, cd, CL.count:format(L.ingest_black_blood, ingestBlackBloodCount)) -- ~time to USCS 442430
	end

	self:ResumeBar(442526, CL.count:format(L.experimental_dosage, experimentalDosageCount)) -- Experimental Dosage
	self:ResumeBar(441362, CL.count:format(self:SpellName(441362), volatileConcoctionCount)) -- Volatile Concoction
	if not self:Easy() then
		self:ResumeBar(446349, CL.count:format(L.sticky_web, stickyWebCount)) -- Sticky Web
	end
	self:PlaySound(args.spellId, "long")
end

function mod:SanguineOverflowApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CausticReaction(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- fail
end

do
	local prev = 0
	function mod:UnstableInfusionApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(L.unstable_infusion, unstableInfusionCount))
			unstableInfusionCount = unstableInfusionCount + 1
			self:Bar(args.spellId, 7.5, CL.count:format(L.unstable_infusion, unstableInfusionCount))
		end
	end
end

function mod:StickyWeb(args)
	self:StopBar(CL.count:format(args.spellName, stickyWebCount))
	self:Message(446349, "yellow", CL.count:format(args.spellName, stickyWebCount))
	stickyWebCount = stickyWebCount + 1
	local cd = 30
	local ingestTimeLeft = nextIngest - GetTime()
	if ingestTimeLeft > cd or ingestBlackBloodCount > 3 then
		self:Bar(446349, cd, CL.count:format(args.spellName, stickyWebCount))
	end
end

do
	local prevOnMe = 0
	function mod:StickyWebApplied(args)
		if self:Me(args.destGUID)  then
			prevOnMe = args.time
			self:PersonalMessage(args.spellId, nil, L.sticky_web)
			self:Say(args.spellId, L.sticky_web_say, nil, "Web")
			self:PlaySound(args.spellId, "warning")
		end
	end

	function mod:WebEruptionApplied(args)
		if self:Me(args.destGUID) and args.time - prevOnMe > 10 then -- You didn't have Sticky Web
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm") -- fail
		end
	end
end

function mod:VolatileConcoction(args)
	self:StopBar(CL.count:format(args.spellName, volatileConcoctionCount))
	volatileConcoctionCount = volatileConcoctionCount + 1
	local cd = 20
	local ingestTimeLeft = nextIngest - GetTime()
	if ingestTimeLeft > cd then
		self:Bar(441362, cd, CL.count:format(args.spellName, volatileConcoctionCount))
	end
end

function mod:VolatileConcoctionApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, volatileConcoctionCount - 1))
	self:TargetBar("volatile_concoction_explosion", 8, args.destName, CL.explosion, args.spellId)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- Taunt
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:VolatileConcoctionRemoved(args)
	self:StopBar(CL.explosion, args.destName)
end

function mod:NecroticWoundApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:PoisonBurst(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		fixateOnMeList[args.sourceGUID] = true
	end
end

function mod:FixateRemoved(args)
	if self:Me(args.destGUID) then
		fixateOnMeList[args.sourceGUID] = nil
	end
end

function mod:Infest(args)
	if fixateOnMeList[args.sourceGUID] then
		self:Message(args.spellId, "red", L.infest_message)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:InfestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		-- self:TargetBar(args.spellId, 10, args.destName)
	end
end

function mod:InfestRemoved(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, L.infest_say, true, "Parasites")
		-- self:StopBar(args.spellId, args.destName)
	end
end
