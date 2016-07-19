
--------------------------------------------------------------------------------
-- TODO List:
-- - Tuning sounds / message colors
-- - Remove alpha engaged message
-- - Respawn Timer, encounter id
-- - Everything:
--   - fix spell ids
--   - remove unused functions
--   - ...

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Magistrix Elisande", 1088, 1743)
if not mod then return end
mod:RegisterEnableMob(106643, 110965) -- fix me
mod.engageId = 1872
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		208887, -- Summon Time Elementals
		"stages",
		"berserk",

		--[[ Recursive Elemental ]]--
		221863, -- Shield
		209590, -- Compressed Time
		221864, -- Blast
		209165, -- Slow Time

		--[[ Expedient Elemental ]]--
		209568, -- Exothermic Release
		209166, -- Fast Time

		--[[ Time Layer 1 ]]--
		208807, -- Arcanetic Ring
		211259, -- Permeliative Torment

		--[[ Time Layer 2 ]]--
		209244, -- Delphuric Beam
		210022, -- Epocheric Orb
		209973, -- Ablating Explosion

		--[[ Time Layer 3 ]]--
		209168, -- Spanning Singularity
		209597, -- Conflexive Burst
		209971, -- Ablative Pulse
		211887, -- Ablated
	},{
		[208887] = "general",
		[221863] = -13226, -- Recursive Elemental
		[209568] = -13229, -- Expedient Elemental
		[208807] = -13222, -- Time Layer 1
		[209244] = -13235, -- Time Layer 2
		[209168] = -13232, -- Time Layer 3
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:Log("SPELL_CAST_SUCCESS", "SummonTimeElementals", 208887)
	self:Log("SPELL_CAST_SUCCESS", "TimeLayerChange", 209030, 209123, 209136, 208944)

	--[[ Recursive Elemental ]]--
	self:Log("SPELL_AURA_APPLIED", "ShieldApplied", 221863)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 221863)
	self:Log("SPELL_CAST_START", "CompressedTime", 209590)
	self:Log("SPELL_CAST_START", "Blast", 221864)
	self:Log("SPELL_AURA_APPLIED", "SlowTime", 209165)

	--[[ Expedient Elemental ]]--
	self:Log("SPELL_CAST_START", "ExothermicRelease", 209568)
	self:Log("SPELL_AURA_APPLIED", "FastTime", 209166)

	--[[ Time Layer 1 ]]--
	self:Log("SPELL_CAST_START", "ArcaneticRing", 208807, 209330)
	self:Log("SPELL_AURA_APPLIED", "PermeliativeTorment", 211259, 211261)

	--[[ Time Layer 2 ]]--
	self:Log("SPELL_AURA_APPLIED", "DelphuricBeam", 209244, 213716)
	self:Log("SPELL_CAST_START", "EpochericOrb", 210022, 211618, 213739)
	self:Log("SPELL_AURA_APPLIED", "AblatingExplosion", 209973)

	--[[ Time Layer 3 ]]--
	self:Log("SPELL_CAST_START", "SpanningSingularity", 209168)
	self:Log("SPELL_AURA_APPLIED", "SingularityDamage", 209433)
	self:Log("SPELL_PERIODIC_DAMAGE", "SingularityDamage", 209433)
	self:Log("SPELL_PERIODIC_MISSED", "SingularityDamage", 209433)
	self:Log("SPELL_CAST_START", "ConflexiveBurst", 209597)
	self:Log("SPELL_AURA_APPLIED", "ConflexiveBurstApplied", 209598)
	self:Log("SPELL_CAST_START", "AblativePulse", 209971)
	self:Log("SPELL_AURA_APPLIED", "Ablated", 211887)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablated", 211887)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Grand Magistrix Elisande (Alpha) Engaged (Pre Alpha Test Mod)", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:SummonTimeElementals(args)
	self:Message(args.spellId, "Attention", "Info")
end

do
  local prev = 0
  function mod:TimeLayerChange(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message("stages", "Neutral", "Info", mod:SpellName(args.spellId), args.spellId)
		end
  end
end

--[[ Recursive Elemental ]]--
function mod:ShieldApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
end

function mod:ShieldRemoved(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Info", CL.removed:format(args.destName))
end

function mod:CompressedTime(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
end

function mod:Blast(args)
	self:Message(args.spellId, "Important", self:Interrupter(args.sourceGUID) and "Alert")
end

function mod:SlowTime(args)
	if self:Me(args.destGUID)then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Long")
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

--[[ Expedient Elemental ]]--
function mod:ExothermicRelease(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Alert")
end

function mod:FastTime(args)
	if self:Me(args.destGUID)then
		self:TargetMessage(args.spellId, args.destName, "Positive", "Long")
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

--[[ Time Layer 1 ]]--
function mod:ArcaneticRing(args)
	self:Message(208807, "Urgent", "Alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:PermeliativeTorment(args)
		if self:Me(args.destGUID) then
			self:Flash(211259)
			self:Say(211259)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(211259, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 211259, playerList, "Important", "Alarm")
		end
	end
end

--[[ Time Layer 2 ]]--
do
	local playerList = mod:NewTargetList()
	function mod:DelphuricBeam(args)
		if self:Me(args.destGUID) then
			self:Flash(209244)
			self:Say(209244)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(209244, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 209244, playerList, "Important", "Alarm")
		end
	end
end

function mod:EpochericOrb(args)
	self:Message(210022, "Urgent", "Alert", CL.casting:format(args.spellName))
end

function mod:AblatingExplosion(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Long")
end

--[[ Time Layer 3 ]]--
function mod:SpanningSingularity(args)
	self:Message(args.spellId, "Attention", "Info", CL.incoming:format(args.spellName))
end

do
	local prev = 0
	function mod:SingularityDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(209168, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:ConflexiveBurst(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
end

do
	local playerList = mod:NewTargetList()
	function mod:ConflexiveBurstApplied(args)
		if self:Me(args.destGUID) then
			self:Flash(209597)
			self:Say(209597)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(209597, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 209597, playerList, "Important", "Alarm")
		end
	end
end

function mod:AblativePulse(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
end

function mod:Ablated(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning")
end



--
