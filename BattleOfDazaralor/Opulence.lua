
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Opulence", 2070, 2342)
if not mod then return end
mod:RegisterEnableMob(145273, 145274, 145261) -- The Hand of In'zashi, Yalat's Bulwark, Opulence
mod.engageId = 2271
mod.respawnTime = 32

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local wailofGreedCount = 1
local spiritsofGoldCount = 1
local handRoomCount = 1
local bulwarkRoomCount = 1
local bulwarkCrushCount = 1
local jewelTracker = {} -- Who has which jewel
local topazStackTracker = {} -- Stacks
local critBuffTracker = {} -- Time on crit buff
local gemInfoBoxOpen = nil
local hexCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.room = "Room (%d/8)"
	L.no_jewel = "No Jewel:"

	L.swap = 161399 -- Swap (replacement for Chaotic Displacement)

	L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the construct which isn't in your hall during stage 1."

	L.custom_on_hand_timers = "The Hand of In'zashi"
	L.custom_on_hand_timers_desc = "Show warnings and bars for The Hand of In'zashi's abilities."
	L.hand_cast = "Hand: %s"

	L.custom_on_bulwark_timers = "Yalat's Bulwark"
	L.custom_on_bulwark_timers_desc = "Show warnings and bars for Yalat's Bulwark's abilities."
	L.bulwark_cast = "Bulwark: %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

local hexOfLethargyMarker = mod:AddMarkerOption(false, "player", 1, 284470, 1, 2, 3, 4) -- Hex of Lethargy
function mod:GetOptions()
	return {
		"stages",
		286541, -- Consuming Flame
		{-19494, "INFOBOX"}, -- The Zandalari Crown Jewels
		{284645, "SAY", "INFOBOX"}, -- Topaz of Brilliant Sunlight
		-- Stage 1
		283606, -- Crush
		"custom_on_fade_out_bars",
		289383, -- Chaotic Displacement
		-- The Hand of In'zashi
		"custom_on_hand_timers",
		{283507, "SAY", "SAY_COUNTDOWN"}, -- Volatile Charge
		-- Yalat's Bulwark
		"custom_on_bulwark_timers",
		282939, -- Flames of Punishment
		-- Traps
		285479, -- Flame Jet
		284424, -- Scorching Ground
		284493, -- Pulse-quickening Toxin
		284519, -- Quickened Pulse
		{284470, "ME_ONLY_EMPHASIZE"}, -- Hex of Lethargy
		hexOfLethargyMarker,
		-- Stage 2
		287070, -- Hoard Power
		{287072, "SAY", "SAY_COUNTDOWN"}, -- Liquid Gold
		287074, -- Molten Gold
		285995, -- Spirits of Gold
		286026, -- Channel Gold
		{285014, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Coin Shower
		284941, -- Wail of Greed
		{287037, "TANK"}, -- Coin Sweep
		-- Mythic
		289155, -- Surging Gold
	}, {
		["stages"] = CL.general,
		[-19494] = -19494, -- Crown Jewels
		[283606] = CL.stage:format(1),
		["custom_on_hand_timers"] = -19497, -- The Hand of In'zashi
		["custom_on_bulwark_timers"] = -19498, -- Yalat's Bulwark
		[285479] = -19519, -- Traps
		[287070] = CL.stage:format(2),
		[289155] = CL.mythic,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
	self:RegisterMessage("BigWigs_BarEmphasized", "BarEmphasized")
	-- Stage 1
	self:Log("SPELL_CAST_START", "Crush", 283606, 289906)
	self:Log("SPELL_CAST_SUCCESS", "ConsumingFlame", 286541)
	self:Log("SPELL_AURA_APPLIED", "ChaoticDisplacement", 289383)
	self:Log("SPELL_AURA_REMOVED", "ChaoticDisplacementRemoved", 289383)
	-- The Hand of In'zashi
	self:Log("SPELL_AURA_APPLIED", "VolatileChargeApplied", 283507, 287648) -- Normal, Empowered
	self:Log("SPELL_AURA_REMOVED", "VolatileChargeRemoved", 283507, 287648)
	-- Yalat's Bulwark
	self:Log("SPELL_CAST_START", "FlamesofPunishment", 282939, 287659) -- Normal, Empowered
	-- Traps
	self:Log("SPELL_AURA_APPLIED", "PulsequickeningToxin", 284493)
	self:Log("SPELL_AURA_APPLIED", "QuickenedPulseApplied", 284519)
	self:Log("SPELL_AURA_APPLIED", "HexOfLethargyApplied", 284470)
	self:Log("SPELL_AURA_REMOVED", "HexOfLethargyRemoved", 284470)
	-- Jewels
	self:Log("SPELL_AURA_APPLIED", "JewelApplied", 284527, 284567, 284558, 284611, 284645, 284814, 284881) -- Diamond, Sapphire, Amethyst, Ruby, Topaz, Emerald, Opal
	self:Log("SPELL_AURA_REMOVED", "JewelRemoved", 284527, 284567, 284558, 284611, 284645, 284814, 284881)
	self:Log("SPELL_AURA_APPLIED", "CritStacks", 284664) -- Incandescence
	self:Log("SPELL_AURA_APPLIED_DOSE", "CritStacks", 284664)
	self:Log("SPELL_AURA_REMOVED_DOSE", "CritStacks", 284664)
	self:Log("SPELL_AURA_REMOVED", "CritStacksRemoved", 284664)
	self:Log("SPELL_AURA_APPLIED", "CritBuffApplied", 284798) -- Grossly Incandescent
	self:Log("SPELL_AURA_REMOVED", "CritBuffRemoved", 284798)

	-- Stage 2
	self:Log("SPELL_CAST_START", "HoardPower", 287070)
	--self:Log("SPELL_CAST_SUCCESS", "HoardPowerSuccess", 287070)
	self:Log("SPELL_AURA_APPLIED", "LiquidGoldApplied", 287072)
	self:Log("SPELL_AURA_REMOVED", "LiquidGoldRemoved", 287072)
	self:Log("SPELL_CAST_START", "SpiritsofGold", 285995)
	self:Log("SPELL_CAST_SUCCESS", "ChannelGold", 286026)
	self:Log("SPELL_AURA_APPLIED", "CoinShowerApplied", 285014)
	self:Log("SPELL_AURA_REMOVED", "CoinShowerRemoved", 285014)
	self:Log("SPELL_CAST_START", "WailofGreed", 284941)
	self:Log("SPELL_CAST_SUCCESS", "CoinSweep", 287037)
	self:Log("SPELL_CAST_START", "SurgingGold", 289155)
	self:Log("SPELL_CAST_SUCCESS", "SurgingGoldSuccess", 289155)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 285479, 284424, 287074) -- Flame Jet, Scorching Ground, Molten Gold
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 285479, 284424, 287074)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 285479, 284424, 287074)
end

function mod:OnEngage()
	stage = 1
	wailofGreedCount = 1
	spiritsofGoldCount = 1
	handRoomCount = 1
	bulwarkRoomCount = 1
	bulwarkCrushCount = 1
	hexCounter = 0
	wipe(jewelTracker)
	wipe(topazStackTracker)
	wipe(critBuffTracker)
	gemInfoBoxOpen = nil
	if self:Mythic() then
		self:Bar(289383, 30, self:SpellName(L.swap), 289383) -- Chaotic Displacement
	end
	if self:GetOption("custom_on_hand_timers") then
		self:Bar(283507, 5) -- Volatile Charge
		self:Bar(283606, 7, L.hand_cast:format(self:SpellName(283606))) -- Crush
	end
	if self:GetOption("custom_on_bulwark_timers") then
		self:Bar(283606, 6, L.bulwark_cast:format(self:SpellName(283606))) -- Crush
		self:Bar(282939, 16.5) -- Flames of Punishment
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IsHandOnPlatform()
	local unit = self:GetUnitIdByGUID(145273)
	if unit then
		return IsItemInRange(116139, unit) -- 50yd
	end
end

function mod:IsBulwarkOnPlatform()
	local unit = self:GetUnitIdByGUID(145274)
	if unit then
		return IsItemInRange(116139, unit) -- 50yd
	end
end

do
	local normalAnchor, emphasizeAnchor, colors = BigWigsAnchor, BigWigsEmphasizeAnchor, nil

	local bulwarkAbilities = {
		[282939] = true, -- Flames of Punishment
	}

	local handAbilities = {
		[283507] = true, -- Volatile Charge
	}

	local handPattern = L.hand_cast:gsub("%%s", ".+")
	local bulwarkPattern = L.bulwark_cast:gsub("%%s", ".+")

	local function colorBar(self, bar)
		colors = colors or BigWigs:GetPlugin("Colors")
		local key = bar:Get("bigwigs:option")
		bar:SetTextColor(colors:GetColor("barText", self, key))
		bar:SetShadowColor(colors:GetColor("barTextShadow", self, key))

		if bar:Get("bigwigs:emphasized") then
			bar:SetColor(colors:GetColor("barEmphasized", self, key))
		else
			bar:SetColor(colors:GetColor("barColor", self, key))
		end
	end

	local function fadeOutBar(self, bar)
		colors = colors or BigWigs:GetPlugin("Colors")
		local key = bar:Get("bigwigs:option")
		local r, g, b = colors:GetColor("barText", self, key)
		bar:SetTextColor(r, g, b, 0.33)
		r, g, b = colors:GetColor("barTextShadow", self, key)
		bar:SetShadowColor(r, g, b, 0.33)

		if bar:Get("bigwigs:emphasized") then
			r, g, b = colors:GetColor("barEmphasized", self, key)
			bar:SetColor(r, g, b, 0.5)
		else
			r, g, b = colors:GetColor("barColor", self, key)
			bar:SetColor(r, g, b, 0.5)
		end
	end

	local function handleBarColor(self, bar)
		if bulwarkAbilities[bar:Get("bigwigs:option")] or bar:GetLabel():match(bulwarkPattern) then
			if self:IsBulwarkOnPlatform() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		elseif handAbilities[bar:Get("bigwigs:option")] or bar:GetLabel():match(handPattern) then
			if self:IsHandOnPlatform() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:CheckBossPlatforms()
		if not self:GetOption("custom_on_fade_out_bars") then return end
		if not normalAnchor then return end
		for k in next, normalAnchor.bars do
			if k:Get("bigwigs:module") == self and k:Get("bigwigs:option") then
				handleBarColor(self, k)
			end
		end
		for k in next, emphasizeAnchor.bars do
			if k:Get("bigwigs:module") == self and k:Get("bigwigs:option") then
				handleBarColor(self, k)
			end
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if not self:GetOption("custom_on_fade_out_bars") then return end
		if bulwarkAbilities[key] or text:match(bulwarkPattern) then
			if not self:IsBulwarkOnPlatform() then
				fadeOutBar(self, bar)
			end
		elseif handAbilities[key] or text:match(handPattern) then
			if not self:IsHandOnPlatform() then
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:BarEmphasized(_, _, bar)
		if not self:GetOption("custom_on_fade_out_bars") then return end
		if bar:Get("bigwigs:module") == self and bar:Get("bigwigs:option") then
			handleBarColor(self, bar)
		end
	end
end

function mod:UpdateGemRoomInfoBox()
	if handRoomCount ~= 7 and bulwarkRoomCount ~= 7 then
		self:CloseInfo(-19494)
		gemInfoBoxOpen = nil
		return
	end

	local noDebuffList = {}

	local _, _, _, myMapId = UnitPosition("player")
	for unit in self:IterateGroup() do
		local name = self:UnitName(unit)
		if name and not UnitIsDead(unit) and not jewelTracker[name] then
			local _, _, _, tarMapId = UnitPosition(unit)
			if tarMapId == myMapId then
				noDebuffList[#noDebuffList+1] = self:ColorName(name)
			end
		end
	end

	if #noDebuffList > 0 then
		self:OpenInfo(-19494, L.no_jewel)
		gemInfoBoxOpen = true
		for i, name in ipairs(noDebuffList) do
			if i > 10 then
				break
			end
			self:SetInfo(-19494, i, name)
		end
	else
		self:CloseInfo(-19494)
		gemInfoBoxOpen = nil
	end
end

do
	local sort, sortFunc = table.sort, function(a, b)
		return a.stacks > b.stacks
	end

	local scheduled = nil

	function mod:UpdateTopazInfoBox()
		if gemInfoBoxOpen then return end

		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end

		local lines = 0

		self:OpenInfo(284645, self:SpellName(284664)) -- Incandescence

		for name, expires in pairs(critBuffTracker) do
			lines = lines + 1
			local timeLeft = math.max(expires - GetTime(), 0)
			local timeLeftPercentage = timeLeft / 20
			self:SetInfo(284645, (lines*2) - 1, self:ColorName(name))
			self:SetInfo(284645, (lines*2), CL.seconds:format(timeLeft))
			self:SetInfoBar(284645, (lines*2), timeLeftPercentage, .46, 1, 0, .67)
			if not scheduled then
				scheduled = self:ScheduleTimer("UpdateTopazInfoBox", 0.1)
			end
		end

		local stackTable = {}
		for name, stacks in pairs(topazStackTracker) do
			stackTable[#stackTable+1] = {name = name, stacks = stacks}
		end
		sort(stackTable, sortFunc)
		for _, tbl in pairs(stackTable) do
			lines = lines + 1
			if lines > 5 then
				break
			end
			self:SetInfo(284645, (lines*2) - 1, self:ColorName(tbl.name))
			self:SetInfo(284645, (lines*2), tbl.stacks)
			self:SetInfoBar(284645, (lines*2), tbl.stacks/100, .9, .6, 0, .67)
		end

		if lines == 0 then
			self:CloseInfo(284645, self:SpellName(284645))
		end
	end
end

function mod:Crush(args)
	if self:MobId(args.sourceGUID) == 145273 and self:GetOption("custom_on_hand_timers") then -- The Hand of In'zashi
		local text = L.hand_cast:format(args.spellName)
		if self:IsHandOnPlatform() then
			self:Message2(283606, "yellow", text)
			self:PlaySound(283606, "alert")
		end
		self:Bar(283606, 15.75, text)
	elseif self:GetOption("custom_on_bulwark_timers") then  -- Yalat's Bulwark
		local text = L.bulwark_cast:format(args.spellName)
		if self:IsBulwarkOnPlatform() then
			self:Message2(283606, "yellow", text)
			self:PlaySound(283606, "alert")
		end
		bulwarkCrushCount = bulwarkCrushCount + 1
		self:Bar(283606, bulwarkCrushCount == 2 and 21.8 or 24.3, text)
	end
end

function mod:ConsumingFlame(args)
	if self:MobId(args.sourceGUID) == 145273 then
		handRoomCount = handRoomCount + 1

		if handRoomCount > 6 then
			self:UpdateGemRoomInfoBox()
		end

		if self:GetOption("custom_on_hand_timers") then
			if self:IsHandOnPlatform() then
				self:Message2(args.spellId, "cyan", L.hand_cast:format(L.room:format(handRoomCount)))
				self:PlaySound(args.spellId, "long")
			end
			self:Bar(283507, 13.3) -- Volatile Charge
			self:Bar(283606, 13.5, L.hand_cast:format(self:SpellName(283606))) -- Crush
		end
	else
		bulwarkRoomCount = bulwarkRoomCount + 1
		bulwarkCrushCount = 1

		if bulwarkRoomCount > 6 then
			self:UpdateGemRoomInfoBox()
		end

		if self:GetOption("custom_on_bulwark_timers") then
			if self:IsBulwarkOnPlatform() then
				self:Message2(args.spellId, "cyan", L.bulwark_cast:format(L.room:format(bulwarkRoomCount)))
				self:PlaySound(args.spellId, "long")
			end
			self:Bar(283606, 13.5, L.bulwark_cast:format(self:SpellName(283606))) -- Crush
			self:Bar(282939, 23.3) -- Flames of Punishment
		end
	end
end

do
	local prev = 0
	function mod:ChaoticDisplacement(args)
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, "blue", args.destName, L.swap, args.spellId)
			self:CastBar(args.spellId, 6, CL.you:format(self:SpellName(L.swap)))
			self:PlaySound(args.spellId, "info")
		end
		local t = args.time
		if t-prev > 2 and stage == 1 then
			self:Bar(args.spellId, 30, L.swap, args.spellId)
		end
	end
end

function mod:ChaoticDisplacementRemoved(args)
	if self:GetOption("custom_on_fade_out_bars") then
		self:CheckBossPlatforms()
		self:ScheduleTimer("CheckBossPlatforms", 1) -- XXX figure out what's reasonable for a recheck
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:VolatileChargeApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(283507, "warning")
			self:Say(283507)
			self:SayCountdown(283507, 8)
		end
		if #playerList == 1 and self:GetOption("custom_on_hand_timers") then
			self:Bar(283507, 12.1)
		end
		if (self:GetOption("custom_on_hand_timers") and self:IsHandOnPlatform()) or self:Me(args.destGUID) then
			self:TargetsMessage(283507, "yellow", playerList)
		end
		self:ScheduleTimer(wipe, 0.5, playerList)
	end

	function mod:VolatileChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(283507)
		end
	end
end

function mod:FlamesofPunishment(args)
	if self:GetOption("custom_on_bulwark_timers") then
		if self:IsBulwarkOnPlatform() then
			self:Message2(282939, "red")
			self:PlaySound(282939, "alarm")
		end
		self:CastBar(282939, 12)
		self:Bar(282939, 24.2)
	end
end

function mod:PulsequickeningToxin(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "orange", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:QuickenedPulseApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, args.amount, "green")
		self:PlaySound(args.spellId, "info")
	end
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:HexOfLethargyApplied(args)
		hexCounter = hexCounter + 1
		if hexCounter == 5 then hexCounter = 1 end
		local playerListCount = #playerList+1
		playerList[playerListCount] = args.destName
		playerIcons[playerListCount] = hexCounter
		if self:Dispeller("magic") then
			self:PlaySound(args.spellId, "alarm", nil, playerList)
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(hexOfLethargyMarker) then
			SetRaidTarget(args.destName, hexCounter)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 2, nil, nil, nil, playerIcons)
	end

	function mod:HexOfLethargyRemoved(args)
		if self:Me(args.destGUID) then
			self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
		end
		if self:GetOption(hexOfLethargyMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:JewelApplied(args)
	jewelTracker[self:UnitName(args.destName)] = args.spellId
	if self:Me(args.destGUID) then
		self:TargetMessage(-19494, "blue", args.destName, args.spellName, args.spellId)
		self:PlaySound(-19494, "long")
	end
	self:UpdateGemRoomInfoBox()
end

function mod:JewelRemoved(args)
	local name = self:UnitName(args.destName)
	if jewelTracker[name] == args.spellId then
		jewelTracker[name] = nil
	end
	self:UpdateGemRoomInfoBox()
end

function mod:CritStacks(args)
	topazStackTracker[args.destName] = args.amount or 1
	self:UpdateTopazInfoBox()
end

function mod:CritStacksRemoved(args)
	topazStackTracker[args.destName] = nil
	self:UpdateTopazInfoBox()
end

function mod:CritBuffApplied(args)
	local _, _, _, expires = self:UnitDebuff(args.destName, args.spellId)
	critBuffTracker[args.destName] = expires

	self:TargetMessage(284645, "green", args.destName, args.spellName, args.spellId)
	if self:Me(args.destGUID) then
		self:Say(284645, args.spellId)
	end
	self:UpdateTopazInfoBox()
end

function mod:CritBuffRemoved(args)
	critBuffTracker[args.destName] = nil
	self:UpdateTopazInfoBox()
end

function mod:HoardPower(args)
	--self:Message2(args.spellId, "red")
	--self:PlaySound(args.spellId, "long")
	-- XXX TEMP HERE - NO SUCCESS IN LOG?
	stage = 2
	self:Message2(args.spellId, "cyan", CL.stage:format(2), false)
	self:PlaySound(args.spellId, "info")
	self:StopBar(L.bulwark_cast:format(self:SpellName(283606))) -- Hand: Crush
	self:StopBar(L.hand_cast:format(self:SpellName(283606))) -- Bulwark: Crush
	self:StopBar(283507) -- Volatile Charge
	self:StopBar(282939) -- Flames of Punishment
	self:StopBar(L.swap) -- Chaotic Displacement

	self:CDBar(287072, 14.5) -- Liquid Gold
	self:CDBar(287037, 16.3) -- Coin Sweep
	self:CDBar(285014, 16.7) -- Coin Shower
	self:CDBar(285995, 28, CL.count:format(self:SpellName(285995), spiritsofGoldCount)) -- Spirits of Gold (x)
	self:Bar(289155, 46.2) -- Surging Gold
	self:CDBar(284941, 61, CL.count:format(self:SpellName(284941), wailofGreedCount)) -- Wail of Greed (x)
end

--function mod:HoardPowerSuccess(args)
--	self:Message2(args.spellId, "cyan", CL.stage:format(2), false)
--	self:PlaySound(args.spellId, "info")
--	self:StopBar(L.bulwark_cast:format(self:SpellName(283606))) -- Hand: Crush
--	self:StopBar(L.hand_cast:format(self:SpellName(283606))) -- Bulwark: Crush
--	self:StopBar(283507) -- Volatile Charge
--	self:StopBar(282939) -- Flames of Punishment
--end

do
	local playerList = mod:NewTargetList()
	function mod:LiquidGoldApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:CDBar(args.spellId, 15)
		end
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 12)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:LiquidGoldRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:SpiritsofGold(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, spiritsofGoldCount))
	self:PlaySound(args.spellId, "long")
	spiritsofGoldCount = spiritsofGoldCount + 1
	self:CDBar(args.spellId, 66, CL.count:format(args.spellName, spiritsofGoldCount))
end

do
	local prev = 0
	function mod:ChannelGold(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:Message2(args.spellId, "orange")
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:CoinShowerApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 10, args.destName)
	self:CDBar(args.spellId, 30.5)
	if self:Me(args.destGUID) then
		self:Yell(args.spellId)
		self:YellCountdown(args.spellId, 10)
	end
end

function mod:CoinShowerRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:StopBar(args.spellId, args.destName)
end

function mod:WailofGreed(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, wailofGreedCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 12, CL.count:format(args.spellName, wailofGreedCount)) -- 2s cast, 10s channel
	wailofGreedCount = wailofGreedCount + 1
	self:CDBar(args.spellId, self:Mythic() and 62 or 72, CL.count:format(args.spellName, wailofGreedCount))
	self:CDBar(287037, 12.7) -- Coin Sweep
end

function mod:CoinSweep(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 10.9)
end

function mod:SurgingGold(args)
	self:Message2(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	self:CastBar(args.spellId, 2.5)
	self:Bar(args.spellId, 42.5)
end

function mod:SurgingGoldSuccess(args)
	self:Bar(args.spellId, 30, CL.onboss:format(args.spellName))
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
