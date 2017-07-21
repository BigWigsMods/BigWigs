
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

local stage = 1
local consumingHungerCounter = 1
local slicingTornadoCounter = 1
local waveCounter = 1
local dreadSharkCounter = 1
local burdenCounter = 1
local slicingTimersP3 = {0, 39.0, 34.1, 42.6}
local hydraShotCounter = 1
local abs = math.abs

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.inks_fed_count = "Ink (%d/%d)"
	L.inks_fed = "Inks fed: %s" -- %s = List of players
end

--------------------------------------------------------------------------------
-- Initialization
--

local hydraShotMarker = mod:AddMarkerOption(false, "player", 1, 230139, 1, 2, 3, 4)
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		{230139, "SAY"}, -- Hydra Shot
		hydraShotMarker,
		{230201, "TANK", "FLASH"}, -- Burden of Pain
		230959, -- Concealing Murk
		232722, -- Slicing Tornado
		230358, -- Thundering Shock
		{230384, "ME_ONLY"}, -- Consuming Hunger
		{234621, "INFOBOX"}, -- Devouring Maw
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
	self:Log("SPELL_AURA_APPLIED", "ConsumingHungerApplied", 230384, 234661) -- Stage 1, Stage 3

	-- Stage Two: Terrors of the Deep
	self:Log("SPELL_CAST_SUCCESS", "DevouringMaw", 232745)
	self:Log("SPELL_CAST_START", "BefoulingInk", 232756) -- Summon Ossunet = Befouling Ink incoming
	self:Log("SPELL_CAST_START", "CrashingWave", 232827)
	self:Log("SPELL_AURA_APPLIED", "MawApplied", 232745) -- Buffed on Sarukel
	self:Log("SPELL_AURA_REMOVED", "MawRemoved", 232745)
	self:Log("SPELL_AURA_APPLIED", "InkApplied", 232913)
	self:Log("SPELL_AURA_REMOVED", "InkRemoved", 232913)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "DeliciousBufferfish", 239362, 239375)
	self:Log("SPELL_AURA_REMOVED", "DeliciousBufferfishRemoved", 239362, 239375)
end

function mod:OnEngage()
	stage = 1
	consumingHungerCounter = 1
	slicingTornadoCounter = 1
	waveCounter = 1
	dreadSharkCounter = 1
	burdenCounter = 1
	hydraShotCounter = 1

	self:Bar(230358, 10.5) -- Thundering Shock
	self:Bar(230201, self:Easy() and 18 or 15.5, CL.count:format(self:SpellName(230201), burdenCounter)) -- Burden of Pain, Timer until cast_start
	self:Bar(230384, 20.5) -- Consuming Hunger
	if not self:LFR() then
		self:CDBar(230139, self:Normal() and 27 or 25, CL.count:format(self:SpellName(230139), hydraShotCounter)) -- Hydra Shot
	end
	self:Bar(232722, self:Easy() and 36 or 30.3) -- Slicing Tornado
	self:Berserk(self:LFR() and 540 or 480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 239423 then -- Dread Shark // Stage 2 + Stage 3
		dreadSharkCounter = dreadSharkCounter + 1
		if not self:Mythic() then
			stage = dreadSharkCounter
		elseif dreadSharkCounter == 3 or dreadSharkCounter == 5 then
			self:Message(239436, "Urgent", "Warning")
			stage = stage+1
		else
			self:Message(239436, "Urgent", "Warning")
			return -- No stage change yet
		end

		self:StopBar(232722) -- Slicing Tornado
		self:StopBar(230358) -- Thundering Shock
		self:StopBar(230384) -- Consuming Hunger
		self:StopBar(232913) -- Befouling Ink
		self:StopBar(232827) -- Crashing Wave
		self:StopBar(234621) -- Devouring Maw
		self:StopBar(CL.count:format(self:SpellName(230139), hydraShotCounter)) -- Hydra Shot
		self:StopBar(CL.count:format(self:SpellName(230201), burdenCounter)) -- Burden of Pain

		consumingHungerCounter = 1
		slicingTornadoCounter = 1
		waveCounter = 1
		burdenCounter = 1
		hydraShotCounter = 1

		self:Message("stages", "Neutral", "Long", CL.stage:format(stage), false)
		if stage == 2 then
			self:Bar(232913, 11) -- Befouling Ink
			if not self:LFR() then
				self:Bar(230139, self:Normal() and 18.2 or 15.9, CL.count:format(self:SpellName(230139), hydraShotCounter)) -- Hydra Shot
			end
			self:Bar(230201, self:Easy() and 28 or 25.6, CL.count:format(self:SpellName(230201), burdenCounter)) -- Burden of Pain, Timer until cast_start
			self:Bar(232827, self:Easy() and 39.6 or 32.5) -- Crashing Wave
			self:Bar(234621, self:Easy() and 46.5 or 42.2) -- Devouring Maw
		elseif stage == 3 then
			self:CDBar(232913, 11) -- Befouling Ink
			self:Bar(230201, self:Easy() and 28 or 25.6, CL.count:format(self:SpellName(230201), burdenCounter)) -- Burden of Pain, Timer until cast_start
			self:Bar(232827, self:Easy() and 38.5 or 32.5) -- Crashing Wave
			if not self:LFR() then
				self:Bar(230139, self:Normal() and 18.2 or 15.5, CL.count:format(self:SpellName(230139), hydraShotCounter)) -- Hydra Shot
			end

			self:Bar(230384, 40.1) -- Consuming Hunger
			self:Bar(232722, self:Easy() and 51.1 or 57.2) -- Slicing Tornado
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:HydraShot(args)
		local count = #list+1
		list[count] = args.destName

		if self:Me(args.destGUID)then
			if self:Easy() then
				self:Say(args.spellId)
			else
				self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
				self:SayCountdown(args.spellId, 6, count, 4)
			end
		end

		if count == 1 then
			self:CastBar(args.spellId, 6, CL.count:format(args.spellName, hydraShotCounter))
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Important", "Warning", nil, nil, true)
			hydraShotCounter = hydraShotCounter + 1
			self:CDBar(args.spellId, self:Mythic() and 30.5 or stage == 2 and 30 or (self:Normal() and stage == 3 and 51) or 40, CL.count:format(args.spellName, hydraShotCounter))
		end
		if self:GetOption(hydraShotMarker) then -- Targets: LFR: 0, 1 Normal, 3 Heroic, 4 Mythic
			SetRaidTarget(args.destName, count)
		end
	end

	function mod:HydraShotRemoved(args)
		if self:GetOption(hydraShotMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if self:Me(args.destGUID) and not self:Easy() then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:BurdenofPainCast(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
end

function mod:BurdenofPain(args)
	burdenCounter = burdenCounter + 1
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
	self:Bar(args.spellId, 25.5, CL.count:format(args.spellName, burdenCounter)) -- Timer until cast_start
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
	if self:Mythic() then
		self:Bar(args.spellId, stage == 3 and slicingTimersP3[slicingTornadoCounter] or 45) -- -- XXX Need more p3 data.
	else
		self:Bar(args.spellId, stage == 3 and (slicingTornadoCounter % 2 == 0 and 45 or 52) or 45) -- -- XXX Need more p3 data.
	end
end

function mod:ThunderingShock(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 36) -- was 32.8, not confirmed
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

function mod:DevouringMaw()
	self:Message(234621, "Important", "Warning")
	self:Bar(234621, 41.5)
end

function mod:BefoulingInk()
	self:Message(232913, "Attention", "Info", CL.incoming:format(self:SpellName(232913))) -- Befouling Ink incoming!
	self:CDBar(232913, stage == 3 and 32 or 41.5) -- XXX 32-34 in P3
end

function mod:CrashingWave(args)
	waveCounter = waveCounter + 1
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, self:Mythic() and 4 or 5)
	self:Bar(args.spellId, stage == 3 and (waveCounter == 3 and 49) or 42) -- XXX need more data in p3
end

function mod:DeliciousBufferfish(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(239362, args.destName, "Personal", "Alert")
	end
end

function mod:DeliciousBufferfishRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(239362, "Personal", "Alert", CL.removed:format(args.spellName))
	end
end

do
	local debuffs, inkName = {}, mod:SpellName(232913)
	local fedTable, fedCount, fedsNeeded = {}, 0, 3

	function mod:MawApplied(args)
		wipe(debuffs)
		wipe(fedTable)
		fedCount = 0
		fedsNeeded = self:Mythic() and 5 or 3
		self:OpenInfo(234621, L.inks_fed_count:format(fedCount, fedsNeeded))

		for unit in self:IterateGroup() do
			local _, _, _, _, _, _, expires = UnitDebuff(unit, inkName)
			debuffs[self:UnitName(unit)] = expires
		end
	end

	function mod:InkApplied(args)
		local _, _, _, _, _, _, expires = UnitDebuff(args.destName, inkName)
		debuffs[self:UnitName(args.destName)] = expires
	end

	function mod:InkRemoved(args)
		local name = args.destName
		local expires = debuffs[name] -- time when the debuff should expire
		if expires then
			local abs = abs(GetTime()-expires) -- difference between now and when it should've expired
			if abs > 0.1 then -- removed early, probably fed the fish
				fedTable[name] = (fedTable[name] or 0) + 1
				fedCount = fedCount + 1
				self:SetInfoTitle(234621, L.inks_fed_count:format(fedCount, fedsNeeded))
				self:SetInfoByTable(234621, fedTable)
			end
			debuffs[name] = nil
		end
	end

	function mod:MawRemoved(args)
		local list = ""
		for name, n in pairs(fedTable) do
			if n > 1 then
				list = list .. CL.count:format(self:ColorName(name), n) .. ", "
			else
				list = list .. self:ColorName(name) .. ", "
			end
		end
		self:Message(234621, "Positive", "Info", CL.over:format(args.spellName) .. " - " .. L.inks_fed:format(list:sub(0, list:len()-2)))
		self:ScheduleTimer("CloseInfo", 5, 234621) -- delay a bit to make sure the people get enough credit
	end
end
