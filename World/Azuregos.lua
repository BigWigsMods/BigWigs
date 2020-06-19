
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Azuregos", -1447)
if not mod then return end
mod:RegisterEnableMob(6109)
mod.otherMenu = -1447
mod.worldBoss = 6109

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
        L.bossName = "Azuregos"
	
	L.teleport = "Teleport Alert"
	L.teleport_desc = "Warn for teleport."
	L.teleport_trigger = "Come, little ones"
	L.teleport_message = "Teleport!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		22067, -- Reflection
		"teleport",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	--self:ScheduleTimer("CheckForEngage", 1)
	--self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_AURA_APPLIED", "Reflection", self:SpellName(22067))
	self:Log("SPELL_AURA_REMOVED", "ReflectionRemoved", self:SpellName(22067))

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("Win", 6109)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--function mod:BOSS_KILL(_, id)
--	if id == 0000 then
--		self:Win()
--	end
--end

function mod:Reflection(args)
	self:Message2(22067, "yellow")
	self:PlaySound(22067, "long")
	self:Bar(22067, 10)
end

function mod:ReflectionRemoved(args)
	self:Message2(22067, "yellow", CL.over:format(args.spellName))
	self:PlaySound(22067, "info")
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.teleport_trigger, nil, true) then
		self:Message2("teleport", "red", L.teleport_message, false)
	end
end
