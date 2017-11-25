--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Argus the Unmaker", nil, 2031, 1712)
if not mod then return end
mod:RegisterEnableMob(124828)
mod.engageId = 2092
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local _, armoryDesc = EJ_GetSectionInfo(17077)
local stage = 1
local coneOfDeathCounter = 1
local soulBlightOrbCounter = 1
local torturedRageCounter = 1
local sweepingScytheCounter = 1

local mobCollector = {}

local timers = {
	[1] = { -- XXX Not needed for other stages right now, perhaps mythic?
		-- Cone of Death
		[248165] = {31, 20.5, 22.7, 20.2, 20.5, 23.5},
		-- Soul Blight Orb
		[248317] = {35.5, 25.5, 26.8, 23.2, 31},
		-- Tortured Rage
		[257296] = {12, 13.5, 13.5, 15.9, 13.5, 13.5, 15.9, 20.9, 13.5},
		-- Sweeping Scythe
		[248499] = {5.8, 11.7, 6.6, 10.3, 10.0, 5.6, 10.3, 5.9, 11.5, 10.1, 5.6, 10.3, 5.6, 15.2},
	},
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.stage2_early = "Let the fury of the sea wash away this corruption!" -- Yell is 6s before the actual cast start
	L.stage3_early = "No hope. Just pain. Only pain!"  -- Yell is 14.5s before the actual cast start

	L.explosion = "%s Exploding"

	L.stellarArmory = "{-17077}"
	L.stellarArmory_desc = armoryDesc
	L.stellarArmory_icon = "inv_sword_2h_pandaraid_d_01"
end

--------------------------------------------------------------------------------
-- Initialization
--

local burstMarker = mod:AddMarkerOption(false, "player", 3, 250669, 3, 7) -- Soul Burst
local bombMarker = mod:AddMarkerOption(false, "player", 2, 251570, 2) -- Soul Bomb
local constellarMarker = mod:AddMarkerOption(false, "npc", 1, 252516, 1, 2, 3, 4, 5, 6, 7) -- The Discs of Norgannon
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		--[[ Stage 1 ]]--
		248165, -- Cone of Death
		248317, -- Soul Blight Orb
		{248396, "ME_ONLY", "SAY", "FLASH"}, -- Soul Blight
		248167, -- Death Fog
		257296, -- Tortured Rage
		248499, -- Sweeping Scythe
		{255594, "SAY"}, -- Sky and Sea

		--[[ Stage 2 ]]--
		{250669, "SAY"}, -- Soul Burst
		burstMarker,
		{251570, "SAY"}, -- Soul Bomb
		bombMarker,
		255826, -- Edge of Obliteration
		255199, -- Avatar of Aggramar
		255200, -- Aggramar's Boon

		--[[ Stage 3 ]]--
		constellarMarker,
		{252729, "SAY"}, -- Cosmic Ray
		{252616, "SAY"}, -- Cosmic Beacon
		"stellarArmory",
		255935, -- Cosmic Power

		--[[ Stage 4 ]]--
		256544, -- End of All Things
		258039, -- Deadly Scythe
		256388, -- Initialization Sequence
		257214, -- Titanforging
	},{
		["stages"] = "general",
		[248165] = CL.stage:format(1),
		[250669] = CL.stage:format(2),
		[constellarMarker] = CL.stage:format(3),
		[256544] = CL.stage:format(4),
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	--[[ Stage 1 ]]--
	self:Log("SPELL_CAST_START", "ConeofDeath", 248165)
	self:Log("SPELL_CAST_START", "SoulBlightOrb", 248317)
	self:Log("SPELL_AURA_APPLIED", "SoulBlight", 248396)
	self:Log("SPELL_AURA_REMOVED", "SoulBlightRemoved", 248396)
	self:Log("SPELL_CAST_START", "TorturedRage", 257296)
	self:Log("SPELL_CAST_START", "SweepingScythe", 248499)
	self:Log("SPELL_AURA_APPLIED", "SweepingScytheStack", 244899)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SweepingScytheStack", 244899)
	self:Log("SPELL_CAST_SUCCESS", "SkyandSea", 255594)
	self:Log("SPELL_AURA_APPLIED", "GiftoftheSea", 258647)
	self:Log("SPELL_AURA_APPLIED", "GiftoftheSky", 258646)
	self:Log("SPELL_AURA_APPLIED", "StrengthoftheSkyandSea", 253901, 253903) -- Strength of the Sea, Strength of the Sky
	self:Log("SPELL_AURA_APPLIED_DOSE", "StrengthoftheSkyandSea", 253901, 253903) -- Strength of the Sea, Strength of the Sky

	--[[ Stage 2 ]]--
	self:Log("SPELL_CAST_START", "GolgannethsWrath", 255648)
	self:Log("SPELL_AURA_APPLIED", "Soulburst", 250669)
	self:Log("SPELL_AURA_REMOVED", "SoulburstRemoved", 248396)
	self:Log("SPELL_AURA_APPLIED", "Soulbomb", 251570)
	self:Log("SPELL_AURA_REMOVED", "SoulbombRemoved", 251570)
	self:Log("SPELL_CAST_SUCCESS", "EdgeofObliteration", 255826)
	self:Log("SPELL_AURA_APPLIED", "AvatarofAggramar", 255199)
	self:Log("SPELL_AURA_APPLIED", "AggramarsBoon", 255200)

	--[[ Stage 3 ]]--
	self:Log("SPELL_CAST_START", "TemporalBlast", 257645)
	self:Log("SPELL_CAST_SUCCESS", "TheDiscsofNorgannonSuccess", 252516)
	self:Log("SPELL_AURA_APPLIED", "CosmicRayApplied", 252729)
	self:Log("SPELL_CAST_START", "CosmicBeacon", 252616)
	self:Log("SPELL_AURA_APPLIED", "CosmicBeaconApplied", 252616)
	self:Log("SPELL_AURA_APPLIED", "StellarArmoryBuffs", 255496, 255478) -- Sword of the Cosmos, Blades of the Eternal
	self:Log("SPELL_CAST_START", "CosmicPower", 255935)


	--[[ Stage 4 ]]--
	self:Log("SPELL_CAST_START", "ReapSoul", 256542)
	self:Log("SPELL_CAST_SUCCESS", "GiftoftheLifebinder", 257619)

	self:Log("SPELL_CAST_START", "EndofAllThings", 256544)
	self:Log("SPELL_INTERRUPT", "EndofAllThingsInterupted", 256544)
	self:Log("SPELL_CAST_START", "DeadlyScythe", 258039)
	self:Log("SPELL_AURA_APPLIED", "DeadlyScytheStack", 258039)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DeadlyScytheStack", 258039)
	self:Log("SPELL_CAST_SUCCESS", "InitializationSequence", 256388)
	self:Log("SPELL_CAST_SUCCESS", "Titanforging", 257214)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundEffects", 248167) -- Death Fog
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffects", 248167) -- Death Fog
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffects", 248167) -- Death Fog
end

function mod:OnEngage()
	stage = 1
	coneOfDeathCounter = 1
	soulBlightOrbCounter = 1
	torturedRageCounter = 1
	sweepingScytheCounter = 1
	wipe(mobCollector)

	self:Bar(255594, 16) -- Sky and Sea
	self:Bar(257296, timers[stage][257296][torturedRageCounter]) -- Tortured Rage
	self:Bar(248165, timers[stage][248165][coneOfDeathCounter]) -- Cone of Death
	self:Bar(248317, timers[stage][248317][soulBlightOrbCounter]) -- Soul Blight Orb
	self:Bar(248499, timers[stage][248499][sweepingScytheCounter]) -- Sweeping Scythe

	self:Berserk(720) -- Heroic PTR
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.stage2_early) then -- We start bars for stage 2 later
		stage = 2
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(248165) -- Cone of Death
		self:StopBar(248317) -- Blight Orb
		self:StopBar(257296) -- Tortured Rage
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255594) -- Sky and Sea
	elseif msg:find(L.stage3_early) then -- We start bars for stage 3 later
		stage = 3
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255826) -- Edge of Obliteration
		self:StopBar(255199) -- Avatar of Aggramar
		self:StopBar(251570) -- Soulbomb
		self:StopBar(250669) -- Soulburst
		self:StopBar(CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)
	end
end

--[[ Stage 1 ]]--
function mod:ConeofDeath(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	coneOfDeathCounter = coneOfDeathCounter + 1
	self:CDBar(args.spellId, timers[stage][248165][coneOfDeathCounter])
end

function mod:SoulBlightOrb(args)
	self:Message(args.spellId, "Neutral", "Alert", CL.casting:format(args.spellName))
	soulBlightOrbCounter = soulBlightOrbCounter + 1
	self:CDBar(args.spellId, timers[stage][args.spellId][soulBlightOrbCounter])
end

function mod:SoulBlight(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:TargetBar(args.spellId, 8, args.destName)
	end
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Warning")
end

function mod:SoulBlightRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:TorturedRage(args)
	self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(args.spellName))
	torturedRageCounter = torturedRageCounter + 1
	self:CDBar(args.spellId, stage == 4 and 13.5 or timers[stage][args.spellId][torturedRageCounter])
end

function mod:SweepingScythe(args)
	self:Message(args.spellId, "Neutral", "Alert")
	sweepingScytheCounter = sweepingScytheCounter + 1
	self:CDBar(args.spellId, stage == 2 and 6.1 or timers[stage][args.spellId][sweepingScytheCounter])
end

function mod:SweepingScytheStack(args)
	if self:Me(args.destGUID) or self:Tank() then -- Always Show for Tanks and when on self
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (amount > 2 and "Alarm") or "Warning") -- Warning sound for non-tanks, 3+ stacks warning for tanks
	end
end

function mod:SkyandSea(args)
	self:CDBar(args.spellId, 27)
end

-- XXX 2 message perhaps too much, maybe combine?
function mod:GiftoftheSea(args)
	self:TargetMessage(255594, args.destName, "Positive", "Long", args.spellName, nil, true)
	if self:Me(args.destGUID) then
		self:Say(255594, args.spellName)
	end
end

function mod:GiftoftheSky(args)
	self:TargetMessage(255594, args.destName, "Positive", "Long", args.spellName, nil, true)
	if self:Me(args.destGUID) then
		self:Say(255594, args.spellName)
	end
end

function mod:StrengthoftheSkyandSea(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:Message(255594, "Positive", "Info", CL.stackyou:format(amount, args.spellName))
	end
end

--[[ Stage 2 ]]--
function mod:GolgannethsWrath()
	if not stage == 2 then -- We already set stage 2 from the yell
		stage = 2
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(248165) -- Cone of Death
		self:StopBar(248317) -- Blight Orb
		self:StopBar(257296) -- Tortured Rage
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255594) -- Sky and Sea
	end

	self:Bar(248499, 17) -- Sweeping Scythe
	self:Bar(255826, 21.9) -- Edge of Obliteration
	self:Bar(255199, 20.8) -- Avatar of Aggramar
	self:Bar(251570, 36.1) -- Soulbomb
	self:Bar(250669, 36.1) -- Soulburst
end

do
	local playerList = mod:NewTargetList()
	function mod:Soulburst(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 15)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
			if self:GetOption(burstMarker) then
				SetRaidTarget(args.destName, 3)
			end
		elseif self:GetOption(burstMarker) then
				SetRaidTarget(args.destName, 7)
		end
	end

	function mod:SoulburstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(burstMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:Soulbomb(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 15)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
	self:Bar(args.spellId, stage == 4 and 54 or 42)

	self:Bar(250669, stage == 4 and 54 or 42) -- Soulburst
	self:Bar(250669, stage == 4 and 24.5 or 20, CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)

	if self:GetOption(burstMarker) then
		SetRaidTarget(args.destName, 2)
	end
end

function mod:SoulbombRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(burstMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:EdgeofObliteration(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:Bar(args.spellId, 30.5)
end

function mod:AvatarofAggramar(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Long")
	self:Bar(args.spellId, 60)
end

do
	local prev = 0
	function mod:AggramarsBoon(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 0.5 then -- Throttle incase you are on the edge/tank moves around slightly
				prev = t
				self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
			end
		end
	end
end

--[[ Stage 3 ]]--
function mod:TemporalBlast()
	if not stage == 3 then
		stage = 3
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255826) -- Edge of Obliteration
		self:StopBar(255199) -- Avatar of Aggramar
		self:StopBar(251570) -- Soulbomb
		self:StopBar(250669) -- Soulburst
		self:StopBar(CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)
	end

	self:Bar("stages", 16.6, CL.incoming:format(self:SpellName(-17070)), "achievement_boss_algalon_01") -- The Constellar Designates Incoming!
	self:Bar("stellarArmory", 26.3, L.stellarArmory, L.stellarArmory_icon) -- The Stellar Armory
	self:Bar(252616, 41.3) -- Cosmic Beacon
end

function mod:TheDiscsofNorgannonSuccess()
	if self:GetOption(constellarMarker) then
		self:RegisterTargetEvents("constellarMark")
		self:ScheduleTimer("UnregisterTargetEvents", 10)
	end
end

do
	local markCounter = 0
	function mod:constellarMark(event, unit, guid)
		if self:MobId(guid) == 127192 and not mobCollector[guid] then
			if UnitDebuff(unit, 255433) then -- Arcane Vulnerability (Blue Moon)
				SetRaidTarget(unit, 5)
				markCounter = markCounter + 1
			elseif UnitDebuff(unit, 255429) then -- Fire Vulnerability (Orange Circle)
				SetRaidTarget(unit, 2)
				markCounter = markCounter + 1
			elseif UnitDebuff(unit, 255425) then -- Frost Vulnerability (Blue Square)
				SetRaidTarget(unit, 6)
				markCounter = markCounter + 1
			elseif UnitDebuff(unit, 255419) then -- Holy Vulnerability (Yellow Star)
				SetRaidTarget(unit, 1)
				markCounter = markCounter + 1
			elseif UnitDebuff(unit, 255422) then -- Nature Vulnerability (Green Triangle)
				SetRaidTarget(unit, 4)
				markCounter = markCounter + 1
			elseif UnitDebuff(unit, 255418) then -- Physical Vulnerability (Red Cross)
				SetRaidTarget(unit, 7)
				markCounter = markCounter + 1
			elseif UnitDebuff(unit, 255430) then -- Shadow Vulnerability (Purple Diamond)
				SetRaidTarget(unit, 3)
				markCounter = markCounter + 1
			end

			mobCollector[guid] = true
			if markCounter == 7 then
				self:UnregisterTargetEvents()
			end
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:CosmicRayApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning", nil, nil, true)
			self:Bar(args.spellId, 20)
		end
	end
end

do
	local prev = 0
	function mod:CosmicBeacon(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
			self:Bar(args.spellId, 20)
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:CosmicBeaconApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Alarm", nil, nil, true)
		end
	end
end

do
	local prev = 0
	function mod:StellarArmoryBuffs()
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("stellarArmory", "Attention", "Alert", L.stellarArmory, L.stellarArmory_icon)
			self:Bar("stellarArmory", 40, L.stellarArmory, L.stellarArmory_icon)
		end
	end
end

function mod:CosmicPower(args)
	self:Message(args.spellId, "Attention", "Alert")
end

--[[ Stage 4 ]]--
function mod:ReapSoul()
	stage = 4
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
	self:StopBar(L.stellarArmory) -- The Stellar Armory
	self:StopBar(252616) -- Cosmic Beacon
	self:StopBar(252729) -- Cosmic Ray

	self:Bar("stages", 35.5, 257619, 257619) -- Gift of the Lifebinder
end

function mod:GiftoftheLifebinder(args)
	self:Message("stages", "Positive", "Long", args.spellName, args.spellId)
end

function mod:EndofAllThings(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 15)
end

function mod:EndofAllThingsInterupted(args)
	self:Message(args.spellId, "Positive", "Info", args.spellName, args.spellId)
	self:StopBar(CL.cast:format(args.spellName))

	-- XXX All timers seem to start from cast interupt
	self:Bar(258039, 6) -- Deadly Scythe
	--self:Bar(251570, 6) -- Soulbomb -- XXX Depends on energy going out of stage 2 atm
	--self:Bar(250669, 6) -- Soulburst -- XXX Depends on energy going out of stage 2 atm
	self:Bar(257296, 11) -- Tortured Rage
	self:Bar(256396, 18.5) -- Initialization Sequence
end

function mod:DeadlyScythe(args)
	self:Message(args.spellId, "Neutral", "Alert")
	self:Bar(args.spellId, 6.6)
end

function mod:DeadlyScytheStack(args)
	if self:Me(args.destGUID) or self:Tank() then -- Always Show for Tanks and when on Self
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (self:Me(args.destGUID) and "Alarm") or "Warning") -- Warning sound for non-tanks, only on self when a tank
	end
end

do
	local prev = 0
	function mod:InitializationSequence(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Important", "Warning")
			self:CDBar(args.spellId, 50)
		end
	end
end

function mod:Titanforging(args)
	self:Message(args.spellId, "Positive", "Long", CL.casting:format(args.spellName))
end

-- Ground Effects
do
	local prev = 0
	function mod:GroundEffects(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName)) -- Death Fog
		end
	end
end
