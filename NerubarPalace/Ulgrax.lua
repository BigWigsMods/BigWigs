--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ulgrax the Devourer", 2657, 2607)
if not mod then return end
mod:RegisterEnableMob(215657) -- Ulgrax the Devourer
mod:SetEncounterID(2902)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local carnivorousContestCount = 1
local stalkersWebbingCount = 1
local venomousLashCount = 1
local digestiveAcidCount = 1
local brutalCrushCount = 1

local juggernautChargeCount = 1
local hungeringBellowsCount = 1
local foodOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.carnivorous_contest_pull = "Pull In"
	L.chunky_viscera_message = "Feed Boss! (Special Action Button)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk",

		-- Gleeful Brutality
		{434803, "CASTBAR", "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Carnivorous Contest (Soak)
		434778, -- Carnivorous Contest (Pull)
			440849, -- Contemptful Rage
		441452, -- Stalkers Webbing
			439419, -- Stalker Netting
		{435138, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Digestive Acid
		435136, -- Venomous Lash
		{434697, "TANK"}, -- Brutal Crush
			{434705, "TANK"}, -- Tenderized

		-- Feeding Frenzy
		445123, -- Hulking Crash
		445052, -- Chittering Swarm
			439037, -- Disembowel
			438657, -- Chunky Viscera
		436200, -- Juggernaut Charge
		443842, -- Swallowing Darkness
		440177, -- Ready to Feed
			438012, -- Hungering Bellows

		-- Mythic
		455831, -- Hardened Netting
	},{
		[434803] = -30011, -- Gleeful Brutality
		[445123] = -28845, -- Feeding Frenzy
		[455831] = "mythic",
	},{
		[434803] = CL.soak, -- Carnivorous Contest (Soak)
		[434778] = L.carnivorous_contest_pull, -- Carnivorous Contest (Pull In)
	}
end

function mod:OnBossEnable()
	self:RegisterWhisperEmoteComms("RaidBossWhisperSync")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- Carnivorous Contest target

	self:Log("SPELL_CAST_SUCCESS", "PhaseTransition", 441425)
	-- Gleeful Brutality
	self:Log("SPELL_CAST_START", "BrutalCrush", 434697)
	self:Log("SPELL_AURA_APPLIED", "TenderizedApplied", 434705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TenderizedApplied", 434705)
	self:Log("SPELL_CAST_SUCCESS", "CarnivorousContest", 434803)
	-- self:Log("SPELL_AURA_APPLIED", "CarnivorousContestApplied", 434803) -- using cast target
	self:Log("SPELL_AURA_REMOVED", "CarnivorousContestRemoved", 434803)
	self:Log("SPELL_AURA_APPLIED", "CarnivorousContestPullApplied", 434778)
	self:Log("SPELL_AURA_REMOVED", "CarnivorousContestPullRemoved", 434778)
	self:Log("SPELL_AURA_APPLIED", "ContemptfulRageApplied", 440849)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ContemptfulRageApplied", 440849)
	self:Log("SPELL_CAST_START", "StalkersWebbing", 441452)
	self:Log("SPELL_AURA_APPLIED", "StalkerNettingApplied", 439419, 455831) -- Stalker Netting/Hardened Netting
	self:Log("SPELL_CAST_START", "VenomousLash", 435136)
	self:Log("SPELL_CAST_START", "DigestiveAcid", 435138)
	self:Log("SPELL_AURA_APPLIED", "DigestiveAcidApplied", 435138)
	self:Log("SPELL_AURA_REMOVED", "DigestiveAcidRemoved", 435138)
	-- Feeding Frenzy
	self:Log("SPELL_CAST_START", "HulkingCrash", 445123)
	self:Log("SPELL_CAST_START", "ChitteringSwarm", 445052)
	self:Log("SPELL_AURA_APPLIED", "DisembowelApplied", 439037)
	-- self:Log("SPELL_AURA_APPLIED_DOSE", "DisembowelApplied", 439037)
	self:Log("SPELL_AURA_APPLIED", "ChunkyVisceraApplied", 438657, 457598)
	self:Log("SPELL_AURA_REMOVED", "ChunkyVisceraRemoved", 438657, 457598)
	self:Log("SPELL_CAST_START", "JuggernautChargeIncoming", 436200) -- burrow
	self:Log("SPELL_CAST_START", "JuggernautCharge", 436203) -- actual charge
	self:Log("SPELL_CAST_START", "SwallowingDarkness", 443842)
	self:Log("SPELL_AURA_APPLIED", "ReadyToEat", 440177)
	self:Log("SPELL_CAST_START", "HungeringBellows", 438012)
end

function mod:OnEngage()
	self:SetStage(1)
	carnivorousContestCount = 1
	stalkersWebbingCount = 1
	venomousLashCount = 1
	digestiveAcidCount = 1
	brutalCrushCount = 1
	foodOnMe = false

	self:Bar(434697, 3.0, CL.count:format(self:SpellName(434697), brutalCrushCount)) -- Brutal Crush
	self:Bar(435136, 5.0, CL.count:format(self:SpellName(435136), venomousLashCount)) -- Venomous Lash
	self:Bar(441452, 9.0, CL.count:format(self:SpellName(441452), stalkersWebbingCount)) -- Stalkers Webbing
	self:Bar(435138, 15.0, CL.count:format(self:SpellName(435138), digestiveAcidCount)) -- Digestive Acid
	self:Bar(434803, 34.0, CL.count:format(CL.soak, carnivorousContestCount)) -- Carnivorous Contest
	self:Bar("stages", 90.0, CL.stage:format(2), 445123) -- Hulking Crash (Stage 2)
	self:Berserk(601, true)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RaidBossWhisperSync(msg, player)
	if msg:find("spell:434776", nil, true) then
		self:TargetMessage(434803, "red", player, CL.soak)
		self:PlaySound(434803, "warning")
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	-- |TInterface\\ICONS\\INV_Misc_Web_01.blp:20|t  Ulgrax engages you in a |cFFFF0000|Hspell:434776|h[Carnivorous Contest]|h|r!
	if msg:find("spell:434776", nil, true) then
		--self:PersonalMessage(434803, nil, CL.soak)
		self:Yell(434803, CL.soak, nil, "Soak")
		self:YellCountdown(434803, 8, nil, 6)
		--self:PlaySound(434803, "warning")
	end
end

function mod:PhaseTransition()
	if self:GetStage() == 2 then
		-- P2 -> P1
		self:StopBar(445052) -- Chittering Swarm
		self:StopBar(CL.count_amount:format(self:SpellName(436200), juggernautChargeCount, 4)) -- Juggernaut Charge
		self:StopBar(443842) -- Swallowing Darkness
		self:StopBar(CL.count:format(self:SpellName(438012), hungeringBellowsCount)) -- Hungering Bellows

		self:SetStage(1)
		self:Message("stages", "cyan", CL.stage:format(1), false)
		self:PlaySound("stages", "long") -- phase change

		brutalCrushCount = 1
		stalkersWebbingCount = 1
		venomousLashCount = 1
		digestiveAcidCount = 1
		carnivorousContestCount = 1

		self:Bar(434697, 8.0, CL.count:format(self:SpellName(434697), brutalCrushCount)) -- Brutal Crush
		self:Bar(435136, 10.0, CL.count:format(self:SpellName(435136), venomousLashCount)) -- Venomous Lash
		self:Bar(441452, 14.0, CL.count:format(self:SpellName(441452), stalkersWebbingCount)) -- Stalkers Webbing
		self:Bar(435138, 20.0, CL.count:format(self:SpellName(435138), digestiveAcidCount)) -- Digestive Acid
		self:Bar(434803, 38.0, CL.count:format(CL.soak, carnivorousContestCount)) -- Carnivorous Contest
		self:Bar("stages", 94.0, CL.stage:format(2), 445123) -- Hulking Crash (Stage 2)
	end
end

-- Gleeful Brutality
function mod:BrutalCrush(args)
	self:StopBar(CL.count:format(args.spellName, brutalCrushCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, brutalCrushCount))
	self:PlaySound(args.spellId, "alert")
	brutalCrushCount = brutalCrushCount + 1

	local timer = { 3.0, 15.0, 15.0, 19.0, 15.0, 0 }
	self:Bar(args.spellId, timer[brutalCrushCount], CL.count:format(args.spellName, brutalCrushCount))
end

function mod:TenderizedApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	else
		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if self:Tank() and unit and not self:Tanking(unit) then
			self:PlaySound(args.spellId, "warning") -- tankswap
		end
	end
end

function mod:CarnivorousContest(args)
	self:StopBar(CL.count:format(CL.soak, carnivorousContestCount))
	if UnitInRaid(args.destName) then -- XXX not targetting [DNT] Tug of War Stalker 1
		self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(CL.soak, carnivorousContestCount))
		self:TargetBar(args.spellId, 8, args.destName, CL.soak)
	else
		self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(CL.soak, carnivorousContestCount)))
		self:CastBar(args.spellId, 8, CL.soak)
	end
	carnivorousContestCount = carnivorousContestCount + 1
	if carnivorousContestCount < 3 then
		self:Bar(args.spellId, 36.0, CL.count:format(CL.soak, carnivorousContestCount))
	end

	-- if self:Me(args.destGUID) then
	-- 	self:PersonalMessage(args.spellId, nil, CL.soak)
	-- 	self:PlaySound(args.spellId, "warning")
	-- 	self:Yell(args.spellId, CL.soak, nil, "Soak")
	-- 	self:YellCountdown(args.spellId, 8)
	-- else
		self:PlaySound(args.spellId, "alert") -- soak
	-- end
end

-- function mod:CarnivorousContestApplied(args)
-- 	local text = CL.count:format(CL.soak, carnivorousContestCount - 1)
-- 	self:TargetMessage(434803, "orange", args.destName, text)
-- 	self:TargetBar(434803, 8, args.destName, CL.soak)
-- 	if self:Me(args.destGUID) then
-- 		self:PlaySound(434803, "warning")
-- 		self:Yell(434803, CL.soak, nil, "Soak")
-- 		self:YellCountdown(434803, 8)
-- 	else
-- 		self:PlaySound(434803, "alert") -- soak
-- 	end
-- end

function mod:CarnivorousContestRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
end

function mod:CarnivorousContestPullApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.carnivorous_contest_pull)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CarnivorousContestPullRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.over:format(args.spellName))
		self:PlaySound(args.spellId, "info") -- Safe
	end
end

function mod:ContemptfulRageApplied(args)
	self:Message(args.spellId, "red", CL.stack:format(args.amount or 1, args.spellName, args.destName))
	self:PlaySound(args.spellId, "alarm") -- fail
end

function mod:StalkersWebbing(args)
	self:StopBar(CL.count:format(args.spellName, stalkersWebbingCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, stalkersWebbingCount))
	self:PlaySound(args.spellId, "info")
	stalkersWebbingCount = stalkersWebbingCount + 1

	if stalkersWebbingCount < 3 then
		self:Bar(args.spellId, 45.0, CL.count:format(args.spellName, stalkersWebbingCount))
	end
end

function mod:StalkerNettingApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VenomousLash(args)
	self:StopBar(CL.count:format(args.spellName, venomousLashCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, venomousLashCount))
	self:PlaySound(args.spellId, "alert")
	venomousLashCount = venomousLashCount + 1

	local timer = { 5.0, 25.0, 28.0, 0 }
	self:Bar(args.spellId, timer[venomousLashCount], CL.count:format(args.spellName, venomousLashCount))
end

function mod:DigestiveAcid(args)
	self:StopBar(CL.count:format(args.spellName, digestiveAcidCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, digestiveAcidCount)))
	self:PlaySound(args.spellId, "alert")
	digestiveAcidCount = digestiveAcidCount + 1

	if digestiveAcidCount < 3 then
		self:Bar(args.spellId, 47.0, CL.count:format(args.spellName, digestiveAcidCount))
	end
end

function mod:DigestiveAcidApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- Clear Webs
		self:Say(args.spellId, nil, nil, "Digestive Acid")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:DigestiveAcidRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

-- Feeding Frenzy
function mod:HulkingCrash(args)
	-- P1 -> P2
	self:StopBar(CL.stage:format(2))
	self:StopBar(CL.count:format(self:SpellName(434697), brutalCrushCount)) -- Brutal Crush
	self:StopBar(CL.count:format(self:SpellName(435136), venomousLashCount)) -- Venomous Lash
	self:StopBar(CL.count:format(self:SpellName(441452), stalkersWebbingCount)) -- Stalkers Webbing
	self:StopBar(CL.count:format(self:SpellName(435138), digestiveAcidCount)) -- Digestive Acid
	self:StopBar(CL.count:format(CL.soak, carnivorousContestCount)) -- Carnivorous Contest

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	juggernautChargeCount = 1
	hungeringBellowsCount = 1

	self:Bar(445052, 7.5) -- Chittering Swarm
	self:Bar(436200, 17.7, CL.count_amount:format(self:SpellName(436200), juggernautChargeCount, 4)) -- Juggernaut Charge
	self:Bar(443842, 48.3) -- Swallowing Darkness
	self:Bar(438012, 60.8, CL.count:format(self:SpellName(438012), hungeringBellowsCount)) -- Hungering Bellows

	self:Message(445123, "red")
end

function mod:ChitteringSwarm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:DisembowelApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
		if amount % 2 == 1 and amount >= 3 then -- 3, 5, 7...
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:ChunkyVisceraApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(438657)
		self:PlaySound(438657, "info")
		foodOnMe = true
	end
end

function mod:ChunkyVisceraRemoved(args)
	if self:Me(args.destGUID) then
		foodOnMe = false
	end
end

function mod:JuggernautChargeIncoming(args)
	self:Message(args.spellId, "cyan", CL.soon:format(args.spellName))
end

function mod:JuggernautCharge(args)
	local spellName = self:SpellName(436200)
	self:StopBar(CL.count_amount:format(spellName, juggernautChargeCount, 4))
	self:Message(436200, "red", CL.count_amount:format(spellName, juggernautChargeCount, 4))
	self:PlaySound(436200, "warning")
	juggernautChargeCount = juggernautChargeCount + 1
	if juggernautChargeCount < 5 then
		self:Bar(436200, 7.1, CL.count_amount:format(spellName, juggernautChargeCount, 4))
	end
end

function mod:SwallowingDarkness(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm") -- possibly under you
end

function mod:ReadyToEat(args)
	if foodOnMe then
		self:Message(438657, "blue", L.chunky_viscera_message, 438324) -- Chunky Viscera
		self:PlaySound(438657, "alert")
	else
		self:Message(args.spellId, "green")
		self:PlaySound(args.spellId, "info")
	end
end

function mod:HungeringBellows(args)
	self:StopBar(CL.count:format(args.spellName, hungeringBellowsCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, hungeringBellowsCount))
	self:PlaySound(args.spellId, "alert")
	hungeringBellowsCount = hungeringBellowsCount + 1
	self:Bar(args.spellId, 7.0, CL.count:format(args.spellName, hungeringBellowsCount))
end
