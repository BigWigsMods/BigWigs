if not IsTestBuild() then return end -- XXX dont load on live

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

local inkCounter = 1
local timersBefoulingInkP3 = {12.4, 31.6, 31.6, 37.6, 31.6, 34.1}


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
	self:Log("SPELL_CAST_SUCCESS", "DreadShark", 239436)
	self:Log("SPELL_AURA_APPLIED", "DeliciousBufferfish", 239362, 239375)
	self:Log("SPELL_AURA_REMOVED", "DeliciousBufferfishRemoved", 239362, 239375)
end

function mod:OnEngage()
	phase = 1
	consumingHungerCounter = 1
	slicingTornadoCounter = 1
	inkCounter = 1
	waveCounter = 1

	self:Bar(230358, 10.5) -- Thundering Shock
	self:Bar(230201, 17.9) -- Burden of Pain
	self:Bar(230384, 20.2) -- Consuming Hunger
	self:Bar(230139, 25) -- Hydra Shot
	self:Bar(232722, 30.3) -- Slicing Tornado
	self:Berserk(480) -- Normal mode testing - Slicing Tornado spam
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 239423 then -- Dread Shark // Stage 2 + Stage 3 // Alternative for Stage 3: 240435
		phase = phase + 1
		consumingHungerCounter = 1
		slicingTornadoCounter = 1
		inkCounter = 1
		waveCounter = 1

		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)

		if phase == 2 then
			self:StopBar(232722) -- Slicing Tornado
			self:StopBar(230358) -- Thundering Shock
			self:StopBar(230384) -- Consuming Hunger

			self:Bar(232913, 11) -- Befouling Ink
			self:Bar(230139, 25.5) -- Hydra Shot
			self:Bar(230201, 29.2) -- Burden of Pain
			self:Bar(232827, 30.4) -- Crashing Wave
			self:Bar(232745, 42.2) -- Devouring Maw
		elseif phase == 3 then
			self:StopBar(232913) -- Befouling Ink
			self:StopBar(230139) -- Hydra Shot
			self:StopBar(230201) -- Burden of Pain
			self:StopBar(232827) -- Crashing Wave
			self:StopBar(232745) -- Devouring Maw

			self:Bar(232913, timersBefoulingInkP3[inkCounter]) -- Befouling Ink
			self:Bar(232827, 27.5) -- Crashing Wave
			self:Bar(230201, 30.4) -- Burden of Pain
			self:Bar(230139, 31.6) -- Hydra Shot
			self:Bar(230384, 35.2) -- Consuming Hunger
			self:Bar(232722, 49.8) -- Slicing Tornado
		end
	end
end

do
	local list, iconsUnused = mod:NewTargetList(), {1,2,3,4} -- Targets: 1 Normal, 3 Heroic, ?? Mythic
	function mod:HydraShot(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning", nil, nil, true)
			self:Bar(args.spellId, 6, CL.casting:format(args.spellName))
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

function mod:BurdenofPain(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
	self:TargetBar(args.spellId, 20, args.destName)
	self:Bar(args.spellId, 28)

	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

function mod:SlicingTornado(args)
	slicingTornadoCounter = slicingTornadoCounter + 1
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, phase == 3 and (slicingTornadoCounter % 2 == 0 and 44.9 or 55.9) or 61.5) -- -- XXX Need more p3 data.
end

function mod:ThunderingShock(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 32.8)
end

function mod:ConsumingHunger(args)
	consumingHungerCounter = consumingHungerCounter + 1
	self:Message(args.spellId, "Attention", "Alert", args.spellName)
	self:Bar(args.spellId, phase == 3 and (consumingHungerCounter % 2 == 0 and 31.5 or 37.5) or 34) -- XXX Need more p3 data.
end

function mod:DevouringMaw(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 42)
end

function mod:BefoulingInk(args)
	inkCounter = inkCounter + 1
	self:Message(232913, "Attention", "Info", L.incoming:format(self:SpellName(232913))) -- Befouling Ink incoming!
	self:Bar(232913, phase == 3 and timersBefoulingInkP3[inkCounter] or 42) -- XXX need more data in p3
end

function mod:CrashingWave(args)
	waveCounter = waveCounter + 1
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 4, CL.casting:format(args.spellName))
	self:Bar(args.spellId, phase == 3 and (waveCounter == 2 and 55.5 or 42) or 42) -- XXX need more data in p3
end

function mod:DreadShark(args)
	self:Message(args.spellId, "Attention", "Info")
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