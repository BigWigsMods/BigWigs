
--------------------------------------------------------------------------------
-- TODO List:
-- - TouchOfCorruption doesnt stack on normal. Do we need warnings for that?
-- - SummonNightmareHorror cd

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

local fixateOnMe = nil
local insidePhase = 1
local deathglareMarked = {} -- save GUIDs of marked mobs
local deathglareMarks  = { [6] = true, [5] = true, [4] = true, [3] = true } -- available marks to use

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.nightmare_horror = -13188 -- Nightmare Horror
	L.nightmare_horror_icon = 209387 -- Seeping Corruption icon

	L.custom_off_deathglare_marker = "Deathglare Tentacle marker"
	L.custom_off_deathglare_marker_desc = "Mark Deathglare Tentacles with {rt6}{rt5}{rt4}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, having nameplates enabled or quickly mousing over the spears is the fastest way to mark them.|r"
	L.custom_off_deathglare_marker_icon = 6
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One ]]--
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
		208929, -- Spew Corruption

		-- Deathglare Tentacle
		208697, -- Mind Flay
		"custom_off_deathglare_marker",

		--[[ Stage Two ]]--
		209915, -- Stuff of Nightmares
		{210781, "COUNTDOWN"}, -- Dark Reconstitution
		223121, -- Final Torpor
		{215128, "SAY", "FLASH", "PROXIMITY"}, -- Cursed Blood

		"berserk",
	},{
		[208689] = -13189, -- Dominator Tentacle
		[210099] = -13186, -- Nightmare Ichor
		["nightmare_horror"] = -13188, -- Nightmare Horror (this looks like shit)
		[208929] = -13191, -- Corruptor Tentacle
		[209915] = -13192, -- Stage Two
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	--[[ Stage One ]]--
	-- Dominator Tentacle
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:Log("SPELL_CAST_START", "GroundSlam", 208689)
	self:Log("SPELL_AURA_APPLIED", "NightmarishFury", 215234)

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
	self:Log("SPELL_AURA_APPLIED", "SpewCorruption", 208929)

	-- Deathglare Tentacle
	self:Log("SPELL_CAST_START", "MindFlay", 208697)
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
	fixateOnMe = nil
	insidePhase = 1
	self:CDBar(208689, 11.5) -- Ground Slam
	self:Bar("nightmare_horror", 85, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror

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
	local list = mod:NewTargetList()
	function mod:SpewCorruption(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "Urgent", "Alert")
		end

		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 10, args.destName)
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

-- Deathglare Tentacle
function mod:MindFlay(args)
	if self:Interrupter(args.sourceGUID) then -- avoid spam
		self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
	end
end

--[[ Stage Two ]]--
function mod:StuffOfNightmares(args)
	if IsEncounterInProgress() then -- Gets buffed when the boss spawns
		self:Message(args.spellId, "Neutral", "Info")
		self:CDBar(208689, 11.5) -- Ground Slam
		self:Bar("nightmare_horror", 99, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror
		insidePhase = insidePhase + 1
	end
end

function mod:StuffOfNightmaresRemoved(args)
	self:Message(args.spellId, "Neutral", "Info", CL.removed:format(args.spellName))

	self:StopBar(L.nightmare_horror)

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
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:CursedBlood(args)
		if self:Me(args.destGUID) then
			isOnMe = true
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

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Alert")
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
