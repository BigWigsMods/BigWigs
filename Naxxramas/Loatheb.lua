----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Loatheb", "$Revision$")
if not mod then return end
mod.zoneName = "Naxxramas"
mod.enabletrigger = 16011
mod.guid = 16011
mod.toggleOptions = {55593, 29865, 29204, 29234, "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local doomTime = 30
local sporeCount = 1
local doomCount = 1
local sporeTime = 16

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Loatheb", "enUS", true)
if L then
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
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Loatheb")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Aura", 55593)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Deathbloom", 29865, 55053)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Doom", 29204, 55052)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spore", 29234)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	doomTime = 30
	sporeCount = 1
	doomCount = 1
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterMessage("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Aura(_, spellId, _, _, spellName)
	self:IfMessage(L["aura_message"], "Important", spellId)
	self:Bar(spellName, 17, spellId)
	self:DelayedMessage(14, L["aura_warning"], "Attention")
end

function mod:Deathbloom(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 30, spellId)
	self:DelayedMessage(15, L["deathbloom_warning"], "Attention")
end

function mod:Doom(_, spellId)
	self:IfMessage(L["doomwarn"]:format(doomCount, doomTime), "Urgent", spellId)
	doomCount = doomCount + 1
	self:Bar(L["doombar"]:format(doomCount), doomTime, spellId)
	self:DelayedMessage(doomTime - 5, L["doomwarn5sec"]:format(doomCount), "Urgent")
end

function mod:Spore()
	--spellId is a question mark, so we use our own: 38755
	self:IfMessage(L["sporewarn"]:format(sporeCount), "Important", 38755)
	sporeCount = sporeCount + 1
	self:Bar(L["sporebar"]:format(sporeCount), sporeTime, 38755)
end

local function swapTime()
	doomTime = 15
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		doomTime = 30
		sporeCount = 1
		doomCount = 1
		sporeTime = GetRaidDifficulty() == 1 and 36 or 16
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		if self:GetOption(29204) then
			self:Bar(L["doomtimerbar"], 300, 29204)
			self:DelayedMessage(240, L["doomtimerwarn"]:format(60), "Attention")
			self:DelayedMessage(270, L["doomtimerwarn"]:format(30), "Attention")
			self:DelayedMessage(290, L["doomtimerwarn"]:format(10), "Urgent")
			self:DelayedMessage(295, L["doomtimerwarn"]:format(5), "Important")
			self:DelayedMessage(300, L["doomtimerwarnnow"], "Important")

			self:ScheduleEvent("BWLoathebDoomTimer", swapTime, 300)

			self:Message(L["startwarn"], "Attention")
			self:Bar(L["doombar"]:format(doomCount), 120, 29204)
			self:DelayedMessage(115, L["doomwarn5sec"]:format(doomCount), "Urgent")
		end
	end
end

