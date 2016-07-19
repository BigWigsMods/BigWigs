
--------------------------------------------------------------------------------
-- TODO List:
-- - Figure out how Arcane Tether works (see comment on event handler)
-- - Be a little bit smarter about timers:
-- -- It looks like Shockwave is always cast on CD. This delays the other abilitys though
-- -- We don't know how the vulnerability phase affect timers yet

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
		204284, -- Broken Shard
		-- 204292, -- Crystalline Fragments
		--{204531, "PROXIMITY"}, -- Arcane Tether
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
	self:Log("SPELL_CAST_SUCCESS", "CallOfTheScorpid", 204372)
	self:Log("SPELL_CAST_START", "FocusedBlast", 204471)
	--self:Log("SPELL_SUMMON", "CrystallineFragments", 204292, 214662) -- blue, red fragments, don't think spawm messages are useful
	--self:Log("SPELL_AURA_APPLIED", "ArcaneTether", 204531) -- Pre alpha testing spellId
	--self:Log("SPELL_AURA_REMOVED", "ArcaneTetherRemoved", 204531) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_APPLIED", "ToxicDamage", 204744)
	self:Log("SPELL_PERIODIC_DAMAGE", "ToxicDamage", 204744)
	self:Log("SPELL_PERIODIC_MISSED", "ToxicDamage", 204744)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Skorpyron (Alpha) Engaged (Post Alpha Mythic Test Mod)", 123886) -- some scorpion icon
	self:CDBar(204471, 15)	-- Focused Blast (time to _success)
	self:Bar(204372, 21)	-- Call of the Scorpid
	self:Bar(-13767, 35, L.mode:format(L.red), 211801)
	self:Bar(204316, 60) 	-- Shockwave (time to _success)
	arcanoslashCount = 1
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
		self:Bar(args.spellId, 60)
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
end

function mod:ChitinousExoskeletonStacks(args)
	if (args.amount % 5 == 0) or args.amount < 4 then -- 20,15,10,5,3,2,1 This seems sane for now
		self:Message(args.spellId, "Neutral", nil, CL.count:format(self:SpellName(args.spellId), args.amount))
	end
end

function mod:ExoskeletalVulnerabilityApplied(args)
	self:Message(args.spellId, "Positive", "Info") -- 50% more damage taken is positive
	self:Bar(args.spellId, 14) -- this was 14s in alpha tests, but 15s in tooltips
end

function mod:CallOfTheScorpid(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 20)
end

function mod:FocusedBlast(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 30)
end

--[[
function mod:CrystallineFragments(args)
	self:Message(args.spellId, "Positive", nil, CL.spawned:format(args.spellName))
end
]]

--[[
-- TODO: I have no idea how this works yet.
-- Might be a debuff you only get when you are near the tank (like a fail mechanic)
-- I got the debuff with 2 stacks on the hc test, ran away and it disapperead - dunno how, why, ...

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ArcaneTether(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert")
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 10)
	end
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ArcaneTetherRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end
]]

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
	function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, spellGUID, _)
		local t = GetTime()
		local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10) -- new uscs format: 3-[server id]-[instance id]-[zone uid]-[spell id]-[spell uid]

		print(t, spellId)
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
