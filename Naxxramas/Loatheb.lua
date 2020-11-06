--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Loatheb", 533)
if not mod then return end
mod:RegisterEnableMob(16011)
mod:SetAllowWin(true)
mod.engageId = 1115
mod.toggleOptions = {55593, 29865, 29204, 29234, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local doomTime = 30
local sporeCount = 1
local doomCount = 1
local sporeTime = 16

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Loatheb"

	L.startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!"

	L.aura_message = "Necrotic Aura - Duration 17 sec!"
	L.aura_warning = "Aura gone in 3 sec!"

	L.deathbloom_warning = "Bloom in 5 sec!"

	L.doombar = "Inevitable Doom %d"
	L.doomwarn = "Doom %d! %d sec to next!"
	L.doomwarn5sec = "Doom %d in 5 sec!"
	L.doomtimerbar = "Doom every 15sec"
	L.doomtimerwarn = "Doom timer changes in %s sec!"
	L.doomtimerwarnnow = "Doom now happens every 15 sec!"

	L.sporewarn = "Spore %d!"
	L.sporebar = "Summon Spore %d"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Aura", 55593)
	self:Log("SPELL_CAST_SUCCESS", "Deathbloom", 29865, 55053)
	self:Log("SPELL_CAST_SUCCESS", "Doom", 29204, 55052)
	self:Log("SPELL_CAST_SUCCESS", "Spore", 29234)
	self:Death("Win", 16011)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

local function swapTime() doomTime = 15 end
function mod:OnEngage(diff)
	doomTime = 30
	sporeCount = 1
	doomCount = 1
	sporeTime = diff == 3 and 36 or 16
	self:Bar(29204, L["doomtimerbar"], 300, 29204)
	self:DelayedMessage(29204, 240, L["doomtimerwarn"]:format(60), "Attention")
	self:DelayedMessage(29204, 270, L["doomtimerwarn"]:format(30), "Attention")
	self:DelayedMessage(29204, 290, L["doomtimerwarn"]:format(10), "Urgent")
	self:DelayedMessage(29204, 295, L["doomtimerwarn"]:format(5), "Important")
	self:DelayedMessage(29204, 300, L["doomtimerwarnnow"], "Important")

	self:ScheduleTimer(swapTime, 300)
	self:Message(29204, L["startwarn"], "Attention")
	self:Bar(29204, L["doombar"]:format(doomCount), 120, 29204)
	self:DelayedMessage(29204, 115, L["doomwarn5sec"]:format(doomCount), "Urgent")

	self:Berserk(720, true)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Aura(_, spellId, _, _, spellName)
	self:Message(55593, L["aura_message"], "Important", spellId)
	self:Bar(55593, spellName, 17, spellId)
	self:DelayedMessage(55593, 14, L["aura_warning"], "Attention")
end

function mod:Deathbloom(_, spellId, _, _, spellName)
	self:Message(29865, spellName, "Important", spellId)
	self:Bar(29865, spellName, 30, spellId)
	self:DelayedMessage(29865, 15, L["deathbloom_warning"], "Attention")
end

function mod:Doom(_, spellId)
	self:Message(29204, L["doomwarn"]:format(doomCount, doomTime), "Urgent", spellId)
	doomCount = doomCount + 1
	self:Bar(29204, L["doombar"]:format(doomCount), doomTime, spellId)
	self:DelayedMessage(29204, doomTime - 5, L["doomwarn5sec"]:format(doomCount), "Urgent")
end

function mod:Spore()
	--spellId is a question mark, so we use our own: 38755
	self:Message(29234, L["sporewarn"]:format(sporeCount), "Important", 38755)
	sporeCount = sporeCount + 1
	self:Bar(29234, L["sporebar"]:format(sporeCount), sporeTime, 38755)
end

