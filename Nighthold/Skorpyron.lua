
--------------------------------------------------------------------------------
-- TODO List:
-- - Arcane Tether warnings for tanks

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skorpyron", 1088, 1706)
if not mod then return end
mod:RegisterEnableMob(102263)
mod.engageId = 1849
mod.respawnTime = 30 -- moves into room at 30, ~35 till he is in position

--------------------------------------------------------------------------------
-- Locals
--

local arcanoslashCount = 1

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
		{204275, "TANK"}, -- Arcanoslash
		204316, -- Shockwave
		204448, -- Chitinous Exoskeleton
		204459, -- Exoskeletal Vulnerability
		204372, -- Call of the Scorpid
		204471, -- Focused Blast
		{204284, "EMPHASIZE"}, -- Broken Shard
		--204292, -- Crystalline Fragments
		"berserk",
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
	self:Bar(204471, 17)	-- Focused Blast (time to _success)
	self:Bar(204372, 21)	-- Call of the Scorpid (time to _start)
	self:Bar(204316, 60) 	-- Shockwave (time to _success)
	arcanoslashCount = 1

	if self:Mythic() then
		self:Bar(-13767, 35, L.mode:format(L.red), 211801)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:Arcanoslash(args)
	if arcanoslashCount % 3 == 1 then -- flurry of 3x 1s casts
		self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
		self:CDBar(args.spellId, 10)
	end
	arcanoslashCount = arcanoslashCount + 1
end

do
	local brokenShardCheck, name = nil, mod:SpellName(204284)

	local function checkForBrokenShard()
		if not UnitDebuff("player", name) then
			mod:Message(204284, "Personal", "Info", CL.no:format(name))
			brokenShardCheck = mod:ScheduleTimer(checkForBrokenShard, 1)
		end
	end

	function mod:Shockwave(args)
		self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
		self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
		self:CDBar(args.spellId, 60) -- can be delayed by up to 3s
		checkForBrokenShard()
	end

	function mod:ShockwaveSuccess(args)
		if brokenShardCheck then
			self:CancelTimer(brokenShardCheck)
		end
	end
end

function mod:ChitinousExoskeletonApplied(args)
	self:Message(args.spellId, "Neutral", nil)
	self:CDBar(204471, 7.5)	-- Focused Blast (time to _success)
	self:CDBar(204372, 8.5)	-- Call of the Scorpid
end

function mod:ChitinousExoskeletonStacks(args)
	if (args.amount % 5 == 0) or args.amount < 4 then -- 20,15,10,5,3,2,1 This seems sane for now
		self:Message(args.spellId, "Neutral", nil, CL.count:format(self:SpellName(args.spellId), args.amount))
	end
end

function mod:ExoskeletalVulnerabilityApplied(args)
	self:Message(args.spellId, "Positive", "Info")
	self:Bar(args.spellId, 14) -- this was 14s on ptr, but says 15s in tooltips
end

function mod:CallOfTheScorpid(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 20)
end

function mod:FocusedBlast(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 30)
end

do
	local prev = 0
	function mod:ToxicDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
		local t = GetTime()
		if spellId == 214800 and t-prev > 1 then -- Red
			prev = t
			self:Message(-13767, "Neutral", "Info", L.mode:format(L.red), 211801)
			self:Bar(-13767, 46, L.mode:format(L.green), 214718)
		elseif spellId == 215042 and t-prev > 1 then -- Green
			prev = t
			self:Message(-13767, "Neutral", "Info", L.mode:format(L.green), 214718)
			self:Bar(-13767, 46, L.mode:format(L.blue), 204292)
		elseif spellId == 215055 and t-prev > 1 then -- Blue
			prev = t
			self:Message(-13767, "Neutral", "Info", L.mode:format(L.blue), 204292)
			self:Bar(-13767, 46, L.mode:format(L.red), 211801)
		end
	end
end
