if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eggtender Ovi'nax", 2657, 2612)
if not mod then return end
mod:RegisterEnableMob(214506) -- Eggtender Ovi'nax
mod:SetEncounterID(2919)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	440421, -- Experimental Dosage
})

--------------------------------------------------------------------------------
-- Locals
--

local experimentalDosageCount = 1
local ingestBlackBloodCount = 1
local reverberationCount = 1
local unstableWebCount = 1
local volatileConcoctionCount = 1
local myFixateList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.unstable_web_say = "Web"
	L.casting_infest_on_you = "Casting Infest on YOU!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{442526, "PRIVATE"}, -- Experimental Dosage
		442660, -- Rupture
		442432, -- Ingest Black Blood
		442799, -- Sanguine Overflow
		450661, -- Caustic Reaction
		443274, -- Reverberation
		{446349, "SAY", "ME_ONLY_EMPHASIZE"}, -- Unstable Web
		446351, -- Web Eruption
		{441362, "TANK_HEALER"}, -- Volatile Concoction
		458212, -- Necrotic Wound
		446700, -- Poison Burst
		442250, -- Fixate
		442257, -- Infest
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ExperimentalDosage", 442526)
	self:Log("SPELL_AURA_APPLIED", "RuptureApplied", 442660)
	self:Log("SPELL_CAST_SUCCESS", "IngestBlackBlood", 442432)
	self:Log("SPELL_AURA_APPLIED", "SanguineOverflowApplied", 442799)
	self:Log("SPELL_CAST_SUCCESS", "CausticReaction", 450661)
	self:Log("SPELL_AURA_APPLIED", "ReverberationApplied", 443274)
	self:Log("SPELL_AURA_APPLIED", "UnstableWeb", 446349) -- XXX 446344 is the uscs event, would be better than throttling off this debuff
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
end

function mod:OnEngage()
	experimentalDosageCount = 1
	ingestBlackBloodCount = 1
	reverberationCount = 1
	unstableWebCount = 1
	volatileConcoctionCount = 1
	myFixateList = {}

	self:Bar(441362, 2, CL.count:format(self:SpellName(441362), volatileConcoctionCount)) -- Volatile Concoction
	self:Bar(446349, 15, CL.count:format(self:SpellName(446349), unstableWebCount)) -- Unstable Web
	self:Bar(442432, 20, CL.count:format(self:SpellName(442432), ingestBlackBloodCount)) -- Ingest Black Blood
	self:Bar(442526, 51, CL.count:format(self:SpellName(442526), experimentalDosageCount)) -- Experimental Dosage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ExperimentalDosage(args)
	self:StopBar(CL.count:format(args.spellName, experimentalDosageCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, experimentalDosageCount))
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 7.5, CL.count:format(CL.explosion, experimentalDosageCount)) -- 1.5s Cast + 6s (Private) Debuff
	experimentalDosageCount = experimentalDosageCount + 1
	self:Bar(args.spellId, 51, CL.count:format(args.spellName, experimentalDosageCount))
end

function mod:RuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:IngestBlackBlood(args)
	self:StopBar(CL.count:format(args.spellName, ingestBlackBloodCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, ingestBlackBloodCount))
	self:PlaySound(args.spellId, "long")
	ingestBlackBloodCount = ingestBlackBloodCount + 1
	self:Bar(args.spellId, 168, CL.count:format(args.spellName, ingestBlackBloodCount))
end

function mod:SanguineOverflowApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CausticReaction(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

do
	local prev = 0
	function mod:ReverberationApplied(args)
		if args.time-prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, reverberationCount))
			reverberationCount = reverberationCount + 1
			self:Bar(args.spellId, 7.5, CL.count:format(args.spellName, reverberationCount))
		end
	end
end

do
	local prev = 0
	local onMeTime = 0
	function mod:UnstableWeb(args)
		if args.time-prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, unstableWebCount))
			self:Message(args.spellId, "yellow", CL.count:format(args.spellName, unstableWebCount))
			unstableWebCount = unstableWebCount + 1
			self:Bar(args.spellId, 32, CL.count:format(args.spellName, unstableWebCount))
		end
		if self:Me(args.destGUID)  then
			onMeTime = args.time
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.unstable_web_say, nil, "Web")
		end
	end

	function mod:WebEruptionApplied(args)
		if self:Me(args.destGUID) and args.time-onMeTime > 10 then -- You didn't have Unstable Web
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "info")
		end
	end
end

do
	local lastMsg = ""
	function mod:VolatileConcoction(args)
		lastMsg = CL.count:format(args.spellName, volatileConcoctionCount)
		self:StopBar(lastMsg)
		volatileConcoctionCount = volatileConcoctionCount + 1
		self:Bar(441362, volatileConcoctionCount > 2 and 20 or 36, CL.count:format(args.spellName, volatileConcoctionCount))
	end

	function mod:VolatileConcoctionApplied(args)
		self:TargetMessage(args.spellId, "purple", args.destName, lastMsg)
		self:TargetBar(args.spellId, 8, args.destName, lastMsg)
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "warning") -- Taunt
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm") -- On you
		end
	end

	function mod:VolatileConcoctionRemoved(args)
		self:StopBar(lastMsg, args.destName)
	end
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

do
	function mod:FixateApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, CL.fixate)
			self:PlaySound(args.spellId, "alarm")
			myFixateList[args.sourceGUID] = true
		end
	end

	function mod:FixateRemoved(args)
		if self:Me(args.destGUID) then
			myFixateList[args.sourceGUID] = nil
		end
	end

	function mod:Infest(args)
		if myFixateList[args.sourceGUID] then
			self:Message(args.spellId, "red", L.casting_infest_on_you)
			self:PlaySound(args.spellId, "warning")
		end
	end
end
