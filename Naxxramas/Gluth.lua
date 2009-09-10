----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Gluth", "Naxxramas")
if not mod then return end
mod.enabletrigger = 15932
mod.toggleOptions = {28371, 54426, "berserk", "bosskill"}

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
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Frenzy", 28371, 54427)
	self:AddCombatListener("SPELL_DAMAGE", "Decimate", 28375, 54426)
	self:AddCombatListener("SPELL_MISSED", "Decimate", 28375, 54426)
	self:AddDeathListener("Win", 15932)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	enrageTime = GetRaidDifficulty() == 1 and 480 or 420
	if self:GetOption(54426) then
		self:Message(L["startwarn"], "Attention")
		self:Bar(L["decimatebartext"], 105, 54426)
		self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
	end
	if self.db.profile.berserk then
		self:Berserk(enrageTime)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Frenzy(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

local last = 0
function mod:Decimate(_, spellId, _, _, spellName)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		self:IfMessage(spellName, "Attention", spellId, "Alert")
		self:Bar(L["decimatebartext"], 105, spellId)
		self:DelayedMessage(100, L["decimatesoonwarn"], "Urgent")
	end
end

