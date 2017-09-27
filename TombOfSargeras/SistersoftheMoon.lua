
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

local stage = 1
local moonGlaiveCounter = 1
local twilightGlaiveCounter = 1
local screechCounter = 0
local rapidShotCounter = 1
local lunarFireCounter = 1
local lunarBeaconCounter = 1
local nextUltimate = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{236541, "SAY", "ICON"}, -- Twilight Glaive
		{236547, "TANK"}, -- Moon Glaive
		{236550, "TANK"}, -- Discorporate
		236480,	-- Glaive Storm
		{236305, "SAY", "ICON"}, -- Incorporeal Shot
		{236442, "SAY"}, -- Twilight Volley
		236694, -- Call Moontalon
		236697, -- Deadly Screech
		236603, -- Rapid Shot
		{233263, "PROXIMITY"}, -- Embrace of the Eclipse
		236519, -- Moon Burn
		{236712, "SAY"}, -- Lunar Beacon
		237351, -- Lunar Barrage
		{239264, "TANK"}, -- Lunar Fire
	},{
		["stages"] = "general",
		[236547] = -15499, -- Huntress Kasparian
		[236480] = -15510, -- Stage Two: Bow of the Night
		[236305] = -15502, -- Captain Yathae Moonstrike
		[236694] = -15510, -- Stage Two: Bow of the Night
		[233263] = -15506, -- Priestess Lunaspyre
		[236712] = -15519, -- Stage Three: Wrath of Elune
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	-- Huntress Kasparian
	self:Log("SPELL_AURA_APPLIED", "TwilightGlaiveApplied", 237561) -- Twilight Glaive
	self:Log("SPELL_AURA_REMOVED", "TwilightGlaiveRemoved", 237561) -- Twilight Glaive
	self:Log("SPELL_CAST_START", "MoonGlaive", 236547) -- Glaive Storm
	self:Log("SPELL_AURA_APPLIED", "Discorporate", 236550) -- Discorporate
	-- Stage Two: Bow of the Night
	self:Log("SPELL_CAST_START", "GlaiveStorm", 239379) -- Glaive Storm

	-- Captain Yathae Moonstrike
	self:Log("SPELL_AURA_APPLIED", "IncorporealShotApplied", 236305) -- Incorporeal Shot
	self:Log("SPELL_AURA_REMOVED", "IncorporealShotRemoved", 236305) -- Incorporeal Shot
	self:Log("SPELL_CAST_START", "TwilightVolley", 236442) -- Twilight Volley
	self:Log("SPELL_CAST_SUCCESS", "TwilightVolleySuccess", 236442) -- Twilight Volley
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
	self:Log("SPELL_AURA_APPLIED", "LunarBeaconApplied", 236712) -- Lunar Beacon (Debuff)
	self:Log("SPELL_AURA_REMOVED", "LunarBeaconRemoved", 236712) -- Lunar Beacon (Debuff)
	self:Log("SPELL_CAST_START", "LunarBeacon", 236712) -- Lunar Beacon
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 237351) -- Lunar Barrage
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 237351)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 237351)
	self:Log("SPELL_CAST_SUCCESS", "LunarFire", 239264) -- Lunar Fire
	self:Log("SPELL_AURA_APPLIED", "LunarFireApplied", 239264) -- Lunar Fire
	self:Log("SPELL_AURA_APPLIED_DOSE", "LunarFireApplied", 239264) -- Lunar Fire
end

function mod:OnEngage()
	stage = 1
	screechCounter = 0
	moonGlaiveCounter = 1
	twilightGlaiveCounter = 1
	rapidShotCounter = 1
	lunarBeaconCounter = 1

	nextUltimate = GetTime() + 48.3

	self:Message("stages", "Neutral", "Long", CL.stage:format(stage), false)
	self:Bar(236519, 9.4) -- Moon Burn
	self:Bar(236547, 14.2) -- Moon Glaive
	self:Bar(236442, 16.6) -- Twilight Volley
	self:Bar(236541, 18.1) -- Twilight Glaive
	self:Bar(236305, 48.3) -- Incorporeal Shot
	if not self:Easy() then
		self:Bar(233263, 48.3) -- Embrace of the Eclipse
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 235268 then -- Lunar Ghost (Transition)
		stage = stage + 1
		local nextUltimateTimer = nextUltimate - GetTime()
		self:Message("stages", "Neutral", "Long", CL.stage:format(stage), false)
		if stage == 2 then
			self:StopBar(236547) -- Moon Glaive
			self:StopBar(236442) -- Twilight Volley
			self:StopBar(236541) -- Twilight Glaive
			self:StopBar(236305) -- Incorporeal Shot

			self:Bar(236541, 6) -- Twilight Glaive
			self:Bar(236694, 7.3) -- Call Moontalon
			self:Bar(236603, 15.8) -- Rapid Shot

			local volleyTimer = 11
			if nextUltimateTimer < volleyTimer and (nextUltimateTimer + 11.5) > volleyTimer then -- Check if the cooldown ends at any point for 11.5s after the ultimate incase it gets interupted
				volleyTimer = volleyTimer + 7
			end
			self:CDBar(236442, volleyTimer) -- Twilight Volley

			if self:Easy() and nextUltimateTimer > 0 then
				self:Bar(233263, nextUltimateTimer) -- Embrace of the Eclipse
			elseif nextUltimateTimer > 0 then
				self:Bar(236480, nextUltimateTimer) -- Glaive Storm
			end
		elseif stage == 3 then
			self:StopBar(233263) -- Embrace of the Eclipse
			self:StopBar(236519) -- Moon Burn
			self:StopBar(236694) -- Call Moontalon
			self:StopBar(236603) -- Rapid Shot
			self:StopBar(236442) -- Twilight Volley

			self:Bar(236519, 10) -- Moon Burn
			self:Bar(239264, 11) -- Lunar Fire
			self:Bar(236712, 18.2) -- Lunar Beacon

			local volleyTimer = 15.8
			if nextUltimateTimer < volleyTimer and (nextUltimateTimer + 11.5) > volleyTimer then -- Check if the cooldown ends at any point for 11.5s after the ultimate incase it gets interupted
				volleyTimer = volleyTimer + 7
			end
			self:CDBar(236442, volleyTimer) -- Twilight Volley

			if self:Easy() and nextUltimateTimer > 0 then
				self:Bar(236480, nextUltimateTimer) -- Glaive Storm
			elseif nextUltimateTimer > 0 then
				self:Bar(236305, nextUltimateTimer) -- Incorporeal Shot
			end
		end
	end
end

function mod:TwilightGlaiveApplied(args)
	twilightGlaiveCounter = twilightGlaiveCounter + 1
	self:TargetMessage(236541, args.destName, "Attention")
	if self:Me(args.destGUID) then
		self:PlaySound(236541, "Warning")
		self:Say(236541)
	else
		self:PlaySound(236541, "Info")
	end
	self:SecondaryIcon(236541, args.destName)
	self:Bar(236541, stage > 1 and 20.5 or (twilightGlaiveCounter % 2 == 1 and 30 or 19))
end

function mod:TwilightGlaiveRemoved()
	self:SecondaryIcon(236541)
end

function mod:MoonGlaive(args)
	self:Message(args.spellId, "Important", "Warning")
	moonGlaiveCounter = moonGlaiveCounter + 1
	self:Bar(args.spellId, moonGlaiveCounter == 4 and 27.6 or 14.6) -- XXX Had a pull where the 3rd cast was delayed instead.
end

function mod:Discorporate(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, self:Tank())
end

function mod:GlaiveStorm(args)
	self:Message(236480, "Important", "Warning", CL.incoming:format(args.spellName))
	self:Bar(236480, 54.7)
	nextUltimate = GetTime() + 54.7
end

function mod:IncorporealShotApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:Bar(args.spellId, 54.7)
	nextUltimate = GetTime() + 54.7
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
		local nextUltimateTimer = nextUltimate - GetTime()
		if nextUltimateTimer > 43.2 then -- If less than 11.5 seconds have passed since last Ultimate, the cast will be interupted
			self:CDBar(args.spellId, 7)
		else
			self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		end
	end
end

function mod:TwilightVolleySuccess(args)
	local nextUltimateTimer = nextUltimate - GetTime()
	local timer = stage == 2 and 15.8 or 19.5 -- XXX Assumed cooldowns
	if nextUltimateTimer < timer and (nextUltimateTimer + 11.5) > timer then -- Check if the cooldown ends at any point for 11.5s after the ultimate incase it gets interupted
		timer = timer + 7
	end
	self:CDBar(args.spellId, timer)
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
	self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(self:SpellName(-15064))) -- Moontalon
	screechCounter = 1
	self:CDBar(args.spellId, 124.5) -- 122~127
end

function mod:DeadlyScreech(args)
	self:Message(args.spellId, "Attention", "Alert", CL.count:format(args.spellName, screechCounter))
	screechCounter = screechCounter + 1
end

function mod:RapidShotApplied(args)
	self:TargetMessage(236603, args.destName, "Attention", "Warning")
	rapidShotCounter = rapidShotCounter + 1
	self:Bar(236603, rapidShotCounter % 2 == 0 and 18.5 or 30.5)
end

function mod:EmbraceoftheEclipse(args)
	self:Message(args.spellId, "Attention", "Alarm", args.spellName)
	self:Bar(args.spellId, 54.7)
	nextUltimate = GetTime() + 54.7
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

function mod:MoonBurn()
	self:CDBar(236519, stage == 3 and 18.3 or 24.3)
end

do
	local playerList = mod:NewTargetList()
	function mod:MoonBurnApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Attention", "Alert")
		end
	end
end

do
	local targetFound = nil

	local function printTarget(self, name, guid)
		if not self:Tank(name) then -- sometimes takes really long, so we might return early
			targetFound = true
			self:TargetMessage(236712, name, "Attention", "Alert")
			if self:Me(guid) then
				self:Say(236712)
			end
		end
	end

	function mod:LunarBeaconApplied(args)
		if not targetFound then
			printTarget(self, args.destName, args.destGUID)
			targetFound = true
		end
		if self:Me(args.destGUID) then
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:LunarBeaconRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end

	function mod:LunarBeacon(args)
		targetFound = nil
		self:GetBossTarget(printTarget, 0.8, args.sourceGUID) -- Faster than waiting for debuff/cast end, but might return with the tank
		lunarBeaconCounter = lunarBeaconCounter + 1
		self:Bar(args.spellId, lunarBeaconCounter == 2 and 21.9 or 35) -- XXX Need Data longer than 4 casts
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:LunarFire(args)
		lunarFireCounter = lunarFireCounter + 1
		local t = GetTime()
		if t-prev > 20 or lunarFireCounter == 5 then -- Either 3rd or 4th is >20s, after that every 4th is.
			lunarFireCounter = 1
		end
		prev = t
		self:Bar(args.spellId, lunarBeaconCounter % 4 == 0 and 23.1 or 10.9)
	end
end

function mod:LunarFireApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 1 and "Warning")
end
