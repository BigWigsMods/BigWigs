
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Oregorger", 988, 1202)
if not mod then return end
mod:RegisterEnableMob(77182)
mod.engageId = 1696

--------------------------------------------------------------------------------
-- Locals
--

local barrageCount = 1
local frenzyCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.berserk_trigger = "Oregorger has gone insane from hunger!"

	L.shard_explosion = "Explosive Shard Explosion"
	L.shard_explosion_desc = "Separate emphasized bar for the explosion."
	L.shard_explosion_icon = "6bf_explosive_shard"

	L.hunger_drive_power = "%dx %s - %d ore to go!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{156240, "TANK_HEALER"}, {173471, "TANK"}, {156203, "SAY", "FLASH"}, {156390, "FLASH"}, {"shard_explosion", "EMPHASIZE"}, 156877, 155819, 155898,
		"stages", "berserk", "bosskill"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcidMaw", 173471)
	self:Log("SPELL_CAST_START", "AcidTorrent", 156240)
	self:Log("SPELL_CAST_START", "RetchedBlackrock", 156179)
	self:Log("SPELL_PERIODIC_DAMAGE", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_PERIODIC_MISSED", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveShard", 156390)
	self:Log("SPELL_AURA_APPLIED", "BlackrockSpines", 156834)
	self:Log("SPELL_CAST_START", "BlackrockBarrage", 156877)
	self:Emote("Insane", L.berserk_trigger)
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", "EarthshakingStomp", "boss1") -- backup for the yell (1s after the emote)
	-- Phase 2
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "FeedingFrenzy", "boss1")
	self:Log("SPELL_AURA_APPLIED_DOSE", "HungerDriveApplied", 155819)
	self:Log("SPELL_AURA_REMOVED", "HungerDriveRemoved", 155819)
	self:Log("SPELL_AURA_REMOVED", "RollingFuryRemoved", 155898)
	self:Log("SPELL_AURA_APPLIED", "RollingFuryApplied", 155898)
end

function mod:OnEngage()
	frenzyCount = 1
	self:CDBar(156203, 6) -- Retched Blackrock
	self:CDBar(156390, 9) -- Explosive Shard
	self:CDBar(156240, 12) -- Acid Torrent
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(unit)
	local power = UnitPower(unit)
	if power < 21 then
		if frenzyCount > 1 then
			self:Message("berserk", "Important", nil, CL.soon:format(self:SpellName(26662)), false) -- Berserk
		else
			self:Message("stages", "Neutral", nil, CL.soon:format(self:SpellName(-9968)), false) -- Feeding Frenzy
		end
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", unit)
	end
end

function mod:AcidTorrent(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CDBar(args.spellId, 12) -- 11-14
end

function mod:AcidMaw(args)
	if args.amount % 2 == 0 then -- 6s cd, 8s duration
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Say(156203)
			self:Flash(156203)
		elseif self:Range(name) < 10 then
			self:RangeMessage(156203)
			self:Flash(156203)
			return
		end
		self:TargetMessage(156203, name, "Attention", "Alarm")
	end
	function mod:RetchedBlackrock(args)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
		self:CDBar(156203, 15) -- 15-19
	end
end

do
	local prev = 0
	function mod:RetchedBlackrockDamage(args)
		local t = GetTime()
		if self:Me(args.spellId) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

function mod:ExplosiveShard(args)
	if self:Tank() or self:Damager() == "MELEE" then -- ranged don't need to worry about this
		self:Message(args.spellId, "Urgent", "Alarm")
		self:CDBar(args.spellId, 12)
		self:Flash(args.spellId)
		self:Bar("shard_explosion", 3.4, 84474, "spell_shadow_mindbomb") -- "Explosion" with a bomb icon
	end
end

function mod:BlackrockSpines(args)
	barrageCount = 1
end

function mod:BlackrockBarrage(args)
	self:Message(args.spellId, "Urgent", not self:Healer() and "Alert", CL.count:format(args.spellName, barrageCount))
	barrageCount = barrageCount + 1
end

-- Phase 2

function mod:FeedingFrenzy(unit, spellName, _, _, spellId)
	if spellId == 165127 then -- Hunger Drive
		self:StopBar(156240) -- Acid Torrent
		self:StopBar(156203) -- Retched Blackrock
		self:StopBar(156390) -- Explosive Shard

		self:Message("stages", "Positive", "Long", self:SpellName(-9968), false) -- Feeding Frenzy
	end
end

function mod:HungerDriveApplied(args)
	if args.amount % 5 == 0 then -- every 15s
		local power = UnitPower("boss1")
		self:Message(args.spellId, "Attention", nil, L.hunger_drive_power:format(args.amount, args.spellName, 100-power))
	end
end

function mod:HungerDriveRemoved(args)
	self:StopBar(155898) -- Rolling Fury
	frenzyCount = frenzyCount + 1

	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
	self:Message("stages", "Positive", "Long", CL.over:format(self:SpellName(-9968)), false) -- Feeding Frenzy
	self:CDBar(156203, 6) -- Retched Blackrock
	self:CDBar(156390, 9) -- Explosive Shard
	self:CDBar(156240, 12) -- Acid Torrent
end

function mod:RollingFuryRemoved(args)
	-- rolls for ~6s then pauses for ~4s. too spammy for a roll message, but maybe show a bar for the pause? 3-5s
	self:CDBar(args.spellId, 4)
end

function mod:RollingFuryApplied(args)
	self:StopBar(args.spellId)
end

function mod:Insane()
	self:Message("berserk", "Important", "Alarm", CL.custom_end:format(self.displayName, self:SpellName(26662)), 26662) -- Berserk
	self:UnregisterUnitEvent("UNIT_SPELLCAST_START", "boss1")
end

function mod:EarthshakingStomp(_, spellName, _, _, spellId)
	if spellId == 159958 then
		self:Insane()
	end
end

