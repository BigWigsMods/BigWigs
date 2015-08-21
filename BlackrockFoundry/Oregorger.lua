
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Oregorger", 988, 1202)
if not mod then return end
mod:RegisterEnableMob(77182)
mod.engageId = 1696
mod.respawnTime = 14.5

--------------------------------------------------------------------------------
-- Locals
--

local barrageCount = 1
local frenzyCount = 1
local torrentCount = 1
local rollCount = 1
local hasGoneBerserk = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.roll_message = "Roll %d - %d ore to go!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		156240, -- Acid Torrent
		{173471, "TANK"}, -- Acid Maw
		{156203, "SAY", "FLASH"}, -- Retched Blackrock
		{156390, "FLASH"}, -- Explosive Shard
		156877, -- Blackrock Barrage
		155898, -- Rolling Fury
		"stages",
		"berserk",
	}, {
		[156240] = CL.phase:format(1),
		[155898] = CL.phase:format(2),
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcidMaw", 173471)
	self:Log("SPELL_CAST_START", "AcidTorrent", 156240)
	self:Log("SPELL_CAST_START", "RetchedBlackrock", 156179)
	self:Log("SPELL_AURA_APPLIED", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_PERIODIC_DAMAGE", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_PERIODIC_MISSED", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveShard", 156390)
	self:Log("SPELL_CAST_SUCCESS", "BlackrockSpines", 156834)
	self:Log("SPELL_CAST_START", "BlackrockBarrage", 156877, 173459) -- Heroic & Mythic (1.5s), Normal & LFR (2s)
	self:Log("SPELL_CAST_START", "StartBerserk", 159958) -- Earthshaking Stomp
	-- Phase 2
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_REMOVED", "HungerDriveRemoved", 155819)
	self:Log("SPELL_AURA_REMOVED", "RollingFuryRemoved", 155898)
	self:Log("SPELL_AURA_APPLIED", "RollingFuryApplied", 155898)
end

function mod:OnEngage()
	frenzyCount = 1
	torrentCount = 1
	hasGoneBerserk = nil
	self:CDBar(156203, 7) -- Retched Blackrock
	self:CDBar(156390, 9) -- Explosive Shard
	self:CDBar(156240, 10.7, CL.count:format(self:SpellName(156240), torrentCount)) -- Acid Torrent
	self:CDBar(156877, 14) -- Blackrock Barrage
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(unit)
	local power = UnitPower(unit)
	if power < 21 then
		if frenzyCount > 2 then
			self:Message("berserk", "Important", "Info", CL.soon:format(self:SpellName(26662)), false) -- Berserk soon!
		else
			self:Message("stages", "Neutral", "Info", CL.soon:format(self:SpellName(-9968)), false) -- Feeding Frenzy soon!
		end
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", unit)
	end
end

function mod:AcidTorrent(args)
	self:Message(args.spellId, "Important", "Warning", CL.count:format(args.spellName, torrentCount))
	torrentCount = torrentCount + 1
	self:CDBar(args.spellId, 12.5, CL.count:format(args.spellName, torrentCount)) -- 12.6-16
end

function mod:AcidMaw(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount > 2 and "Warning")
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Say(156203)
			self:Flash(156203)
		elseif self:Range(name) < 9 then
			self:RangeMessage(156203)
			self:Flash(156203)
			return
		end
		self:TargetMessage(156203, name, "Attention", "Alarm")
	end
	function mod:RetchedBlackrock(args)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
		self:CDBar(156203, 15.8) -- 15.8-23.7
	end
end

do
	local prev = 0
	function mod:RetchedBlackrockDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:ExplosiveShard(args)
	if self:Damager() == "MELEE" then -- ranged don't need to worry about this
		self:Message(args.spellId, "Urgent", "Alarm")
		self:Flash(args.spellId)
		self:Bar(args.spellId, 3.5, 84474, "spell_shadow_mindbomb") -- "Explosion" with a bomb icon
	end
	if self:Tank() then
		self:Message(args.spellId, "Urgent")
	end
end

function mod:BlackrockSpines(args)
	barrageCount = 1
	self:CDBar(156877, 20.7) -- Blackrock Barrage, 20.7-23.3
end

function mod:BlackrockBarrage(args)
	self:Message(156877, "Urgent", not self:Healer() and "Alert", CL.count:format(args.spellName, barrageCount))
	barrageCount = barrageCount + 1
end

-- Phase 2

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 165127 then -- Hunger Drive, entering phase 2
		self:StopBar(CL.count:format(self:SpellName(156240), torrentCount)) -- Acid Torrent
		self:StopBar(156203) -- Retched Blackrock
		self:StopBar(156390) -- Explosive Shard
		self:StopBar(156877) -- Blackrock Barrage

		rollCount = 1
		self:Message("stages", "Positive", "Long", self:SpellName(-9968), false) -- Feeding Frenzy
		self:CDBar(155898, 3.5, CL.count:format(self:SpellName(155898), rollCount)) -- Rolling Fury
	end
end

function mod:HungerDriveRemoved(args) -- Entering phase 1
	frenzyCount = frenzyCount + 1
	torrentCount = 1

	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
	self:CDBar(156203, 4.9) -- Retched Blackrock
	self:CDBar(156390, 7) -- Explosive Shard
	self:CDBar(156240, 12, CL.count:format(self:SpellName(156240), torrentCount)) -- Acid Torrent
	self:CDBar(156877, 14) -- Blackrock Barrage
end

function mod:RollingFuryRemoved(args)
	-- rolls then pauses for ~4s
	local remaining = 100 - UnitPower("boss1")
	if remaining > 0 then
		self:Message(args.spellId, "Attention", nil, L.roll_message:format(rollCount, remaining))
		rollCount = rollCount + 1
		self:CDBar(args.spellId, 3.5, CL.count:format(args.spellName, rollCount))
	else
		self:StopBar(CL.count:format(args.spellName, rollCount))
		self:Message("stages", "Positive", "Long", CL.over:format(self:SpellName(-9968)), false) -- Feeding Frenzy over!
	end
end

function mod:RollingFuryApplied(args)
	self:StopBar(CL.count:format(args.spellName, rollCount))
end

function mod:StartBerserk()
	if not hasGoneBerserk then
		hasGoneBerserk = true
		self:Message("berserk", "Important", "Alarm", CL.custom_end:format(self.displayName, self:SpellName(26662)), 26662) -- Berserk
	end
end

