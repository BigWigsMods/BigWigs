
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Humongris", -641, 1770)
if not mod then return end
mod:RegisterEnableMob(108879)
mod.otherMenu = -619
mod.worldBoss = 108879

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{216428, "SAY"}, -- Fire Boom
		216430, -- Earthshake Stomp
		{216432, "SAY"}, -- Ice Fist
		216467, -- Make the Snow
		{216817, "SAY"}, -- You Go Bang!
		216476, -- Blizzard
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FireBoom", 216428)
	self:Log("SPELL_CAST_START", "EarthshakeStomp", 216430)
	self:Log("SPELL_CAST_START", "IceFist", 216432)
	self:Log("SPELL_CAST_SUCCESS", "MakeTheSnow", 216467)
	self:Log("SPELL_CAST_SUCCESS", "YouGoBang", 216817)
	self:Log("SPELL_AURA_APPLIED", "YouGoBangApplied", 216817)

	self:Log("SPELL_AURA_APPLIED", "BlizzardDamage", 216476)
	self:Log("SPELL_PERIODIC_DAMAGE", "BlizzardDamage", 216476)
	self:Log("SPELL_PERIODIC_MISSED", "BlizzardDamage", 216476)

	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(216430, 13) -- Earthshake Stomp
	self:CDBar(216432, 18) -- Ice Fist
	self:CDBar(216817, 20) -- You Go Bang!
	self:CDBar(216467, 26) -- Make the Snow
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function printTarget(self, player, guid)
		self:TargetMessage(216428, player, "Attention", "Alarm")
		if self:Me(guid) then
			self:Say(216428)
		end
	end
	function mod:FireBoom(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:EarthshakeStomp(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 34)
end

do
	local function printTarget(self, player, guid)
		self:TargetMessage(216432, player, "Important", "Alert")
		if self:Me(guid) then
			self:Say(216432)
		end
	end
	function mod:IceFist(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
		self:CDBar(args.spellId, 30)
	end
end

function mod:MakeTheSnow(args)
	self:Message(args.spellId, "Positive", "Long")
	self:CDBar(args.spellId, 34)
end

function mod:YouGoBang(args)
	self:CDBar(args.spellId, 24)
end

function mod:YouGoBangApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 12, args.destName, self:SpellName(47496)) -- 47496 = "Explode"
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

do
	local prev = 0
	function mod:BlizzardDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1917 then
		self:Win()
	end
end
