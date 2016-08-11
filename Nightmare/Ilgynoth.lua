
--------------------------------------------------------------------------------
-- TODO List:
-- - Tuning sounds / message colors
-- - Remove alpha engaged message
-- - p1 proximity range: 5
-- - TouchOfCorruption doesnt stack on normal. Do we need warnings for that?
-- - Add mouseover / nameplate marking for Deathglare Tentacle

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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.nightmare_horror = -13188 -- Nightmare Horror
	L.nightmare_horror_icon = 209387 -- Seeping Corruption icon
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One ]]--
		-- Dominator Tentacle
		208689, -- Ground Slam
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

		--[[ Stage Two ]]--
		{209915, "COUNTDOWN"}, -- Stuff of Nightmares
		-- 210781, -- Dark Reconstitution // using Stuff of Nightmares as P2 bar
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
	self:Log("SPELL_AURA_APPLIED", "TouchOfCorruption", 209469)
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

	--[[ Stage Two ]]--
	self:Log("SPELL_AURA_APPLIED", "StuffOfNightmares", 209915)
	self:Log("SPELL_AURA_REMOVED", "StuffOfNightmaresRemoved", 209915)
	self:Log("SPELL_CAST_START", "DarkReconstitution", 210781)
	self:Log("SPELL_AURA_APPLIED", "CursedBlood", 215128)
	self:Log("SPELL_AURA_REMOVED", "CursedBloodRemoved", 215128)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Ilgynoth Engaged (Beta v2)", "ability_malkorok_blightofyshaarj_red")
	fixateOnMe = nil
	self:CDBar(208689, 11.5) -- Ground Slam
	self:Bar("nightmare_horror", 69, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Dominator Tentacle
function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("208689", nil, true) then -- Ground Slam
		self:Message(208689, "Personal", "Alarm", CL.you:format(self:SpellName(208689)))
		self:Flash(208689)
		self:Say(208689)
	end
end

function mod:GroundSlam(args)
	-- XXX Do we want a message with the target(s)? They only have 2s to react, personal warning is in RAID_BOSS_WHISPER
	self:CDBar(args.spellId, 20.5)
end

function mod:NightmarishFury(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 10)
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

function mod:NightmareExplosion(args)
	if fixateOnMe then -- Explosion has a small radius, you could only get hit if you are fixated and near the Eye
		self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
	end
end

-- Nightmare Horror
function mod:SummonNightmareHorror(args)
	self:Message("nightmare_horror", "Important", "Info", CL.spawned:format(self:SpellName(L.nightmare_horror)), L.nightmare_horror_icon)
	self:Bar("nightmare_horror", 220, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror
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
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:TargetBar(args.spellId, args.destName, 10)
		end
	end
end

-- Deathglare Tentacle
function mod:MindFlay(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Info")
end

--[[ Stage Two ]]--
function mod:StuffOfNightmares(args)
	self:Message(args.spellId, "Neutral", "Info")
	self:CDBar(208689, 11.5) -- Ground Slam
	self:Bar("nightmare_horror", 99, L.nightmare_horror, L.nightmare_horror_icon) -- Summon Nightmare Horror
end

function mod:StuffOfNightmaresRemoved(args)
	self:Message(args.spellId, "Neutral", "Info", CL.removed:format(args.spellName))
	self:Bar(args.spellId, 60) -- 60s Intermission
end

function mod:DarkReconstitution(args)
	self:Bar(209915, 50) -- cast after 10s in phase, so only fine tuning StuffOfNightmares bar
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
