
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mannoroth", 1026, 1395)
if not mod then return end
mod:RegisterEnableMob(91305, 91241, 91349) -- Fel Iron Summoner, Doom Lord, Mannoroth
mod.engageId = 1795

--------------------------------------------------------------------------------
-- Locals
--

local portalsClosed = 0
local phase = 1
local curseCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.doomLord = "Doom Lord portal closed!"
	L.imp = "Imp portal closed!"
	L.infernal = "Infernal portal closed!"

	L.gaze = "Gaze (%d)"
	L.felseeker_message = "%s (%d) %dy" -- same as Margok's branded_say

	L.custom_off_gaze_marker = "Mannoroth's Gaze marker"
	L.custom_off_gaze_marker_desc = "Mark the targets of Mannoroth's Gaze with {rt1}{rt2}{rt3}, requires promoted or leader."
	L.custom_off_gaze_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mannoroth ]]--
		181799, -- Shadowforce
		{181354, "TANK"}, -- Glaive Combo
		{181359, "TANK"}, -- Massive Blast
		181557, -- Fel Hellstorm
		{181597, "SAY"}, -- Mannoroth's Gaze
		"custom_off_gaze_marker",
		181735, -- Felseeker
		{186362, "SAY", "FLASH"}, -- Wrath of Gul'dan
		--[[ Adds ]]--
		{181275, "SAY", "ICON", "FLASH"}, -- Curse of the Legion
		{181119, "TANK"}, -- Doom Spike
		{181099, "PROXIMITY", "FLASH", "SAY"}, -- Mark of Doom
		181126, -- Shadow Bolt Volley
		181255, -- Fel Imp-losion
		181180, -- Inferno
		--[[ General ]]--
		"stages",
	}, {
		[181799] = mod.displayName,
		[181275] = "adds",
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "MannorothsGazeCast", 181597, 182006)
	self:Log("SPELL_AURA_APPLIED", "MannorothsGaze", 181597, 182006)
	self:Log("SPELL_AURA_REMOVED", "MannorothsGazeRemoved", 181597, 182006)
	self:Log("SPELL_CAST_START", "Shadowforce", 181799, 182084)
	self:Log("SPELL_CAST_START", "Felseeker", 181793, 181792, 181738) -- 10, 20, 30 yds
	self:Log("SPELL_CAST_START", "EmpoweredFelseeker", 182077, 182076, 182040)
	self:Log("SPELL_CAST_START", "GlaiveThrust", 183377, 185831)
	self:Log("SPELL_AURA_APPLIED", "MassiveBlast", 181359, 185821)
	self:Log("SPELL_CAST_SUCCESS", "FelHellstorm", 181557)
	self:Log("SPELL_DAMAGE", "FelHellstormDamage", 181566)
	self:Log("SPELL_MISSED", "FelHellstormDamage", 181566)
	-- Adds
	self:Log("SPELL_CAST_SUCCESS", "CurseOfTheLegionSuccess", 181275) -- APPLIED can miss
	self:Log("SPELL_AURA_APPLIED", "CurseOfTheLegion", 181275)
	self:Log("SPELL_AURA_REMOVED", "CurseOfTheLegionRemoved", 181275)
	self:Log("SPELL_AURA_APPLIED", "MarkOfDoom", 181099)
	self:Log("SPELL_AURA_REMOVED", "MarkOfDoomRemoved", 181099)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomSpike", 181119)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 181126)
	self:Log("SPELL_SUMMON", "FelImplosion", 181255)
	self:Log("SPELL_SUMMON", "Inferno", 181180)
	-- General
	self:Log("SPELL_AURA_APPLIED", "WrathOfGuldan", 186362)
	self:Log("SPELL_AURA_REMOVED", "P1PortalClosed", 185147, 185175, 182212) -- Doom Lords, Imps, Infernals
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	portalsClosed = 0
	phase = 1
	curseCount = 1
	if self:Mythic() then -- non-mythic starts after the portals close
		self:Bar("stages", 15.5, 108508) -- Mannoroth's Fury
		self:CDBar(181275, 24) -- Curse of the Legion
		self:CDBar(181557, 30) -- Fel Hellstorm
		self:CDBar(181354, 43) -- Glaive Combo
		self:Bar(181255, 46.5) -- Fel Imp-losion
		self:CDBar(181735, 57) -- Felseeker
		self:Bar(181180, 70) -- Infernals
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Adds

do
	local list = mod:NewTargetList()
	function mod:MarkOfDoom(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(args.spellName, #list))
			self:TargetBar(args.spellId, 15, args.destName)
			self:OpenProximity(args.spellId, 20)
			self:Flash(args.spellId)
		end
	end
end

function mod:MarkOfDoomRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
		self:CloseProximity(args.spellId)
	end
end

function mod:DoomSpike(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Positive", nil, CL.casting:format(args.spellName))
end

function mod:FelImplosion(args)
	if phase > 1 then
		self:CDBar(args.spellId, self:Mythic() and 49 or 30)
	end
end

function mod:Inferno(args)
	if phase > 1 then
		self:CDBar(args.spellId, self:Mythic() and 55 or 35)
	end
end

-- Mannoroth

do
	local list = mod:NewTargetList()
	function mod:WrathOfGuldan(args)
		list[#list + 1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(args.spellName, #list))
			self:Flash(args.spellId)
		end
	end
end

function mod:GlaiveThrust(args)
	self:Message(181354, "Attention", "Warning", args.spellName)
end

function mod:MassiveBlast(args)
	self:TargetMessage(181359, args.destName, "Attention", nil, args.spellName)
end

function mod:MannorothsGazeCast(args)
	self:Message(181597, "Attention", "Info", CL.casting:format(args.spellName))
	self:Bar(181597, 47, args.spellName)
end

do
	local list, isOnMe = {}, nil
	local function gazeSay(self, spellName)
		table.sort(list)
		for i = 1, #list do
			local target = list[i]
			if target == isOnMe then
				local gaze = L.gaze:format(i)
				self:Say(181597, gaze)
				self:Message(181597, "Positive", nil, CL.you:format(gaze))
			end
			if self:GetOption("custom_off_gaze_marker") then
				SetRaidTarget(target, i)
			end
			list[i] = self:ColorName(target)
		end
		self:TargetMessage(181597, list, "Attention", "Alarm")
		isOnMe = nil
	end

	function mod:MannorothsGaze(args)
		if self:Me(args.destGUID) then
			isOnMe = args.destName
		end

		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer(gazeSay, 0.3, self, args.spellName)
		end
	end

	function mod:MannorothsGazeRemoved(args)
		if self:GetOption("custom_off_gaze_marker") then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:Shadowforce(args)
	self:Message(181799, "Important", "Long", CL.casting:format(args.spellName))
	self:Bar(181799, 8, CL.cast:format(args.spellName))
	self:CDBar(181799, 52, args.spellName)
end

function mod:CurseOfTheLegionSuccess(args)
	curseCount = curseCount + 1
	if self:Mythic() then
		self:Bar(args.spellId, 65, CL.count:format(args.spellName, curseCount))
	end
end

function mod:CurseOfTheLegion(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm", CL.count:format(args.spellName, curseCount-1))
	self:TargetBar(args.spellId, 20, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:CurseOfTheLegionRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(args.spellId)
	self:Message(args.spellId, "Important", "Warning", CL.spawned:format(self:SpellName(-11813))) -- Doom Lord
	self:Bar(181099, 12) -- Mark of Doom
end

function mod:Felseeker(args)
	if args.spellId == 181793 then
		self:Message(181735, "Positive", "Alert", L.felseeker_message:format(args.spellName, 1, 10))
	elseif args.spellId == 181792 then
		self:Message(181735, "Positive", "Alert", L.felseeker_message:format(args.spellName, 2, 20))
	elseif args.spellId == 181738 then
		self:Message(181735, "Positive", "Alert", L.felseeker_message:format(args.spellName, 3, 30))
	end
end

function mod:EmpoweredFelseeker(args)
	if args.spellId == 182077 then
		self:Message(181735, "Positive", "Alert", CL.count:format(args.spellName, 1))
	elseif args.spellId == 182076 then
		self:Message(181735, "Positive", "Alert", CL.count:format(args.spellName, 2))
	elseif args.spellId == 182040 then
		self:Message(181735, "Positive", "Alert", CL.count:format(args.spellName, 3))
	end
end

function mod:FelHellstorm(args)
	self:CDBar(args.spellId, 36)
end

do
	local prev = 0
	function mod:FelHellstormDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(181557, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

-- Phases

do
	local tbl = {
		[185147] = L.doomLord,
		[185175] = L.imp,
		[182212] = L.infernal,
	}
	function mod:P1PortalClosed(args)
		portalsClosed = portalsClosed + 1
		self:Message("stages", "Neutral", nil, tbl[args.spellId], false)
		if portalsClosed == 3 then
			self:ScheduleTimer("Message", 1, "stages", "Neutral", "Info", CL.stage:format(2), false)
			phase = 2
			if not self:Mythic() then -- already starting mythic timers on :OnEnage()
				self:CDBar(181557, 33) -- Fel Hellstorm
				self:CDBar(181597, 40) -- Mannoroth's Gaze
				self:CDBar(181354, 45) -- Glaive Combo
				self:CDBar(181735, 60) -- Felseeker
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	--181156 = Summon Adds: Mythic, when Mannoroth spawns at ~17sec, not sure what it actually does (Doomguards?)

	if spellId == 181301 then -- Summon Adds: P2 & Mythic P3
		self:Bar(181255, 25) -- Fel Imp-losion
		if self:Mythic() then
			self:StopBar(CL.count:format(self:SpellName(181275), curseCount))
			curseCount = 1
			self:Bar(181275, 45, CL.count:format(self:SpellName(181275), curseCount)) -- Curse of the Legion
		else
			self:Bar(181180, 48) -- Inferno
		end

	elseif spellId == 182262 then -- Summon Adds: P3
		self:StopBar(181255) -- Fel Imp-losion
		self:Bar(181180, 28) -- Inferno

	elseif spellId == 182263 then -- P3 Transform
		-- ~7s before: CHAT_MSG_MONSTER_YELL#Fear not, Mannoroth. The fel gift empowers you... Make them suffer!#Gul'dan
		self:Message("stages", "Neutral", "Info", CL.stage:format(3), false)
		phase = 3
		self:CDBar(181557, 24) -- Fel Hellstorm
		self:CDBar(181799, 30) -- Shadowforce
		self:CDBar(181354, 36) -- Glaive Combo
		self:CDBar(181597, 40) -- Mannoroth's Gaze
		self:CDBar(181735, 60) -- Felseeker
		if self:Mythic() then
			self:Bar(186362, 5) -- Wrath of Gul'dan
		end

	elseif spellId == 185690 then -- P4 Transform
		-- ~8s before: CHAT_MSG_MONSTER_YELL#These mortals cannot be this strong. Gul'dan, do something!#Mannoroth
		self:Message("stages", "Neutral", "Info", CL.stage:format(4), false)
		phase = 4
		self:StopBar(181557) -- Fel Hellstorm
		self:StopBar(181597) -- Mannoroth's Gaze
		self:StopBar(181799) -- Shadowforce
		self:StopBar(181735) -- Felseeker
		self:StopBar(181354) -- Glaive Combo
		self:CDBar(181557, 14, 181948) -- Empowered Fel Hellstorm
		self:CDBar(181354, 23, 187347) -- Empowered Glaive Combo
		self:CDBar(181799, 45, 182084) -- Empowered Shadowforce
		self:CDBar(181597, 30, 182006) -- Empowered Mannoroth's Gaze
		self:CDBar(181735, 60, 182077) -- Empowered Felseeker
		if self:Mythic() then
			self:Bar(186362, 5) -- Wrath of Gul'dan
			self:Bar(181255, 19) -- Fel Imp-losion
		end

	elseif spellId == 181735 then -- Felseeker
		self:CDBar(181735, 50, phase == 4 and 182077) -- [Empowered] Felseeker

	elseif spellId == 181354 then -- Glaive Combo
		self:CDBar(181354, 30.5, phase == 4 and 187347) -- [Empowered] Glaive Combo

	end
end

