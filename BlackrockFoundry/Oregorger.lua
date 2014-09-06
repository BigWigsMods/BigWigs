
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Oregorger", 988, 1202)
if not mod then return end
mod:RegisterEnableMob(77182)
--mod.engageId = 1696

--------------------------------------------------------------------------------
-- Locals
--

local feedingFrenzy = EJ_GetSectionInfo(9968)
local barrageCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.hunger_drive_power = "%dx %s - %d ore to go!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{156240, "TANK_HEALER"}, {156203, "SAY", "FLASH"}, 156390, 156877, 155819, 155898,
		"stages", "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "AcidTorrent", 156240)
	self:Log("SPELL_AURA_APPLIED", "AcidTorrentApplied", 156297)
	self:Log("SPELL_CAST_START", "RetchedBlackrock", 156179)
	self:Log("SPELL_PERIODIC_DAMAGE", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_PERIODIC_MISSED", "RetchedBlackrockDamage", 156203)
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveShard", 156390)
	self:Log("SPELL_AURA_APPLIED", "BlackrockSpines", 156834)
	self:Log("SPELL_CAST_START", "BlackrockBarrage", 156877)
	-- Phase 2
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "FeedingFrenzy", "boss1")
	self:Log("SPELL_AURA_APPLIED_DOSE", "HungerDriveApplied", 155819)
	self:Log("SPELL_AURA_REMOVED", "HungerDriveRemoved", 155819)
	self:Log("SPELL_AURA_REMOVED", "RollingFuryRemoved", 155898)
	self:Log("SPELL_AURA_REMOVED", "RollingFuryApplied", 155898)

	self:Death("Win", 77182)
end

function mod:OnEngage()
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
		self:Message("stages", "Neutral", "Info", CL.soon:format(feedingFrenzy), false)
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1")
	end
end

function mod:AcidTorrent(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CDBar(args.spellId, 12) -- 11-14
end

function mod:AcidTorrentApplied(args)
	self:TargetBar(156240, 20, args.destName)
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
		self:TargetMessage(156203, "Attention", "Alarm")
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
	local melee = self:Tank() or self:Damager() == "MELEE"
	self:Message(args.spellId, "Urgent", melee and "Alarm")
	if melee then -- ranged don't really need to worry about this
		self:Bar(args.spellId, 3, 84474, "spell_shadow_mindbomb") -- "Explosion" with a bomb icon
	end
	self:CDBar(args.spellId, 12)
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

		self:Message("stages", "Neutral", "Long", feedingFrenzy, false)
	end
end

function mod:HungerDriveApplied(args)
	if args.amount % 5 == 0 then
		local power = UnitPower("boss1")
		self:Message(args.spellId, "Attention", nil, L.hunger_drive_power:format(args.amount, self:SpellName(155819), 100-power), false)
	end
end

function mod:HungerDriveRemoved(args)
	self:StopBar(CL.incoming:format(self:SpellName(155898))) -- Rolling Fury

	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
	self:Message("stages", "Positive", "Long", CL.over:format(feedingFrenzy), false)
	self:CDBar(156203, 6) -- Retched Blackrock
	self:CDBar(156390, 9) -- Explosive Shard
	self:CDBar(156240, 12) -- Acid Torrent
end

function mod:RollingFuryRemoved(args)
	-- rolls for ~6s then pauses for ~4s. too spammy for a roll message, but maybe show a bar for the pause? 3-5s
	self:CDBar(args.spellId, 4, CL.incoming:format(args.spellName))
end

function mod:RollingFuryApplied(args)
	self:StopBar(CL.incoming:format(args.spellName))
end

