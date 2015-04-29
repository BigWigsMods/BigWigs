
-- Notes --
-- (E)/Fel Hellstorm damage ids
-- Glaive combo is hidden
-- Fel streak is instant?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Mannoroth", 1026, 1395)
if not mod then return end
mod:RegisterEnableMob(91305, 94362, 91409, 91349, 91369) -- Fel Iron Summoner, ...
mod.engageId = 1795

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{181099, "PROXIMITY", "FLASH", "SAY"}, -- Mark of Doom
		{181597, "ICON", "SAY"}, -- Mannoroth's Gaze
		181799, -- Shadowforce
		181948, -- Empowered Fel Hellstorm
		{181275, "SAY", "ICON", "FLASH"}, -- Curse of the Legion
		{181119, "TANK"}, -- Doom Spike
		181126, -- Shadow Bolt Volley
		181735, -- Felseeker
		{183377, "TANK"}, -- Glaive Thrust
		{181359, "TANK"}, -- Massive Blast
		"berserk",
	} -- XXX separate by stages
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MarkOfDoom", 181099)
	self:Log("SPELL_AURA_REMOVED", "MarkOfDoomRemoved", 181099)
	self:Log("SPELL_CAST_START", "MannorothsGazeCast", 181597, 182006)
	self:Log("SPELL_AURA_APPLIED", "MannorothsGaze", 181597, 182006)
	self:Log("SPELL_AURA_REMOVED", "MannorothsGazeRemoved", 181597, 182006)
	self:Log("SPELL_CAST_START", "Shadowforce", 181799, 182084)
	self:Log("SPELL_AURA_APPLIED", "CurseOfTheLegion", 181275)
	self:Log("SPELL_AURA_REMOVED", "CurseOfTheLegionRemoved", 181275)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomSpike", 181119)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 181126)
	self:Log("SPELL_CAST_START", "Felseeker", 181738, 181792, 181793)
	self:Log("SPELL_CAST_START", "GlaiveThrust", 183377, 185831)
	self:Log("SPELL_AURA_APPLIED", "MassiveBlast", 181359, 185821)


	--self:Log("SPELL_AURA_APPLIED", "EmpoweredFelHellstormDamage", 181948)
	--self:Log("SPELL_PERIODIC_DAMAGE", "EmpoweredFelHellstormDamage", 181948)
	--self:Log("SPELL_PERIODIC_MISSED", "EmpoweredFelHellstormDamage", 181948)
end

function mod:OnEngage()
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
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
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

function mod:MannorothsGaze(args)
	self:TargetMessage(181597, args.destName, "Urgent", "Alarm", args.spellName)
	self:PrimaryIcon(181597, args.destName)
	if self:Me(args.destGUID) then
		self:Say(181597, args.spellName)
	end
end

function mod:MannorothsGazeRemoved(args)
	self:PrimaryIcon(181597)
end

function mod:Shadowforce(args)
	self:Message(181799, "Important", "Long", CL.casting:format(args.spellName))
	self:Bar(181799, 8, args.spellName)
end

function mod:CurseOfTheLegion(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm")
	self:Bar(args.spellId, 20, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:CurseOfTheLegionRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(args.spellId)
end

function mod:DoomSpike(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Positive", nil, CL.casting:format(args.spellName))
end

function mod:Felseeker(args) -- XXX add empowered abilities which atm are all 300yds (wrong)
	if args.spellId == 181738 then
		self:Message(181735, "Positive", "Alert", ("%s (%d) %d yards"):format(args.spellName, 1, 35))
	elseif args.spellId == 181792 then
		self:Message(181735, "Positive", "Alert", ("%s (%d) %d yards"):format(args.spellName, 2, 20))
	else
		self:Message(181735, "Positive", "Alert", ("%s (%d) %d yards"):format(args.spellName, 3, 10))
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
	function mod:EmpoweredFelHellstormDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

