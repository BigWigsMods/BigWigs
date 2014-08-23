
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Kargath Bladefist", 994, 1128)
if not mod then return end
mod:RegisterEnableMob(78714)
--mod.engageId = 1721

--------------------------------------------------------------------------------
-- Locals
--

local hurled = nil

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
		{159113, "TANK_HEALER"}, 159250, {158986, "ICON", "FLASH"}, 159947, {159413, "FLASH"}, {159311, "FLASH"}, 160521, "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_START_START", "Impale", 159113)
	self:Log("SPELL_AURA_APPLIED", "BladeDance", 159250)
	self:Log("SPELL_START_START", "BerserkerRush", 158986)
	self:Log("SPELL_AURA_REMOVED", "BerserkerRushRemoved", 158986)
	self:Log("SPELL_START_START", "ChainHurl", 159947)
	self:Log("SPELL_AURA_APPLIED", "ChainHurlApplied", 159947)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameJetDamage", 159311)
	self:Log("SPELL_PERIODIC_MISSED", "FlameJetDamage", 159311)
	self:Log("SPELL_PERIODIC_DAMAGE", "MaulingBrewDamage", 159413)
	self:Log("SPELL_PERIODIC_MISSED", "MaulingBrewDamage", 159413)
	self:Log("SPELL_CAST_START", "VileBreath", 160521)

	self:Death("Win", 79459)
end

function mod:OnEngage()
	self:CDBar(159113, 37) -- Impale
	--self:CDBar(158986, 48) -- Berserker Rush
	self:CDBar(159947, 90) -- Chain Hurl
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Impale(args)
	local target = UnitName("boss1target")
	self:TargetMessage(args.spellId, target, "Important", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 8.8) -- cast+channel
	self:ScheduleTimer("CDBar", 8.8, args.spellId, 28.2) -- 37.4 cd with chain hurl/berserker rush delaying it
end

function mod:BladeDance(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 10, "Blade Dancing")
	--self:CDBar(args.spellId, 20)
end

function mod:BerserkerRush(args)
	local target = UnitName("boss1target")
	self:PrimaryIcon(args.spellId, target)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
	self:TargetMessage(args.spellId, target, "Important", "Alarm", nil, nil, true)
	-- cd is 45-70 :\
end

function mod:BerserkerRushRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local hurlList, scheduled = mod:NewTargetList(), nil

	local function printTargets(spellId)
		mod:TargetMessage(spellId, hurlList, "Attention")
		scheduled = nil
	end

	function mod:ChainHurl(args)
		self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(args.spellName))
		self:Bar(args.spellId, 3.4)
		hurled = nil
	end

	function mod:ChainHurlApplied(args)
		hurlList[#hurlList+1] = args.destName
		if self:Me(args.destGUID) then
			-- you get a debuff for getting thrown into the stands...
			-- should find out what it is maybe mute warnings while you have it
			hurled = true
		end
		if not scheduled then
			self:Bar(args.spellId, 103)
			scheduled = self:ScheduleTimer(printTargets, 0.1, args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:MaulingBrewDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:FlameJetDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

function mod:VileBreath(args)
	if hurled then
		self:Message(args.spellId, "Urgent", "Alarm")
	end
end

