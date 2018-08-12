
--------------------------------------------------------------------------------
-- TODO List:
-- - Arcane Tether warnings for tanks
-- - Mythic mode transform cds

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skorpyron", 1530, 1706)
if not mod then return end
mod:RegisterEnableMob(102263)
mod.engageId = 1849
mod.respawnTime = 40 -- moves into room at 30, ~40 until he's attackable

--------------------------------------------------------------------------------
-- Locals
--

local engageTime = 0
local arcanoslashCount = 1
local shardOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.blue = "Blue"
	L.red = "Red"
	L.green = "Green"
	L.mode = "%s Mode"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		{204275, "TANK"}, -- Arcanoslash
		204316, -- Shockwave
		204448, -- Chitinous Exoskeleton
		204459, -- Exoskeletal Vulnerability
		204372, -- Call of the Scorpid
		204471, -- Focused Blast
		{204284, "EMPHASIZE"}, -- Broken Shard
		--204292, -- Crystalline Fragments
		204744, -- Toxic Chitin
		"berserk",

		--[[ Mythic ]]--
		-13767, -- Chromatic Exoskeleton
	},{
		[204275] = "general",
		[-13767] = "mythic",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Arcanoslash", 204275)
	self:Log("SPELL_CAST_START", "Shockwave", 204316)
	self:Log("SPELL_CAST_SUCCESS", "ShockwaveSuccess", 204316)
	self:Log("SPELL_AURA_APPLIED", "BrokenShard", 204284)
	self:Log("SPELL_AURA_REMOVED", "BrokenShardRemoved", 204284)
	self:Log("SPELL_AURA_APPLIED", "ChitinousExoskeletonApplied", 204448)
	self:Log("SPELL_AURA_REMOVED_DOSE", "ChitinousExoskeletonStacks", 204448)
	self:Log("SPELL_AURA_APPLIED", "ExoskeletalVulnerabilityApplied", 204459)
	self:Log("SPELL_CAST_START", "CallOfTheScorpid", 204372)
	self:Log("SPELL_CAST_START", "FocusedBlast", 204471)
	--self:Log("SPELL_SUMMON", "CrystallineFragments", 204292, 214662) -- blue/red fragments, don't think spawn messages are useful
	self:Log("SPELL_AURA_APPLIED", "ToxicDamage", 204744)
	self:Log("SPELL_PERIODIC_DAMAGE", "ToxicDamage", 204744)
	self:Log("SPELL_PERIODIC_MISSED", "ToxicDamage", 204744)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	shardOnMe = false
	engageTime = GetTime()
	arcanoslashCount = 1
	self:Berserk(542) -- Heroic
	self:Bar(204275, 6) -- Arcanoslash
	self:Bar(204471, 16) -- Focused Blast (time to _success)
	self:Bar(204372, 20) -- Call of the Scorpid (time to _start)
	self:Bar(204316, 59) -- Shockwave (time to _success)

	if self:Mythic() then
		self:Bar(-13767, 22, L.mode:format(L.red), 211801)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:Arcanoslash(args)
	if arcanoslashCount % 3 == 1 then -- flurry of 3x 1s casts
		self:Message(args.spellId, "red", "Alarm", CL.casting:format(args.spellName))
		self:CDBar(args.spellId, 10)
	end
	arcanoslashCount = arcanoslashCount + 1
end

do
	local brokenShardCheck, name = nil, mod:SpellName(204284)

	local function checkForBrokenShard()
		if not shardOnMe then
			mod:Message(204284, "blue", "Warning", CL.no:format(name))
			brokenShardCheck = mod:ScheduleTimer(checkForBrokenShard, 1)
		else
			mod:Message(204284, "green", nil, CL.you:format(name))
		end
	end

	function mod:Shockwave(args)
		self:Message(args.spellId, "red", "Alarm", CL.casting:format(args.spellName))
		self:CastBar(args.spellId, 3)
		self:CDBar(args.spellId, 58) -- can be delayed by up to 3s
		self:CDBar(204372, 11) -- Call of the Scorpid (time to _start)
		self:CDBar(204471, 24) -- Focused Blast (time to _success)
		checkForBrokenShard()
	end

	function mod:ShockwaveSuccess()
		if brokenShardCheck then
			self:CancelTimer(brokenShardCheck)
		end
	end
end

function mod:BrokenShard(args)
	if self:Me(args.destGUID) then
		shardOnMe = true
	end
end

function mod:BrokenShardRemoved(args)
	if self:Me(args.destGUID) then
		shardOnMe = false
	end
end

function mod:ChitinousExoskeletonApplied(args)
	if self.isEngaged and (GetTime() - engageTime) > 10 then -- also applied when the boss spawns and/or(?) is pulled
		self:Message(args.spellId, "cyan", nil)
	end
end

function mod:ChitinousExoskeletonStacks(args)
	if (args.amount % 5 == 0) or args.amount < 4 then -- 20,15,10,5,3,2,1 This seems sane for now
		self:Message(args.spellId, "cyan", nil, CL.count:format(self:SpellName(args.spellId), args.amount))
	end
end

function mod:ExoskeletalVulnerabilityApplied(args)
	self:Message(args.spellId, "green", "Info")
	self:CastBar(args.spellId, 14, 160734, args.spellId) -- 160734 = Vulnerability
	self:CDBar(204471, 21.5) -- Focused Blast (time to _success), 14+7.5
	self:CDBar(204372, 22.5) -- Call of the Scorpid, 14+8.5
end

function mod:CallOfTheScorpid(args)
	self:Message(args.spellId, "yellow", "Long")
	self:CDBar(args.spellId, 20)
end

function mod:FocusedBlast(args)
	self:Message(args.spellId, "orange", "Alert")
	self:CastBar(args.spellId, 4)
	self:CDBar(args.spellId, 30)
end

do
	local prev = 0
	function mod:ToxicDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "blue", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		local t = GetTime()
		if spellId == 214800 and t-prev > 1 then -- Red
			prev = t
			self:Message(-13767, "cyan", "Info", L.mode:format(L.red), 211801)
			self:Bar(-13767, 45, L.mode:format(L.green), 214718)
			self:StopBar(L.mode:format(L.red))
			self:StopBar(L.mode:format(L.blue))
		elseif spellId == 215042 and t-prev > 1 then -- Green
			prev = t
			self:Message(-13767, "cyan", "Info", L.mode:format(L.green), 214718)
			self:Bar(-13767, 45, L.mode:format(L.blue), 204292)
			self:StopBar(L.mode:format(L.red))
			self:StopBar(L.mode:format(L.green))
		elseif spellId == 215055 and t-prev > 1 then -- Blue
			prev = t
			self:Message(-13767, "cyan", "Info", L.mode:format(L.blue), 204292)
			self:Bar(-13767, 45, L.mode:format(L.red), 211801)
			self:StopBar(L.mode:format(L.green))
			self:StopBar(L.mode:format(L.blue))
		end
	end
end
