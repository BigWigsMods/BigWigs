
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Supreme Lord Kazzak", 945, 1452)
if not mod then return end
mod:RegisterEnableMob(94015)
mod.otherMenu = 962
mod.worldBoss = 94015
--BOSS_KILL#1801#Supreme Lord Kazzak

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		187664, -- Fel Breath
		187471, -- Supreme Doom
		{187668, "SAY", "PROXIMITY"}, -- Mark of Kazzak
		187702, -- Twisted Reflection
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FelBreath", 187664)
	self:Log("SPELL_AURA_REFRESH", "FelBreath", 187664)
	self:Log("SPELL_AURA_REMOVED", "FelBreathRemoved", 187664)
	self:Log("SPELL_AURA_APPLIED", "SupremeDoom", 187471)
	self:Log("SPELL_AURA_APPLIED", "MarkOfKazzak", 187668)
	self:Log("SPELL_AURA_REMOVED", "MarkOfKazzakRemoved", 187668)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CDBar(187471, 17) -- Supreme Doom
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FelBreath(args)
	if self:Tank(args.destName) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", self:Tank() and "Alert")
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:FelBreathRemoved(args)
	if self:Tank(args.destName) then
		self:StopBar(args.spellName, args.destName)
	end
end

do
	local list = mod:NewTargetList()
	function mod:SupremeDoom(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Info", nil, nil, self:Healer())
			self:CDBar(args.spellId, 51)
		end
	end
end

function mod:MarkOfKazzak(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:TargetBar(args.spellId, 15, args.destName)
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 8)
	end
end

function mod:MarkOfKazzakRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
		self:CloseProximity(args.spellId)
	end
end

function mod:RAID_BOSS_EMOTE(event, msg)
	if msg:find("187702", nil, true) then -- hidden cast, has unit event
		self:Message(187702, "Important", "Long")
	end
end

function mod:BOSS_KILL(event, id)
	if id == 1801 then
		self:Win()
	end
end

