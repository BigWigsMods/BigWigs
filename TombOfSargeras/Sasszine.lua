
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
		{230201, "FLASH"}, -- Burden of Pain
		232722, -- Slicing Tornado
		230358, -- Thundering Shock
		230384, -- Consuming Hunger
		232745, -- Devouring Maw
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

	-- Stage One: Ten Thousand Fangs
	self:Log("SPELL_CAST_START", "SlicingTornado", 232722)
	self:Log("SPELL_CAST_START", "ThunderingShock", 230358)
	self:Log("SPELL_CAST_START", "ConsumingHunger", 230384)

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
	self:Berserk(self:LFR() and 540 or 480) -- Confirmed LFR + Normal
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 239423 then -- Dread Shark // Stage 2 + Stage 3
		dreadSharkCounter = dreadSharkCounter + 1
		if not self:Mythic() then
			phase = dreadSharkCounter
		elseif dreadSharkCounter == 2 then
			self:Message(239436, "Urgent", "Warning")
			phase = 2
		elseif dreadSharkCounter == 4 then
			self:Message(239436, "Urgent", "Warning")
			phase = 3
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
				self:Bar(230139, 25.5) -- Hydra Shot
			end
			self:Bar(230201, 25.6) -- Burden of Pain
			self:Bar(232827, 30.4) -- Crashing Wave
			self:Bar(232745, 42) -- Devouring Maw
		elseif phase == 3 then
			self:StopBar(232913) -- Befouling Ink
			self:StopBar(232827) -- Crashing Wave
			self:StopBar(232745) -- Devouring Maw

			self:CDBar(232913, 11) -- Befouling Ink
			self:Bar(230201, 25.6) -- Burden of Pain
			self:Bar(232827, 27.5) -- Crashing Wave
			if not self:LFR() then
				self:Bar(230139, 31.6) -- Hydra Shot
			end
			self:Bar(230384, 35.2) -- Consuming Hunger
			self:Bar(232722, 49.8) -- Slicing Tornado
		end
	end
end

do
	local list, iconsUnused = mod:NewTargetList(), {1,2,3,4} -- Targets: LFR: 0, 1 Normal, 3 Heroic, 4 Mythic
	function mod:HydraShot(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning", nil, nil, true)
			self:CastBar(args.spellId, 6)
			self:Bar(args.spellId, phase == 2 and 30 or 40)
		end
		if self:GetOption(hydraShotMarker) then
			local icon = iconsUnused[1]
			if icon then
				SetRaidTarget(args.destName, icon)
				tDeleteItem(iconsUnused, icon)
			end
		end
	end

	function mod:HydraShotRemoved(args)
		if self:GetOption(hydraShotMarker) then
			local icon = GetRaidTargetIndex(args.destName)
			if icon > 0 and icon < 5 and not tContains(iconsUnused, icon) then
				table.insert(iconsUnused, icon)
				SetRaidTarget(args.destName, 0)
			end
		end
	end
end

function mod:BurdenofPainCast(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
end

function mod:BurdenofPain(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
	self:Bar(args.spellId, 28)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

function mod:SlicingTornado(args)
	slicingTornadoCounter = slicingTornadoCounter + 1
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, phase == 3 and (slicingTornadoCounter % 2 == 0 and 44.9 or 55.9) or 61.5) -- -- XXX Need more p3 data.
end

function mod:ThunderingShock(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 32.8)
end

function mod:ConsumingHunger(args)
	consumingHungerCounter = consumingHungerCounter + 1
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, phase == 3 and (consumingHungerCounter % 2 == 0 and 31.5 or 37.5) or 34) -- XXX Need more p3 data.
end

function mod:DevouringMaw(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 42)
end

function mod:BefoulingInk(args)
	self:Message(232913, "Attention", "Info", CL.incoming:format(self:SpellName(232913))) -- Befouling Ink incoming!
	self:Bar(232913, phase == 3 and 34 or 42) -- XXX 34~37 in P3
end

function mod:CrashingWave(args)
	waveCounter = waveCounter + 1
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 4)
	self:Bar(args.spellId, phase == 3 and (waveCounter == 2 and 55.5 or 42) or 42) -- XXX need more data in p3
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