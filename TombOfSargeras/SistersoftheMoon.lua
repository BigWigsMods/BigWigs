
--------------------------------------------------------------------------------
-- TODO List:
-- - Deadly Screech Timers

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sisters of the Moon", 1147, 1903)
if not mod then return end
mod:RegisterEnableMob(118523, 118374, 118518, 119205) -- Huntress Kasparian, Captain Yathae Moonstrike, Priestess Lunaspyre, Moontalon
mod.engageId = 2050
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local stageOne = mod:SpellName(-15498)
local stageTwo = mod:SpellName(-15510)
local stageThree = mod:SpellName(-15519)

local phase = 1
local moonGlaiveCounter = 1
local twilightGlaiveCounter = 1
local screechCounter = 0
local rapidShotCounter = 1
local lunarFireCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{236541, "SAY", "ICON"}, -- Twilight Glaive
		236547, -- Moon Glaive
		{236550, "TANK"}, -- Discorporate
		236480,	-- Glaive Storm
		{236305, "SAY", "ICON"}, -- Incorporeal Shot
		{236442, "SAY"}, -- Twilight Volley
		236694, -- Call Moontalon
		236697, -- Deadly Screech
		236603, -- Rapid Shot
		{233263, "PROXIMITY"}, -- Embrace of the Eclipse
		236519, -- Moon Burn
		236712, -- Lunar Beacon
		{239264, "TANK"}, -- Lunar Fire
	},{
		["stages"] = "general",
		[236547] = -15499, -- Huntress Kasparian
		[236480] = stageTwo, -- Stage Two: Bow of the Night
		[236305] = -15502, -- Captain Yathae Moonstrike
		[236694] = stageTwo, -- Stage Two: Bow of the Night
		[233263] = -15506, -- Priestess Lunaspyre
		[236712] = stageThree, -- Stage Three: Wrath of Elune
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	-- Huntress Kasparian
	self:Log("SPELL_AURA_APPLIED", "TwilightGlaiveApplied", 237561) -- Twilight Glaive
	self:Log("SPELL_AURA_REMOVED", "TwilightGlaiveRemoved", 237561) -- Twilight Glaive
	self:Log("SPELL_AURA_APPLIED", "Discorporate", 236550) -- Discorporate
	-- Stage Two: Bow of the Night
	self:Log("SPELL_CAST_START", "GlaiveStorm", 239379) -- Glaive Storm

	-- Captain Yathae Moonstrike
	self:Log("SPELL_AURA_APPLIED", "IncorporealShotApplied", 236305) -- Incorporeal Shot
	self:Log("SPELL_AURA_REMOVED", "IncorporealShotRemoved", 236305) -- Incorporeal Shot
	self:Log("SPELL_CAST_START", "TwilightVolley", 236442) -- Twilight Volley
	self:Log("SPELL_AURA_APPLIED", "TwilightVolleyDamage", 236516) -- Twilight Volley
	self:Log("SPELL_PERIODIC_DAMAGE", "TwilightVolleyDamage", 236516) -- Twilight Volley
	self:Log("SPELL_PERIODIC_MISSED", "TwilightVolleyDamage", 236516) -- Twilight Volley
	-- Stage Two: Bow of the Night
	self:Log("SPELL_CAST_START", "CallMoontalon", 236694) -- Call Moontalon
	self:Log("SPELL_CAST_SUCCESS", "DeadlyScreech", 236697) -- Deadly Screech
	self:Log("SPELL_AURA_APPLIED", "RapidShotApplied", 236596) -- Rapid Shot (Debuff)

	-- Priestess Lunaspyre
	self:Log("SPELL_CAST_SUCCESS", "EmbraceoftheEclipse", 233263) -- Embrace of the Eclipse
	self:Log("SPELL_AURA_APPLIED", "EmbraceoftheEclipseApplied", 233263) -- Embrace of the Eclipse
	self:Log("SPELL_AURA_REMOVED", "EmbraceoftheEclipseRemoved", 233263) -- Embrace of the Eclipse
	self:Log("SPELL_CAST_SUCCESS", "MoonBurn", 236518) -- Moon Burn
	self:Log("SPELL_AURA_APPLIED", "MoonBurnApplied", 236519) -- Moon Burn
	-- Stage Three: Wrath of Elune
	self:Log("SPELL_CAST_START", "LunarBeacon", 236712) -- Lunar Beacon
	self:Log("SPELL_AURA_APPLIED", "LunarBeaconApplied", 236712) -- Lunar Beacon (Debuff)
	self:Log("SPELL_CAST_SUCCESS", "LunarFire", 239264) -- Lunar Fire
	self:Log("SPELL_AURA_APPLIED", "LunarFireApplied", 239264) -- Lunar Fire
	self:Log("SPELL_AURA_APPLIED_DOSE", "LunarFireApplied", 239264) -- Lunar Fire
end

function mod:OnEngage()
	phase = 1
	screechCount = 0
	moonGlaiveCounter = 1
	twilightGlaiveCounter = 1
	rapidShotCounter = 1

	self:Message("stages", "Neutral", "Long", stageOne, false)
	self:Bar(236519, 9.4) -- Moon Burn
	self:Bar(236547, 14.2) -- Moon Glaive
	self:Bar(236442, 16.6) -- Twilight Volley
	self:Bar(236541, 19.1) -- Twilight Glaive
	self:Bar(236305, 48.3) -- Incorporeal Shot
	self:Bar(233263, 48.3) -- Embrace of the Eclipse
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 236547 then -- Moon Glaive
		moonGlaiveCounter = moonGlaiveCounter + 1
		self:Bar(spellId, moonGlaiveCounter == 4 and 27.6 or 14.6) -- XXX Had a pull where the 3rd cast was delayed instead.
	elseif spellId == 235268 then -- Lunar Ghost (Transition) XXX Need to confirm
		phase = phase + 1
		if phase == 2 then
			self:Message("stages", "Neutral", "Long", stageTwo, false)
			self:StopBar(236547) -- Moon Glaive
			self:StopBar(236442) -- Twilight Volley
			self:StopBar(236541) -- Twilight Glaive
			self:StopBar(236305) -- Incorporeal Shot

			self:Bar(236694, 5.7) -- Call Moontalon
			self:Bar(236541, 7) -- Twilight Glaive
			self:Bar(236442, 11) -- Twilight Volley
			self:Bar(236603, 17.1) -- Rapid Shot
			self:Bar(236480, 42.6) -- Glaive Storm
		elseif phase == 3 then
			self:Message("stages", "Neutral", "Long", stageThree, false)
			self:StopBar(233263) -- Embrace of the Eclipse
			self:StopBar(236519) -- Moon Burn
			self:StopBar(236694) -- Call Moontalon
			self:StopBar(236603) -- Rapid Shot
			self:StopBar(236442) -- Twilight Volley

			self:Bar(239264, 6.8) -- Lunar Fire
			self:Bar(236519, 9.5) -- Moon Burn
			self:Bar(236442, 15.8) -- Twilight Volley
			self:Bar(239264, 18.2) -- Lunar Beacon
			self:Bar(236305, 35.2) -- Incorporeal Shot
		end
	end
end

function mod:TwilightGlaiveApplied(args)
	twilightGlaiveCounter = twilightGlaiveCounter + 1
	self:TargetMessage(236541, args.destName, "Attention", "Warning")
	if self:Me(guid) then
		self:Say(236541)
	end
	self:SecondaryIcon(236541, args.destName)
	self:Bar(236541, phase ~= 1 and 20.5 or (twilightGlaiveCounter % 2 == 1 and 30 or 19))
end

function mod:TwilightGlaiveRemoved(args)
	self:SecondaryIcon(236541)
end

function mod:Discorporate(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, self:Tank())
end

function mod:GlaiveStorm(args)
	self:Message(236480, "Important", "Warning", CL.incoming:format(args.spellName))
	self:Bar(236480, 54.7)
end

function mod:IncorporealShotApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(guid) then
		self:Say(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:CDBar(args.spellId, 54.7)
end

function mod:IncorporealShotRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(236442, name, "Attention", "Alert", nil, nil, true)
		if self:Me(guid) then
			self:Say(236442)
		end
	end
	function mod:TwilightVolley(args)
		if phase == 2 then
			self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		else -- Can only find target in P2
			self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
		end
		self:Bar(args.spellId, 19.5)
	end
end

do
	local prev = 0
	function mod:TwilightVolleyDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(236442, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:CallMoontalon(args)
	screechCount = 0
	self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(self:SpellName(-15064))) -- Moontalon
	self:Bar(args.spellId, 146.9)
end

function mod:DeadlyScreech(args)
	screechCounter = screechCounter + 1
	self:Message(args.spellId, "Attention", "Alert", CL.count:format(args.spellName, screechCounter))
end

function mod:RapidShotApplied(args)
	rapidShotCounter = rapidShotCounter + 1
	self:TargetMessage(236603, args.destName, "Attention", "Warning")
	self:Bar(236603, rapidShotCounter % 2 == 0 and 19.4 or 31.6)
end

function mod:EmbraceoftheEclipse(args)
	self:Message(args.spellId, "Attention", "Alarm", args.spellName)
	self:Bar(args.spellId, 54.7)
end

function mod:EmbraceoftheEclipseApplied(args)
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 8)
	end
end

function mod:EmbraceoftheEclipseRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:MoonBurn(args)
	self:Bar(236519, phase == 3 and 17 or 24.3) -- XXX Need more P3 data/timers
end

do
	local playerList = mod:NewTargetList()
	function mod:MoonBurnApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Attention", "Alert")
		end
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(236712, name, "Attention", "Alert")
		if self:Me(guid) then
			self:Say(236712)
		end
	end
	function mod:LunarBeacon(args)
		lunarBeaconCounter = lunarBeaconCounter + 1
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID) -- Faster than waiting for debuff/cast end
		self:Bar(args.spellId, lunarBeaconCounter % 2 == 0 and 35.3 or 21.9)
	end
end

function mod:LunarBeaconApplied(args)
	if self:Me(args.destGUID) then
		self:ScheduleTimer("Say", 3, args.spellId, 3, true)
		self:ScheduleTimer("Say", 4, args.spellId, 2, true)
		self:ScheduleTimer("Say", 5, args.spellId, 1, true)
	end
end

do
	local prev = 0
	function mod:LunarFire(args)
		lunarFireCounter = lunarFireCounter + 1
		local amount = args.amount or 1
		local t = GetTime()
		if t-prev > 20 or lunarFireCounter == 5 then -- Either 3rd or 4th is >20s, after that every 4th is.
		 lunarFireCounter = 1
		end
		prev = t
		self:Bar(args.spellId, lunarBeaconCounter % 4 == 0 and 23.1 or 10.9)
	end
end

function mod:LunarFireApplied(args)
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 1 and "Warning")
end
