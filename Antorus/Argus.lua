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

local stage = 1
local coneOfDeathCounter = 1
local soulBlightOrbCounter = 1
local torturedRageCounter = 1
local sweepingScytheCounter = 1
local initializationCount = 3
local scanningTargets = nil
local vulnerabilityCollector = {}
local vulnerabilityIcons = {
	[255419] = 1, -- Holy Vulnerability (Yellow Star)
	[255429] = 2, -- Fire Vulnerability (Orange Circle)
	[255430] = 3, -- Shadow Vulnerability (Purple Diamond)
	[255422] = 4, -- Nature Vulnerability (Green Triangle)
	[255433] = 5, -- Arcane Vulnerability (Blue Moon)
	[255425] = 6, -- Frost Vulnerability (Blue Square)
	[255418] = 7, -- Physical Vulnerability (Red Cross)
}

local timersHeroic = {
	[1] = { -- XXX Not needed for other stages right now, perhaps mythic?
		-- Cone of Death
		[248165] = {31, 20.5, 22.7, 20.2, 20.5, 23.5},
		-- Soulblight Orb
		[248317] = {35.5, 25.5, 26.8, 23.2, 31},
		-- Tortured Rage
		[257296] = {12, 13.5, 13.5, 15.9, 13.5, 13.5, 15.9, 20.9, 13.5},
		-- Sweeping Scythe
		[248499] = {5.8, 11.7, 6.6, 10.3, 10.0, 5.6, 10.3, 5.9, 11.5, 10.1, 5.6, 10.3, 5.6, 15.2},
	},
}

local timersNormal = {
	[1] = {
		-- Soulblight Orb
		[248317] = {36, 33, 28, 26.5, 26.6},
		-- Sweeping Scythe
		[248499] = {7, 9.5, 7.3, 8.4, 9, 6.8, 7.3, 9.5, 7.5, 7.3, 13.1, 7.5, 8.4, 7.3, 11.5, 6.5, 10.9},
	},
}
local timers = mod:Easy() and timersNormal or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--
local vulnerabilityOptionDesc
do
	local icons, desc = "", ""
	for spell,icon in pairs(vulnerabilityIcons) do
		local tex = ("|T13700%d:15|t"):format(icon)
		icons = icons .. tex
		desc = desc .. tex .. mod:SpellName(spell) .. ", "
	end
	vulnerabilityOptionDesc = CL.marker_npc_desc:format(mod:SpellName(-17070), icons) .. "\n" .. desc:sub(0, desc:len() - 2)
end

local L = mod:GetLocale()
if L then
	L.combinedBurstAndBomb = "Combine Soulburst and Soulbomb"
	L.combinedBurstAndBomb_desc = "|cff71d5ffSoulbombs|r are always applied in combination with |cff71d5ffSoulbursts|r. Enable this option to combine those two messages into one."

	L.custom_off_always_show_combined = "Always show the combined Soulburst and Soulbomb message"
	L.custom_off_always_show_combined_desc = "The combined message won't be displayed if you get the |cff71d5ffSoulbomb|r or the |cff71d5ffSoulburst|r. Enable this option to always show the combined message, even when you're affected. |cff33ff99Useful for raid leaders.|r"

	L.custom_off_252516 = CL.marker:format(mod:SpellName(170967)) -- Vulnerability Marker
	L.custom_off_252516_desc = vulnerabilityOptionDesc
	L.custom_off_252516_icon = 1

	L.stage2_early = "Let the fury of the sea wash away this corruption!" -- Yell is 6s before the actual cast start
	L.stage3_early = "No hope. Just pain. Only pain!"  -- Yell is 14.5s before the actual cast start

	L.explosion = "%s Explosion"
	L.gifts = "Gifts: %s (Sky), %s (Sea)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tBurst:%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBomb:%s" -- short for Soulbomb

	L.countx = "%s (%dx)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local burstMarker = mod:AddMarkerOption(false, "player", 3, 250669, 3, 7) -- Soul Burst
local bombMarker = mod:AddMarkerOption(false, "player", 2, 251570, 2) -- Soul Bomb
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		--[[ Stage 1 ]]--
		248165, -- Cone of Death
		248317, -- Soulblight Orb
		{248396, "ME_ONLY", "SAY", "FLASH"}, -- Soul Blight
		248167, -- Death Fog
		257296, -- Tortured Rage
		248499, -- Sweeping Scythe
		{255594, "SAY"}, -- Sky and Sea

		--[[ Stage 2 ]]--
		{250669, "SAY"}, -- Soulburst
		burstMarker,
		{251570, "SAY"}, -- Soulbomb
		bombMarker,
		"combinedBurstAndBomb",
		"custom_off_always_show_combined",
		255826, -- Edge of Obliteration
		255199, -- Avatar of Aggramar
		255200, -- Aggramar's Boon

		--[[ Stage 3 ]]--
		252516, -- The Discs of Norgannon
		"custom_off_252516",
		{252729, "SAY"}, -- Cosmic Ray
		{252616, "SAY"}, -- Cosmic Beacon
		-17077, -- Stellar Armory
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
		[252516] = CL.stage:format(3),
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
	self:Log("SPELL_AURA_REMOVED", "SoulburstRemoved", 250669)
	self:Log("SPELL_AURA_APPLIED", "Soulbomb", 251570)
	self:Log("SPELL_AURA_REMOVED", "SoulbombRemoved", 251570)
	self:Log("SPELL_CAST_SUCCESS", "EdgeofObliteration", 255826)
	self:Log("SPELL_AURA_APPLIED", "AvatarofAggramar", 255199)
	self:Log("SPELL_AURA_APPLIED", "AggramarsBoon", 255200)

	--[[ Stage 3 ]]--
	self:Log("SPELL_CAST_START", "TemporalBlast", 257645)
	self:Log("SPELL_AURA_APPLIED", "VulnerabilityApplied", 255433, 255429, 255425, 255419, 255422, 255418, 255430)

	self:Log("SPELL_AURA_APPLIED", "CosmicRayApplied", 252729)
	self:Log("SPELL_CAST_START", "CosmicBeacon", 252616)
	self:Log("SPELL_AURA_APPLIED", "CosmicBeaconApplied", 252616)
	self:Log("SPELL_AURA_APPLIED", "StellarArmoryBuffs", 255496, 255478) -- Sword of the Cosmos, Blades of the Eternal
	self:Log("SPELL_CAST_START", "CosmicPower", 255935)


	--[[ Stage 4 ]]--
	self:Log("SPELL_CAST_START", "ReapSoul", 256542)
	self:Log("SPELL_CAST_SUCCESS", "GiftoftheLifebinder", 257619)

	self:Log("SPELL_CAST_START", "EndofAllThings", 256544)
	self:Log("SPELL_INTERRUPT", "EndofAllThingsInterupted", "*")
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
	timers = self:Easy() and timersNormal or timersHeroic
	stage = 1
	coneOfDeathCounter = 1
	soulBlightOrbCounter = 1
	torturedRageCounter = 1
	sweepingScytheCounter = 1

	self:Bar(255594, 16) -- Sky and Sea
	self:Bar(257296, self:Easy() and 13.5 or timers[stage][257296][torturedRageCounter]) -- Tortured Rage
	self:Bar(248165, self:Easy() and 39 or timers[stage][248165][coneOfDeathCounter]) -- Cone of Death
	self:Bar(248317, timers[stage][248317][soulBlightOrbCounter]) -- Soulblight Orb
	self:Bar(248499, timers[stage][248499][sweepingScytheCounter]) -- Sweeping Scythe

	self:Berserk(720)
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
		wipe(vulnerabilityCollector)
		scanningTargets = nil
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
	self:CDBar(args.spellId, self:Easy() and 24 or timers[stage][248165][coneOfDeathCounter]) -- normal: 24-26
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
	self:CDBar(args.spellId, stage == 4 and 13.5 or self:Easy() and 15.8 or timers[stage][args.spellId][torturedRageCounter])
end

function mod:SweepingScythe(args)
	if self:Tank() then
		self:Message(args.spellId, "Neutral", "Alert")
	end
	sweepingScytheCounter = sweepingScytheCounter + 1

	local timer = 6.1
	if stage == 1 then
		timer = timers[stage][args.spellId][sweepingScytheCounter]
	elseif stage == 4 then -- normal mode only
		timer = sweepingScytheCounter == 2 and 8.3 or sweepingScytheCounter % 2 == 0 and 7.1 or 6.1
	end

	self:CDBar(args.spellId, timer)
end

function mod:SweepingScytheStack(args)
	if self:Me(args.destGUID) or self:Tank() then -- Always Show for Tanks and when on self
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (amount > 2 and "Alarm") or "Warning") -- Warning sound for non-tanks, 3+ stacks warning for tanks
	end
end

function mod:SkyandSea(args)
	self:CDBar(args.spellId, self:Easy() and 30.3 or 27)
end

do
	local skyName, seaName = nil, nil

	local function announce(self)
		if skyName and seaName then
			local text = L.gifts:format(self:ColorName(skyName), self:ColorName(seaName))
			self:Message(255594, "Positive", "Long", text, 255594)
			skyName = nil
			seaName = nil
		end
	end

	function mod:GiftoftheSea(args)
		if self:Me(args.destGUID) then
			self:Say(255594, args.spellName)
		end
		seaName = args.destName
		announce(self)
	end

	function mod:GiftoftheSky(args)
		if self:Me(args.destGUID) then
			self:Say(255594, args.spellName)
		end
		skyName = args.destName
		announce(self)
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
	self:Bar(255826, 24) -- Edge of Obliteration
	self:Bar(255199, 20.8) -- Avatar of Aggramar
	self:Bar(251570, 36.1) -- Soulbomb
	self:Bar(250669, 36.1) -- Soulburst
end

do
	local burstList, bombName, isOnMe, scheduled = {}, nil, nil, nil

	local function getPlayerIcon(unit)
		return (UnitExists(unit) and GetRaidTargetIndex(unit) and ("|T%d:0|t"):format(137000+GetRaidTargetIndex(unit))) or " "
	end

	local function announce(self)
		if isOnMe == "burst" then
			self:Message(250669, "Personal", "Alarm", CL.you:format(self:SpellName(250669) .. getPlayerIcon("player")))
		elseif isOnMe == "bomb" then
			self:Message(251570, "Personal", "Warning", CL.you:format(self:SpellName(251570) .. getPlayerIcon("player")))
		end
		if self:CheckOption("combinedBurstAndBomb", "MESSAGE") then
			if not isOnMe or self:GetOption("custom_off_always_show_combined") then
				local msg = ""
				if bombName then
					msg = L.bomb:format(getPlayerIcon(bombName) .. self:ColorName(bombName)) .. " - "
				end
				local burstMsg = ""
				for _, player in pairs(burstList) do
					burstMsg = burstMsg .. getPlayerIcon(player) .. self:ColorName(player) .. ","
				end
				msg = msg .. L.burst:format(burstMsg:sub(0, burstMsg:len()-1))
				self:Message("combinedBurstAndBomb", "Important", nil, msg, false)
			end
		else
			if isOnMe ~= "burst" then
				self:TargetMessage(250669, self:ColorName(burstList), "Important")
			end
			if isOnMe ~="bomb" then
				self:TargetMessage(251570, bombName, "Urgent")
			end
		end
		wipe(burstList)
		scheduled = nil
		bombName = nil
		isOnMe = nil
	end

	function mod:Soulburst(args)
		burstList[#burstList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 15)
			isOnMe = "burst"
		end
		if #burstList == 1 then
			if not scheduled then
				scheduled = self:ScheduleTimer(announce, 0.1, self)
			end
			self:Bar(args.spellId, 15, L.explosion:format(args.spellName)) -- Soulburst Explosion
			if self:GetOption(burstMarker) then
				SetRaidTarget(args.destName, 3)
			end

			if self:Easy() and stage == 4 then -- starts in Soulbomb on other difficulties and stages
				self:Bar(args.spellId, 50.2)
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

	function mod:Soulbomb(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 15)
			isOnMe = "bomb"
		end

		bombName = args.destName

		if not scheduled then
			scheduled = self:ScheduleTimer(announce, 0.1, self)
		end

		self:TargetBar(args.spellId, self:Mythic() and 12 or 15, args.destName)
		self:Bar(args.spellId, stage == 4 and (self:Easy() and 100.5 or 54) or 42)

		if stage ~= 4 or not self:Easy() then
			self:Bar(250669, stage == 4 and 54 or 42) -- Soulburst
			self:Bar(250669, stage == 4 and 24.5 or 20, CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)
		end

		if self:GetOption(burstMarker) then
			SetRaidTarget(args.destName, 2)
		end
	end
end

function mod:SoulbombRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(burstMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:EdgeofObliteration(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:Bar(args.spellId, 34)
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
		wipe(vulnerabilityCollector)
		scanningTargets = nil
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255826) -- Edge of Obliteration
		self:StopBar(255199) -- Avatar of Aggramar
		self:StopBar(251570) -- Soulbomb
		self:StopBar(250669) -- Soulburst
		self:StopBar(CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)
	end

	self:Bar("stages", 16.6, CL.incoming:format(self:SpellName(-17070)), "achievement_boss_algalon_01") -- The Constellar Designates Incoming!
	self:Bar(-17077, self:Easy() and 30.5 or 26.3, nil, "inv_sword_2h_pandaraid_d_01") -- The Stellar Armory
	self:Bar(252516, 27.3) -- The Discs of Norgannon
	self:Bar(252729, self:Easy() and 38 or 30.4) -- Cosmic Ray
	self:Bar(252616, self:Easy() and 53 or 41.3) -- Cosmic Beacon
end

function mod:VulnerabilityApplied(args)
	if self:GetOption("custom_off_252516") then
		vulnerabilityCollector[args.destGUID] = vulnerabilityIcons[args.spellId]
		if not scanningTargets then
			self:RegisterTargetEvents("ConstellarMark")
			scanningTargets = true
		end
	end
end

function mod:ConstellarMark(_, unit, guid)
	if vulnerabilityCollector[guid] then
		SetRaidTarget(unit, vulnerabilityCollector[guid])
		vulnerabilityCollector[guid] = nil
		if not next(vulnerabilityCollector) then
			scanningTargets = nil
			self:UnregisterTargetEvents()
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
			self:Bar(args.spellId, self:Easy() and 30 or 20)
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
			self:Bar(args.spellId, self:Easy() and 30 or 20)
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
			self:Message(-17077, "Attention", "Alert", nil, "inv_sword_2h_pandaraid_d_01")
			self:Bar(-17077, 40, nil, "inv_sword_2h_pandaraid_d_01")
		end
	end
end

function mod:CosmicPower(args)
	self:Message(args.spellId, "Attention", "Alert")
end

--[[ Stage 4 ]]--
function mod:ReapSoul()
	self:UnregisterTargetEvents()

	stage = 4
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
	self:StopBar(-17077) -- The Stellar Armory
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
	if args.extraSpellId == 256544 then
		self:Message(args.extraSpellId, "Positive", "Info", CL.interrupted:format(args.extraSpellName))
		self:StopBar(CL.cast:format(args.extraSpellName))
		initializationCount = 3
		sweepingScytheCounter = 1

		-- XXX All timers seem to start from cast interupt
		if self:Easy() then
			self:Bar(248499, 5.1) -- Sweeping Scythe
		else
			self:Bar(258039, 6) -- Deadly Scythe
		end
		self:Bar(251570, 100.5) -- Soulbomb
		self:Bar(250669, 50.2) -- Soulburst
		self:Bar(257296, 11) -- Tortured Rage
		self:Bar(256388, 18.5, L.countx:format(self:SpellName(256388), initializationCount)) -- Initialization Sequence XXX depends on energy?
	end
end

function mod:DeadlyScythe(args)
	if self:Tank() then
		self:Message(args.spellId, "Neutral", "Alert")
	end
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
			self:Message(args.spellId, "Important", "Warning", L.countx:format(args.spellName, initializationCount))
			initializationCount = initializationCount + 1
			self:CDBar(args.spellId, 50, L.countx:format(args.spellName, initializationCount))
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
