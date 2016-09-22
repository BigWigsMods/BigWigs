
--------------------------------------------------------------------------------
-- TODO List:
-- - Fix untested funcs if needed
-- - WaveSpawn got broken, figure out a new way to do this
--     Wave 1:	Wisp, Drake, Treant
--     Wave 2:	Wisp, Drake, Sister
--     Wave 3:	2x Sister, Treant
--     Wave 4:	2x Drake, Wisp
--     Wave 5:	2x Treant, Sister
--     Wave 6:	2x Wisp, Sister
-- - NightmareBrambles: can targetscan for initial target - lets hope that there
--   is a debuff on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cenarius", 1094, 1750)
if not mod then return end
mod:RegisterEnableMob(104636)
mod.engageId = 1877
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local forcesOfNightmareCount = 1
local phase = 1


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.forces = "Forces"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Cenarius ]]--
		"stages",
		210279, -- Creeping Nightmares
		{210290, "ICON", "SAY", "FLASH"}, -- Nightmare Brambles
		212726, -- Forces of Nightmare
		210346, -- Dread Thorns
		214884, -- Corrupt Allies of Nature
		-- P2
		214505, -- Entangling Nightmares
		214529, -- Spear of Nightmares
		
		--[[ Malfurion Stormrage ]]--
		212681, -- Cleansed Ground

		--[[ Corrupted Wisp ]]--
		-- they don't have a fixate debuff :(

		--[[ Nightmare Treant ]]--
		211073, -- Desiccating Stomp

		--[[ Rotten Drake ]]--
		211192, -- Rotten Breath

		--[[ Twisted Sister ]]--
		211368, -- Twisted Touch of Life
		{211471, "SAY", "FLASH", "PROXIMITY"}, -- Scorned Touch

		--[[ General ]]--
		"berserk",

		--[[ Mythic ]]--
		214876, -- Beasts of Nightmare
	},{
		[210279] = -13339, -- Cenarius
		[212681] = -13344, -- Malfurion Stormrage
		--[0000] = -13348, -- Corrupted Wisp
		[211073] = -13350, -- Nightmare Treant
		[211192] = -13354, -- Rotten Drake
		[211368] = -13357, -- Twisted Sister
		["berserk"] = "general",
		[214876] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ Cenarius ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCESS", nil, "boss1")
	self:Log("SPELL_CAST_START", "ForcesOfNightmare", 212726)
	self:Log("SPELL_AURA_APPLIED", "CreepingNightmares", 210279)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CreepingNightmares", 210279)
	self:Log("SPELL_AURA_REMOVED", "CreepingNightmaresRemoved", 210279)
	--self:Log("SPELL_CAST_START", "NightmareBrambles", 210290) -- XXX do these actually work?
	--self:Log("SPELL_CAST_SUCCES", "NightmareBramblesSuccess", 210290) -- XXX do these actually work?
	--self:Log("SPELL_AURA_APPLIED", "NightmareBramblesApplied", 210290) -- untested, -- XXX do these actually work?
	self:Log("SPELL_AURA_APPLIED", "DestructiveNightmares", 210617) -- wisp spawn
	self:Log("SPELL_AURA_APPLIED", "DreadThorns", 210346)
	self:Log("SPELL_AURA_REMOVED", "DreadThornsRemoved", 210346)
	self:Log("SPELL_AURA_APPLIED", "CorruptAlliesOfNature", 214884) -- untested

	self:Log("SPELL_AURA_APPLIED", "EntanglingNightmares", 214505)
	self:Log("SPELL_CAST_START", "SpearOfNightmaresCast", 214529)
	self:Log("SPELL_AURA_APPLIED", "SpearOfNightmares", 214529)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SpearOfNightmares", 214529)

	--[[ Malfurion Stormrage ]]--
	self:Log("SPELL_AURA_APPLIED", "CleansedGround", 212681)
	self:Log("SPELL_AURA_REMOVED", "CleansedGroundRemoved", 212681)

	--[[ Corrupted Wisp ]]--
  --self:Log("SPELL_AURA_APPLIED", "SomethingLikeWhispFixate", 0)

	--[[ Nightmare Treant ]]--
	self:Log("SPELL_CAST_START", "DesiccatingStomp", 211073)

	--[[ Rotten Drake ]]--
	self:Log("SPELL_CAST_START", "RottenBreath", 211192)

	--[[ Twisted Sister ]]--
	self:Log("SPELL_CAST_START", "TwistedTouchOfLife", 211368)
	self:Log("SPELL_AURA_APPLIED", "TwistedTouchOfLifeApplied", 211368)
	self:Log("SPELL_AURA_APPLIED", "ScornedTouch", 211471)
	self:Log("SPELL_AURA_REMOVED", "ScornedTouchRemoved", 211471)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_SUCCESS", "BeastsOfNightmare", 214876) -- untested
end

function mod:OnEngage()
	forcesOfNightmareCount = 1
	phase = 1
	self:CDBar(212726, 10, CL.count:format(self:SpellName(212726), forcesOfNightmareCount)) -- Forces of Nightmare
	self:Bar(210290, 28) -- Nightmare Brambles

	wipe(mobCollector)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Cenarius ]]--
function mod:UNIT_SPELLCAST_SUCCESS(unit, spellName, _, _, spellId)
	if spellId == 210290 then -- Nightmare Brambles
		local targetGUID = UnitGUID('boss1target') --selects target 2sec prior to the cast
		local targetName = UnitName('boss1target')
		if self:Me(targetGUID) then
			self:Flash(210290)
			self:Say(210290)
		end
		self:Bar(args.spellId, phase == 2 and 20 or 30) -- at some point starts casting with 15sec-20sec cd
		self:TargetMessage(210290, targetName, "Urgent", "Alarm")
		self:PrimaryIcon(210290, targetName)
	elseif spellId == 217368 then -- Phase 2
		phase = 2
		self:Bar(210290, 13) -- Nightmare Brambles
		self:Bar(214529, 23) -- Spear Of Nightmares
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
	end
end
function mod:CreepingNightmares(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 15 and amount % 4 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
		end
	end
end

function mod:CreepingNightmaresRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
	end
end

function mod:NightmareBramblesSuccess(args)
	self:Message(args.spellId, "Attention", "Info")
end

-- untested
function mod:NightmareBramblesApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:ForcesOfNightmare(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	forcesOfNightmareCount = forcesOfNightmareCount + 1
	self:Bar(210346, 6) -- Dread Thorns
	self:Bar(212681, 13, self:SpellName(212681)) -- Cleansed Ground
	--self:CDBar(args.spellId, 19, CL.incoming:format(L.forces))
	self:Bar(args.spellId, 77.7, CL.count:format(self:SpellName(args.spellId), forcesOfNightmareCount))
end

do
	local adds = {
		[106304] = -13348, -- Corrupted Wisp
		[105468] = -13350, -- Nightmare Treant
		[105494] = -13354, -- Rotten Drake
		[105495] = -13357, -- Twisted Sister
	}
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 5 do
			local guid = UnitGUID("boss"..i)
			if guid and not mobCollector[guid] then
				mobCollector[guid] = true
				local id = adds[self:MobId(guid)]
				if id then
					self:Message(212726, "Neutral", "Info", self:SpellName(id), false)
				end
			end
		end
	end

	local prev = 0
	function mod:DestructiveNightmares(args)
		local t = GetTime()
		if t-prev > 10 then
			prev = t
			self:Message(212726, "Neutral", "Info", self:SpellName(-13348), false)
		end
	end
end

function mod:DreadThorns(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:Bar(args.spellId, 45, CL.on:format(args.spellName, args.destName))
end

function mod:DreadThornsRemoved(args)
	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
	self:CDBar(args.spellId, 32.7)
end

function mod:EntanglingNightmares(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:CDBar(args.spellId, 51)
end

-- untested
local prev = 0
function mod:CorruptAlliesOfNature(args)
	local t = GetTime()
	if t-prev > 10 then
		prev = t
			self:Message(args.spellId, "Attention", "Info", CL.incoming:format(args.spellName))
	end
end


function mod:SpearOfNightmaresCast(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
end

function mod:SpearOfNightmares(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", self:Tank() and "Warning")
	self:Bar(args.spellId, 15.7)
end

--[[ Malfurion Stormrage ]]--
do
	local cleansedGroundCheck, name = nil, mod:SpellName(212681)

	local function checkForCleansedGround()
		if UnitDebuff("player", name) then
			mod:Message(212681, "Positive", "Alert", CL.underyou:format(name))
			cleansedGroundCheck = mod:ScheduleTimer(checkForCleansedGround, 1)
		end
	end

	function mod:CleansedGround(args)
		if self:Me(args.destGUID) then
			cleansedGroundCheck = mod:ScheduleTimer(checkForCleansedGround, 1) -- you shouldn't stand in there for too long
		end
	end

	function mod:CleansedGroundRemoved(args)
		if cleansedGroundCheck then
			self:CancelTimer(cleansedGroundCheck)
		end
	end
end

--[[ Corrupted Wisp ]]--
-- give fixate debuff pls blizzard

--[[ Nightmare Treant ]]--
function mod:DesiccatingStomp(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 33)
end

--[[ Rotten Drake ]]--
function mod:RottenBreath(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 5.5, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 25)
end

--[[ Twisted Sister ]]--
function mod:TwistedTouchOfLife(args)
	self:Message(args.spellId, "Important", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 12.1)
end

function mod:TwistedTouchOfLifeApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, self:Dispeller("magic", true, args.spellId))
end

do
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:ScornedTouch(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
			self:OpenProximity(args.spellId, 8)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 8, proxList)
		end

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Alert")
		end
	end

	function mod:ScornedTouchRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
		end

		tDeleteItem(proxList, args.destName)
		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 8, proxList)
			end
		end
	end
end

--[[ Mythic ]]--
function mod:BeastsOfNightmare(args)
	self:Message(args.spellId, "Important", "Alert")
end
