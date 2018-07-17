
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Drugon the Frostblood", -650, 1789)
if not mod then return end
mod:RegisterEnableMob(110378)
mod.otherMenu = -619
mod.worldBoss = 110378

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		219803, -- Ice Hurl
		219493, -- Snow Crash
		{219542, "FLASH"}, -- Avalanche
		{219602, "ICON", "SAY"}, -- Snow Plow
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "IceHurl", 219803)
	self:Log("SPELL_CAST_START", "SnowCrash", 219493)
	self:Log("SPELL_CAST_START", "Avalanche", 219542)
	self:Log("SPELL_CAST_START", "SnowPlow", 219601)
	self:Log("SPELL_AURA_APPLIED", "SnowPlowApplied", 219602)
	self:Log("SPELL_AURA_REMOVED", "SnowPlowRemoved", 219602)

	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(219493, 19) -- Snow Crash
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function printTarget(self, player)
		self:TargetMessage(219803, player, "Positive")
	end
	function mod:IceHurl(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:SnowCrash(args)
	self:Message(args.spellId, "Important", self:Melee() and "Alert")
	self:CDBar(args.spellId, 19)
end

function mod:Avalanche(args)
	self:Message(args.spellId, "Attention", "Warning")
	self:Flash(args.spellId)
end

function mod:SnowPlow(args)
	self:Message(219602, "Urgent", "Long", CL.incoming:format(args.spellName))
end

function mod:SnowPlowApplied(args)
	if self:MobId(args.destGUID) ~= 110378 then -- Skip the boss
		self:TargetMessage(args.spellId, args.destName, "Positive", "Alarm")
		self:PrimaryIcon(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:SnowPlowRemoved(args)
	if self:MobId(args.destGUID) ~= 110378 then -- Skip the boss
		self:PrimaryIcon(args.spellId)
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1949 then
		self:Win()
	end
end
