
--------------------------------------------------------------------------------
-- TODO List:
-- - Timers for heroic+mythic (using normal atm)
-- - Tune which markers are used, depending on Mythic targets

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mistress Sassz'ine", 1147, 1861)
if not mod then return end
mod:RegisterEnableMob(115767)
mod.engageId = 2037
mod.respawnTime = 40

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local consumingHungerCounter = 1
local slicingTornadoCounter = 1
local waveCounter = 1
local dreadSharkCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

local hydraShotMarker = mod:AddMarkerOption(false, "player", 1, 230139, 1, 2, 3, 4)
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		230139, -- Hydra Shot
		hydraShotMarker,
		{230201, "TANK", "FLASH"}, -- Burden of Pain
		230959, -- Concealing Murk
		232722, -- Slicing Tornado
		230358, -- Thundering Shock
		230384, -- Consuming Hunger
		234621, -- Devouring Maw
		232913, -- Befouling Ink
		232827, -- Crashing Wave
		239436, -- Dread Shark
		239362, -- Delicious Bufferfish
	},{
		["stages"] = "general",
		[232722] = -14591,
		[232746] = -14605,
		[239436] = "mythic",
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:Log("SPELL_AURA_APPLIED", "HydraShot", 230139)
	self:Log("SPELL_AURA_REMOVED", "HydraShotRemoved", 230139)
	self:Log("SPELL_CAST_START", "BurdenofPainCast", 230201)
	self:Log("SPELL_CAST_SUCCESS", "BurdenofPain", 230201)

	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 230959) -- Concealing Murk
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 230959)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 230959)

	-- Stage One: Ten Thousand Fangs
	self:Log("SPELL_CAST_START", "SlicingTornado", 232722)
	self:Log("SPELL_CAST_START", "ThunderingShock", 230358)
	self:Log("SPELL_CAST_START", "ConsumingHunger", 230384, 234661) -- Stage 1 id + Stage 3 id
	self:Log("SPELL_AURA_APPLIED", "ConsumingHungerApplied", 230384, 234661)

	-- Stage Two: Terrors of the Deep
	self:Log("SPELL_CAST_SUCCESS", "DevouringMaw", 232745)
	self:Log("SPELL_CAST_START", "BefoulingInk", 232756) -- Summon Ossunet = Befouling Ink incoming
	self:Log("SPELL_CAST_START", "CrashingWave", 232827)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "DeliciousBufferfish", 239362, 239375)
	self:Log("SPELL_AURA_REMOVED", "DeliciousBufferfishRemoved", 239362, 239375)
end

function mod:OnEngage()
	phase = 1
	consumingHungerCounter = 1
	slicingTornadoCounter = 1
	waveCounter = 1
	dreadSharkCounter = 1

	self:Bar(230358, 10.5) -- Thundering Shock
	self:Bar(230201, 15.5) -- Burden of Pain
	self:Bar(230384, 20.5) -- Consuming Hunger
	if not self:LFR() then
		self:Bar(230139, 25) -- Hydra Shot
	end
	self:Bar(232722, 30.3) -- Slicing Tornado
	self:Berserk(self:LFR() and 540 or 480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 239423 then -- Dread Shark // Stage 2 + Stage 3
		dreadSharkCounter = dreadSharkCounter + 1
		if not self:Mythic() then
			phase = dreadSharkCounter
		elseif dreadSharkCounter == 2 or dreadSharkCounter == 4 then
			self:Message(239436, "Urgent", "Warning")
			phase = phase+1
		else
			self:Message(239436, "Urgent", "Warning")
			return -- No phase change yet
		end

		consumingHungerCounter = 1
		slicingTornadoCounter = 1
		waveCounter = 1

		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)

		if phase == 2 then
			self:StopBar(232722) -- Slicing Tornado
			self:StopBar(230358) -- Thundering Shock
			self:StopBar(230384) -- Consuming Hunger

			self:Bar(232913, 11) -- Befouling Ink
			if not self:LFR() then
				self:Bar(230139, 15.9) -- Hydra Shot
			end
			self:Bar(230201, 25.6) -- Burden of Pain
			self:Bar(232827, 32.5) -- Crashing Wave
			self:Bar(234621, 42.2) -- Devouring Maw
		elseif phase == 3 then
			self:StopBar(232913) -- Befouling Ink
			self:StopBar(232827) -- Crashing Wave
			self:StopBar(234621) -- Devouring Maw

			self:CDBar(232913, 11) -- Befouling Ink
			self:Bar(230201, 25.6) -- Burden of Pain
			self:Bar(232827, 32.5) -- Crashing Wave
			if not self:LFR() then
				self:Bar(230139, 31.6) -- Hydra Shot
			end

			self:Bar(230384, 40.1) -- Consuming Hunger
			self:Bar(232722, 57.2) -- Slicing Tornado
		end
	end
end

do
	local list, iconsUnused = mod:NewTargetList(), {1,2,3,4} -- Targets: LFR: 0, 1 Normal, 3 Heroic, 4 Mythic
	function mod:HydraShot(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Important", "Warning", nil, nil, true)
			self:CastBar(args.spellId, 6)
			self:Bar(args.spellId, phase == 2 and 30 or 40)
		end
		if self:GetOption(hydraShotMarker) then
			SetRaidTarget(args.destName, #list)
		end
	end

	function mod:HydraShotRemoved(args)
		if self:GetOption(hydraShotMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:BurdenofPainCast(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
end

function mod:BurdenofPain(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
	self:Bar(args.spellId, 25.5) -- Timer until cast_start
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:SlicingTornado(args)
	slicingTornadoCounter = slicingTornadoCounter + 1
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, phase == 3 and (slicingTornadoCounter % 2 == 0 and 45 or 52) or 45) -- -- XXX Need more p3 data.
end

function mod:ThunderingShock(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 36) -- was 32.8, not confirmed
end

function mod:ConsumingHunger(args)
	consumingHungerCounter = consumingHungerCounter + 1
	self:Bar(230384, phase == 3 and (consumingHungerCounter == 2 and 47 or 42) or 34) -- XXX Need more p3 data.
end

do
	local list = mod:NewTargetList()
	function mod:ConsumingHungerApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 230384, list, "Attention", "Alert", nil, nil, true)
		end
	end
end

function mod:DevouringMaw(args)
	self:Message(234621, "Important", "Warning")
	self:Bar(234621, 41.5)
end

function mod:BefoulingInk(args)
	self:Message(232913, "Attention", "Info", CL.incoming:format(self:SpellName(232913))) -- Befouling Ink incoming!
	self:CDBar(232913, phase == 3 and 32 or 41.5) -- XXX 32-34 in P3
end

function mod:CrashingWave(args)
	waveCounter = waveCounter + 1
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 5)
	self:Bar(args.spellId, phase == 3 and (waveCounter == 3 and 49) or 42) -- XXX need more data in p3
end

function mod:DeliciousBufferfish(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Positive")
	end
end

function mod:DeliciousBufferfishRemoved(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alert", CL.removed:format(args.spellName))
	end
end
