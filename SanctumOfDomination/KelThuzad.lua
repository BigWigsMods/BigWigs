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
local glacialSpikeCollector = {}
local glacialSpikeMarks = {}
local soulShardMarks = {}
local soulShardCollector = {}
local mindControlled = false
local inPhylactery = false
local darkEvocationCount = 1
local blizzardCount = 1
local soulFractureCount = 1
local oblivionsEchoCount = 1
local frostBlastCount = 1
local glacialWrathCount = 1
local soulReaverCollector = {}
local soulReaverCount = 0
local soulReaverSpawnTime = 0
local soulReaverMarkScheduler = nil

-- local timersHeroic = { -- XXX Old timers used before hotfix, leaving it in for now to check incase.
-- 	[100] = { -- Mana on cast_start
-- 		[347292] = 62, -- Oblivion's Echo
-- 	},
-- 	[80] = {
-- 		[346459] = 118, -- Glacial Wrath
-- 		[347292] = nil, -- Oblivion's Echo
-- 	},
-- 	[60] = {
-- 		[346459] = nil, -- Glacial Wrath
-- 		[347292] = 69.7, -- Oblivion's Echo
-- 		[348760] = 42.5, -- Frost Blast
-- 	},
-- 	[40] = {
-- 		[346459] = 69, -- Glacial Wrath
-- 		[347292] = 42.5, -- Oblivion's Echo
-- 		[348760] = nil, -- Frost Blast
-- 	},
-- 	[20] = {
-- 		[346459] = 44.1, -- Glacial Wrath
-- 		[347292] = nil, -- Oblivion's Echo
-- 		[348760] = 69.5, -- Frost Blast
-- 	},
-- }

-- local timersMythic = {
-- 	[100] = { -- Mana on cast_start
-- 		[347292] = 61, -- Oblivion's Echo
-- 	},
-- 	[80] = {
-- 		[346459] = 113, -- Glacial Wrath
-- 		[347292] = nil, -- Oblivion's Echo
-- 	},
-- 	[60] = {
-- 		[346459] = nil, -- Glacial Wrath
-- 		[347292] = 69.7, -- Oblivion's Echo
-- 		[348760] = 39, -- Frost Blast
-- 	},
-- 	[40] = {
-- 		[346459] = 69, -- Glacial Wrath
-- 		[347292] = 50, -- Oblivion's Echo
-- 		[348760] = nil, -- Frost Blast
-- 	},
-- 	[20] = {
-- 		[346459] = 50, -- Glacial Wrath
-- 		[347292] = nil, -- Oblivion's Echo
-- 		[348760] = 69.5, -- Frost Blast
-- 	},
-- }

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spikes = "Spikes" -- Short for Glacial Spikes
	L.spike = "Spike"
	L.silence = mod:SpellName(226452) -- Silence
	L.miasma = "Miasma" -- Short for Sinister Miasma
	L.glacial_winds = "Tornadoes"
	L.foul_winds = "Pushback"

	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frostbound Devoted that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 210130
end

--------------------------------------------------------------------------------
-- Initialization
--

local soulShardMarker = mod:AddMarkerOption(false, "npc", 8, -23224, 8, 7, 6, 5, 4) -- Soul Shard
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
		soulShardMarker,
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
		[355055] = L.glacial_winds, -- Glacial Winds (Tornadoes)
		[355127] = L.foul_winds, -- Foul Winds (Pushback)
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_CAST_START", "HowlingBlizzard", 354198)
	self:Log("SPELL_AURA_APPLIED", "DarkEvocation", 352530) -- No _SUCCESS on the channel
	self:Log("SPELL_AURA_APPLIED", "RelentlessHauntApplied", 355389)
	self:Log("SPELL_AURA_REMOVED", "RelentlessHauntRemoved", 355389)
	self:Log("SPELL_CAST_START", "SoulFractureStart", 362565)
	self:Log("SPELL_CAST_SUCCESS", "SoulFractureSuccess", 362565)
	self:Log("SPELL_AURA_APPLIED", "SoulExhaustionApplied", 348978)
	self:Log("SPELL_CAST_SUCCESS", "SoulShardEvent", 181113)
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "PhylacteryApplied", 348787)
	self:Log("SPELL_AURA_REMOVED", "PhylacteryRemoved", 348787)
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
	glacialSpikeCollector = {}
	glacialSpikeMarks = {}
	soulShardMarks = {}
	soulShardCollector = {}

	mindControlled = false
	inPhylactery = false

	darkEvocationCount = 1
	blizzardCount = 1
	soulFractureCount = 1
	oblivionsEchoCount = 1
	frostBlastCount = 1
	glacialWrathCount = 1

	-- Soul Fracture and Ice Shards can delay casts
	self:CDBar(348071, self:Mythic() and 10.9 or 13.8, CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
	self:CDBar(347292, 14.5, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
	self:CDBar(346459, 24.2, CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
	self:CDBar(348760, 48.5, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
	self:CDBar(352530, 51.4, CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
	self:CDBar(354198, 91, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
	self:RegisterTargetEvents("MarkUnits")
end

function mod:OnBossDisable()
	if self:GetOption("custom_on_nameplate_fixate") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MarkReavers()
	for i = 1, #soulReaverCollector do
		local guid = soulReaverCollector[i].reaverGuid
		if not mobCollector[guid] then
			local unit = self:GetUnitIdByGUID(guid)
			if unit then
				self:CustomIcon(soulReaverMarker, unit, 9-i)
				mobCollector[soulReaverCollector[i].reaverGuid] = true
			end
		end
	end
	soulReaverMarkScheduler = nil
end

function mod:MarkUnits(event, unit, guid)
	if not mobCollector[guid] then
		if soulShardCollector[guid] then
			self:CustomIcon(soulShardMarker, unit, soulShardCollector[guid])
			mobCollector[guid] = true
		end
		if glacialSpikeCollector[guid] then
			if glacialSpikeCollector[guid] > 0 then
				self:CustomIcon(glacialWrathMarker, unit, glacialSpikeCollector[guid])
			end
			glacialSpikeCollector[guid] = nil
			mobCollector[guid] = true
		end
		if self:MobId(guid) == 176974 then -- Soulreaver
			if self:GetStage() == 3 then -- Mark in Order
				soulReaverCount = soulReaverCount + 1
				local icon = soulReaverCount % 3 + 1 -- XXX FixME
				self:CustomIcon(soulReaverMarker, unit, icon)
				mobCollector[guid] = true
			elseif self:GetStage() < 3 then -- Mark using logic
				local tableCount = #soulReaverCollector
				if soulReaverCollector[guid] then
					if tableCount > 2 then -- Mark once 3 are found
						self:MarkReavers()
					end
				elseif not soulReaverMarkScheduler then -- Mark anyways after the scheduled timer is gone
					soulReaverCount = soulReaverCount + 1
					local icon = 9-(tableCount + soulReaverCount)
					self:CustomIcon(soulReaverMarker, unit, icon)
					mobCollector[guid] = true
				else
					--local range = self:GetRange(unit) -- XXX Mark based on distance from the units
					--if range then
						soulReaverCollector[tableCount+1] = {reaverGuid = guid, reaverRange = 2} --{reaverGuid = guid, reaverRange = range} XXX Range API Needed
						soulReaverCollector[guid] = true
						table.sort(soulReaverCollector,function(t1,t2) return t1.reaverRange < t2.reaverRange end)
						return
					--end
				end
			end
		end
	end
end

-- Stage One: Chains and Ice
function mod:HowlingBlizzard(args)
	self:Message(args.spellId, "cyan", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 23, CL.count:format(args.spellName, blizzardCount))
	blizzardCount = blizzardCount + 1
	self:CDBar(354198, 118.5, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
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
	self:Message(348071, "purple", CL.casting:format(CL.count:format(args.spellName, soulFractureCount)))
	self:PlaySound(348071, "alarm")

	soulShardMarks = {}
	soulShardCollector = {}
end

function mod:SoulFractureSuccess(args)
	soulFractureCount = soulFractureCount + 1
	self:CDBar(348071, soulFractureCount == 4 and 43.5 or 30.2, CL.count:format(args.spellName, soulFractureCount)) -- to _START XXX Check count 4
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

function mod:SoulShardEvent(args)
	if self:GetOption(soulShardMarker) then
		for i = 8, 4, -1 do -- 8, 7, 6, 5, 4
			if not soulShardCollector[args.sourceGUID] and not soulShardMarks[i] then
				soulShardMarks[i] = args.sourceGUID
				soulShardCollector[args.sourceGUID] = i
				return
			end
		end
	end
end

function mod:SoulExhaustionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
	self:StopBar(CL.count:format(args.spellName, soulFractureCount-1), args.destName)
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
	self:CDBar(args.spellId, 113, CL.count:format(L.spikes, glacialWrathCount))

	glacialSpikeCollector = {}
	glacialSpikeMarks = {}
end

function mod:GlacialWrathSummon(args)
	glacialSpikeCollector[args.destGUID] = tremove(glacialSpikeMarks, 1)
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
		glacialSpikeMarks[#glacialSpikeMarks+1] = playerList[args.destName] or 0 -- _REMOVED is more reliable for spike order
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
		self:CDBar(347292, oblivionsEchoCount % 2 == 0 and 61.5 or 40.5, CL.count:format(L.silence, oblivionsEchoCount)) -- XXX Need to confirm the (3)+ casts
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
		self:CDBar(348760, frostBlastCount % 2 == 0 and 40 or 70, CL.count:format(CL.meteor, frostBlastCount))
	elseif self:GetStage() == 3 then
		self:CDBar(348760, 15.8, CL.count:format(CL.meteor, frostBlastCount))
	end
end

function mod:FrostBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, CL.meteor)
		self:Flash(args.spellId)
		self:YellCountdown(args.spellId, 6)
	else
		self:PlaySound(args.spellId, "alert", nil, args.destName)
	end
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(CL.meteor, frostBlastCount-1))
end

function mod:PhylacteryApplied(args)
	if self:Me(args.destGUID) then
		inPhylactery = true
	end
end

function mod:PhylacteryRemoved(args)
	if self:Me(args.destGUID) then
		inPhylactery = false
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

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 351625 then -- Cosmetic Death
		self:StopBar(CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
		self:StopBar(CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
		self:StopBar(CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
		self:StopBar(CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
		self:StopBar(CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
		self:StopBar(CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
	end
end

function mod:VengefulDestruction(args)
	self:Message(args.spellId, "yellow", CL.casting:format(self:SpellName(249436)))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 45, self:SpellName(249436)) -- Destruction

	self:SetStage(2)
	-- XXX Starts when the first person enters, should we keep this or just ditch it?
	-- local remnant = self:GetBossId(176929) -- was only ever boss2, but just to make sure
	-- if remnant and self:GetHealth(remnant) < 34 then -- final stage 2
	-- 	--self:CDBar(355055, 3, L.glacial_winds) -- Glacial Winds
	-- 	--self:CDBar(352379, 11) -- Freezing Blast
	-- 	-- if self:Mythic() then
	-- 	-- 	self:CDBar(355127, 7, L.foul_winds) -- Foul Winds
	-- 	-- end
	-- else
	-- 	self:CDBar(352379, self:Mythic() and 3 or 7) -- Freezing Blast
	-- 	if self:Mythic() then
	-- 		self:CDBar(355127, 7, L.foul_winds) -- Foul Winds
	-- 	end
	-- end
end

function mod:NecroticSurgeApplied(args)
	if not self:IsEngaged() then return end -- starts with stacks on mythic
	if args.amount and args.amount > 4 then -- Don't show for Stage 3 (Custom message for that)
		self:NewStackMessage(args.spellId, "cyan", args.destName, args.amount)
		self:PlaySound(args.spellId, "info")
	end
	self:StopBar(CL.cast:format(self:SpellName(249436))) -- Destruction
	self:StopBar(352379) -- Freezing Blast
	self:StopBar(L.glacial_winds) -- Glacial Winds
	self:StopBar(L.foul_winds) -- Foul Winds
	if self:GetStage() == 2 then
		self:SetStage(1)
		soulFractureCount = 1
		oblivionsEchoCount = 1
		glacialWrathCount = 1
		frostBlastCount = 1
		darkEvocationCount = 1
		blizzardCount = 1

		self:CDBar(348071, 10, CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
		self:CDBar(347292, 14.5, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
		self:CDBar(346459, 24.2, CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
		self:CDBar(348760, 45.5, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
		self:CDBar(352530, 35.9, CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
		self:CDBar(354198, 89.9, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
	else -- Stage 3
		frostBlastCount = 1 -- Frost Blast
		self:CDBar(348760, 11.5, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
		self:CDBar(352348, 48.5) -- Onslaught of the Damned
	end
end

function mod:RemnantDeath()
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "info")
	self:SetStage(3)
end

function mod:FreezingBlast(args)
	if _G.GetPlayerAuraBySpellID(348787) then -- inPhylactery doesn't work for some reason?
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alarm")
		self:CDBar(args.spellId, 6.1)
	end
end

function mod:GlacialWinds(args)
	if _G.GetPlayerAuraBySpellID(348787) then -- inPhylactery doesn't work for some reason?
		self:Message(args.spellId, "cyan", L.glacial_winds)
		self:CDBar(args.spellId, 13.5, L.glacial_winds)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FoulWinds(args)
	if _G.GetPlayerAuraBySpellID(348787) then -- inPhylactery doesn't work for some reason?
		self:Message(args.spellId, "yellow", L.foul_winds)
		self:CDBar(args.spellId, 25.5, L.foul_winds)
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:UndyingWrath(args)
	self:Message(args.spellId, "red")
	self:CastBar(args.spellId, 10)
	if _G.GetPlayerAuraBySpellID(348787) then -- inPhylactery doesn't work for some reason?
		self:PlaySound(args.spellId, "warning")
	end

	self:StopBar(352379) -- Freezing Blast
	self:StopBar(L.glacial_winds) -- Glacial Winds
	self:StopBar(L.foul_winds) -- Foul Winds
end

function mod:OnslaughtOfTheDamned(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:CDBar(args.spellId, 48.6) XXX Does it even happen again?
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
	if canDo and (self:GetStage() == 3 or not inPhylactery) then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:MarchOfTheForsakenSummon(args)
		if not self:GetOption(soulReaverMarker) then return end
		local t = args.time
		if t-prev > 5 then
			prev = t
			soulReaverCollector = {}
			soulReaverCount = 0
			soulReaverSpawnTime = GetTime()
			if not soulReaverMarkScheduler then
				soulReaverMarkScheduler = self:ScheduleTimer("MarkReavers", 5)
			end
		end
	end
end
