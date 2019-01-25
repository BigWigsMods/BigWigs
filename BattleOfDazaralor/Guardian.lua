--------------------------------------------------------------------------------
-- TODO:
-- - Info warnings about player abilities from Jewels

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

local wailofGreedCount = 1
local spiritsofGoldCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
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

local timeBombMarker = mod:AddMarkerOption(false, "player", 1, 284470, 1, 2, 3, 4) -- Time Bomb
function mod:GetOptions()
	return {
		"stages",
		286541, -- Consuming Flame
		-- Stage 1
		"custom_on_hand_timers",
		"custom_on_bulwark_timers",
		283606, -- Crush
		-- The Hand of In'zashi
		{283507, "SAY", "SAY_COUNTDOWN"}, -- Volatile Charge
		-- Yalat's Bulwark
		282939, -- Flames of Punishment
		-- Traps
		285479, -- Flame Jet
		284424, -- Scorching Ground
		284493, -- Pulse-quickening Toxin
		284519, -- Quickened Pulse
		284470, -- Time Bomb
		timeBombMarker,
		-- Stage 2
		287070, -- Hoard Power
		{287072, "SAY", "SAY_COUNTDOWN"}, -- Liquid Gold
		287074, -- Molten Gold
		285995, -- Spirits of Gold
		286026, -- Channel Gold
		{285014, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Coin Shower
		284941, -- Wail of Greed
		{287037, "TANK"}, -- Coin Sweep
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")

	-- Stage 1
	self:Log("SPELL_CAST_START", "Crush", 283606)
	-- The Hand of In'zashi
	self:Log("SPELL_AURA_APPLIED", "VolatileChargeApplied", 283507, 287648) -- Normal, Empowered
	self:Log("SPELL_AURA_REMOVED", "VolatileChargeRemoved", 283507, 287648)
	-- Yalat's Bulwark
	self:Log("SPELL_CAST_START", "FlamesofPunishment", 282939, 287659) -- Normal, Empowered
	-- Traps
	self:Log("SPELL_CAST_SUCCESS", "PulsequickeningToxin", 284493)
	self:Log("SPELL_AURA_APPLIED", "QuickenedPulseApplied", 284519)
	self:Log("SPELL_AURA_APPLIED", "TimeBombApplied", 284470)
	self:Log("SPELL_AURA_REMOVED", "TimeBombRemoved", 284470)

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
	self:Log("SPELL_AURA_APPLIED", "CoinSweepApplied", 287037)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 285479, 284424, 287074) -- Flame Jet, Scorching Ground, Molten Gold
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 285479, 284424, 287074)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 285479, 284424, 287074)
end

function mod:OnEngage()
	wailofGreedCount = 1
	spiritsofGoldCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 286541 then -- Consuming Flame
		if self:MobId(UnitGUID(unit)) == 145273 and self:GetOption("custom_on_hand_timers") then
			self:Message2(spellId, "cyan", L.hand_cast:format(self:SpellName(spellId)))
			self:PlaySound(spellId, "long")
			self:Bar(283507, 14.2) -- Volatile Charge
			self:Bar(283606, 14.7, L.hand_cast:format(self:SpellName(283606))) -- Crush
		elseif self:GetOption("custom_on_bulwark_timers") then
			self:Message2(spellId, "cyan", L.bulwark_cast:format(self:SpellName(spellId)))
			self:PlaySound(spellId, "long")
			self:Bar(283606, 14.7, L.bulwark_cast:format(self:SpellName(283606))) -- Crush
			self:Bar(282939, 20.7) -- Flames of Punishment
		end
	end
end

function mod:Crush(args)
	local text = nil
	if self:MobId(args.sourceGUID) == 145273 and self:GetOption("custom_on_hand_timers") then -- The Hand of In'zashi
		text = L.hand_cast:format(args.spellName)
		self:Message2(args.spellId, "yellow", text)
		self:PlaySound(args.spellId, "alert")
		self:Bar(args.spellId, 15.5, text)
	elseif self:GetOption("custom_on_bulwark_timers") then  -- Yalat's Bulwark
		text = L.bulwark_cast:format(args.spellName)
		self:Message2(args.spellId, "yellow", text)
		self:PlaySound(args.spellId, "alert")
		self:Bar(args.spellId, 15.5, text)
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:VolatileChargeApplied(args)
		if self:GetOption("custom_on_hand_timers") or self:Me(args.destGUID) then
			playerList[#playerList+1] = args.destName
			self:TargetsMessage(283507, "yellow", playerList)
		end
		if self:Me(args.destGUID) then
			self:PlaySound(283507, "warning")
			self:Say(283507)
			self:SayCountdown(283507, 8)
		end
		if #playerList == 1 and self:GetOption("custom_on_hand_timers") then
			self:Bar(283507, 12.2)
		end
	end

	function mod:VolatileChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(283507)
		end
	end
end

function mod:FlamesofPunishment(args)
	if self:GetOption("custom_on_bulwark_timers") then
		self:Message2(282939, "red")
		self:PlaySound(282939, "alarm")
		self:CastBar(282939, 12)
		self:Bar(282939, 23.1)
	end
end

function mod:PulsequickeningToxin(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:QuickenedPulseApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, args.amount, "green")
		self:PlaySound(args.spellId, "info")
	end
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(284470, "ME_ONLY")

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message2(284470, "blue", CL.you:format(("|T13700%d:0|t%s"):format(isOnMe, mod:SpellName(284470))))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message2(284470, "orange", CL.other:format(mod:SpellName(284470), msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:TimeBombApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.1)
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(timeBombMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end

	function mod:TimeBombRemoved(args)
		if self:GetOption(timeBombMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:HoardPower(args)
	--self:Message2(args.spellId, "red")
	--self:PlaySound(args.spellId, "long")
	-- XXX TEMP HERE - NO SUCCESS IN LOG?
	self:Message2(args.spellId, "cyan", CL.stage:format(2), false)
	self:PlaySound(args.spellId, "info")
	self:StopBar(L.bulwark_cast:format(self:SpellName(283606))) -- Hand: Crush
	self:StopBar(L.hand_cast:format(self:SpellName(283606))) -- Bulwark: Crush
	self:StopBar(283507) -- Volatile Charge
	self:StopBar(282939) -- Flames of Punishment

	self:CDBar(287072, 14.5) -- Liquid Gold
	self:CDBar(285014, 16.7) -- Coin Shower
	self:CDBar(285995, 28, CL.count:format(self:SpellName(285995), spiritsofGoldCount)) -- Spirits of Gold (x)
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
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if #playerList == 1 then
			self:CDBar(args.spellId, 15)
		end
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 12)
		end
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

function mod:ChannelGold(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CoinShowerApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 10, args.destName)
	self:CDBar(args.spellId, 30.5)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 10)
	end
end

function mod:CoinShowerRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:StopBar(args.spellId, args.destName)
end

function mod:WailofGreed(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, wailofGreedCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 12, CL.count:format(args.spellName, wailofGreedCount)) -- 2s cast, 10s channel
	wailofGreedCount = wailofGreedCount + 1
	self:CDBar(args.spellId, 71, CL.count:format(args.spellName, wailofGreedCount))
end

function mod:CoinSweepApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
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
