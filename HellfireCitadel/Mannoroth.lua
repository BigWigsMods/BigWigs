
-- Notes --
-- Glaive combo is hidden
-- Fel streak is instant?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Mannoroth", 1026, 1395)
if not mod then return end
mod:RegisterEnableMob(91305, 94362, 91409, 91349, 91369) -- Fel Iron Summoner, 91349 on beta
mod.engageId = 1795

--------------------------------------------------------------------------------
-- Locals
--

local portalsClosed = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.doomLord = "Doom Lord portal closed!"
	L.imp = "Imp portal closed!"
	L.infernal = "Infernal portal closed!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{181099, "PROXIMITY", "FLASH", "SAY"}, -- Mark of Doom
		{181597, "SAY"}, -- Mannoroth's Gaze
		181799, -- Shadowforce
		181566, -- Fel Hellstorm
		{181275, "SAY", "ICON", "FLASH"}, -- Curse of the Legion
		{181119, "TANK"}, -- Doom Spike
		181126, -- Shadow Bolt Volley
		181735, -- Felseeker
		{183377, "TANK"}, -- Glaive Thrust
		{181359, "TANK"}, -- Massive Blast
		"stages",
		"berserk",
	} -- XXX separate by stages
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MarkOfDoom", 181099)
	self:Log("SPELL_AURA_REMOVED", "MarkOfDoomRemoved", 181099)
	self:Log("SPELL_CAST_START", "MannorothsGazeCast", 181597, 182006)
	self:Log("SPELL_AURA_APPLIED", "MannorothsGaze", 181597, 182006)
	self:Log("SPELL_CAST_START", "Shadowforce", 181799, 182084)
	self:Log("SPELL_AURA_APPLIED", "CurseOfTheLegion", 181275)
	self:Log("SPELL_AURA_REMOVED", "CurseOfTheLegionRemoved", 181275)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomSpike", 181119)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 181126)
	self:Log("SPELL_CAST_START", "Felseeker", 181793, 181792, 181738)
	self:Log("SPELL_CAST_START", "EmpoweredFelseeker", 182077, 182076, 182040)
	self:Log("SPELL_CAST_START", "GlaiveThrust", 183377, 185831)
	self:Log("SPELL_AURA_APPLIED", "MassiveBlast", 181359, 185821)

	self:Log("SPELL_DAMAGE", "FelHellstormDamage", 181566)
	self:Log("SPELL_MISSED", "FelHellstormDamage", 181566)

	self:Log("SPELL_AURA_REMOVED", "P1PortalClosed", 185147, 185175, 182212) -- Doom Lords, Imps, Infernals
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	portalsClosed = 0
	self:Message("berserk", "Neutral", nil, "Mannoroth (beta) engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:MarkOfDoom(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
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

function mod:MannorothsGazeCast(args)
	self:Message(181597, "Attention", "Info", CL.casting:format(args.spellName))
end

do
	local list = mod:NewTargetList()
	function mod:MannorothsGaze(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, 181597, list, "Attention", "Alarm", args.spellName)
		end
		if self:Me(args.destGUID) then
			self:Say(181597, args.spellName)
		end
	end
end

function mod:Shadowforce(args)
	self:Message(181799, "Important", "Long", CL.casting:format(args.spellName))
	self:Bar(181799, 8, args.spellName)
end

function mod:CurseOfTheLegion(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm")
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
	self:Message(args.spellId, "Important", "Warning", CL.spawning:format("Doom Lord"))
end

function mod:DoomSpike(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Positive", nil, CL.casting:format(args.spellName))
end

function mod:Felseeker(args)
	if args.spellId == 181738 then
		self:Message(181735, "Positive", "Alert", ("%s (%d) %d yards"):format(args.spellName, 3, 35))
	elseif args.spellId == 181792 then
		self:Message(181735, "Positive", "Alert", ("%s (%d) %d yards"):format(args.spellName, 2, 20))
	else
		self:Message(181735, "Positive", "Alert", ("%s (%d) %d yards"):format(args.spellName, 1, 10))
	end
end

function mod:EmpoweredFelseeker(args)
	if args.spellId == 182077 then
		self:Message(181735, "Positive", "Alert", CL.count:format(args.spellName, 1))
	elseif args.spellId == 182076 then
		self:Message(181735, "Positive", "Alert", CL.count:format(args.spellName, 2))
	else
		self:Message(181735, "Positive", "Alert", CL.count:format(args.spellName, 3))
	end
end

function mod:GlaiveThrust(args)
	self:Message(183377, "Attention", "Warning", args.spellName)
end

function mod:MassiveBlast(args)
	self:TargetMessage(181359, args.destName, "Attention", nil, args.spellName)
end

do
	local prev = 0
	function mod:FelHellstormDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

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
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 182263 then -- P3 Transform
		self:Message("stages", "Neutral", "Info", CL.stage:format(3), false)
	elseif spellId == 185690 then -- P4 Transform
		self:Message("stages", "Neutral", "Info", CL.stage:format(4), false)
	end
end

