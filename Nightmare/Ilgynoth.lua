
--------------------------------------------------------------------------------
-- TODO List:
-- - TouchOfCorruption doesnt stack on normal. Do we need warnings for that?
-- - SummonNightmareHorror cd
-- - Is the percentage per blob the same (5%) for every difficulty?
--   LFR (?) - Normal (✔) - Heroic (✔) - Mythic (?)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Il'gynoth", 1094, 1738)
if not mod then return end
mod:RegisterEnableMob(105906, 105393, 105304) -- Eye of Il'gynoth, Il'gynoth, Dominator Tentacle
mod.engageId = 1873
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local fixateOnMe = nil
local insidePhase = 1
local deathglareMarked = {} -- save GUIDs of marked mobs
local deathglareMarks  = { [6] = true, [5] = true, [4] = true, [3] = true } -- available marks to use

local phaseStartTime = 0

local spawnData = {
	[1] = { -- Outside Phase 1
		[-13190] = { -- Deathglare Tentacle, Mind Flay (208697) SPELL_CAST_START
			{ 26.5, 1}, -- 1x
			{ 88.0, 2}, -- 2x
			{183.0, 1}, -- 1x
		},
		[-13191] = { -- Corruptor Tentacle, Spew Corruption (208929) SPELL_CAST_START
			{ 82.0, 2}, -- 2x
		},
	},
	[2] = { -- Outside Phase 2, time after Stuff of Nightmares (209915) applied
		[-13190] = { -- Deathglare Tentacle, Mind Flay (208697) SPELL_CAST_START
			{ 21.5, 2}, -- 2x
			{116.5, 2}, -- 2x
		},
		[-13191] = { -- Corruptor Tentacle, Spew Corruption (208929) SPELL_CAST_START
			{ 45.0, 3}, -- 3x
			{140.0, 2}, -- 2x
			{175.0, 4}, -- 4x
		},
	}
}
local nextCorruptorText = "" -- used to stop the bars
local nextDeathglareText = "" -- used to stop the bars
local bloodsRemaining = 20

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.forces = -13187
	L.forces_icon = "spell_nature_dryaddispelmagic" -- some weird icon, only used in options

	L.nightmare_horror = -13188 -- Nightmare Horror
	L.nightmare_horror_icon = 209387 -- Seeping Corruption icon

	L.corruptor_tentacle = -13191 -- Corruptor Tentacle
	L.corruptor_tentacle_icon = 208929 -- Spew Corruption icon

	L.deathglare_tentacle = -13190 -- Deathglare Tentacle
	L.deathglare_tentacle_icon = 208697 -- Mind Flay icon

	L.custom_off_deathglare_marker = "Deathglare Tentacle marker"
	L.custom_off_deathglare_marker_desc = "Mark Deathglare Tentacles with {rt6}{rt5}{rt4}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, having nameplates enabled or quickly mousing over the spears is the fastest way to mark them.|r"
	L.custom_off_deathglare_marker_icon = 6

	L.bloods_remaining = "%d Bloods remaining"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One ]]--
		"forces",

		-- Dominator Tentacle
		{208689, "SAY", "FLASH"}, -- Ground Slam
		{215234, "TANK"}, -- Nightmarish Fury

		-- Nightmare Ichor
		210099, -- Fixate
		209469, -- Touch of Corruption
		209471, -- Nightmare Explosion

		-- Nightmare Horror
		"nightmare_horror", -- Nightmare Horror
		210984, -- Eye of Fate

		-- Corruptor Tentacle
		{208929, "SAY", "FLASH"}, -- Spew Corruption

		-- Deathglare Tentacle
		208697, -- Mind Flay
		"custom_off_deathglare_marker",

		--[[ Stage Two ]]--
		209915, -- Stuff of Nightmares
		{210781, "COUNTDOWN"}, -- Dark Reconstitution
		223121, -- Final Torpor
		{215128, "SAY", "FLASH", "PROXIMITY"}, -- Cursed Blood
	},{
		["forces"] = -13184, -- Stage One
		[208689] = -13189, -- Dominator Tentacle
		[210099] = -13186, -- Nightmare Ichor
		["nightmare_horror"] = -13188, -- Nightmare Horror (this looks like shit)
		[208929] = -13191, -- Corruptor Tentacle
		[208697] = -13190, -- Deathglare Tentacle
		[209915] = -13192, -- Stage Two
	}
end

function mod:OnBossEnable()
	--[[ Stage One ]]--
	-- Dominator Tentacle
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:Log("SPELL_CAST_START", "GroundSlam", 208689)
	self:Log("SPELL_AURA_APPLIED", "NightmarishFury", 215234)
	self:Log("SPELL_DAMAGE", "EyeDamage", 210048) -- Nightmare Explosion, only hits the Eye

	-- Nightmare Ichor
	self:Log("SPELL_AURA_APPLIED", "Fixate", 210099)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 210099)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TouchOfCorruption", 209469)
	self:Log("SPELL_CAST_START", "NightmareExplosion", 209471)

	-- Nightmare Horror
	self:Log("SPELL_AURA_APPLIED", "SummonNightmareHorror", 209387) -- Seeping Corruption, buffed on spawn
	self:Log("SPELL_AURA_APPLIED", "EyeOfFate", 210984)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EyeOfFate", 210984)

	-- Corruptor Tentacle
	self:Log("SPELL_CAST_START", "CorruptorTentacleSpawn", 208929) -- They start casting Spew Corruption instantly
	self:Log("SPELL_CAST_SUCCESS", "SpewCorruption", 208929)

	-- Deathglare Tentacle
	self:Log("SPELL_CAST_START", "MindFlay", 208697) -- Also used for spawn messages
	self:Death("DeathglareDeath", 105322)

	--[[ Stage Two ]]--
	self:Log("SPELL_AURA_APPLIED", "StuffOfNightmares", 209915)
	self:Log("SPELL_AURA_REMOVED", "StuffOfNightmaresRemoved", 209915)
	self:Log("SPELL_CAST_START", "DarkReconstitution", 210781)
	self:Log("SPELL_CAST_START", "FinalTorpor", 223121)
	self:Log("SPELL_AURA_APPLIED", "CursedBlood", 215128)
	self:Log("SPELL_AURA_REMOVED", "CursedBloodRemoved", 215128)
end

function mod:OnEngage()
	wipe(mobCollector)
	fixateOnMe = nil
	insidePhase = 1
	bloodsRemaining = 20
	self:CDBar(208689, 11.5) -- Ground Slam
	self:CDBar("nightmare_horror", 65, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror

	phaseStartTime = GetTime()
	self:StartSpawnTimer(-13190, 1)
	self:StartSpawnTimer(-13191, 1)


	wipe(deathglareMarked)
	if self:GetOption("custom_off_deathglare_marker") then
		deathglareMarks = { [6] = true, [5] = true, [4] = true, [3] = true }

		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "DeathglareMark")
		self:RegisterEvent("UNIT_TARGET", "DeathglareMark")
		self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "DeathglareMark")
	end
end

function mod:OnBossDisable()
	wipe(deathglareMarked)
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:UnregisterEvent("UNIT_TARGET")
	self:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:StartSpawnTimer(addType, count)
	--local data = self:Mythic() and spawnDataMythic or self:LFR() and spawnDataLFR or spawnData TODO
	local data = spawnData
	local info = data and data[insidePhase][addType][count]
	if not info then
		-- all out of spawn data
		return
	end

	local time, numSpawns = unpack(info)
	local length = floor(time - (GetTime() - phaseStartTime))

	if addType == -13190 then
		nextDeathglareText = CL.count:format(self:SpellName(addType), numSpawns)
		self:Bar("forces", length, nextDeathglareText, L.deathglare_tentacle_icon)
	else
		nextCorruptorText = CL.count:format(self:SpellName(addType), numSpawns)
		self:CDBar("forces", length, nextCorruptorText, L.corruptor_tentacle_icon)
	end

	self:ScheduleTimer("StartSpawnTimer", length, addType, count+1)
end

function mod:DeathglareMark(event, firedUnit)
	local unit = event == "NAME_PLATE_UNIT_ADDED" and firedUnit or firedUnit and firedUnit.."target" or "mouseover"
	local guid = UnitGUID(unit)

	if self:MobId(guid) == 105322 and not deathglareMarked[guid] then
		local icon = next(deathglareMarks)
		if icon then -- At least one icon unused
			SetRaidTarget(unit, icon)
			deathglareMarks[icon] = nil -- Mark is no longer available
			deathglareMarked[guid] = icon -- Save the tentacle we marked and the icon we marked it with
		end
	end
end

function mod:DeathglareDeath(args)
	if deathglareMarked[args.destGUID] then -- Did we mark the Tentacle?
		deathglareMarks[deathglareMarked[args.destGUID]] = true -- Mark used is available again
	end
end

-- Dominator Tentacle
function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("208689", nil, true) then -- Ground Slam
		self:Message(208689, "Personal", "Alarm", CL.you:format(self:SpellName(208689)))
		self:Flash(208689)
		self:Say(208689)
	end
end

function mod:GroundSlam(args)
	-- Personal warning is in RAID_BOSS_WHISPER above
	self:CDBar(args.spellId, 20.5)
end

do
	local prev = 0
	function mod:NightmarishFury(args)
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Urgent")
			self:Bar(args.spellId, 10)
		end
	end
end

function mod:EyeDamage(args)
	bloodsRemaining = bloodsRemaining - 1
	if (bloodsRemaining % 5 == 0 or bloodsRemaining < 5) and bloodsRemaining > 0 then
		self:Message("forces", "Positive", nil, L.bloods_remaining:format(bloodsRemaining), false)
	end
end

-- Nightmare Ichor
function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
		fixateOnMe = true
	end
end

function mod:FixateRemoved(args)
	if self:Me(args.destGUID) then
		fixateOnMe = nil
	end
end

function mod:TouchOfCorruption(args)
	local amount = args.amount or 1
	if amount % 2 == 0 and (self:Me(args.destGUID) or (amount > 5 and self:Healer())) then
		self:StackMessage(args.spellId, args.destName, amount, "Important")
	end
end

do
	local prev = 0
	function mod:NightmareExplosion(args)
		local t = GetTime()
		if fixateOnMe and t-prev > 3 then -- Explosion has a small radius, you could only get hit if you are fixated and near the Eye
			prev = t
			self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
		end
	end
end

-- Nightmare Horror
function mod:SummonNightmareHorror(args)
	self:Message("nightmare_horror", "Important", "Info", CL.spawned:format(self:SpellName(L.nightmare_horror)), L.nightmare_horror_icon)
	self:Bar("nightmare_horror", 220, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror < TODO beta timer, need live data
	if self:Tank() or self:Healer() then
		self:CDBar(210984, 10) -- Deathglare
	end
end

function mod:EyeOfFate(args)
	if self:Tank() or self:Healer() then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Important", self:Tank() and amount > 1 and "Warning")
		self:CDBar(args.spellId, 10)
	end
end

-- Corruptor Tentacle
do
	local prev = 0
	function mod:CorruptorTentacleSpawn(args)
		if not mobCollector[args.sourceGUID] then
			mobCollector[args.sourceGUID] = true
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "Neutral", "Info", CL.spawned:format(self:SpellName(L.corruptor_tentacle)), L.corruptor_tentacle_icon)
			end
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:SpewCorruption(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent", "Alert")
		end

		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 10, args.destName)
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

-- Deathglare Tentacle
do
	local prev = 0
	function mod:MindFlay(args)
		if not mobCollector[args.sourceGUID] then
			mobCollector[args.sourceGUID] = true
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "Neutral", "Info", CL.spawned:format(self:SpellName(L.deathglare_tentacle)), L.deathglare_tentacle_icon)
			end
		end

		if self:Interrupter(args.sourceGUID) then -- avoid spam
			self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
		end
	end
end

--[[ Stage Two ]]--
function mod:StuffOfNightmares(args)
	if IsEncounterInProgress() then -- Gets buffed when the boss spawns
		self:Message(args.spellId, "Neutral", "Info")
		self:Bar("nightmare_horror", 99, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror
		insidePhase = insidePhase + 1

		phaseStartTime = GetTime()
		self:StartSpawnTimer(-13190, 1)
		self:StartSpawnTimer(-13191, 1)

		bloodsRemaining = 20
	end
end

function mod:StuffOfNightmaresRemoved(args)
	self:Message(args.spellId, "Neutral", "Info", CL.removed:format(args.spellName))

	self:StopBar(L.nightmare_horror)
	self:StopBar(nextCorruptorText)
	self:StopBar(nextDeathglareText)

	-- The boss casts the "Intermission ending" spell after 10s in the phase, but
	-- we want the bars as soon as the phase starts. This requires hard coding the
	-- spell ids.
	-- Intermission 1: Dark Reconstitution (210781), 50+10s (heroic)
	-- Intermission 2: FinalTorpor (223121), 90+10s (heroic)
	-- In mod:DarkReconstitution() and mod:FinalTorpor() we overwrite the bars
	-- started here, just to make sure. It's just me being paranoid.
	local intermissionSpellId = insidePhase == 1 and 210781 or 223121
	self:Bar(intermissionSpellId, insidePhase == 1 and 60 or 100, CL.cast:format(self:SpellName(intermissionSpellId)))
end

function mod:DarkReconstitution(args)
	self:Bar(args.spellId, 50, CL.cast:format(args.spellName)) -- cast after 10s in phase, overwriting bar started in mod:StuffOfNightmaresRemoved()
end

function mod:FinalTorpor(args)
	self:Bar(args.spellId, 90, CL.cast:format(args.spellName)) -- cast after 10s in phase, overwriting bar started in mod:StuffOfNightmaresRemoved()
end

do
	local proxList, isOnMe, scheduled = {}, nil, nil

	local function warn(self, spellId)
		if not isOnMe then
			self:Message(spellId, "Attention", "Alert")
		end
		scheduled = nil
	end

	function mod:CursedBlood(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:TargetBar(args.spellId, 8, args.destName)
			self:OpenProximity(args.spellId, 11)
			self:ScheduleTimer("Say", 5, args.spellId, 3, true)
			self:ScheduleTimer("Say", 6, args.spellId, 2, true)
			self:ScheduleTimer("Say", 7, args.spellId, 1, true)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 11, proxList)
		end

		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId)
			self:CDBar(args.spellId, 15)
		end
	end

	function mod:CursedBloodRemoved(args)
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
				self:OpenProximity(args.spellId, 11, proxList)
			end
		end
	end
end
