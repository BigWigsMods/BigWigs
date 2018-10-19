if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
-- - Info warnings about player abilities from Jewels

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Treasure Guardian", 2070, 2342)
if not mod then return end
mod:RegisterEnableMob(145273, 145274, 145261, 147564) -- The Hand of In'zashi, Yalat's Bulwark, 2x Treasure Guardian
mod.engageId = 2271
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local wailofGreedCount = 1

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

local timeBombMarker = mod:AddMarkerOption(false, "player", 1, 284470, 1, 2, 3, 4) -- Time Bomb
function mod:GetOptions()
	return {
		-- Stage 1
		283604, -- Crush
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
		287070, -- Draw Power
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
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "Crush", 283604)
	-- The Hand of In'zashi
	self:Log("SPELL_AURA_APPLIED", "VolatileChargeApplied", 283507)
	self:Log("SPELL_AURA_REMOVED", "VolatileChargeRemoved", 283507)
	-- Yalat's Bulwark
	self:Log("SPELL_CAST_START", "FlamesofPunishment", 283507)
	-- Traps
	self:Log("SPELL_CAST_SUCCESS", "PulsequickeningToxin", 284493)
	self:Log("SPELL_AURA_APPLIED", "QuickenedPulseApplied", 284519)
	self:Log("SPELL_AURA_APPLIED", "TimeBombApplied", 284470)
	self:Log("SPELL_AURA_REMOVED", "TimeBombRemoved", 284470)

	-- Stage 2
	self:Log("SPELL_CAST_START", "DrawPower", 287070)
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
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Crush(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:VolatileChargeApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
		end
	end

	function mod:VolatileChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:FlamesofPunishment(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:PulsequickeningToxin(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:QuickenedPulseApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, amount, "green")
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

function mod:DrawPower(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

do
	local playerList = mod:NewTargetList()
	function mod:LiquidGoldApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList)
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
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

function mod:ChannelGold(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CoinShowerApplied(args)
	self:TargetMessage2(args.spellId, "yellow", name)
	self:PlaySound(args.spellId, "alert")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 10, args.destName)
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
	self:Message2(args.spellId, "red", CL.count:format(self:SpellName(args.spellId), wailofGreedCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 12, CL.count:format(self:SpellName(args.spellId), wailofGreedCount)) -- 2s cast, 10s channel
	wailofGreedCount = wailofGreedCount + 1
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
