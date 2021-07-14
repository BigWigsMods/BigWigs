--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kel'Thuzad", 2450, 2440)
if not mod then return end
mod:RegisterEnableMob(175559, 176703, 176973, 176974, 176929) -- Kel'Thuzad, Frostbound Devoted, Unstoppable Abomination, Soul Reaver, Remnant of Kel'Thuzad
mod:SetEncounterID(2422)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local glacialSpikeMarks = {}
local mindControlled = false
local inPhylactry = false
local darkEvocationCount = 1
local blizzardCount = 1
local soulFractureCount = 1
local oblivionsEchoCount = 1
local frostBlastCount = 1
local glacialWrathCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spikes = "Spikes" -- Short for Glacial Spikes
	L.spike = "Spike"
	L.silence = mod:SpellName(226452) -- Silence
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frostbound Devoted that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 210130
end

--------------------------------------------------------------------------------
-- Initialization
--

local glacialWrathMarker = mod:AddMarkerOption(false, "player", 1, 346459, 1, 2, 3, 4, 5) -- Glacial Wrath
local soulReaverMarker = mod:AddMarkerOption(false, "npc", 8, -23435, 8, 7, 6) -- Soul Reaver
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Chains and Ice
		354198, -- Howling Blizzard
		352530, -- Dark Evocation
		355389, -- Relentless Haunt
		"custom_on_nameplate_fixate",
		348071, -- Soul Fracture // Tank hit but spawns Soul Shards for DPS
		{348978, "TANK"}, -- Soul Exhaustion
		348428, -- Piercing Wail
		{346459, "SAY", "SAY_COUNTDOWN"}, -- Glacial Wrath
		glacialWrathMarker,
		{346530, "ME_ONLY"}, -- Frozen Destruction
		{347292, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Oblivion's Echo
		{348760, "SAY", "SAY_COUNTDOWN", "FLASH", "ME_ONLY_EMPHASIZE"}, -- Frost Blast
		-- Stage Two: The Phylactery Opens
		354289, -- Sinister Miasma
		352051, -- Necrotic Surge
		352293, -- Vengeful Destruction
		355137, -- Shadow Pool
		352379, -- Freezing Blast
		355055, -- Glacial Winds
		355127, -- Foul Winds (Mythic)
		352355, -- Undying Wrath
		352141, -- Banshee's Cry (Soul Reaver)
		soulReaverMarker,
		-- Stage Three: The Final Stand
		354639, -- Deep Freeze
		352348, -- Onslaught of the Damned
	},{
		["stages"] = "general",
		[354198] = mod:SpellName(-22884), -- Stage One: Chains and Ice
		[354289] = mod:SpellName(-22885), -- Stage Two: The Phylactery Opens
		[354639] = mod:SpellName(-23201) -- Stage Three: The Final Stand
	},{
		[355389] = CL.fixate, -- Relentless Haunt (Fixate)
		[346459] = L.spikes, -- Glacial Wrath (Spikes)
		[347292] = L.silence, -- Oblivion's Echo (Silence)
		[348760] = CL.meteor, -- Frost Blast (Meteor)
		[354289] = L.miasma, -- Necrotic Miasma (Miasma)
		[352293] = self:SpellName(249436), -- Necrotic Destruction (Destruction)
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_CAST_START", "HowlingBlizzard", 354198)
	self:Log("SPELL_AURA_APPLIED", "DarkEvocation", 352530) -- No _SUCCESS on the channel
	self:Log("SPELL_AURA_APPLIED", "RelentlessHauntApplied", 355389)
	self:Log("SPELL_AURA_REMOVED", "RelentlessHauntRemoved", 355389)
	self:Log("SPELL_CAST_START", "SoulFractureStart", 348071)
	self:Log("SPELL_CAST_SUCCESS", "SoulFractureSuccess", 348071)
	self:Log("SPELL_AURA_APPLIED", "SoulExhaustionApplied", 348978)
	self:Log("SPELL_AURA_REMOVED", "SoulExhaustionRemoved", 348978)
	self:Log("SPELL_CAST_START", "PiercingWailStart", 348428)
	self:Log("SPELL_CAST_START", "GlacialWrath", 346459)
	self:Log("SPELL_SUMMON", "GlacialWrathSummon", 346469)
	self:Log("SPELL_AURA_APPLIED", "GlacialWrathApplied", 353808)
	self:Log("SPELL_AURA_REMOVED", "GlacialWrathRemoved", 353808)
	self:Log("SPELL_AURA_APPLIED", "FrozenDestructionApplied", 346530)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrozenDestructionApplied", 346530)
	self:Log("SPELL_CAST_START", "OblivionsEcho", 347291)
	self:Log("SPELL_AURA_APPLIED", "OblivionsEchoApplied", 347292)
	self:Log("SPELL_AURA_REMOVED", "OblivionsEchoRemoved", 347292)
	self:Log("SPELL_CAST_START", "FrostBlast", 348756, 358999)
	self:Log("SPELL_CAST_SUCCESS", "FrostBlastSuccess", 348756, 358999)
	self:Log("SPELL_AURA_APPLIED", "FrostBlastApplied", 348760)

	-- Stage Two: The Phylactery Opens
	self:Log("SPELL_AURA_APPLIED", "PhylactryApplied", 348787)
	self:Log("SPELL_AURA_REMOVED", "PhylactryRemoved", 348787)
	self:Log("SPELL_AURA_APPLIED", "SinisterMiasmaApplied", 354289)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SinisterMiasmaApplied", 354289)
	self:Log("SPELL_AURA_APPLIED", "NecroticSurgeApplied", 352051)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NecroticSurgeApplied", 352051)
	self:Log("SPELL_CAST_START", "VengefulDestruction", 352293)
	self:Log("SPELL_CAST_START", "FreezingBlast", 352379)
	self:Log("SPELL_CAST_START", "GlacialWinds", 355055)
	self:Log("SPELL_CAST_START", "FoulWinds", 355127)
	self:Log("SPELL_CAST_START", "UndyingWrath", 352355)
	self:Death("RemnantDeath", 176929) -- Remnant of Kel'Thuzad

	self:Log("SPELL_CAST_START", "BansheesCry", 352141)
	self:Log("SPELL_SUMMON", "MarchOfTheForsakenSummon", 352094)

	-- Stage Three: The Final Stand
	self:Log("SPELL_CAST_START", "OnslaughtOfTheDamned", 352348)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 354198, 354639, 355137) -- Howling Blizzard, Deep Freeze, Shadow Pool
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 354198, 354639, 355137)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 354198, 354639, 355137)

	self:Log("SPELL_AURA_APPLIED", "ReturnOfTheDamned", 348638)
	self:Log("SPELL_AURA_REMOVED", "ReturnOfTheDamnedRemoved", 348638)

	if self:GetOption("custom_on_nameplate_fixate") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	self:SetStage(1)
	mobCollector = {}
	glacialSpikeMarks = {}
	mindControlled = false
	inPhylactry = false

	darkEvocationCount = 1
	blizzardCount = 1
	soulFractureCount = 1
	oblivionsEchoCount = 1
	frostBlastCount = 1
	glacialWrathCount = 1

	-- Soul Fracture and Ice Shards delay casts
	self:CDBar(348071, 13.8, CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture (to _SUCCESS)
	self:CDBar(347292, 15.8, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
	self:CDBar(346459, 24.2, CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
	self:CDBar(348760, 46.2, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
	self:CDBar(352530, 51.4, CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
	self:CDBar(354198, 110, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
end

function mod:OnBossDisable()
	if self:GetOption("custom_on_nameplate_fixate") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Chains and Ice
function mod:HowlingBlizzard(args)
	self:Message(args.spellId, "cyan", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 23, CL.count:format(args.spellName, blizzardCount))
	blizzardCount = blizzardCount + 1
	self:CDBar(354198, 118.5, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard

	oblivionsEchoCount = 1
	glacialWrathCount = 1
	frostBlastCount = 1
end

function mod:DarkEvocation(args)
	self:Message(args.spellId, "cyan", CL.casting:format(CL.count:format(args.spellName, darkEvocationCount)))
	self:PlaySound(args.spellId, "long")
	darkEvocationCount = darkEvocationCount + 1
	self:CDBar(args.spellId, 111, CL.count:format(args.spellName, darkEvocationCount))
end

function mod:RelentlessHauntApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		if self:GetOption("custom_on_nameplate_fixate") then
			self:AddPlateIcon(210130, args.sourceGUID) -- 210130 = ability_fixated_state_red
		end
	end
end

function mod:RelentlessHauntRemoved(args)
	if self:Me(args.destGUID) and self:GetOption("custom_on_nameplate_fixate") then
		self:RemovePlateIcon(210130, args.sourceGUID)
	end
end

function mod:SoulFractureStart(args)
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, soulFractureCount)))
	self:PlaySound(args.spellId, "alarm")
end

function mod:SoulFractureSuccess(args)
	soulFractureCount = soulFractureCount + 1
	self:CDBar(args.spellId, 33.2, CL.count:format(args.spellName, soulFractureCount)) -- 33~ or 40.3+ (delayed by a blizzard/dark evocation?)
end

function mod:SoulExhaustionApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		local unit = self:GetBossId(175559) -- Kel'Thuzad
		if not self:Me(args.destGUID) and unit and not self:Tanking(unit) then
			self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, soulFractureCount-1))
			self:PlaySound(args.spellId, "warning", "taunt", args.destName) -- Not taunted? Play warning sound.
		elseif self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end
	self:TargetBar(args.spellId, 60, args.destName, CL.count:format(args.spellName, soulFractureCount-1))
end

function mod:SoulExhaustionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
	self:StopBar(args.spellId, args.destName)
end

function mod:PiercingWailStart(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:GlacialWrath(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.spikes, glacialWrathCount)))
	self:PlaySound(args.spellId, "alert")
	glacialWrathCount = glacialWrathCount + 1
	self:CDBar(args.spellId, 118.6, CL.count:format(L.spikes, glacialWrathCount))

	mobCollector = {}
	glacialSpikeMarks = {}
	if self:GetOption(glacialWrathMarker) then
		self:RegisterTargetEvents("GlacialSpikeMarker")
		self:ScheduleTimer("UnregisterTargetEvents", 10)
	end
end

function mod:GlacialWrathSummon(args)
	mobCollector[args.destGUID] = tremove(glacialSpikeMarks, 1)
end

function mod:GlacialSpikeMarker(event, unit, guid)
	if self:MobId(guid) == 175861 and mobCollector[guid] then
		self:CustomIcon(glacialWrathMarker, unit, mobCollector[guid])
		mobCollector[guid] = nil
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:GlacialWrathApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(346459, CL.rticon:format(L.spike, count))
			self:SayCountdown(346459, 5, count)
			self:PlaySound(346459, "warning")
		end
		self:NewTargetsMessage(346459, "orange", playerList, nil, L.spike)
		self:CustomIcon(glacialWrathMarker, args.destName, icon)
	end

	function mod:GlacialWrathRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(346459)
		end
		self:CustomIcon(glacialWrathMarker, args.destName)
		glacialSpikeMarks[#glacialSpikeMarks+1] = playerList[args.destName] -- _REMOVED is more reliable for spike order
	end
end


do
	local playerName = mod:UnitName("player")
	local stacks = 1
	local scheduled = nil

	local function FrozenDestructionStackMessage()
		mod:NewStackMessage(346530, "blue", playerName, stacks)
		mod:PlaySound(346530, stacks > 4 and "warning" or "info") -- How many stacks is too much?
		scheduled = nil
	end

	function mod:FrozenDestructionApplied(args) -- Throttle incase several die at the same time
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer(FrozenDestructionStackMessage, 0.1)
			end
		end
	end
end

do
	local playerList = {}
	function mod:OblivionsEcho(args)
		playerList = {}
		oblivionsEchoCount = oblivionsEchoCount + 1
		self:CDBar(347292, oblivionsEchoCount == 1 and 61.5 or 40.4, CL.count:format(L.silence, oblivionsEchoCount))
	end

	function mod:OblivionsEchoApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.silence)
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.silence, oblivionsEchoCount-1))
	end
end

function mod:OblivionsEchoRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:FrostBlast(args)
	-- Fix timer
	self:CDBar(348760, 3, CL.count:format(CL.meteor, frostBlastCount))
end

function mod:FrostBlastSuccess(args)
	frostBlastCount = frostBlastCount + 1
	if self:GetStage() == 1 then
		self:CDBar(348760, frostBlastCount == 1 and 42.4 or 76.1, CL.count:format(CL.meteor, frostBlastCount))
	elseif self:GetStage() == 3 and frostBlastCount % 3 ~= 0 then
		self:CDBar(348760, 15.7, CL.count:format(CL.meteor, frostBlastCount))
	end
end

function mod:FrostBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, CL.meteor)
		self:Flash(args.spellId)
		self:YellCountdown(args.spellId, 6)
	else
		self:PlaySound(args.spellId, "alert")
	end
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(CL.meteor, frostBlastCount-1))
end

function mod:PhylactryApplied(args)
	if self:Me(args.destGUID) then
		inPhylactry = true
	end
end

function mod:PhylactryRemoved(args)
	if self:Me(args.destGUID) then
		inPhylactry = false
	end
end

function mod:SinisterMiasmaApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 0 and amount > 15 then -- 15+ or every 3
			self:NewStackMessage(args.spellId, "blue", args.destName, amount, 10, L.miasma)
			if amount > 15 then
				self:PlaySound(args.spellId, "alert")
			end
		end
	end
end

function mod:VengefulDestruction(args)
	self:Message(args.spellId, "yellow", CL.casting:format(self:SpellName(249436)))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 45, self:SpellName(249436)) -- Destruction

	-- UNIT_SPELLCAST_SUCCEEDED Events which are 2.5~s faster to do a stage change on:
	-- ClearAllDebuffs-34098-npc:175559
	-- Cosmetic Death-351625-npc:175559
	-- Teleport to Floor-351418-npc:175559

	self:StopBar(CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
	self:StopBar(CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
	self:StopBar(CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
	self:StopBar(CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
	self:StopBar(CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
	self:StopBar(CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard

	self:SetStage(2)
	local remnant = self:GetBossId(176929) -- was only ever boss2, but just to make sure
	if remnant and self:GetHealth(remnant) < 34 then -- final stage 2
		self:CDBar(355055, 3) -- Glacial Winds
		self:CDBar(352379, 11) -- Freezing Blast
		-- if self:Mythic() then
		-- 	self:CDBar(355127, 7) -- Foul Winds
		-- end
	else
		-- XXX probably varies based on the first person entering?
		self:CDBar(352379, self:Mythic() and 3 or 7) -- Freezing Blast
		if self:Mythic() then
			self:CDBar(355127, 7) -- Foul Winds
		end
	end
end

function mod:NecroticSurgeApplied(args)
	if not self:IsEngaged() then return end -- starts with stacks on mythic
	self:NewStackMessage(args.spellId, "cyan", args.destName, args.amount)
	self:PlaySound(args.spellId, "info")

	self:StopBar(CL.cast:format(self:SpellName(249436))) -- Destruction
	self:StopBar(352379) -- Freezing Blast
	self:StopBar(355055) -- Glacial Winds
	self:StopBar(355127) -- Foul Winds

	if self:GetStage() == 2 then
		self:SetStage(1)
		soulFractureCount = 1
		oblivionsEchoCount = 1
		glacialWrathCount = 1
		frostBlastCount = 1

		local currentMana = UnitPower("boss1") or 0

		-- XXX these need to be checked!
		-- Standard time if mana is 100
		local evocationTime = 35.9 -- ✓
		local blizzardTime = 90.3 -- ✓
		if currentMana == 80 then
			evocationTime = 46.1
			blizzardTime = 86.4
		elseif currentMana == 60 then
			evocationTime = 15.8 -- ✓
			blizzardTime = 51.4 -- ✓
		elseif currentMana == 40 then
			evocationTime = 3.2 -- ✓
			blizzardTime = 25.5 -- ✓
		elseif currentMana == 20 then
			evocationTime = 92.1 -- ✓
			blizzardTime = 16.5 -- ✓
		end

		--         80        60         40         20         0          100
		-- Silence -> Spikes -> Meteor  -> Silence -> Meteor -> Blizzard
		--  61.9      ~118.6     42.4       40.4      ~76.1      118.6

		self:CDBar(348071, 13, CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
		self:CDBar(347292, 14.5, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
		if currentMana > 20 then
			self:CDBar(346459, 24.7, CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
			if currentMana > 40 then
				self:CDBar(348760, 46.6, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
			end
		end
		self:CDBar(352530, evocationTime, CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
		self:CDBar(354198, blizzardTime, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
	else -- Stage 3
		-- Frost Blast -> Frost Blast -> Frost Blast -> Onslaught
		frostBlastCount = 1 -- Frost Blast
		self:CDBar(348760, 8, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
		self:CDBar(352348, 48.5) -- Onslaught of the Damned
	end
end

function mod:RemnantDeath()
	self:Message("stages", "green", CL.stage:format(3), false)
	self:PlaySound("stages", "info")
	self:SetStage(3)
end

function mod:FreezingBlast(args)
	if inPhylactry then
		self:Message(args.spellId, "orange")
		self:CDBar(args.spellId, self:Mythic() and 12.1 or 4.9)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:GlacialWinds(args)
	if inPhylactry then
		self:Message(args.spellId, "cyan")
		self:CDBar(args.spellId, 13.5)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FoulWinds(args)
	if inPhylactry then
		self:Message(args.spellId, "yellow")
		self:CDBar(args.spellId, 12.2)
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:UndyingWrath(args)
	self:Message(args.spellId, "red")
	self:CastBar(args.spellId, 10)
	if inPhylactry then
		self:PlaySound(args.spellId, "warning")
	end

	self:StopBar(352379) -- Freezing Blast
	self:StopBar(355055) -- Glacial Winds
	self:StopBar(355127) -- Foul Winds
end

function mod:OnslaughtOfTheDamned(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 48.6)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and not mindControlled then
			local t = args.time
			local throttle = args.spellId == 354639 and 6 or 2 -- Deep Freeze
			if t-prev > throttle then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:ReturnOfTheDamned(args)
	if self:Me(args.destGUID) then
		mindControlled = true
	end
end

function mod:ReturnOfTheDamnedRemoved(args)
	if self:Me(args.destGUID) then
		mindControlled = false
	end
end

function mod:BansheesCry(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and (self:GetStage() == 3 or not inPhylactry) then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	function mod:SoulReaverMarker(event, unit, guid)
		if mobCollector[guid] then
			self:CustomIcon(soulReaverMarker, unit, mobCollector[guid])
			mobCollector[guid] = nil
			if not next(mobCollector) then
				self:UnregisterTargetEvents()
			end
		end
	end

	local prev = 0
	local count = 8
	function mod:MarchOfTheForsakenSummon(args)
		if not self:GetOption(soulReaverMarker) then return end
		local t = args.time
		if t-prev > 5 then
			prev = t
			mobCollector = {}
			count = 8
			self:RegisterTargetEvents("SoulReaverMarker")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
		mobCollector[args.destGUID] = count
		count = count - 1
	end
end
