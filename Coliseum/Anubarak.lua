--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = "Anub'arak"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = boss
mod.zoneName = "Trial of the Crusader"
mod.enabletrigger = 34564
mod.guid = 34564
mod.toggleOptions = {66118, 67574, "icon", "burrow", "berserk", "bosskill"}
mod.consoleCmd = "Anubarak"

--------------------------------------------------------------------------------
-- Locals
--

local db

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
if L then
	L.engage_message = "Anub'arak engaged, burrow in 80sec!"
	L.engage_trigger = "This place will serve as your tomb!"

	L.unburrow_trigger = "emerges from the ground"
	L.burrow_trigger = "burrows into the ground"
	L.burrow = "Burrow"
	L.burrow_desc = "Show a timer for Anub'Arak's Burrow ability"
	L.burrow_cooldown = "Next Burrow"
	L.burrow_soon = "Burrow soon"

	L.icon = "Place icon"
	L.icon_desc = "Place a raid target icon on the person targetted by Anub'arak during his burrow phase. (requires promoted or higher)"

	L.chase = "Pursue"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Anub'arak")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	db = self.db.profile
	self:AddCombatListener("SPELL_CAST_START", "Swarm", 66118)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Pursue", 67574)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Swarm(event, player, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

function mod:Pursue(event, player, spellId)
	self:TargetMessage(L["chase"], player, "Personal", spellId)
	self:Whisper(player, L["chase"])
	self:PrimaryIcon(player, "icon")
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["engage_trigger"]) then
		if db.burrow then
			self:IfMessage(L["engage_message"], "Attention", 65919)
			self:Bar(L["burrow_cooldown"], 80, 65919)
		end
		if db.berserk then
			self:Enrage(570, true, true)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if db.burrow and msg:find(L["unburrow_trigger"]) then
		self:Bar(L["burrow_cooldown"], 80, 65919)
		self:DelayedMessage(70, L["burrow_soon"], "Attention")
	end
	if db.burrow and msg:find(L["burrow_trigger"]) then
		self:Bar(L["burrow"], 65, 65919)
	end
end

