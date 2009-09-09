--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Anub'arak", "Trial of the Crusader")
if not mod then return end
mod.enabletrigger = 34564
mod.guid = 34564
mod.toggleOptions = {66118, 67574, "icon", "burrow", 68510, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local pName = UnitName("player")
local phase2 = nil

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

	L.nerubian_burrower = "Nerubian Burrower"

	L.pcold_bar = "~Next Penetrating Cold"

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
	self:AddCombatListener("SPELL_CAST_START", "Swarm", 66118, 68646, 68647)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ColdCooldown", 68510, 68509)
	self:AddCombatListener("SPELL_AURA_APPLIED", "ColdDebuff", 68510, 68509)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Pursue", 67574)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	phase2 = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ColdDebuff(player, spellId, _, _, spellName)
	if player ~= pName or not phase2 then return end
	self:LocalMessage(spellName, "Personal", spellId, "Alarm")
end

function mod:ColdCooldown(_, spellId)
	if not phase2 then return end
	self:Bar(L["pcold_bar"], 15, spellId)
end

function mod:Swarm(player, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	phase2 = true
end

function mod:Pursue(player, spellId)
	self:TargetMessage(L["chase"], player, "Personal", spellId)
	self:Whisper(player, L["chase"])
	self:PrimaryIcon(player, "icon")
end

local function nextwave()
	mod:Bar(L["nerubian_burrower"], 45, 66333)
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["engage_trigger"]) then
		if self.db.profile.burrow then
			self:IfMessage(L["engage_message"], "Attention", 65919)
			self:Bar(L["burrow_cooldown"], 80, 65919)
			self:Bar(L["nerubian_burrower"], 10, 66333)
			self:ScheduleEvent("BWnextwave", nextwave, 10)
		end
		if self.db.profile.berserk then
			self:Berserk(570)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if self.db.profile.burrow and msg:find(L["unburrow_trigger"]) then
		self:Bar(L["burrow_cooldown"], 80, 65919)
		self:DelayedMessage(70, L["burrow_soon"], "Attention")
		self:Bar(L["nerubian_burrower"], 10, 66333)
		self:ScheduleEvent("BWnextwave", nextwave, 10)
	end
	if self.db.profile.burrow and msg:find(L["burrow_trigger"]) then
		self:Bar(L["burrow"], 65, 65919)
	end
end

