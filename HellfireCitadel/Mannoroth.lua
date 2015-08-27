
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mannoroth", 1026, 1395)
if not mod then return end
mod:RegisterEnableMob(91305, 91241, 91349) -- Fel Iron Summoner, Doom Lord, Mannoroth
mod.engageId = 1795
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local portalsClosed = 0
local phase = 1
local curseCount = 1
local markOfDoomOnMe = nil
local markOfDoomTargets = {}
local wrathOfGuldanOnMe = nil
local wrathOfGuldanTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L["185147"] = "Doom Lord portal closed!"
	L["185175"] = "Imp portal closed!"
	L["182212"] = "Infernal portal closed!"

	L.gaze = "Gaze (%d)"
	L.felseeker_message = "%s (%d) %dy" -- same as Margok's branded_say

	L.custom_off_gaze_marker = "Mannoroth's Gaze marker"
	L.custom_off_gaze_marker_desc = "Mark the targets of Mannoroth's Gaze with {rt1}{rt2}{rt3}, requires promoted or leader."
	L.custom_off_gaze_marker_icon = 1

	L.custom_off_doom_marker = "Mark of Doom marker"
	L.custom_off_doom_marker_desc = "On Mythic difficulty, mark the targets of Mark of Doom with {rt1}{rt2}{rt3}, requires promoted or leader."
	L.custom_off_doom_marker_icon = 1

	L.custom_off_wrath_marker = "Wrath of Gul'dan marker"
	L.custom_off_wrath_marker_desc = "Mark the targets of Wrath of Gul'dan with {rt8}{rt7}{rt6}{rt5}{rt4}, requires promoted or leader."
	L.custom_off_wrath_marker_icon = 8
end

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
		{186362, "PROXIMITY", "FLASH", "SAY"}, -- Wrath of Gul'dan
		"custom_off_wrath_marker",
		{190482, "SAY"}, -- Gripping Shadows
		190070, -- Overflowing Fel Energy
		--[[ Adds ]]--
		{181275, "SAY", "ICON", "FLASH"}, -- Curse of the Legion
		{181119, "TANK"}, -- Doom Spike
		{181099, "PROXIMITY", "FLASH", "SAY"}, -- Mark of Doom
		"custom_off_doom_marker",
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
	self:Log("SPELL_AURA_APPLIED", "ShadowforceApplied", 181841, 182088)
	self:Log("SPELL_CAST_START", "Felseeker", 181793, 181792, 181738) -- 10, 20, 30 yds
	self:Log("SPELL_CAST_START", "EmpoweredFelseeker", 182077, 182076, 182040)
	self:Log("SPELL_CAST_START", "GlaiveThrust", 183377, 185831)
	self:Log("SPELL_AURA_APPLIED", "MassiveBlast", 181359, 185821)
	self:Log("SPELL_CAST_SUCCESS", "FelHellstorm", 181557)
	self:Log("SPELL_DAMAGE", "FelDamage", 190070) -- Overflowing Fel Energy
	self:Log("SPELL_MISSED", "FelDamage", 190070) -- Overflowing Fel Energy
	-- Adds
	self:Log("SPELL_CAST_SUCCESS", "CurseOfTheLegionSuccess", 181275) -- APPLIED can miss
	self:Log("SPELL_AURA_APPLIED", "CurseOfTheLegion", 181275)
	self:Log("SPELL_AURA_REMOVED", "CurseOfTheLegionRemoved", 181275)
	self:Log("SPELL_CAST_START", "MarkOfDoomCast", 181099)
	self:Log("SPELL_AURA_APPLIED", "MarkOfDoom", 181099)
	self:Log("SPELL_AURA_REMOVED", "MarkOfDoomRemoved", 181099)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomSpike", 181119)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 181126)
	self:Log("SPELL_SUMMON", "FelImplosion", 181255)
	self:Log("SPELL_SUMMON", "Inferno", 181180)
	-- General
	self:Log("SPELL_AURA_APPLIED", "WrathOfGuldan", 186362)
	self:Log("SPELL_AURA_REMOVED", "WrathOfGuldanRemoved", 186362)
	self:Log("SPELL_AURA_APPLIED", "GrippingShadows", 190482)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrippingShadows", 190482)
	self:Log("SPELL_AURA_REMOVED", "P1PortalClosed", 185147, 185175, 182212) -- Doom Lords, Imps, Infernals
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Death("DoomLordDies", 91241) -- Doom Lord
end

function mod:OnEngage()
	portalsClosed = 0
	phase = 1
	curseCount = 1
	wipe(markOfDoomTargets)
	wipe(wrathOfGuldanTargets)
	markOfDoomOnMe = nil
	wrathOfGuldanOnMe = nil
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

local function updateProximity(self)
	local showMark = self:CheckOption(181099, "PROXIMITY") -- Mark of Doom http://www.wowhead.com/spell=181102 says Radius: 20 yards
	local showWrath = self:CheckOption(186362, "PROXIMITY") -- Wrath of Gul'dan http://www.wowhead.com/spell=186408 says Radius: 15 yards
	if showMark and markOfDoomOnMe then
		self:OpenProximity(181099, 21)
	elseif showMark and #markOfDoomTargets > 0 then
		self:OpenProximity(181099, 21, markOfDoomTargets)
	elseif showWrath and wrathOfGuldanOnMe then
		self:OpenProximity(186362, 16)
	elseif showWrath and #wrathOfGuldanTargets > 0 then
		self:OpenProximity(186362, 16, wrathOfGuldanTargets)
	end
end

-- Adds

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

do
	local list, timer = mod:NewTargetList(), nil
	function mod:MarkOfDoomCast(args)
		wipe(list)
		self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
		self:CDBar(args.spellId, 30)
	end

	function mod:MarkOfDoom(args)
		list[#list+1] = args.destName
		local count = #list

		if count == 1 then
			timer = self:ScheduleTimer("TargetMessage", 2, args.spellId, list, "Attention", "Alarm")
		end

		if self:Me(args.destGUID) then
			self:CancelTimer(timer)
			timer = nil
			markOfDoomOnMe = self:Mythic() and CL.count_icon:format(self:SpellName(28836), count, count) or CL.count:format(self:SpellName(28836), count) -- 28836 = "Mark"
			self:Say(args.spellId, self:Mythic() and CL.count_rticon:format(self:SpellName(28836), count, count) or CL.count:format(self:SpellName(28836), count))
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm", markOfDoomOnMe)
			self:TargetBar(args.spellId, 15, args.destName, markOfDoomOnMe)
			self:Flash(args.spellId)
			self:ScheduleTimer(wipe, 1, list)
		end

		if count == 3 and timer then -- After the :Me check as we might be the last player
			self:CancelTimer(timer)
			timer = nil
			self:TargetMessage(args.spellId, list, "Attention", "Alarm")
		end

		if self:GetOption("custom_off_doom_marker") and self:Mythic() then
			SetRaidTarget(args.destName, count)
		end

		if not tContains(markOfDoomTargets, args.destName) then
			markOfDoomTargets[#markOfDoomTargets+1] = args.destName
		end

		updateProximity(self)
	end
end

function mod:MarkOfDoomRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(markOfDoomOnMe, args.destName)
		markOfDoomOnMe = nil
		self:CloseProximity(args.spellId)
	end

	tDeleteItem(markOfDoomTargets, args.destName)

	if self:GetOption("custom_off_doom_marker") and self:Mythic() then
		SetRaidTarget(args.destName, 0)
	end

	if #markOfDoomTargets == 0 then
		self:CloseProximity(args.spellId)
	end

	updateProximity(self)
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
		self:CDBar(args.spellId, self:Mythic() and 49 or 38)
	end
end

function mod:Inferno(args)
	if phase > 1 then
		self:CDBar(args.spellId, (self:Mythic() and 55) or (phase == 2 and 45) or 35)
	end
end

-- Mannoroth

do
	local list, timer = mod:NewTargetList(), nil
	function mod:WrathOfGuldan(args)
		list[#list + 1] = args.destName
		local count = #list
		local reverseCount = 9-count
		if count == 1 then
			timer = self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Attention", "Alarm")
		end

		if self:Me(args.destGUID) then
			wrathOfGuldanOnMe = true
			self:CancelTimer(timer)
			timer = nil
			self:Say(args.spellId, CL.count_rticon:format(self:SpellName(170963), count, reverseCount)) -- 170963 = "Wrath"
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm", CL.count_icon:format(self:SpellName(170963), count, reverseCount))
			self:Flash(args.spellId)
			self:ScheduleTimer(wipe, 1, list)
		end

		if count == 5 and timer then -- After the :Me check as we might be the last player
			self:CancelTimer(timer)
			timer = nil
			self:TargetMessage(args.spellId, list, "Attention", "Alarm")
		end

		if self:GetOption("custom_off_wrath_marker") then
			SetRaidTarget(args.destName, reverseCount)
		end

		if not tContains(wrathOfGuldanTargets, args.destName) then
			wrathOfGuldanTargets[#wrathOfGuldanTargets+1] = args.destName
		end

		updateProximity(self)
	end
end

function mod:WrathOfGuldanRemoved(args)
	if self:Me(args.destGUID) then
		wrathOfGuldanOnMe = nil
		self:CloseProximity(args.spellId)
	end

	tDeleteItem(wrathOfGuldanTargets, args.destName)

	if self:GetOption("custom_off_wrath_marker") then
		SetRaidTarget(args.destName, 0)
	end

	if #wrathOfGuldanTargets == 0 then
		self:CloseProximity(args.spellId)
	end

	updateProximity(self)
end

function mod:GrippingShadows(args)
	if self:Me(args.destGUID) then
		if not args.amount then
			self:Message(args.spellId, "Personal", "Long", CL.you:format(args.spellName))
		elseif args.amount > 5 and ((self:Tank() and args.amount % 4 == 2) or (not self:Tank() and args.amount % 2 == 0)) then
			-- Say at 6 stacks and every 2 stacks (4 stacks for tanks)
			self:Say(args.spellId, CL.count:format(args.spellName, args.amount))
			self:Message(args.spellId, "Personal", nil, CL.you:format(CL.count:format(args.spellName, args.amount)))
		end
	end
end

function mod:GlaiveThrust(args)
	self:Message(181354, "Urgent", "Warning", args.spellName)
end

function mod:MassiveBlast(args)
	self:TargetMessage(181359, args.destName, "Urgent", nil, args.spellName)
end

do
	local list, isOnMe, timer = {}, nil, nil
	function mod:MannorothsGazeCast(args)
		timer, isOnMe = nil, nil
		wipe(list)
		self:Message(181597, "Attention", "Info", CL.casting:format(args.spellName))
		self:Bar(181597, 47, args.spellName)
	end

	local function gazeSay(self, spellName)
		timer = nil
		sort(list)
		for i = 1, #list do
			local target = list[i]
			if target == isOnMe then
				local gaze = L.gaze:format(i)
				self:Say(181597, gaze)
				self:TargetMessage(181597, target, "Personal", "Alarm", gaze)
			end
			if self:GetOption("custom_off_gaze_marker") then
				SetRaidTarget(target, i)
			end
			list[i] = self:ColorName(target)
		end
		if not isOnMe then
			self:TargetMessage(181597, list, "Attention")
		end
	end

	function mod:MannorothsGaze(args)
		if self:Me(args.destGUID) then
			isOnMe = args.destName
		end

		list[#list+1] = args.destName
		if #list == 1 then
			timer = self:ScheduleTimer(gazeSay, 2, self, args.spellName) -- Large delays sometimes.
		elseif timer and #list == 3 then
			self:CancelTimer(timer)
			gazeSay(self, args.spellName)
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
	self:CDBar(181799, 52, args.spellName)
end

function mod:ShadowforceApplied(args)
	if self:Me(args.destGUID) then
		self:TargetBar(181799, 6, args.destName)
	end
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
		self:Message(181735, "Positive", "Alert", L.felseeker_message:format(args.spellName, 1, 10))
	elseif args.spellId == 182076 then
		self:Message(181735, "Positive", "Alert", L.felseeker_message:format(args.spellName, 2, 20))
	elseif args.spellId == 182040 then
		self:Message(181735, "Positive", "Alert", L.felseeker_message:format(args.spellName, 3, 30))
	end
end

function mod:FelHellstorm(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 36)
end

do
	local prev = 0
	function mod:FelDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.you:format(args.spellName))
		end
	end
end

-- Phases

function mod:P1PortalClosed(args)
	portalsClosed = portalsClosed + 1
	self:Message("stages", "Neutral", nil, L[tostring(args.spellId)], false)
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
		self:CDBar(181557, 22) -- Fel Hellstorm
		self:CDBar(181799, 26.5) -- Shadowforce, 26.5-31
		self:CDBar(181597, 37) -- Mannoroth's Gaze
		self:CDBar(181354, 40) -- Glaive Combo
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
		self:CDBar(181557, 12, 181948) -- Empowered Fel Hellstorm
		self:CDBar(181354, 23, 187347) -- Empowered Glaive Combo
		self:CDBar(181597, 27, 182006) -- Empowered Mannoroth's Gaze
		self:CDBar(181799, 42, 182084) -- Empowered Shadowforce
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

function mod:DoomLordDies()
	self:StopBar(181099) -- Mark of Doom
end

