
--------------------------------------------------------------------------------
-- TODO List:
-- - Respawn timer
-- - Mod is untested and PTR logs were old, probably needs a lot of updates

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Magistrix Elisande", 1088, 1743)
if not mod then return end
mod:RegisterEnableMob(106643)
mod.engageId = 1872
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--
local phase = 1
local fastElementalCounter = 0
local slowElementalCounter = 0
local slowElementalTimers = {49,52,60} -- No idea how it continues
local fastElementalTimers = {88,95,20} -- No idea how it continues
local ringTimers = {40,10,63,10} -- No idea how it continues
local ringCounter = 0
local lookingForMsg = false
local orbMsg = ''
local orbCounter = 0
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
		211616, -- Summon Time Elemental - Fast
		211614, -- Summon Time Elemental - Slow
		"stages",
		"berserk",

		--[[ Recursive Elemental ]]--
		221863, -- Shield
		221864, -- Blast
		209165, -- Slow Time

		--[[ Expedient Elemental ]]--
		209568, -- Exothermic Release
		209166, -- Fast Time

		--[[ Time Layer 1 ]]--
		208807, -- Arcanetic Ring
		209170, -- Spanning Singularity
		{209615, "TANK"}, -- Ablation

		--[[ Time Layer 2 ]]--
		{209244, "SAY", "FLASH"}, -- Delphuric Beam
		210022, -- Epocheric Orb
		209973, -- Ablating Explosion

		--[[ Time Layer 3 ]]--
		{211261, "SAY", "FLASH"}, -- Permeliative Torment
		{209597, "SAY", "FLASH"}, -- Conflexive Burst
		209971, -- Ablative Pulse
		{211887, "TANK"}, -- Ablated
	},{
		[208887] = "general",
		[221863] = -13226, -- Recursive Elemental
		[209568] = -13229, -- Expedient Elemental
		[208807] = -13222, -- Time Layer 1
		[209244] = -13235, -- Time Layer 2
		[211261] = -13232, -- Time Layer 3
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "TimeStop", 208944) -- Phase triggering
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	--[[ Recursive Elemental ]]--
	self:Log("SPELL_AURA_APPLIED", "ShieldApplied", 221863)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 221863)
	self:Log("SPELL_CAST_START", "Blast", 221864)
	self:Log("SPELL_AURA_APPLIED", "SlowTime", 209165)

	--[[ Expedient Elemental ]]--
	self:Log("SPELL_CAST_START", "ExothermicRelease", 209568)
	self:Log("SPELL_AURA_APPLIED", "FastTime", 209166)

	--[[ Time Layer 1 ]]--
	self:Log("SPELL_CAST_START", "ArcaneticRing", 208807)
	self:Log("SPELL_CAST_SUCCESS", "SpanningSingularity", 209170, 233011, 233012)
	--self:Log("SPELL_AURA_APPLIED", "SingularityDamage", 209433)
	--self:Log("SPELL_PERIODIC_DAMAGE", "SingularityDamage", 209433)
	--self:Log("SPELL_PERIODIC_MISSED", "SingularityDamage", 209433)
	self:Log("SPELL_AURA_APPLIED", "Ablation", 209615)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablation", 209615)

	--[[ Time Layer 2 ]]--
	self:Log("SPELL_AURA_APPLIED", "DelphuricBeam", 209244)
	self:Log("SPELL_CAST_START", "EpochericOrb", 210022)
	self:Log("SPELL_AURA_APPLIED", "AblatingExplosion", 209973)

	--[[ Time Layer 3 ]]--
	self:Log("SPELL_AURA_APPLIED", "PermeliativeTorment", 211261)
	self:Log("SPELL_CAST_START", "ConflexiveBurst", 209597)
	self:Log("SPELL_AURA_APPLIED", "ConflexiveBurstApplied", 209598)
	self:Log("SPELL_CAST_START", "AblativePulse", 209971)
	self:Log("SPELL_AURA_APPLIED", "Ablated", 211887)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablated", 211887)
end

function mod:OnEngage()
	phase = 1
	fastElementalCounter = 0
	slowElementalCounter = 0
	lookingForMsg = false
	ringCounter = 0
	orbCounter = 0
	self:Bar(211614, 5) -- Summon Time Elemental - Slow
	self:Bar(211616, 8) -- Summon Time Elemental - Fast
	self:Bar(208807, 36.3) -- Arcanetic Rings
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 211614 then -- Slow
		self:Message(spellId, "Neutral", "Info")
		slowElementalCounter = slowElementalCounter + 1
		self:Bar(spellId, slowElementalTimers[slowElementalCounter] or 60) -- Assuming timers cap at 60, which is probably wrong
	elseif spellId == 211616 then -- Fast
		self:Message(spellId, "Neutral", "Info")
		fastElementalCounter = fastElementalCounter + 1
		self:Bar(spellId, fastElementalTimers[fastElementalCounter] or 20) -- Assuming timers cap at 20, which is probably wrong
	end
end

function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find("228877") then -- Arcanetic Rings
		ringCounter = ringCounter + 1
		self:Bar(208807, ringTimers[ringCounter] or (ringCounter%2==0 and 10 or 40))
		self:Message(208807, "Attention", "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg, npcname)
	if lookingForMsg then
		orbMsg = msg
		lookingForMsg = false
	end
	if orbMsg == msg then
		orbCounter = orbCounter + 1
		self:Bar(210022, orbCounter%2==1 and 76 or 37)
		self:Message(210022, "Urgent", "Alert", CL.incoming:format(self:SpellName(210022)))
	end
end

function mod:TimeStop(args)
	phase = phase + 1
	self:Message("stages", "Neutral", "Info", CL.stage:format(phase), false)
	-- Reset elemental counters
	fastElementalCounter = 0
	slowElementalCounter = 0
	ringCounter = 0
	orbCounter = 0
	-- Stop old bars

	-- Start new bars
	self:Bar(211614, 15) -- Summon Time Elemental - Slow
	self:Bar(211616, 18) -- Summon Time Elemental - Fast
	self:Bar(210022, 28)
end

--[[ Recursive Elemental ]]--
function mod:ShieldApplied(args)
	self:Message(args.spellId, "Attention", "Info", CL.on:format(args.spellName, args.destName))
end

function mod:ShieldRemoved(args)
	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
end

function mod:Blast(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Important", "Alert")
	end
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
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:FastTime(args)
	if self:Me(args.destGUID)then
		self:Message(args.spellId, "Positive", "Long", CL.you:format(args.spellName))
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

--[[ Time Layer 1 ]]--
function mod:ArcaneticRing(args)
	--self:Message(args.spellId, "Urgent", "Alert")
	--self:CDBar(args.spellId, 30)
end

function mod:SpanningSingularity(args)
	self:Message(209170, "Attention", "Info")
end

function mod:Ablation(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 3 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 3 and "Warning")
	end
end

--[[
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
]]

--[[ Time Layer 2 ]]--
do
	local playerList = mod:NewTargetList()
	function mod:DelphuricBeam(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end
end

function mod:EpochericOrb(args)
	lookingForMsg = true
	--self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(args.spellName))
end

function mod:AblatingExplosion(args)
	self:Bar(args.spellId, 20.7)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Long")
	self:TargetBar(args.spellId, 8, args.destName)
	self:ScheduleTimer("Bar", 8, args.spellId, 7)
end

--[[ Time Layer 3 ]]--
do
	local playerList = mod:NewTargetList()
	function mod:PermeliativeTorment(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end
end


function mod:ConflexiveBurst(args)
	--self:Bar(args.spellId, ???)
end

do
	local playerList = mod:NewTargetList()
	function mod:ConflexiveBurstApplied(args)
		if self:Me(args.destGUID) then
			self:Flash(209597)
			self:Say(209597)
			-- Need to constantly update because of fast/slow time
			--local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			--local t = expires - GetTime()
			--self:TargetBar(209597, t, args.destName)
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
