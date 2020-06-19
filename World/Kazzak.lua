
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Kazzak", -1419)
if not mod then return end
mod:RegisterEnableMob(12397)
mod.otherMenu = -1419
mod.worldBoss = 12397

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Lord Kazzak"
	
	L.supreme = "Supreme Alert"
	L.supreme_desc = "Warn for Supreme Mode"
	L.engage_trigger = "For the Legion! For Kil'Jaeden!"
	L.engage_message = "Lord Kazzak engaged, 3mins until Supreme!"
	L.supreme1min = "Supreme mode in 1 minute!"
	L.supreme30sec = "Supreme mode in 30 seconds!"
	L.supreme10sec = "Supreme mode in 10 seconds!"
	L.bartext = "Supreme mode"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"supreme",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	--self:ScheduleTimer("CheckForEngage", 1)
	--self:RegisterEvent("BOSS_KILL")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("Win", 12397)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--function mod:BOSS_KILL(_, id)
--	if id == 0000 then
--		self:Win()
--	end
--end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.engage_trigger, nil, true) then
		self:Message2("supreme", "red", L.engage_message, false)
		self:DelayedMessage("supreme", 120, "yellow", L.supreme1min)
		self:DelayedMessage("supreme", 150, "orange", L.supreme30sec)
		self:DelayedMessage("supreme", 170, "red", L.supreme10sec)
		self:Bar("supreme", 180, L.bartext, "Spell_Shadow_ShadowWordPain")
	end
end
