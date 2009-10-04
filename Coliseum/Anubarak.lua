--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Anub'arak", "Trial of the Crusader")
if not mod then return end
mod.toggleOptions = {66012, "burrow", {67574, "WHISPER", "ICON", "FLASHSHAKE"}, {68510, "FLASHSHAKE"}, 66118, "berserk", "bosskill"}
--[[mod.optionHeaders = {
	[66012] = "normal",
	--[the shadow strike thing from the adds] = "hard",
	berserk = "general",
}]]

--------------------------------------------------------------------------------
-- Locals
--

local difficulty = nil
local pName = UnitName("player")
local phase2 = nil
local burrowMessage = nil

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

	L.freeze_bar = "~Next Freezing Slash"
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

function mod:OnRegister()
	self:RegisterEnableMob(34564)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Swarm", 66118, 68646, 68647)
	self:Log("SPELL_CAST_SUCCESS", "ColdCooldown", 68510, 68509)
	self:Log("SPELL_AURA_APPLIED", "ColdDebuff", 68510, 68509)
	self:Log("SPELL_AURA_APPLIED", "Pursue", 67574)
	
	self:Log("SPELL_CAST_SUCCESS", "FreezeCooldown", 66012)
	self:Log("SPELL_MISSED", "FreezeCooldown", 66012)
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34564)
	
	difficulty = GetRaidDifficulty()
end

local function nextwave() mod:Bar("burrow", L["nerubian_burrower"], 45, 66333) end
function mod:OnEngage()
	self:Message("burrow", L["engage_message"], "Attention", 65919)
	self:Bar("burrow", L["burrow_cooldown"], 80, 65919)
	self:Bar("burrow", L["nerubian_burrower"], 10, 66333)
	self:ScheduleEvent("BWnextwave", nextwave, 10)
	self:Berserk(570, true)
	phase2 = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FreezeCooldown(player, spellId)
	self:Bar(66012, L["freeze_bar"], 20, spellId)
end

function mod:ColdDebuff(player, spellId, _, _, spellName)
	if player ~= pName or not phase2 then return end
	self:LocalMessage(68510, spellName, "Personal", spellId, "Alarm")
	self:FlashShake(68510)
end

function mod:ColdCooldown(_, spellId)
	if not phase2 then return end
	self:Bar(68510, L["pcold_bar"], 15, spellId)
end

function mod:Swarm(player, spellId, _, _, spellName)
	self:Message(66118, spellName, "Important", spellId)
	phase2 = true
	self:SendMessage("BigWigs_StopBar", self, L["burrow_cooldown"])
	self:CancelScheduledEvent(burrowMessage)
	if difficulty < 3 then -- Normal modes
		self:SendMessage("BigWigs_StopBar", self, L["nerubian_burrower"])
		self:CancelScheduledEvent("BWnextwave")
	end
end

function mod:Pursue(player, spellId)
	self:TargetMessage(67574, L["chase"], player, "Personal", spellId)
	if player == pName then self:FlashShake(67574) end
	self:Whisper(67574, player, L["chase"])
	self:PrimaryIcon(67574, player, "icon")
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg:find(L["unburrow_trigger"]) then
		self:Bar("burrow", L["burrow_cooldown"], 80, 65919)
		burrowMessage = self:DelayedMessage("burrow", 70, L["burrow_soon"], "Attention")
		self:Bar("burrow", L["nerubian_burrower"], 6, 66333)
		self:ScheduleEvent("BWnextwave", nextwave, 6)
	elseif msg:find(L["burrow_trigger"]) then
		self:Bar("burrow", L["burrow"], 65, 65919)
	end
end

