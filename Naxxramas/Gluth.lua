----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Gluth", "Naxxramas")
if not mod then return end
mod:RegisterEnableMob(15932)
mod:Toggle(28371, "MESSAGE")
mod:Toggle(54426, "MESSAGE", "BAR")
mod:Toggle("berserk")
mod:Toggle("bosskill")

------------------------------
--      Are you local?      --
------------------------------

local enrageTime = 420

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Gluth", "enUS", true)
if L then
	L.startwarn = "Gluth engaged, ~105 sec to decimate!"

	L.decimatesoonwarn = "Decimate Soon!"
	L.decimatebartext = "~Decimate Zombies"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Gluth")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Frenzy", 28371, 54427)
	self:Log("SPELL_DAMAGE", "Decimate", 28375, 54426)
	self:Log("SPELL_MISSED", "Decimate", 28375, 54426)
	self:Death("Win", 15932)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	enrageTime = GetRaidDifficulty() == 1 and 480 or 420
	self:Message(54426, L["startwarn"], "Attention")
	self:Bar(54426, L["decimatebartext"], 105, 54426)
	self:DelayedMessage(54426, 100, L["decimatesoonwarn"], "Urgent")
	self:Berserk(enrageTime)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Frenzy(_, spellId, _, _, spellName)
	self:IfMessage(28371, spellName, "Important", spellId)
end

local last = 0
function mod:Decimate(_, spellId, _, _, spellName)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		self:IfMessage(54426, spellName, "Attention", spellId, "Alert")
		self:Bar(54426, L["decimatebartext"], 105, spellId)
		self:DelayedMessage(54426, 100, L["decimatesoonwarn"], "Urgent")
	end
end

